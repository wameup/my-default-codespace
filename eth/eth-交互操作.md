# 交互

几种调用方法 <https://blog.csdn.net/weixin_44029550/article/details/110009549>

## command line

- `geth -h`
- <https://geth.ethereum.org/docs/interface/command-line-options>

## JavaScript Console

<https://geth.ethereum.org/docs/interface/javascript-console>
The purpose of Geth’s Javascript console is to provide a built-in environment to use <font color="red">a subset of the Web3.js</font> libraries to interact with a Geth node.

- 交互式 `geth --datadir [datadir] console`
- 交互式 `geth attach [network or ipcpath]`
- 非交互式执行 `geth attach --exec eth.accounts`
- 内置了 web3 对象，但是很老的，参见 <https://github.com/ethereum/go-ethereum> (note: the web3 version bundled within geth is very old, and not up to date with official docs)
  - admin <https://geth.ethereum.org/docs/rpc/ns-admin> 这是标准 web3.js 里没有的。
- 当获取合约实例之后（比如 testInstance），在 geth console 中可以通过三种方法调用合约方法 <https://zhuanlan.zhihu.com/p/26089385>
  - `testInstance.testFunc.sendTransaction()` 会创建一个交易，调用之后会返回一个交易 hash 值，它会广播到网络，等待矿工打包, 它会消耗 gas。
  - `testInstance.testFunc.call()` 它完全是一个本地调用，不会向区块链网络广播任何东西，它的返回值完全取决于 testFunc 方法的代码，不会消耗 gas
  - `testInstance.testFunc()` 如果 testFunc() 有 constant 标识，即不会修改状态变量，它并不会被编译器执行，web3.js 会执行 call()的本地操作。相反如果没有 constant 标识，会执行 sendTransaction()操作。

## JSON-RPC

over http|websocket|unix-socket. 默认 rpc 端口 http:8545, ws:8546.

参见

- Ethereum JSON-RPC 协议规范 <https://ethereum.org/en/developers/docs/apis/json-rpc/>
- Geth JSON-RPC 实现 <https://geth.ethereum.org/docs/rpc/server>

### 启用 JSON-RPC

- `geth --http --http.port 8545 --http.addr 127.0.0.1 --http.api eth,net,web3,personal,admin,miner,debug,txtool,shh`
  - `geth attach [http://addr:port]`
- `geth --ws --ws.addr 127.0.0.1 --ws.port 8546 --ws.api eth,net,web3`
- `geth --ipcpath [IPCPATH]` 或者禁用 `geth --ipcdiable`
  - Path default to `~/.etherum/geth.ipc` on Nix or `\\.\pipe\geth.ipc` on Windows
  - `geth attach ipc:[IPCPATH]` 或者 `geth attach [IPCPATH]`
- 同一台主机上两个实例不能共用一样的 http.port, ws.port 或 ipcpath

### JSON-RPC 规范

- data types and (hex) encoding
  - 注意，JSON-RPC 所有参数都要求是 hex 编码的，所以比如 "method":"web3_sha3", "params":["get()"] 是不行的
  - quantities (integers, numbers, ...):
    - 0x0: 0
    - 0x1: 1
    - 0x40: 64
    - 0x400: 1024
  - unformated (byte arrays, addresses, hashes, ...):
    - 0x: ''
    - 0x41: 'A'
    - 0x004100: '\0A\0'
- API
  - web3_xxx
    - clientVersion, sha3
  - net_xxx
    - version, listening, peerCount
  - eth_xxx
    - syncing, coinbase, mining, hashrate, gasPrice, accounts, blockNumber, getBalance, getStorageAt,
    - getTransactionCount, getBlockTransactionCountByHash, getBlockTransactionCountByNumber, getUncleCountByBlockHash, getUncleCountByBlockNumber,
    - getCode, sign, signTransaction, sendTransaction, sendRawTransaction
    - call, estimateGas, getBlockByHash, getBlockByNumber, getTransactionByHash, getTransactionByBlockHashAndIndex, getTransactionByBlockNumberAndIndex, getTransactionReceipt, getUncleByBlockHashAndIndex, getUncleByBlockNumberAndIndex, getCompilers, compileSolidity, compileLLL, compileSerpent, newFilter, newBlockFilter, newPendingTransactionFilter, uninstallFilter, getFilterChanges, getFilterLogs, getLogs, getWork, submitWork, submitHashrate
  - db_xxx (deprecated)
  - shh_xxx (deprecated)

## 编程接口库/JavaScript API

- web3.js 是以太坊基金会支持的封装了 JSON-RPC，方便 js 客户端调用 <https://github.com/ChainSafe/web3.js> <https://learnblockchain.cn/docs/web3.js/> <https://web3js.readthedocs.io/>
  - var Web3 = require('web3')
    - Web3.utils/version/givenProvider/providers/modules
  - var web3 = new Web3(Web3.givenProvider || 'http://localhost:6739')
    - web3.version, extend()
    - web3.setProvider(), currentProvider, givenProvider, providers, BatchRequest()
    - web3.eth // 等价于 var Eth = require('web3-eth'); var eth = new Eth(Eth.givenProvider || '...')
      - 本包中函数所返回的以太坊地址均为校验和地址
      - subscribe
      - setProvider(...), providers, givenProvider, currentProvider, BatchRequest()
      - extend(...)
      - getAccounts(callback), getBlockNumber, getBalance, getBlock, getTransaction, getHashrate, getCoinbase, getGasPrice, getChainId, getNodeInfo, getProof
      - sign, signTransaction
      - sendTransaction, sendSignedTransaction
      - estimateGas
      - Contract
        - new web3.eth.Contract(jsonInterface[, address][, options])
        - defaultAccount, defaultBlock, defaultChain
        - deploy
        - methods.[myFunc].call: 不发送交易，不能修改合约状态
        - methods.[myFunc].send: 发送交易，可以修改合约状态
        - methods.[myFunc].estimateGas/encodeABI
      - Iban
      - personal
        - signTransaction, sendTransaction, getAccounts, lockAccount, unlockAccount
      - accounts
        - create, sign, encrypt, decrypt, wallet, wallet.\*
      - ens, abi, net
    - web3.shh
    - web3.bzz
    - web3.utils
      - randomHex, isHex, isHexStrict, toHex
      - sha3, sha3Raw, isAddress
      - BN, isBN, isBigNumber, toBN
      - hexToNumber, numberToHex, hexToUtf8, utf8ToHex, hexToAscii, asciiToHex, hexToBytes, bytesToHex
      - toWei, fromWei
    - web3.\*.net
      - getId: web3.[eth,bzz,shh].net.getId(callback)
      - getPeerCount
      - isListening
- ethers.js <https://learnblockchain.cn/docs/ethers.js/>
  - ethers.Provider
  - ethers.Wallet
    - let wallet = new ethers.Wallet(privateKey)
    - let wallet = ethers.Wallet.createRandom()
    - wallet.sign(transaction)
  - ethers.Contract
    - 部署新合约：let contract = await (new ethers.ContractFactory(abi, bytecode, wallet)).deploy(构造函数参数值); await contract.deployed()
    - 连接老合约：let contract = new ethers.Contract(contractAddress, abi, provider)
    - 调用视图方法（只查询，不能修改状态，免费）
    - 调用非视图方法（可修改状态，收费）
  - ethers.utils
    - getAddress, getContractAddress, computeAddress
    - keccak256
  - ethers.constants
- ethers.js 比较 web3.js <https://learnblockchain.cn/article/1851>
