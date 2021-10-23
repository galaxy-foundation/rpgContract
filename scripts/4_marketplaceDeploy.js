const hre = require("hardhat");

const deployMarketplace =async  (atariCoin)=>{

    const Marketplace = await hre.ethers.getContractFactory("Marketplace");
    const marketplace = await Marketplace.deploy(atariCoin);

    await marketplace.deployed();
    
    console.log("marketplace deployed to:", marketplace.address);
    
    return marketplace;
}

module.exports = {deployMarketplace}