// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "../src/DevOpsTools.sol";
import {Stuff} from "../src/mocks/Stuff.sol";

contract InteractWithStuff is Script {
    function run() external view {
        address mostRecent = DevOpsTools.get_most_recent_deployment("Stuff", block.chainid);
        uint256 value = Stuff(mostRecent).getSeven();
        assert(value == 7);
    }
}
