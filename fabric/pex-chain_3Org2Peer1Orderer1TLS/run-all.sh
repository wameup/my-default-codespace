echo "=== 设置 DNS 到 /etc/hosts"
read -p ">>> 按回车键继续 >>>"
echo "127.0.0.1       council.pex-chain.bittic.cn" >> /etc/hosts
echo "127.0.0.1       orderer.pex-chain.bittic.cn" >> /etc/hosts
echo "127.0.0.1       soft.pex-chain.bittic.cn" >> /etc/hosts
echo "127.0.0.1       web.pex-chain.bittic.cn" >> /etc/hosts

echo "127.0.0.1       orderer1.orderer.pex-chain.bittic.cn" >> /etc/hosts

echo "127.0.0.1       peer1.soft.pex-chain.bittic.cn" >> /etc/hosts
echo "127.0.0.1       peer1.web.pex-chain.bittic.cn" >> /etc/hosts

echo
echo "=== 设置通用变量 FABRIC 和 PATH"
read -p ">>> 按回车键继续 >>>"
export FABRIC=/usr/local/fabric
export PATH=$PATH:$FABRIC/bin

echo
echo "=== 设置soft 环境变量"
read -p ">>> 按回车键继续 >>>"
export LOCAL_ROOT_PATH=$PWD
export LOCAL_CA_PATH=$LOCAL_ROOT_PATH/orgs
export DOCKER_CA_PATH=/tmp
export COMPOSE_PROJECT_NAME=fabriclearn
export DOCKER_NETWORKS=network
export FABRIC_BASE_VERSION=2.4
export FABRIC_CA_VERSION=1.5

echo
echo "=== 启动各组织 ca 的 docker container"
read -p ">>> 按回车键继续 >>>"
source envpeer1soft
docker-compose -f $LOCAL_ROOT_PATH/compose/docker-compose.yaml up -d council.pex-chain.bittic.cn orderer.pex-chain.bittic.cn soft.pex-chain.bittic.cn web.pex-chain.bittic.cn

echo
echo "=== 查看 docker ps -a"
read -p ">>> 按回车键继续 >>>"
docker ps -a

echo
echo "=== 注册账户"
echo
echo "  === 注册 council 组织账户"
read -p "  >>> 按回车键继续 >>>"
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/council.pex-chain.bittic.cn/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/council.pex-chain.bittic.cn/ca/admin
fabric-ca-client enroll -d -u https://ca-admin:ca-adminpw@council.pex-chain.bittic.cn:7050
echo
echo "    --- 以 ca-admin 身份注册其他用户"
read -p "    >>> 按回车键继续 >>>"
fabric-ca-client register -d --id.name orderer1 --id.secret orderer1 --id.type orderer -u https://council.pex-chain.bittic.cn:7050
fabric-ca-client register -d --id.name peer1soft --id.secret peer1soft --id.type peer -u https://council.pex-chain.bittic.cn:7050
fabric-ca-client register -d --id.name peer1web --id.secret peer1web --id.type peer -u https://council.pex-chain.bittic.cn:7050

echo 
echo "  === 注册 orderer 组织账户"
read -p "  >>> 按回车键继续 >>>"
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/ca/admin
fabric-ca-client enroll -d -u https://ca-admin:ca-adminpw@orderer.pex-chain.bittic.cn:7150
fabric-ca-client register -d --id.name orderer1 --id.secret orderer1 --id.type orderer -u https://orderer.pex-chain.bittic.cn:7150
fabric-ca-client register -d --id.name admin1 --id.secret admin1 --id.type admin -u https://orderer.pex-chain.bittic.cn:7150

echo 
echo "  === 注册 soft 组织账户"
read -p "  >>> 按回车键继续 >>>"
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/soft.pex-chain.bittic.cn/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/soft.pex-chain.bittic.cn/ca/admin
fabric-ca-client enroll -d -u https://ca-admin:ca-adminpw@soft.pex-chain.bittic.cn:7250
fabric-ca-client register -d --id.name peer1 --id.secret peer1 --id.type peer -u https://soft.pex-chain.bittic.cn:7250
fabric-ca-client register -d --id.name admin1 --id.secret admin1 --id.type admin -u https://soft.pex-chain.bittic.cn:7250

echo 
echo "  === 注册 web 组织账户"
read -p "  >>> 按回车键继续 >>>"
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/web.pex-chain.bittic.cn/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/web.pex-chain.bittic.cn/ca/admin
fabric-ca-client enroll -d -u https://ca-admin:ca-adminpw@web.pex-chain.bittic.cn:7350
fabric-ca-client register -d --id.name peer1 --id.secret peer1 --id.type peer -u https://web.pex-chain.bittic.cn:7350
fabric-ca-client register -d --id.name admin1 --id.secret admin1 --id.type admin -u https://web.pex-chain.bittic.cn:7350

echo
echo "=== 构造组织成员证书"
echo
echo "  === 1.创建各组织的 assets 目录"
read -p "  >>> 按回车键继续 >>>"
mkdir -p $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets
cp $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets/ca-cert.pem
cp $LOCAL_CA_PATH/council.pex-chain.bittic.cn/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets/tls-ca-cert.pem

mkdir -p $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/assets
cp $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/assets/ca-cert.pem
cp $LOCAL_CA_PATH/council.pex-chain.bittic.cn/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/assets/tls-ca-cert.pem

mkdir -p $LOCAL_CA_PATH/web.pex-chain.bittic.cn/assets 
cp $LOCAL_CA_PATH/web.pex-chain.bittic.cn/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/web.pex-chain.bittic.cn/assets/ca-cert.pem
cp $LOCAL_CA_PATH/council.pex-chain.bittic.cn/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/web.pex-chain.bittic.cn/assets/tls-ca-cert.pem

echo
echo "  === 2.构造 orderer 组织成员证书"
read -p "  >>> 按回车键继续 >>>"
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/admin1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin1:admin1@orderer.pex-chain.bittic.cn:7150

mkdir -p $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/admin1/msp/admincerts
cp $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/admin1/msp/admincerts/cert.pem

echo
echo "    --- 登录 orderer 的 orderer1 的组织内账户："
read -p "    >>> 按回车键继续 >>>"
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/orderer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://orderer1:orderer1@orderer.pex-chain.bittic.cn:7150
mkdir -p $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/orderer1/msp/admincerts
cp $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/orderer1/msp/admincerts/cert.pem

echo
echo "    --- 登录 orderer 的 orderer1 的组织间 TLS-CA 账户："
read -p "    >>> 按回车键继续 >>>"
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1:orderer1@council.pex-chain.bittic.cn:7050 --enrollment.profile tls --csr.hosts orderer1.orderer.pex-chain.bittic.cn
cp $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/orderer1/tls-msp/keystore/*_sk $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/orderer1/tls-msp/keystore/key.pem

echo
echo "    --- 构造 orderer 的组织 MSP 目录："
read -p "    >>> 按回车键继续 >>>"
mkdir -p $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/admincerts
mkdir -p $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/cacerts
mkdir -p $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/tlscacerts
mkdir -p $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/users
cp $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets/ca-cert.pem $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/cacerts/
cp $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets/tls-ca-cert.pem $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/tlscacerts/
cp $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/admincerts/cert.pem
cp $LOCAL_ROOT_PATH/config/config-msp.yaml $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/config.yaml

echo
echo "  === 3.构造 soft 组织成员证书："
read -p "  >>> 按回车键继续 >>>"

echo "Start Soft============================="
echo "Enroll Admin"
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/soft.pex-chain.bittic.cn/registers/admin1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/soft.pex-chain.bittic.cn/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin1:admin1@soft.pex-chain.bittic.cn:7250
mkdir -p $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/registers/admin1/msp/admincerts
cp $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/registers/admin1/msp/admincerts/cert.pem

echo "Enroll Peer1"
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/soft.pex-chain.bittic.cn/registers/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/soft.pex-chain.bittic.cn/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://peer1:peer1@soft.pex-chain.bittic.cn:7250
# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/soft.pex-chain.bittic.cn/assets/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1soft:peer1soft@council.pex-chain.bittic.cn:7050 --enrollment.profile tls --csr.hosts peer1.soft.pex-chain.bittic.cn
cp $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/registers/peer1/tls-msp/keystore/*_sk $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/registers/peer1/tls-msp/keystore/key.pem
mkdir -p $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/registers/peer1/msp/admincerts
cp $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/registers/peer1/msp/admincerts/cert.pem

mkdir -p $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/msp/admincerts
mkdir -p $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/msp/cacerts
mkdir -p $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/msp/tlscacerts
mkdir -p $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/msp/users
cp $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/assets/ca-cert.pem $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/msp/cacerts/
cp $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/assets/tls-ca-cert.pem $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/msp/tlscacerts/
cp $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/msp/admincerts/cert.pem
cp $LOCAL_ROOT_PATH/config/config-msp.yaml $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/msp/config.yaml
echo "End Soft============================="

echo
echo "  === 4.构造 web 组织成员证书："
read -p "  >>> 按回车键继续 >>>"

echo "Start Web============================="
echo "Enroll Admin"
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/web.pex-chain.bittic.cn/registers/admin1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/web.pex-chain.bittic.cn/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin1:admin1@web.pex-chain.bittic.cn:7350
mkdir -p $LOCAL_CA_PATH/web.pex-chain.bittic.cn/registers/admin1/msp/admincerts
cp $LOCAL_CA_PATH/web.pex-chain.bittic.cn/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/web.pex-chain.bittic.cn/registers/admin1/msp/admincerts/cert.pem

echo "Enroll Peer1"
# for identity
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/web.pex-chain.bittic.cn/registers/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/web.pex-chain.bittic.cn/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://peer1:peer1@web.pex-chain.bittic.cn:7350
# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/web.pex-chain.bittic.cn/assets/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1web:peer1web@council.pex-chain.bittic.cn:7050 --enrollment.profile tls --csr.hosts peer1.web.pex-chain.bittic.cn
cp $LOCAL_CA_PATH/web.pex-chain.bittic.cn/registers/peer1/tls-msp/keystore/*_sk $LOCAL_CA_PATH/web.pex-chain.bittic.cn/registers/peer1/tls-msp/keystore/key.pem
mkdir -p $LOCAL_CA_PATH/web.pex-chain.bittic.cn/registers/peer1/msp/admincerts
cp $LOCAL_CA_PATH/web.pex-chain.bittic.cn/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/web.pex-chain.bittic.cn/registers/peer1/msp/admincerts/cert.pem

mkdir -p $LOCAL_CA_PATH/web.pex-chain.bittic.cn/msp/admincerts
mkdir -p $LOCAL_CA_PATH/web.pex-chain.bittic.cn/msp/cacerts
mkdir -p $LOCAL_CA_PATH/web.pex-chain.bittic.cn/msp/tlscacerts
mkdir -p $LOCAL_CA_PATH/web.pex-chain.bittic.cn/msp/users
cp $LOCAL_CA_PATH/web.pex-chain.bittic.cn/assets/ca-cert.pem $LOCAL_CA_PATH/web.pex-chain.bittic.cn/msp/cacerts/
cp $LOCAL_CA_PATH/web.pex-chain.bittic.cn/assets/tls-ca-cert.pem $LOCAL_CA_PATH/web.pex-chain.bittic.cn/msp/tlscacerts/
cp $LOCAL_CA_PATH/web.pex-chain.bittic.cn/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/web.pex-chain.bittic.cn/msp/admincerts/cert.pem
cp $LOCAL_ROOT_PATH/config/config-msp.yaml $LOCAL_CA_PATH/web.pex-chain.bittic.cn/msp/config.yaml
echo "End Web============================="

echo
echo "=== 配置系统通道及测试通道"
echo
echo "  === 2.生成创世区块和测试通道："
read -p "  >>> 按回车键继续 >>>"
configtxgen -profile OrgsOrdererGenesis -outputBlock $LOCAL_ROOT_PATH/data/genesis.block -channelID syschannel
configtxgen -profile OrgsChannel -outputCreateChannelTx $LOCAL_ROOT_PATH/data/mychannel.tx -channelID mychannel

echo
echo "  === 4.启动 peer 和 orderer 服务："
read -p "  >>> 按回车键继续 >>>"
docker-compose -f $LOCAL_ROOT_PATH/compose/docker-compose.yaml up -d peer1.soft.pex-chain.bittic.cn peer1.web.pex-chain.bittic.cn orderer1.orderer.pex-chain.bittic.cn

echo
echo "  === 7.通过 soft 创建 mychannel 测试通道的创世区块："
read -p "  >>> 按回车键继续 >>>"
source envpeer1soft
peer channel create -c mychannel -f $LOCAL_ROOT_PATH/data/mychannel.tx -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA --outputBlock $LOCAL_ROOT_PATH/data/mychannel.block

echo
echo "  === 8.将 mychannel 创世区块复制到其成员组织目录："
read -p "  >>> 按回车键继续 >>>"
cp $LOCAL_ROOT_PATH/data/mychannel.block $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/assets/
cp $LOCAL_ROOT_PATH/data/mychannel.block $LOCAL_CA_PATH/web.pex-chain.bittic.cn/assets/

echo
echo "  === 9.分别通过 soft 和 web 成员组织的 cli 加入通道："
read -p "  >>> 按回车键继续 >>>"
source envpeer1soft
peer channel join -b $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/assets/mychannel.block
source envpeer1web
peer channel join -b $LOCAL_CA_PATH/web.pex-chain.bittic.cn/assets/mychannel.block

echo
echo "  === 查看已加入通道："
read -p "  >>> 按回车键继续 >>>"
peer channel getinfo -c mychannel 

echo
echo "=== 安装/测试链码"
echo

echo
echo "  === 为了部署 chaincode，如果在中国，需要设 golang 代理，y for yes, anything else for no"
read -p ">>> " GolangChina
echo
if [ $GolangChina ] && [ $GolangChina='y' ] 
then
  echo "  --- go 1.13 及以上"
  go env -w GO111MODULE=on && go env -w GOPROXY=https://goproxy.cn,direct
  echo "  --- 其他版本"
  export GO111MODULE=on && export GOPROXY=https://goproxy.cn,direct
# else
#   echo "  === 取消 go 代理"
#   go env -u GOPROXY
fi

echo
echo "  === 1. soft 打包并安装链码"
read -p "  >>> 按回车键继续 >>>"
source envpeer1soft
#peer lifecycle chaincode package basic.tar.gz --path asset-transfer-basic/chaincode-go --label basic_1 ## 不需要安装，因为FabricLearn已经提供了打包好的。如果自行打包，会生成不同的 package id，在国外能够部署成功，但在国内莫名其妙的无法下载https://proxy.golang.org/github.com/golang/protobuf/@v/v1.3.2.mod，虽然设置了 go env GOPROXY=https://goproxy.io,direct
peer lifecycle chaincode install basic.tar.gz

echo
echo "    --- 查询已安装链码信息，记住 Package ID"
read -p "    >>> 按回车键继续 >>>"
peer lifecycle chaincode queryinstalled

echo
echo "  === 2. web 安装链码"
read -p "  >>> 按回车键继续 >>>"
source envpeer1web
peer lifecycle chaincode install basic.tar.gz

echo
echo "  === 3. 设置链码ID 环境变量"
read -p "  >>> 按回车键继续 >>>"
#export CHAINCODE_ID=basic_1:210dcb53c80e59266eca932463a06976fa9ad7d08508bd1b179552fba803f7b0 ## 这是自行打包的结果
export CHAINCODE_ID=basic_1:06613e463ef6694805dd896ca79634a2de36fdf019fa7976467e6e632104d718

echo
echo "  === 4. soft and web 批准链码"
read -p "  >>> 按回车键继续 >>>"
source envpeer1soft
peer lifecycle chaincode approveformyorg -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA  --channelID mychannel --name basic --version 1.0 --sequence 1 --waitForEvent --init-required --package-id $CHAINCODE_ID
source envpeer1web
peer lifecycle chaincode approveformyorg -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA  --channelID mychannel --name basic --version 1.0 --sequence 1 --waitForEvent --init-required --package-id $CHAINCODE_ID

echo
echo "    --- 查看本组织的链码批准情况"
read -p "    >>> 按回车键继续 >>>"
peer lifecycle chaincode queryapproved -C mychannel -n basic --sequence 1

echo
echo "    --- 查看指定链码是否已准备好提交"
read -p "    >>> 按回车键继续 >>>"
peer lifecycle chaincode checkcommitreadiness -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA --channelID mychannel --name basic --version 1.0 --sequence 1 --init-required

echo
echo "  === 5. 使用任意合法组织提交链码"
read -p "  >>> 按回车键继续 >>>"
source envpeer1soft
peer lifecycle chaincode commit -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA --channelID mychannel --name basic --init-required --version 1.0 --sequence 1 --peerAddresses peer1.soft.pex-chain.bittic.cn:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer1.web.pex-chain.bittic.cn:7351 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE

echo
echo "    --- 查看链码提交情况"
read -p "    >>> 按回车键继续 >>>"
peer lifecycle chaincode querycommitted --channelID mychannel --name basic -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA --peerAddresses peer1.soft.pex-chain.bittic.cn:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE

echo
echo "  === 6. 初始化链码（非必须）"
read -p "  >>> 按回车键继续 >>>"
peer chaincode invoke --isInit -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA --channelID mychannel --name basic --peerAddresses peer1.soft.pex-chain.bittic.cn:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer1.web.pex-chain.bittic.cn:7351 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"Args":["InitLedger"]}'

echo
echo "  === 7. 调用链码（建议多等几秒，等待链码初始化完毕）"
read -p "  >>> 按回车键继续 >>>"
peer chaincode invoke -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA --channelID mychannel --name basic --peerAddresses peer1.soft.pex-chain.bittic.cn:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer1.web.pex-chain.bittic.cn:7351 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"Args":["GetAllAssets"]}'
