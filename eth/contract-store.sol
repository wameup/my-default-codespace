pragma solidity ^0.7.5;
contract Storage {
    uint256 public storedData;
    function set(uint256 data) public {
        storedData = data;
    }
    function get() public returns (uint256) {
        return storedData;
    }
}
