// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IUniswapV2Pair {
    function balanceOf(address account) external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);
}
