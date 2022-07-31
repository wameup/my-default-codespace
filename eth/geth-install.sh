#!/bin/bash

echo "=== Install geth：[b] for 二进制， [s] for 源代码，[anything else or leave blank] for no change"
read -p ">>> " BINARY_OR_SOURCE
if [ $BINARY_OR_SOURCE ] && [ $BINARY_OR_SOURCE == 'b' ]
then
  echo "--- 下载二进制 geth"
  wget -P ./geth-temp/ https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.20-8f2416a8.tar.gz
  tar xzf ./geth-temp/geth-linux-amd64-1.10.20-8f2416a8.tar.gz -C ./geth-temp/
  mv ./geth-temp/geth-linux-amd64-1.10.20-8f2416a8/geth /usr/local/bin/
  rm -fr ./geth-temp/
elif [ $BINARY_OR_SOURCE ] && [ $BINARY_OR_SOURCE == 's' ]
then
  echo "--- 克隆并编译 geth"
  git clone -b v1.10.20 https://github.com/ethereum/go-ethereum ./geth-temp/go-ethereum
  pushd ./geth-temp/go-ethereum && make geth && popd # 或者 make all
  mv ./geth-temp/go-ethereum/build/bin/geth /usr/local/bin/
  rm -fr ./geth-temp/
else
  echo "--- Nothing changed."
fi
echo ""
