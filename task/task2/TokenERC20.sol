// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TokenERC20{
    string private name = "MyToken";
    string private symbol = "MTK";
    uint8 constant private decimals = 18;
    uint256 private totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed from, address indexed spender, uint256 amount);

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * 10 ** decimals;
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    // 转账
    function transfer(address to, uint256 amount) public returns(bool) {
        checkAddress(to, "TO zero address");
        checkBalance(balanceOf[msg.sender], amount, "Insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // 授权
    function approval(address spender, uint256 amount) public returns(bool){
        checkAddress(spender, "Spender zero address");

        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns(bool) {
        checkAddress(from, "From zero address");
        checkAddress(to, "To zero address");

        checkBalance(balanceOf[from], amount, "Insufficient balance");
        checkBalance(allowance[from][msg.sender], amount, "Insufficient allownace");

        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        allowance[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }

    // 铸币
    function mint(address to, uint256 amount) public onlyOwner {
        checkAddress(to, "Mint to zero address");

        totalSupply += amount;
        balanceOf[to] += amount;

        emit Transfer(address(0), to, amount);
    }

    // 销毁
    function burn(uint256 amount) public  {
        checkBalance(balanceOf[msg.sender], amount, "Insufficient burn balance");

        totalSupply -= amount;
        balanceOf[msg.sender] -= amount;

        emit Transfer(msg.sender, address(0), amount);
    } 

    // 检查地址
    function checkAddress(address _addr, string memory _str) private pure {
        require(_addr != address(0), _str);
    }

    // 检查余额
    function checkBalance(uint256 balance, uint256 amount, string memory _str) private pure {
        require(balance >= amount, _str);
    }


}