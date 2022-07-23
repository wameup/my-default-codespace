#!/bin/bash

# 假设目前在 my-default-codespace/eth 目录下
wget -P ./bin https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.20-8f2416a8.tar.gz
tar xzf ./bin/geth-linux-amd64-1.10.20-8f2416a8.tar.gz -C ./bin
ln -s `pwd`/bin/geth-linux-amd64-1.10.20-8f2416a8/geth /usr/local/bin/

echo "=== 生成新账户"
# 生成 [datadir]/keystore/ 下的钱包文件
geth account new --datadir ./pex-data/ 
# 0x3831e121b349aebaea8ed0c44d4c7cb7b15ad8ad
geth account list --datadir ./pex-data/
# 私有链挖矿比较容易，所以实际上不需要预置有币的账号，需要的时候自己创建即可以

# 添加
geth --datadir ./pex-data/ init genesis-ethash.json
geth --datadir ./pex-data-clique/ init genesis-clique.json

# 生成 [datadir]/ 下的 链上数据 geth/ 和 geth.ipc 
pm2 start -x 'geth' --name geth-pex -- --datadir ./pex-data/ --http --http.addr 127.0.0.1 --http.port 6739 --http.api eth,net,web3,personal,admin,miner,debug,txpool,shh --http.corsdomain "*" --nodiscover --networkid 6739 --port 60739 --allow-insecure-unlock [console]
pm2 start -x 'geth' --name geth-pex-clique -- --datadir ./pex-data-clique/ --http --http.addr 127.0.0.1 --http.port 6739 --http.api eth,net,web3,personal,admin,miner,debug,txpool,shh --http.corsdomain "*" --nodiscover --networkid 6739 --port 60739 --allow-insecure-unlock [console]

geth attach http://127.0.0.1:6739
> personal.unlockAccount(eth.coinbase, '123')
> eth.sendTransaction({from:eth.coinbase, to:eth.accounts[1], value: web3.toWei(1, "ether")})
> txpool.status
> txpool.inspect.pending
> miner.start(1);admin.sleepBlocks(1);miner.stop();

curl http://localhost:6739 --data '{"id":6739, "method": "admin_nodeInfo"}' -X POST -H "Content-Type: application/json" # 必须提供一个任意 id 否则返回为空
curl http://localhost:6739 -d '{"method":"eth_blockNumber","params":[],"jsonrpc":"2.0","id":1}' -X POST -H "Content-Type: application/json"
curl http://localhost:6739 -d '{"method":"eth_getBalance","params":["0x3831e121b349aebaea8ed0c44d4c7cb7b15ad8ad"],"jsonrpc":"2.0","id":1}' -X POST -H "Content-Type: application/json"
curl http://localhost:6739 -d '{"method":"eth_accounts","params":[],"jsonrpc":"2.0","id":1}' -X POST -H "Content-Type: application/json"
