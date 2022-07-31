#!/bin/bash

while [ ! $DATADIR ]
do
  echo "=== Set datadir name, for example pex-poa:"
  read -p ">>> " DATADIR
done
echo ""

echo "--- pm2 start geth and create ./$DATADIR/geth.ipc"
# http.addr 127.0.0.1 => 无法从远处连接。要用 0.0.0.0 才能从远处用 IP 连接。
# 如果不是用 pm2 而是直接用 geth，那么可以在最后加 console
# shh 是 whisper 协议，好像要先启动 websocket 接口才能启用。
# 我的 PEX 链的默认端口：
# - pex=739
# - chainid 6739
# - networkid 6739
# - rpc 端口/http.port 6739
# - 网络端口/port 60739
pm2 start -x 'geth' --name $DATADIR -- --datadir ./$DATADIR/ --http --http.addr 0.0.0.0 --http.port 6739 --http.api eth,net,web3,personal,admin,miner,debug,txpool,shh --http.corsdomain "*" --nodiscover --networkid 6739 --port 60739 --allow-insecure-unlock
