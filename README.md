# agora-smart-contracts

## Agora.sol 
 The video/music nft minting contract

## agoraMarket.sol
This is the decentralized marketplace for selling nft tokens 

## agoraShare.sol
 This contract allows you to split an agora Nft into shareable and purchasable bits(token)

## paymentsplitting.sol.
- This contract is
- This contract splits payment amongs investors/ token owners of an Agora Nft after a huge buyout
- This splitter is re-deployed everytime by a method from the frontend, and burns 100% sharedDrops of an 
 Agora NFT



<!-- Todo, not exactly profitable for this hackathon -->
## stream payment.sol
This streams payment to the content creator to ensure they don't runaway with investor's funding



# create a token
 share the token or auction at marketplace

# share token
- Investor Buyout 
- checkout line 140 to 143  and 145 agoraSharetests.js to implement buyout on the frontEnd

# Agora Market
- Investor Executes Order



### SET-UP
- install `node.js` on your local system [here](https://nodejs.org/en/)
- run `npm i` to install dependencies



# check that hardhat works as expected

```
 npx hardhat
```

- Don't override config files

## RUN a node

<!-- Open terminal, use env.example as example for .env variables for asserting correctness of configuration -->
```
npx hardhat node --fork https://api.avax.network/ext/bc/C/rpc

```

## Compile and test solidity file  

<!-- Open another terminal -->

```
 npx hardhat compile
```
```
 npx hardhat test
```

## Deploy
```
 npx hardhat run scripts/deployAgora.js
```




#### FUNCTION MOCKUP'S


# Agora SETTERS

Agora.

** Create()
This function receives the hashed value of the video from ipfs /filecoin

 emit CreatedAgora(tokenCounter, hash)**
 
 create(string memory hash)


# Agora getters

<!-- baseTokenURI(string memory hash) public pure returns (string memory) {
    return string(abi.encodePacked("https://ipfs.io", hash ));
  } -->

baseTokenURI(hash) {
  returns the external Url which could the ipfs.io link
}


formatTokenURI(tokenURL) {
  returns film/token metadata
  }


# AGORA MARKET SETTERS


* **The creator of the video NFT opens an order to sell the created**

openOrder(uint256 _tokenId, uint256 _price){
  emits event
}


* **The function is called by the investor willing to pay the entire sum after the creator list the created NFT from agora**

executeOrder(uint256 _orderId){
  emits event
}


* **This function allows the user to cancel an NFT order incase, and maybe fractionalize**

cancelOrder(uint256 _orderId){
  emits event
}


## AgoraShare setters


* **share a minted agora Nft token**

function shareAgoraNft(uint _tokenId, uint priceinWei) {
  emits event
}


* **Buy part of a shared Video NFT token**

 function buyShares(uint16 _sharedId, uint16 amount) external payable {
   emits event
 }

* **Redeem allows the video NFT owner to redeem the amount invested**

function redeem ( uint _sharedId ) external {}


## AgoraNFT getters

* **returns two seperate arrays fo deploying the payment splitter**

address [] is the array of investors in the particular VIDEO nfT token 

UINT [] is the precentage share of the investor index to index

This is useful in the payment splitter constructor-->


function getInvestorNShares(uint16 _sharedId) external  returns (address [] memory, uint [] memory) {}
