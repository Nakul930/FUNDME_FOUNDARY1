// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "forge-std/Script.sol";
import "foundry-devops/src/DevOpsTools.sol";
import "../src/fundme.sol";
contract FundingFundme is Script {
    uint256 constant Send_value = 0.01 ether;
    function fundFundMe(address mostRecentDeployed) public{
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployed)).fund{value:Send_value}();   
        vm.stopBroadcast(); 
        console.log("Funded FundMe with %s",Send_value);
    }
    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        vm.startBroadcast();
        fundFundMe(mostRecentDeployed);
        vm.stopBroadcast();    
    }
}
contract WithdrawingFundme is Script{
    function withdrawFundMe(address mostRecentDeployed) public{
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployed)).withdraw();
        vm.stopBroadcast();
        
    }
      function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        vm.startBroadcast();
        withdrawFundMe(mostRecentDeployed);
        vm.stopBroadcast();    
    }
    
}