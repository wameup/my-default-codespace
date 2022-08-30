#!/bin/bash -eu
configtxgen -profile OrgsOrdererGenesis -outputBlock $LOCAL_ROOT_PATH/data/genesis.block -channelID syschannel
configtxgen -profile OrgsChannel -outputCreateChannelTx $LOCAL_ROOT_PATH/data/mychannel.tx -channelID mychannel
docker-compose -f $LOCAL_ROOT_PATH/compose/docker-compose.yaml up -d peer1.soft.pex-chain.bittic.cn peer1.web.pex-chain.bittic.cn orderer1.orderer.pex-chain.bittic.cn
sleep 5
source envpeer1soft
peer channel create -c mychannel -f $LOCAL_ROOT_PATH/data/mychannel.tx -o orderer1.orderer.pex-chain.bittic.cn:7151 --tls --cafile $ORDERER_CA --outputBlock $LOCAL_ROOT_PATH/data/mychannel.block
# InitCmd -> ERRO 001 Fatal error when initializing core config : Could not find config file. Please make sure that FABRIC_CFG_PATH is set to a path which contains core.yaml
# dos2unix
# ERRO 002 Client TLS handshake failed after 1.116738ms with error: x509: certificate is not valid for any names, but wanted to match localhost remoteaddress=127.0.0.1:7151
cp $LOCAL_ROOT_PATH/data/mychannel.block $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/assets/
cp $LOCAL_ROOT_PATH/data/mychannel.block $LOCAL_CA_PATH/web.pex-chain.bittic.cn/assets/

# 加入通道
source envpeer1soft
peer channel join -b $LOCAL_CA_PATH/soft.pex-chain.bittic.cn/assets/mychannel.block
# Client TLS handshake failed after 1.554615ms with error: x509: certificate is valid for peer1soft, peer1.soft.pex-chain.bittic.cn, not soft.pex-chain.bittic.cn remoteaddress=127.0.0.1:7251
# CORE_PEER_ADDRESS必须与docker中一致
source envpeer1web
peer channel join -b $LOCAL_CA_PATH/web.pex-chain.bittic.cn/assets/mychannel.block