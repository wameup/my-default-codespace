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

# 网络 <https://ethereum.org/en/developers/docs/networks>

- ropsten (deprecated): PoW
- rinkeby (deprecated): PoA
- sepolia: PoW
- goerli: PoA
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

- `geth -h`

1. JavaScript Console

- `geth --datadir [datadir] console`
- `geth attach [network or ipcpath]`
- 也内置了 web3 对象，但是很老的，参见 <https://github.com/ethereum/go-ethereum> (note: the web3 version bundled within geth is very old, and not up to date with official docs)

2. JSON-RPC: over http|websocket|unix-socket. 默认 rpc 端口 8545. 参见 <https://ethereum.org/en/developers/docs/apis/json-rpc/>

   - `geth --http --http.port 8545 --http.addr 127.0.0.1 --http.api eth,net,web3,personal,admin,miner,debug,txtool,shh`
     - `geth attach http://addr:port ...
   - `geth --ws --ws.addr 127.0.0.1 --ws.port 8546 --ws.api eth,net,web3`
   - `geth --ipcpath [IPCPATH]` 或者禁用 `geth --ipcdiable`
     - Path default to `~/.etherum/geth.ipc` on Nix or `\\.\pipe\geth.ipc` on Windows
     - `geth attach ipc:[IPCPATH]` 或者 `geth attach [IPCPATH]`
   - 同一台主机上两个实例不能共用一样的 http.port, ws.port 或 ipcpath

3. 编程接口库/JavaScript API
   - web3.js 是以太坊基金会支持的封装了 JSON-RPC，方便 js 客户端调用 <https://github.com/ChainSafe/web3.js> <https://learnblockchain.cn/docs/web3.js/>
     - web3
     - web3-eth
     - web3-shh
     - web3-bzz
     - web3-net
     - web3-utils
   - ethers.js
     - Ethers.provider
     - Ethers.contract
     - Ethers.utils
     - Ethers.wallets
   - ethers.js 比较 web3.js <https://learnblockchain.cn/article/1851>

# 端口

- 默认 http rpc 端口: 8545 `geth --http.port 8545`
- 默认 ws rpc 端口: 8546 `geth --ws.port 8546`
- 默认网络端口: 30303 `geth --port 30303` network listening port. 不能和 http.port 一样！

# 私有链

https://geth.ethereum.org/docs/interface/private-network
只有当 networkid、chainID、创世区块都相同时，才是同一条链。chainID 不是 networkid，但 metatask 等工具可能错误的混用了，因此为了兼容，可以把 chainId 和 networkid 设成一样。<https://www.jianshu.com/p/b8730a05eb36> <https://learnblockchain.cn/article/578>

已被使用的 chainId 列表: <https://chainlist.org/zh>

我的 PEX 链的默认端口：

- pex=739
- chainid 6739
- networkid 6739
- rpc 端口/http.port 6739
- 网络端口/port 60739

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
