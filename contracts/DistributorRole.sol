pragma solidity ^0.5.16;

import "./Roles.sol";
/***
  * Contract is based on Open Zeppelins RBAC Roles contract.
  * Reference: https://docs.openzeppelin.com/contracts/2.x/api/access#Roles */

// Contract creates an role instance that is specifically for a Distributor.
contract DistributorRole {
  using Roles for Roles.Role;

 // Define two events for the addition and removal of a Distributor account.
  event DistributorAdded(address indexed account);
  event DistributorRemoved(address indexed account);

  // Define a public instance of all distributor accounts.
  Roles.Role private distributors;

// Deployer of contract is defined as a distributor.
  constructor() public {
    _addDistributor(msg.sender);
  }

// Define a modifier that checks if the address of user accessing a function has a manufacture role account.
  modifier onlyDistributor() {
    require(isDistributor(msg.sender), "Sender is not a Distributor" );
    _;
  }

  // function checks if account address has a distributor account registered.
  function isDistributor(address account) public view returns (bool) {
    return distributors.has(account);
  }

  // function adds a new distributor to the system with provided account address.
  function addDistributor(address account) public onlyDistributor{
    _addDistributor(account);
  }

  // function removes a distributor account from the system.
  function renounceDistributor() public {
    _removeDistributor(msg.sender);
  }

  // function adds a distributor to the system
  function _addDistributor(address account) internal {
    distributors.add(account);
    // Emits an event to communicate with system that a new distributor has been added.
    emit DistributorAdded(account);
  }

  // function removes a distributor from the system
  function _removeDistributor(address account) internal {
    distributors.remove(account);
    // Emits an event to communicate with system that a distributor has been removed.
    emit DistributorRemoved(account);
  }
}