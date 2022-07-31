# 连接上去，使用 JavaScript console 交互
geth attach http://127.0.0.1:6739 # 或者 ./[datadir]/geth.ipc
> eth.blockNumber # === web3.eth.blockNumber
> eth.getBlock(eth.blockNumber) # === web3.eth.getBlock(eth.blockNumber) # 通过块号查找区块
> eth.getBlock('latest') # 通过默认值 'latest', 'earliest'
> eth.getBlock(eth.getBlock('latest').hash) # 通过 hash 查找区块
> admin.nodeInfo
> personal.listAccounts # === web3.eth.accounts === eth.accounts
> personal.newAccount()
> eth.coinbase # 确认已设置挖矿地址，否则 miner.setEtherbase(eth.accounts[0])
> web3.eth.getBalance(eth.coinbase)
> web3.fromWei(web3.eth.getBalance(eth.coinbase), 'ether')
> web3.eth.estimateGas({ from: eth.coinbase, to: web3.eth.accounts[1], value: web3.toWei(1, 'ether')}) # 一般简单的转账交易通常会消耗21000gas
> personal.unlockAccount(eth.coinbase, '123', 0) # 用于交易的签名，需要解锁账户。PoW 不需要解锁就能挖矿。PoA 需要解锁账户并在有效期才能挖矿，默认解锁有效期300秒。如果永久解锁被禁用（默认），那么该调用将忽略解锁时长参数，账户 仅为一次签名解锁；当启用永久锁定后，使用解锁时长参数设定保持账户 解锁的秒数，默认值是300秒。传入0则无限期解锁账户。同一时刻只能有一个解锁账户。
> var txId = eth.sendTransaction({from:eth.coinbase, to:eth.accounts[1], value: web3.toWei(1, "ether")})
> var tx = web3.eth.getTransaction(txId)
> eth.getTransactionReceipt(txId)
> txpool.status
> txpool.inspect.pending
> miner.start(1);admin.sleepBlocks(1);miner.stop(); # miner.start(threadCount)
> loadScript('.../xxx.js') # 可以编程导入变量等

# 使用 Ethereum JSON-RPC 交互 必须提供一个任意 id，哪怕 null 也可以，否则返回为空
curl http://localhost:6739 --data '{"method": "admin_nodeInfo","id":1}' -X POST -H "Content-Type: application/json"
curl http://localhost:6739 --data '{"method": "eth_accounts","id":1}' -X POST -H "Content-Type: application/json"
curl http://localhost:6739 --data '{"method": "eth_blockNumber","id":1}' -X POST -H "Content-Type: application/json"
curl http://localhost:6739 -d '{"method":"eth_getBlockByNumber","params":["0x0",true],"jsonrpc":"2.0","id":1}' -X POST -H "Content-Type: application/json"
# 根据上一步获得的 block hash
curl http://localhost:6739 -d '{"method":"eth_getBlockByHash","params":["0xe704143d3cc1aedeaa20cda2cb2e543300787f5e5ae9e7ac95655ec777ea65b7",true],"jsonrpc":"2.0","id":1}' -X POST -H "Content-Type: application/json"
curl http://localhost:6739 -d '{"method":"eth_getBalance","params":["0x3831e121b349aebaea8ed0c44d4c7cb7b15ad8ad"],"jsonrpc":"2.0","id":1}' -X POST -H "Content-Type: application/json"
curl http://localhost:6739 -d '{"method":"eth_sendTransaction","params":[{"from":"0x3831e121b349aebaea8ed0c44d4c7cb7b15ad8ad","to":"0x921b248a470f7d0bba40077c7aee3ab3440caa77","value":"0xde0b6b3a7640000","gas":"0x5208"}],"jsonrpc":"2.0","id":1}' -X POST -H "Content-Type: application/json"
# 根据上一步获得的 tx hash
curl http://localhost:6739 -d '{"method":"eth_getTransactionByHash","params":["0x5c8232ae68541b64f7701c5fe6195a142ba1dc1bd3989986871d9ce49394e342"],"jsonrpc":"2.0","id":1}' -X POST -H "Content-Type: application/json"

# 解析私钥
# https://blog.csdn.net/northeastsqure/article/details/79476831
# https://github.com/ethereumjs/keythereum
# http://t.zoukankan.com/wanghui-garcia-p-9519873.html