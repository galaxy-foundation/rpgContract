

const fs = require('fs');

const {deployAtariCoin} = require ("./1_atariCoinDeploy");
const {deployWeaponNFT} = require ("./2_weaponNFTDeploy")
const {deployMultiCall} = require ("./3_multiCallDeploy")
const {deployMarketplace} = require ("./4_marketplaceDeploy")

const AtariCoin = require("../artifacts/contracts/atariCoin.sol/AtariCoin.json");
const WeaponNFT = require("../artifacts/contracts/weaponNFT.sol/WeaponNFT.json");
const MultiCall = require("../artifacts/contracts/multicall.sol/multicall.json");
const MarketPlace = require("../artifacts/contracts/Marketplace.sol/Marketplace.json");

async function main() {

  // local test
  
  var atariCoinAddress = await deployAtariCoin();
  // var atariCoin = process.env.ATARICOIN;

  var weaponAddress = await deployWeaponNFT(atariCoinAddress);

  var multiCallAddress = await deployMultiCall(weaponAddress);

  var marketAddress = await deployMarketplace(atariCoinAddress);

  //object
  var atariToken = {address:atariCoinAddress, abi:AtariCoin.abi};
  var weaponNFT = {address:weaponAddress, abi:WeaponNFT.abi};
  var multiCall = {address:multiCallAddress, abi:MultiCall.abi};
  var marketPlace = {address:marketAddress,abi:MarketPlace.abi}

  var contractObject = {atariToken,weaponNFT,multiCall,marketPlace};
  
  fs.writeFile("./exports/contracts/4002.json",JSON.stringify(contractObject,null,4), function(err,content){
          if (err) throw err;
          console.log('complete');
  });

}

main()
  .then(() => {
    // process.exit(0)
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
