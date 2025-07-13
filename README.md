## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.


## Package installation
```bash
forge install OpenZeppelin/openzeppelin-contracts
```

Update `foundry.toml` file
```js
remappings = ["@openzeppelin=lib/openzeppelin-contracts"]
```

## Description of the files


### ManualToken.sol
The file `ManualToken.sol` defines a smart contract for an ERC-20-like token with additional functionalities. Here's an overview:

### Key Components:
1. **Interface: `tokenRecipient`**
   - Defines a function `receiveApproval` for contracts to handle token approval notifications.

2. **Public Variables:**
   - `name`: Name of the token.
   - `symbol`: Symbol of the token.
   - `decimals`: Number of decimal places (default is 18).
   - `totalSupply`: Total supply of the token.
   - `balanceOf`: Mapping to track balances of addresses.
   - `allowance`: Mapping to track allowances for token transfers.

3. **Events:**
   - `Transfer`: Emitted when tokens are transferred.
   - `Approval`: Emitted when an allowance is set.
   - `Burn`: Emitted when tokens are burned.

4. **Constructor:**
   - Initializes the token with a specified supply, name, and symbol.
   - Assigns the total supply to the contract creator.

5. **Functions:**
   - `_transfer`: Internal function to handle token transfers.
   - `transfer`: Transfers tokens from the caller's account.
   - `transferFrom`: Transfers tokens on behalf of another address.
   - `approve`: Sets an allowance for another address.
   - `approveAndCall`: Sets an allowance and notifies the recipient contract.
   - `burn`: Burns tokens from the caller's account.
   - `burnFrom`: Burns tokens from another account, using an allowance.

### Features:
- Implements basic ERC-20 functionality (transfer, approve, allowance).
- Adds burning functionality to reduce the token supply.
- Includes `approveAndCall` for interacting with other contracts.

This contract is designed to be a manually implemented token with standard features and some additional capabilities.