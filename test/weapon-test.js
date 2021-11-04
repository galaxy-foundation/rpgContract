const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Weapon test",()=>{
    var coin;
    it("coin deploy",async ()=>{
        const Coin = await hre.ethers.getContractFactory("AtariCoin");
        coin = await Coin.deploy();
    });

    var weaponNFT;
    it("weaponNFT deploy and config",async ()=>{
        const WeaponNFT = await hre.ethers.getContractFactory("WeaponNFT");
        weaponNFT = await WeaponNFT.deploy("ATARI Weapon","AWP");
        await weaponNFT.deployed();

        var tx = await weaponNFT.setAcceptedToken(coin.address);
        await tx.wait();

        var tokenURIS = [];
        var prices = [];
        //init asssets
        for(var i=0; i<10; i++) {
            tx = await weaponNFT.AddAssets("test"+i.toString(),10000000);
            await tx.wait();
            tokenURIS.push("test"+(i+10).toString());
            prices.push(10000000);
        }

        tx = await weaponNFT.BatchAddAssets(tokenURIS,prices);
        await tx.wait();
    });

    it("weaponNFT test", async ()=>{
        var tx =await coin.approve(weaponNFT.address,10000000000);
        await tx.wait();

        tx =await weaponNFT.create(0);
        await tx.wait()
    });
})