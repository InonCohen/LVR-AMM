// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleWallet is Ownable {
    // Constructor to set the owner of the wallet
    constructor() Ownable(msg.sender) {}

    // Function to deposit tokens into the wallet
    function depositTokens(address token, uint256 amount) external {
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "Transfer failed");
    }

    // Function to withdraw tokens from the wallet
    function withdrawTokens(address token, address to, uint256 amount) external onlyOwner {
        require(IERC20(token).transfer(to, amount), "Transfer failed");
    }

    // Function to check the balance of a specific token in the wallet
    function tokenBalance(address token) external view returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }

    // Function to get the address of the owner (inherited from Ownable)
    function getOwner() external view returns (address) {
        return owner();
    }
}
