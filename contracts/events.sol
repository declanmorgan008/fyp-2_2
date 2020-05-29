 // Define 4 events with the same 4 enum state values and emit UPC and current time.
  event Produced(uint indexed upc, uint256 time);
  event Packed(uint indexed upc, uint256 time);
  event Shipped(uint indexed upc, uint256 time);
  event Received(uint indexed upc, uint256 time);

  function shippedItem
  (uint _upc,
  address _retailerID) 
  packed(_upc) 
  onlyDistributor public {
    items[_upc].itemState = State.Shipped;
    items[_upc].retailerID = _retailerID;

    //Emit Shipped Event for corresponding product.
    emit Shipped(_upc, now);
  }