#!/bin/bash -u
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi $(docker images dev-* -q)
rm -rf orgs data
docker-compose -f $LOCAL_ROOT_PATH/compose/docker-compose.yaml up -d council.pex-chain.bittic.cn orderer.pex-chain.bittic.cn soft.pex-chain.bittic.cn web.pex-chain.bittic.cn