const hre = require("hardhat");
const ipfsHashes = require("../resources/ipfshashes.json");

const weaponInfos = require("../resources/weaponInfos.json")

const getTokenURIS = ()=>{
	var keys = Object.keys(weaponInfos);
	var tokenInfos = [];
	keys.map ((key,index)=>{
		tokenInfos.push({
			tokenURI:{
				...weaponInfos[key],
				image:ipfsHashes[key],
                name : key
			},
			price:weaponInfos[key].Price
		})
	})

	return tokenInfos;
}
const deployWeaponNFT =async (atariCoin)=>{

	const WeaponNFT = await hre.ethers.getContractFactory("WeaponNFT");
	const weaponNFT = await WeaponNFT.deploy("ATARI Weapon","AWP");
	await weaponNFT.deployed();

	console.log("weaponNFT deployed to:", weaponNFT.address);
	
	//config

	var tx = await weaponNFT.setAcceptedToken(atariCoin);
	await tx.wait();

	var tokenInfos = getTokenURIS();

    var tokenURIs = [];
    var prices = [];
	//init asssets
	for(var i=0; i<tokenInfos.length; i++) {
		console.log(tokenInfos[i]);
        tokenURIs.push(JSON.stringify(tokenInfos[i].tokenURI));
        prices.push(ethers.utils.parseUnits(tokenInfos[i].price));
	}

    tx = await weaponNFT.BatchAddAssets(tokenURIs ,prices);
    await tx.wait();
	
	return weaponNFT;
}

module.exports = {deployWeaponNFT}