// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

contract Auction{

    address payable public beneficiary;
    uint public auctionEndTime;
    string private secretMessage;

    address public highestBidder;
    uint public highestBid;
    uint public difference;

    mapping(address=> uint) pendingReturns;

    bool ended;

    constructor(
        uint biddingTime,
        string memory secret,
        address payable beneficiaryAddress

    ){
        beneficiary= beneficiaryAddress;
        auctionEndTime = block.timestamp + biddingTime;
        secretMessage=secret;
    }
    
    function bid() external payable {
        
        
    }
    



}