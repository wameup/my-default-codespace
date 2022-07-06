#!/bin/bash

wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.20-8f2416a8.tar.gz
tar xzf geth-linux-amd64-1.10.20-8f2416a8.tar.gz
ln -s `pwd`/bin/geth-linux-amd64-1.10.20-8f2416a8/geth /usr/local/bin/

echo "=== 生成新账户"
# 生成 [datadir]/keystore/ 下的钱包文件
geth account new --datadir ./pex-data/
geth account list --datadir ./pex-data/
# 私有链挖矿比较容易，所以实际上不需要预置有币的账号，需要的时候自己创建即可以

# 添加
geth --datadir ./pex-data/ init genesis.json

# 生成 [datadir]/ 下的 链上数据 geth/ 和 geth.ipc 
pm2 start -x 'geth' --name geth-pex -- --datadir ./pex-data/ --http --http.addr 127.0.0.1 --http.port 6739 --http.api eth,net,web3,personal,admin,miner,debug,txpool,shh --http.corsdomain "*" --nodiscover --networkid 6739 --port 60739 --allow-insecure-unlock [console]

geth attach http://127.0.0.1:6739
personal.unlockAccount(eth.coinbase, '123')

eth.sendTransaction({from:eth.coinbase, to:eth.accounts[1], value: web3.toWei(1, "ether")})

curl http://localhost:6739 -X POST --data '{"id":6739, "method": "admin_nodeInfo"}' -H "Content-Type: application/json" # 必须提供一个任意 id 否则返回为空

########################

#####################
