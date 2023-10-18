// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; 
import "@openzeppelin/contracts/token/ERC721/IERC721.sol"; 
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "forge-std/console.sol"; 
contract BlindBoxNFT is ERC721{
    mapping(uint256=>bool) private usedTokenID;
    string customBaseURI;
    address owner;

    constructor(address _owner) ERC721("BlindBoxNFT", "BBNFT") {
        customBaseURI="ipfs://Qmdhe87uRvnpbxKEkWTGkpgdFP3RS4bQBLCJWp8vqkQmqp/";
        owner=_owner;
    }
    
    function mint(address to) public returns(uint256) {
        uint tokenId=random(500);
        if(usedTokenID[tokenId])revert("the token id minted");
        usedTokenID[tokenId]=true;
        _mint(to, tokenId);
        return tokenId;
    }

    function setBaseURI(string memory customBaseURI_) external {
        require(owner==msg.sender,"owner only");
        customBaseURI = customBaseURI_;
    }

    function random(uint number) public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp,  
        msg.sender))) % number;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory)
    {
        string memory tokenURI_ = string.concat(customBaseURI,Strings.toString(tokenId),".json");
        if (usedTokenID[tokenId]) {
            return tokenURI_;     
        }
        return _baseURI();
    }

}