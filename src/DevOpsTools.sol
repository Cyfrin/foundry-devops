// SPDX-License-Identifier: MIT

pragma solidity >=0.8.13 <0.9.0;

import {Vm} from "forge-std/Vm.sol";
import {console} from "forge-std/console.sol";

library DevOpsTools {
    Vm public constant vm =
        Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

    string public constant RELATIVE_BROADCAST_PATH = "./broadcast";
    string public constant RELATIVE_SCRIPT_PATH =
        "./lib/foundry-devops/src/get_recent_deployment.sh";

    function get_most_recent_deployment(
        string memory contractName,
        uint256 chainId
    ) public returns (address) {
        return
            get_most_recent_deployment(
                contractName,
                chainId,
                RELATIVE_BROADCAST_PATH,
                RELATIVE_SCRIPT_PATH
            );
    }

    function cleanStringPath(
        string memory stringToClean
    ) public pure returns (string memory) {
        bytes memory inputBytes = bytes(stringToClean);
        uint256 start = 0;
        uint256 end = inputBytes.length;

        // Find the start of the non-whitespace characters
        for (uint256 i = 0; i < inputBytes.length; i++) {
            if (inputBytes[i] != " ") {
                start = i;
                break;
            }
        }

        // Find the end of the non-whitespace characters
        for (uint256 i = inputBytes.length; i > 0; i--) {
            if (inputBytes[i - 1] != " ") {
                end = i;
                break;
            }
        }

        // Remove the leading '.' if it exists
        if (inputBytes[start] == ".") {
            start += 1;
        }

        // Create a new bytes array for the trimmed string
        bytes memory trimmedBytes = new bytes(end - start);

        // Copy the trimmed characters to the new bytes array
        for (uint256 i = 0; i < trimmedBytes.length; i++) {
            trimmedBytes[i] = inputBytes[start + i];
        }

        return string(trimmedBytes);
    }

    function get_most_recent_deployment(
        string memory contractName,
        uint256 chainId,
        string memory relativeBroadcastPath,
        string memory relativeScriptPath
    ) public returns (address) {
        relativeBroadcastPath = cleanStringPath(relativeBroadcastPath);
        relativeScriptPath = cleanStringPath(relativeScriptPath);

        string[] memory pwd = new string[](1);
        pwd[0] = "pwd";
        string memory absolutePath = string(vm.ffi(pwd));

        string[] memory getRecentDeployment = new string[](5);
        getRecentDeployment[0] = "bash";
        getRecentDeployment[1] = string.concat(
            absolutePath,
            relativeScriptPath
        );
        getRecentDeployment[2] = contractName;
        getRecentDeployment[3] = vm.toString(chainId);
        getRecentDeployment[4] = string.concat(
            absolutePath,
            "/",
            relativeBroadcastPath
        );

        bytes memory retData = vm.ffi(getRecentDeployment);
        console.log("Return Data:");
        console.logBytes(retData);
        address returnedAddress = address(uint160(bytes20(retData)));
        if (returnedAddress != address(0)) {
            return returnedAddress;
        } else {
            revert("No contract deployed");
        }
    }
}
