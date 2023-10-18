// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; 
import "@openzeppelin/contracts/token/ERC721/IERC721.sol"; 
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "forge-std/console.sol"; 
contract HW1 is ERC721{
    uint256 index=0;
    string customBaseURI="https://drive.google.com/file/d/1DTwHclyZgPKcHgqxC1EWYNABkgYeaxiJ/view?usp=share_link";
   
    // create a ERCJ21 token with name ="" symbol =""
    constructor() ERC721("Don't send NFT to me", "NONFT") {
    }

    //Have the mint function to mint a new token
    function mint(address to) public returns(uint256) {
        index++;
        _mint(to, index);
        return index;
    }
    
    //token metadata URI
    function tokenURI(uint256 tokenId) public view override returns (string memory)
    {
        string memory tokenURI_ = customBaseURI;

        if (index >= tokenId) {
            return tokenURI_;     
        }
        return _baseURI();
    }

}

contract NETReceiver is IERC721Receiver , HW1{
    address private myNFT;
    HW1 hw1=new HW1();

    constructor(address myNFT_) {
        myNFT = myNFT_;
    }

      function onERC721Received(address operator, address from , uint256 tokenId, bytes memory data) external returns (bytes4) {

      
        //1. check the sender(ERC721 contract) is the same as your ERC721 contract.
        //2. if not, please transfer this token back to the original owner. 
        //3. and also mint your HW1 token to the original owner.
        if(msg.sender != myNFT) {
          (bool success,) = address(myNFT).call(abi.encodeWithSignature("mint(address)", from));
          require(success);
          IERC721(msg.sender).safeTransferFrom(address(this),from,tokenId,data);
        }

        //console.log(IERC721(myToken).ownerOf(tokenId));
        return IERC721Receiver.onERC721Received.selector;
    }
}

contract OtherNft is ERC721{
    uint256 index=0;
    string customBaseURI;

    constructor() ERC721("OtherNft", "Other") {}
    function mint(address to) public returns(uint256) {
        index++;
        _mint(to, index);
        return index;
    }
}