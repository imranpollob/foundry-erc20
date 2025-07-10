// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ManualToken {
    mapping(address => uint256) private s_balances;

    // Our name function could also be represented by a public declaration such as string public name = "ManualToken";. This is because Solidity creates public getter functions when compiled for any publicly accessible storage variables!
    function name() public pure returns (string memory) {
        return "ManualToken";
    }

    function totalSupply() public pure returns (uint256) {
        return 100 ether; // 100,000,000,000,000,000,000 wei
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }

    function transfer(address _to, uint256 _amount) public {
        // This line captures the sum of the sender’s and receiver’s balances before the transfer. It’s a basic integrity check used later to confirm that no tokens were accidentally minted or lost.
        uint256 previousBalance = balanceOf(msg.sender) + balanceOf(_to);
        s_balances[msg.sender] -= _amount;
        s_balances[_to] += _amount;

        require(balanceOf(msg.sender) + balanceOf(_to) == previousBalance, "Transfer failed: balance mismatch");
    }
}
