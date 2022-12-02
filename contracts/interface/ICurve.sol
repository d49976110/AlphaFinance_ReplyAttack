// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface ICurve {
    function exchange(
        uint256 i,
        uint256 j,
        uint256 dx,
        uint256 min_dy
    ) external returns (uint256);
}