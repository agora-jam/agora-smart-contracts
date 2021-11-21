pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";





contract AgoraShare is ERC20, ERC20Burnable {

// uint sharedId;

struct SharedDrop  {
  address sharer;
  // address splitterContract;

  // share [] shares;
  uint256 tokensleft;
  uint16 sold;
  uint256 tokenId;
  uint256 unitprice;
  Status state ;//{ Shared, Whole}

  // mapping(uint => sharedDrop) public sharedDrops;
}

    enum Status { Shared, Whole}
    Status state;

  SharedDrop [] sharedDrops;

  mapping (address => uint) [] share;

  mapping (uint => address[]) investors ;


  address[] splitterContract;
  
  bool tokensAvailableForSale;

  uint[] knownShares;

 event AgoraShared(
    // uint Id,
    address indexed sharer,
    uint256 indexed tokenId,
    uint tokenQuanity,
    uint256 priceInWei,
    Status state
  );


  event buyAgoraShared(
    // uint Id,
    uint256 indexed tokenId,
    uint256 totalPrice,
    uint16 amount,
    address indexed owner,
    address indexed buyer
  );

   
  event redeemAgoraShared(
    // uint _sharedId,
    uint tokenId,
    address indexed owner,
    uint amountgained
    );




   address AgoraNFTaddress;
//   Agora agora;
  uint tokenId;
//   uint numberOfTokens;


  constructor(address _agoraNft, uint _tokenId) ERC20('AgoraShareToken', 'agx') {
//   sharedId = 0;
   AgoraNFTaddress = _agoraNft;
  tokenId = _tokenId;
//   numberOfTokens = _numberOfTokens;
 
  }

    
    
    

  function shareAgoraNft( uint raiseAmount, uint _numberOfTokens) public {
   
    require(msg.sender == getTokenOwner(),"not owner");
    
    IERC721(AgoraNFTaddress).transferFrom(msg.sender, address(this), tokenId);
    
    uint tokenPrice = raiseAmount / _numberOfTokens;

    SharedDrop memory sharedDrop = 
    SharedDrop({
        sharer: msg.sender,
        // splitterContract : "",
        tokenId: tokenId,
        tokensleft: _numberOfTokens,
        sold: 0,
       unitprice: tokenPrice,
       state: Status.Shared
    });
    
    //  sharedId += 1;
    _mint(msg.sender, _numberOfTokens * (10 ** 18));

  emit AgoraShared(
    //   sharedDrop.tokenId, 
                   sharedDrop.sharer,
                   sharedDrop.tokenId,
                   sharedDrop.tokensleft,
                   sharedDrop.unitprice,
                   sharedDrop.state
                   );
                   
  }
 
  


  function buyShares( uint16 amount) external payable {
    //  require buyer has enough money to purchase the amount of tokens
    // subtract the amount sold from the tokensleft
     uint tobuy =  sharedDrops[tokenId].unitprice * amount;

     require(sharedDrops[tokenId].state == Status.Shared, "Shares not yet available for that Id" );
     require( msg.value >= tobuy, "you don't have enough money");
     require( sharedDrops[tokenId].tokensleft > amount, "you're trying to purchase more tokens than exist");
     require( sharedDrops[tokenId].tokensleft > 0, "all tokens sold");
     
      sharedDrops[tokenId].tokensleft -= amount;
      sharedDrops[tokenId].sold += amount;

        share[tokenId][msg.sender] = amount;

    //  sharedDrops[_tokenId].share[_tokenId][msg.sender] = amount;

       investors[tokenId].push(msg.sender);

     _transfer(sharedDrops[tokenId].sharer, msg.sender, amount);


  emit buyAgoraShared(
    //   _sharedId, 
                        sharedDrops[tokenId].tokenId,
                         tobuy,
                         amount,
                         address(this),
                         msg.sender );
  }
  
  function releaseTokens() public {
      tokensAvailableForSale = true;
  }
  
  function authorizeViewing(uint16 sharedID) public view returns(bool) {
    uint arrayLength = investors[sharedID].length;
    for (uint i; i < arrayLength - 1 ; i++) {
        if (investors[sharedID][i] == msg.sender) {
            return true;
        }
    }
  }

  function redeem () external {
    //  check if the sender is the owner
    // transfer sold token value to owner
    // send value to owner
      require(tokensAvailableForSale == true);
      require(msg.sender == sharedDrops[tokenId].sharer, "not owner bros");
      uint amountsold = sharedDrops[tokenId].sold * sharedDrops[tokenId].unitprice ;
      payable(msg.sender).transfer(amountsold);
      
      emit redeemAgoraShared( tokenId,
                              msg.sender,
                              amountsold

      );
  }

  // function buyOut(){
    // This function calls the getInvestor and getShares function
    // creates a newPaymentSplitter ---- redeploys at every instance with getInvestor and getShares
    // ----------------------------if there's enough time, we can consider gelato for automation  for redeployment of payment spiltter
    // then splits amongst investors
    // then burn sharedDrops
    // then transfer ERC721.transfer to buyer
  //    new PaymentSplitter()
  // this is to be done preferably in NodeJS
  // }

 function setSplitContract( address _splitter) internal{
   require(msg.sender == sharedDrops[tokenId].sharer);
   splitterContract[tokenId] = _splitter;
 }



// --------------------------------------getters-----------------------------------
  function getInvestor() internal view returns ( address [] memory) {
   return  investors[tokenId];
  }

  function getInvestorNShares() external  returns (address [] memory, uint [] memory) {
    // uint[] storage knownShares;
    investors [tokenId] = getInvestor();
    uint16 i = 0;
    while( investors[tokenId].length > i )
    {
       knownShares.push(share[tokenId][investors[tokenId][i]]) ;

    }
  //  for (uint16 i = 0; i++; i <= investors[tokenId].length){
  //     knownShares.push(
  //        share[tokenId][investors[i]]
        
  //       // sharedDrops[tokenId].shares[tokenId].investors[i] 
  //       );
  //  }
  // return (investors, knownShares);
  return (investors[tokenId], knownShares);
  }
  
  function getNFTAddress() public view returns(address) {
        return AgoraNFTaddress;
    }
    
    function getTokenOwner() public view returns(address) {
    
        return  IERC721(AgoraNFTaddress).ownerOf(tokenId);
    }
    
    
    
  function getApprove() public {
     IERC721(AgoraNFTaddress).approve(address(this), tokenId);
  }
  
    // function getSharedId() public view returns(uint) {
    
    //     return sharedId;
    // }
    
}