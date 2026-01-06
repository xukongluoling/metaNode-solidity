// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OptimizedCode{
    uint[] public data;
    
    function process(uint[] memory values) public {
        
        for(uint i = 0; i < values.length; i++) {
            if(values[i] > 10) {
                data.push(values[i]);
            }
        }
    }

    function optimizedProcess(uint[] calldata values) public {
        uint len = values.length;

        uint[] memory temp = new uint[](len);
        uint count = 0;
        
        for(uint i = 0; i < len; i++) {
            if(values[i] > 10) {
                temp[count] = values[i];
                count++;
            }
        }

        for (uint i = 0; i < count; i++) {
            data.push(temp[i]);
        }
    }

    function optimizedProcessV2(uint[] calldata values) public {
        
        uint[] memory temp = new uint[]( values.length);
        
        for(uint i = 0; i < values.length; i++) {
            if(values[i] > 10) {
                temp[i] = values[i];
            }
        }
        for(uint i = 0; i < temp.length; i++) {
            if(values[i] > 10) {
                data.push(temp[i]);
            }
        }
    }
}