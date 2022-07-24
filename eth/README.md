# 安装

- download binaries <https://geth.ethereum.org/downloads/>
  - Windows <https://gethstore.blob.core.windows.net/builds/geth-windows-amd64-1.10.20-8f2416a8.exe>
  - Linux amd64 <https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.20-8f2416a8.tar.gz>
  - Linux arm64 <https://gethstore.blob.core.windows.net/builds/geth-linux-arm64-1.10.20-8f2416a8.tar.gz>
  - MacOS <https://gethstore.blob.core.windows.net/builds/geth-darwin-amd64-1.10.20-8f2416a8.tar.gz>
  - Sources <https://github.com/ethereum/go-ethereum/archive/v1.10.20.tar.gz>
- clone source repository
  - `git clone https://github.com/ethereum/go-ethereum -b v1.10.20`
    - `cd go-ethereum && make [geth|all] && ./build/bin/geth version`
  - `wget https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.10.20.tar.gz`
- pull docker
  - `docker pull ethereum/client-go:v1.10.20`

# 共识

- clique: Proof of Authority <http://yangzhe.me/2019/02/01/ethereum-clique/>
- ethash: Proof of Work

# 网络

- ropsten: PoW
- rinkeby: PoA
- 本地网：
  - [ganache](https://github.com/trufflesuite/ganache) ( <= [ganache-cli](https://github.com/trufflesuite/ganache-cli-archive) <= [ethereumjs-testrpc](https://github.com/ethereumjs/testrpc) )
    - `npx ganache`
    - 属于 truffle 三大组件之一
  - [ganache-ui](https://github.com/trufflesuite/ganache-ui) 是个桌面程序，不依赖于 ganache-cli。
  - [Hardhat Network](https://hardhat.org/hardhat-network)

# 文档

https://geth.ethereum.org/docs

# 交互

几种调用方法 <https://blog.csdn.net/weixin_44029550/article/details/110009549>

0. command line

1. JavaScript Console

   - 也内置了 web3 对象，但是很老的，参见 <https://github.com/ethereum/go-ethereum> (note: the web3 version bundled within geth is very old, and not up to date with official docs)

1. JSON-RPC: over http|websocket|unix-socket. 默认 rpc 端口 8545

   - `geth --http --http.port 8545 --http.addr 127.0.0.1 --http.api eth,net,web3,personal,admin,miner,debug,txtool,shh`
     - `geth attach http://addr:port ...
   - `geth --ws --ws.addr *** --ws.port 8546 --ws.api eth,net,web3`
   - `geth --ipcpath [PATH]`
     - `geth --ipcdiable`
     - Path default to `~/.etherum/geth.ipc` on Nix or `\\.\pipe\geth.ipc` on Windows
     - `geth attach ipc:[PATH]`
   - 同一台主机上两个实例不能共用一样的 http.port, ws.port 或 ipcpath

1. 编程接口库
   - web3.js 是以太坊基金会支持的封装了 JSON-RPC，方便 js 客户端调用
     - web3
     - web3-eth
     - web3-shh
     - web3-bzz
     - web3-net
     - web3-utils
   - ethers.js （与 web3.js 比较 https://learnblockchain.cn/article/1851 ）
     - Ethers.provider
     - Ethers.contract
     - Ethers.utils
     - Ethers.wallets

# 端口

- 默认 rpc 端口: 8545 `geth --http.port 8545`
- 默认网络端口: 30303 `geth --port 30303` network listening port. 不能和 http.port 一样！

# 私有链

https://geth.ethereum.org/docs/interface/private-network
只有当 networkid、chainID、创世区块都相同时，才是同一条链。chainID 不是 networkid，但 metatask 等工具可能错误的混用了，因此为了兼容，可以把 chiinId 和 networkid 设成一样。<https://www.jianshu.com/p/b8730a05eb36> <https://learnblockchain.cn/article/578>

已被使用的 chainId 列表: <https://chainlist.org/zh>

我的 PEX 链的默认端口：

- pex=739
- chainid 6739
- networkid 6739
- rpc 端口/http.port 6739
- 网络端口/port 60739

部署合约 https://github.com/nibbstack/erc721

当获取合约实例之后（比如 testInstance），在 geth console 中可以通过三种方法调用合约方法 <https://zhuanlan.zhihu.com/p/26089385>

- testInstance.testFunc.sendTransaction();
  - testInstance.testFunc.sendTransaction(); 会创建一个交易，调用之后会返回一个交易 hash 值，它会广播到网络，等待矿工打包, 它会消耗 gas。
- testInstance.testFunc.call();
  - testInstance.testFunc.call(); 它完全是一个本地调用，不会向区块链网络广播任何东西，它的返回值完全取决于 testFunc 方法的代码，不会消耗 gas
- testInstance.testFunc();
  - testInstance.testFunc(); 它会比较特殊，由于有 constant 标识的方法不会修改状态变量，所以它不会被编译器执行。所以，如果 testFunc() 有 constant 标识，它并不会被编译器执行，web3.js 会执行 call()的本地操作。相反如果没有 constant 标识，会执行 sendTransaction()操作。

# 开发

- hardhat + ethers.js <https://hardhat.org/> <https://zhuanlan.zhihu.com/p/353251375> <https://learnblockchain.cn/docs/hardhat/getting-started/>
- truffle + web3.js
- embark <https://framework.embarklabs.io/>

they are like vuejs for web projects, while source code is in solidity or html/css/js, respectively.

# 合约

- <https://docs.openzeppelin.com/>
- <https://github.com/nibbstack/erc721>

# NFT

每个符合 ERC-721 标准的合同都必须实现 ERC721 和 ERC165 接口

EIP721 specification: https://eips.ethereum.org/EIPS/eip-721

- interface ERC721 /_ is ERC165 _/
  - `event Transfer (address indexed _from, address indexed _to, uint256 indexed _tokenId)` 当代币的所有权从一个人变为另一个人时，该事件被触发。发出的信息包括哪个账户转移了代币，哪个账户收到了代币，以及哪个代币（通过 ID）被转移。
  - `event Approval (address indexed _owner, address indexed _approved, uint256 indexed _tokenId)` 当用户批准另一个用户获得代币的所有权时，该事件就会被触发，也就是说，每当 approve 函数被执行时，该事件就会被触发。它发出的信息包括：当前哪个账户拥有该代币，哪个账户被批准在未来拥有该代币，以及哪个代币（通过 ID）被批准转让其所有权。
  - `event ApprovalForAll (address indexed _owner, address indexed _operator, bool _approved)`
  - `function balanceOf (address _owner) external view returns (uint256)` 返回一个地址拥有的 NFT 数量。
  - `function ownerOf (uint256 _tokenId) external view returns (address)` Ownership 本函数返回代币所有者的地址。由于每个 ERC-721 代币都是独一无二的，非同质化的，它们在区块链上由一个 ID 来表示。其他用户、合约、应用可以使用这个 ID 来确定代币的所有者。
  - `function transferFrom (address _from, address _to, uint256 _tokenId) external payable`
  - `function safeTransferFrom (address _from, address _to, uint256 _tokenId, bytes data) external payable`: 这是另一个转移函数；它允许所有者将代币转让给另一个用户，就像加密货币一样。
  - `function safeTransferFrom (address _from, address _to, uint256 _tokenId) external payable` //如上，只是将 data 参数置空。
  - `function approve (address _approved, uint256 _tokenId) external payable` 批准某地址获得某代币。
  - `function setApprovalForAll (address _operator, bool _approved) external`
  - `function getApproved (uint256 _tokenId) external view returns (address)`
  - `function isApprovedForAll (address _owner, address _operator) external view returns (bool)`
  - takeOwnership: 这是一个可选的函数，它的作用就像一个取款函数，因为外界可以调用它从另一个用户的账户中取出代币。当一个用户被批准拥有一定数量的代币，可以使用 takeOwnership。
- interface ERC165
  - `function supportsInterface (bytes4 interfaceID) external view returns (bool)`
- interface ERC721TokenReceiver 钱包/经纪人/拍卖应用程序必须实现钱包接口，如果它接受安全转移
  - `function onERC721Received (address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4)`
- interface ERC721Metadata /_ is ERC721 _/ (可选)
  - `function name () external view returns (string _name)` 用于定义代币的名称。
  - `function symbol () external view returns (string _symbol)` 用于定义标记代币的符号。
  - `function tokenURI (uint256 _tokenId) external view returns (string)` 获得某资产的 uri。
  - tokenURI should resolve to metadata following ERC721 Metadata JSON Schema
    ```
    {
      "title": "Asset Metadata",
      "type": "object",
      "properties": {
          "name": {
              "type": "string",
              "description": "Identifies the asset to which this NFT represents",
          },
          "description": {
              "type": "string",
              "description": "Describes the asset to which this NFT represents",
          },
          "image": {
              "type": "string",
              "description": "A URI pointing to a resource with mime type image/* representing the asset to which this NFT represents. Consider making any images at a width between 320 and 1080 pixels and aspect ratio between 1.91:1 and 4:5 inclusive.",
          }
      }
    ```
- interface ERC721Enumerable /_ is ERC721 _/（可选）枚举扩展对于 ERC-721 智能合约是可选的（请参阅下面的“警告”）。这允许您的合同发布其完整的 NFT 列表并使其可被发现。
  - `function totalSupply () external view returns (uint256)` 这个函数用来定义区块链上的代币总数，供应量不必是恒定的。
  - `function tokenByIndex (uint256 _index) external view returns (uint256)`
  - `function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256)` 这是一个可选的函数，但建议使用。每个所有者可以同时拥有一个以上的 NFT。其独特的 ID 可以识别每一个 NFT，结果可能会变得难以跟踪 ID。所以合约将这些 ID 存储在一个数组中，tokenOfOwnerByIndex 函数让我们从数组中检索这些信息。
- interface ERC721Burnable
  - `function burn(uint256 tokenId)`

每个 NFT 都由 ERC-721 智能合约中的唯一 ID 标识。该识别号码在合同有效期内不得更改。然后，该货币对将成为以太坊链上特定资产的全球唯一且完全合格的标识符。虽然一些 ERC-721 智能合约可能会发现从 ID 0 开始并为每个新的 NFT 简单地递增 1 很方便，但调用者不应假设 ID 号具有任何特定的模式，并且必须将 ID 视为“黑匣子”。另请注意，NFT 可能会失效（被销毁）。请参阅枚举函数，了解支持的枚举接口。

https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
https://github.com/nibbstack/erc721/tree/master/src/contracts/tokens
