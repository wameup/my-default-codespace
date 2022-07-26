mkdir [hht] && cd [hht]
npm init -y
npm i --save-dev hardhat
npx hardhat # setup a project
npx hardhat # view command options
npx hardhat compile # compile contracts
npx hardhat node # start a local node。 这个 node 无法通过 geth attach 连接，报错说 "Method rpc_modules not found"。
# pm2 start -x 'npx' --name hardhat-node -- hardhat node && pm2 log 
npx hardhat run scripts/deploy.js --network [localhost|goerli|...] # 如果部署到 hardhat network, 省略 --network localhost 也显示成功，但在 node 记录里似乎没有上链。localhost以外的网络需要在 hardhat.config.js 中定义。
npx hardhat console # start a hardhat console，但这里似乎只是 node console，不是 ethereum JavaScript console，不存在 eth, web3 等对象。