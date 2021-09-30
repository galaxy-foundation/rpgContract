// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

import "./utils/access/Ownable.sol";
import "./ERC721/ERC721.sol";
import "./ERC20/IERC20.sol";

contract weapons is Ownable, ERC721 {
    
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
        uint256 price,
    );

    AssetInfo[] public assets;

    /* --------------- tokenInfos --------------- */

    uint256 private _totalSupply;
    
    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => AssetInfo) public _tokenMetadatas;

    address public AtariTokenAddress;

    /* */

    constructor (
        string memory _name,
        string memory _symbol
    )
        Ownable() ERC721(_name, _symbol)
    {
        _totalSupply=0;
    }
    
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId));
        return _tokenMetadatas[tokenId].tokenURI;
    }
    
    function totalSupply()external view returns(uint256){
        return _totalSupply;
    }

    function create(
        uint256 _assetId
    )
        external
    {
        require(assets.length >= _assetId, "weapon : asset not exist");
        IERC20(AtariTokenAddress).transferFrom(assets[_assetId].initPrice);
         
        _create(msg.sender, _metaDataURI);
    }

    function createPub(
        string calldata _metaDataURI,
        address _marketplace
    )
        external
    {
        // Create the new asset and allow marketplace to manage it
        // Use this to override the msg.sender here.
        this.approve(
            _marketplace,
            _create(msg.sender, _metaDataURI)
        );
    }

    function _create(
        address _owner,
        string calldata _metaDataURI
    )
        internal returns (uint256 tokenId)
    {
        tokenId = _totalSupply;
        _totalSupply=_totalSupply+1;

        /// Mint new NFT
        _mint(_owner, tokenId);
        _setTokenURI(tokenId, _metaDataURI);

        emit ItemCreated(_owner, 0, tokenId);
    }
    
    /**
     * @dev Internal function to set the token URI for a given token
     * Reverts if the token ID does not exist
     * @param tokenId uint256 ID of the token to set its URI
     * @param uri string URI to assign
     */
    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        require(_exists(tokenId));
        _tokenURIs[tokenId] = uri;
    }
    
}
