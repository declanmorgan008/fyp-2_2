pragma solidity ^0.5.16;
contract Users {

    enum UserType{
        Producer,
        Manufacturer,
        Supplier,
        Retailer,
        Consumer
    }

    // modifier onlyProducer(){
    //     require (isProducer(msg.sender), "Only Producer's are allowed to access this function");
    //     _;
    // }

    modifier onlyManufacturer(address _owner){
        require (isManufacturer(_owner), "Only Manufacturer's are allowed to access this function");
        _;
    }

    modifier onlySupplier(){
        require (isSupplier(msg.sender), "Only Supplier's are allowed to access this function");
        _;
    }
    modifier onlyRetailer(){
        require (isRetailer(msg.sender), "Only Retailers's are allowed to access this function");
        _;
    }
    modifier onlyConsumer(){
        require (isConsumer(msg.sender), "Only Consumers's are allowed to access this function");
        _;
    }

    

    UserType constant defaultUserType = UserType.Producer;
    struct User{
        address uad;
        string name;
        string city;
        string country;
        uint tel;
        UserType userType;
    }

    mapping (address => User) users;
    mapping (address => bool) hasAccount;

    event NewUser(address indexed _userAddress);
    event UserExists(address indexed _userAddress);

    function addUser(address _userAddress, string memory _name, string memory _city, string memory _country,
    uint _tel, UserType _userType) public returns(bool log){
        if(!hasAccount[_userAddress]){
            hasAccount[_userAddress] = true;
            users[_userAddress] = User(_userAddress, _name, _city, _country, _tel, _userType);
            emit NewUser(_userAddress);
            return true;
        }
        emit UserExists(_userAddress);
        return false;
    }

    function addProducer(address _userAddress, string memory _name, string memory _city, string memory _country,
    uint _tel) public returns(bool log){
        UserType temp = UserType.Producer;
        return addUser(_userAddress,_name,_city,_country,_tel,temp);
    }

    function addManufacturer(address _userAddress, string memory _name, string memory _city, string memory _country,
    uint _tel) public returns(bool log){
        UserType temp = UserType.Manufacturer;
        return addUser(_userAddress,_name,_city,_country,_tel,temp);
    }
    function addSupplier(address _userAddress, string memory _name, string memory _city, string memory _country,
    uint _tel) public returns(bool log){
        UserType temp = UserType.Supplier;
        return addUser(_userAddress,_name,_city,_country,_tel,temp);
    }
    function addRetailer(address _userAddress, string memory _name, string memory _city, string memory _country,
    uint _tel) public returns(bool log){
        UserType temp = UserType.Retailer;
        return addUser(_userAddress,_name,_city,_country,_tel,temp);
    }

    function hasUser(address _userAddress) public view returns(bool exists){
        return (hasAccount[_userAddress]);
    }

    function isProducer(address _userAddress) public view returns(bool){
        if(users[_userAddress].uad == address(0)){
            return false;
        }else{
            UserType temp = UserType.Producer;
            if(users[_userAddress].userType == temp){
                return true;
            }else{
                return false;
            }
        }
        
    }
    function getUser(address _userAddress) public view returns (address add, string memory name, UserType _user){
        
        return (users[_userAddress].uad, users[_userAddress].name, users[_userAddress].userType);
    
    }

    function isManufacturer(address _userAddress) public view returns(bool){
        UserType temp = UserType.Manufacturer;
        if(users[_userAddress].userType == temp){
            return true;
        }else{
            return false;
        }
    }

    function isSupplier(address _userAddress) public view returns(bool){
        if(users[_userAddress].userType == UserType.Supplier){
            return true;
        }else{
            return false;
        }
    }

    function isRetailer(address _userAddress) public view returns(bool){
        if(users[_userAddress].userType == UserType.Retailer){
            return true;
        }else{
            return false;
        }
    }

    function isConsumer(address _userAddress) public view returns(bool){
        if(users[_userAddress].userType == UserType.Consumer){
            return true;
        }else{
            return false;
        }
    }

    function viewAccountType(address _userAddress) public view returns(UserType){
        return users[_userAddress].userType;
    }

   




}