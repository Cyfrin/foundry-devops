// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Test} from "forge-std/Test.sol";
import {AderynRunnerTool} from "../src/AderynRunnerTool.sol";

contract AderynRunnerTest is Test {
    
    function testAderynRunnerDefaultWorks() public {
        AderynRunnerTool.run_with_defaults();
    }

    function testAderynRunnerCustomWorks() public {
        AderynRunnerTool.run_with("../aderyn/target/release/aderyn", "my_report.md");
    }

}