// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IHomoraBank {
    function POSITION_ID() external view returns (uint256);

    function execute(
        uint256 positionId,
        address spell,
        bytes memory data
    ) external payable returns (uint256);

    function borrow(address token, uint256 amount) external;

    function putCollateral(
        address collToken,
        uint256 collId,
        uint256 amountCall
    ) external;

    function accrue(address token) external;

    function getPositionDebts(uint256 positionId)
        external
        view
        returns (address[] memory tokens, uint256[] memory debts);

    function repay(address token, uint256 amountCall) external;

    function resolveReserve(address token) external;

    function getBankInfo(address token)
        external
        view
        returns (
            bool isListed,
            address cToken,
            uint256 reserve,
            uint256 totalDebt,
            uint256 totalShare
        );

    function getPositionInfo(uint256 positionId)
        external
        view
        returns (
            address owner,
            address collToken,
            uint256 collId,
            uint256 collateralSize
        );
    
    function getPositionDebtShareOf(uint256 positionId, address token) external view returns (uint256);
}
