//SPDX-License-Identifier: MIT

// https://medium.com/scrappy-squirrels/tutorial-writing-an-nft-collectible-smart-contract-9c7e235e96da

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract PEX is ERC721Enumerable, Ownable {
    using SafeMath for uint256;

    uint public constant PRICE = 0.01 ether; // The amount of ether required to buy 1 NFT.

    string public _baseTokenURI; // The IPFS URL of the folder containing the JSON metadata.

    // 创建合约时提供 baseURI
    constructor(string memory baseURI) ERC721("Permanent Existence", "PEX") {
        setBaseURI(baseURI);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // 本函数让主人可以在后期修改 _baseTokenURI。
    function setBaseURI(string memory baseTokenURI_) public onlyOwner {
        _baseTokenURI = baseTokenURI_;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(baseURI, Strings.toHexString(tokenId))
                )
                : "";
    }

    // web3.sha3('mint(address,uint256)').substr(2,8) ==> 40c10f19
    function mint(address _to, uint256 _tokenId)
        public
        payable
        onlyOwner
    // returns (uint256)
    {
        require(msg.value >= PRICE, "Not enough ether to purchase NFT.");
        _safeMint(_to, _tokenId);
        //        return _tokenId;
    }

    function transfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: caller is not token owner or approved"
        );
        _safeTransfer(from, to, tokenId, data);
    }

    function tokensOfOwner(address _owner)
        external
        view
        returns (uint[] memory)
    {
        uint tokenCount = balanceOf(_owner);
        uint[] memory tokenIds = new uint256[](tokenCount);
        for (uint i = 0; i < tokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }

        return tokenIds;
    }

    function withdraw() public payable onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No ether left to withdraw");
        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed.");
    }
}
