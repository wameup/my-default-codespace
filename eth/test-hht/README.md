# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
GAS_REPORT=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

# luk 笔记

hardhat 编译结果和 remix 的是否一致？用 contract-multip.sol 做测试
结论：虽然都用了 0.4.18，但 bytecode 有一些不同
