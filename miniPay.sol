// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MiniPay {
    struct User {
        bool registered;
        address walletAddress;
    }

    mapping(address => User) public users;
    mapping(address => uint256) public balances;
    address public admin;

    event UserRegistered(address indexed user, address walletAddress);
    event PaymentSent(address indexed from, address indexed to, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerUser() external {
        require(!users[msg.sender].registered, "User already registered");

        users[msg.sender] = User(true, msg.sender);

        emit UserRegistered(msg.sender, msg.sender);
    }

    function sendPayment(address _to, uint256 _amount) external {
        require(_amount > 0, "Payment amount must be greater than zero");
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;

        emit PaymentSent(msg.sender, _to, _amount);
    }

    function changeAdmin(address _newAdmin) external onlyAdmin {
        admin = _newAdmin;
    }
}
