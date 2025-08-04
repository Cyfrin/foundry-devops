// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {DevOpsTools} from "../src/DevOpsTools.sol";
import {ZkSyncChainChecker} from "../src/ZkSyncChainChecker.sol";
import {FoundryZkSyncChecker} from "../src/FoundryZkSyncChecker.sol";

contract DevOpsToolsTest is Test, ZkSyncChainChecker, FoundryZkSyncChecker {
    string public constant SEARCH_PATH = "broadcast";
    string[] public contracts = ["DevOpsTools", "StringUtils"];
    string[] public paths = ["./folder/subfolder", "./folder/subfolder"];
    string[] public files = ["DevOpsToolsArtifacts.json", "StringUtilsArtifacts.json"];
    bool[] public flags = [true, true];

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

    /// forge-config: default.allow_internal_expect_revert = true
    function testExpectRevertIfNoRun() public onlyVanillaFoundry {
        string memory contractName = "FundMe";
        uint256 chainId = 9999;
        vm.expectRevert("No deployment artifacts were found for specified chain");
        DevOpsTools.get_most_recent_deployment(contractName, chainId, SEARCH_PATH);
    }

    /// forge-config: default.allow_internal_expect_revert = true
    function testExpectRevertIfNoDeployment() public skipZkSync onlyVanillaFoundry {
        string memory contractName = "MissingContract";
        uint256 chainId = 1234;
        vm.expectRevert(
            bytes.concat(
                "No contract named ",
                "'",
                bytes(contractName),
                "'",
                " has been deployed on chain ",
                bytes(vm.toString(chainId))
            )
        );
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

    // If `recursive` is `false`, then all the parent folder must exist.
    /// forge-config: default.allow_internal_expect_revert = true
    function testCannotRouteIfParentsAreMissing() public skipZkSync onlyVanillaFoundry {
        string memory path = "./folder/subfolder";
        string memory fileName = "artifacts.json";

        vm.expectRevert();
        DevOpsTools.routeArtifacts("DevOpsTools", path, string.concat(path, "/", fileName), false);
        assertTrue(DevOpsTools.vm.isDir(path), "Folders not created recursively");
        assertTrue(DevOpsTools.vm.isFile(string.concat(path, "/", fileName)), "artifacts.json file not created");
    }

    /// forge-config: default.allow_internal_expect_revert = true
    function testCannotRouteIfContractNotFound() public skipZkSync onlyVanillaFoundry {
        string memory path = "./folder/subfolder";
        string memory fileName = "artifacts.json";

        vm.expectRevert("Contract 'DevOpTool' not found");
        DevOpsTools.routeArtifacts("DevOpTool", path, string.concat(path, "/", fileName), false);
        assertTrue(DevOpsTools.vm.isDir(path), "Folders not created recursively");
        assertTrue(DevOpsTools.vm.isFile(string.concat(path, "/", fileName)), "artifacts.json file not created");
    }

    // If `recursive` is `true`, then all the parent folders are created on the fly.
    function testRouteArtifactsToDestination() public skipZkSync onlyVanillaFoundry {
        string memory path = "./folder/subfolder";
        string memory fileName = "artifacts.json";
        DevOpsTools.routeArtifacts("DevOpsTools", path, fileName, true);
        assertTrue(DevOpsTools.vm.isDir(path), "Folders not created recursively");
        assertTrue(DevOpsTools.vm.isFile(string.concat(path, "/", fileName)), "artifacts.json file not created");
    }

    /// forge-config: default.allow_internal_expect_revert = true
    function testCannotRouteArtifactsUsingEmptyString() public skipZkSync onlyVanillaFoundry {
        string memory path = "./folder/subfolder";
        string memory fileName = "artifacts.json";

        vm.expectRevert("Empty string is not allowed");
        DevOpsTools.routeArtifacts("", path, fileName, true);

        vm.expectRevert("Empty string is not allowed");
        DevOpsTools.routeArtifacts("DevOpsTools", "", fileName, true);

        vm.expectRevert("Empty string is not allowed");
        DevOpsTools.routeArtifacts("DevOpsTools", path, "", true);
    }

    function testRouteMultipleArtifacts() public skipZkSync onlyVanillaFoundry {
        DevOpsTools.routeArtifacts(contracts, paths, files, flags);

        for (uint256 i = 0; i < contracts.length; i++) {
            assertTrue(DevOpsTools.vm.isDir(paths[i]), "Folders not created recursively");
            assertTrue(DevOpsTools.vm.isFile(string.concat(paths[i], "/", files[i])), "File not created");
        }
    }

    /// forge-config: default.allow_internal_expect_revert = true
    function testCannotRouteWithEmptyArray() public skipZkSync onlyVanillaFoundry {
        vm.expectRevert("The length of the arrays cannot be zero");
        DevOpsTools.routeArtifacts(new string[](0), paths, files, flags);

        vm.expectRevert("The length of the arrays cannot be zero");
        DevOpsTools.routeArtifacts(contracts, new string[](0), files, flags);

        vm.expectRevert("The length of the arrays cannot be zero");
        DevOpsTools.routeArtifacts(contracts, paths, new string[](0), flags);

        vm.expectRevert("The length of the arrays cannot be zero");
        DevOpsTools.routeArtifacts(contracts, paths, files, new bool[](0));
    }

    /// forge-config: default.allow_internal_expect_revert = true
    function testCannotRouteWithArraysWithDiffLength() public skipZkSync onlyVanillaFoundry {
        contracts = ["DevOpsTools"];
        vm.expectRevert("Arrays length must match");
        DevOpsTools.routeArtifacts(contracts, paths, files, flags);
    }
}
