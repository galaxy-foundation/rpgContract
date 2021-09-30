// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

import "./utils/access/Ownable.sol";


contract FeeManager is Ownable {

    event ChangedFeePerMillion(uint256 cutPerMillion);

    // Market fee on sales
    uint256 public cutPerMillion=100000;
    uint256 public constant maxCutPerMillion = 100000; // 10% cut
    
    uint256 public royaltyPerMillion=100000;

    /**
     * @dev Sets the share cut for the owner of the contract that's
     *  charged to the seller on a successful sale
     * @param _cutPerMillion - Share amount, from 0 to 99,999
     */
    function setOwnerCutPerMillion(uint256 _cutPerMillion) external onlyOwner {
        require(
            _cutPerMillion < maxCutPerMillion,
            "The owner cut should be between 0 and maxCutPerMillion"
        );

        cutPerMillion = _cutPerMillion;
        emit ChangedFeePerMillion(cutPerMillion);
    }
}
