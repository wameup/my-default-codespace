DATADIR=pex-poa
pm2 start -x 'geth' --name $DATADIR -- --datadir ./$DATADIR/ --http --http.addr 0.0.0.0 --http.port 6739 --http.api eth,net,web3,personal,admin,miner,debug,txpool,shh --http.corsdomain "*" --nodiscover --networkid 6739 --port 60739 --allow-insecure-unlock  -unlock '0x3831e121b349aebaea8ed0c44d4c7cb7b15ad8ad' --password ./password-3831e1.txt --mine
