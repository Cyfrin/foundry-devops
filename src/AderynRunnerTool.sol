// SPDX-License-Identifier: MIT

pragma solidity >=0.8.13 <0.9.0;

import {Vm} from "forge-std/Vm.sol";
import {console} from "forge-std/console.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console} from "forge-std/console.sol";


struct IssueCount {
    int256 critical;
    int256 high;
    int256 medium;
    int256 low;
    int256 nc;
}

library AderynRunnerTool {

    using stdJson for string;

    Vm public constant vm = Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

    string public constant RELATIVE_ADERYN_PATH = "aderyn";

    function run_with(string memory path, string memory output) public {
        string[] memory inputs = new string[](4);
        inputs[0] = path;
        inputs[1] = ".";
        inputs[2] = "-o";
        inputs[3] = output;
        vm.ffi(inputs);
    }

    function run_with_defaults() public {
        run_with(RELATIVE_ADERYN_PATH, "report.md");
    }

    function get_issue_count(string memory filePath) public view returns (IssueCount memory) {
        string memory json = vm.readFile(filePath);
        int256 critical = json.readInt("$.issue_count.critical");
        int256 high = json.readInt("$.issue_count.high");
        int256 medium = json.readInt("$.issue_count.medium");
        int256 low = json.readInt("$.issue_count.low");
        int256 nc = json.readInt("$.issue_count.nc");
        return IssueCount({
            critical: critical, 
            high: high,
            medium: medium, 
            low: low, 
            nc:nc
        });
    }

}