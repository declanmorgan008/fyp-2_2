var Supplier = artifacts.require("./SupplyChain.sol");
var CoffeeShop = artifacts.require("./Users.sol");

var ProducerRole = artifacts.require("./ProducerRole.sol");
var ManufacturerRole = artifacts.require("./ManufacturerRole.sol");
var DistributorRole = artifacts.require("./DistributorRole.sol");
var RetailerRole = artifacts.require("./RetailerRole.sol");
module.exports = (deployer, network) => {
    deployer.deploy(Supplier);
    deployer.deploy(CoffeeShop);
    deployer.deploy(ProducerRole);
    deployer.deploy(ManufacturerRole);
    deployer.deploy(DistributorRole);
    deployer.deploy(RetailerRole);
    // deployer.deploy(Supplier, Sugar.address);
    // deployer.deploy(CoffeeShop, Supplier.address);
    // deployer.deploy(Sugar).then(function(){
    //   return deployer.deploy(Supplier, Sugar.address)
    // });
    // deployer.deploy(CoffeeShop, Supplier.address);
    // deployer.deploy(Supplier).then(function() {
    //   return deployer.deploy(CoffeeShop, Supplier.address)
    // });
  };