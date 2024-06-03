// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console2} from "forge-std/Test.sol";
import {FoundryZkSyncChecker} from "src/FoundryZkSyncChecker.sol";
import {StringUtils} from "src/StringUtils.sol";

contract FoundryZkSyncCheckerTest is Test, FoundryZkSyncChecker {
    using StringUtils for string;

    string public constant RELATIVE_SCRIPT_PATH = "test/is_foundry_zksync.sh";

    function setUp() public {}

    function testVersion() public {
        bool isZkFoundryBashScript = is_foundry_zksync_bash_script();
        bool isZkFoundryChecker = is_foundry_zksync();
        assertEq(isZkFoundryBashScript, isZkFoundryChecker);
    }

    /*//////////////////////////////////////////////////////////////
                                 HELPER
    //////////////////////////////////////////////////////////////*/
    function is_foundry_zksync_bash_script() public returns (bool) {
        string[] memory command = new string[](2);
        command[0] = "bash";
        command[1] = RELATIVE_SCRIPT_PATH;
        bytes memory retData = vm.ffi(command);
        bool isFoundryZkSync = uint256(bytes32(retData)) > 0;
        return isFoundryZkSync;
    }
}
