npx hardhat run scripts/deploy-PEX.js --network pex
Contract deployed to: 0x604a794e353Ae687CBB7F054bd684da894457e82
Owner has tokens:  [ BigNumber { value: "14992194115857084" } ]

# name() `06fdde03`
curl http://localhost:6739 --data '{"method": "eth_call", "params":[{"to":"0x604a794e353Ae687CBB7F054bd684da894457e82", "data":"0x06fdde03"},"latest"],"id":1}' -X POST -H "Content-Type: application/json"
{"jsonrpc":"2.0","id":1,"result":"0x
0000000000000000000000000000000000000000000000000000000000000020
0000000000000000000000000000000000000000000000000000000000000013
5065726d616e656e74204578697374656e636500000000000000000000000000"}
返回了96字节
# 返回字符串 "Permanent Existence" 编码：长度 0x13 + ascii
135065726d616e656e74204578697374656e6365 
==
  P e r m a n e n t   E x i s t e n c e

# balanceOf(address) `70a08231`
# address 做参数，要在前面填0补足32字节
# eth_call 需要第二个数组元素指定 block number，默认为 latest
curl http://localhost:6739 --data '{"method": "eth_call", "params":[{"to":"0x604a794e353Ae687CBB7F054bd684da894457e82", "data":"0x70a082310000000000000000000000003831e121b349aebaea8ed0c44d4c7cb7b15ad8ad"},"latest"],"id":1}' -X POST -H "Content-Type: application/json"
{"jsonrpc":"2.0","id":1,"result":"0x0000000000000000000000000000000000000000000000000000000000000001"}

# tokenURI(uint256) `c87b56dd`
curl http://localhost:6739 --data '{"method": "eth_call", "params":[{"to":"0x604a794e353Ae687CBB7F054bd684da894457e82", "data":"0xc87b56dd0000000000000000000000000000000000000000000000000035435234adeabc"},"latest"],"id":1}' -X POST -H "Content-Type: application/json"
{"jsonrpc":"2.0","id":1,"result":"0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000047
697066733a2f2f516d5a62574e4b4a50416a7858754e465345616b73434a5664314d3644614b5156694a4259504b324264704445502f
i p f s : / / Q m Z b W N K J P A j x X u N F S E a k s C J V d 1 M 6 D a K Q V i J B Y P K 2 B d p D E P /
3134393932313934313135383537303834
1 4 9 9 2 1 9 4 1 1 5 8 5 7 0 8 4 (=== tokenID 0x35435234adeabc 的十进制 )
00000000000000000000000000000000000000000000000000"}

修改合约使用 Strings.toHexString(tokenId) 后
{"jsonrpc":"2.0","id":1,"result":"0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000046
697066733a2f2f516d5a62574e4b4a50416a7858754e465345616b73434a5664314d3644614b5156694a4259504b324264704445502f
30783335343335323334616465616263
0 x 3 5 4 3 5 2 3 4 a d e a b c
0000000000000000000000000000000000000000000000000000"}


# mint() web3.sha3('mint(address,uint256)').substr(2,8) ==> "40c10f19"
# eth_transaction 不需要第二个数组元素，加了就死了
curl http://localhost:6739 --data '{"method": "eth_sendTransaction", "params":[{"from":"0x3831e121b349aebaea8ed0c44d4c7cb7b15ad8ad","to":"0x604a794e353Ae687CBB7F054bd684da894457e82", "data":"0x40c10f19000000000000000000000000921b248a470f7d0bba40077c7aee3ab3440caa7700000000000000000000000000000000000000000000000000000000000033dd","gas":"0xc350"}],"id":1}' -X POST -H "Content-Type: application/json"
返回交易哈希
{"jsonrpc":"2.0","id":1,"result":"0xdc96657cf66e43d7c1ec1cd642b9e2bdd1c93fccc4c50510529dbc6fe2a433cf"}

curl http://localhost:6739 -d '{"method":"eth_getTransactionByHash","params":["0xdc96657cf66e43d7c1ec1cd642b9e2bdd1c93fccc4c50510529dbc6fe2a433cf"],"jsonrpc":"2.0","id":1}' -X POST -H "Content-Type: application/json"

但是检查区块链上数据，发现mint不成功

# totalSupply() `18160ddd`
curl http://localhost:6739 --data '{"method": "eth_call", "params":[{"to":"0x604a794e353Ae687CBB7F054bd684da894457e82", "data":"0x18160ddd"},"latest"],"id":1}' -X POST -H "Content-Type: application/json"
{"jsonrpc":"2.0","id":1,"result":"0x0000000000000000000000000000000000000000000000000000000000000001"}

