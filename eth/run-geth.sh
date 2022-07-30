#!/bin/bash

# 假设目前在 my-default-codespace/eth 目录下
# 下载二进制
wget -P ./bin https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.20-8f2416a8.tar.gz
tar xzf ./bin/geth-linux-amd64-1.10.20-8f2416a8.tar.gz -C ./bin
ln -s `pwd`/bin/geth-linux-amd64-1.10.20-8f2416a8/geth /usr/local/bin/
# 或者 下载源代码进行编译
git clone -b v1.10.20 https://github.com/ethereum/go-ethereum ./bin/go-ethereum
pushd ./bin/go-ethereum && make geth && popd # 或者 make all
ln -s `pwd`/bin/go-ethereum/build/bin/geth /usr/local/bin/

echo "=== 生成新账户，存放在 [datadir]/keystore/"
geth --datadir ./pex-data/ account list # 检查现有账户。如果 ./pex-data/ 已经有数据，就不用生成新账户
# 生成 [datadir]/keystore/ 下的钱包文件
geth --datadir ./pex-data/ account new # 密码设为 123
# 0x3831e121b349aebaea8ed0c44d4c7cb7b15ad8ad 导入 MetaMask 可得到密钥 0xd2ed4496be1251a7f55772bba6ef1106ec330e27002898a5e1c69cd4e39de965
geth --datadir ./pex-data/ account new
# 0x921b248a470f7d0bba40077c7aee3ab3440caa77

# 给上面生成的账户在 genesis-clique.json 里设置初始金额
# 不过，私有链挖矿比较容易，所以实际上不需要预置有币的账号，需要的时候自己创建即可以

# 初始化链上数据，存放在 [datadir]/geth/
geth --datadir ./pex-data/ init genesis-ethash.json
geth --datadir ./pex-data-clique/ init genesis-clique.json

# 生成 [datadir]/geth.ipc 。
# 如果不是用 pm2 而是直接用 geth，那么可以在最后加 console
# shh 是 whisper 协议，好像要先启动 websocket 接口才能启用。
# 我的 PEX 链的默认端口：
# - pex=739
# - chainid 6739
# - networkid 6739
# - rpc 端口/http.port 6739
# - 网络端口/port 60739

pm2 start -x 'geth' --name geth-pex -- --datadir ./pex-data/ --http --http.addr 127.0.0.1 --http.port 6739 --http.api eth,net,web3,personal,admin,miner,debug,txpool,shh --http.corsdomain "*" --nodiscover --networkid 6739 --port 60739 --allow-insecure-unlock
pm2 start -x 'geth' --name geth-pex-clique -- --datadir ./pex-data-clique/ --http --http.addr 127.0.0.1 --http.port 6739 --http.api eth,net,web3,personal,admin,miner,debug,txpool,shh --http.corsdomain "*" --nodiscover --networkid 6739 --port 60739 --allow-insecure-unlock
pm2 log # 跟踪进程

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

# 使用 Ethereum JSON-RPC 交互 必须提供一个任意 id 否则返回为空
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