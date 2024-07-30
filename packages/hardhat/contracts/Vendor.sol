pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
	event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

	event SellTokens(
		address seller,
		uint256 amountOfTokens,
		uint256 amountOfETH
	);

	YourToken public yourToken;

	uint256 public constant tokensPerEth = 100;

	constructor(address tokenAddress) {
		yourToken = YourToken(tokenAddress);
	}

	function buyTokens() public payable {
		// calculate the amount of tokens
		uint256 amountOfTokens = msg.value * tokensPerEth;

		// transfer the tokens to the buyer
		yourToken.transfer(msg.sender, amountOfTokens);

		// Notice to buyer
		emit BuyTokens(msg.sender, msg.value, amountOfTokens);
	}

	// ToDo: create a withdraw() function that lets the owner withdraw ETH
	function withdraw() public onlyOwner {
		uint256 contractBalance = address(this).balance;
		require(contractBalance > 0, "Vendor: No ETH to withdraw");

		payable(owner()).transfer(contractBalance);
	}

	// ToDo: create a sellTokens(uint256 _amount) function:

	function sellTokens(uint256 _amount) public {
		require(
			_amount > 0,
			"Vendor: Amount of tokens to sell should be greater than zero"
		);

		uint256 amountOfETH = _amount / tokensPerEth;
		require(
			address(this).balance >= amountOfETH,
			"Vendor: Not enough ETH in the contract"
		);

		bool sent = yourToken.transferFrom(msg.sender, address(this), _amount);
		require(
			sent,
			"Vendor: Failed to transfer tokens from user to contract"
		);

		payable(msg.sender).transfer(amountOfETH);

		emit SellTokens(msg.sender, _amount, amountOfETH);
	}
}
