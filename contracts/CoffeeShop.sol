pragma solidity >=0.4.22  <0.7.0;


contract Supplier{
    
    function orderSugar(uint256 _id, int _quantity, address _caller) public{}
}

contract CoffeeShop{
    
    Supplier supplier;
    
    constructor (address _t) public{
        supplier = Supplier(_t);
    }
    
    struct Beans{
        uint256 serial_no;
        string bean_type;
        string origin;
        int quantity;
    }
    
    struct Cups{
        uint256 serial_no;
        string cup_type;
        int quantity;
    }
    
    struct Milk{
        uint256 serial_no;
        string milk_type;
        string origin;
        int quantity;
    }
    
    mapping(uint256 =>Beans) public beans;
    mapping(uint256 => Cups) public cups;
    mapping(uint256 => Milk) public milk;

    
    modifier beansExist(uint256 _serial){
        require(beans[_serial].serial_no > 0, "Bean type don't exist.");
        _;
    }
    
    modifier cupsExist(uint256 _serial){
        require(cups[_serial].serial_no > 0, "Cups don't exist.");
        _;
    }
    
    modifier milkExists(uint256 _serial){
        require(milk[_serial].serial_no > 0, "Milk type don't exist.");
        _;
    }
    
    function addBeans(uint256 _serial, string memory _type, string memory _origin, int _quantity) public {
        if(beans[_serial].serial_no > 0){
            beans[_serial].quantity += _quantity;
        }else{
            beans[_serial] = Beans(_serial, _type, _origin, _quantity);
        }
    }
    
    function addCups(uint256 _serial, string memory _type, int _quantity) public {
        if(cups[_serial].serial_no > 0){
            cups[_serial].quantity += _quantity;
        }else{
            cups[_serial] = Cups(_serial, _type, _quantity);
        }
    }
    
    function addMilk(uint256 _serial, string memory _type, string memory _origin, int _quantity) public {
        if(milk[_serial].serial_no > 0){
            milk[_serial].quantity += _quantity;
        }else{
            milk[_serial] = Milk(_serial, _type, _origin, _quantity);
        }
    }
    
    
    function makeLatte(uint256 _coffeeSN, int _coffeeQ, uint256 _cupSN, uint256 _milkSN, int _milkQ) public
    beansExist(_coffeeSN)
    cupsExist(_cupSN)
    milkExists(_milkSN){
        _makeLatte(_coffeeSN, _coffeeQ, _cupSN, _milkSN, _milkQ);
    }
    
    function _makeLatte(uint256 _coffeeSN, int _coffeeQ, uint256 _cupSN, uint256 _milkSN, int _milkQ) internal{
        beans[_coffeeSN].quantity -= _coffeeQ;
        cups[_cupSN].quantity -= 1;
        milk[_milkSN].quantity -= _milkQ;
    }
    
    
    function makeSugarOrder(uint256 _id, int _quantity) public {
        supplier.orderSugar(_id, _quantity, msg.sender);
    }
   
}