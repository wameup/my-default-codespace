mkdir [hht] && cd [hht]
npm init -y
npm i --save-dev hardhat
npx hardhat # setup a project
npx hardhat # view command options
npx hardhat compile # compile contracts
npx hardhat node # start a local node
# pm2 start -x 'npx' --name hardhat-node -- hardhat node && pm2 log 
npx hardhat run scripts/deploy.js --network [localhost|goerli|...]
npx hardhat console # start a hardhat JavaScript console