//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {DeployFundMe} from "../../script/DeployfundMe.s.sol";
import {FundingFundme,WithdrawingFundme} from "../../script/interaction.s.sol";
contract InterationTest is Test{ 
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;
    function setUp() external{
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, STARTING_BALANCE);
    }
    function testUsercanFund() public {
        FundingFundme fundFundMe = new FundingFundme();
        fundFundMe.fundFundMe(address(fundMe));
        WithdrawingFundme withdrawFundMe = new WithdrawingFundme();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }

}