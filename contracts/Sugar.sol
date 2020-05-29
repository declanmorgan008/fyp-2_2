pragma solidity >=0.4.22  <0.7.0;


contract Sugar {
    
    struct SugarO {
        uint256 id;
        string brand;
        int quantity;
    }

    constructor() public {
        
    }


    string sugarBrand;

    event SugarAdded(address caller, uint256 _id, int _quantity);
    
    mapping(uint256 => SugarO) public supplierSugar;
    mapping(uint256 => SugarO) public shopSugar;



    modifier sugarExists(uint256 _id, int _quantity){
        require(supplierSugar[_id].id > 0 && supplierSugar[_id].quantity > _quantity, "Supplier does not have enough sugar.");
        _;
    }

    function addBrand(string memory brand) public view returns(string memory){
        
        return sugarBrand;
    }
    
    
    function addSugar(uint256 _id, string memory _brand, int _quantity) public {
        if(supplierSugar[_id].id > 0){
            supplierSugar[_id].quantity += _quantity;
        }else{
            supplierSugar[_id] = SugarO(_id, _brand, _quantity);
        }
        emit SugarAdded(msg.sender, _id, _quantity);
    }
    
    
    function orderSupplierSugar(uint256 _id, int _quantity, address _caller) public sugarExists(_id, _quantity){
        supplierSugar[_id].quantity -= _quantity;
        orderShopSugar(_id, _quantity, _caller);
    }

    function orderShopSugar(uint256 _id, int _quantity, address _caller) public{
        if(shopSugar[_id].id > 0){
            shopSugar[_id].quantity += _quantity;
        }
        // }else{
        //     shopSugar[_id] = SugarO(_id, _brand, _quantity);
        // }
        emit SugarAdded(_caller, _id, _quantity);
    }


    function getSugarDetails(uint256 _id) public view returns(string memory){
        if(supplierSugar[_id].id > 0){
           //return (_id, supplierSugar[_id].brand, supplierSugar[_id].quantity);
           
           return (supplierSugar[_id].brand);
        }
    }

    function addSugarToMapping(uint256 _key, string memory _brand, int _quantity) public {
        if(supplierSugar[_key].id > 0){
            supplierSugar[_key].quantity += _quantity;
        }else{
            supplierSugar[_key] = SugarO(_key,_brand,_quantity);
        }
    }

   

    function getByKey(uint256 _key) public view returns (string memory){
        if(supplierSugar[_key].id != 0){
            return "Here is 10 sugar";
        }
    }
    
}