pragma solidity ^0.4.17;

import "./Ownable.sol";

contract RockPaperScissor is Ownable {
    

    struct Player {
        address playerAddress;
        bytes32 bet;
        uint betAmount;
    }

    bytes32  public constant ROCK = "ROCK";
    bytes32  public constant PAPER = "PAPER";
    bytes32  public constant SCISSORS = "SCISSORS";
    uint public numberOfPlayers;
    Player public winningPlayer;
    mapping(address => Player) public playerBets;
    mapping(uint => address) public players;

    event LogCreatePlayer(address from, uint amountSent);
    event LogBidPlace(address from, bytes32 bidValue);
    event LogWinnerNotification(address winner,uint amountWon);
    


//Function to create player .it only allows to create two players and restricts already registered player.

    function createPlayer() public payable{
        require(msg.sender!=owner);
        require(playerBets[msg.sender].playerAddress == address(0));
        require(numberOfPlayers<2);

        Player memory player;
        player.playerAddress = msg.sender;
        player.betAmount = msg.value;
        playerBets[msg.sender] = player;
        numberOfPlayers++;
        players[numberOfPlayers] = msg.sender;
        LogCreatePlayer(msg.sender,msg.value);
    }

//Used to play bids. It verifies that the address from which bid comes in already exisits or not.
    function placeBid(bytes32 bidValue) public returns(bool success){
        require(playerBets[msg.sender].playerAddress == msg.sender);
        require(bidValue!=bytes32(0));
        require(checkIfbidValueExists(bidValue));
        
    
        playerBets[msg.sender].bet = bidValue;
        LogBidPlace(msg.sender,bidValue);
        return true;

    }

//Once both players are registered. The owner can start the play and decide the winner.

    function play() public onlyOwner {
      
        bytes32 player1Bet = playerBets[players[1]].bet;
        bytes32 player2Bet = playerBets[players[2]].bet;

        if(player1Bet == ROCK){
            if(player2Bet == PAPER) {
                winningPlayer = playerBets[players[2]];
                winningPlayer.betAmount += playerBets[players[1]].betAmount;
            }
            else if(player2Bet == SCISSORS) {
                winningPlayer = playerBets[players[1]];
                winningPlayer.betAmount += playerBets[players[2]].betAmount;
            }
        }
        else if(player1Bet == PAPER) {
            if(player2Bet == ROCK) {
                winningPlayer = playerBets[players[1]];
                winningPlayer.betAmount += playerBets[players[2]].betAmount;
            }
            else if(player2Bet == SCISSORS) {
                winningPlayer = playerBets[players[2]];
                winningPlayer.betAmount += playerBets[players[1]].betAmount;
            }
        }
        else if(player1Bet == SCISSORS) {
            if(player2Bet == ROCK) {
                winningPlayer = playerBets[players[2]];
                winningPlayer.betAmount += playerBets[players[1]].betAmount;
            }
            else if(player2Bet == PAPER) {
                winningPlayer = playerBets[players[1]];
                winningPlayer.betAmount += playerBets[players[2]].betAmount;
            }
        }

    }

//Owner can withdraw the funds once he is notified as winner.
    function winnerWithdraw() public {
        require(winningPlayer.playerAddress == msg.sender);
        require(winningPlayer.betAmount>0);

        uint amount = winningPlayer.betAmount;
        winningPlayer.betAmount = 0;
        LogWinnerNotification(msg.sender,amount);
        msg.sender.transfer(amount);
    }

    function checkIfbidValueExists(bytes32 bidValue) private pure returns(bool exists) {

         //tried somthings like
        if(bidValue == ROCK || bidValue == PAPER || bidValue == SCISSORS){
            return true;
        }
        else{
            return false;
        }
    }

}