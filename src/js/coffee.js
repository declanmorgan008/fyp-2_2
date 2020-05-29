App = {
    web3Provider: null,
    contracts: {},
  
    init: function() {
      return App.initWeb3();
    },
  
    initWeb3: function() {
      if (typeof web3 !== 'undefined') {
        App.web3Provider = web3.currentProvider;
      } else {
        // If no injected web3 instance is detected, fall back to Ganache
        App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      }
      web3 = new Web3(App.web3Provider);
      window.ethereum.enable();
  
      return App.initContract();
    },
  
    initContract: function() {
      $.getJSON("Supplier.json", function(supplier) {
        // Instantiate a new truffle contract from the artifact
        App.contracts.Supplier = TruffleContract(supplier);
        // Connect provider to interact with contract
        App.contracts.Supplier.setProvider(App.web3Provider);
  
        return App.render();
      });
  
      return App.bindEvents();
    },
  
    bindEvents: function() {
      $(document).on("click", App.handleButtonClick);
    },
  
    handleButtonClick: async function(event) {
      var processId = parseInt($(event.target).data("id"));
      console.log("processId", processId);
  
  
      switch (processId) {
        case 1:
          return await App.orderSugar(event);
          break;
      }
    },
  
    orderSugar: function() {
      var sugar_id = $("#sugar-uid").val();
      console.log("sugar-uid", sugar_id);
      var sugar_brand = $("#sugar-brand").val();
      console.log("sugar-brand", sugar_brand);
      var sugar_quantity = $("#sugar-quantity").val();
      console.log("sugar-quantity", sugar_quantity);
  
  
      web3.eth.getAccounts(function(error, accounts) {
        if (error) {
          console.log(error);
        }
        console.log("account 0", accounts[0]);
      
        var account = accounts[0];
    
        App.contracts.Supplier.deployed().then(function(instance) {
          supplierInstance = instance;
            // Execute adopt as a transaction by sending account
          return supplierInstance.addSugar(sugar_id, sugar_brand, sugar_quantity, {from: account});
        }).catch(function(err) {
          console.log(err.message);
        });
      });    
    },
  
  
    updateSugar: async function(){
      App.contracts.Supplier.deployed().then(function(instance){
        return instance.getSugar.call();
      }).then(function(sugarResult){
        $("#sugarQuantity").text(sugarResult);
      });
    },
  
    render: function() {
      var supplierInstance;
      var loader = $("#loader");
      var content = $("#content");
  
      loader.show();
      content.hide();
     
      App.contracts.Supplier.deployed().then(function(instance){
          return instance.getSugar.call();
        }).then(function(result){
          $("#sugar_quantity").text(result);
      }).catch(function(error) {
        console.warn(error);
      });
    }
  };
  
  $(function() {
    $(window).load(function() {
      App.init();
    });
  });