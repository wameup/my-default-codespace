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
# 0x3831e121b349aebaea8ed0c44d4c7cb7b15ad8ad
geth --datadir ./pex-data/ account new
# 921b248a470f7d0bba40077c7aee3ab3440caa77

# 给上面生成的账户在 genesis-clique.json 里设置初始金额
# 不过，私有链挖矿比较容易，所以实际上不需要预置有币的账号，需要的时候自己创建即可以

# 初始化链上数据，存放在 [datadir]/geth/
geth --datadir ./pex-data/ init genesis-ethash.json
geth --datadir ./pex-data-clique/ init genesis-clique.json

# 生成 [datadir]/geth.ipc 。
# 如果不是用 pm2 而是直接用 geth，那么可以在最后加 console
# shh 是 whisper 协议，好像要先启动 websocket 接口才能启用。
pm2 start -x 'geth' --name geth-pex -- --datadir ./pex-data/ --http --http.addr 127.0.0.1 --http.port 6739 --http.api eth,net,web3,personal,admin,miner,debug,txpool,shh --http.corsdomain "*" --nodiscover --networkid 6739 --port 60739 --allow-insecure-unlock
pm2 start -x 'geth' --name geth-pex-clique -- --datadir ./pex-data-clique/ --http --http.addr 127.0.0.1 --http.port 6739 --http.api eth,net,web3,personal,admin,miner,debug,txpool,shh --http.corsdomain "*" --nodiscover --networkid 6739 --port 60739 --allow-insecure-unlock
pm2 log # 跟踪进程

# 连接上去，使用 JavaScript console 交互
geth attach http://127.0.0.1:6739 # 或者 ./[datadir]/geth.ipc
> eth.blockNumber
> personal.listAccounts
> eth.coinbase # 确认已设置挖矿地址，否则 miner.setEtherbase(eth.accounts[0])
> web3.eth.getBalance(eth.coinbase)
> personal.unlockAccount(eth.coinbase, '123') # 为了转账，需要解锁账户。注意，为了挖矿不需要。
> eth.sendTransaction({from:eth.coinbase, to:eth.accounts[1], value: web3.toWei(1, "ether")})
> txpool.status
> txpool.inspect.pending
> miner.start(1);admin.sleepBlocks(1);miner.stop(); # miner.start(threadCount)
> admin.nodeInfo

# 使用 Ethereum JSON-RPC 交互 必须提供一个任意 id 否则返回为空
curl http://localhost:6739 --data '{"id":1, "method": "admin_nodeInfo"}' -X POST -H "Content-Type: application/json"
curl http://localhost:6739 -d '{"method":"eth_blockNumber","params":[],"jsonrpc":"2.0","id":1}' -X POST -H "Content-Type: application/json"
curl http://localhost:6739 -d '{"method":"eth_getBalance","params":["0x3831e121b349aebaea8ed0c44d4c7cb7b15ad8ad"],"jsonrpc":"2.0","id":1}' -X POST -H "Content-Type: application/json"
curl http://localhost:6739 -d '{"method":"eth_accounts","params":[],"jsonrpc":"2.0","id":1}' -X POST -H "Content-Type: application/json"
