// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BeggingContract is Ownable {

    // 记录捐赠者及捐赠金额
    mapping(address => uint256) private _donations;

    event Donated(address indexed donor, uint256 indexed amount, uint256 totalAmount);
    event Withdrawed(address indexed _owner, uint256 indexed amount);

    constructor() Ownable(msg.sender) {}

    /**
     * @dev donate 转以太币捐赠
     */
    function donate() external payable {
        // 判断调用地址不为0
        require(msg.sender != address(0), "Invalid address");
        
        // 记录捐赠金额
        _donations[msg.sender] += msg.value;
        // 触发捐赠金额
        emit Donated(msg.sender, msg.value, _donations[msg.sender]);
    }

    function withdraw() public onlyOwner payable {
        uint256 balance = address(this).balance;
        // 查看合约balance
        require(balance > 0, "balance is 0");

        payable(owner()).transfer(balance);
        emit Withdrawed(msg.sender, balance);
    }
}