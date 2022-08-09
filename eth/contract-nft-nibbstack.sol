// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* 这个地址是错的 无法访问。但这是 https://github.com/nibbstack/erc721 上的官方例子，不知为何。用这个错误的地址，也能在 remix 里编译成功。
//import "https://github.com/nibbstack/erc721/src/contracts/tokens/nf-token-metadata.sol";
//import "https://github.com/nibbstack/erc721/src/contracts/ownership/ownable.sol";
*/
// todo 这里有嵌套 import，为何能在 rimix 编译成功？
import "https://github.com/nibbstack/erc721/blob/master/src/contracts/tokens/nf-token-metadata.sol";
import "https://github.com/nibbstack/erc721/blob/master/src/contracts/ownership/ownable.sol";

/**
 * @dev This is an example contract implementation of NFToken with metadata extension.
 */
contract MyArtSale is NFTokenMetadata, Ownable {
    /**
     * @dev Contract constructor. Sets metadata extension `name` and `symbol`.
     */
    constructor() {
        nftName = "Frank's Art Sale";
        nftSymbol = "FAS";
    }

    /**
     * @dev Mints a new NFT.
     * @param _to The address that will own the minted NFT.
     * @param _tokenId of the NFT to be minted by the msg.sender.
     * @param _uri String representing RFC 3986 URI.
     */
    function mint(
        address _to,
        uint256 _tokenId,
        string calldata _uri
    ) external onlyOwner {
        super._mint(_to, _tokenId);
        super._setTokenUri(_tokenId, _uri);
    }
}
