// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Test} from "forge-std/Test.sol";
import {DevOpsTools} from "../src/DevOpsTools.sol";

contract DevOpsToolsTest is Test {
    address public constant EXPECTED_ADDRESS =
        0xa513E6E4b8f2a923D98304ec87F64353C4D5C853;
    string public constant CONTRACT_NAME = "Stuff";
    uint256 public constant CHAIN_ID = 31337;
    string public constant SEARCH_PATH = "broadcast";
    string public constant SCRIPT_PATH = "./src/get_recent_deployment.sh";

    function testGetMostRecentlyDeployedContract() public {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment(
            CONTRACT_NAME,
            CHAIN_ID,
            SEARCH_PATH,
            SCRIPT_PATH
        );
        assertEq(mostRecentDeployment, EXPECTED_ADDRESS);
    }

    function testGetMostRecentlyDeployedEvenWhenMultipleAreDeployed() public {
        string memory contractName = "FundMe";
        uint256 chainId = 1234;
        address expectedAddress = 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9;
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment(
            contractName,
            chainId,
            SEARCH_PATH,
            SCRIPT_PATH
        );
        assertEq(mostRecentDeployment, expectedAddress);
    }
}
