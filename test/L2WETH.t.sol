// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import {L2WETH} from "../contracts/L2WETH.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract W2WETHTest is Test {
    address internal deployer = makeAddr("deployer");
    address internal user = makeAddr("user");

    L2WETH public implementation;
    ERC1967Proxy public l2WethProxy;
    L2WETH public l2Weth;

    function setUp() public {
        vm.deal(deployer, 1_000_000e18);
        vm.deal(user, 1_000_000e18);

        vm.startPrank(deployer);
        L2WETH implementation = new L2WETH();

        l2WethProxy = new ERC1967Proxy(
            address(implementation), abi.encodeWithSelector(implementation.initialize.selector, "Sophon", "SOPH")
        );

        l2Weth = L2WETH(payable(address(l2WethProxy)));

        vm.stopPrank();
    }

    function test_Name() public {
        assertEq(l2Weth.name(), "Sophon");
    }

    function test_Symbol() public {
        assertEq(l2Weth.symbol(), "SOPH");
    }

    function test_BridgeMint() public {
        vm.startPrank(user);
        vm.expectRevert("bridgeMint is not implemented");
        l2Weth.bridgeMint(user, 1_000e18);
    }

    function test_BridgeBurn() public {
        vm.startPrank(user);
        vm.expectRevert("bridgeBurn is not implemented yet");
        l2Weth.bridgeBurn(user, 1_000e18);
    }

    function test_l2Bridge() public {
        vm.startPrank(user);
        vm.expectRevert("l2Bridge is not implemented yet");
        l2Weth.l2Bridge();
    }

    function test_l1Address() public {
        vm.startPrank(user);
        vm.expectRevert("l1Address is not implemented yet");
        l2Weth.l1Address();
    }

    function test_Deposit(uint256 depositAmount) public {
        vm.startPrank(user);
        depositAmount = bound(depositAmount, 1, address(user).balance);
        l2Weth.deposit{value: depositAmount}();
        assertEq(l2Weth.balanceOf(user), depositAmount);
    }

    function test_Withdraw(uint256 depositAmount, uint256 withdrawAmount) public {
        vm.startPrank(user);
        depositAmount = bound(depositAmount, 1, address(user).balance);
        l2Weth.deposit{value: depositAmount}();
        assertEq(l2Weth.balanceOf(user), depositAmount);

        withdrawAmount = bound(withdrawAmount, 1, depositAmount);
        l2Weth.withdraw(withdrawAmount);
        assertEq(l2Weth.balanceOf(user), depositAmount - withdrawAmount);
    }

    function test_DepositTo(uint256 depositAmount) public {
        vm.startPrank(user);
        address receiver = makeAddr("receiver");
        depositAmount = bound(depositAmount, 1, address(user).balance);
        l2Weth.depositTo{value: depositAmount}(receiver);
        assertEq(l2Weth.balanceOf(receiver), depositAmount);
    }

    function test_WithdrawTo(uint256 depositAmount, uint256 withdrawAmount) public {
        vm.startPrank(user);
        depositAmount = bound(depositAmount, 1, address(user).balance);
        l2Weth.deposit{value: depositAmount}();
        assertEq(l2Weth.balanceOf(user), depositAmount);

        address receiver = makeAddr("receiver");
        withdrawAmount = bound(withdrawAmount, 1, depositAmount);
        l2Weth.withdrawTo(receiver, withdrawAmount);
        assertEq(address(receiver).balance, withdrawAmount);
    }
}
