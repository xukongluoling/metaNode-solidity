// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MyToken {
    // 1.代币基础信息
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    // 2.状态变量
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // 3.所有者（用于权限控制）
    address public owner;

    // 4.事件
    // 4.1转账事件 
    event Transfer(address indexed from, address indexed to, uint256 value);
    // 4.2授权事件
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // 5.修饰符
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    // 7.构造函数
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ){
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        // 计算代币总量
        totalSupply = _initialSupply * 10**_decimals;

        // 合约部署者
        owner = msg.sender;
        // 总代币分配给部署者
        balanceOf[msg.sender] = totalSupply;
        // 触发事件（从零地址到部署者）
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    // 8.转账函数
    function transfer(address to, uint256 amount) public returns(bool) {
        // 1.检查地址
        require(to != address(0), "Cannot transfer to zero address");
        // 2.检查余额
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        // 3.更新余额
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;

        // 4.触发转账事件
        emit Transfer(msg.sender, to, amount);

        // 5.返回成功
        return true;
    }

    // 9.授权函数
    function approve(address spender, uint256 amount) public returns(bool) {
        // 1.检查地址
        require(spender != address(0), "Cannot approve zero address");
        // 2.设置授权额度
        allowance[msg.sender][spender] = amount;
        // 3.触发事件
        emit Approval(msg.sender, spender, amount);

        return true;
    }

    // 10.账号转账函数
    function transferFrom(address from, address to, uint256 amount)public returns(bool){
        // 1.检测地址
        require(from != address(0), "From zero address");
        require(to != address(0), "To zero address");

        // 2.检查余额
        require(balanceOf[from] >= amount, "Insufficient balance");
        // 3.检查授权额度
        require(allowance[from][msg.sender] >= amount);

        // 4.执行转账
        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        // 5.减少授权额度
        allowance[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);

        return true;
    }

    // 11.铸币函数
    function mint(address to, uint256 amount) public onlyOwner {
        // 1.检查地址
        require(to != address(0), "Cannot mint zero address");

        // 2.总供应量
        totalSupply += amount;

        // 3.增加接收者余额
        balanceOf[to] += amount;

        // 4.触发转账事件
        emit Transfer(address(0), to, amount);
    }

    // 12.销毁代币
    function burn(uint256 amount) public {
        // 1.检查余额
        require(balanceOf[msg.sender] >= amount, "Insufficient balance to burn");

        // 减少总供应
        totalSupply -= amount;
        // 减少调用者余额
        balanceOf[msg.sender] -= amount;

        emit Transfer(msg.sender, address(0), amount);
        
    }

}