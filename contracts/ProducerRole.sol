pragma solidity ^0.5.16;

import "./Roles.sol";

contract ProducerRole {
  using Roles for Roles.Role;

  event ProducerAdded(address indexed account);
  event ProducerRemoved(address indexed account);

  Roles.Role private producers;

  constructor() public {
    _addProducer(msg.sender);
  }

  modifier onlyProducer() {
    require(isProducer(msg.sender), "Sender is not a Producer" );
    _;
  }

  function isProducer(address account) public view returns (bool) {
    return producers.has(account);
  }

  function addProducer(address account) public onlyProducer{
    _addProducer(account);
  }

  function renounceProducer() public {
    _removeProducer(msg.sender);
  }

  function _addProducer(address account) internal {
    producers.add(account);
    emit ProducerAdded(account);
  }

  function _removeProducer(address account) internal {
    producers.remove(account);
    emit ProducerRemoved(account);
  }
}