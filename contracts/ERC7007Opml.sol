// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./IERC7007.sol";
import "./IOpmlLib.sol";

/**
 * @dev Implementation of the {IERC7007} interface.
 */
contract ERC7007Opml is ERC165, IERC7007, ERC721URIStorage {
    address public immutable opmlLib;
    mapping (uint256 => uint256) public tokenIdToRequestId;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(
        string memory name_,
        string memory symbol_,
        address opmlLib_
    ) ERC721(name_, symbol_) {
        opmlLib = opmlLib_;
    }

    /**
     * @dev See {IERC7007-mint}.
     */
    function mint(
        address to,
        bytes calldata prompt,
        bytes calldata aigcData,
        string calldata uri,
        bytes calldata proof
    ) public virtual override returns (uint256 tokenId) {
        tokenId = uint256(keccak256(prompt));
        _safeMint(to, tokenId);
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
        
        tokenIdToRequestId[tokenId] = IOpmlLib(opmlLib).initOpmlRequest(prompt);
        IOpmlLib(opmlLib).uploadResult(tokenIdToRequestId[tokenId], aigcData);

        emit Mint(to, tokenId, prompt, aigcData, uri, proof);
    }

    /**
     * @dev See {IERC7007-verify}.
     */
    function verify(
        bytes calldata prompt,
        bytes calldata aigcData,
        bytes calldata proof
    ) public view virtual override returns (bool success) {
        uint256 tokenId = uint256(keccak256(prompt));
        bytes memory output = IOpmlLib(opmlLib).getOutput(tokenIdToRequestId[tokenId]);
        
        // ? : should we update the aigcData if output != keccak256(aigcData) ?
        return IOpmlLib(opmlLib).isFinalized(tokenIdToRequestId[tokenId]) && (keccak256(output) == keccak256(aigcData));
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC165, ERC721, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}
