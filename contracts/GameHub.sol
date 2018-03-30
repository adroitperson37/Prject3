pragma solidity ^0.4.17;

import "./Stoppable.sol";
import "./RockPaperScissor.sol";

contract GameHub is Stoppable {

    address[] public games;
    mapping(address => bool) isGameExists;

    modifier onlyGame(address game) {
        require(isGameExists[game]);
        _;
    }

    function getGamesCount() public constant returns(uint count) {
        return games.length;
    }

    function newGame() public returns(address rockPaperScissorGame) {
        RockPaperScissor rockPaperScissor = new RockPaperScissor(2, msg.sender);
        games.push(rockPaperScissor);
        isGameExists[rockPaperScissorGame] = true;
        return rockPaperScissor;
    }


    function stopGame(address game) public onlyOwner onlyGame(game) returns(bool sucess){
     
        RockPaperScissor rockPaperScissor = RockPaperScissor(game);
        return(rockPaperScissor.startOrStop(false)); 

    }

    function startGame(address game) public onlyOwner onlyGame(game) returns(bool sucess){
     
        RockPaperScissor rockPaperScissor = RockPaperScissor(game);
        return(rockPaperScissor.startOrStop(true));
        
    }

    function changeGameOwner(address owner, address newOwner) public onlyOwner onlyGame(owner) returns(bool success){
          
        RockPaperScissor rockPaperScissor = RockPaperScissor(owner);
        return(rockPaperScissor.setOwner(newOwner));

    }




}