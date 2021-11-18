const chai = require('chai')
const { expect } = require("chai");
const { ethers } = require("hardhat");



  describe('AgoraNFT Unit Tests', async function () {
    beforeEach(async () => {
      const Agora = await ethers.getContractFactory("Agora");
      AgoraContract = await Agora.deploy()
    })
    it('The tokenId should increase', async () => {

  let NftId = await AgoraContract.tokenCounter();

  console.log("NftId", NftId)
  let result = await AgoraContract.create("tide")
   // wait until the transaction is mined
 await result.wait();
 
 let NftIdNext = await AgoraContract.tokenCounter();

 expect(NftIdNext).to.be.gt(NftId);
//  expect(NftId == NftIdNext).to.be.false;

})


 it('The newly minted Nft should return the correct Uri', async () => {
  let NftUrl = "https://opensea-creatures-api.herokuapp.com/api/creature/"+"tide" ;
   console.log("tokenUrl", NftUrl)
  let result = await AgoraContract.create("tide")
   // wait until the transaction is mined
 await result.wait();
 let  newNftUrl = await AgoraContract.imageURI();
 console.log("tokenUrl", newNftUrl)  
 expect(NftUrl == newNftUrl).to.be.true
    })

    it('The newly minted Nft should possess a unique Uri', async () => {
      let NftUrl = await AgoraContract.imageURI();
     console.log("tokenUrl", NftUrl)
      let result = await AgoraContract.create("tide")
       // wait until the transaction is mined
     await result.wait();
     let  newNftUrl = await AgoraContract.imageURI();
     console.log("tokenUrl", newNftUrl)  
     expect(NftUrl == newNftUrl).to.be.false
        })


})