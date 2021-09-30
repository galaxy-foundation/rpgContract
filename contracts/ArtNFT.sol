// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

import "./utils/access/Ownable.sol";
import "./ERC721/ERC721.sol";

contract ArtNFT is Ownable, ERC721 {
    
    uint256 private _totalSupply;
    
    mapping(uint256 => string) private _tokenURIs;

    event ItemCreated(
        address indexed owner,
        uint256 indexed tokenId
    );

    // Used to correctly support fingerprint verification for the assets
    bytes4 public constant _INTERFACE_ID_ERC721_VERIFY_FINGERPRINT = bytes4(
        keccak256("verifyFingerprint(uint256,bytes32)")
    );

    constructor (
        string memory _name,
        string memory _symbol
    )
        Ownable() ERC721(_name, _symbol)
    {
        _totalSupply=0;
    }
    
    /**
     * @dev Returns an URI for a given token ID
     * Throws if the token ID does not exist. May return an empty string.
     * @param tokenId uint256 ID of the token to query
     */
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId));
        return _tokenURIs[tokenId];
    }
    
    function totalSupply()external view returns(uint256){
        return _totalSupply;
    }

    function create(
        string calldata _metaDataURI
    )
        external
    {
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

        emit ItemCreated(_owner, tokenId);
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
