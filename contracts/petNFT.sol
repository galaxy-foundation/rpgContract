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
    function breed(address owner,EggInfo memory _eggInfo) external returns (uint256 tokenId) ;
}

interface IPetNFT is IERC721, PetStructs{

    function born(address owner,EggInfo memory _eggInfo) external returns(uint256 tokenId);
}

contract PetNFT is IPetNFT, Ownable, ERC721 {
    
    event ItemCreated(
        address indexed owner,
        uint256 indexed tokenId
    );
    event Born(
        address indexed owner,
        uint256 indexed tokenId
    );
    event Upgraded(
        address indexed owner,
        uint256 indexed tokenId,
        uint256 indexed level
    );

    struct Prize {
        uint256 date;
        uint256 Id;
        uint256 number;
    }

    //DNA types : Adenine, Cytosine, Thymine, Guanine
    bytes private GeneType = "ACGT"; 

    //token Data
    uint256 private _totalSupply;
    mapping(uint256 => string) private _tokenURIs;

    mapping(uint256 => EggInfo) public petInfos;
    mapping(uint256 => uint256) public ageInfos;
    mapping(uint256 => uint256) public latestUpgradeTime;
    mapping(uint256 => uint256) public latestBreedLevels;

    // accepted token
    IERC20 public petCoin;
    uint256 public price;
    uint256 public upgradeTime = 0 days;
    uint256 private minlevel = 0 ;

    // petContract 
    address public eggContract;

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
        price = 40 * 10**18;
    }

    function setAcceptedToken(address _petCoinAddress) external onlyOwner {
        petCoin = IERC20(_petCoinAddress);
    }

    function setEggContract(address _eggContract) external onlyOwner {
        eggContract = _eggContract;
    }

    function setPrices(uint256 _price) external onlyOwner {
        price = _price;
    }

    function setUpgradeTime (uint256 _upgradeTime) external onlyOwner {
        upgradeTime = _upgradeTime;
    }
     
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId));
        return _tokenURIs[tokenId];
    }
    
    function totalSupply()external view returns(uint256){
        return _totalSupply;
    }
    
    function getPetInfo(uint256 id) public view returns(uint8[80] memory _mGenome, uint8[80] memory _fGenome, uint8 _gene, uint256 _mID, uint256 _fID) {
        _mGenome = petInfos[id].mGenome;
        _fGenome = petInfos[id].fGenome;
        _gene = petInfos[id].gene;
        _mID = petInfos[id].mID;
        _fID = petInfos[id].fID;
    }

    function getGenome(uint256 id) external view returns(string memory genome) {
        bytes memory genomeByte = new bytes(160);
        uint8[80] memory _mGenome = petInfos[id].mGenome;
        uint8[80] memory _fGenome = petInfos[id].fGenome;
        for (uint i=0; i<80; i++){
            genomeByte[i] = GeneType[_mGenome[i]];
        }
        for (uint i=80; i<160; i++){
            genomeByte[i] = GeneType[_fGenome[i-80]];
        }
        genome = string(genomeByte);
    }
    
    function born(
        address owner,EggInfo memory _eggInfo
    )
        external override returns(uint256 tokenId)
    {
        require(msg.sender==eggContract,"PetNFT: Only born from egg");
    
        tokenId = _create(owner, _eggInfo);
    }

    // upgrade level
    function upgrade(uint256 id) public returns (uint256 level) {
        require (ownerOf(id)==msg.sender,"EggNFT : only owner can upgrade");
        require(block.timestamp >= latestUpgradeTime[id] + upgradeTime, "EggNFT : not UpgradeTime");
        ageInfos[id] = ageInfos[id] + 1;
        level = ageInfos[id];
        latestUpgradeTime[id]  = block.timestamp;
        emit Upgraded(msg.sender,id,ageInfos[id]);
    }

    //breed
    function breed(uint256 mID, uint256 fID) external {
        require(ownerOf(mID) == msg.sender&&ownerOf(fID)==msg.sender,"EggNFT : Only owner can breed");
        require(ageInfos[mID] >= minlevel && ageInfos[fID] >= minlevel,"EggNFT : not enough level");
        require((ageInfos[mID] - latestBreedLevels[mID]) >= minlevel && (ageInfos[fID] - latestBreedLevels[fID]) >= minlevel, "EggNFT : not exact level");

        petCoin.transferFrom(msg.sender,owner(),price);
        EggInfo memory _eggInfo;
        _eggInfo.mID = mID;
        _eggInfo.fID = fID;

        if(petInfos[mID].gene > petInfos[fID].gene) 
            _eggInfo.gene = petInfos[mID].gene+1;
        else _eggInfo.gene = petInfos[fID].gene+1;

        uint8[80] memory _mGenome = _getChildGenome(mID,1);
        uint8[80] memory _fGenome = _getChildGenome(fID,2);
        _eggInfo.mGenome = _mGenome;
        _eggInfo.fGenome = _fGenome;

        IEggNFT eggNFT = IEggNFT(eggContract);
        eggNFT.breed(msg.sender,_eggInfo);

        latestBreedLevels[mID] = ageInfos[mID];
        latestBreedLevels[fID] = ageInfos[fID];
    }

    function _getChildGenome(uint256 id,uint256 externalNumber) internal view returns(uint8[80] memory childGenome){
            
            //heredity
            uint8[] memory Random = RandomLibrary.random(20,2,externalNumber);
            for (uint256 i=0; i<20; i++){
                if(Random[i]==0){
                    childGenome[i*4] = petInfos[id].mGenome[i*4];
                    childGenome[i*4+1] = petInfos[id].mGenome[i*4+1];
                    childGenome[i*4+2] = petInfos[id].mGenome[i*4+2];
                    childGenome[i*4+3] = petInfos[id].mGenome[i*4+3];
                }
                else {
                    childGenome[i*4] = petInfos[id].fGenome[i*4];
                    childGenome[i*4+1] = petInfos[id].fGenome[i*4+1];
                    childGenome[i*4+2] = petInfos[id].fGenome[i*4+2];
                    childGenome[i*4+3] = petInfos[id].fGenome[i*4+3];
                }
            }

            //mutation 
            uint8[] memory mutationNum = RandomLibrary.random(2,160,externalNumber);
            if(mutationNum[0]<80)
                childGenome[mutationNum[0]] = (childGenome[mutationNum[0]]+1)%4;  
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
        _setPetInfo(tokenId, _eggInfo);

        emit ItemCreated(_owner, tokenId);
    }
    
    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        require(_exists(tokenId));
        _tokenURIs[tokenId] = uri;
    }

    function _setPetInfo(uint256 tokenId, EggInfo memory _eggInfo) internal {
        petInfos[tokenId].mGenome = _eggInfo.mGenome;
        petInfos[tokenId].fGenome = _eggInfo.fGenome;
        petInfos[tokenId].gene = _eggInfo.gene;
        petInfos[tokenId].mID = _eggInfo.mID;
        petInfos[tokenId].fID = _eggInfo.fID;
    }

    function getPetAgeInfos(uint256[] memory tokenIds) external view returns(uint256[] memory _ageInfos, uint256[] memory _latestBreedLevels){
        _ageInfos = new uint256[](tokenIds.length);
        _latestBreedLevels = new uint256[](tokenIds.length);

        for(uint256 i = 0; i < tokenIds.length; i++){
            _ageInfos[i] = ageInfos[i];
            _latestBreedLevels[i] = latestBreedLevels[i];
        }

    }
}
