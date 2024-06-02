// SPDX-License-Identifier: MIt
pragma solidity ^0.8.18;

import {ZkSyncChainChecker} from "src/ZkSyncChainChecker.sol";
import {FoundryZkSyncChecker} from "src/FoundryZkSyncChecker.sol";
import {Test, console2} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";

contract Checker is ZkSyncChainChecker {}

contract ZkSyncChainCheckerTest is Test, FoundryZkSyncChecker {
    uint256 mainnetForkId;
    Checker checkerMainnet;

    uint256 zkSyncForkId;
    Checker checkerZkSync;

    uint256 AMOUNT = 1e18;

    function setUp() public onlyVanillaFoundry {
        vm.createSelectFork("mainnet");
        mainnetForkId = vm.activeFork();
        checkerMainnet = new Checker();
        vm.deal(address(checkerMainnet), AMOUNT);

        vm.createSelectFork("zksync");
        zkSyncForkId = vm.activeFork();
        checkerZkSync = new Checker();
        vm.deal(address(checkerZkSync), AMOUNT);
    }

    /*//////////////////////////////////////////////////////////////
                               BY CHAINID
    //////////////////////////////////////////////////////////////*/
    function testIsOnZkSyncChainByChainId_mainnet() public onlyVanillaFoundry {
        vm.selectFork(mainnetForkId);
        assertEq(checkerMainnet.isOnZkSyncChainId(), false);
    }

    function testIsOnZkSyncChainByChainId_zksync() public onlyVanillaFoundry {
        vm.selectFork(zkSyncForkId);
        assertEq(checkerZkSync.isOnZkSyncChainId(), true);
    }

    /*//////////////////////////////////////////////////////////////
                             BY PRECOMPILES
    //////////////////////////////////////////////////////////////*/
    // In the future I expect these tests to work, but right now, forking is broken
    // on foundry-zksync
    // function testIsOnZkSyncByPrecompiles_mainnet() public onlyFoundryZkSync {
    //     vm.selectFork(mainnetForkId);
    //     assertEq(checkerMainnet.isOnZkSyncPrecompiles(), false);
    // }

    // function testIsOnZkSyncByPrecompiles_zksync() public onlyFoundryZkSync {
    //     vm.selectFork(zkSyncForkId);
    //     assertEq(checkerZkSync.isOnZkSyncPrecompiles(), true);
    // }
}
