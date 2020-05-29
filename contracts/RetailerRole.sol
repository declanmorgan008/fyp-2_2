pragma solidity ^0.5.16;

import "./Roles.sol";
/***
  * Contract is based on Open Zeppelins RBAC Roles contract.
  * Reference: https://docs.openzeppelin.com/contracts/2.x/api/access#Roles */

// Contract creates an role instance that is specifically for a Retailer.

contract RetailerRole {
  using Roles for Roles.Role;

// Define two events for the addition and removal of a manufacturer account.
  event RetailerAdded(address indexed account);
  event RetailerRemoved(address indexed account);

  // Define a public instance of all manufacturer accounts.
  Roles.Role private retailers;
  
  // Deployer of contract is defined as a Manufacturer.
  constructor() public {
    _addRetailer(msg.sender);
  }

  // Define a modifier that checks if the address of user accessing a function has a manufacture role account.
  modifier onlyRetailer() {
    require(isRetailer(msg.sender), "Sender is not a Retailer" );
    _;
  }

 // function checks if account address has a manufacturer account registered.
  function isRetailer(address account) public view returns (bool) {
    return retailers.has(account);
  }


  // function adds a new manufacturer to the system with provided account address.
  function addRetailer(address account) public onlyRetailer{
    _addRetailer(account);
  }

  // function removes a manufacturer account from the system.
  function renounceRetailer() public {
    _removeRetailer(msg.sender);
  }

  // function adds a manufacturer to the system
  function _addRetailer(address account) internal {
    retailers.add(account);
    // Emits an event to communicate with system that a new manufacturer has been added.
    emit RetailerAdded(account);
  }

  // function removes a manufacturer from the system
  function _removeRetailer(address account) internal {
    retailers.remove(account);
    // Emits an event to communicate with system that a manufacturer has been removed.
    emit RetailerRemoved(account);
  }
}