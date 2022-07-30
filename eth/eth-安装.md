# 安装 geth

- download binaries <https://geth.ethereum.org/downloads/>
  - Windows <https://gethstore.blob.core.windows.net/builds/geth-windows-amd64-1.10.20-8f2416a8.exe>
  - Linux amd64 <https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.20-8f2416a8.tar.gz>
  - Linux arm64 <https://gethstore.blob.core.windows.net/builds/geth-linux-arm64-1.10.20-8f2416a8.tar.gz>
  - MacOS <https://gethstore.blob.core.windows.net/builds/geth-darwin-amd64-1.10.20-8f2416a8.tar.gz>
  - Sources <https://github.com/ethereum/go-ethereum/archive/v1.10.20.tar.gz>
- clone source repository
  - `git clone https://github.com/ethereum/go-ethereum -b v1.10.20`
    - `cd go-ethereum && make [geth|all] && ./build/bin/geth version`
  - `wget https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.10.20.tar.gz`
- pull docker
  - `docker pull ethereum/client-go:v1.10.20`
