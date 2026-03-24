// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

contract Auction{

    address payable public beneficiary;
    uint public auctionEndTime;
    string private secretMessage;
    
    uint public maxBidders;
    uint public bidderCounter;

    address public highestBidder;
    uint public highestBid;
    uint public difference;

    mapping(address=> uint) pendingReturns;
    mapping(address=>bool) hasBid;

    bool ended;

    event HighestBidIncreased(address bidder, uint bid, uint _difference);
    event AuctionHasEnded(uint _highestBid, address _highestBidder);
    
    error maxBiddersAlready(uint maxBidders);
    error AuctionAlreadyEnded();
    error BidNotHighEnough(uint highestBid);
    error NotYetEnded();

    constructor(
        uint biddingTime,
        string memory secret,
        address payable beneficiaryAddress,
        uint maxbid
        
    ){
        beneficiary= beneficiaryAddress;
        auctionEndTime = block.timestamp + biddingTime;
        secretMessage=secret;
        maxbid=maxBidders;
    }
    
    function bid() external payable {
        if(bidderCounter>=maxBidders && !hasBid[msg.sender])
            revert maxBiddersAlready(maxBidders);
        if(ended)
            revert AuctionAlreadyEnded();
        if(msg.value<=highestBid)
            revert BidNotHighEnough(highestBid);
        if(!hasBid[msg.sender]){
            bidderCounter++;
            hasBid[msg.sender]=true;
        }
        if(highestBid!=0){
            pendingReturns[highestBidder]+=highestBid;
        }        
        difference = msg.value - highestBid;
        highestBid=msg.value;
        highestBidder=msg.sender;
        emit HighestBidIncreased(msg.sender,msg.value,difference);



    }

    function withdraw() external returns (bool){
        uint amount = pendingReturns[msg.sender];
        require(ended,"Auction has not yet ended");
        require(amount>0);
        if(amount>0){
            pendingReturns[msg.sender]=0;
            (bool success,) = payable(msg.sender).call{value: amount}("");
            if(!success){
                pendingReturns[msg.sender]=amount;
                return false;
            }
        }
        return true;
    }

    function auctionEnd() external {
        //checks
        if(block.timestamp<auctionEndTime)
            revert NotYetEnded();
        if(ended)
            revert AuctionAlreadyEnded();
        
        //effects
        ended = true;
        emit AuctionHasEnded(highestBid,highestBidder);
        
        
        //interactions

        (bool success, )=beneficiary.call{value: highestBid}("");
        require(success, "Sending money didn't succeed");

    }
    
    function getSecretMessage() external view returns(string memory){
        require(ended,"Auction has not yet ended");
        require(highestBidder==msg.sender,"Not highest bidder");

        return secretMessage;
        
    }


}