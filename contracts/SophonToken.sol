// SPDX-License-Identifier: GPL-3.0-only

pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

/**
 * @title SophonToken
 * @dev An ERC20 token with permit functionality and the ability to rescue tokens.
 * Inherits from ERC20Permit and Ownable2Step for ownership and access control.
 */
contract SophonToken is ERC20Permit, Ownable2Step {
    using SafeERC20 for IERC20;

    /// @notice Emitted when a token rescue operation is performed
    /// @param token The address of the rescued token
    /// @param receiver The address receiving the rescued tokens
    /// @param value The amount of tokens rescued
    event Rescue(address indexed token, address indexed receiver, uint256 value);

    /// @notice Error thrown when the contract itself is set as the token receiver
    error ERC20TokenIsReceiver();

    /**
     * @notice Constructor to initialize the token with the owner and mint receiver
     * @param initialOwner The address of the initial owner
     * @param mintReceiver The address that will receive the initial token supply
     */
    constructor(address initialOwner, address mintReceiver)
        ERC20Permit(name())
        ERC20(name(), symbol())
        Ownable(initialOwner)
    {
        // Mint initial and maximum supply of 10 billion tokens (18 decimal places)
        _mint(mintReceiver, 10_000_000_000e18);
    }

    /**
     * @notice Returns the name of the token
     * @return The token name as a string
     */
    function name() public pure override returns (string memory) {
        return "Sophon";
    }

    /**
     * @notice Returns the symbol of the token
     * @return The token symbol as a string
     */
    function symbol() public pure override returns (string memory) {
        return "SOPH";
    }

    /**
     * @notice Allows the caller to burn a specific amount of tokens
     * @param value The amount of tokens to burn
     * @return True if the burn was successful
     */
    function burn(uint256 value) external returns (bool) {
        address owner = _msgSender();
        _burn(owner, value);
        return true;
    }

    /**
     * @notice Allows the caller to burn tokens from another account based on allowance
     * @param from The address from which tokens will be burned
     * @param value The amount of tokens to burn
     * @return True if the burn was successful
     */
    function burnFrom(address from, uint256 value) external returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _burn(from, value);
        return true;
    }

    /**
     * @notice Allows the owner to rescue ERC20 tokens that are mistakenly sent to this contract
     * @param token The ERC20 token contract address to rescue tokens from
     */
    function rescue(IERC20 token) external onlyOwner {
        address owner = _msgSender();
        uint256 value = token.balanceOf(address(this));
        token.safeTransfer(owner, value);
        emit Rescue(address(token), owner, value);
    }

    /**
     * @notice Internal function that updates token balances before transfers
     * @dev Reverts if the contract is set as the receiver
     * @param from The address sending the tokens
     * @param to The address receiving the tokens
     * @param value The number of tokens being transferred
     */
    function _update(address from, address to, uint256 value) internal override {
        if (to == address(this)) {
            revert ERC20TokenIsReceiver();
        }
        super._update(from, to, value);
    }
}
