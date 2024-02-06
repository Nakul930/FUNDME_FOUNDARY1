// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol" ;
import {FundMe} from "../src/fundme.sol";
import{DeployFundMe} from "../script/DeployfundMe.s.sol";
import "./HelperConfig.s.sol" ;

contract DeployFundMe is Script{
    function run() external returns (FundMe){
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}