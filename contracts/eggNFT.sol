// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

import "./utils/access/Ownable.sol";
import "./ERC721/ERC721.sol";
import "./utils/random.sol";
import "./ERC20/IERC20.sol";
import "./Interface/petStructs.sol";

interface IEggNFT is IERC721,PetStructs {
    function create(uint8 _eggType) external returns(uint256 tokenId);
    function getEggInfo(uint256 id) external view returns(uint8[80] memory _mGenome, uint8[80] memory _fGenome,  uint8 _gene, uint256 _mID, uint256 _fID);
    function getEggType(uint256 id) external view returns (uint256 _eggType);
    function breed(address owner,EggInfo memory _eggInfo) external returns (uint256 tokenId) ;
}

interface IPetNFT is IERC721, PetStructs{

    function getPetInfo(uint256 id) external view returns(uint8[80] memory _mGenome, uint8[80] memory _fGenome,  uint8 _gene, uint256 _mID, uint256 _fID);
    function born(address owner,EggInfo memory _eggInfo) external ;
}

contract EggNFT is IEggNFT, Ownable, ERC721 {
    
    event ItemCreated(
        address indexed owner,
        uint256 indexed tokenId
    );

    event Born(
        address indexed owner,
        uint256 indexed tokenId
    );

    //DNA types : Adenine, Cytosine, Thymine, Guanine
    bytes private GeneType = "ACGT"; 

    //token Data
    uint256 private _totalSupply;
    mapping(uint256 => string) private _tokenURIs;

    mapping(uint256 => EggInfo) public eggInfos;
    mapping(uint256 => uint256) public eggTypes;

    // accepted token
    IERC20 public petCoin;
    uint256[3] public prices;

    // petContract 
    address public petContract;

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
        prices[2] = 20 * 10**18;
        prices[1] = 40 * 10**18;
        prices[0] = 160 * 10**18;
    }

    function setAcceptedToken(address _petCoinAddress) external onlyOwner {
        petCoin = IERC20(_petCoinAddress);
    }

    function setPetContract(address _petContract) external onlyOwner {
        petContract = _petContract;
    }

    function setPrices(uint256[3] memory _prices) external onlyOwner {
        prices = _prices;
    }
     
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId));
        return _tokenURIs[tokenId];
    }
    
    function totalSupply()external view returns(uint256){
        return _totalSupply;
    }
    
    function getEggInfo(uint256 id) public view override returns(uint8[80] memory _mGenome, uint8[80] memory _fGenome, uint8 _gene, uint256 _mID, uint256 _fID) {
        _mGenome = eggInfos[id].mGenome;
        _fGenome = eggInfos[id].fGenome;
        _gene = eggInfos[id].gene;
        _mID = eggInfos[id].mID;
        _fID = eggInfos[id].fID;
    }

    function getEggType(uint256 id) external view override returns (uint256 _eggType){
        _eggType = eggTypes[id];
    }

    function getGenome(uint256 id) external view returns(string memory genome) {
        bytes memory genomeByte = new bytes(160);
        uint8[80] memory _mGenome = eggInfos[id].mGenome;
        uint8[80] memory _fGenome = eggInfos[id].fGenome;
        for (uint i=0; i<80; i++){
            genomeByte[i] = GeneType[_mGenome[i]];
        }
        for (uint i=80; i<160; i++){
            genomeByte[i] = GeneType[_fGenome[i-80]];
        }
        genome = string(genomeByte);
    }
    
    function create(
        uint8 _eggType
    )
        external override returns(uint256 tokenId)
    {
        require(_eggType>=0 && _eggType<12,"EggNFT : Only 12 type of eggs exist");
        EggInfo memory _eggInfo;

        //gene is 0
        _eggInfo.gene = 0;

        // genome set
        if(_eggType<4){

            petCoin.transferFrom(msg.sender,owner(),prices[0]);
            // defiend Genome
            _eggInfo.mGenome[0] = _eggType%4;
            _eggInfo.mGenome[1] = _eggType%4;
            _eggInfo.mGenome[2] = _eggType%4; 
            _eggInfo.fGenome[0] = _eggType%4;
            _eggInfo.fGenome[1] = _eggType%4;
            _eggInfo.fGenome[2] = _eggType%4; 

            // random
            uint8[] memory mRandom = new uint8[](78);
            mRandom = RandomLibrary.random(77,4,0);
            
            uint8[] memory fRandom = new uint8[](78);
            fRandom = RandomLibrary.random(77,4,1);
            for (uint i = 0; i<77; i++){
                _eggInfo.mGenome[i+3] = mRandom[i];
                _eggInfo.fGenome[i+3] = fRandom[i];
            }
        }
        else if(_eggType<8) {
            
            petCoin.transferFrom(msg.sender,owner(),prices[1]);
            // defiend Genome
            _eggInfo.mGenome[0] = _eggType%4;
            _eggInfo.mGenome[1] = _eggType%4;
            _eggInfo.fGenome[0] = _eggType%4;
            _eggInfo.fGenome[1] = _eggType%4;

            //random
            uint8[] memory mRandom = RandomLibrary.random(78,4,0);
            uint8[] memory fRandom = RandomLibrary.random(78,4,1);
            for (uint i = 0; i<78; i++){
                _eggInfo.mGenome[i+2] = mRandom[i];
                _eggInfo.fGenome[i+2] = fRandom[i];
            }
        }
        else {
            
            petCoin.transferFrom(msg.sender,owner(),prices[2]);
            //random
            uint8[] memory mRandom = RandomLibrary.random(80,4,0);
            uint8[] memory fRandom = RandomLibrary.random(80,4,1);
            for (uint i = 0; i<80; i++){
                _eggInfo.mGenome[i] = mRandom[i];
                _eggInfo.fGenome[i] = fRandom[i];
            }
        }    
        eggTypes[_totalSupply] = _eggType;
        tokenId = _create(msg.sender, _eggInfo);
    }
    
    function breed(address owner, EggInfo memory _eggInfo) external override returns (uint256 tokenId) {
        require(msg.sender==petContract,"EggNFT : Only petContract available");
        tokenId = _create(owner, _eggInfo);
        eggTypes[tokenId] = RandomLibrary.random(2,12,0)[0];
    }

    function born(uint256 id)external {
        _transfer(msg.sender,petContract,id);
        
        IPetNFT _petContract = IPetNFT(petContract);
        EggInfo memory _eggInfo = eggInfos[id];
        _petContract.born(msg.sender,_eggInfo);
    }

    function _create(
        address _owner,
        EggInfo memory _eggInfo
    )
        internal returns (uint256 tokenId)
    {
        tokenId = _totalSupply;
        _totalSupply=_totalSupply+1;

        /// Mint new NFT
        _mint(_owner, tokenId);
        _setEggInfo(tokenId, _eggInfo);

        emit ItemCreated(_owner, tokenId);
    }
    
    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        require(_exists(tokenId));
        _tokenURIs[tokenId] = uri;
    }

    function _setEggInfo(uint256 tokenId, EggInfo memory _eggInfo) internal {
        eggInfos[tokenId].mGenome = _eggInfo.mGenome;
        eggInfos[tokenId].fGenome = _eggInfo.fGenome;
        eggInfos[tokenId].gene = _eggInfo.gene;
        eggInfos[tokenId].mID = _eggInfo.mID;
        eggInfos[tokenId].fID = _eggInfo.fID;
    }
    
}
