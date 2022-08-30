#!/bin/bash -eu
# 部署链码
source envpeer1soft
# peer lifecycle chaincode package basic.tar.gz --path asset-transfer-basic/chaincode-go --label basic_1
peer lifecycle chaincode install basic.tar.gz
peer lifecycle chaincode queryinstalled
source envpeer1web
peer lifecycle chaincode install basic.tar.gz
peer lifecycle chaincode queryinstalled

export CHAINCODE_ID=basic_1:06613e463ef6694805dd896ca79634a2de36fdf019fa7976467e6e632104d718

source envpeer1soft
peer lifecycle chaincode approveformyorg -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA  --channelID mychannel --name basic --version 1.0 --sequence 1 --waitForEvent --init-required --package-id $CHAINCODE_ID
peer lifecycle chaincode queryapproved -C mychannel -n basic --sequence 1
source envpeer1web
peer lifecycle chaincode approveformyorg -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA  --channelID mychannel --name basic --version 1.0 --sequence 1 --waitForEvent --init-required --package-id $CHAINCODE_ID
peer lifecycle chaincode queryapproved -C mychannel -n basic --sequence 1

peer lifecycle chaincode checkcommitreadiness -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA --channelID mychannel --name basic --version 1.0 --sequence 1 --init-required

source envpeer1soft
peer lifecycle chaincode commit -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA --channelID mychannel --name basic --init-required --version 1.0 --sequence 1 --peerAddresses peer1.soft.pex-chain.bittic.cn:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer1.web.pex-chain.bittic.cn:7351 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
peer lifecycle chaincode querycommitted --channelID mychannel --name basic -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA --peerAddresses peer1.soft.pex-chain.bittic.cn:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
# error starting container: error starting container: API error (404): network hyperledger_fabric-ca not found"
peer chaincode invoke --isInit -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA --channelID mychannel --name basic --peerAddresses peer1.soft.pex-chain.bittic.cn:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer1.web.pex-chain.bittic.cn:7351 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"Args":["InitLedger"]}'
sleep 5
peer chaincode invoke -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA --channelID mychannel --name basic --peerAddresses peer1.soft.pex-chain.bittic.cn:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer1.web.pex-chain.bittic.cn:7351 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"Args":["GetAllAssets"]}'
# Error: endorsement failure during invoke. response: status:500 message:"make sure the chaincode fabcar has been successfully defined on channel mychannel and try again: chaincode definition for 'basic' exists, but chaincode is not installed"
# approveformyorg 的链码包与 install 的链码包ID不一致