// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    // 1.定义枚举
    enum Vote{Yes, No, Abstain}

    // 2.状态变量
    uint private yesCount;
    uint private noCount;
    uint private abstainCount;
    mapping (address => Vote) private votes;
    mapping (address => bool) private hasVoted;

    event Voted(address indexed voter, Vote vote);

    // 3.投票
    function vote(Vote _vote) public {
        // 判断该用户是否已投过票
        require(!hasVoted[msg.sender], "already vote");
        // 记录用户投的票
        votes[msg.sender] = _vote;
        // 标记用户已投票
        hasVoted[msg.sender] = true;
        // 更新票数
        if (Vote.Yes == _vote) {
            yesCount++;
        }else if (Vote.No == _vote) {
            noCount++;
        }else if (Vote.Abstain == _vote) {
            abstainCount++;
        }

        emit Voted(msg.sender, _vote);
    }

    // 4.查询票数
    function getResults() public view returns(uint, uint, uint) {
        return (yesCount, noCount, abstainCount);
    }

    // 5.查看用户投的票类型
    function getMyVote() public view returns(Vote) {
        // 判断已投过票
        require(hasVoted[msg.sender], "You haven't voted");
        return votes[msg.sender];
    }
}