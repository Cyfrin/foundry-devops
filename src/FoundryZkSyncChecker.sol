// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console2} from "forge-std/Script.sol";

abstract contract FoundryZkSyncChecker is Script {
    /**
     * @notice returns the current version of foundry.
     */
    function is_foundry_zksync() internal returns (bool) {
        string[] memory command = new string[](2);
        command[0] = "bash";
        command[1] = "src/is_foundry_zksync.sh";
        bytes memory retData = vm.ffi(command);
        bool isFoundryZkSync = uint256(bytes32(retData)) > 0;
        return isFoundryZkSync;
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
