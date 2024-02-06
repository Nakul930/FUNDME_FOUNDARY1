// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


import {PriceConverter} from "./PriceConvertor.sol/";

error FundME__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) private s_addressToAmountFunded;  //mapping from address to amount funded
    address[] private s_funders;

    
    address immutable public i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;  //minimum usd is 5 dollors
    AggregatorV3Interface private s_priceFeed;
    
    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);   
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");
        
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }
    
    function getVersion() public view returns (uint256){
        
        return s_priceFeed.version();
    }
    
    modifier onlyOwner {
        // require(msg.sender == owner);                              //as we know the person who deploys will become owner
        if (msg.sender != i_owner) revert FundME__NotOwner();
        _;
    }
    
    function withdraw() public onlyOwner {                            //only owner can withdraw
        for (uint256 funderIndex=0; funderIndex < s_funders.length; funderIndex++){           
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
       
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
   

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
    //getters
    function getAddresstoAmountfunded(address fundingAddress)external view returns (uint256){
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index)external view returns(address){
        return s_funders[index];
    }
    function getowner() external view returns(address){
        return i_owner;
    }
}   
