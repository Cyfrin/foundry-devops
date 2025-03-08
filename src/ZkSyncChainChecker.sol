// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.18;

import {console2} from "forge-std/console2.sol";

abstract contract ZkSyncChainChecker {
    uint256 constant ZKSYNC_MAINNET_CHAIN_ID = 324;
    uint256 constant ZKSYNC_SEPOLIA_CHAIN_ID = 300;
    uint256 constant ZKSYNC_IN_MEMORY_NODE_CHAIN_ID = 260;

    function isOnZkSyncChainId() public view returns (bool) {
        // We can make a "dummy" check by looking at the chainId, but this won't work for when working with foundry
        return block.chainid == ZKSYNC_MAINNET_CHAIN_ID || block.chainid == ZKSYNC_SEPOLIA_CHAIN_ID
            || block.chainid == ZKSYNC_IN_MEMORY_NODE_CHAIN_ID;
    }

    function isOnZkSyncPrecompiles() public returns (bool isZkSync) {
        // https://docs.zksync.io/build/developer-reference/differences-with-ethereum.html#precompiles
        // As of writing, at least 0x03, 0x04, 0x05, and 0x08 precompiles are not supported on zkSync
        // So, we can call them to check if we are on zkSync or not
        // This test may fail in the future if these precompiles become supported on zkSync
        uint256 value = 1;
        address ripemd = address(uint160(3));
        address identity = address(uint160(4));
        address modexp = address(uint160(5));

        address[3] memory targets = [ripemd, identity, modexp];

        for (uint256 i = 0; i < targets.length; i++) {
            bool success;
            address target = targets[i];
            assembly {
                success := call(gas(), target, value, 0, 0, 0, 0)
            }
            if (!success) {
                isZkSync = true;
                return isZkSync;
            }
        }
        return isZkSync;
    }

    function isZkSyncChain() public returns (bool isZkSync) {
        if (isOnZkSyncChainId()) {
            return isZkSync;
        }
        return isOnZkSyncPrecompiles();
    }

    modifier skipZkSync() {
        if (isZkSyncChain()) {
            console2.log("Skipping test because we are on zkSync");
            return;
        } else {
            _;
        }
    }

    modifier onlyZkSync() {
        if (!isZkSyncChain()) {
            console2.log("Skipping test because we are not on zkSync");
            return;
        } else {
            _;
        }
    }
}
