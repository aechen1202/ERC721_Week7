// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Test, console2} from "forge-std/Test.sol";
import {BlindBoxNFT} from "../src/BlindBoxNFT.sol";
import "forge-std/console.sol"; 
import "@openzeppelin/contracts/utils/Strings.sol";

contract BlindBoxNFTTest is Test {
    BlindBoxNFT blindBoxNFT;
    address user1;
    function setUp() public {
        user1 = makeAddr("art");
        blindBoxNFT = new BlindBoxNFT(user1);
    }

    function test_mint() public {
        vm.startPrank(user1);
        vm.warp(1);
        uint256 tokenId1 = blindBoxNFT.mint(user1);
        require(tokenId1>0);
        vm.warp(2);
        uint256 tokenId2 = blindBoxNFT.mint(user1);
        require(tokenId2>0);
        require(tokenId1!=tokenId2);
        console.log("mint 2 NFT tokenId1!= tokenId2");
        console.log(tokenId1);
        console.log(tokenId2);
        vm.stopPrank();

    }

    function test_reveal() public {
        vm.startPrank(user1);
        uint256 tokenId = blindBoxNFT.mint(user1);
        require(tokenId>0);

        //BeforeReveal
        string memory baseURIBeforeReveal="ipfs://Qmdhe87uRvnpbxKEkWTGkpgdFP3RS4bQBLCJWp8vqkQmqp/";
        assertEq(blindBoxNFT.tokenURI(tokenId), 
        string.concat(baseURIBeforeReveal,Strings.toString(tokenId),".json"));


        //AfterReveal
        string memory baseURIAfterReveal="ipfs://xxxxxxxxxxxxxxxxxxx/";
        blindBoxNFT.setBaseURI(baseURIAfterReveal);
        assertEq(blindBoxNFT.tokenURI(tokenId), 
        string.concat(baseURIAfterReveal,Strings.toString(tokenId),".json"));

        vm.stopPrank();

    }

}