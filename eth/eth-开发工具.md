# 开发工具

- hardhat + ethers.js <https://hardhat.org/> <https://learnblockchain.cn/docs/hardhat/getting-started/> <https://zhuanlan.zhihu.com/p/353251375>
- truffle + web3.js <https://trufflesuite.com/> <https://github.com/trufflesuite/truffle>
  - Quick start <https://trufflesuite.com/docs/truffle/quickstart/>
- embark <https://framework.embarklabs.io/>

they are like vuejs for web projects, while source code is in solidity or html/css/js, respectively.

```
truffle init
truffile unbox metacoin
truffle develop # 启动内置的链（无视truffle-config.js里的networks设置），并进入console
truffle console # 连接到 truffle-config.js 里的 networks 设置
truffle compile
truffle migrate
```
