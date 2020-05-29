pragma solidity ^0.5.16;

import "./Roles.sol";

contract SupplierRole {
  using Roles for Roles.Role;

  event SupplierAdded(address indexed account);
  event SupplierRemoved(address indexed account);

  Roles.Role private suppliers;

  constructor() public {
    _addSupplier(msg.sender);
  }

  modifier onlySupplier() {
    require(isSupplier(msg.sender), "Sender is not a Supplier" );
    _;
  }

  function isSupplier(address account) public view returns (bool) {
    return suppliers.has(account);
  }

  function addSupplier(address account) public onlySupplier{
    _addSupplier(account);
  }

  function renounceSupplier() public {
    _removeSupplier(msg.sender);
  }

  function _addSupplier(address account) internal {
    suppliers.add(account);
    emit SupplierAdded(account);
  }

  function _removeSupplier(address account) internal {
    suppliers.remove(account);
    emit SupplierRemoved(account);
  }
}