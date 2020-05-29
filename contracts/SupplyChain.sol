pragma solidity ^0.5.16;
import './Users.sol';
import './SupplierRole.sol';
import './ManufacturerRole.sol';
import './DistributorRole.sol';
import './RetailerRole.sol';

/*SupplyChain contract stores the core functionality and details 
about items being produced, packed and shipped along a SupplyChain. The contract
inherits behaviour from Supplier Role, ManufactureRole, DistrbutorRole and RetailerRole
contracts based on Open Zeppelin's RBAC contracts. */
contract SupplyChain is SupplierRole, ManufacturerRole, DistributorRole, RetailerRole{

  // Define the owner of this contract.
  address owner;

  // Owner of this contract is the address of the deployer of SCs to the network.
  constructor() public {
    owner = msg.sender;
  }

  // Define an enum of the various states a product can undergo in the supply chain process.
  enum State {
    Produced,
    Packed,
    Shipped,
    Received
  }
  
  // Define and set the default state of an item added to this contract.
  State constant defaultState = State.Produced;

  // Define a struct that contains product details, this can be extended to include
  // data collected by different Roles in the system, e.g. machine logs.
  struct ProductDetails { 
    uint serial;
    uint weight;
    uint quantity;
    string color;
  }

  // Define a struct that defines an item. Include a unique identifier - UPC as well 
  // as addresses of the accounts that can have access to this item to perform  manufacturing functions.
  struct Item {
    uint upc; //Universal Product Code (UPC)
    uint batch;
    uint price;
    address currentOwner;
    address manufacturerID;
    address distrbutorID;
    address retailerID;
    State itemState;
    bool filled;
  }

  // Define a public mapping 'items' that maps the UPC to an Item.
  mapping(uint => Item) items;
  // Define a public mapping 'productDetails' that maps the UPC of an item to its corresponding
  // instance of its product details.
  mapping(uint => ProductDetails) productDetails;

  // Define 4 events with the same 4 enum state values and emit UPC and current time.
  event Produced(uint indexed upc, uint256 time);
  event Packed(uint indexed upc, uint256 time);
  event Shipped(uint indexed upc, uint256 time);
  event Received(uint indexed upc, uint256 time);

  // Define a modifer that verifies the Caller
  modifier verifyCaller (address _address) {
    require(msg.sender == _address); 
    _;
  }

  // Define a modifier that checks if an item.state of a upc is Produced
  modifier produced(uint _upc) {
    require(items[_upc].itemState == State.Produced, "Item not yet Produced.");
    _;
  }
  
  // Define a modifier that checks if an item.state of a upc is Packed
  modifier packed(uint _upc) {
    require(items[_upc].itemState == State.Packed, "Item not yet Packed.");
    _;
  }
  
  // Define a modifier that checks if an item.state of a upc is Shipped
  modifier shipped(uint _upc) {
    require(items[_upc].itemState == State.Shipped, "Item not yet Shipped.");
    _;
  }

  // Define a modifier that checks if an item.state of a upc is Received
  modifier received(uint _upc) {
    require(items[_upc].itemState == State.Received, "Item not yet Received.");
    _;
  }

  // Define a modifier that checks if a UPC value is already in use.
  modifier upcUsed(uint _upc){
    require(items[_upc].filled == false, "The UPC entered is already in use.");
    _;
  }

  // Define a modifier that requires only the distribuor address stored in the Item instance 
  // to have access to a function.
  modifier onlyAssociatedDistributor(uint _upc, address _disAddress){
    require(items[_upc].distrbutorID == _disAddress, "You are not associated with this product.");
    _;
  }

  // Define a modifier that requires only the retailer address stored in the Item instance 
  // to have access to a function.
  modifier onlyAssociatedRetailer(uint _upc, address _retAddress){
    require(items[_upc].retailerID == _retAddress, "You are not associated with this product.");
    _;
  }

  // produceItem function adds a new item instance to the items mapping
  function produceItem
  (uint _upc,
  address _distributorID,
  uint _serial,
  uint _weight,
  uint _quantity,
  string memory _color
  )
  // call modifier to check if upc is already in use. 
  upcUsed(_upc) 
  // call modifier in coresponding role contract to check if sender has account type of manufacturer.
  onlyManufacturer 
  public {
    // add a new item instance to the items mapping.
    items[_upc] = Item({
      upc: _upc,
      batch: 1,
      price: 1,
      currentOwner: msg.sender,
      manufacturerID: msg.sender,
      distrbutorID: _distributorID,
      retailerID: address(0),
      itemState: State.Produced,
      filled: true
    });

    // add a new instance of product details to the productDetails mapping.
    productDetails[_upc] = ProductDetails({
      serial: _serial,
      weight: _weight,
      quantity: _quantity,
      color: _color
    });
    // Emit a Produced event that tells the system the manufacturer has completed its item production.
    emit Produced(_upc, now);
  }

  // function packItem allows only a corresponding distributor to access and changes product state to Packed.
  function packItem
  (uint _upc) 
  // check if item state has been changed to Produced before continuing.
  produced(_upc) 
  // check if the account attempting to call this function is of type Distributor.
  onlyDistributor 
  // check if the account attempting to call this function is associated with the item.
  onlyAssociatedDistributor(_upc, msg.sender) public {
    //Change the current owner address of item to distributor address.
    items[_upc].currentOwner = msg.sender;
    // update item state to Packed.
    items[_upc].itemState = State.Packed;
    // Emit a Packed event that tells the system the Distribuor has completed packing of item.
    emit Packed(_upc, now);
  }

  // function shippedItem allows only a corresponding distributor to access and change product state to Shipped.
  function shippedItem
  (uint _upc,
  address _retailerID) 
  //Check if the item state has been updated to Packed before continuing with shipment.
  packed(_upc) 
  // Check if the account attempting to call this function is of type distribuor.
  onlyDistributor public {
    // update the item state to Shipped.
    items[_upc].itemState = State.Shipped;
    // add corresponding retailerID that shipment will be sent to.
    items[_upc].retailerID = _retailerID;

    //Emit a Shipped event that tells the system the Distibutor has completed shipment of an item.
    emit Shipped(_upc, now);
  }

  // function Received Item allows a corresponding retailer to access and change product state to Received.
  function receivedItem(uint _upc) 
  // check if the item state has been updated to Shipped before continuing with function.
  shipped(_upc) 
  // Check if the account attempting to call this function is of type retailer.
  onlyRetailer public{
    // update product state to Received.
    items[_upc].itemState = State.Received;
    // Emit a Received event that tells the system the Retailer has completed the receivement process.
    emit Received(_upc, now);
  }

  // Function returns product details relating to an item UPC.
  function getProductDetails(uint _upc) public view returns(uint _serial, uint _weight, uint _quantity, string memory _color, address _owner, State _curState){
    return (productDetails[_upc].serial, productDetails[_upc].weight, productDetails[_upc].quantity, productDetails[_upc].color, items[_upc].currentOwner, items[_upc].itemState);
  }

  // Function checks if an instance of Item with UPC already exists.
  function isEntity(uint _upc) public view returns(bool isIndeed){
    return items[_upc].filled;
  }

  // Function returns the current state of an item with UPC value.
  function returnUPCStage(uint _key) view public returns (State){
    return items[_key].itemState;
  }

  // Function checks if address of accoutn accessing function is the owner of the contract.
  function isOwner(address _address) public view returns(bool){
    if(owner == _address){
      return true;
    }else{
      return false;
    }
  }

  // Function returns all product and item details relating to a corresponding UPC value.
  function fetchItem(uint _upc) public view returns
  (uint upc, uint batch, uint price, address curOwner, address manID, address disID, address retID,
  State state, uint serial, uint weight, uint quantity, string memory color){
    upc = items[_upc].upc;
    batch = items[_upc].batch;
    price = items[_upc].price;
    curOwner = items[_upc].currentOwner;
    manID = items[_upc].manufacturerID;
    disID = items[_upc].distrbutorID;
    retID = items[_upc].retailerID;
    state = items[_upc].itemState;
    serial = productDetails[_upc].serial;
    weight = productDetails[_upc].weight;
    quantity = productDetails[_upc].quantity;
    color = productDetails[_upc].color;
    return(upc, batch, price, curOwner, manID, disID, retID, state, serial, weight, quantity, color);
  }

}