// SPDX-License-Identifier: MIT

pragma solidity >=0.8.13 <0.9.0;

import {Vm} from "forge-std/Vm.sol";
import {console} from "forge-std/console.sol";


library AderynRunnerTool {

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

}