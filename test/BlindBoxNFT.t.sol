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
        blindBoxNFT = new BlindBoxNFT();
        user1 = makeAddr("art");
    }

    function test_mint() public {
        vm.startPrank(user1);
        vm.warp(1);
        uint256 tokenId = blindBoxNFT.mint(user1);
        console.log(tokenId);
        require(tokenId>0);
        vm.warp(2);
        tokenId = blindBoxNFT.mint(user1);
        require(tokenId>0);
        console.log(tokenId);
        vm.stopPrank();

    }

    function test_reveal() public {
        vm.startPrank(user1);
        uint256 tokenId = blindBoxNFT.mint(user1);
        require(tokenId>0);
        string memory baseURIBeforeReveal="ipfs://Qmdhe87uRvnpbxKEkWTGkpgdFP3RS4bQBLCJWp8vqkQmqp/";
        string memory baseURIAfterReveal="ipfs://xxxxxxxxxxxxxxxxxxx/";
        assertEq(blindBoxNFT.tokenURI(tokenId), 
        string.concat(baseURIBeforeReveal,Strings.toString(tokenId),".json"));
        blindBoxNFT.setBaseURI(baseURIAfterReveal);
         assertEq(blindBoxNFT.tokenURI(tokenId), 
        string.concat(baseURIAfterReveal,Strings.toString(tokenId),".json"));
        vm.stopPrank();

    }

}