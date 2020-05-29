
var SupplyChain = artifacts.require("SupplyChain");
const assert = require("chai").assert;
const truffleAssert = require('truffle-assertions');
contract("SupplyChain", function(accounts){
    var upc = 1;
    const ownerID = accounts[0];
    const manufacturerID = accounts[0];
    const distributorID = accounts[1];
    const retailerID = accounts[2];
    var serial = 111222333444;
    var weight = 20;
    var quantity = 50000;
    var color = "green";
    var zeroAddress = "0x0000000000000000000000000000000000000000";

    console.log("Contract Owner: ", ownerID);
    console.log("manufacturer ID: ", manufacturerID);
    console.log("Distributor ID: ", distributorID);
    console.log("Retailer ID: ", retailerID);

    it("Test Produce function that allows user to add a product.", async () =>{
        const supplyChain = await SupplyChain.deployed();
        var producedEventEmitted = false;
    
        let result = await supplyChain.produceItem(upc, 
            distributorID,
            serial,
            weight,
            quantity,
            color
        );

        truffleAssert.eventEmitted(result, 'Produced', (ev) => {
            return ev.upc.words[0] === upc;
        });

        const itemsReturned = await supplyChain.fetchItem(upc);
        assert.equal(itemsReturned[0], upc, "Error: Invalid UPC");
        assert.equal(itemsReturned[3], ownerID, "Eror: Missing or invalid owner ID");
        assert.equal(itemsReturned[4], manufacturerID, "Eror: Missing or invalid manufacturer ID");
        assert.equal(itemsReturned[5], distributorID, "Eror: Missing or invalid distributor ID");
        assert.equal(itemsReturned[6], zeroAddress, "Eror: Missing or invalid retailer ID");
        assert.equal(itemsReturned[7], 0, "Eror: Missing or invalid State.");
        assert.equal(itemsReturned[8], serial, "Eror: Missing or invalid serial");
        assert.equal(itemsReturned[9], weight, "Eror: Missing or invalid weight");
        assert.equal(itemsReturned[10], quantity, "Eror: Missing or invalid quantity");
        assert.equal(itemsReturned[11], color, "Eror: Missing or invalid color");
    });

    it("Register accounts for corresponding account types.", async() => {
        const supplyChain = await SupplyChain.deployed();

        const ownerResult = await supplyChain.isOwner.call(ownerID);
        assert.equal(ownerResult, true, "Error: owner address is not contract owner");

        let result = await supplyChain.addDistributor(distributorID);
        truffleAssert.eventEmitted(result, 'DistributorAdded', (ev) => {
            return ev.account === distributorID;
        });

        result = await supplyChain.addRetailer(retailerID);
        truffleAssert.eventEmitted(result, 'RetailerAdded', (ev) => {
            return ev.account === retailerID;
        });
    });

    it("Test PackItem function where only corresponding distributor can access.", async () =>{
        const supplyChain = await SupplyChain.deployed();
        var producedEventEmitted = false;
     
        let result = await supplyChain.packItem(upc, {from: distributorID});

        truffleAssert.eventEmitted(result, 'Packed', (ev) => {
            return ev.upc.words[0] === upc;
        });


        const itemsReturned = await supplyChain.fetchItem(upc);
        assert.equal(itemsReturned[0], upc, "Error: Invalid UPC");
        assert.equal(itemsReturned[3], distributorID, "Eror: Missing or invalid owner ID");
        assert.equal(itemsReturned[4], manufacturerID, "Eror: Missing or invalid manufacturer ID");
        assert.equal(itemsReturned[5], distributorID, "Eror: Missing or invalid distributor ID");
        assert.equal(itemsReturned[6], zeroAddress, "Eror: Missing or invalid retailer ID");
        assert.equal(itemsReturned[7], 1, "Eror: Missing or invalid State.");
    });

    it("Test ShippedItem function where only corresponding distributor can access.", async () =>{
        const supplyChain = await SupplyChain.deployed();
        var producedEventEmitted = false;
     
        let result = await supplyChain.shippedItem(upc, retailerID, {from: distributorID});

        truffleAssert.eventEmitted(result, 'Shipped', (ev) => {
            return ev.upc.words[0] === upc;
        });


        const itemsReturned = await supplyChain.fetchItem(upc);
        assert.equal(itemsReturned[0], upc, "Error: Invalid UPC");
        assert.equal(itemsReturned[3], distributorID, "Eror: Missing or invalid owner ID");
        assert.equal(itemsReturned[4], manufacturerID, "Eror: Missing or invalid manufacturer ID");
        assert.equal(itemsReturned[5], distributorID, "Eror: Missing or invalid distributor ID");
        assert.equal(itemsReturned[6], retailerID, "Eror: Missing or invalid retailer ID");
        assert.equal(itemsReturned[7], 4, "Eror: Missing or invalid State.");
    });

    it("Test ReceivedItem function where only corresponding retailer can access.", async () =>{
        const supplyChain = await SupplyChain.deployed();
        var producedEventEmitted = false;
     
        let result = await supplyChain.receivedItem(upc, {from: retailerID});

        truffleAssert.eventEmitted(result, 'Received', (ev) => {
            return ev.upc.words[0] === upc;
        });


        const itemsReturned = await supplyChain.fetchItem(upc);
        assert.equal(itemsReturned[0], upc, "Error: Invalid UPC");
        assert.equal(itemsReturned[3], distributorID, "Eror: Missing or invalid owner ID");
        assert.equal(itemsReturned[4], manufacturerID, "Eror: Missing or invalid manufacturer ID");
        assert.equal(itemsReturned[5], distributorID, "Eror: Missing or invalid distributor ID");
        assert.equal(itemsReturned[6], retailerID, "Eror: Missing or invalid retailer ID");
        assert.equal(itemsReturned[7], 5, "Eror: Missing or invalid State.");
    });

    
})