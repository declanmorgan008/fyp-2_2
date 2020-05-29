

App = {
  web3Provider: null,
  contracts: {},
  metamaskAccountID: "0x0000000000000000000000000000000000000000",
  


  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      // If no injected web3 instance is detected, fall back to Ganache
      //App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      App.web3Provider = new web3.providers.HttpProvider('http://127.0.0.1:9545');
    }
    web3 = new Web3(App.web3Provider);
    window.ethereum.enable();

    App.getMetaskAccountID();

    return App.initContract();
  },

  getMetaskAccountID: function () {
    web3 = new Web3(App.web3Provider);

    // Retrieving accounts
    web3.eth.getAccounts(function(err, res) {
        if (err) {
            console.log('Error:',err);
            return;
        }
        console.log('getMetaskID:',res);
        App.metamaskAccountID = res[0];

    })
  },

  initContract: function() {
    $.getJSON("SupplyChain.json", function(supplychain) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.SupplyChain = TruffleContract(supplychain);
      // Connect provider to interact with contract
      App.contracts.SupplyChain.setProvider(App.web3Provider);
    });
    $.getJSON("Users.json", function(users) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.Users = TruffleContract(users);
      // Connect provider to interact with contract
      App.contracts.Users.setProvider(App.web3Provider);
      App.allowRegistration();
    });
    return App.bindEvents();
  },


  bindEvents: function() {
    var eventLog = document.getElementById("upc-event-log");
    eventLog.style.display = "none";
    var eventLog = document.getElementById("transaction-timeline");
    eventLog.style.display = "none";
    document.getElementById("product-details").style.display = "none";
    
    
    $(document).on("click", App.handleButtonClick);
    
  },

  handleButtonClick: async function(event) {
    var processId = parseInt($(event.target).data("id"));
    console.log("processId", processId);
    ;

    switch (processId) {
      case 1:
        return await App.registerUser(event);
        break;
      case 2:
        return await App.produceItem(event);
        break;
      case 3:
        return await App.packItem(event);
        break;
      case 4:
        return await App.shipItem(event);
        break;
      case 5:
        return await App.receiveItem(event);
        break;
      case 6:
        return await App.receiveItem(event);
        break;
      case 9:
        return await App.isManufacturer(event);
        break;
      case 10:
        return await App.trackUPCNew(event);
        break;
      case 11:
        return await App.registerUser(event);
        
    }
  },

  allowRegistration: function(event){
    var registration = document.getElementById("user-register");
    App.contracts.SupplyChain.deployed().then(function(instance){
      instance.isOwner(App.metamaskAccountID).then(function(res){
        if(res){
          registration.style.display = "block";
        }else{
          registration.style.display = "none";
        }
      });
    });
  },

  isProducer: function(event){
   
    App.contracts.Users.deployed().then(function(instance) {
      console.log(App.metamaskAccountID);
      instance.getUser(App.metamaskAccountID).then(function (f){
        console.log(f);
      });
      console.log(instance.getUser(App.metamaskAccountID));
      return instance.isProducer(App.metamaskAccountID);
      //return instance.isProducer(App.metamaskAccountID);
    }).then(function(result) {
        console.log('isProducer',result);
    }).catch(function(err) {
        console.log(err.message);
    });
  },

  isManufacturer: function(event){
   
    App.contracts.SupplyChain.deployed().then(function(instance) {
      instance.isManufacturer(App.metamaskAccountID).then(function(f){
        console.log(f);
      });
      return instance.isManufacturer(App.metamaskAccountID);
    }).then(function(result) {
        console.log('manufacturer? :',result);
    }).catch(function(err) {
        console.log(err.message);
    });
  },

  registerUser: function(event){
    var company_name = $("#company-name").val();
    var company_account_type = $("#company-account-type").val();
    
    App.contracts.SupplyChain.deployed().then(function(instance){
      if(company_account_type == "Manufacturer"){
        return instance.addManufacturer(company_name, {from: App.metamaskAccountID});
      }else if(company_account_type == "Distributor"){
        console.log("Distributor completed");
        return instance.addDistributor(company_name, {from: App.metamaskAccountID});
      }else if(company_account_type == "Retailer"){
        return instance.addRetailer(company_name, {from: App.metamaskAccountID});
      }

    });


  },

  packItem: function(event){
    var upc = $("#distributor-upc").val();
    App.contracts.SupplyChain.deployed().then(function(instance) {
      return instance.packItem(upc);
    }).then(function(result) {
      console.log('isManufacturer',result);
    }).catch(function(err) {
        alert("You don't have access to this function.");
        console.log(err.message);
    });
  },

  shipItem: function(event){
    var upc = $("#distributor-ship-upc").val();
    var receiverAddress = $("#distributor-ship-address").val();
    App.contracts.SupplyChain.deployed().then(function(instance){
      return instance.shippedItem(upc, receiverAddress);
    }).then(function (result){
      console.log("Item Shipped ", result);
    }).catch(function(err){
      console.log(err.message);
    });
  },

  receiveItem: function(event){
    var upc = $("#retailer-upc").val();
    App.contracts.SupplyChain.deployed().then(function(instance){
      return instance.receivedItem(upc);
    }).then(function (result){
      console.log("Item Received ", result);
    }).catch(function(err){
      console.log(err.message);
    });
  },

  produceItem: function(event) {
    var processId = parseInt($(event.target).data('id'));
    var originalFarm = $("#originFarmerID").val();
    var upc = $("#product-upc").val();
    var disAddress = $("#product-distributor-address").val();
    var serial = $("#product-distributor-serial").val();
    var weight = $("#product-distributor-weight").val();
    var quantity = $("#product-distributor-quantity").val();
    var colour = $("#product-distributor-colour").val();

    App.contracts.SupplyChain.deployed().then(function(instance) {
       return instance.produceItem(upc, disAddress, serial, weight, quantity, colour);
    }).then(function(result) {
      console.log('isManufacturer',result);
    }).catch(function(err) {
        alert("You don't have access to this function.");
        console.log(err.message);
    });
  },

  convertTime: function(timestamp){
    let unix_timestamp = timestamp;
    // Create a new JavaScript Date object based on the timestamp
    // multiplied by 1000 so that the argument is in milliseconds, not seconds.
    var date = new Date(unix_timestamp * 1000);
    // Hours part from the timestamp
    var hours = date.getHours();
    // Minutes part from the timestamp
    var minutes = "0" + date.getMinutes();
    // Seconds part from the timestamp
    var seconds = "0" + date.getSeconds();

    var days = date.getDate();
    var month = date.getMonth();
    var year = date.getFullYear();


    // Will display time in 10:30:23 format
    var formattedTime = days + "/" + month + "/" + year + "\t" + hours + ':' + minutes.substr(-2) + ':' + seconds.substr(-2);

    return(formattedTime);
  },


  
  fetchProcessedEvent: function(){
    var upc_value = $("#upc_track_input").val();
    
    App.contracts.SupplyChain.deployed().then(function(instance){
      var harvestEvent = instance.Produced({upc: upc_value}, {fromBlock: 0, toBlock: 'latest'});
      harvestEvent.watch(function(err, result){
        if(!err){
          document.getElementById("produced-incomplete").style.display="none";
          document.getElementById("produced-complete").style.display="inline-block";
          console.log(result);
          console.log(result.blocknumber);
          var blockNum = result.transactionHash;
          web3.eth.getTransactionReceipt(blockNum, function(err, res){
            if(!err){
              console.log(res);
              document.getElementById("produced-card-title").innerHTML = "UPC: #" + upc_value;
              $("produced-card-text").empty();
              $('#produced-card-text').append(
                "<li>" + "TxHash: " + JSON.stringify(res.transactionHash) + "</li>" + "<br>" + 
                "<li>" + "Block Number: " + JSON.stringify(res.blockNumber) + "</li>" + "<br>" + 
                "<li>" + "To: " + JSON.stringify(res.to) + "</li>" + "<br>" + 
                "<li>" + "From: " + JSON.stringify(res.from) + "</li>" + "<br>" + 
                "<li>" + "Gas: " + JSON.stringify(res.gasUsed) + "</li>" 
              );
              document.getElementById("produced-card-footer").innerHTML = App.convertTime(result.args.time);
            }
          });
        }
      })
    });
  },

  fetchPackedEvent: function(){
    var upc_value = $("#upc_track_input").val();
    console.log("packedEvent: " + upc_value);
    App.contracts.SupplyChain.deployed().then(function(instance){
      var processedEvent = instance.Packed({upc: upc_value}, {fromBlock: 0, toBlock: 'latest'});
      processedEvent.watch(function(err, result){
        if(!err){
          document.getElementById("packed-incomplete").style.display="none";
          document.getElementById("packed-complete").style.display="inline-block";
          console.log(result);
          console.log(result.blocknumber);
          var blockNum = result.transactionHash;
          web3.eth.getTransactionReceipt(blockNum, function(err, res){
            if(!err){
              console.log(res);
              document.getElementById("packed-card-title").innerHTML = "UPC: #" + upc_value;
              $("packed-card-text").empty();
              $('#packed-card-text').append(
                "<li>" + "TxHash: " + JSON.stringify(res.transactionHash) + "</li>" + "<br>" + 
                "<li>" + "Block Number: " + JSON.stringify(res.blockNumber) + "</li>" + "<br>" + 
                "<li>" + "To: " + JSON.stringify(res.to) + "</li>" + "<br>" + 
                "<li>" + "From: " + JSON.stringify(res.from) + "</li>" + "<br>" + 
                "<li>" + "Gas: " + JSON.stringify(res.gasUsed) + "</li>" 
              );
              document.getElementById("packed-card-footer").innerHTML = App.convertTime(result.args.time);
            }
          });
        }
      })
    });
  },


  fetchShippedEvent: function(){
    var upc_value = $("#upc_track_input").val();
    console.log("shippedEvent: " + upc_value);
    App.contracts.SupplyChain.deployed().then(function(instance){
      var processedEvent = instance.Shipped({upc: upc_value}, {fromBlock: 0, toBlock: 'latest'});
      processedEvent.watch(function(err, result){
        if(!err){
          document.getElementById("shipped-incomplete").style.display="none";
          document.getElementById("shipped-complete").style.display="inline-block";
          console.log(result);
          console.log(result.blocknumber);
          var blockNum = result.transactionHash;
          web3.eth.getTransactionReceipt(blockNum, function(err, res){
            if(!err){
              console.log(res);
              document.getElementById("shipped-card-title").innerHTML = "UPC: #" + upc_value;
              $("shipped-card-text").empty();
              $('#shipped-card-text').append(
                "<li>" + "TxHash: " + JSON.stringify(res.transactionHash) + "</li>" + "<br>" + 
                "<li>" + "Block Number: " + JSON.stringify(res.blockNumber) + "</li>" + "<br>" + 
                "<li>" + "To: " + JSON.stringify(res.to) + "</li>" + "<br>" + 
                "<li>" + "From: " + JSON.stringify(res.from) + "</li>" + "<br>" + 
                "<li>" + "Gas: " + JSON.stringify(res.gasUsed) + "</li>" 
              );
              document.getElementById("shipped-card-footer").innerHTML = App.convertTime(result.args.time);
            }
          });
        }
      })
    });
  },


  fetchReceivedEvent: function(){
    var upc_value = $("#upc_track_input").val();
    console.log("Received Event: " + upc_value);
    App.contracts.SupplyChain.deployed().then(function(instance){
      var processedEvent = instance.Received({upc: upc_value}, {fromBlock: 0, toBlock: 'latest'});
      processedEvent.watch(function(err, result){
        if(!err){
          document.getElementById("received-incomplete").style.display="none";
          document.getElementById("received-complete").style.display="inline-block";
          console.log(result);
          console.log(result.blocknumber);
          var blockNum = result.transactionHash;
          web3.eth.getTransactionReceipt(blockNum, function(err, res){
            if(!err){
              console.log(res);
              document.getElementById("received-card-title").innerHTML = "UPC: #" + upc_value;
              $("received-card-text").empty();
              $('#received-card-text').append(
                "<li>" + "TxHash: " + JSON.stringify(res.transactionHash) + "</li>" + "<br>" + 
                "<li>" + "Block Number: " + JSON.stringify(res.blockNumber) + "</li>" + "<br>" + 
                "<li>" + "To: " + JSON.stringify(res.to) + "</li>" + "<br>" + 
                "<li>" + "From: " + JSON.stringify(res.from) + "</li>" + "<br>" + 
                "<li>" + "Gas: " + JSON.stringify(res.gasUsed) + "</li>" 
              );
              document.getElementById("received-card-footer").innerHTML = App.convertTime(result.args.time);
            }
          });
        }
      })
    });
  },

  
  productDetails: function(event){
    var serial = $("#product-details-serial");
    var weight = $("#product-details-weight");
    var quantity = $("#product-details-quantity");
    var color = $("#product-details-color");
    var owner = $("#product-details-current-owner");
    var upc_value = $("#upc_track_input").val();
    App.contracts.SupplyChain.deployed().then(function(instance){
      instance.getProductDetails(upc_value).then(function(res){
        document.getElementById("product-details").style.display = "block";
        document.getElementById("product-details-serial").innerText = "Serial: " + res[0];
        document.getElementById("product-details-weight").innerText = "Weight: " + res[1];
        document.getElementById("product-details-quantity").innerText = "Quantity: " + res[2];
        document.getElementById("product-details-color").innerText = "Colour: " + res[3];
        document.getElementById("product-details-current-owner").innerText = "Current Owner: " + res[4];
        document.getElementById("product-details-state").innerText = "Current State: " + res[5];
      });
    })
  },

  trackUPCNew: function(event){
    var eventLog = document.getElementById("transaction-timeline");
    eventLog.style.display = "block";
    var upc_value = $("#upc_track_input").val();
    //var allStates = [Harvested, Processed, Packed, ForSale, Sold, Shipped, Received, Purchased];
    App.contracts.SupplyChain.deployed().then(function(instance){
      // let harvestEvent1 = instance.Harvested({upc:upc_value});
      // harvestEvent1.watch(function(error, result){
      //   if(!error){
      //     console.log("HELLO SIR");
      //     console.log(JSON.stringify(result));
      //   }
      // });
      instance.returnUPCStage(upc_value).then(function(res){
        var upcState = res;
        console.log("UPC STATE RETURNED " + upcState);
        var i = 0;
        var stringToDisplay = "<tr>"
        //console.log("Calling Harvest Event" + getHarvest(upc_value));
        console.log("Value of i " + i);
        console.log("Value of UPCSTATE: " + upcState);
        for(i=0; i<=upcState; i++){
          console.log("INSIDE");
          var watchEvent;

          if(i==0){
            console.log("i is 0");
            console.log(App.fetchProcessedEvent());
            App.productDetails();
            instance.getProductDetails(upc_value).then(function(error, result){
              if(!error){
                document.getElementById("product-details").style.display = "block";
                console.log("get product details" , result);
                console.log(JSON.stringify(result[0]));
              }else{
                console.log(error);
              }
            })
          }else if(i==1){
            console.log("get processed event");
            console.log(App.fetchPackedEvent());
          }else if(i==2){
            console.log("get shipped event");
            console.log(App.fetchShippedEvent());
          }else if(i==3){
            console.log("get received event");
            console.log(App.fetchReceivedEvent());
          }
        }
        console.log(stringToDisplay);
      });
    });
  },

};

$(function() {
  $(window).load(function() {
    App.init();
    
  });
});