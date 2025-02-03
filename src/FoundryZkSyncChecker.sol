// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console2} from "forge-std/Test.sol";

// We have to label it a test so foundry-zksync doesn't get confused
abstract contract FoundryZkSyncChecker is Test {
    // Old
    // // cast from-utf8 "forge 0.0.2"
    // bytes constant FORGE_VERSION_0_0_2 = hex"666f72676520302e302e32";
    // // cast from-utf8 "forge 0.0.4"
    // bytes constant FORGE_VERSION_0_0_4 = hex"666f72676520302e302e34";

    // cast from-utf8 "forge 0.0."
    bytes constant FORGE_VERSION_0_0_ = hex"666f72676520302e302e";

    // cast from-utf8 "forge 0.2."
    bytes constant FORGE_VERSION_0_2_ = hex"666f72676520302e322e";
    // cast from-utf8 "forge 0.3."
    bytes constant FORGE_VERSION_0_3_ = hex"666f72676520302e332e";

    // cast from-utf8 "forge Version: 0.3"
    bytes constant POST_THREE_FORGE_VERSION = hex"666f7267652056657273696f6e3a20302e33";
    // cast from-utf8 "forge Version: 1.0"
    bytes constant STABLE_ONE_VERSION = hex"666f7267652056657273696f6e3a20312e30";

    uint256 constant PRIOR_TO_THREE_PREFIX_LENGTH = 10;
    uint256 constant POST_THREE_PREFIX_LENGTH = 18;

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

        uint256 prefix_length = POST_THREE_PREFIX_LENGTH;
        for (uint256 i = 0; i < POST_THREE_PREFIX_LENGTH; i++) {
            if (retData[i] != POST_THREE_FORGE_VERSION[i]) {
                prefix_length = PRIOR_TO_THREE_PREFIX_LENGTH;
                break;
            }
        }

        if (prefix_length != POST_THREE_PREFIX_LENGTH) {
            prefix_length = POST_THREE_PREFIX_LENGTH;
            for (uint256 i = 0; i < POST_THREE_PREFIX_LENGTH; i++) {
                if (retData[i] != STABLE_ONE_VERSION[i]) {
                    prefix_length = PRIOR_TO_THREE_PREFIX_LENGTH;
                    break;
                }
            }
        }

        bytes memory forgeVersionPrefixed = new bytes(prefix_length);

        for (uint256 i = 0; i < prefix_length; i++) {
            forgeVersionPrefixed[i] = retData[i];
        }
        string memory forgePrefixedStr = string(forgeVersionPrefixed);
        console2.log("Got forge version:", forgePrefixedStr);

        console2.logBytes32(bytes32(forgeVersionPrefixed));
        console2.logBytes32(bytes32(FORGE_VERSION_0_3_));

        if (
            bytes32(forgeVersionPrefixed) == bytes32(FORGE_VERSION_0_2_)
                || bytes32(forgeVersionPrefixed) == bytes32(FORGE_VERSION_0_3_)
                || bytes32(forgeVersionPrefixed) == bytes32(POST_THREE_FORGE_VERSION)
                || bytes32(forgeVersionPrefixed) == bytes32(STABLE_ONE_VERSION)
        ) {
            console2.log("This is Vanilla Foundry");
            return false;
        } else if (bytes32(forgeVersionPrefixed) == bytes32(FORGE_VERSION_0_0_)) {
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
