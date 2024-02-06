## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

Prerequisites -
First you need to make sure you have git on your steup!
so you can check it by running

```
git --version
 ```    
    in your terminal.this will show that if you have git or not if no,then you need to install git!

run foundry comand -

````
curl -L https://foundry.paradigm.xyz | bash
```
this will install foundry!

Now to Deploy you can use this below comand

```
forge script script/DeployFundMe.s.sol
```
Now this code has been made with test where most oof its functions are test! So to run Test you can say -

```
forge test

```
Now to see the coverage or effieciency of test you can type

```
forge coverage
````

If the Makefile command do not work please make sure to use

```forge script script/DeployfundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
```
 To run it on Sepolia

 
This code has been/can be right now deployed on two main eth chains ie
SEPOLIA AND ETHMAINNET

I know this code hasnt been well written or test efficiency is nit that high as I expected but I promise I will make sure that the test are dont of most of functions as possible! Hope you love my first project in Solidity with help of Foundry! A special thanks To Patrick Collins who has helped or guided me to be a good Blockchain Dev. Also please make sure to pull issues is you found any so that we can connect and solve it!Thankyou!

