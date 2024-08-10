// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./IERC7007.sol";
import "./IERC7007Enumerable.sol";
import "./IERC7007Updatable.sol";

contract ERC165Calculator {
    function calcIERC7007() public pure returns (bytes4) {
        return type(IERC7007).interfaceId;
    }

    function calcIERC7007Enumerable() public pure returns (bytes4) {
        return type(IERC7007Enumerable).interfaceId;
    }

    function calcIERC7007Updatable() public pure returns (bytes4) {
        return type(IERC7007Updatable).interfaceId;
    }
}
