// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TypeOperations {
    function ReverseString(string memory str) public pure returns(string memory) {
        bytes memory byStr = bytes(str);
        bytes memory reverByte = new bytes(byStr.length);
        
        for (uint i = 0; i < byStr.length; i++) {
            reverByte[i] = byStr[byStr.length - 1 - i];
        }
        return string(reverByte);
    }

    // 数字转罗马字符
    function numConvertRome(uint256 _num) public pure returns(string memory){
        // 定义罗马数字映射表（从大到小）
        string[13] memory romanSymbols = [
            "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"
        ];
        
        uint16[13] memory values = [
            1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1
        ];

        bytes memory result = new bytes(0);
        for(uint i = 0; i < 13; i++) {
            while(_num >= values[i]) {
                _num -= values[i];
                result = bytes.concat(result, bytes(romanSymbols[i]));
            }
        }
        return string(result);
    }

    // 罗马字符转数字
    function romanToInt(string memory str) public pure returns(uint256) {
        bytes memory byStr = bytes(str);
        
        uint256 total = 0;
        uint256 preValue = 0;
        for(uint256 i = byStr.length; i > 0; i--) {
            uint256 index = i - 1;
            uint256 value = charToValue(byStr[index]);
            if (preValue > value) {
                total -= value;
            }else {
                total += value;
            }
            preValue = value;
        }
        return total;

    }
    // 罗马字符转数字
    function romeConvertNum(string memory str) public pure returns(uint256) {
        bytes memory bStr = bytes(str);
        // for (uint i = 0; i < bStr.length; i++) {
        //     if (bStr[i] >= 0x61 && bStr[i] <= 0x7A) { // 小写字母范围
        //         bStr[i] = bytes1(uint8(bStr[i]) - 32); // 转换为大写
        //     }
        // }
        uint256 total = 0;
        uint256 preValue = 0;
        for(uint i = bStr.length - 1; i >=0; i--){
            
            uint256 value = charToValue(bStr[i]);
            if (value < preValue) {
                total -= value;
            }else {
               total += value; 
            }
            preValue = value;
        }
        return total;
    }
    // 罗马字符转数字 字符转数值
    function charToValue(bytes1 b)internal pure returns (uint256) {
        // 优化：直接比较字节，无需转换为 string，更高效且省Gas。
        if (b == 0x49) return 1; // "I"
        if (b == 0x56) return 5; // "V"
        if (b == 0x58) return 10; // "X"
        if (b == 0x4C) return 50; // "L"
        if (b == 0x43) return 100; // "C"
        if (b == 0x44) return 500; // "D"
        if (b == 0x4D) return 1000; // "M"
        revert("Invalid Roman numeral character");
    }
    // 罗马字符转数字 字符判断
    function compareStrings(
        string memory a,
        string memory b
    ) internal  pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }

    // 合并两个有序数组
    function mergeAddr(uint256[] memory addr1, uint256[] memory addr2)public pure returns(uint256[] memory) {
        // 判断两组的长度
        uint256 le1 = addr1.length;
        uint256 le2 = addr2.length;
        
        uint i = 0;
        uint j = 0;
        uint index = 0;
        uint256[] memory results = new uint256[](le1 + le2);
        while (i < le1 && j < le2) {
            if (addr1[i] <= addr2[j]) {
                results[index] = addr1[i];
                i++;
            }else {
                results[index] = addr2[j];
                j++;
            }
            index++;
        }
        
        while (i < le1) {
            results[index] = addr1[i];
            i++;
            index++;
        }
                
        
        while(j < le2){
            results[index] = addr2[j];
            j++;
            index++;
        }
        return results;
    }

    function searchAddr(uint256[] memory addr, uint256 target) public pure returns(int256) {
        if (addr.length == 0) {
            return -1;
        }

        uint256 left = 0;
        uint256 right = addr.length - 1;

        while (left <= right) {
            uint256 mid = left + (right - left) / 2;
            if (addr[mid] == target) {
                return int256(mid);
            }else if(addr[mid] < target) {
                // 小于中间值在右区
                left = mid + 1;
            }else {
                if (mid == 0) {
                    break ;
                }
                // 大于中间值在左区
                right = mid - 1;
            }
        }
        return -1;
    }

}