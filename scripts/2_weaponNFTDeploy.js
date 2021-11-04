const hre = require("hardhat");
const ipfsHashes = require("../resources/ipfshashes.json");

const getTokenURIS = ()=>{
	
	var _tokenInfos = [];
	_tokenInfos.push({
		tokenURI:{
			weapon_name:"Colt M1911",
			weapon_type:"3",
			damage:"30",
			fire_rate:"0.092",
			reload_time:"2.2",
			shot_range:"550",
			accurency:"2",
			weight:"2"
		},
		price :"1"
	})
	_tokenInfos.push({
		tokenURI:{
			weapon_name:"MP5K",
			weapon_type:"3",
			damage:"30",
			fire_rate:"0.092",
			reload_time:"2.2",
			shot_range:"550",
			accurency:"2",
			weight:"2"
		},
		price :"1"
	})
	_tokenInfos.push({
		tokenURI:{
			weapon_name:"ARTIC",
			weapon_type:"3",
			damage:"30",
			fire_rate:"0.092",
			reload_time:"2.2",
			shot_range:"550",
			accurency:"2",
			weight:"2"
		},
		price :"1"
	})
	_tokenInfos.push({
		tokenURI:{
			weapon_name:"TOXI",
			weapon_type:"3",
			damage:"30",
			fire_rate:"0.092",
			reload_time:"2.2",
			shot_range:"550",
			accurency:"2",
			weight:"2"
		},
		price :"1"
	})
	_tokenInfos.push({
		tokenURI:{
			weapon_name:"SDASS MARTIAL",
			weapon_type:"3",
			damage:"30",
			fire_rate:"0.092",
			reload_time:"2.2",
			shot_range:"550",
			accurency:"2",
			weight:"2"
		},
		price :"1"
	})
	_tokenInfos.push({
		tokenURI:{
			weapon_name:"Dragonov SVD",
			weapon_type:"3",
			damage:"30",
			fire_rate:"0.092",
			reload_time:"2.2",
			shot_range:"550",
			accurency:"2",
			weight:"2"
		},
		price :"1"
	})
	_tokenInfos.push({
		tokenURI:{
			weapon_name:"Knife",
			weapon_type:"3",
			damage:"30",
			fire_rate:"0.092",
			reload_time:"2.2",
			shot_range:"550",
			accurency:"2",
			weight:"2"
		},
		price :"1"
	})
	_tokenInfos.push({
		tokenURI:{
			weapon_name:"Bushmaster ACR",
			weapon_type:"3",
			damage:"30",
			fire_rate:"0.092",
			reload_time:"2.2",
			shot_range:"550",
			accurency:"2",
			weight:"2"
		},
		price :"1"
	})
	_tokenInfos.push({
		tokenURI:{
			weapon_name:"SDASS MARTIAL",
			weapon_type:"3",
			damage:"30",
			fire_rate:"0.092",
			reload_time:"2.2",
			shot_range:"550",
			accurency:"2",
			weight:"2"
		},
		price :"1"
	})
	_tokenInfos.push({
		tokenURI:{
			weapon_name:"M32 MGL",
			weapon_type:"3",
			damage:"30",
			fire_rate:"0.092",
			reload_time:"2.2",
			shot_range:"550",
			accurency:"2",
			weight:"2"
		},
		price :"1"
	})
	var tokenInfos = [];
	_tokenInfos.map ((tokenInfo,index)=>{
		tokenInfos.push({
			tokenURI:{
				...tokenInfo.tokenURI,
				image:ipfsHashes[String(index)]
			},
			price:tokenInfo.price

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
		console.log(tokenInfos[i].tokenURI);
        tokenURIs.push(JSON.stringify(tokenInfos[i].tokenURI));
        prices.push(ethers.utils.parseUnits(tokenInfos[i].price));
	}

    tx = await weaponNFT.BatchAddAssets(tokenURIs ,prices);
    await tx.wait();
	
	return weaponNFT;
}

module.exports = {deployWeaponNFT}