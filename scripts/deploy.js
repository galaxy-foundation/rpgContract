

const fs = require('fs');

const {deployPetCoin} = require ("./1_petCoinDeploy");
const {deployEggPetNFT} = require ("./2_eggpetNFTDeploy")
const {deployArtNFT} = require ("./3_artNFTDeploy")
const {deployMultiCall} = require ("./4_multiCallDeploy")
const {deployMarketplace} = require ("./5_marketplaceDeploy")

const PetCoin = require("../artifacts/contracts/petCoin.sol/PetCoin.json");
const EggNFT = require("../artifacts/contracts/eggNFT.sol/EggNFT.json");
const PetNFT = require("../artifacts/contracts/petNFT.sol/PetNFT.json");
const ArtNFT = require("../artifacts/contracts/ArtNFT.sol/ArtNFT.json");
const MultiCall = require("../artifacts/contracts/multicall.sol/multicall.json");
const MarketPlace = require("../artifacts/contracts/Marketplace.sol/Marketplace.json");

async function main() {

  // local test
  
  var petWorldCoin = await deployPetCoin();
  // var petWorldCoin = process.env.PETWORLDCOIN;
  var {eggAddress,petAddress} = await deployEggPetNFT(petWorldCoin);
  var artAddress = await deployArtNFT();

  var multiCallAddress = await deployMultiCall(artAddress,eggAddress,petAddress);

  var marketAddress = await deployMarketplace(petWorldCoin);

  //object
  var petWorldCoin = {address:petWorldCoin, abi:PetCoin.abi};
  var artNFT = {address:artAddress, abi:ArtNFT.abi};
  var eggNFT = {address:eggAddress, abi:EggNFT.abi};
  var petNFT = {address:petAddress, abi:PetNFT.abi};
  var multiCall = {address:multiCallAddress, abi:MultiCall.abi};
  var marketPlace = {address:marketAddress,abi:MarketPlace.abi}


  var contractObject = {petWorldCoin,artNFT,eggNFT,petNFT,multiCall,marketPlace};
  
  fs.writeFile("./exports/contracts/gameContracts.json",JSON.stringify(contractObject,null,4), function(err,content){
          if (err) throw err;
          console.log('complete');
  });

  //fantom testnet
  // await deployMarketplace(process.env.PETWORLDCOIN);
}

main()
  .then(() => {
    // process.exit(0)
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
