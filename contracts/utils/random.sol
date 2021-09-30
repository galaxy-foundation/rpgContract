// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library RandomLibrary {
    function random(uint256 length, uint256 maxNum,uint256 _externalRandomNumber) public view returns(uint8[] memory _random) {
        _random = new uint8[](length);
        
        bytes32 _blockhash = blockhash(block.number-1);
        bytes32 _structHash;
        uint256 _randomNumber;

        for ( uint i = 0; i < length; i++){
            _structHash = keccak256(
                abi.encode(
                    _blockhash,
                    _externalRandomNumber,
                    i
                )
            );
            _randomNumber  = uint256(_structHash);
            assembly {_randomNumber := mod(_randomNumber, maxNum)}
            _random[i]=uint8(_randomNumber);
        }
    }
}