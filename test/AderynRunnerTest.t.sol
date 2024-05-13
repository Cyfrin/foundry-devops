// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Test} from "forge-std/Test.sol";
import "../src/AderynRunnerTool.sol";
import {console} from "forge-std/console.sol";

contract AderynRunnerTest is Test {
    function setUp() public {
        // Path to aderyn executable in your local computer
        string memory ADERYN_PATH = "aderyn";

        // Test if markdown creation works
        AderynRunnerTool.run_with(ADERYN_PATH, "./reports/my_report.md");

        // Test if json output works
        AderynRunnerTool.run_with(ADERYN_PATH, "./reports/my_report.json");
    }

    // forge-config: default.ffi = true
    function testAderynThereAreNoCriticalErrors() public view {
        IssueCount memory ic = AderynRunnerTool.get_issue_count("./reports/my_report.json");
        assert(ic.high == 0);
    }

    // forge-config: default.ffi = true
    function testAderynThereAreLessThan10MediumOrLessSevereErrors() public view {
        IssueCount memory ic = AderynRunnerTool.get_issue_count("./reports/my_report.json");
        assert(ic.low < 10);
    }
}
