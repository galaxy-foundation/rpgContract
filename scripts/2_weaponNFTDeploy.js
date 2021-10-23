const hre = require("hardhat");

const deployWeaponNFT =async (atariCoin)=>{

	//weapon

	const WeaponNFT = await hre.ethers.getContractFactory("WeaponNFT");
	const weaponNFT = await WeaponNFT.deploy("ATARI Weapon","AWP");
	await weaponNFT.deployed();

	console.log("weaponNFT deployed to:", weaponNFT.address);
	
	//config

	var tx = await weaponNFT.setAcceptedToken(atariCoin);
	await tx.wait();

	var tokenInfos = [];
	tokenInfos.push({
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
	tokenInfos.push({
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
	tokenInfos.push({
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
	tokenInfos.push({
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
	tokenInfos.push({
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
	tokenInfos.push({
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
	tokenInfos.push({
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
	tokenInfos.push({
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
	tokenInfos.push({
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
	tokenInfos.push({
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
	//init asssets
	for(var i=0; i<10; i++) {
		tx = await weaponNFT.AddAssets(JSON.stringify(tokenInfos[i].tokenURI) ,ethers.utils.parseUnits(tokenInfos[i].price));
		await tx.wait();
	}
	
	return weaponNFT;
}

module.exports = {deployWeaponNFT}