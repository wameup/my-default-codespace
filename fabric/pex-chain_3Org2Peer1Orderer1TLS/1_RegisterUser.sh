#!/bin/bash -eu
echo "Working on council"
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/council.pex-chain.bittic.cn/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/council.pex-chain.bittic.cn/ca/admin
fabric-ca-client enroll -d -u https://ca-admin:ca-adminpw@council.pex-chain.bittic.cn:7050
fabric-ca-client register -d --id.name orderer1 --id.secret orderer1 --id.type orderer -u https://council.pex-chain.bittic.cn:7050
fabric-ca-client register -d --id.name peer1soft --id.secret peer1soft --id.type peer -u https://council.pex-chain.bittic.cn:7050
fabric-ca-client register -d --id.name peer1web --id.secret peer1web --id.type peer -u https://council.pex-chain.bittic.cn:7050
echo "Working on orderer"
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/orderer.pex-chain.bittic.cn/ca/admin
fabric-ca-client enroll -d -u https://ca-admin:ca-adminpw@orderer.pex-chain.bittic.cn:7150
fabric-ca-client register -d --id.name orderer1 --id.secret orderer1 --id.type orderer -u https://orderer.pex-chain.bittic.cn:7150
fabric-ca-client register -d --id.name admin1 --id.secret admin1 --id.type admin -u https://orderer.pex-chain.bittic.cn:7150
echo "Working on soft"
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/soft.pex-chain.bittic.cn/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/soft.pex-chain.bittic.cn/ca/admin
fabric-ca-client enroll -d -u https://ca-admin:ca-adminpw@soft.pex-chain.bittic.cn:7250
fabric-ca-client register -d --id.name peer1 --id.secret peer1 --id.type peer -u https://soft.pex-chain.bittic.cn:7250
fabric-ca-client register -d --id.name admin1 --id.secret admin1 --id.type admin -u https://soft.pex-chain.bittic.cn:7250
echo "Working on web"
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/web.pex-chain.bittic.cn/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/web.pex-chain.bittic.cn/ca/admin
fabric-ca-client enroll -d -u https://ca-admin:ca-adminpw@web.pex-chain.bittic.cn:7350
fabric-ca-client register -d --id.name peer1 --id.secret peer1 --id.type peer -u https://web.pex-chain.bittic.cn:7350
fabric-ca-client register -d --id.name admin1 --id.secret admin1 --id.type admin -u https://web.pex-chain.bittic.cn:7350
echo "All CA and registration done"