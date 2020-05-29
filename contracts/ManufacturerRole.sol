pragma solidity ^0.5.16;

import "./Roles.sol";

/***
  * Contract is based on Open Zeppelins RBAC Roles contract.
  * Reference: https://docs.openzeppelin.com/contracts/2.x/api/access#Roles */

// Contract creates an role instance that is specifically for a Manufacturer.
contract ManufacturerRole {
  using Roles for Roles.Role;

  // Define two events for the addition and removal of a manufacturer account.
  event ManufacturerAdded(address indexed account);
  event ManufacturerRemoved(address indexed account);

  // Define a public instance of all manufacturer accounts.
  Roles.Role private manufacturers;

  // Deployer of contract is defined as a Manufacturer.
  constructor() public {
    _addManufacturer(msg.sender);
  }

  // Define a modifier that checks if the address of user accessing a function has a manufacture role account.
  modifier onlyManufacturer() {
    require(isManufacturer(msg.sender), "Sender is not a Manufacturer" );
    _;
  }

  // function checks if account address has a manufacturer account registered.
  function isManufacturer(address account) public view returns (bool) {
    return manufacturers.has(account);
  }

  // function adds a new manufacturer to the system with provided account address.
  function addManufacturer(address account) public onlyManufacturer{
    _addManufacturer(account);
  }

  // function removes a manufacturer account from the system.
  function renounceManufacturer() public {
    _removeManufacturer(msg.sender);
  }

  // function adds a manufacturer to the system
  function _addManufacturer(address account) internal {
    manufacturers.add(account);
    // Emits an event to communicate with system that a new manufacturer has been added.
    emit ManufacturerAdded(account);
  }

  // function removes a manufacturer from the system
  function _removeManufacturer(address account) internal {
    manufacturers.remove(account);
    // Emits an event to communicate with system that a manufacturer has been removed.
    emit ManufacturerRemoved(account);
  }
}