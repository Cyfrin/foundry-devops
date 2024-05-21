// SPDX-License-Identifier: MIT

pragma solidity >=0.8.13 <0.9.0;

import {Vm} from "forge-std/Vm.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {StdCheatsSafe} from "forge-std/StdCheats.sol";
import {console} from "forge-std/console.sol";
import {StringUtils} from "./StringUtils.sol";

library DevOpsTools {
    using stdJson for string;
    using StringUtils for string;

    Vm public constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    string public constant RELATIVE_BROADCAST_PATH = "./broadcast";

    function get_most_recent_deployment(string memory contractName, uint256 chainId) internal view returns (address) {
        return get_most_recent_deployment(contractName, chainId, RELATIVE_BROADCAST_PATH);
    }

    function get_most_recent_deployment(
        string memory contractName,
        uint256 chainId,
        string memory relativeBroadcastPath
    ) internal view returns (address) {
        address latestAddress = address(0);
        uint256 lastTimestamp;

        bool runProcessed;
        Vm.DirEntry[] memory entries = vm.readDir(relativeBroadcastPath, 3);
        for (uint256 i = 0; i < entries.length; i++) {
            Vm.DirEntry memory entry = entries[i];
            if (
                entry.path.contains(string.concat("/", vm.toString(chainId), "/")) && entry.path.contains(".json")
                    && !entry.path.contains("dry-run")
            ) {
                runProcessed = true;
                string memory json = vm.readFile(entry.path);

                uint256 timestamp = vm.parseJsonUint(json, ".timestamp");

                if (timestamp > lastTimestamp) {
                    latestAddress = processRun(json, contractName, latestAddress);

                    // If we have found some deployed contract, update the timestamp
                    // Otherwise, the earliest deployment may have been before `lastTimestamp` and we should not update
                    if (latestAddress != address(0)) {
                        lastTimestamp = timestamp;
                    }
                }
            }
        }

        if (!runProcessed) {
            revert("No deployment artifacts were found for specified chain");
        }

        if (latestAddress != address(0)) {
            return latestAddress;
        } else {
            revert("No contract deployed");
        }
    }

    function processRun(string memory json, string memory contractName, address latestAddress)
        internal
        view
        returns (address)
    {
        for (uint256 i = 0; vm.keyExistsJson(json, string.concat("$.transactions[", vm.toString(i), "]")); i++) {
            string memory contractNamePath = string.concat("$.transactions[", vm.toString(i), "].contractName");
            if (vm.keyExistsJson(json, contractNamePath)) {
                string memory deployedContractName = json.readString(contractNamePath);
                if (deployedContractName.isEqualTo(contractName)) {
                    latestAddress =
                        json.readAddress(string.concat("$.transactions[", vm.toString(i), "].contractAddress"));
                }
            }
        }

        return latestAddress;
    }
}
