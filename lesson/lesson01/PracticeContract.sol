// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PracticeContract{
    address immutable private ADMIN;
    uint256 constant private MULTIPLIER = 2;
    uint256[] private numbers;

    constructor() {
        ADMIN = msg.sender;
    }
    function batchProcess(
        uint256[] calldata inputs
    ) external {
        require(msg.sender == ADMIN);
    
        for (uint i = 0; i < inputs.length; i++) {
            uint256 result = inputs[i] * MULTIPLIER;
            numbers.push(result);
        }
    }

    function getSum() external view returns (uint256) {
        require(msg.sender == ADMIN);
        
        uint256 sum = 0;
        uint256 len = numbers.length;
        for (uint i = 0; i < len; i++) {
            sum += numbers[i];
        }
        return sum;
    }
}

// 需要优化合约
// contract PracticeContract {
//     uint256[] public numbers;
//     address public admin;
//     uint256 public multiplier = 2;
    
//     function batchProcess(
//         uint256[] memory inputs
//     ) external {
//         require(msg.sender == admin);
        
//         for (uint i = 0; i < inputs.length; i++) {
//             uint256 result = inputs[i] * multiplier;
//             numbers.push(result);
//         }
//     }
    
//     function getSum() external view returns (uint256) {
//         require(msg.sender == admin);
        
//         uint256 sum = 0;
//         for (uint i = 0; i < numbers.length; i++) {
//             sum += numbers[i];
//         }
//         return sum;
//     }
// }