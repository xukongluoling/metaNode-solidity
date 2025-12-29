// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RomanConverter {
    function romanToInt(string calldata str) public pure returns(uint256) {
        bytes memory cleanStr = cleanString(bytes(str));
        uint256 total = 0;
        uint256 preValue = 0;
        for(uint256 i = cleanStr.length - 1; i >= 0; i--) {
            uint256 value = charToValue(cleanStr[i]);
            if (preValue > value) {
                total -= value;
            } else {
                total += value;
            }
            preValue = value;
        }
        return total;
    }

    function cleanString(bytes memory b) internal pure returns (bytes memory) {
        bytes memory clean = new bytes(b.length);
        uint256 index = 0;
        for (uint256 i = 0; i < b.length; i++) {
            bytes1 c = b[i];
            if (isValidRomanChar(c)) {
                clean[index] = c;
                index++;
            }
        }
        // 重新切片，移除尾部无效字符
        return clean;
    }

    function isValidRomanChar(bytes1 c) internal pure returns (bool) {
        // ASCII: I=73, V=86, X=88, L=76, C=67, D=68, M=77
        return c == 0x49 || c == 0x56 || c == 0x58 || c == 0x4C || 
               c == 0x43 || c == 0x44 || c == 0x4D;
    }

    function charToValue(bytes1 b) internal pure returns (uint256) {
        if (b == 0x49) return 1;  // I
        if (b == 0x56) return 5;  // V
        if (b == 0x58) return 10; // X
        if (b == 0x4C) return 50; // L
        if (b == 0x43) return 100; // C
        if (b == 0x44) return 500; // D
        if (b == 0x4D) return 1000; // M
        revert("Invalid Roman numeral character");
    }
}