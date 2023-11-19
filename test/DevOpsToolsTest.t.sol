// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Test} from "forge-std/Test.sol";
import {DevOpsTools} from "../src/DevOpsTools.sol";

contract DevOpsToolsTest is Test {
    string public constant SEARCH_PATH = "broadcast";

    function testGetMostRecentlyDeployedContract() public {
        string memory contractName = "Stuff";
        uint256 chainId = 31337;
        address expectedAddress = 0xa513E6E4b8f2a923D98304ec87F64353C4D5C853;
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment(
            contractName,
            chainId,
            SEARCH_PATH
        );
        assertEq(mostRecentDeployment, expectedAddress);
    }

    function testGetMostRecentlyDeployedEvenWhenMultipleAreDeployed() public {
        string memory contractName = "FundMe";
        uint256 chainId = 1234;
        address expectedAddress = 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9;
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment(
            contractName,
            chainId,
            SEARCH_PATH
        );
        assertEq(mostRecentDeployment, expectedAddress);
    }

    function testExpectRevertIfNoRun() public {
        string memory contractName = "FundMe";
        uint256 chainId = 9999;
        vm.expectRevert("No run-latest.json file found for specified chain");
        DevOpsTools.get_most_recent_deployment(
            contractName,
            chainId,
            SEARCH_PATH
        );
    }

    function testExpectRevertIfNoDeployment() public {
        string memory contractName = "MissingContract";
        uint256 chainId = 1234;
        vm.expectRevert("No contract deployed");
        DevOpsTools.get_most_recent_deployment(
            contractName,
            chainId,
            SEARCH_PATH
        );
    }

    // All other tests use what appear to be legacy broadcast files
    // This one uses the newer type with no rpc property
    function testNonLegacyBroadcast() public {
        string memory contractName = "NewStuff";
        uint256 chainId = 31337;
        address expectedAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment(
            contractName,
            chainId,
            SEARCH_PATH
        );
        assertEq(mostRecentDeployment, expectedAddress);
    }
}
