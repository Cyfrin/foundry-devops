// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Test} from "forge-std/Test.sol";
import {DevOpsTools} from "../src/DevOpsTools.sol";
import {ZkSyncChainChecker} from "../src/ZkSyncChainChecker.sol";
import {FoundryZkSyncChecker} from "../src/FoundryZkSyncChecker.sol";

contract DevOpsToolsTest is Test, ZkSyncChainChecker, FoundryZkSyncChecker {
    string public constant SEARCH_PATH = "broadcast";

    function testGetMostRecentlyDeployedContract() public skipZkSync onlyVanillaFoundry {
        string memory contractName = "Stuff";
        uint256 chainId = 31337;
        address expectedAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment(contractName, chainId, SEARCH_PATH);
        assertEq(mostRecentDeployment, expectedAddress);
    }

    function testGetMostRecentlyDeployedEvenWhenMultipleAreDeployed() public skipZkSync onlyVanillaFoundry {
        string memory contractName = "FundMe";
        uint256 chainId = 1234;
        address expectedAddress = 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9;
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment(contractName, chainId, SEARCH_PATH);
        assertEq(mostRecentDeployment, expectedAddress);
    }

    function testExpectRevertIfNoRun() public onlyVanillaFoundry {
        string memory contractName = "FundMe";
        uint256 chainId = 9999;
        vm.expectRevert("No deployment artifacts were found for specified chain");
        DevOpsTools.get_most_recent_deployment(contractName, chainId, SEARCH_PATH);
    }

    function testExpectRevertIfNoDeployment() public skipZkSync onlyVanillaFoundry {
        string memory contractName = "MissingContract";
        uint256 chainId = 1234;
        vm.expectRevert("No contract deployed");
        DevOpsTools.get_most_recent_deployment(contractName, chainId, SEARCH_PATH);
    }

    // All other tests use what appear to be legacy broadcast files
    // This one uses the newer type with no rpc property
    function testNonLegacyBroadcast() public skipZkSync onlyVanillaFoundry {
        string memory contractName = "NewStuff";
        uint256 chainId = 31337;
        address expectedAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment(contractName, chainId, SEARCH_PATH);
        assertEq(mostRecentDeployment, expectedAddress);
    }
}
