const hre = require("hardhat");

const deployMarketplace =async  (petCoin)=>{

    const Marketplace = await hre.ethers.getContractFactory("Marketplace");
    const marketplace = await Marketplace.deploy(petCoin);

    await marketplace.deployed();
    
    console.log("marketplace deployed to:", marketplace.address);
    
    return marketplace.address;
}


module.exports = {deployMarketplace}