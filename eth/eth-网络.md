# 共识算法

- clique: Proof of Authority <http://yangzhe.me/2019/02/01/ethereum-clique/>
- ethash: Proof of Work

# 网络 <https://ethereum.org/en/developers/docs/networks>

- ropsten (deprecated): PoW
- kovan (deprecated): PoA
- rinkeby (deprecated): PoA
- sepolia: PoW
- goerli: PoA
  - `geth --goerli/rinkeby/ropsten console --syncmode light/full`
- 本地网：
  - [ganache](https://github.com/trufflesuite/ganache) ( <= [ganache-cli](https://github.com/trufflesuite/ganache-cli-archive) <= [ethereumjs-testrpc](https://github.com/ethereumjs/testrpc) )
    - `npx ganache`
    - 属于 truffle 三大组件之一
  - [ganache-ui](https://github.com/trufflesuite/ganache-ui) 是个桌面程序，不依赖于 ganache-cli。或者从官网下载 <https://trufflesuite.com/ganache/>
  - [Hardhat Network](https://hardhat.org/hardhat-network)
- 私有链 <https://geth.ethereum.org/docs/interface/private-network>
  只有当 networkid、chainID、创世区块都相同时，才是同一条链。chainID 不是 networkid，但 metatask 等工具可能错误的混用了，因此为了兼容，可以把 chainId 和 networkid 设成一样。<https://www.jianshu.com/p/b8730a05eb36> <https://learnblockchain.cn/article/578>
  已被使用的 chainId 列表: <https://chainlist.org/zh>
