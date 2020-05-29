pragma solidity ^0.5.16;
import './Users.sol';
import './SupplierRole.sol';
import './ManufacturerRole.sol';
import './DistributorRole.sol';
import './RetailerRole.sol';

/*SupplyChain contract stores the core functionality and details 
about items being produced, packed and shipped along a SupplyChain. */
contract SupplyChain is SupplierRole, ManufacturerRole, DistributorRole, RetailerRole{

  address owner;

  constructor() public {
    owner = msg.sender;
  }

  // Define a public mapping 'itemsHistory' that maps the UPC to an array of TxHash, 
  // that track its journey through the supply chain -- to be sent from DApp.

  //Not a good idea to use this as it will cost a lot of gas to keep updated.
  mapping (uint => string[]) itemsHistory;


  enum State {
    Produced,
    Packed,
    ForSale,
    Sold,
    Shipped,
    Received
  }
  

  State constant defaultState = State.Produced;

  struct ProductDetails { 
    uint serial;
    uint weight;
    uint quantity;
    string color;
  }

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
  mapping (uint => Item) items;
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


  modifier upcUsed(uint _upc){
    require(items[_upc].filled == false, "The UPC entered is already in use.");
    _;
  }

  modifier onlyAssociatedDistributor(uint _upc, address _disAddress){
    require(items[_upc].distrbutorID == _disAddress, "You are not associated with this product.");
    _;
  }

  modifier onlyAssociatedRetailer(uint _upc, address _retAddress){
    require(items[_upc].retailerID == _retAddress, "You are not associated with this product.");
    _;
  }


  function produceItem
  (uint _upc,
  address _distributorID,
  uint _serial,
  uint _weight,
  uint _quantity,
  string memory _color
  ) upcUsed(_upc) onlyManufacturer public {
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

    productDetails[_upc] = ProductDetails({
      serial: _serial,
      weight: _weight,
      quantity: _quantity,
      color: _color
    });
    emit Produced(_upc, now);
  }

  function packItem
  (uint _upc) produced(_upc) onlyDistributor onlyAssociatedDistributor(_upc, msg.sender) public {
    items[_upc].currentOwner = msg.sender;
    items[_upc].itemState = State.Packed;

    emit Packed(_upc, now);
  }

  function shippedItem
  (uint _upc,
  address _retailerID) packed(_upc) onlyDistributor public {
    items[_upc].itemState = State.Shipped;
    items[_upc].retailerID = _retailerID;

    emit Shipped(_upc, now);
  }

  function receivedItem(uint _upc) shipped(_upc) onlyRetailer public{
    items[_upc].itemState = State.Received;
    emit Received(_upc, now);
  }

  function getProductDetails(uint _upc) public view returns(uint _serial, uint _weight, uint _quantity, string memory _color, address _owner, State _curState){
    return (productDetails[_upc].serial, productDetails[_upc].weight, productDetails[_upc].quantity, productDetails[_upc].color, items[_upc].currentOwner, items[_upc].itemState);
  }

  function isEntity(uint _upc) public view returns(bool isIndeed){
    return items[_upc].filled;
  }


  function returnUPCStage(uint _key) view public returns (State){
    return items[_key].itemState;
  }

  function isOwner(address _address) public view returns(bool){
    if(owner == _address){
      return true;
    }else{
      return false;
    }
  }

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