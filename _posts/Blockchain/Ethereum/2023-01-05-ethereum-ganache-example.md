--- 
title: 이더리움 가나슈, 리액트 예제 
author: rito26 
date: 2023-01-05 22:00:00 +09:00 
categories: [Blockchain, Ethereum] 
tags: [] 
math: false
mermaid: false
--- 

# 이더리움 메타마스크 프론트 연결 예제
---
- <https://bitkunst.tistory.com/entry/Ethereum이더리움-개발-환경-세팅>
- <https://bitkunst.tistory.com/entry/Ethereum이더리움-메타마스크-연결하기>


## 사용 환경
- 지갑 : 메타마스크(크롬 확장)
- 로컬 서버 : 가나슈
- 프론트엔드 : 리액트

<br>


# 1. Ganache(가나슈) 설치
---

## 가나슈란?
- 이더리움 네트워크, 스마트 컨트랙트 등의 개발을 위한 독립 로컬 네트워크 테스트 환경


## 가나슈 CLI 설치

```cmd
npm install -g ganache-cli
```


## 가나슈 실행
```cmd
npx ganache-cli
```


## 가나슈 실행 에러 발생 시
- 에러 내용 : `error:0308010C:digital envelope routines::unsupported`

- `nvm -v`로 확인하여 nvm 미설치 시
  - <https://github.com/coreybutler/nvm-windows/releases>
  - `nvm-setup.exe` 설치 및 실행

- nvm 옵션
  - 설치 가능 버전 확인   : `nvm list available`
  - 현재 설치된 버전 확인 : `nvm list`
  - 특정 버전 설치        : `nvm install {버전}`
  - 사용 중인 버전 확인   : `node -v`
  - 사용 버전 변경        : `nvm use {버전}`


## Note
- `16.13.0` 버전으로 가나슈 성공적으로 실행됨 확인
- 가나슈를 실행할 경우, CLI에서 `Available Accounts`, `Private Keys`를 통해 사용 가능한 지갑들을 확인할 수 있다.

<br>


# 2. 리액트 프론트엔드
---

## 리액트 앱 생성

```cmd
echo.Y|npx create-react-app front
```


## npm install

```cmd
cd front
npm install web3
```


## src/App.js 수정

<details>
<summary markdown="span">
...
</summary>


```js
import './App.css';
import useWeb3 from './hooks/useWeb3';
import { useEffect, useState } from 'react';

function App() {
    const [account, web3] = useWeb3();
    const [isLogin, setIsLogin] = useState(false);
    const [balance, setBalance] = useState(0);

    const handleSubmit = async (e) => {
        e.preventDefault();

        await web3.eth.sendTransaction({
            from: account,
            to: e.target.received.value,
            value: web3.utils.toWei(e.target.amount.value, 'ether'),
        });
    };

    useEffect(() => {
        const init = async () => {
            // web3? 문법
            // web3가 null 값이라면 undefined를 반환해준다.
            const balance = await web3?.eth.getBalance(account);
            setBalance(balance / 10 ** 18);
        };

        if (account) setIsLogin(true);
        init();
    }, [account]);

    if (!isLogin)
        return (
            <div>
                <h1>메타마스크 로그인 이후 사용해주세요.</h1>
            </div>
        );

    return (
        <div className="App">
            <div>
                <h3>{account}님 환영합니다.</h3>
                <div>Balance : {balance} ETH</div>
            </div>
            <div>
                <form onSubmit={handleSubmit}>
                    <input type="text" id="received" placeholder="받을 계정" />
                    <input type="number" id="amount" placeholder="보낼 금액" />
                    <input type="submit" value="전송" />
                </form>
            </div>
        </div>
    );
}

export default App;
```

</details>



## src/hooks/useWeb3.js 파일 생성

<details>
<summary markdown="span">
...
</summary>

```js
import { useEffect, useState } from 'react';
import Web3 from 'web3/dist/web3.min.js';
// web3 라이브러리 안에는 브라우저가 아닌 nodejs에서만 사용 가능한 라이브러리들이 존재
// webpack 설정을 잡아주거나 최소기능만을 가져오는 방법으로 해결

const useWeb3 = () => {
    const [account, setAccount] = useState(null);
    const [web3, setWeb3] = useState(null);

    const getChainId = async () => {
        const chainId = await window.ethereum.request({
            // 메타마스크가 사용하고 있는 네트워크의 체인 아이디를 return
            method: 'eth_chainId',
        });

        return chainId;
    };

    const getRequestAccounts = async () => {
        const accounts = await window.ethereum.request({
            // 연결이 안되어 있다면 메타마스크 내의 계정들과 연결 요청
            // 연결이 되었다면 메타마스크가 갖고 있는 계정들 중 사용하고 있는 계정 가져오기
            method: 'eth_requestAccounts',
        });

        console.log(accounts);

        return accounts;
    };

    const addNetwork = async (_chainId) => {
        // 메타마스크에서 네트워크 추가를 할 때 들어가는 속성들
        const network = {
            chainId: _chainId,
            chainName: 'Ganache',
            rpcUrls: ['http://127.0.0.1:8545'],
            nativeCurrency: {
                name: 'Ethereum',
                symbol: 'ETH', // 통화 단위
                decimals: 18, // 소수점 자리수
            },
        };

        await window.ethereum.request({
            method: 'wallet_addEthereumChain',
            params: [network],
        });
    };

    // window 객체에 대한 접근은 모든 요소들이 랜더 완료되었을 때 하는 것이 효과적이다.
    useEffect(() => {
        // console.log(window.ethereum);
        const init = async () => {
            try {
                const targetChainId = '0x4d2';
                const chainId = await getChainId(); // 1234 , hex: 0x4d2
                console.log('체인 아이디 : ', chainId);
                if (targetChainId !== chainId) {
                    // 네트워크 추가하는 코드
                    addNetwork(targetChainId);
                }

                const [accounts] = await getRequestAccounts();

                // web3 라이브러리를 메타마스크에 연결 (맵핑)
                const web3 = new Web3(window.ethereum);
                setAccount(accounts);
                setWeb3(web3);
            } catch (e) {
                console.error(e.message);
            }
        };

        if (window.ethereum) {
            // 메타마스크 설치된 클라이언트
            // window.ethereum.request() : 메타마스크에 요청 보내는 메소드
            // RPC 사용
            init();
        }
    }, []);

    return [account, web3];
};

export default useWeb3;
```

</details>

<br>


## 프론트 실행
```js
npm start
```


## 메타마스크 네트워크 선택
- `Localhost:8545`

