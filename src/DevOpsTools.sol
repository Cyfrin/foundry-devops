// SPDX-License-Identifier: MIT

pragma solidity >=0.8.13 <0.9.0;

import {Vm} from "forge-std/Vm.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {StdCheatsSafe} from "forge-std/StdCheats.sol";
import {console} from "forge-std/console.sol";
import {StringUtils} from "./StringUtils.sol";

/**
 * Note: Though the arguments property is a string array, when there are no arguments, the json produced has a null value.  The null value
 *           will not deserialize back into an empty string array.  We could have used two different types and used a try / catch to use the correct
 *           type, but to keep things simple, we're deserializing arguments to a string, which allows abi.decode to not revert for a string array
 *           and a null value, but the the arguments value is not usable.  Given the scope of the get_most_recent_deployment function, this seems an
 *           acceptable trade-off.  Somewhat related: https://github.com/foundry-rs/foundry/issues/3731
 */

struct BroadcastTransaction {
    // This is a guess that additionalContracts is a string array
    string[] additionalContracts;
    string arguments;
    address contractAddress;
    string contractName;
    // json key = function
    string functionSig;
    bytes32 hash;
    bool isFixedGasLimit;
    BroadcastTransactionDetail transaction;
    string transactionType;
}

/**
 * The broadcast files committed in April 2023 had reference to an rpc property, which seems to no longer be written.
 */
struct LegacyBroadcastTransaction {
    // This is a guess that additionalContracts is a string array
    string[] additionalContracts;
    string arguments;
    address contractAddress;
    string contractName;
    // json key = function
    string functionSig;
    bytes32 hash;
    bool isFixedGasLimit;
    string rpc;
    BroadcastTransactionDetail transaction;
    string transactionType;
}

struct BroadcastTransactionDetail {
    StdCheatsSafe.AccessList[] accessList;
    bytes data;
    address from;
    uint256 gas;
    uint256 nonce;
    // json key = type
    uint256 txType;
    uint256 value;
}

library DevOpsTools {
    using stdJson for string;
    using StringUtils for string;

    Vm public constant vm = Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

    string public constant RELATIVE_BROADCAST_PATH = "./broadcast";

    function get_most_recent_deployment(string memory contractName, uint256 chainId) public view returns (address) {
        return get_most_recent_deployment(contractName, chainId, RELATIVE_BROADCAST_PATH);
    }

    function get_most_recent_deployment(
        string memory contractName,
        uint256 chainId,
        string memory relativeBroadcastPath
    ) public view returns (address) {
        address latestAddress = address(0);
        uint256 lastTimestamp;

        bool runProcessed;
        Vm.DirEntry[] memory entries = vm.readDir(relativeBroadcastPath, 3);
        for (uint256 i = 0; i < entries.length; i++) {
            Vm.DirEntry memory entry = entries[i];
            if (entry.path.contains(vm.toString(chainId)) && entry.path.contains("run-latest.json")) {
                runProcessed = true;
                string memory json = vm.readFile(entry.path);

                uint256 timestamp = vm.parseJsonUint(json, ".timestamp");

                if (timestamp > lastTimestamp) {
                    // This broadcast is later than the last one we know about, process txns
                    console.log("Processing: ", entry.path);

                    latestAddress = processRun(json, contractName, latestAddress);
                }
            }
        }

        if (!runProcessed) {
            revert("No run-latest.json file found for specified chain");
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
        bytes memory transactionsBytes = json.parseRaw("$.transactions");

        if (vm.keyExists(json, "$.transactions[0].rpc")) {
            LegacyBroadcastTransaction[] memory transactions =
                abi.decode(transactionsBytes, (LegacyBroadcastTransaction[]));

            console.log("Inspecting %s transactions", transactions.length);

            for (uint256 i = 0; i < transactions.length; i++) {
                LegacyBroadcastTransaction memory transaction = transactions[i];
                if (transaction.contractName.isEqualTo(contractName)) {
                    latestAddress = transaction.contractAddress;
                }
            }
        } else {
            BroadcastTransaction[] memory transactions = abi.decode(transactionsBytes, (BroadcastTransaction[]));
            console.log("Inspecting %s transactions", transactions.length);

            for (uint256 i = 0; i < transactions.length; i++) {
                BroadcastTransaction memory transaction = transactions[i];
                if (transaction.contractName.isEqualTo(contractName)) {
                    latestAddress = transaction.contractAddress;
                }
            }
        }
        return latestAddress;
    }
}
