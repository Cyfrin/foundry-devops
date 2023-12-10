// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Test} from "forge-std/Test.sol";
import "../src/AderynRunnerTool.sol";
import {console} from "forge-std/console.sol";

contract AderynRunnerTest is Test {
    
    function setUp() public {

        // Path to aderyn executable in your local computer
        string memory ADERYN_PATH = "../aderyn/target/release/aderyn";

        // Test if markdown creation works
        AderynRunnerTool.run_with(ADERYN_PATH, "./reports/my_report.md");
        
        // Test if json output works
        AderynRunnerTool.run_with(ADERYN_PATH, "./reports/my_report.json");
    }

    // function testDefaultsAderynRunnerWorks() public {
    //     AderynRunnerTool.run_with_defaults();
    // }

    function testAderynThereAreNoCriticalErrors() public view {
        IssueCount memory ic = AderynRunnerTool.get_issue_count("./reports/my_report.json");
        assert(ic.critical == 0);
        assert(ic.high == 0);
    }

    function testAderynThereAreLessThan10MediumOrLessSevereErrors() public view {
        IssueCount memory ic = AderynRunnerTool.get_issue_count("./reports/my_report.json");
        assert(ic.medium < 10);
        assert(ic.low < 10);
        assert(ic.nc < 10);
    }

}