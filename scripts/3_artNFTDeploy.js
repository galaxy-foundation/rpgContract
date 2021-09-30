const hre = require("hardhat");

const deployArtNFT =async ()=>{

        const ArtNFT = await hre.ethers.getContractFactory("ArtNFT");
        const artNFT = await ArtNFT.deploy("ArtNFT","ANFT");
        await artNFT.deployed();

        console.log("artNFT deployed to:", artNFT.address);

        return artNFT.address;
}


module.exports = {deployArtNFT}