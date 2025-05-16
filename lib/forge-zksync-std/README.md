## Forge ZKsync Standard Library

Forge ZKsync Standard Library is a collection of helpful contracts and libraries for use with [Forge and Foundry ZKsync](https://github.com/matter-labs/foundry-zksync). It leverages Forge's cheatcodes to make writing tests easier and faster, while improving the UX of cheatcodes.

**Learn how to use Forge-ZKsync-Std with the [📖 Foundry ZKsync Book](https://foundry-book.zksync.io/zksync-specifics/cheatcodes/).**

## Install

```bash
forge install Moonsong-Labs/forge-zksync-std
```

## Usage

Test:

```solidity
import {Test, console2 as console} from "forge-std/Test.sol";
import {TestExt} from "forge-zksync-std/TestExt.sol";

contract FooTest is Test, TestExt {
    function testZkTraceOutputDuringCreate() public {
        vm.startPrank(address(65536));  // normal foundry cheatcodes
        new Contract1();

        vmExt.zkVmSkip();               // additional foundry-zksync cheatcodes
        new Contract2();
    }
}
```

Script:

```solidity
import {Test, console2 as console} from "forge-std/Test.sol";
import {ScriptExt} from "forge-zksync-std/ScriptExt.sol";

contract FooScript is Script, ScriptExt {
    function deployTwoUserMultisig() public {
        Factory factory = new Factory(multisigBytecodeHash);

        // Mark the bytecode as a factory dependency
        vmExt.zkUseFactoryDep("TwoUserMultisig");

        // Deploy the account using the factory
        factory.deployAccount(multisigBytecodeHash);
    }
}
```
