pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 tokensToSell, uint256 tokensToReceive);

  YourToken public yourToken;
  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    uint256 amountToReceive = tokensPerEth * msg.value;
    yourToken.transfer(msg.sender, amountToReceive);
    emit BuyTokens(msg.sender, msg.value, amountToReceive);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    require (address(this).balance>0, "balance is 0");
    (bool sent, ) = owner().call{value: address(this).balance}("");
    require (sent,"Failed to send Ether");
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 amount) public {
    uint256 amountEth = amount/tokensPerEth;
    yourToken.transferFrom(msg.sender, address(this), amount);
    (bool sent, ) = msg.sender.call{value: amountEth}("");
    require (sent,"Failed to send Ether");
    emit SellTokens(msg.sender, amount, amountEth);
  }

}
