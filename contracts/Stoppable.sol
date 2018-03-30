pragma solidity ^0.4.17;


import "./Ownable.sol";


/**
 * The contractName contract does this and that...
 */
contract Stoppable is Ownable {

    bool public isOn;
    event LogStartOrStop(address indexed sender, bool indexed startOrStop);

    function Stoppable () public {
        isOn = true;
    }

    function startOrStop (bool on)  public onlyOwner returns(bool success) {
        isOn = on;
        LogStartOrStop(msg.sender, on);
        return true;
    }

    modifier isRunning() {
        require(isOn == true);
        _;
    }

}
