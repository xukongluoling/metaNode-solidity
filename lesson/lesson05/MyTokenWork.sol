// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MyTokenWork {
    string private name;
    string private symbol;
    uint8 constant private decimals = 18;
    bool private paused = false;
    uint256 private totalSupply;

    mapping(address => uint256) public balanceMp;
    mapping(address => mapping(address => uint256)) public allowance;

    address owner;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed from, address indexed spender, uint256 amount);

    modifier onlyOwner {
        require(msg.sender == owner, "only owner execute");
        _;
    }

    modifier whenNotPaused {
        require(!paused, "Contract is paused");
        _;
    }

    function pause() public onlyOwner {
    paused = true;
    }

    function unpause() public onlyOwner {
        paused = false;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply
    ){
        name = _name;
        symbol = _symbol;
        totalSupply = _initialSupply * 10**decimals;

        owner = msg.sender;
        balanceMp[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address to, uint256 amount) public whenNotPaused returns(bool) {
        checkAddress(to, "To transfer zero addrees");
        checkBalance(balanceMp[msg.sender], amount, "Insufficient balance");

        balanceMp[msg.sender] -= amount;
        balanceMp[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approval(address spender, uint256 amount) public whenNotPaused returns(bool){
        
        checkAddress(spender, "Approval spender addrees is zero");

        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, 0);
        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public whenNotPaused returns(bool) {
        checkAddress(from, "From transfer addrees is zero");
        checkAddress(to, "To transfer addrees is zero");
        checkBalance(balanceMp[from], amount, "Insufficient balance");
        checkBalance(allowance[from][msg.sender], amount, "Insufficient allowance");

        balanceMp[from] -= amount;
        balanceMp[to] += amount;

        allowance[from][msg.sender] -= amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function batchTransfer(address[] memory addArr, uint256[] memory amountArr) public returns(bool) {
        // 1.判断是否为空 2.是否超过长度 3.判断长度是否一致
        checkBatch(addArr, amountArr);
        
        // 检查余额是否够
        uint256 totalAmount = sumAmountArray(amountArr);
        require(balanceMp[msg.sender] >= totalAmount, "Insufficient balance");
        
        uint256 len = addArr.length;
        for (uint i = 0; i < len; i++) {
            checkAddress(addArr[i], "Invalid address");
            require(amountArr[i] > 0, "Invalid amount");
        }
        for (uint i = 0; i < len; i++) {
            uint amount = amountArr[i];
            balanceMp[msg.sender] -= amount;
            
            balanceMp[addArr[i]] += amountArr[i];
            
            emit Transfer(msg.sender, addArr[i], amountArr[i]);
        }
        return true;

    }

    function checkBatch(address[] memory _addArr, uint256[] memory _amountArr) private pure {
        uint256 addLen = _addArr.length;
        uint256 amountLen = _amountArr.length;
        require(0 < addLen && addLen <= 10, "_addArr not empty or exceed ten");
        require(0 < amountLen && amountLen <= 10, "_amountArr not empty or exceed ten");
        require(addLen == amountLen, "_addArr legth and _amountArr legth mismatch");
    }

    function sumAmountArray(uint256[] memory _amountArr) private pure returns(uint256) {
        uint256 total = 0;
        uint256 len = _amountArr.length;
        for(uint i = 0; i < len; i++) {
            total += _amountArr[i];
        }
        return total;
    }

    function mint(address to, uint256 amount) public onlyOwner returns(bool) {
        checkAddress(to, "Mint to addrees is zero");

        totalSupply += amount;
        balanceMp[to] += amount;
        
        emit Transfer(address(0), to, amount);
        return true;
    }

    function burn(uint256 amount) public returns(bool) {
        checkBalance(balanceMp[msg.sender], amount, "Insufficient balance to burn");
        
        totalSupply -= amount;
        balanceMp[msg.sender] -= amount;

        emit Transfer(msg.sender, address(0), amount);
        return true;
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