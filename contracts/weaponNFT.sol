// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

import "./utils/access/Ownable.sol";
import "./ERC721/ERC721.sol";
import "./ERC20/IERC20.sol";

contract WeaponNFT is Ownable, ERC721 {
    
    event ItemCreated(
        address indexed owner,
        uint256 indexed assetId,
        uint256 indexed tokenId
    );

    struct AssetInfo {
        uint256 assetId;
        string tokenURI;
        uint256 initPrice;
    }

    /* --------------- assetInfos ---------------*/
    
    event ItemAdded (
        uint256 assetId,
        string tokenURI,
        uint256 price
    );
    
    event SetTokenMetadata (
        uint256 assetId,
        uint256 price
    );

    AssetInfo[] public assets;

    /* --------------- tokenInfos --------------- */

    uint256 private _totalSupply;
    
    mapping(uint256 => AssetInfo) public _tokenMetadatas;

    address public AtariTokenAddress;

    /* --------------- userInfo --------------- */
    event Registered(address user, string name);

    mapping(address => bool) public isRegistered;
    mapping(address => string) public users;

    /* --------------- functions --------------- */

    constructor (
        string memory _name,
        string memory _symbol
    )
        Ownable() ERC721(_name, _symbol)
    {
        _totalSupply=0;
    }

    function register(string memory name) external {
        require(isRegistered[msg.sender] == false, "already registered");
        isRegistered[msg.sender] == true;
        users[msg.sender] = name;
        _create(msg.sender, 0);
        _create(msg.sender, 1);
        emit Registered(msg.sender, name);
    }

    function changeName(string memory name) external {
        require(isRegistered[msg.sender] == true, "already registered");
        users[msg.sender] = name;
    }

    function create(
        uint256 _assetId
    )
        external
    {
        require( _existAssets(_assetId), "weapon : asset not exist");
        IERC20(AtariTokenAddress).transferFrom(msg.sender,owner(),assets[_assetId].initPrice);
         
        _create(msg.sender, _assetId);
    }

    function _create(
        address _owner,
        uint256 _assetId
    )
        internal returns (uint256 tokenId)
    {
        tokenId = _totalSupply;
        _totalSupply=_totalSupply+1;

        /// Mint new NFT
        _mint(_owner, tokenId);
        _tokenMetadatas[tokenId] = assets[_assetId];

        emit ItemCreated(_owner, _assetId, tokenId);
    }
    
    function _existAssets(uint256 _assetId) internal view returns (bool) {
        return (assets.length > _assetId);
    }

    /* ------------- view ---------------*/
    
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId));
        return _tokenMetadatas[tokenId].tokenURI;
    }
    
    function totalSupply()external view returns(uint256){
        return _totalSupply;
    }

    
    function totalAssets()external view returns(uint256){
        return assets.length;
    }

    function getAssets(uint256 _assetId) external view 
        returns (
        uint256 assetId,
        string memory URI,
        uint256 initPrice
        )
    {
        assetId = _assetId;
        URI = assets[_assetId].tokenURI;
        initPrice = assets[_assetId].initPrice;
    }

    /* ------------- Update --------------*/

    function setAcceptedToken(address _tokenAddress) external onlyOwner {

        AtariTokenAddress = _tokenAddress;
    }

    function AddAssets(string calldata _tokenURI, uint256 _initPrice) external onlyOwner {
        
        assets.push(AssetInfo(assets.length, _tokenURI, _initPrice));
        emit ItemAdded(assets.length-1, _tokenURI, _initPrice);
    }

    function BatchAddAssets(string[] calldata _tokenURIs, uint256[] calldata _initPrices) external onlyOwner {
        for(uint i = 0; i < _tokenURIs.length; i++){
            assets.push(AssetInfo(assets.length, _tokenURIs[i], _initPrices[i]));
            emit ItemAdded(assets.length-1, _tokenURIs[i], _initPrices[i]);
        }
    }

    function setTokenMetadata(uint256 _assetId, string calldata _tokenURI, uint256 _initPrice) external onlyOwner{
        require(_existAssets(_assetId),"setURI : asset not exist");

        assets[_assetId].tokenURI = _tokenURI;
        assets[_assetId].initPrice = _initPrice;

        emit SetTokenMetadata(_assetId,_initPrice);
    }
}
