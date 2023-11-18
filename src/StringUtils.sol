// SPDX-License-Identifier: MIT

pragma solidity >=0.8.13 <0.9.0;

library StringUtils {
    function isEqualTo(
        string memory str1,
        string memory str2
    ) internal pure returns (bool) {
        return
            keccak256(abi.encodePacked(str1)) ==
            keccak256(abi.encodePacked(str2));
    }

    function contains(
        string memory str,
        string memory substr
    ) internal pure returns (bool) {
        bytes memory strBytes = bytes(str);
        bytes memory substrBytes = bytes(substr);
        if (strBytes.length < substrBytes.length || strBytes.length == 0)
            return false;

        for (uint i = 0; i <= strBytes.length - substrBytes.length; i++) {
            bool isEqual = true;
            for (uint j = 0; j < substrBytes.length; j++) {
                if (strBytes[i + j] != substrBytes[j]) {
                    isEqual = false;
                    break;
                }
            }
            if (isEqual) return true;
        }
        return false;
    }
}
