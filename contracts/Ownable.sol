pragma solidity ^0.4.17;

contract Ownable {

    address  public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function Ownable() public {
        owner = msg.sender;
    }

    function setOwner (address newOwner) public onlyOwner returns(bool res) {
        owner = newOwner;
        return true;
    }
    

}