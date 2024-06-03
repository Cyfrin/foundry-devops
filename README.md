# foundry-devops

A repo to get the most recent deployment from a given environment in foundry. This way, you can do scripting off previous deployments in solidity.

It will look through your `broadcast` folder at your most recent deployment.

## Features
- Get the most recent deployment of a contract in foundry
- Checking if your on a zkSync based chain

- [foundry-devops](#foundry-devops)
  - [Features](#features)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Usage - Getting the most recent deployment](#usage---getting-the-most-recent-deployment)
  - [Usage - zkSync Checker](#usage---zksync-checker)
- [Contributing](#contributing)
  - [Testing](#testing)


# Getting Started

## Requirements

-   [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
    -   You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
-   [foundry](https://getfoundry.sh/)
    -   You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`
-   [jq](https://stackoverflow.com/questions/37668134/how-to-install-jq-on-mac-on-the-command-line)
    -   A lot already have it installed. Try it with `jq --version` and see a response like `jq-1.6`

## Installation

```bash
forge install Cyfrin/foundry-devops --no-commit
```

- Update forge-std to use newer FS cheatcodes
```
git rm -rf lib/forge-std
```
```
 rm -rf lib/forge-std
```
```
 forge install foundry-rs/forge-std@v1.8.2 --no-commit
```

## Usage - Getting the most recent deployment

1. Update your `foundry.toml` to have read permissions on the `broadcast` folder.

```toml
fs_permissions = [
    { access = "read", path = "./broadcast" },
    { access = "read", path = "./reports" },
]
```

2. Import the package, and call `DevOpsTools.get_most_recent_deployment("MyContract", chainid);`

ie:

```javascript
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {MyContract} from "my-contract/MyContract.sol";
.
.
.
function interactWithPreviouslyDeployedContracts() public {
    address contractAddress = DevOpsTools.get_most_recent_deployment("MyContract", block.chainid);
    MyContract myContract = MyContract(contractAddress);
    myContract.doSomething();
}
```

## Usage - zkSync Checker

### Prerequisites
- [foundry-zksync](https://github.com/matter-labs/foundry-zksync)
  - You'll know you did it right if you can run `foundryup-zksync --help` and you see a response like:
```
The installer for Foundry-zksync.

Update or revert to a specific Foundry-zksync version with ease.
.
.
.
```

### Usage - ZkSyncChainChecker

In your contract, you can import and inherit the abstract contract `ZkSyncChainChecker` to check if you are on a zkSync based chain. And add the `skipZkSync` modifier to any function you want to skip if you are on a zkSync based chain.

It will check both the precompiles or the `chainid` to determine if you are on a zkSync based chain.

```javascript
import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";

contract MyContract is ZkSyncChainChecker {

  function doStuff() skipZkSync {
```

### ZkSyncChainChecker modifiers:
- `skipZkSync`: Skips the function if you are on a zkSync based chain.
- `onlyZkSync`: Only allows the function if you are on a zkSync based chain.
  
### ZkSyncChainChecker Functions:
- `isZkSyncChain()`: Returns true if you are on a zkSync based chain.
- `isOnZkSyncPrecompiles()`: Returns true if you are on a zkSync based chain using the precompiles.
- `isOnZkSyncChainId()`: Returns true if you are on a zkSync based chain using the chainid.

### Usage - FoundryZkSyncChecker

In your contract, you can import and inherit the abstract contract `FoundryZkSyncChecker` to check if you are on the `foundry-zksync` fork of `foundry`. 

> !Important: Functions and modifiers in `FoundryZkSyncChecker` are only available if you run `foundry-zksync` with the `--zksync` flag.

```javascript
import {FoundryZkSyncChecker} from "lib/foundry-devops/src/FoundryZkSyncChecker.sol";

contract MyContract is FoundryZkSyncChainChecker {

  function doStuff() onlyFoundryZkSync {
```

You must also add `ffi = true` to your `foundry.toml` to use this feature. 

### FoundryZkSync modifiers:
- `onlyFoundryZkSync`: Only allows the function if you are on `foundry-zksync`
- `onlyVanillaFoundry`: Only allows the function if you are on `foundry`

### FoundryZkSync Functions:
- `is_foundry_zksync`: Returns true if you are on `foundry-zksync`


# Testing

For testing on vanilla foundry, run:

```bash
make test
```

For testing with `foundry-zksync`, run:

```bash
make test-zksync
```

# Limitations
- You cannot deploy a contract with `FoundryZkSyncChainChecker` or `ZkSyncChainChecker` because `foundry-zksync` gets confused by a lot of cheatcodes, and doesn't recognize cheatcodes after compiling to the EraVM. 

# Contributing

PRs are welcome!

```
git clone https://github.com/Cyfrin/foundry-devops
cd foundry-devops
make
```
