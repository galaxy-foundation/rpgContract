const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Marketplace", function () {
    var petCoinAddress;
    it("petCoin deploy", async function () {

        const PetCoin = await ethers.getContractFactory("PetCoin");
        const petCoin = await PetCoin.deploy();

        await petCoin.deployed();

        console.log("petCoin deployed to:", petCoin.address);
        petCoinAddress = petCoin.address;
    });

    it("Marketplace testing", async function () {
        
        const Marketplace = await ethers.getContractFactory("Marketplace");
        const marketplace = await Marketplace.deploy(petCoinAddress);

        await marketplace.deployed();

        console.log("marketplace deployed to:", marketplace.address);
        expect(await marketplace.acceptedToken()).to.equal(petCoinAddress);

    });
});
