// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract NewStuff {
    function getSeven() public pure returns (uint256) {
        return 7;
    }
}

contract NewDeployStuff is Script {
    function run() external {
        vm.startBroadcast();
        new NewStuff();
        vm.stopBroadcast();
    }
}
