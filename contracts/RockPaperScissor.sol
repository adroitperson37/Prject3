pragma solidity ^0.4.17;

import "./Stoppable.sol";

contract RockPaperScissor is Stoppable {


    struct Player {
        address playerAddress;
        bytes8 bet;
        uint betAmount;
        bytes32 hashValue;
        bool isCommitted;      
    }

    bytes8  public constant ROCK = "ROCK";
    bytes8  public constant PAPER = "PAPER";
    bytes8  public constant SCISSORS = "SCISSORS";
    uint public numberOfPlayers;
    Player public winningPlayer;
    mapping(address => Player) public playerBets;
    mapping(uint => address) public players;
    address public gameOwner;

    event LogCreatePlayer(address from, uint amountSent, bytes32 committedHash);
    event LogBidPlace(address from, bytes8 bidValue, bytes32 committedHash);
    event LogWinnerNotification(address winner, uint amountWon);


    modifier onlyGameOwner() {
        require(msg.sender == gameOwner);
        _;
    }

    
    function RockPaperScissor(uint noOfPlayers, address gameCreator) public {
        gameOwner = gameCreator;
        numberOfPlayers = noOfPlayers;

    }
//Function to create player .it only allows to create two players and restricts already registered player.

    function createPlayer(bytes32 committedHash) public isRunning payable {
        require(msg.sender != owner);
        require(playerBets[msg.sender].playerAddress == address(0));
        require(numberOfPlayers < 2);

        Player memory player;
        player.playerAddress = msg.sender;
        player.betAmount = msg.value;
        player.hashValue = committedHash;
        playerBets[msg.sender] = player;
        numberOfPlayers++;
        players[numberOfPlayers] = msg.sender;
        LogCreatePlayer(msg.sender, msg.value, committedHash);
    }

//Used to play bids. It verifies that the address from which bid comes in already exisits or not.
    function placeBid(bytes8 bidValue, bytes32 committedHash) public isRunning returns(bool success) {
        require(numberOfPlayers == 2);
        require(playerBets[msg.sender].playerAddress == msg.sender);
        require(playerBets[msg.sender].hashValue == committedHash);
        require(bidValue != bytes8(0));
        require(checkIfbidValueExists(bidValue));
        playerBets[msg.sender].bet = bidValue;
        LogBidPlace(msg.sender, bidValue, committedHash);
        return true;

    }

// //Get HashValue 
    function getHash(bytes32 bidValue, bytes32 uniqueValue) public pure returns(bytes32 hash) {
        return keccak256(bidValue, uniqueValue);
    }


//Once both players are registered. The owner can start the play and decide the winner.

    function play() public onlyGameOwner isRunning {
        require(numberOfPlayers == 2);

        bytes8 player1Bet = playerBets[players[1]].bet;
        bytes8 player2Bet = playerBets[players[2]].bet;

        if (player1Bet == ROCK) {
            if (player2Bet == PAPER) {
                winningPlayer = playerBets[players[2]];
                winningPlayer.betAmount += playerBets[players[1]].betAmount;
            }else if (player2Bet == SCISSORS) {
                winningPlayer = playerBets[players[1]];
                winningPlayer.betAmount += playerBets[players[2]].betAmount;
            }
        }else if (player1Bet == PAPER) {
            if (player2Bet == ROCK) {
                winningPlayer = playerBets[players[1]];
                winningPlayer.betAmount += playerBets[players[2]].betAmount;
            }else if (player2Bet == SCISSORS) {
                winningPlayer = playerBets[players[2]];
                winningPlayer.betAmount += playerBets[players[1]].betAmount;
            }
        }else if (player1Bet == SCISSORS) {
            if (player2Bet == ROCK) {
                winningPlayer = playerBets[players[2]];
                winningPlayer.betAmount += playerBets[players[1]].betAmount;
            }else if (player2Bet == PAPER) {
                winningPlayer = playerBets[players[1]];
                winningPlayer.betAmount += playerBets[players[2]].betAmount;
            }
        }

    }

//Owner can withdraw the funds once he is notified as winner.
    function winnerWithdraw() public isRunning {
        require(winningPlayer.playerAddress == msg.sender);
        require(winningPlayer.betAmount>0);

        uint amount = winningPlayer.betAmount;
        winningPlayer.betAmount = 0;
        LogWinnerNotification(msg.sender, amount);
        msg.sender.transfer(amount);
    }

    function checkIfbidValueExists(bytes32 bidValue) private pure returns(bool exists) {

         //tried somthings like
        if (bidValue == ROCK || bidValue == PAPER || bidValue == SCISSORS) {
            return true;
        }else {
            return false;
        }
    }

}