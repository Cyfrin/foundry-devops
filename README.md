# foundry-devops

A repo to get the most recent deployment from a given environment in foundry. This way, you can do scripting off previous deployments in solidity. 

It will look through your `broadcast` folder at your most recent deployment. 


- [foundry-devops](#foundry-devops)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Usage](#usage)
- [Contributing](#contributing)
  - [Testing](#testing)


# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`


## Installation

```
forge install ChainAccelOrg/foundry-devops
```

## Usage

```javascript
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
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

# Contributing

PRs are welcome!

```
git clone https://github.com/ChainAccelOrg/foundry-devops
cd foundry-devops
forge install
```

## Testing

```
forge test
```
