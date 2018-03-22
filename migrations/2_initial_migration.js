var RockPaperScissors = artifacts.require("./RockPaperScissor.sol");
var Owner = artifacts.require("./Ownable.sol");

module.exports = function(deployer) {
  deployer.deploy(Owner);
  deployer.deploy(RockPaperScissors);
};
