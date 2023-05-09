// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "./IERC0000.sol";

/**
 * @title ERC0000 Token Standard, optional enumeration extension
 */
interface IERC0000Enumerable is IERC0000 {
    /**
     * @dev Returns the token ID given `prompt`.
     */
    function tokenId(bytes calldata prompt) external view returns (uint256);

    /**
     * @dev Returns the prompt given `tokenId`.
     */
    function prompt(uint256 tokenId) external view returns (string calldata);
}
