// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console2} from "forge-std/Test.sol";

// We have to label it a test so foundry-zksync doesn't get confused
abstract contract FoundryZkSyncChecker is Test {
    bytes constant FORGE_VERSION_0_0_2 = hex"666f72676520302e302e32";
    bytes constant FORGE_VERSION_0_2_0 = hex"666f72676520302e322e30";
    uint256 constant PREFIX_LENGTH = 11;

    error FoundryZkSyncChecker__UnknownFoundryVersion();

    /**
     * @notice returns the current version of foundry.
     */
    function is_foundry_zksync() public returns (bool) {
        string[] memory forgeVersionCommand = new string[](2);
        forgeVersionCommand[0] = "forge";
        forgeVersionCommand[1] = "--version";
        bytes memory retData = vm.ffi(forgeVersionCommand);
        console2.logBytes(retData);

        bytes memory forgeVersionPrefixed = new bytes(PREFIX_LENGTH);
        for (uint256 i = 0; i < PREFIX_LENGTH; i++) {
            forgeVersionPrefixed[i] = retData[i];
        }
        string memory forgePrefixedStr = string(forgeVersionPrefixed);
        console2.log("Got forge version:", forgePrefixedStr);

        if (bytes32(forgeVersionPrefixed) == bytes32(FORGE_VERSION_0_2_0)) {
            console2.log("This is Vanilla Foundry");
            return false;
        } else if (bytes32(forgeVersionPrefixed) == bytes32(FORGE_VERSION_0_0_2)) {
            console2.log("This is Foundry ZkSync");
            return true;
        }
        console2.log("Unknown forge version");
        revert FoundryZkSyncChecker__UnknownFoundryVersion();
    }

    modifier onlyFoundryZkSync() {
        if (!is_foundry_zksync()) {
            console2.log("Only foundry-zksync works with this function");
        } else {
            _;
        }
    }

    modifier onlyVanillaFoundry() {
        if (is_foundry_zksync()) {
            console2.log("Only foundry works with this function");
        } else {
            _;
        }
    }
}
