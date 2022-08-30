#!/bin/bash -eu
echo "Preparation============================="
mkdir -p $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets
cp $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets/ca-cert.pem
cp $LOCAL_CA_PATH/council.pex-chain.bittic.cn/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets/tls-ca-cert.pem

mkdir -p $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/assets
cp $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/assets/ca-cert.pem
cp $LOCAL_CA_PATH/council.pex-chain.bittic.cn/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/assets/tls-ca-cert.pem

mkdir -p $LOCAL_CA_PATH/web.pex-chain.bittic.cn/assets 
cp $LOCAL_CA_PATH/web.pex-chain.bittic.cn/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/web.pex-chain.bittic.cn/assets/ca-cert.pem
cp $LOCAL_CA_PATH/council.pex-chain.bittic.cn/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/web.pex-chain.bittic.cn/assets/tls-ca-cert.pem
echo "Preparation============================="

echo "Start orderer============================="
echo "Enroll Admin"
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/admin1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin1:admin1@orderer.pex-chain.bittic.cn:7150
# 加入通道时会用到admin/msp，其下必须要有admincers
mkdir -p $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/admin1/msp/admincerts
cp $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/admin1/msp/admincerts/cert.pem

echo "Enroll Orderer"
# for identity
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/orderer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://orderer1:orderer1@orderer.pex-chain.bittic.cn:7150
mkdir -p $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/orderer1/msp/admincerts
cp $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/orderer1/msp/admincerts/cert.pem
# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1:orderer1@council.pex-chain.bittic.cn:7050 --enrollment.profile tls --csr.hosts orderer1.orderer.pex-chain.bittic.cn
cp $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/orderer1/tls-msp/keystore/*_sk $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/orderer1/tls-msp/keystore/key.pem

mkdir -p $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/admincerts
mkdir -p $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/cacerts
mkdir -p $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/tlscacerts
mkdir -p $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/users
cp $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets/ca-cert.pem $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/cacerts/
cp $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/assets/tls-ca-cert.pem $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/tlscacerts/
cp $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/admincerts/cert.pem
cp $LOCAL_ROOT_PATH/config/config-msp.yaml $LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/msp/config.yaml
echo "End orderer============================="


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