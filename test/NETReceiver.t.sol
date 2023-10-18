// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Test, console2} from "forge-std/Test.sol";
import {HW1,NETReceiver,OtherNft} from "../src/ERC721Receiver.sol";
import "forge-std/console.sol"; 

contract NETReceiverTest is Test {
    HW1 public hw1;
    NETReceiver public nftReceiver;
    OtherNft public otherNft;
    address user1;

    function setUp() public {
        hw1 = new HW1();
        nftReceiver = new NETReceiver(address(hw1));
        otherNft = new OtherNft();
        user1 = makeAddr("art");
    }
    function test_Receiver() public {
        vm.startPrank(user1);
        uint256 tokenId = hw1.mint(user1);
        require(tokenId>0);
        assertEq(hw1.ownerOf(tokenId), user1);
        console.log("mint HW1 nft for Receiver");
        console.log(tokenId);
        hw1.safeTransferFrom(user1, address(nftReceiver), tokenId);
        assertEq(hw1.balanceOf(user1), 0);

        tokenId=otherNft.mint(user1);
        require(tokenId>0);
        assertEq(otherNft.ownerOf(tokenId), user1);
        assertEq(hw1.balanceOf(user1), 0);
        otherNft.safeTransferFrom(user1, address(nftReceiver), tokenId);
        assertEq(hw1.balanceOf(user1), 1);
        assertEq(otherNft.ownerOf(tokenId), user1);
        console.log("mint other nft for Receiver");
        console.log(user1);
        console.log(otherNft.ownerOf(tokenId));
        console.log(hw1.balanceOf(user1));

        vm.stopPrank();

        //console.log(hw1.ownerOf(tokenId));
        //console.log(address(hw1));
    }

    function test_metadata() public {
        vm.startPrank(user1);
        uint256 tokenId = hw1.mint(user1);
        assertEq(hw1.tokenURI(tokenId), "https://drive.google.com/file/d/1DTwHclyZgPKcHgqxC1EWYNABkgYeaxiJ/view?usp=share_link");
        require(tokenId>0);
        vm.stopPrank();
    }
}