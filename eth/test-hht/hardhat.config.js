require('@nomicfoundation/hardhat-toolbox')

// Go to https://www.alchemyapi.io, sign up, create
// a new App in its dashboard, and replace "KEY" with its key
const ALCHEMY_API_KEY = 'KEY'

// Replace this private key with your Ropsten account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Be aware of NEVER putting real Ether into testing accounts
const ROPSTEN_PRIVATE_KEY = 'YOUR ROPSTEN PRIVATE KEY'

// Replace this private key with your Goerli account private key.
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key.
// Beware: NEVER put real Ether into testing accounts
const GOERLI_PRIVATE_KEY = 'YOUR GOERLI PRIVATE KEY'

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: '0.8.9',
  /* 或者定义多个 solc 版本，比如：
  solidity: {
    compilers: [
      {
        version: "0.5.5",
      },
      {
        version: "0.6.7",
        settings: {},
      },
    ],
  },
  */
  networks: {
    // ropsten: {
    //   url: `https://eth-ropsten.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
    //   accounts: [`0x${ROPSTEN_PRIVATE_KEY}`]
    // },
    // goerli: {
    //   url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
    //   accounts: [GOERLI_PRIVATE_KEY]
    // },
    pexdev: {
      url: 'http://127.0.0.1:6739',
      accounts: [
        '0xd2ed4496be1251a7f55772bba6ef1106ec330e27002898a5e1c69cd4e39de965' // 加不加 0x 貌似都可以
      ]
    },
    pex: {
      url: 'http://121.5.167.48:6739',
      accounts: [
        '0xd2ed4496be1251a7f55772bba6ef1106ec330e27002898a5e1c69cd4e39de965' // 加不加 0x 貌似都可以
      ]
    }
  }
  // defaultNetwork: 'pex'
  // etherscan: {
  //   apiKey: 'ETHERSCAN_API',
  // }
}
