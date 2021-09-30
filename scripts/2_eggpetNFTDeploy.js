const hre = require("hardhat");

const deployEggPetNFT =async (petCoin)=>{

        //library
        
        const RandomLibrary = await hre.ethers.getContractFactory("RandomLibrary");
        const randomLibrary = await RandomLibrary.deploy();
        await randomLibrary.deployed();

        console.log("randomLibrary deployed to:", randomLibrary.address);

        //egg

        const EggNFT = await hre.ethers.getContractFactory("EggNFT",{
                libraries: {
                        RandomLibrary:randomLibrary.address
                }
        });
        const eggNFT = await EggNFT.deploy("EggNFT","ENFT");
        await eggNFT.deployed();

        console.log("eggNFT deployed to:", eggNFT.address);

        //pet

        const PetNFT = await hre.ethers.getContractFactory("PetNFT",{
                libraries: {
                        RandomLibrary:randomLibrary.address
                }
        });
        const petNFT = await PetNFT.deploy("PetNFT","PNFT");
        await petNFT.deployed();

        console.log("petNFT deployed to:", petNFT.address);
        
        //config
        //eggNFT

        var tx = await eggNFT.setAcceptedToken(petCoin);
        await tx.wait();
        tx = await eggNFT.setPetContract(petNFT.address);
        await tx.wait();

        console.log("EggNFT: set petContract to ",await eggNFT.petContract());

        //petNFT

        tx = await petNFT.setAcceptedToken(petCoin);
        await tx.wait();
        tx = await petNFT.setEggContract(eggNFT.address);
        await tx.wait();

        console.log("PetNFT: set eggContract to ",await petNFT.eggContract());

        //
        let eggAddress = eggNFT.address;
        let petAddress = petNFT.address;
        
        return {eggAddress,petAddress};
}

module.exports = {deployEggPetNFT}