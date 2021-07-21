var HDWalletProvider = require("truffle-hdwallet-provider");

var mnemonic = "tired silly unit grace loud glide snow social avoid hard vague breeze";
var mnemonicRopsten = "lunar cinnamon blanket split over sheriff slab lounge galaxy since fish enough";

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!

  networks: {
    test: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "http://localhost:8545/");
      },
      network_id: '*',
      gas: 4712388
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonicRopsten, "https://ropsten.infura.io/6NjMuaztDrkkDbfutwfu ");
      },
      network_id: '3',
      gas: 2900000
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
};
