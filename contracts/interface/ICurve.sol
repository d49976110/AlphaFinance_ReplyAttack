// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface ICurve {
    function balanceOf(address account) external view returns (uint256);

    function approve(address spender, uint256 amount) external;

    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy
    ) external;

    function add_liquidity(
        uint256[3] calldata uamounts,
        uint256 min_mint_amount,
        bool _use_underlying
    ) external;
}
