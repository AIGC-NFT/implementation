// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "./IERC7007.sol";

/**
 * @title ERC7007 Token Standard, optional claimable extension
 */
interface IERC7007Claimable is IERC7007 {
    /**
     * @dev Emitted when `owner` claims `prompt`.
     */
    event Claim(bytes indexed prompt, address indexed owner);

    /**
     * @dev Claim ownership of given `prompt`.
     *
     * Requirements:
     * - `prompt` must not be claimed.
     */
    function claim(bytes calldata prompt) external returns (address owner);
}
