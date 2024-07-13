// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {

    // Getters
    function totalSupply() external view returns(uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    // Functions
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract DIOToken is IERC20 {

    string public constant name = "DIO Token";
    string public constant symbol = "DIO";
    uint8 public constant decimals = 18;

    mapping (address => uint256) private balances;
    mapping (address => mapping (address => uint256)) private allowed;
    uint256 private totalSupply_;

    constructor(uint256 initialSupply) {
        totalSupply_ = initialSupply;
        balances[msg.sender] = initialSupply;
        emit Transfer(address(0), msg.sender, initialSupply);
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address account) public override view returns (uint256) {
        return balances[account];
    }

    function allowance(address owner, address spender) public override view returns (uint256) {
        return allowed[owner][spender];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(recipient != address(0), "Transfer to the zero address");
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(recipient != address(0), "Transfer to the zero address");
        require(amount <= balances[sender], "Insufficient balance");
        require(amount <= allowed[sender][msg.sender], "Allowance exceeded");

        balances[sender] -= amount;
        allowed[sender][msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}
