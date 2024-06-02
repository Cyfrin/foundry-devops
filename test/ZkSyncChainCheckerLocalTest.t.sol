// SPDX-License-Identifier: MIt
pragma solidity ^0.8.18;

import {ZkSyncChainChecker} from "src/ZkSyncChainChecker.sol";
import {FoundryZkSyncChecker} from "src/FoundryZkSyncChecker.sol";
import {Test, console2} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";

contract Checker is ZkSyncChainChecker {}

/**
 * @title ZkSyncChainCheckerLocalTest
 * @author Patrick Collins
 * @notice We need to test the local zkSync edition separately, because we cannot do
 * vm.selectFork on foundry-zksync
 */
contract ZkSyncChainCheckerLocalTest is Test, FoundryZkSyncChecker {
    Checker checkerLocal;
    uint256 AMOUNT = 1e18;

    function setUp() public {
        checkerLocal = new Checker();
        vm.deal(address(checkerLocal), AMOUNT);
    }

    /*//////////////////////////////////////////////////////////////
                               BY CHAINID
    //////////////////////////////////////////////////////////////*/
    function testIsOnZkSyncChainByChainId_local() public onlyVanillaFoundry {
        assertEq(checkerLocal.isOnZkSyncChainId(), false);
    }

    /*//////////////////////////////////////////////////////////////
                             BY PRECOMPILES
    //////////////////////////////////////////////////////////////*/
    function testIsOnZkSyncByPrecompiles_local() public onlyFoundryZkSync {
        assertEq(checkerLocal.isOnZkSyncPrecompiles(), true);
    }
}
