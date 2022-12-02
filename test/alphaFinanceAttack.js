const { time, loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("Alpha Finance Attack", function () {
    let attacker, attack;
    let amount = BigInt(0.5 * 1e18);
    async function deployContractFixture() {
        // Contracts are deployed using the first signer/account by default
        const [attacker, ...addrs] = await ethers.getSigners();

        const Attack = await ethers.getContractFactory("Attack");
        attack = await Attack.deploy();

        return { attacker, attack };
    }

    describe("Deployment", function () {
        before(async () => {
            await loadFixture(deployContractFixture);
        });

        it("step 2", async function () {
            await attack.attack2({ value: amount });
        });

        it("step 3", async function () {
            await attack.attack3();
        });
    });
});
