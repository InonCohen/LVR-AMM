
        const { expect } = require("chai");
        const { ethers } = require("hardhat");

        describe("AMM", function () {
            let Token;
            let token0;
            let token1;
            let AMM;
            let amm;
            let owner;
            let addr1;

            beforeEach(async function () {
                Token = await ethers.getContractFactory("ERC20Token");
                token0 = await Token.deploy("Token0", "TOK0", 1000000);
                token1 = await Token.deploy("Token1", "TOK1", 1000000);

                AMM = await ethers.getContractFactory("AMM");
                amm = await AMM.deploy(token0.address, token1.address);

                [owner, addr1] = await ethers.getSigners();
            });

            it("Should set the oracle price and add liquidity", async function () {
                await amm.setOraclePrice(1000);
                await token0.approve(amm.address, 10000);
                await token1.approve(amm.address, 10000);

                await amm.addLiquidity(1, 1000);
                const [reserve0, reserve1] = await amm.getReserves();
                expect(reserve0).to.equal(1);
                expect(reserve1).to.equal(1000);
            });

            it("Should balance the pool when price changes", async function () {
                await amm.setOraclePrice(1000);
                await token0.approve(amm.address, 10000);
                await token1.approve(amm.address, 10000);

                await amm.addLiquidity(1, 1000);
                await amm.setOraclePrice(4000);
                await amm.balancePool();

                const [reserve0, reserve1] = await amm.getReserves();
                console.log("Reserves after price change to 4000:", reserve0.toString(), reserve1.toString());
            });

            it("Should calculate loss and profit", async function () {
                await amm.setOraclePrice(1000);
                await token0.approve(amm.address, 10000);
                await token1.approve(amm.address, 10000);

                await amm.addLiquidity(1, 1000);
                await amm.setOraclePrice(4000);
                await amm.balancePool();
                
                let [reserve0, reserve1] = await amm.getReserves();
                console.log("Reserves after price change to 4000:", reserve0.toString(), reserve1.toString());

                await amm.setOraclePrice(1000);
                await amm.balancePool();

                [reserve0, reserve1] = await amm.getReserves();
                console.log("Reserves after price change back to 1000:", reserve0.toString(), reserve1.toString());
            });
        });
        