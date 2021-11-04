const ipfs = require("./ipfs_api");
const fs = require('fs');
const weaponInfos = require("../../resources/weaponInfos.json")

function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time));
}

const upload_IFPS =async (Num)=>{
    const basic_ipfs_url = "https://ipfs.io/ipfs/";

    const basic_file_path = "./resources/videos/";
    var ipfsHashes = {};

    var keys = Object.keys(weaponInfos);
    for (var i = 0; i < keys.length; i++) {
        const contents = fs.readFileSync(basic_file_path+keys[i]+".mp4");
        console.log(basic_file_path+i+".mp4");
        
        var result = await ipfs.files.add(contents);
        var ipfsHash = basic_ipfs_url+result[0].hash;
        console.log(ipfsHash);
        ipfsHashes[keys[i]] = ipfsHash;

        await delay(10000);
    } 
    fs.writeFile("./resources/ipfshashes.json",JSON.stringify(ipfsHashes,null,4), function(err,content){
        if (err) throw err;
        console.log('complete');
});
}

upload_IFPS(10)