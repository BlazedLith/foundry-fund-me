//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("User");
    uint256 constant MINIMUM_ETH = 0.1 ether;
    uint256 constant STARTING_BALANCE = 100 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: MINIMUM_ETH}();
        _;
    }

    function testMinimumDollarIsFive() external view {
        // 5 USD in ETH
        uint256 minimumUsd = 5e18; // 5 * 10 ** 18
        assertEq(fundMe.MINIMUM_USD(), minimumUsd);
    }

    function testOwnerIsMsgSender() external view {
        // Check if the owner is set to the address that deployed the contract
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersion() external view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutMinimumEth() external {
        // Attempt to fund with less than the minimum ETH
        vm.expectRevert("You need to spend more ETH!");
        fundMe.fund{value: 1e12}(); // 0.001 ETH
    }

    function testFundSucceedsWithMinimumEth() external funded {
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, MINIMUM_ETH);
    }

    function testAddsFundersToArray() external funded {
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerCanWithdraw() external funded {
        // Attempt to withdraw as a non-owner
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() external funded {
        //Arrange
        uint256 startingBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //Assert
        uint256 endingBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingBalance, endingBalance);
    }

    function testWithdrawWithMultipleFunders() external funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value: MINIMUM_ETH}();
        }

        uint256 startingBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert
        uint256 endingBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingBalance, endingBalance);
    }

    function testWithdrawWithMultipleFundersCheaper() external funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value: MINIMUM_ETH}();
        }

        uint256 startingBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        // Assert
        uint256 endingBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingBalance, endingBalance);
    }
}
