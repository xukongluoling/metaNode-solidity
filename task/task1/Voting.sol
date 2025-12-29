// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
问题：users会随着用户量多而消耗更多gas
 */
contract Voting{
    mapping(address => uint256) private voteRecords;
    address[] public users;

    // 记录用户投票
    function vote(address _addr) public {
        // 没有投票用户记录数组
        if (voteRecords[_addr] == 0) {
            users.push(_addr);
        }
        voteRecords[_addr] += 1;
    }

    // 获取用户票数
    function getVotes(address _addr) public view returns(uint256) {
        return voteRecords[_addr];
    }
    // 重置所有用户票数
    function resetVotes() public {
        uint256 len = users.length;
        for (uint i = 0; i < len; i++) {
            voteRecords[users[i]] = 0;
        }
    }
}
// 优化投票
contract OptimizationVoting{
    // 使用嵌套数组，模拟多轮投票 0x00 : {1 : 2, 2 : 0}
    mapping(address => mapping(uint256 => uint256)) private voteRecords;
    uint256 private currentEpoch = 1;

    // 记录用户投票
    function vote() public {
        voteRecords[msg.sender][currentEpoch] += 1; 
    }

    // 获取用户票数
    function getVotes(address _addr) public view returns(uint256) {
        return voteRecords[_addr][currentEpoch];
    }
    // 重置所有用户票数
    function resetVotes() public {
        currentEpoch += 1;
    }
}