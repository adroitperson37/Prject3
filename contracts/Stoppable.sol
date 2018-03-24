pragma solidity ^0.4.17;


import "./Ownable.sol";


/**
 * The contractName contract does this and that...
 */
contract Stoppable is Ownable {

    bool public isOn;

    function Stoppable () public {
        isOn = true;
    }

    function startOrStop (bool on)  public onlyOwner returns(bool success) {
        isOn = on;
        return true;
    }

    modifier isRunning() {
        require(isOn == true);
        _;
    }

}
