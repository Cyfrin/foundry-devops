// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Test} from "forge-std/Test.sol";
import "../src/AderynRunnerTool.sol";
import {console} from "forge-std/console.sol";

contract AderynRunnerTest is Test {
    
    function testAderynRunnerDefaultWorks() public {
        AderynRunnerTool.run_with_defaults();
    }

    function testAderynRunnerCustomWorks() public {
        AderynRunnerTool.run_with("../aderyn/target/release/aderyn", "my_report.md", "./reports/my_report.json");
    }

    function testThereAreNoCriticalErrors() public view {
        IssueCount memory ic = AderynRunnerTool.get_issue_count("./reports/my_report.json");
        assert(ic.critical == 0);
        assert(ic.high == 0);
    }

    function testThereAreLessThan10MediumOrLessSevereErrors() public view {
        IssueCount memory ic = AderynRunnerTool.get_issue_count("./reports/my_report.json");
        assert(ic.medium < 10);
        assert(ic.low < 10);
        assert(ic.nc < 10);
    }

}