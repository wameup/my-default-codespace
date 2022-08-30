#!/bin/bash

## https://github.com/wameup/FabricLearn

## Add dev container configuration, set to go + node + docker-in-docker, comment out `"remoteUser": "vscode"` in .devcontainer/devcontainer.json

## apt update && apt install curl golang jq -y

# fabric not compatible with arm because there is no hyperledger-fabric-linux-aarch64-2.4.4.tar.gz
# bootstrap.sh is equal to `curl -sSL https://bit.ly/2ysbOFE | bash -s`
# bootstrap.sh 在国内主机上下载很艰难。不管失败与否，都需要按以下流程重新做一遍：
echo "=== 使用官方初始化脚本 bootstrap.sh ? y for yes, anything else for no"
read -p ">>> " UseBootstrap
echo
if [ $UseBootstrap ] && [ $UseBootstrap='y' ]
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
echo "=== 查看 docker iamges"
read -p ">>> 按回车键继续 >>>"

docker images

echo
echo "=== 下载 fabric-samples"
read -p ">>> 按回车键继续 >>>"

git clone https://github.com/hyperledger/fabric-samples.git
ln -s /usr/local/fabric/bin ./fabric-samples/
ln -s /usr/local/fabric/config ./fabric-samples/

echo
echo "=== 启动测试网络"
read -p ">>> 按回车键继续 >>>"
## . /etc/profile
export FABRIC=/usr/local/fabric
export PATH=$PATH:$FABRIC/bin
cd fabric-samples/test-network
./network.sh up

echo
echo "=== 创建 org1 和 org2 之间通道"
read -p ">>> 按回车键继续 >>>"
./network.sh createChannel -c testchannel

echo
echo "=== 为了部署 chaincode，如果在中国，需要设 golang 代理，y for yes, anything else for no"
read -p ">>> " GolangChina
echo
if [ $GolangChina ] && [ $GolangChina='y' ] 
then
  echo "  === go 1.13 及以上"
  go env -w GO111MODULE=on && go env -w GOPROXY=https://goproxy.cn,direct
  echo "  === 其他版本"
  export GO111MODULE=on && export GOPROXY=https://goproxy.cn,direct
# else
#   echo "  === 取消 go 代理"
#   go env -u GOPROXY
fi

echo
echo "=== 部署 chaincode"
read -p ">>> 按回车键继续 >>>"
echo
./network.sh deployCC -c testchannel -ccn basic -ccp ../asset-transfer-basic/chaincode-go -ccl go

echo
echo "=== 测试合约交互"
echo
export FABRIC_CFG_PATH=$PWD/../config/
echo "  === 设置 org1 环境变量"
read -p "  >>> 按回车键继续 >>>"
# CORE_PEER_TLS_ROOTCERT_FILE和CORE_PEER_MSPCONFIGPATH环境变量指向Org1的organizations文件夹中的身份证书。
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

echo
echo "  === 初始化 chaincode for org1"
read -p "  >>> 按回车键继续 >>>"
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C testchannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"InitLedger","Args":[]}'

echo
echo "  === 查询资产"
read -p "  >>> 按回车键继续 >>>"
peer chaincode query -C testchannel -n basic -c '{"Args":["GetAllAssets"]}'

echo
echo "  === 修改资产（如果直接在 shell script 里顺序执行，会出错。必须稍等一会儿执行才会成功）"
read -p "  >>> 按回车键继续 >>>"
echo
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C testchannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"TransferAsset","Args":["asset6","Christopher"]}'

echo
echo "=== 关闭测试网络"
read -p ">>> 按回车键继续 >>>"
./network.sh down
