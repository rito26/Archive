--- 
title: 이더리움 Web3js API 정리 
author: rito26 
date: 2023-01-11 22:20:21 +09:00 
categories: [Blockchain, Ethereum] 
tags: [] 
math: false
mermaid: false
--- 

# References
---
- <https://ihpark92.tistory.com/44>
- <https://web3js.readthedocs.io/en/v1.8.1/index.html>
- <https://www.jongho.dev/blockchain/ethereum-transaction/>
- <https://steemit.com/kr/@brownbears/ethereum-account-transaction-message>

<br>


<!--------------------------------------------------------------------------------------------------->
# Web3 객체 생성
---
- <https://web3js.readthedocs.io/en/v1.8.1/web3.html#web3-instance>

<details>
<summary markdown="span">
...
</summary>


```ts
//const web3 = new Web3(provider);
const web3 = new Web3(new Web3.providers.HttpProvider('{INFURA_API}')); // Infura
const web3 = new Web3(window.ethereum);                                 // 메타마스크 확장
```

<br>

</details>


<!--------------------------------------------------------------------------------------------------->
# Web3.Account 객체 생성
---
- <https://web3js.readthedocs.io/en/v1.8.1/web3-eth-accounts.html>
- <https://web3js.readthedocs.io/en/v1.8.1/web3-eth-accounts.html#privatekeytoaccount>

<details>
<summary markdown="span">
...
</summary>

```ts
const account = web3.eth.accounts.privateKeyToAccount('{PRIVATE_KEY}');
```
- 비밀키를 통해서 계정 객체를 생성한다.

<br>

</details>


<!--------------------------------------------------------------------------------------------------->
# 잔액 조회
---
- <https://web3js.readthedocs.io/en/v1.8.1/web3-eth.html#getbalance>

<details>
<summary markdown="span">
...
</summary>


## 메소드
```ts
await web3.eth.getBalance(publicKey: string)
```


## 예제
```ts
//import * as wu from 'web3-utils';

// 1. 결과 : 10진수 wei
const resultWei = await web3.eth.getBalance('{PUBLIC_KEY}');

// 2. 변환 : 10진수 ether
const resultEther = wu.fromWei(resultWei, 'ether');
```


## 설명
- 해당 네트워크 내에서 해당 지갑의 잔고를 조회한다.  
- Ether 단위로 변환할 필요가 있다.


## 리턴
- 타입 : string
- 단위 : 10진수 wei

<br>

</details>


<!--------------------------------------------------------------------------------------------------->
# 최근 평균 가스 가격 조회
---
- <https://web3js.readthedocs.io/en/v1.8.1/web3-eth.html#getgasprice>

<details>
<summary markdown="span">
...
</summary>

## 메소드
```ts
await web3.eth.getGasPrice()
```


## 예제
```ts
//import * as wu from 'web3-utils';

const gasPrice = await web3.eth.getGasPrice(); // 반환 : wei 단위
const ggp      = wu.fromWei(gasPrice, 'Gwei'); // wei -> Gwei 변환
```


## 설명
- 최근 평균 가스 가격을 조회한다.
- 메인넷보다 테스트넷의 평균 가스비가 훨씬 저렴하다.
- wei 단위로 리턴하므로, 종종 Gwei 단위로 변환할 필요가 있다.


## 리턴
- 타입 : string
- 단위 : wei

<br>

</details>


<!--------------------------------------------------------------------------------------------------->
# 트랜잭션 개수 조회(Nonce 획득)
---
- <https://web3js.readthedocs.io/en/v1.8.1/web3-eth.html#gettransactioncount>

<details>
<summary markdown="span">
...
</summary>

## 메소드
```ts
await web3.eth.getTransactionCount(publicKey: string, blockNumber: BlockNumber);
```


## 예제
```ts
await web3.eth.getTransactionCount('PUBLIC_KEY', 'latest');
```

## 설명
- 해당 지갑 주소의 네트워크 내 트랜잭션 개수를 조회한다.
- 추후 트랜잭션 전송을 위한 Nonce 값으로 활용된다.


## 리턴
- 타입 : number
- 10진수 개수

<br>

</details>


<!--------------------------------------------------------------------------------------------------->
# 트랜잭션 서명
---
- <https://web3js.readthedocs.io/en/v1.8.1/web3-eth-accounts.html#signtransaction>

- <https://web3js.readthedocs.io/en/v1.8.1/web3-eth.html#signtransaction>
- <https://www.jongho.dev/blockchain/ethereum-transaction/>

<details>
<summary markdown="span">
...
</summary>


## 메소드
```ts
await web3.eth.accounts.signTransaction(transaction: TransactionConfig, privateKey: string);
```


## 예제
```ts
//import * as wu from 'web3-utils';

const pubKeyFrom  = '...'; // 발신자 공개키
const prvKeyFrom  = '...'; // 발신자 비밀키
const pubKeyTo    = '...'; // 수신자 공개키
const etherToSend = 1;     // 전송할 이더 개수

// 트랜잭션 정보 생성
const transaction: TransactionConfig = {

    /* 필수 프로퍼티 */
    from : pubKeyFrom,
    to   : pubKeyTo,
    value: wu.toHex(wu.toWei(etherToSend.toString(), 'ether')),
    gas  : 21000,
    
    /* 선택 프로퍼티 */
    //nonce: await web3.eth.getTransactionCount(pubKeyFrom, 'latest'),
    //gasPrice: wu.toWei('0.09', 'Gwei') // await web3.eth.getGasPrice()
};

// 서명
const signedTx = await eth.accounts.signTransaction(transaction, prvKeyFrom);
```


## 설명
- 개인키를 통해 트랜잭션을 서명한다.


## 리턴
- 타입 : SignedTransaction
- 서명된 트랜잭션 정보를 반환한다.


## TransactionConfig 필드
```
- *필드*      *타입*            *단위*  *설명*
- `to`        : string          :      : 전송할 대상 공개키
- `value`     : string | number : wei  : 전송할 가격(단위: wei)
- `nonce?`    : number          : 정수 : 트랜잭션 번호(중복 방지), 발신자의 트랜잭션 카운터(Transaction counter). 비워놓을 경우 `getTransactionCount()`를 통해 얻음
- `gas`       : string | number : 개수 : 수수료로 소모할 가스 개수(10진수, 단순 이더 전송 시 21000 필요)
- `gasPrice?` : string | number : wei  : 수료로 소모할 가스 개당 가격(비워놓을 경우 `getGasPrice()`를 통해 얻은 최근 평균 가격 사용)
```

## 리턴: SignedTransaction
- `messageHash`     : 트랜잭션 내 데이터의 해시
- `rawTransaction`  : 트랜잭션 정보와 서명을 합친 것. 곧바로 전송할 수 있도록 직렬화된 트랜잭션 문자열.
- `transactionHash` : TXID라고도 불리며, 트랜잭션 고유 ID. rawTransaction을 keccak256 해시 함수에 넣어서 얻을 수 있다.
- `v, r, s`         : ECDSA 디지털 서명의 세 가지 구성요소. Ecrecover를 통해 공개키를 얻을 수 있다.


## 리턴: SignedTransaction 예시
```ts
{
  messageHash: '0xa7676a8f069be7369a45b2d6f654270fc69e64d51c17663e724f52bd011131e9',
  v: '0x2d',
  r: '0xec7249e2dd3230ba98ee1586f8f7509ba39bfa6fb02c2aa50f73d314604cac8f',
  s: '0x2360331ad53159e5f5868819fb3d3131f9192c71099cf073852bceeac48d05e5',
  rawTransaction: '0xf86a0784054a3446825208946f2e7094c9a669930aa88cd60a7a4e4d8a9b439387470de4df820000802da0ec7249e2dd3230ba98ee1586f8f7509ba39bfa6fb02c2aa50f73d314604cac8fa02360331ad53159e5f5868819fb3d3131f9192c71099cf073852bceeac48d05e5',
  transactionHash: '0x594b69186c963f59823a0f5d2e90f6b8cd1be99f06d3f04116fd1cff8961e826'
}
```

<br>

</details>


<!--------------------------------------------------------------------------------------------------->
# 트랜잭션 전송
---
- <https://web3js.readthedocs.io/en/v1.8.1/web3-eth.html#sendsignedtransaction>

<details>
<summary markdown="span">
...
</summary>

## 메소드
```ts
await web.eth.sendSignedTransaction(signedTransactionData: string, callback?: (error, hash) => void);
```


## 예제
```ts
// 트랜잭션 서명
const signedTx = await eth.accounts.signTransaction(transaction, prvKeyFrom);
    
// 서명된 트랜잭션의 rawTransaction 전송
const resSend = await eth.sendSignedTransaction(signedTx.rawTransaction!, function(error, hash) {
    if (!error) {
        console.log("Send - Success: ", hash);
    } else {
        console.log("Send - Error: ", error);
    }
});
```


## 설명
- 서명된 트랜잭션(Raw 트랜잭션)의 직렬화된 스트링을 이더리움 네트워크에 전송한다.


## 리턴
- 타입 : TransactionReceipt
- 트랜잭션 전송 결과 데이터


## 유의사항
- `await`를 통해 대기할 경우, 다른 노드가 채굴에 성공하여 트랜잭션을 검증할 때까지 기다린다.
- `gasPrice`를 평균보다 낮게 설정하면 대기 시간이 오래 걸릴 수 있다.


## 리턴: TransactionReceipt
- `from`              : 발신자 주소
- `transactionHash`   : 트랜잭션 해시
- `gasUsed`           : 실제로 소모된 가스 개수
- `effectiveGasPrice` : 실제로 소모된 가스 가격
- `cumulativeGasUsed` : 블럭에서 사용된 전체 가스 비용


## 리턴: TransactionReceipt 예시
```ts
{
  blockHash: '0x5cd76318ea0946d8054b0f1a93e3892b41afed8fb0db228adf1ddd911472ef3d',
  blockNumber: 8291406,
  contractAddress: null,
  cumulativeGasUsed: 6082513,
  effectiveGasPrice: 88749126,
  from: '0x9e27ddd14395760e7b06ed5ed3a955ce355b19f4',
  gasUsed: 21000,
  logs: [],
  logsBloom: '0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
  status: true,
  to: '0x6f2e7094c9a669930aa88cd60a7a4e4d8a9b4393',
  transactionHash: '0x594b69186c963f59823a0f5d2e90f6b8cd1be99f06d3f04116fd1cff8961e826',
  transactionIndex: 48,
  type: '0x0'
}
```

<br>

</details>


<!--------------------------------------------------------------------------------------------------->
# 트랜잭션 조회
---
- <https://web3js.readthedocs.io/en/v1.8.1/web3-eth.html#gettransaction>
- https://etherscan.io/tx/{트랜잭션_해시}
- https://goerli.etherscan.io/tx/{트랜잭션_해시}

<details>
<summary markdown="span">
...
</summary>

## 메소드
```ts
await web3.eth.getTransaction(transactionHash: string [, callback])
```


## 예제
```ts
// 트랜잭션 전송 => 결과 타입 : TransactionReceipt
const resSend = await web3.eth.sendSignedTransaction( ... );

// 트랜잭션 조회
const txInfo = await web3.eth.getTransaction(resSend.transactionHash);
```


## 설명
- 전송된 트랜잭션의 상태와 정보를 조회한다.


## 리턴 예시
```ts
{
  hash: '0xc1517259b910ce6820fe353f5c9e8b8f28c2c85536beb6929ff1fe44b0d43776',
  nonce: 16,
  blockHash: '0x2f5c26dadd6cfdab47f94097a1f5125cc2865a288a5294a3520b41a7ba93392d',
  blockNumber: 20,
  transactionIndex: 0,
  from: '0x9e27dDd14395760e7B06ED5Ed3A955Ce355B19f4',
  to: '0x6F2e7094C9A669930aA88Cd60a7a4e4d8a9b4393',
  value: '550000000000000000',
  gas: 21000,
  gasPrice: '20000000000',
  input: '0x',
  v: '0xa95',
  r: '0x42b32c19c101ceceddd02c7080b5a0f74aa3284fee2ce320088f3f89e77aaa1a',
  s: '0x79b839b3c3aee97cd1e97976ce9c928c7f604468ee5ea766c8547e143799eea'
}
```

<br>

</details>


<!--------------------------------------------------------------------------------------------------->
# 대기 중인 트랜잭션 조회
---
- <https://web3js.readthedocs.io/en/v1.2.11/web3-eth.html#getpendingtransactions>

<details>
<summary markdown="span">
...
</summary>

## 메소드
```ts
await web3.eth.getPendingTransactions([callback])
```


## 설명
- 전송된 후, 검증 대기 중인 트랜잭션의 상태와 정보를 조회한다.

<br>

</details>

