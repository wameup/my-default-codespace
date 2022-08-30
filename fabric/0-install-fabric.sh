#!/bin/bash

## Add dev container configuration, set to go + node + docker-in-docker, comment out `"remoteUser": "vscode"` in .devcontainer/devcontainer.json

## apt update && apt install curl golang jq -y

# fabric not compatible with arm because there is no hyperledger-fabric-linux-aarch64-2.4.4.tar.gz
# bootstrap.sh is equal to `curl -sSL https://bit.ly/2ysbOFE | bash -s -- fabric版本 ca版本`
# bootstrap.sh 在国内主机上下载很艰难。不管失败与否，都需要按以下流程重新做一遍：
echo "=== 使用官方初始化脚本 bootstrap.sh ? y for yes, anything else for no"
read -p ">>> " UseBootstrap
echo
if [ $UseBootstrap] && [ $UseBootstrap='y' ]
then
  wget https://raw.githubusercontent.com/hyperledger/fabric/master/scripts/bootstrap.sh
  chmod +x bootstrap.sh
  echo "=== Cloning fabric-samples, "
  echo "=== downloading hyperledger-fabric-linux-amd64-2.4.4 and hyperledger-fabric-ca-linux-amd64-1.5.4, copy to fabric-samples/bin and config, "
  echo "=== pulling hyperledger/fabric-xxx images and tag as latest: "
  ./bootstrap.sh
  echo "=== Checking images downloaded:"
  docker images
fi

mkdir /usr/local/fabric

echo
echo "=== 下载 fabric 和 fabric-ca，安装到 /usr/local/fabric"
read -p ">>> 按回车键继续 >>>"
## it contains bin/* and config/*
if [ ! -e hyperledger-fabric-linux-amd64-2.4.4.tar.gz ]
then
  wget https://github.com/hyperledger/fabric/releases/download/v2.4.4/hyperledger-fabric-linux-amd64-2.4.4.tar.gz
fi
tar xzvf hyperledger-fabric-linux-amd64-2.4.4.tar.gz -C /usr/local/fabric/

## it contains fabric-ca-client and farbic-ca-server
if [ ! -e hyperledger-fabric-ca-linux-amd64-1.5.4.tar.gz ]
then
  wget https://github.com/hyperledger/fabric-ca/releases/download/v1.5.4/hyperledger-fabric-ca-linux-amd64-1.5.4.tar.gz
fi
tar xzvf hyperledger-fabric-ca-linux-amd64-1.5.4.tar.gz -C /usr/local/fabric/

echo
echo "=== 设置环境变量 FABRIC 和 PATH 指向 /user/local/fabric/"
read -p ">>> 按回车键继续 >>>"
echo 'export FABRIC=/usr/local/fabric' >> /etc/profile
echo 'export PATH=$PATH:$FABRIC/bin' >> /etc/profile

echo 
echo "=== 下载 hyperledger/fabric-* dockers"
read -p ">>> 按回车键继续 >>>"

docker pull hyperledger/fabric-tools:2.4.4
docker pull hyperledger/fabric-peer:2.4.4
docker pull hyperledger/fabric-orderer:2.4.4
docker pull hyperledger/fabric-ccenv:2.4.4
docker pull hyperledger/fabric-baseos:2.4.4
docker pull hyperledger/fabric-ca:1.5.4

docker tag 278009bfeccd hyperledger/fabric-ca:latest
docker tag d2f5f013cf70 hyperledger/fabric-tools:latest
docker tag 080114f6c98f hyperledger/fabric-peer:latest
docker tag 9e5c2bd3cd99 hyperledger/fabric-orderer:latest
docker tag b01eeb054e4c hyperledger/fabric-ccenv:latest
docker tag 1c37de9bc07b hyperledger/fabric-baseos:latest

echo 
echo "=== 查看 docker images"
read -p ">>> 按回车键继续 >>>"

docker images
