// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// handle token approval notifications
interface tokenRecipient {
    function receiveApproval(
        address _from,
        uint256 _value,
        address _token,
        bytes calldata _extraData // The extra data to send to the recipient
    ) external; // designed to be called by another contract
}

contract ManualToken {
    string public name;
    string public symbol;
    uint8 public constant decimals = 18; // Standard token decimal places
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance; // track the amount of tokens that one address (_owner) allows another address (_spender) to spend on its behalf.

    event Transfer(address indexed from, address indexed to, uint256 value); // Parameters marked as indexed can be used as filters when querying logs. For example, you can search for all Transfer events involving a specific from or to address.
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed from, uint256 value); // burning allows users to reduce the circulating supply of tokens either from their own balance (burn) or from another account with permission (burnFrom). This feature provides flexibility and aligns with various use cases, such as deflationary tokenomics or ecosystem management.

    constructor(
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol // The memory keyword is used in Solidity to specify the data location for variables that are only needed temporarily during function execution
    ) {
        totalSupply = initialSupply * 10 ** uint256(decimals); // Most tokens, including ERC-20 tokens, use decimals to allow fractional amounts. For example, if a token has 18 decimals, 1 token is represented as 1 * 10^18 smallest units (like "wei" in Ether). The initialSupply provided during contract deployment is typically specified in whole tokens (e.g., 1000 tokens).To represent this in the smallest units, it is multiplied by 10 ** decimals. For 18 decimals, this means multiplying by 10^18
        balanceOf[msg.sender] = totalSupply;
        name = tokenName;
        symbol = tokenSymbol;
    }

    // This logic is reused in both the transfer and transferFrom functions
    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_from != address(0), "Invalid from address");
        require(_to != address(0), "Invalid to address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(balanceOf[_to] + _value > balanceOf[_to], "Overflow error");

        uint256 previousBalance = balanceOf[_from] + balanceOf[_to];

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);

        assert(balanceOf[_from] + balanceOf[_to] == previousBalance); // Ensure that the total balance remains consistent after the transfer
    }

    function transfer(address _to, uint256 _value) external returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
        require(_value <= allowance[_from][msg.sender], "Allowance exceeded"); // ensures that the caller (the msg.sender) does not transfer more tokens than they are authorized to spend on behalf of the _from address.
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "Invalid spender address");
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function approveAndNotify(address _spender, uint256 _value, bytes calldata _extraData)
        external
        returns (bool success)
    {
        if (approve(_spender, _value)) {
            // calling the interface function to notify the spender
            tokenRecipient(_spender).receiveApproval(msg.sender, _value, address(this), _extraData);
            return true;
        }
        return false;
    }

    function burn(uint256 _value) external returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance to burn");
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        emit Burn(msg.sender, _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value) external returns (bool success) {
        require(balanceOf[_from] >= _value, "Insufficient balance to burn");
        require(_value <= allowance[_from][msg.sender], "Allowance exceeded");

        balanceOf[_from] -= _value;
        totalSupply -= _value;
        allowance[_from][msg.sender] -= _value;

        emit Burn(_from, _value);
        return true;
    }
}
