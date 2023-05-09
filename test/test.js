const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { BigNumber } = require("ethers");

async function deployVerifierFixture() {
    const Verifier = await ethers.getContractFactory("MockVerifier");
    const verifier = await Verifier.deploy();
    await verifier.deployed();
    return verifier;
}
const prompt = ethers.utils.toUtf8Bytes("test");
const aigcData = ethers.utils.toUtf8Bytes("test");
const uri = '"name": "test", "description": "test", "image": "test", "aigc_type": "test"';
const validProof = ethers.utils.toUtf8Bytes("valid");
const invalidProof = ethers.utils.toUtf8Bytes("invalid");
const tokenId = BigNumber.from("70622639689279718371527342103894932928233838121221666359043189029713682937432");

describe("ERC0000.sol", function () {

    async function deployERC0000Fixture() {
        const verifier = await deployVerifierFixture();

        const ERC0000 = await ethers.getContractFactory("ERC0000");
        const erc0000 = await ERC0000.deploy("testing", "TEST", verifier.address);
        await erc0000.deployed();
        return erc0000;
    }

    describe("mint", function () {
        it("should mint a token", async function () {
            const erc0000 = await deployERC0000Fixture();
            const [owner] = await ethers.getSigners();
            await erc0000.mint(prompt, aigcData, uri, validProof);
            expect(await erc0000.balanceOf(owner.address)).to.equal(1);
        });

        it("should not mint a token with invalid proof", async function () {
            const erc0000 = await deployERC0000Fixture();
            await expect(erc0000.mint(prompt, aigcData, uri, invalidProof)).to.be.revertedWith("ERC0000: invalid proof");
        });

        it("should not mint a token with same data twice", async function () {
            const erc0000 = await deployERC0000Fixture();
            await erc0000.mint(prompt, aigcData, uri, validProof);
            await expect(erc0000.mint(prompt, aigcData, uri, validProof)).to.be.revertedWith("ERC721: token already minted");
        });

        it("should emit a Mint event", async function () {
            const erc0000 = await deployERC0000Fixture();
            await expect(erc0000.mint(prompt, aigcData, uri, validProof))
                .to.emit(erc0000, "Mint")
        });
    });

    describe("metadata", function () {
        it("should return token metadata", async function () {
            const erc0000 = await deployERC0000Fixture();
            await erc0000.mint(prompt, aigcData, uri, validProof);
            expect(await erc0000.tokenURI(tokenId)).to.equal('{"name": "test", "description": "test", "image": "test", "aigc_type": "test", "prompt": "test", "aigc_data": "test"}');
        });
    });
});

describe("ERC0000Enumerable.sol", function () {

    async function deployERC0000EnumerableFixture() {
        const verifier = await deployVerifierFixture();

        const ERC0000Enumerable = await ethers.getContractFactory("MockERC0000Enumerable");
        const erc0000Enumerable = await ERC0000Enumerable.deploy("testing", "TEST", verifier.address);
        await erc0000Enumerable.deployed();
        await erc0000Enumerable.mint(prompt, aigcData, uri, validProof);
        return erc0000Enumerable;
    }
    
    it("should return token id by prompt", async function () {
        const erc0000Enumerable = await deployERC0000EnumerableFixture();
        expect(await erc0000Enumerable.tokenId(prompt)).to.equal(tokenId);
    });

    it("should return token prompt by id", async function () {
        const erc0000Enumerable = await deployERC0000EnumerableFixture();
        expect(await erc0000Enumerable.prompt(tokenId)).to.equal("test");
    });

});