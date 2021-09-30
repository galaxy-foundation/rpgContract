require('dotenv').config();
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  networks: {
    localhost: {
      url: "http://127.0.0.1:7545"
    },
    hardhat: {
    },
    fantomtestnet: {
      url: "https://rpc.testnet.fantom.network",
      accounts: [process.env.PRIVATEKEY]
    }
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: "WQKQ9RXXCTK715PKG1H7JUMV4ZEUW3KKXN"
  },
  solidity: "0.8.4", 
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  },
  mocha: {
    timeout: 200000
  }
};
