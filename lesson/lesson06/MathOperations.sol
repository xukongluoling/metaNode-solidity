// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library MathOperations {
    
    function add(uint256 a, uint256 b) internal pure returns(uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b <= a, "Subtraction underflow");
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns(uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "Multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns(uint256) {
        if (a == 0) return 0;
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    } 
}

contract MyContractTradition {

    function _add(uint256 a, uint256 b) public pure returns(uint256) {
        return MathOperations.add(a, b);
    }
}

contract MyContractUsing {

    using MathOperations for uint256;

    function _add(uint256 a, uint256 b) public pure returns(uint256) {
        return a.add(b);
    }
}