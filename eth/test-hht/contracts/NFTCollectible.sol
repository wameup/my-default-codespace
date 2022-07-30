//SPDX-License-Identifier: MIT

// https://medium.com/scrappy-squirrels/tutorial-writing-an-nft-collectible-smart-contract-9c7e235e96da

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFTCollectible is ERC721Enumerable, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds; // 在 solidity 中，mapping 没有长度（length）概念，因此自己定义一个来跟踪。

    uint public constant MAX_SUPPLY = 100; // The maximum number of NFTs that can be minted in your collection.
    uint public constant PRICE = 0.01 ether; // The amount of ether required to buy 1 NFT.
    uint public constant MAX_PER_MINT = 5; // The upper limit of NFTs that you can mint at once.

    string public _baseTokenURI; // The IPFS URL of the folder containing the JSON metadata.

    // 创建合约时提供 baseURI
    constructor(string memory baseURI) ERC721("Permanent Existence", "PEX") {
        setBaseURI(baseURI);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // 本函数让主人可以在后期修改 _baseTokenURI。
    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        _baseTokenURI = _baseTokenURI;
    }

    function _mintSingleNFT() private {
        uint newTokenID = _tokenIds.current(); // 注意，本合约的实现，是自动按顺序生成了 tokenID，而不是被合约调用者赋予。
        _safeMint(msg.sender, newTokenID); // _safeMint should be defined by openzeppelin, it assigns NFT with ID _newTokenID to msg.sender, and each NFT gets the correct metadata (stored in IPFS) assigned automatically by openzeppelin.
        _tokenIds.increment();
    }

    function reserveNFTs() public onlyOwner {
        uint totalMinted = _tokenIds.current();
        require(totalMinted.add(10) < MAX_SUPPLY, "Not enough NFTs");
        for (uint i = 0; i < 10; i++) {
            _mintSingleNFT();
        }
    }

    function mintNFTs(uint _count) public payable {
        uint totalMinted = _tokenIds.current();
        require(totalMinted.add(_count) <= MAX_SUPPLY, "Not enough NFTs!");
        require(
            _count > 0 && _count <= MAX_PER_MINT,
            "Cannot mint specified number of NFTs."
        );
        require(
            msg.value >= PRICE.mul(_count),
            "Not enough ether to purchase NFTs."
        );
        for (uint i = 0; i < _count; i++) {
            _mintSingleNFT();
        }
    }

    function tokensOfOwner(address _owner)
        external
        view
        returns (uint[] memory)
    {
        uint tokenCount = balanceOf(_owner);
        uint[] memory tokensId = new uint256[](tokenCount);
        for (uint i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }

        return tokensId;
    }

    function withdraw() public payable onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No ether left to withdraw");
        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed.");
    }
}
