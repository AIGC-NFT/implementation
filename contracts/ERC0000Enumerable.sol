// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "./ERC0000.sol";
import "./IERC0000Enumerable.sol";

/**
 * @dev Implementation of the {IERC0000Enumerable} interface.
 */
abstract contract ERC0000Enumerable is ERC0000, IERC0000Enumerable {
    /**
     * @dev See {IERC0000Enumerable-tokenId}.
     */
    mapping(uint256 => string) public prompt;


    /**
     * @dev See {IERC0000Enumerable-prompt}.
     */
    mapping(bytes => uint256) public tokenId;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(IERC165, ERC0000) returns (bool) {
        return
            interfaceId == type(IERC0000Enumerable).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC0000-mint}.
     */
    function mint(
        bytes calldata prompt_,
        bytes calldata aigcData,
        string calldata uri,
        bytes calldata proof
    ) public virtual override(ERC0000, IERC0000) returns (uint256 tokenId_) {
        tokenId_ = ERC0000.mint(prompt_, aigcData, uri, proof);
        prompt[tokenId_] = string(prompt_);
        tokenId[prompt_] = tokenId_;
    }
}

contract MockERC0000Enumerable is ERC0000Enumerable {
    constructor(
        string memory name_,
        string memory symbol_,
        address verifier_
    ) ERC0000(name_, symbol_, verifier_) {}
} 