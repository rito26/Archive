--- 
title: 이더리움 Geth 설치 
author: rito26 
date: 2023-01-05 22:22:22 +09:00 
categories: [Blockchain, Ethereum] 
tags: [] 
math: true 
mermaid: true 
--- 

# Geth 설치
--- 
- <https://bitkunst.tistory.com/entry/Ethereum이더리움-개발-환경-세팅>

<br>


## [1] WSL2 & 우분투 설치
- ㅇ

<br>


## [2] Go 설치
```wsl2
sudo apt update
sudo apt install golang
```

- Geth 설치용 추가 명령어

```wsl2
sudo apt install -y libgmp3-dev tree make build-essential
```

- `go version`으로 버전을 확인하여, `1.4` 미만일 경우에만 아래 명령어 실행

```wsl2
git clone https://github.com/udhos/update-golang
sudo update-golang/update-golang.sh
```

<br>


## [3] Geth 설치
```wsl2
git clone https://github.com/ethereum/go-ethereum
```

- geth 생성

```wsl2
cd go-ethereum
make geth
```

- geth 실행

```wsl2
cd ./build/bin
./geth         # 반드시 `/build/bin` 디렉토리 내에서 실행
```

- 전역 환경변수로 설정(`geth` 명령어로 한 번에 실행할 수 있도록)

```wsl2
# 반드시 `/build/bin` 디렉토리 내에서 실행
export PATH=$PATH:$PWD
```


