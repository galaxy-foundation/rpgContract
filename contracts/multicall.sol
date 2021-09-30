// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

import "./utils/access/Ownable.sol";
import "./ERC721/ERC721.sol";
import "./Interface/petStructs.sol";


interface IEggNFT is IERC721,PetStructs {
    function create(uint8 _eggType) external returns(uint256 tokenId);
    function getEggInfo(uint256 id) external view returns(uint8[80] memory _mGenome, uint8[80] memory _fGenome,  uint8 _gene, uint256 _mID, uint256 _fID);
    function getEggType(uint256 id) external view returns (uint256 _eggType);
    function bread(address owner,EggInfo memory _eggInfo) external returns (uint256 tokenId) ;
}

interface IPetNFT is IERC721, PetStructs{
    function getPetInfo(uint256 id) external view returns(uint8[80] memory _mGenome, uint8[80] memory _fGenome,  uint8 _gene, uint256 _mID, uint256 _fID);
    function born(address owner,EggInfo memory _eggInfo) external ;
}

interface IArtNFT is IERC721 {
    function tokenURI(uint256 tokenId) external view returns (string memory) ;
}

contract multicall is Ownable {
    address public artNFTAddress;
    address public eggNFTAddress;
    address public petNFTAddress;
    
    function setAddresses(address _artNFTAddress, address _eggNFTAddress, address _petNFTAddress) external onlyOwner{
        artNFTAddress = _artNFTAddress;
        eggNFTAddress = _eggNFTAddress;
        petNFTAddress = _petNFTAddress;
    }
    
    function getArtInfos(uint256[] memory tokenIds) external view returns (address[] memory owners,address[] memory creators,string[] memory URIs){
        owners = new address[](tokenIds.length);
        creators = new address[](tokenIds.length);
        URIs = new string[](tokenIds.length);
        
        IArtNFT artNFTContract = IArtNFT(artNFTAddress);
        
        for (uint256 i=0; i<tokenIds.length; i++){
            owners[i] = artNFTContract.ownerOf(tokenIds[i]);
            creators[i] = artNFTContract.createrOf(tokenIds[i]);
            URIs[i] = artNFTContract.tokenURI(tokenIds[i]);
        }
    }
    
    function getEggInfos(uint256[] memory tokenIds) external view returns (address[] memory owners,address[] memory creators,uint8[][] memory _mGenome, uint8[][] memory _fGenome, uint8[] memory _gene, uint256[] memory _mID, uint256[] memory _fID, uint256[] memory _eggTypes){
        owners = new address[](tokenIds.length);
        creators = new address[](tokenIds.length);
        _mGenome = new uint8[][](tokenIds.length);
        _fGenome = new uint8[][](tokenIds.length);
        _gene = new uint8[](tokenIds.length);
        _mID =  new uint256[](tokenIds.length);
        _fID =  new uint256[](tokenIds.length);
        _eggTypes = new uint256[](tokenIds.length);

        IEggNFT eggNFTContract = IEggNFT(eggNFTAddress);
        
        for (uint256 i=0; i<tokenIds.length; i++){
            owners[i] = eggNFTContract.ownerOf(tokenIds[i]);
            creators[i] = eggNFTContract.createrOf(tokenIds[i]);
            _eggTypes[i] = eggNFTContract.getEggType(tokenIds[i]);
            
            uint8[80] memory mIDtemp;
            uint8[80] memory fIDtemp;
            (mIDtemp,fIDtemp,_gene[i],_mID[i],_fID[i]) = eggNFTContract.getEggInfo(tokenIds[i]);
            
            uint8[]  memory _mIDtemp = new uint8[](80);
            uint8[]  memory _fIDtemp = new uint8[](80);
            for (uint256 j = 0; j < 80; j ++){
                _mIDtemp[j] = mIDtemp[j];
                _fIDtemp[j] = fIDtemp[j];
            }
            _mGenome[i] = _mIDtemp;
            _fGenome[i] = _fIDtemp;
        }
    }
    
    function getPetInfos(uint256[] memory tokenIds) external view returns (address[] memory owners,address[] memory creators,uint8[][] memory _mGenome, uint8[][] memory _fGenome, uint8[] memory _gene, uint256[] memory _mID, uint256[] memory _fID){
        owners = new address[](tokenIds.length);
        creators = new address[](tokenIds.length);
        _mGenome = new uint8[][](tokenIds.length);
        _fGenome = new uint8[][](tokenIds.length);
        _gene = new uint8[](tokenIds.length);
        _mID =  new uint256[](tokenIds.length);
        _fID =  new uint256[](tokenIds.length);
        
        IPetNFT petNFTContract = IPetNFT(petNFTAddress);
        
        for (uint256 i=0; i<tokenIds.length; i++){
            owners[i] = petNFTContract.ownerOf(tokenIds[i]);
            creators[i] = petNFTContract.createrOf(tokenIds[i]);
            
            uint8[80] memory mIDtemp;
            uint8[80] memory fIDtemp;
            (mIDtemp,fIDtemp,_gene[i],_mID[i],_fID[i]) = petNFTContract.getPetInfo(tokenIds[i]);
            
            uint8[]  memory _mIDtemp = new uint8[](80);
            uint8[]  memory _fIDtemp = new uint8[](80);
            for (uint256 j = 0; j < 80; j ++){
                _mIDtemp[j] = mIDtemp[j];
                _fIDtemp[j] = fIDtemp[j];
            }
            _mGenome[i] = _mIDtemp;
            _fGenome[i] = _fIDtemp;
        }
    }
}