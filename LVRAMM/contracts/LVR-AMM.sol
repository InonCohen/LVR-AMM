// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ConstantProductAMM {
    IERC20 public token0;
    IERC20 public token1;
    uint256 public reserve0;
    uint256 public reserve1;
    uint256 public price; // price of 1 token0 in terms of token1
    uint8 public constant DECIMALS = 3;
    uint256 public constant SCALE = 10 ** DECIMALS;
    uint256 public K;

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function addLiquidity(uint256 amount0, uint256 amount1) external {
        require(amount0 > 0 && amount1 > 0, "Invalid amounts");
        token0.transferFrom(msg.sender, address(this), amount0);
        token1.transferFrom(msg.sender, address(this), amount1);
        reserve0 += amount0 * SCALE;
        reserve1 += amount1 * SCALE;
        K = reserve0*reserve1; //assuming liquidity is only set at initialization and never changed
    }

    function _internalSwap(int256 amount) internal {
        if (amount < 0){
            uint256 abs_amount = (amount < 0) ? uint256(-amount) : uint256(amount);
            uint256 delta1 = abs_amount*price;
            require(delta1 <= reserve1, "Not enough liquidity");
            reserve0 -= uint256(amount);
            reserve1 -= delta1;
        }else if (amount == 0){
            return;
        }else{
            require(amount < int256(reserve0), "Not enough liquidity");
            reserve0 -= uint256(amount);
            uint256 delta1 = uint256(amount) *price;
            reserve1 += delta1;
        }         
    }

    function getReserves() public view returns (uint256, uint256) {
        return (reserve0 / SCALE, reserve1 / SCALE);
    }

    function setExchangeRate(uint256 targetPrice) external {
        require(targetPrice > 0, "Invalid target price");
        uint256 oldPrice = (price == 0) ? targetPrice : price;
        price = targetPrice;
        balancePool(oldPrice, price);
    }

    function balancePool(uint256 oldPrice, uint256 newPrice) internal {
        if (oldPrice == newPrice){
            return;
        }        
        if (oldPrice < newPrice) {// selling TOK0
            uint256 amountToSell = reserve0 - sqrt(K/newPrice);
            uint256 amountEarned = amountToSell * newPrice;
            reserve0 -= amountToSell;
            reserve1 += amountEarned;
        } else { // buying TOK0
            uint256 amountToBuy = sqrt(K/newPrice)-reserve0; 
            uint256 amountSpent = amountToBuy * newPrice;
            reserve1 -= amountSpent;
            reserve0 += amountToBuy;
        }
    }

    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}
