// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Stuff} from "../src/mocks/Stuff.sol";

contract DeployStuff is Script {
    function run() external {
        vm.startBroadcast();
        new Stuff();
        vm.stopBroadcast();
    }
}
