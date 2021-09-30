// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface PetStructs {
    struct EggInfo {
        uint8[80] mGenome;
        uint8[80] fGenome;
        uint8 gene;
        uint256 mID;
        uint256 fID;
    }
}