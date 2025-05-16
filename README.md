<p align="center">
    <img width="200" src="https://portal.sophon.xyz/img/logo-sophon.svg" alt="Sophon Logo">
</p>

# Sophon Token

This repository contains the smart contracts for the Sophon Token (SOPH) and its wrapped variant.

## Overview

Sophon is an ERC20 token with permit functionality, implementing the [EIP-2612](https://eips.ethereum.org/EIPS/eip-2612) standard. The repository includes:

- `SophonToken` (SOPH): The main ERC20 token with a fixed supply of 10 billion tokens
- `L2WETH`: A wrapped ETH implementation for Layer 2
- Supporting contracts and interfaces

## Contracts

### SophonToken

A standard ERC20 token with the following features:
- Permit functionality for gasless approvals
- Burning capability for token holders
- Other token rescue functionality for the owner
- Protection against direct transfers to the token contract

### L2WETH

An upgradeable wrapped ETH implementation for Layer 2 with:
- Standard WETH functionality (deposit/withdraw)
- ERC20Permit support
- Compatibility with L2 standard token interface

## Development

### Prerequisites

- [Node.js](https://nodejs.org/) (v16+)
- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Brownie](https://eth-brownie.readthedocs.io/en/stable/install.html) (for Python-based tests)

### Installation

```bash
# Install dependencies
npm install

# Install Foundry dependencies
forge install
```

### Testing

```bash
# Run Foundry tests
forge test
```

## License

This project is licensed under GPL-3.0-only for `SophonToken` and MIT for `L2WETH`.

## Security

These contracts have been developed following best practices and industry standards. Always exercise caution when interacting with smart contracts.
