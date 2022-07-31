# solidity

<https://docs.soliditylang.org/en/latest/>
<https://solidity.readthedocs.io/en/latest/>

- Remix
- nodejs `npm i -g solc` 获得 `solcjs` 命令，比 `solc` 少一些特性
- docker `docker run ethereum/solc:stable --help`
- Linux
  ```
  sudo add-apt-repository ppa:ethereum/ethereum
  sudo apt-get update
  sudo apt-get install solc
  ```
- MacOS
  ```
  brew update
  brew upgrade
  brew tap ethereum/ethereum
  brew install solidity
  ```

## 全局变量

msg 是合约调用的上下文，包含了合约的名称、版本、参数等信息

- msg.sender: 合约的直接调用者。如果 用户 -> 合约 1 -> 合约 2，那么在 合约 2 里的 msn.sender 是合约 1 的地址。
- msg.calldata: 包含完整的调用信息，包括函数标识、参数等。calldata 的前 4 字节就是函数标识，与 msg.sig 相同。
- msg.sig: msg.calldata 的前 4 字节，用于标识函数。
- msg.gas
- msg.value
