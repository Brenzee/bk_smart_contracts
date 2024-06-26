// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

/// @title ReentrancyGuard
/// @notice Provides a modifier to prevent reentrancy attacks by using transient storage (tstore, tload)
contract ReentrancyGuard {
    /// @dev Storage slot for the reentrancy status
    uint256 constant STATUS_SLOT = 0x50faf685b147df9542991c607c44d9086449c331254fbd8f457e5a863d8632cd; // keccak256("ReentrancyGuard.status")

    /// @notice Modifier to prevent reentrancy attacks
    /// @dev Uses inline assembly to access transient storage directly
    modifier nonReentrant() {
        assembly {
            let status := tload(STATUS_SLOT)
            // In Solidity terms this is require(status == 0)
            if iszero(eq(status, 0)) {
                let ptr := mload(0x40) // Load the free memory pointer
                mstore(ptr, 0x20) // Store the length of the error message (32 bytes)
                mstore(add(ptr, 0x20), 0x5265656e7472616e6379206465746563746564) // "Reentrancy detected"
                revert(ptr, 0x40)
            }
            tstore(STATUS_SLOT, 1)
        }
        _;
        assembly {
            tstore(STATUS_SLOT, 0)
        }
    }
}
