// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import "./Auction.sol";


contract AuctionCollection {

    Auction [] public auctions;

    function createAuction(uint  biddingTime, string memory secret, address payable beneficiary, uint max) public  {
        Auction  newAuction = new Auction(biddingTime, secret, beneficiary, max);
        auctions.push(newAuction);
    }

    function getLength() external view returns(uint){
        return auctions.length;
    }

    function getAllAuctions() public view returns (Auction[] memory){
        return auctions;
    }


}