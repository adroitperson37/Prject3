var RockPaperScissor = artifacts.require("./RockPaperScissor.sol");



contract('RockPaperScissor',function(accounts){

    var instance;
    var owner = accounts[0];
    var playerOne = accounts[1];
    var playerTwo = accounts[2];
    var playerOneBet ="ROCK";
    var playerTwoBet="PAPER";



    describe("Testing RockPaperScissor",() => {
        
         beforeEach('create new instance of RockPaperScissor', () =>{
                 return RockPaperScissor.new({from:owner}).then(
                     ins => {
                          instance = ins;
                     }
                 )
         });
        
    it('Checks the entire Transactions', () => {
          return instance.createPlayer({from:playerOne,value:10}).then(
            transactionObject => {
                assert.strictEqual(playerOne,transactionObject.logs[0].args.from);
                assert.strictEqual(10,transactionObject.logs[0].args.amountSent.toNumber());
                return instance.createPlayer({from:playerTwo,value:20});
                  }
          ).then(
            transactionObject => {
                assert.strictEqual(playerTwo,transactionObject.logs[0].args.from);
                assert.strictEqual(20,transactionObject.logs[0].args.amountSent.toNumber());
                return instance.numberOfPlayers.call({from:owner});
            }
          ).then(
              valueObject => {
                assert.strictEqual(2,valueObject.toNumber());
                return instance.placeBid(playerOneBet,{from:playerOne});
              }
          ).then(
            transactionObject => {
                assert.strictEqual(playerOne,transactionObject.logs[0].args.from);
                assert.strictEqual(playerOneBet,web3.toUtf8(transactionObject.logs[0].args.bidValue));
                return instance.placeBid(playerTwoBet,{from:playerTwo});
            }              
          ).then(
            transactionObject => {
                assert.strictEqual(playerTwo,transactionObject.logs[0].args.from);
                assert.strictEqual(playerTwoBet,web3.toUtf8(transactionObject.logs[0].args.bidValue));
                return instance.play({from:owner});
            }  
          ).then(
              transactionObject => {
               return instance.winningPlayer.call({from:owner});
              }
          ).then(
              valueObject => {
                  assert.strictEqual(playerTwo,valueObject[0]);
                  return instance.winnerWithdraw({from:playerTwo});
              }
          ).then(
             transactionObject =>{
                 assert.strictEqual(playerTwo,transactionObject.logs[0].args.winner);
                 assert.strictEqual(30,transactionObject.logs[0].args.amountWon.toNumber());
             }
          )
    });

 });
});