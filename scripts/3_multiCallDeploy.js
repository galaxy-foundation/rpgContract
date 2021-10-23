const hre = require("hardhat");

const deployMultiCall =async (weaponAddress)=>{

        const MultiCall = await hre.ethers.getContractFactory("multicall");
        const multiCall = await MultiCall.deploy();
        await multiCall.deployed();

        console.log("multicall deployed to:", multiCall.address);

        //set config
        
        var tx = await multiCall.setAddresses(weaponAddress);
        await tx.wait();
        
        console.log("multiCall: set weaponNFT addresses",weaponAddress);
        
        return multiCall;
}


module.exports = {deployMultiCall}