const hre = require("hardhat");

const deployMultiCall =async (artAddress,eggAddress,petAddress)=>{

        const MultiCall = await hre.ethers.getContractFactory("multicall");
        const multiCall = await MultiCall.deploy();
        await multiCall.deployed();

        console.log("multicall deployed to:", multiCall.address);

        //set config
        
        var tx = await multiCall.setAddresses(artAddress,eggAddress,petAddress);
        await tx.wait();
        
        console.log("multiCall: set art,pet,eggNFT addresses",artAddress,eggAddress,petAddress);
        
        return multiCall.address;
}


module.exports = {deployMultiCall}