// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "./ERC7007.sol";
import "./IERC7007Claimable.sol";

/**
 * @dev Implementation of the {IERC7007Claimable} interface.
 */
abstract contract ERC7007Claimable is ERC7007, IERC7007Claimable {
    /**
     * @dev Mapping of prompt to owner.
     */
    mapping(bytes => address) public promptOwner;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(IERC165, ERC7007) returns (bool) {
        return
            interfaceId == type(IERC7007Claimable).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev see {IERC7007Claimable-claim}.
     */
    function claim(
        bytes calldata prompt
    ) public virtual override returns (address owner) {
        owner = promptOwner[prompt];
        require(
            owner == address(0),
            "ERC7007Claimable: prompt already claimed"
        );
        owner = promptOwner[prompt] = msg.sender;
        emit Claim(prompt, owner);
    }

    /**
     * @dev See {IERC7007-mint}.
     */
    function mint(
        bytes calldata prompt,
        bytes calldata aigcData,
        string calldata uri,
        bytes calldata proof
    ) public virtual override(ERC7007, IERC7007) returns (uint256 tokenId) {
        require(
            promptOwner[prompt] != address(0),
            "ERC7007Claimable: prompt not claimed"
        );
        require(verify(prompt, aigcData, proof), "ERC7007: invalid proof");
        tokenId = uint256(keccak256(prompt));
        _safeMint(promptOwner[prompt], tokenId);
        string memory tokenUri = string(
            abi.encodePacked(
                "{",
                uri,
                ', "prompt": "',
                string(prompt),
                '", "aigc_data": "',
                string(aigcData),
                '"}'
            )
        );
        _setTokenURI(tokenId, tokenUri);
        emit Mint(tokenId, prompt, aigcData, uri, proof);
    }
}

contract MockERC7007Claimable is ERC7007Claimable {
    constructor(
        string memory name_,
        string memory symbol_,
        address verifier_
    ) ERC7007(name_, symbol_, verifier_) {}
}
