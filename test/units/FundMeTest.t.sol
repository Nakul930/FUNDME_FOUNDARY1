//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {DeployFundMe} from "../../script/DeployfundMe.s.sol";
contract FundMeTest is Test{    
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;     //magic No.s
    uint256 constant GAS_PRICE = 1;

    function setUp() external{
        //fundMe = new FundMe();
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER,1000e18);
    }
    function testMinimumDollarisFive() public{       //test for minimum dollar is 5
        assertEq(fundMe.MINIMUM_USD(), 5e18);                
    }
    function testwoner() public{                     //test for checking msg.sender is the owner
        assertEq(fundMe.i_owner(), msg.sender);      
    }

    function testPriceFeedVersion() public{
        uint256 version= fundMe.getVersion();           //test for checking the version 
        assertEq(version,4);
    }
    function testFundwithoutEnoughEth() public{
        vm.expectRevert();                               //test for making sure it reverts when less usd is send ie below 5 usd
        fundMe.fund();//send value is 0
    }
    function testfundupdatesFundDataStructures() public{
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();                                  
        uint256 amountfunded= fundMe.getAddresstoAmountfunded(USER);   
        assertEq(amountfunded,SEND_VALUE);
    }
     function testAddsFundertoArray() public{
        vm.prank(USER);
        fundMe.fund{value:SEND_VALUE}();
        address funder = fundMe.getFunder(0);             //funder add to array
        assertEq(funder,USER);

    }
    modifier funded(){
        vm.prank(USER);
        fundMe.fund{value:SEND_VALUE}();
        _;
    }
    function testOwnercanOnlyWithdraw() public funded{
        vm.prank(USER);
        vm.expectRevert();
                                                               //ONLY OWNER CAN WITHDRAW
        fundMe.withdraw();
    }
    function testwithASingleFunder() public funded {
        uint256 startingOwnerBalance = fundMe.getowner().balance;     //1 funder withdraw
        uint256 startingfundmeBalance = address(fundMe).balance;
                
        vm.startPrank(fundMe.getowner());
        fundMe.withdraw();   
        vm.stopPrank();

        uint256 endingOwnerbalance = fundMe.getowner().balance;
        uint256 endingfundmebalance= address(fundMe).balance;
        assertEq(endingfundmebalance,0);    
        assertEq(startingfundmeBalance+startingOwnerBalance,endingOwnerbalance);
    }
    function testMultipleFunder() public funded{
        uint160 numberofFunders = 10;
        uint160 startingFunderIndex = 1;                                      //10 funder withdraw
        for(uint160 i = startingFunderIndex; i < numberofFunders; i++){
            hoax(address(i),SEND_VALUE);
            fundMe.fund{value:SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getowner().balance;
        uint256 startingfundmeBalance = address(fundMe).balance;
        vm.startPrank(fundMe.getowner());
        fundMe.withdraw();
        vm.stopPrank();
        

        assert(address(fundMe).balance==0);    
        assert(startingfundmeBalance+startingOwnerBalance==fundMe.getowner().balance);
    }
}
