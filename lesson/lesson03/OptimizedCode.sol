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
        for(uint i = 0; i < len; i++) {
            if(values[i] > 10) {
                data.push(values[i]);
            }
        }
    }
}