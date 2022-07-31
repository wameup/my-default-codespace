# <https://zhuanlan.zhihu.com/p/497532168> <https://blog.csdn.net/weixin_44029550/article/details/110200472>
# 编译：
#  - 用命令行编译器 solc
#  - go to https://remix.ethereum.org, compile contract, click "Compilation Details", copy BYTECODE.object and ABI, prefix bytecode with '0x'
#  - 用 npx hardhat compile
# 部署合约：
#  - 用 JavaScript console
#  - 用 JSON-RPC eth_sendTransaction 参见 <https://ethereum.org/en/developers/docs/apis/json-rpc/#deploying-contract>
#  - 用 hardhat
# 调用：
#  - 用 JavaScript console
#  - 用 JSON-RPC eth_call 调用

bytecodeMultip = "0x608060405234801561001057600080fd5b5060bb8061001f6000396000f300608060405260043610603f576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063c6888fa1146044575b600080fd5b348015604f57600080fd5b50606c600480360381019080803590602001909291905050506082565b6040518082815260200191505060405180910390f35b60006007820290509190505600a165627a7a723058209135a65fdddd7be677810243db99bc4cbe46fcf74ee4ce1a3a8cc7fdbab004ef0029"
web3.eth.estimateGas({data: bytecodeMultip})

abiMultip = JSON.parse('[{"constant":true,"inputs":[{"name":"a","type":"uint256"}],"name":"multiply","outputs":[{"name":"d","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"}]')
ContractMultip = web3.eth.contract(abiMultip)

personal.unlockAccount(eth.coinbase, '123')

contractMultip = ContractMultip.new({data: bytecodeMultip, gas: 1000000, from: eth.coinbase}, function(e, contract){
  if(!e){
    if(!contract.address){
      console.log("Contract transaction send: Transaction Hash: "+contract.transactionHash+" waiting to be mined...");
    }else{
      console.log("Contract mined! Address: "+contract.address);
    }
  }else{
    console.log(e)
  }
})

contractMultip
/*
{
  abi: [{
      constant: true,
      inputs: [{...}],
      name: "multiply",
      outputs: [{...}],
      payable: false,
      stateMutability: "view",
      type: "function"
  }],
  address: "0x2b2de91719b2f3d195e73eee2dc99b6c809bd472",
  transactionHash: "0xef61108703d705cffd21e899bc01f7d1c41c84f97887a4768fbb84ce68f2b654",
  allEvents: function bound(),
  multiply: function bound()
}
*/

contractMultip.multiply(62, {from:eth.coinbase})

# 通过 eth_call + 函数签名 调用智能合约的函数

# 1. 先把"函数名(逗号间隔的参数类型)"进行哈希取前4个字节作为函数签名
进入 geth JavaScript console
> var func_sign_multiply = web3.sha3('multiply(uint256)').substr(2,8) # => c6888fa1

或者 调用 JSON-RPC
node -e 'console.log(Buffer.from("get()").toString("hex").substr(2,8))' # => 6765742829
curl http://localhost:6739 --data '{"method":"web3_sha3","params":["0x6765742829"],"jsonrpc":"2.0","id":1}' -X POST -H "Content-Type: application/json"

# 2. 然后拼接 '0x' + 函数哈希码 + 参数值(如果为空，不要填或者填32字节全0即可），参见 <https://docs.soliditylang.org/en/develop/abi-spec.html> ABI规范
curl http://localhost:6739 --data '{"method": "eth_call", "params":[{"to":"0x2b2de91719b2f3d195e73eee2dc99b6c809bd472", "data":"0xc6888fa10000000000000000000000000000000000000000000000000000000000000002"},"latest"],"id":1}' -X POST -H "Content-Type: application/json"

# name()
curl http://localhost:6739 --data '{"method": "eth_call", "params":[{"to":"0x2b2de91719B2f3d195E73EEe2DC99b6C809bD472", "data":"0x06fdde03"},"latest"],"id":1}' -X POST -H "Content-Type: application/json"
result="0x
0000000000000000000000000000000000000000000000000000000000000020
0000000000000000000000000000000000000000000000000000000000000013
5065726d616e656e74204578697374656e636500000000000000000000000000"
返回了96字节
# 返回字符串 "Permanent Existence" 编码：长度 0x13 + ascii
135065726d616e656e74204578697374656e6365 
==
  P e r m a n e n t   E x i s t e n c e

# balanceOf(address) 
# address 做参数，要在前面填0补足32字节
# eth_call 需要第二个数组元素指定 block number，默认为 latest
curl http://localhost:6739 --data '{"method": "eth_call", "params":[{"to":"0x2b2de91719B2f3d195E73EEe2DC99b6C809bD472", "data":"0x70a082310000000000000000000000003831e121b349aebaea8ed0c44d4c7cb7b15ad8ad"},"latest"],"id":1}' -X POST -H "Content-Type: application/json"


# mintNFT() 14f710fe
# eth_transaction 不需要第二个数组元素，加了就死了
curl http://localhost:6739 --data '{"method": "eth_call", "params":[{"from":"0x3831e121b349aebaea8ed0c44d4c7cb7b15ad8ad","to":"0x2b2de91719B2f3d195E73EEe2DC99b6C809bD472", "data":"0x14f710fe","gas":"0xc35000"}],"id":1}' -X POST -H "Content-Type: application/json"

{"jsonrpc":"2.0","id":1,"result":"0xe80e7f1d78ad00d2e9bf6779cebb3105c2b4f119cb6abe63419fda995c9c082e"}