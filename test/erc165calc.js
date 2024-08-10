const { expect } = require("chai");

describe("ERC165Calculator.sol", function () {
  let erc165calc;

  before(async function () {
    erc165calc = await ethers.deployContract("ERC165Calculator");
  });

  it("IERC7007 Identifier", async function () {
    expect(await erc165calc.calcIERC7007()).to.equal('0x702c55a6');
  });

  it("IERC7007Enumerable Identifier", async function () {
    expect(await erc165calc.calcIERC7007Enumerable()).to.equal('0xfa1a557a');
  });

  it("IERC7007Updatable Identifier", async function () {
    expect(await erc165calc.calcIERC7007Updatable()).to.equal('0x3f37dce2');
  });
});