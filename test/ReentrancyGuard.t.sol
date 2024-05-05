// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Test} from "forge-std/Test.sol";
import {ReentrancyGuard} from "../src/ReentrancyGuard.sol";

contract SimpleReentrancyContract is ReentrancyGuard {
    function tCall(address target, bytes calldata data) public nonReentrant {
        (bool success,) = target.call(data);
        require(success, "Something failed");
    }

    function t1() public nonReentrant {
        return;
    }
}

contract ReentrancyGuardTest is Test {
    SimpleReentrancyContract public testContract;

    function setUp() public {
        testContract = new SimpleReentrancyContract();
    }

    function test_reentrancyGuard() public {
        testContract.t1();

        vm.expectRevert();
        testContract.tCall(
            address(testContract),
            abi.encodeWithSignature("tCall(address,bytes)", address(testContract), abi.encodeWithSignature("t1()"))
        );
    }
}
