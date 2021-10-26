const ipfs = require("./ipfs_api");
const fs = require('fs');

const upload_IFPS =async (Num)=>{
    const basic_ipfs_url = "https://ipfs.io/ipfs/";

    const basic_file_path = "./resources/videos/";
    var ipfsHashes = {};
    for (var i = 0; i < Num; i++) {
        const contents = fs.readFileSync(basic_file_path+i+".mp4");
        console.log(basic_file_path+i+".mp4");
        var result = await ipfs.files.add(contents);
        var ipfsHash = "https://ipfs.io/ipfs/"+result[0].hash;
        console.log(ipfsHash);
        ipfsHashes[i] = ipfsHash;
    } 
    fs.writeFile("./resources/ipfshashes.json",JSON.stringify(ipfsHashes,null,4), function(err,content){
        if (err) throw err;
        console.log('complete');
});
}

upload_IFPS(10)