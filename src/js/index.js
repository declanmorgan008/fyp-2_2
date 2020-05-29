var http = require('http');
var Web3 = require('web3');
var mysql = require('mysql');
const rpcURL = "https://mainnet.infura.io/v3/464a1128fd8e4d13b3a74cf509398f50";


var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));
let connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'Password123',
  database: 'pet_shop',
  post: '3306'
});

var blockNumber;



connection.connect(function(err) {
  if (err) {
    return console.error('error: ' + err.message);
  }
  console.log('Connected to the MySQL server.');
  
  web3.eth.getBlockNumber(function(error, _bn){
    blockNumber = _bn;
    
    console.log(blockNumber);

  
    for (var i=1; i <= blockNumber; i++) {
      console.log("block", i);
      web3.eth.getBlock(i, function(error, value){
        //console.log("block", value.transactions[0]);
        
        var number = JSON.stringify(value.number);
        var hash = JSON.stringify(value.hash);
        var nonce = JSON.stringify(value.nonce);
        var miner = JSON.stringify(value.miner);
        var difficulty = JSON.stringify(value.difficulty);
        var size = JSON.stringify(value.size);
        var gasLimit = JSON.stringify(value.gasLimit);
        var gasUsed = JSON.stringify(value.gasUsed);
        var timestamp = JSON.stringify(value.timestamp);
        //var sql = "INSERT INTO blockchain_blocks (idblockchain_blocks, gaslimit, gasused) VALUES ()";
        var sql = "INSERT INTO p1_1 (id_block_num, hash, nonce, miner, difficulty, size, gasLimit, gasUsed, timestamp) VALUES (" 
        + number + ", " + hash + ", " + nonce + ", " + miner + ", " + difficulty + ", " + size + ", " + gasLimit + ", " + gasUsed + ", " + timestamp + ")";
        
        var checkSQL = "SELECT 1 FROM p1_1 WHERE id_block_num = " + number ;
          // connection.query(checkSQL, function(error, result){
          //   if(error){
          //     connection.query(sql, function (err, result){
          //       if(err) throw err;
          //       console.log("inserted");
          //     });
          //   }
          // });
        connection.query(sql, function (err, result) {
          if (err) throw err;
          console.log("1 block inserted");
        });

        // web3.eth.getTransaction(value.transactions[0], function(error, trans){
        //   var hash = JSON.stringify(trans.hash);
        //   var nonce = JSON.stringify(trans.nonce);
        //   var blockHash = JSON.stringify(trans.blockHash);
        //   var bn = JSON.stringify(trans.blockNumber);
        //   var transactionIndex = JSON.stringify(trans.transactionIndex);
        //   var from = JSON.stringify(trans.from);
        //   var to = JSON.stringify(trans.to);
        //   var value = JSON.stringify(trans.value);
        //   var gas = JSON.stringify(trans.gas);
        //   var gasPrice = JSON.stringify(trans.gasPrice);
        //   var input = JSON.stringify(trans.input);
        //   var sql = "INSERT INTO p1_1_transactions (hash_id, nonce, blockHash, blockNumber, transactionIndex, from_add, to_add, value, gas, gasPrice) VALUES (" 
        //   + hash + ", " + nonce + ", " + blockHash + ", " + bn + ", " + transactionIndex + ", " + from + ", " + to + ", " + value + ", " + gas + ", " + gasPrice + ")";
        //   //var sql = "INSERT INTO test (idtest) VALUES(" + hash + ")";
        //   connection.query(sql, function (err, result) {
        //     if (err) throw err;
        //     console.log("1 record inserted");
        //   });
        // });
      });
    };  

  });

  web3.eth.getBlockNumber(function(error, _bn){
    blockNumber = _bn;
    
    console.log(blockNumber);

  
    for (var i=1; i <= blockNumber; i++) {
      web3.eth.getBlock(i, function(error, value){
        //console.log("Value Transactions [0]: ", value);
        web3.eth.getTransaction(value.transactions[0], function(error, trans){
          var hash = JSON.stringify(trans.hash);
          var nonce = JSON.stringify(trans.nonce);
          var blockHash = JSON.stringify(trans.blockHash);
          var bn = JSON.stringify(trans.blockNumber);
          var transactionIndex = JSON.stringify(trans.transactionIndex);
          var from = JSON.stringify(trans.from);
          var to = JSON.stringify(trans.to);
          var value = JSON.stringify(trans.value);
          var gas = JSON.stringify(trans.gas);
          var gasPrice = JSON.stringify(trans.gasPrice);
          var input = JSON.stringify(trans.input);
          var sql = "INSERT INTO p1_1_transactions (hash_id, nonce, blockHash, blockNumber, transactionIndex, from_add, to_add, value, gas, gasPrice) VALUES (" 
          + hash + ", " + nonce + ", " + blockHash + ", " + bn + ", " + transactionIndex + ", " + from + ", " + to + ", " + value + ", " + gas + ", " + gasPrice + ")";
          //var sql = "INSERT INTO test (idtest) VALUES(" + hash + ")";
          
          var checkSQL = "SELECT 1 FROM p1_1_transactions WHERE hash_id = " + hash ;
          // connection.query(checkSQL, function(error, result){
          //   if(error){
          //     connection.query(sql, function (err, result){
          //       if(err) throw err;
          //       console.log("inserted");
          //     });
          //   }
          // });
          connection.query(sql, function (err, result) {
            if (err) throw err;
            console.log("1 transaction inserted");
          });
        });
      });

    }

  });
  
});

function getBlockTransactions(transactionID){
  web3.eth.getTransaction(transactionsID).then(console.log);
}