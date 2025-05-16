// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IL2WETH.sol";
import "./IL2StandardToken.sol";

interface IwSoph is IERC20, IL2WETH, IL2StandardToken {}