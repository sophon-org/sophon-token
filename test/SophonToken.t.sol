// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.28;

import {Test, console} from "forge-std/Test.sol";

import {SophonToken} from "../contracts/SophonToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MockERC20} from "contracts/mocks/MockERC20.sol";

contract SophonTokenTest is Test {
    address internal deployer = address(uint160(uint256(keccak256("deployer"))));
    address internal owner = address(uint160(uint256(keccak256("owner"))));
    address internal mintReceiver = address(uint160(uint256(keccak256("mintReceiver"))));

    SophonToken public sophonToken;

    function setUp() public {
        vm.deal(deployer, 1_000_000e18);
        vm.deal(mintReceiver, 1_000_000e18);

        vm.startPrank(deployer);

        sophonToken = new SophonToken(owner, mintReceiver);

        vm.stopPrank();
    }

    function test_Name() public {
        assertEq(sophonToken.name(), "Sophon");
    }

    function test_Symbol() public {
        assertEq(sophonToken.symbol(), "SOPH");
    }

    function test_CorrectSetUp() public {
        assertEq(sophonToken.owner(), owner);
        assertEq(sophonToken.totalSupply(), 10_000_000_000e18);
        assertEq(sophonToken.balanceOf(mintReceiver), 10_000_000_000e18);
    }

    function test_Burn(uint256 burnAmount) public {
        uint256 initialTotalSupply = sophonToken.totalSupply();
        burnAmount = bound(burnAmount, 1, initialTotalSupply);
        vm.prank(mintReceiver);
        sophonToken.burn(burnAmount);
        assertEq(sophonToken.balanceOf(mintReceiver), initialTotalSupply - burnAmount);
    }

    function test_BurnFrom(uint256 burnAmount) public {
        uint256 initialTotalSupply = sophonToken.totalSupply();
        burnAmount = bound(burnAmount, 1, initialTotalSupply);
        vm.prank(mintReceiver);
        sophonToken.approve(deployer, burnAmount);
        vm.prank(deployer);
        sophonToken.burnFrom(mintReceiver, burnAmount);
        assertEq(sophonToken.balanceOf(mintReceiver), initialTotalSupply - burnAmount);
    }

    function test_Rescue() public {
        vm.startPrank(owner);

        IERC20 token = IERC20(address(new MockERC20("MockToken", "MTK", 18)));
        deal(address(token), address(sophonToken), 100e18);

        assertEq(token.balanceOf(address(sophonToken)), 100e18);
        assertEq(token.balanceOf(address(owner)), 0);

        sophonToken.rescue(token);

        assertEq(token.balanceOf(address(sophonToken)), 0);
        assertEq(token.balanceOf(address(owner)), 100e18);
    }

    function test_Update() public {
        vm.prank(mintReceiver);
        vm.expectRevert(SophonToken.ERC20TokenIsReceiver.selector);
        sophonToken.transfer(address(sophonToken), 100e18);
    }
}
