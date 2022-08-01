const { utils } = require('ethers')

async function main () {
  const baseTokenURI = 'ipfs://QmZbWNKJPAjxXuNFSEaksCJVd1M6DaKQViJBYPK2BdpDEP/'

  // Get owner/deployer's wallet address
  const [owner] = await hre.ethers.getSigners()

  // Get contract that we want to deploy
  const contractFactory = await hre.ethers.getContractFactory('PEX')

  // Deploy contract with the correct constructor arguments
  const contract = await contractFactory.deploy(baseTokenURI)
  // const contract = await contractFactory.attach(contractAddress)

  // Wait for this transaction to be mined
  await contract.deployed()

  // Get contract address
  console.log('Contract deployed to:', contract.address)

  // Mint NFT
  txn = await contract.mint(owner.address, '0x1', {
    // 或者 tokenId: 0x35435234adeabc
    // 如果 PEX.sol 里不要求 最低价格，那么这里不提供 { value } 参数也可以。
    value: utils.parseEther('0.01')
  })
  await txn.wait()

  txn2 = await contract.mint(
    '0x921b248a470f7d0bba40077c7aee3ab3440caa77',
    '0x2',
    {
      value: utils.parseEther('0.01')
    }
  )
  await txn2.wait()

  // Get all token IDs of the owner
  let tokens = await contract.tokensOfOwner(owner.address)
  console.log('Owner has tokens: ', tokens)

  let uri = await contract.tokenURI('0x1')
  console.log('token URI = ', uri)
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
