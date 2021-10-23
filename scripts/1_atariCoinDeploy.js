const hre = require("hardhat");

const deployAtariCoin =async ()=>{

        const AtariCoin = await hre.ethers.getContractFactory("AtariCoin");
        const atariCoin = await AtariCoin.deploy();

        await atariCoin.deployed();
        
        console.log("atariCoin deployed to:", atariCoin.address);
        return atariCoin
}


module.exports = {deployAtariCoin}