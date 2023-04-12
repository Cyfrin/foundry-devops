// SPDX-License-Identifier: MIT

pragma solidity >=0.8.13 <0.9.0;

import {Vm} from "forge-std/Vm.sol";

library DevOpsTools {
    Vm public constant vm =
        Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

    function get_most_recent_deployment(
        string memory contractName,
        uint256 chainId,
        string memory path
    ) public returns (address) {
        string[] memory getRecentDeployment = new string[](5);

        getRecentDeployment[0] = "bash";
        getRecentDeployment[1] = "./src/get_recent_deployment.sh";
        getRecentDeployment[2] = contractName;
        getRecentDeployment[3] = uint2str(chainId);
        getRecentDeployment[4] = path;

        bytes memory retData = vm.ffi(getRecentDeployment);
        address returnedAddress = address(uint160(bytes20(retData)));
        if (returnedAddress != address(0)) {
            return returnedAddress;
        } else {
            revert("No contract deployed");
        }
    }

    function uint2str(
        uint _i
    ) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
