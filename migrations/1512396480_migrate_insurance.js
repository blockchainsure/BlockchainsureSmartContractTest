var BlockchaInsureCountries = artifacts.require("BlockchaInsureCountries");
var BlockchaInsurePolicy = artifacts.require("BlockchaInsurePolicy");

module.exports = function(deployer) {
  // Use deployer to state migration tasks.
  deployer.deploy(BlockchaInsureCountries).then(function() {
    return deployer.deploy(BlockchaInsurePolicy, BlockchaInsureCountries.address);
  });
}