// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {DeployStuff} from "./DeployStuff.s.sol";
import {DevOpsTools} from "../src/DevOpsTools.sol";
import {Stuff} from "../src/mocks/Stuff.sol";

contract RouteStuffArtifacts is Script {
    function run() external {
        new DeployStuff().run();
        DevOpsTools.routeArtifacts("Stuff", "./folder", "StuffArtifacts.json", true);
        address mostRecent = DevOpsTools.get_most_recent_deployment("Stuff", block.chainid);
        uint256 value = Stuff(mostRecent).getSeven();
        assert(value == 7);
    }
}
