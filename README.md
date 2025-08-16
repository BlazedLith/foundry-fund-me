# FundMe Smart Contract

A decentralized crowdfunding smart contract built with Foundry that allows users to fund projects and enables only the owner to withdraw collected funds. This project demonstrates best practices in Solidity development including proper testing, deployment scripts, and multi-network configurations.

## 🌟 Features

- **Decentralized Funding**: Users can fund the contract with ETH
- **Minimum Funding Threshold**: Enforces a minimum funding amount of $5 USD equivalent in ETH
- **Real-time Price Conversion**: Uses Chainlink price feeds to convert ETH to USD
- **Owner-only Withdrawals**: Only the contract owner can withdraw accumulated funds
- **Gas-optimized Withdrawals**: Includes both standard and gas-optimized withdrawal functions
- **Multi-network Support**: Configured for Ethereum Mainnet, Sepolia testnet, and local Anvil
- **Comprehensive Testing**: Unit and integration tests with 100% coverage
- **Automated Deployment**: Ready-to-use deployment scripts for different networks

## 🏗️ Architecture

### Core Contracts

- **`FundMe.sol`**: Main crowdfunding contract with funding and withdrawal logic
- **`PriceConverter.sol`**: Library for ETH/USD price conversion using Chainlink price feeds

### Smart Contract Features

- **Minimum USD Requirement**: $5 minimum funding threshold (configurable)
- **Price Feed Integration**: Real-time ETH/USD conversion via Chainlink oracles
- **Access Control**: Owner-only modifier for withdrawal functions
- **Funder Tracking**: Maintains array of funders and mapping of contributions
- **Gas Optimization**: Cheaper withdrawal function using memory optimization

### Network Configuration

- **Ethereum Mainnet**: Uses production Chainlink ETH/USD price feed
- **Sepolia Testnet**: Uses Sepolia Chainlink ETH/USD price feed  
- **Local Anvil**: Deploys mock price feed for testing

## 🚀 Quick Start

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
- Git for cloning the repository
- An Ethereum wallet with some ETH for deployment and testing

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/BlazedLith/foundry-fund-me.git
   cd foundry-fund-me
   ```

2. **Install dependencies**
   ```bash
   forge install
   ```

3. **Build the contracts**
   ```bash
   forge build
   ```

4. **Run tests**
   ```bash
   forge test
   ```

### Environment Setup

Create a `.env` file in the root directory:

```env
SEPOLIA_RPC_URL=your_sepolia_rpc_url
PRIVATE_KEY=your_private_key
ETHERSCAN_API_KEY=your_etherscan_api_key
```

## 📋 Usage

### Local Development

1. **Start local blockchain**
   ```bash
   anvil
   ```

2. **Deploy to local network**
   ```bash
   forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url http://localhost:8545 --private-key $PRIVATE_KEY --broadcast
   ```

### Testnet Deployment

Deploy to Sepolia testnet using the Makefile:

```bash
make deploy-sepolia
```

Or manually:

```bash
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

### Interacting with the Contract

#### Fund the Contract

```bash
cast send <CONTRACT_ADDRESS> "fund()" --value 0.1ether --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY
```

#### Withdraw Funds (Owner Only)

```bash
cast send <CONTRACT_ADDRESS> "withdraw()" --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY
```

#### Check Contract Balance

```bash
cast balance <CONTRACT_ADDRESS> --rpc-url $SEPOLIA_RPC_URL
```

### Using Interaction Scripts

The project includes automated interaction scripts:

```bash
# Fund the most recently deployed contract
forge script script/Interactions.s.sol:FundFundMe --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast

# Withdraw from the most recently deployed contract
forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
```

## 🧪 Testing

### Run All Tests

```bash
forge test
```

### Run Tests with Verbosity

```bash
forge test -vvv
```

### Run Specific Test File

```bash
forge test --match-path test/unit/FundMeTest.t.sol
```

### Generate Gas Report

```bash
forge test --gas-report
```

### Test Coverage

```bash
forge coverage
```

### Test Structure

- **Unit Tests** (`test/unit/`): Test individual contract functions
- **Integration Tests** (`test/integration/`): Test contract interactions
- **Mocks** (`test/mocks/`): Mock contracts for testing (MockAggregatorV3)

## 📁 Project Structure

```
foundry-fund-me/
├── src/
│   ├── FundMe.sol              # Main crowdfunding contract
│   └── PriceConverter.sol      # ETH/USD conversion library
├── script/
│   ├── DeployFundMe.s.sol      # Deployment script
│   ├── HelperConfig.s.sol      # Network configuration
│   └── Interactions.s.sol      # Fund/withdraw scripts
├── test/
│   ├── unit/
│   │   └── FundMeTest.t.sol    # Unit tests
│   ├── integration/
│   │   └── InteractionsTest.t.sol # Integration tests
│   └── mocks/
│       └── MockAggregatorV3.sol   # Mock price feed
├── lib/                        # Dependencies
├── foundry.toml               # Foundry configuration
├── Makefile                   # Build automation
└── README.md                  # This file
```

## 🔧 Configuration

### Foundry Configuration (`foundry.toml`)

```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
remappings = [
    "@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/",
]
solc_version = "0.8.19"
```

### Network Configurations

The `HelperConfig.s.sol` automatically detects the network and configures:

- **Sepolia** (Chain ID: 11155111): `0x694AA1769357215DE4FAC081bf1f309aDC325306`
- **Mainnet** (Chain ID: 1): `0x5147eA642CAEF7BD9c1265AadcA78f997AbB9649`
- **Anvil** (Local): Deploys MockV3Aggregator

## 🔐 Security Features

- **Access Control**: Only contract owner can withdraw funds
- **Input Validation**: Ensures minimum funding threshold
- **Reentrancy Protection**: Uses checks-effects-interactions pattern
- **Gas Optimization**: Efficient storage and memory usage
- **Price Feed Security**: Uses Chainlink's decentralized oracles

## 🛠️ Development

### Formatting Code

```bash
forge fmt
```

### Gas Snapshots

```bash
forge snapshot
```

### Updating Dependencies

```bash
forge update
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Useful Links

- [Foundry Book](https://book.getfoundry.sh/)
- [Chainlink Documentation](https://docs.chain.link/)
- [Solidity Documentation](https://docs.soliditylang.org/)
- [Ethereum Development Documentation](https://ethereum.org/en/developers/)

## 🆘 Troubleshooting

### Common Issues

1. **"You need to spend more ETH!" Error**
   - Ensure you're sending at least $5 worth of ETH
   - Check current ETH/USD price on price feed

2. **Deployment Fails**
   - Verify your private key and RPC URL are correct
   - Ensure you have enough ETH for gas fees
   - Check if the network is properly configured

3. **Tests Failing**
   - Run `forge clean` and `forge build` to rebuild
   - Ensure all dependencies are installed with `forge install`
   - Check if you're running tests on the correct network

4. **Mock Price Feed Issues**
   - Ensure Anvil is running for local testing
   - Verify mock contracts are properly deployed

### Getting Help

- Check the [Foundry Troubleshooting Guide](https://book.getfoundry.sh/troubleshooting/)
- Open an issue on this repository for project-specific problems
- Join the [Foundry Telegram](https://t.me/foundry_rs) for community support

---

## Checking out Deployed Contract

Wanna check out and interact with the deployed contract? Visit 0xE3BDF47e2E5Cbd9638aE141510A143502313e5d8 address at etherscan.io in Sepolia Testnet.

---

**Happy Coding!** 🚀
