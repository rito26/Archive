--- 
title: 이더리움 트랜잭션 
author: rito26 
date: 2023-01-10 22:11:56 +09:00 
categories: [Blockchain, Ethereum] 
tags: [] 
math: true 
mermaid: true 
--- 

# References
---

## 개념
- <https://steemit.com/busy/@anpigon/ethereum-3>
- <https://lbm93.tistory.com/7>

## 구현 정보
- <https://betterprogramming.pub/how-to-send-ethereum-transactions-using-web3-d05e0c95f820>
- <https://velog.io/@hb707/이더리움-web3>
- <https://web3js.readthedocs.io/en/v1.2.11/web3-eth.html#id84>

<br>


# 이더리움 트랜잭션 기초
---

## 개념
- 트랜잭션(Transactions)은 외부 소유 계정(EOA)에서 생성되어 이더리움 블록체인에 기록된 서명된 메시지다.
- 트랜잭션을 통해서만 이더(ether)를 전송하거나 컨트랙트(contract)를 실행할 수 있다.


## 구조

```js
{
    nonce    : number,          // 10진수 정수
    from?    : string,          //                    // 기본값 : web3.eth.accounts.wallet
    to       : string,
    value?   : string,          // 16진수 실수, Wei
    data?    : string,
    gasPrice?: number | string, // 10진수 실수, Wei   // 기본값 :  web3.eth.gasPrice
    gas      : number | string, // 10진수 정수, 개수
    chain?   : string,          //                    // 기본값 : 'mainnet'
}
```

<!--
## 유의사항
- 이더리움은 기본적으로 무분별한 트랜잭션 전송을 막기 위해 `sendTransaction`을 잠근다고 한다.
- 따라서 `web3.personal.unlockAccount()`와 같은 메소드로 먼저 잠금을 해제해야 한다.
- Raw 트랜잭션은 실제로 전송되는 트랜잭션 오브젝트를 의미하며, 각 필드가 16진수 문자열로 이루어져 있다.(변환됨)
-->

<br>


# 이더리움 트랜잭션 구성요소
---
- 기준 Web3js 버전 : 1.8.1

<br>

## **nonce**
- 타입 : number, 10진수
- EOA(외부 소유 계정)에 발급되는 트랜잭션 일련번호
- 트랜잭션의 중복 전송을 방지할 때 사용한다.
- 전송 시, `web3.eth.getTransactionCount()`를 통해 `nonce` 값을 먼저 획득해야 한다.


## **from**
- 타입 : string
- 발신자의 주소(public key)
- 기본값은 `web3.eth.defaultAccount`


## **to**
- 타입 : string
- 수신자의 주소(public key)
- 이더리움에서는 수신자의 주소가 실제로 존재하는지 검증하지 않으므로, 유의해야 한다.
- 만약 잘못된 주소에 전송했다면 발신자에게 책임이 있다.


## **value**
- 타입 : string, 16진수, wei
- 전송할 금액
- wei 단위이므로, ether를 입력하려면 `web3-utils.toWei()` 메소드를 통해 wei로 변환해야 한다.
- 또한 16진수로 변환해야 하므로 `.toHex()`를 해주어야 한다.
- (10진수도 되는지 확인 필요)


## **data**
- 타입 : string, 16진수
- 트랜잭션 전송 시 함께 보낼 내용
- 컨트랙트 트랜잭션 전송 시 사용한다.


## **gasPrice**
- <https://upbitcare.com/academy/education/coin/22>

- 타입 : number, 10진수
- Gwei(기가 웨이, 10^9 wei) 단위를 사용한다.

- `가스` 하나 당 가격
- 트랜잭션 채굴 시 채굴자가 받을 수수료
- 트랜잭션 생성자가 직접 지정하며, 높을수록 빠르게 채굴 및 검증된다.
- 최소 0부터 설정할 수 있지만, 낮으면 그만큼 늦게 채굴된다.
- 이더 송금 시에는 지정하지 않아도 21,000(`web3.eth.gasPrice`)으로 설정된다.


- `web3.eth.getGasPrice()`를 통해 이더리움 네트워크 평균 가스 가격을 조회할 수 있다.
- 평균보다 높아야 유리하다.

- 여러 사이트를 통해 현황을 파악할 수 있다.
  - <https://etherscan.io/gastracker#historicaldata>
  - <https://ethgasstation.info/>


- 실제로 트랜잭션 작성자에게 부과되는 수수료는 `gas(가격) * gasLimit(개수)`
- 예를 들어 `gas = 10`, `gasLimit = 21,000`일 경우 부과되는 가격은 `210,000 Gwei` = `0.00021 Ether`이다.
- 가스비는 채굴될 때 한 번만 부과된다.


## **gas**
- 타입 : number, 10진수
- 트랜잭션을 처리하는데 사용할 최대 가스 `개수`
- EOA로 이더(`ether`)를 전송하는 트랜잭션에 필요한 가스 개수는 21,000개가 표준이다.

- 컨트랙트 트랜잭션 전송 시, 실제 필요 한도보다 낮은 개수를 지정하면 그만큼 이더가 소모되고 전송은 실패할 수 있다.
- 그렇다고 가스 한도를 엄청 높게 지정한다고 그만큼 다 소모되는 것이 아니라 계산된 만큼만 소모되므로 넉넉히 가스 한도를 설정하는 것이 좋다.


## **chain**
- 타입 : string
- 전송할 대상 네트워크
- 기본 값은 `mainnet`
- 참고: 커스텀 체인을 사용할 경우 `customChain`, `chainId` 등을 명시한다.

