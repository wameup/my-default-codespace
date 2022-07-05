- download binaries <https://geth.ethereum.org/downloads/>
  - Windows <https://gethstore.blob.core.windows.net/builds/geth-windows-amd64-1.10.20-8f2416a8.exe>
  - Linux <https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.20-8f2416a8.tar.gz>
  - MacOS <https://gethstore.blob.core.windows.net/builds/geth-darwin-amd64-1.10.20-8f2416a8.tar.gz>
  - Sources <https://github.com/ethereum/go-ethereum/archive/v1.10.20.tar.gz>
- clone source repository
  - `git clone https://github.com/ethereum/go-ethereum -b v1.10.20`
    - `cd go-ethereum && make [geth|all] && ./build/bin/geth version`
  - `wget https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.10.20.tar.gz`
- pull docker
  - `docker pull ethereum/client-go:v1.10.20`

文档
https://geth.ethereum.org/docs

npx ganache-cli (取代了 testrpc)

交互

1. JavaScript Console

- 也内置了 web3 对象，但是很老的，参见 <https://github.com/ethereum/go-ethereum> (note: the web3 version bundled within geth is very old, and not up to date with official docs)

2. JSON-RPC: over http|websocket|unix-socket.

- `geth --http --http.port 8545 --http.addr 127.0.0.1 --http.api eth,net,web3,personal,admin,miner,debug,txtool,shh`
  - `geth attach http://addr:port ...
- `geth --ws --ws.addr *** --ws.port 8546 --ws.api eth,net,web3`
- `geth --ipcpath [PATH]`

  - Path default to `~/.etherum/geth.ipc` on Nix or `\\.\pipe\geth.ipc` on Windows
  - `geth attach ipc:[PATH]`

- `geth --port 30303` network listening port. 不能和 http.port 一样！

3. web3.js 是以太坊基金会支持的封装了 JSON-RPC，方便 js 客户端调用

   - web3
   - web3-eth
   - web3-shh
   - web3-bzz
   - web3-net
   - web3-utils

4. ethers.js （与 web3.js 比较 https://learnblockchain.cn/article/1851 ）
   - Ethers.provider
   - Ethers.contract
   - Ethers.utils
   - Ethers.wallets

https://geth.ethereum.org/docs/interface/private-network
只有当 network、chainID、创世区块配置都相同时，才是同一条链。chainID 不是 networkid，但 metatask 等工具可能错误的混用了，因此为了兼容，可以把 chiinId 和 networkid 设成一样。<https://www.jianshu.com/p/b8730a05eb36> <https://learnblockchain.cn/article/578>

已被使用的 chainId 列表: <https://chainlist.org/zh>

pex=739
chainid 6739
networkid 6739
port 60739

部署合约 https://github.com/nibbstack/erc721

当获取合约实例之后（比如 testInstance），在 geth console 中可以通过三种方法调用合约方法（比如 testFunc）

<https://zhuanlan.zhihu.com/p/26089385>
testInstance.testFunc.sendTransaction();
testInstance.testFunc();
testInstance.testFunc.call();
本文将讲解这三种调用方法的区别
testInstance.testFunc.sendTransaction(); 会创建一个交易，调用之后会返回一个交易 hash 值，它会广播到网络，等待矿工打包, 它会消耗 gas。
testInstance.testFunc.call(); 它完全是一个本地调用，不会向区块链网络广播任何东西，它的返回值完全取决于 testFunc 方法的代码，不会消耗 gas
testInstance.testFunc(); 它会比较特殊，由于有 constant 标识的方法不会修改状态变量，所以它不会被编译器执行。所以，如果 testFunc() 有 constant 标识，它并不会被编译器执行，web3.js 会执行 call()的本地操作。相反如果没有 constant 标识，会执行 sendTransaction()操作。
