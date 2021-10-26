

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
  
  var atariCoin = await deployAtariCoin();
  // var atariCoin = process.env.ATARICOIN;

  var weapon = await deployWeaponNFT(atariCoin.address);

  var multiCall = await deployMultiCall(weapon.address);

  var market = await deployMarketplace(atariCoin.address);

  //object
  var atariToken = {address:atariCoin.address, abi:AtariCoin.abi};
  var weaponNFT = {address:weapon.address, abi:WeaponNFT.abi};
  var multiCall = {address:multiCall.address, abi:MultiCall.abi};
  var marketPlace = {address:market.address,abi:MarketPlace.abi}

  var contractObject = {atariToken,weaponNFT,multiCall,marketPlace};
  
  fs.writeFile("./exports/gameContracts.json",JSON.stringify(contractObject,null,4), function(err,content){
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
