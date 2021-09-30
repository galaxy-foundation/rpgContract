const hre = require("hardhat");

const deployPetCoin =async ()=>{

        const PetCoin = await hre.ethers.getContractFactory("PetCoin");
        const petCoin = await PetCoin.deploy();

        await petCoin.deployed();
        
        console.log("petCoin deployed to:", petCoin.address);
        return petCoin.address;
}


module.exports = {deployPetCoin}