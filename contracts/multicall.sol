// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

import "./utils/access/Ownable.sol";
import "./ERC721/ERC721.sol";

interface IWeaponNFT is IERC721{
    function tokenURI(uint256 id) external view returns(string memory);
    function getAssets(uint256 _assetId) external view 
        returns (
        uint256 assetId,
        string memory URI,
        uint256 initPrice
        );
}

contract multicall is Ownable {
    address public weaponNFTAddress;
    
    function setAddresses(address _weaponNFTAddress) external onlyOwner{
        weaponNFTAddress = _weaponNFTAddress;
    }
    
    function getWeaponInfos(uint256[] memory _tokenIds) external view returns (address[] memory owners,address[] memory creators,string[] memory tokenURIs){
        owners = new address[](_tokenIds.length);
        creators = new address[](_tokenIds.length);
        tokenURIs = new string[](_tokenIds.length);
        
        IWeaponNFT weaponNFT = IWeaponNFT(weaponNFTAddress);
        
        for (uint256 i=0; i<_tokenIds.length; i++){
            owners[i] = weaponNFT.ownerOf(_tokenIds[i]);
            creators[i] = weaponNFT.createrOf(_tokenIds[i]);
            tokenURIs[i] = weaponNFT.tokenURI(_tokenIds[i]);
        }
    }
    
    function getWeaponAssetInfos(uint256[] memory _assetIds) external view returns (uint256[] memory assetIds,string[] memory tokenURIs,uint256[] memory initPrices){ 
        assetIds = new uint256[](_assetIds.length);
        tokenURIs = new string[](_assetIds.length);
        initPrices = new uint256[](_assetIds.length);
        
        IWeaponNFT weaponNFT = IWeaponNFT(weaponNFTAddress);
        
        for (uint256 i=0; i<assetIds.length; i++){
            (assetIds[i],tokenURIs[i],initPrices[i]) = weaponNFT.getAssets(_assetIds[i]);
        }
    }
}