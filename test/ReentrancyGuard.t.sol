// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ReentrancyGuard} from "../src/ReentrancyGuard.sol";

contract SimpleReentrancyTestContract is ReentrancyGuard {
    function test(address target, bytes calldata data) public nonReentrant {
        (bool success,) = target.call(data);
        require(success, "Something failed");
    }

    function test1() public nonReentrant {
        return;
    }
}

contract CounterTest is Test {
    SimpleReentrancyTestContract public testContract;

    function setUp() public {
        testContract = new SimpleReentrancyTestContract();
    }

    function test_reentrancyGuard() public {
        testContract.test1();

        vm.expectRevert();
        testContract.test(
            address(testContract),
            abi.encodeWithSignature("test(address,bytes)", address(testContract), abi.encodeWithSignature("test1()"))
        );
    }
}
