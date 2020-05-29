pragma solidity >=0.4.22  <0.7.0;



contract Sugar{

    function orderSupplierSugar(uint256 _id, int _quantity, address _caller) public {}
    function addSugar(uint256 _id, string memory _brand, int _quantity) public {}
    function getSugarDetails(uint256 _id) public view returns(string memory){}
    function addBrand(string memory brand) public view returns(string memory){}

}

contract Supplier {

    Sugar sugar;
    
    
    event sugarAdded(address caller, uint256 _id, int _quantity);

    constructor(address _t) public {
        sugar = Sugar(_t);
    }

    function addSupplierSugar(uint256 _id, string memory _brand, int _quantity) public {
        sugar.addSugar(_id, _brand, _quantity);
        emit sugarAdded(msg.sender, _id, _quantity);
    }
    
    function orderSugar(uint256 _id, int _quantity, address _caller) public {
        sugar.orderSupplierSugar(_id, _quantity, _caller);
    }

    function getSugarDetails(uint256 _id) public view returns(string memory){
        return (sugar.getSugarDetails(_id));
    }
    
    function addBrand(string memory brand) public view returns(string memory){
        
        return brand;
    }

}