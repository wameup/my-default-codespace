bytecodeMultip = "0x608060405234801561001057600080fd5b5060bb8061001f6000396000f300608060405260043610603f576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063c6888fa1146044575b600080fd5b348015604f57600080fd5b50606c600480360381019080803590602001909291905050506082565b6040518082815260200191505060405180910390f35b60006007820290509190505600a165627a7a723058209135a65fdddd7be677810243db99bc4cbe46fcf74ee4ce1a3a8cc7fdbab004ef0029"
web3.eth.estimateGas({data: bytecodeMultip})

abiMultip = JSON.parse('[{\"constant\":true,\"inputs\":[{\"name\":\"a\",\"type\":\"uint256\"}],\"name\":\"multiply\",\"outputs\":[{\"name\":\"d\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"}]')
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

# 通过 eth_call 调用智能合约
web3.sha3('multiply(uint256)').substr(2,8)
// => c6888fa1

curl http://localhost:6739 -X POST --data '{"id":67, "method": "eth_call", "params":[{"to":"0x2b2de91719b2f3d195e73eee2dc99b6c809bd472", "data":"0xc6888fa10000000000000000000000000000000000000000000000000000000000000002"},"latest"]}' -H "Content-Type: application/json"

