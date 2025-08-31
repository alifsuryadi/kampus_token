# Kampus Token System

A comprehensive blockchain-based token system for campus environments built on Sui blockchain. This project consists of three main token modules designed for different use cases within an educational ecosystem.

## Overview

The Kampus Token System provides three distinct token implementations:

1. **KAMPUS_COIN** - Basic campus utility token
2. **ADVANCED_KAMPUS_COIN** - Advanced token with admin controls and treasury management
3. **STUDENT_REWARD_TOKEN** - Gamified reward system for student achievements

## Deployed Contract Information

**Package ID**: `0xd513f3f7115b4bf173a3b23524781bcda7b27837ade0d7a51f2189879a86dfdd`

**Transaction Digest**: `EyhQmVAK2W4cWA3D6ELFm33DvpnEiYeSrdhz9LUNaL23`

**Network**: Sui Testnet

## Token Modules

### 1. KAMPUS_COIN

Basic campus utility token for general campus transactions.

**Features:**

- Symbol: `KAMPUS`
- Decimals: 9
- Basic minting and burning functionality
- Treasury cap control for minting

**Key Objects:**

- Treasury Cap: `0xd746e3a2885626f5fab2225f1c845dd54c914a2241909c564efa4ea53eafa81b`
- Metadata: `0xa39500f41886f481cb76d8ea037abbcaf29d5f7cbf68481bdf03f1c8c66113db`

### 2. ADVANCED_KAMPUS_COIN

Advanced token system with sophisticated admin controls and treasury management.

**Features:**

- Symbol: `AKAMPUS`
- Decimals: 9
- Admin capability system
- Treasury management with minting controls
- Event emission for token operations
- Batch minting functionality
- Coin splitting and joining utilities

**Key Objects:**

- Admin Cap: `0x9b0842befe723f719f8cac8ee824de468f117a400ec954709b0cef9112e266f3`
- Treasury: `0x7e5b3c04ac5a4f56c8670640479608355979c3200b192dbd4f73f570cffee372`
- Metadata: `0x08b949864b573c85de06c327ccb4f52dfc34d426e6426af23e9c9add41ed5d1d`

**Admin Functions:**

- `toggle_minting()` - Enable/disable token minting
- `mint_tokens()` - Mint tokens to specific address
- `batch_mint()` - Mint tokens to multiple addresses

**Public Functions:**

- `burn_tokens()` - Burn tokens to reduce supply
- `split_coin()` - Split coins into smaller denominations
- `join_coins()` - Combine multiple coins

### 3. STUDENT_REWARD_TOKEN

Gamified token system for rewarding student achievements and activities.

**Features:**

- Symbol: `SRT`
- Decimals: 6
- Student profile management
- Achievement-based reward system
- Configurable reward rates
- Token spending for benefits

**Key Objects:**

- Reward System: `0x3da55ca0a86d66a882cc889ea5bdbee689a9af45349bd64f814e32f2c728f29b`
- Metadata: `0x793bc30b1f3c6b4126a793babe1ffb55189c987117d2995769a9037d9916982f`

**Reward Structure:**

- Attendance: 10 SRT
- Assignment Completion: 25 SRT
- Exam Pass: 50 SRT
- Project Completion: 100 SRT

**Student Functions:**

- `register_student()` - Create student profile
- `claim_achievement_reward()` - Claim rewards for achievements
- `spend_tokens()` - Spend tokens for campus benefits

## Installation and Setup

### Prerequisites

Before you can build and deploy this project, you need to have the following tools installed:

- Git
- Rust (latest stable version)
- Sui CLI
- Code editor (VS Code recommended)

### Step 1: Install Rust

Visit [rustup.rs](https://rustup.rs/) and follow the installation instructions for your operating system.

For Windows:

```bash
# Download and run rustup-init.exe from rustup.rs
# Or use PowerShell:
Invoke-WebRequest -Uri "https://win.rustup.rs/" -OutFile "rustup-init.exe"
./rustup-init.exe
```

For macOS/Linux:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

### Step 2: Install Sui CLI

#### Option A: Install from Source (Recommended)

```bash
# Install Sui CLI from source
cargo install --locked --git https://github.com/MystenLabs/sui.git --branch testnet sui
```

#### Option B: Download Binary

Visit [Sui Releases](https://github.com/MystenLabs/sui/releases) and download the appropriate binary for your system.

### Step 3: Verify Installation

```bash
# Check Sui CLI version
sui --version

# Check if Move is available
sui move --help
```

### Step 4: Configure Sui Client

```bash
# Initialize Sui client configuration
sui client

# This will create a new wallet and configuration
# Follow the prompts to set up your wallet
```

### Step 5: Get Testnet Tokens

```bash
# Request testnet SUI tokens from faucet
sui client faucet

# Check your balance
sui client balance
```

### Step 6: Clone and Setup Project

```bash
# Clone the repository (if from GitHub)
git clone https://github.com/alifsuryadi/kampus_token.git
cd kampus_token

# Or create project from scratch
mkdir kampus_token
cd kampus_token

# Initialize Move project
sui move new kampus_token
cd kampus_token
```

### Step 7: Project Configuration

Ensure your `Move.toml` file is properly configured:

```toml
[package]
name = "kampus_token"
version = "0.0.1"
edition = "legacy"

[dependencies]
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/testnet" }

[addresses]
kampus_token = "0x0"
```

### Step 8: Building the Project

```bash
# Build the Move project
sui move build

# Check for any compilation errors
# The build should complete successfully with only warnings
```

### Step 9: Deploying to Testnet

```bash
# Deploy to Sui testnet
sui client publish --gas-budget 100000000

# Optional: Verify dependencies during publish
sui client publish --gas-budget 100000000 --verify-deps
```

### Step 10: Verify Deployment

After successful deployment, you should see:

- Transaction digest
- Package ID
- Created objects (Treasury caps, Admin caps, Shared objects)
- Gas costs

```bash
# Check your objects
sui client objects

# View specific object details
sui client object [OBJECT_ID]
```

## Local Development Environment

### Setting up VS Code

1. Install VS Code extensions:

   - Move Language Support
   - Rust Analyzer
   - Better TOML

2. Configure settings for Move development:

```json
{
  "move.extension.moveAnalyzer.path": "sui",
  "move.extension.moveAnalyzer.args": ["move", "analyzer"]
}
```

### Running Tests (Optional)

```bash
# Run Move tests if you have test files
sui move test

# Run with verbose output
sui move test --verbose
```

### Troubleshooting Common Issues

1. **"sui command not found"**

   - Make sure Rust and Cargo are in your PATH
   - Restart your terminal after installation
   - Run `source ~/.cargo/env` on Unix systems

2. **Build errors**

   - Check your `Move.toml` configuration
   - Ensure you're using the correct Sui framework version
   - Run `sui client faucet` to get testnet tokens

3. **Deployment failures**

   - Increase gas budget: `--gas-budget 200000000`
   - Check your testnet SUI balance
   - Verify network connection

4. **Permission errors on Windows**
   - Run terminal as Administrator
   - Check Windows Defender/antivirus settings

## Network Configuration

### Switching Networks

```bash
# List available environments
sui client envs

# Add custom RPC (if needed)
sui client new-env --alias custom-testnet --rpc https://fullnode.testnet.sui.io:443

# Switch to testnet
sui client switch --env testnet
```

### Interacting with the Contract

#### Minting KAMPUS_COIN

```bash
sui client call \
  --package 0xd513f3f7115b4bf173a3b23524781bcda7b27837ade0d7a51f2189879a86dfdd \
  --module kampus_coin \
  --function mint \
  --args [TREASURY_CAP_ID] [AMOUNT] [RECIPIENT_ADDRESS] \
  --gas-budget 10000000
```

#### Registering as Student

```bash
sui client call \
  --package 0xd513f3f7115b4bf173a3b23524781bcda7b27837ade0d7a51f2189879a86dfdd \
  --module student_reward_token \
  --function register_student \
  --args [NIM] [NAME] \
  --gas-budget 10000000
```

#### Claiming Achievement Rewards

```bash
sui client call \
  --package 0xd513f3f7115b4bf173a3b23524781bcda7b27837ade0d7a51f2189879a86dfdd \
  --module student_reward_token \
  --function claim_achievement_reward \
  --args [REWARD_SYSTEM_ID] [STUDENT_PROFILE_ID] [ACHIEVEMENT_NAME] \
  --gas-budget 10000000
```

## Architecture

### Token Design Patterns

1. **One Time Witness (OTW)** - Used for secure token initialization
2. **Capability Pattern** - Admin controls through capability objects
3. **Shared Objects** - Treasury and reward systems accessible to all users
4. **Event Emission** - Transparent tracking of token operations

### Security Features

- Admin-only minting controls
- Capability-based access control
- Immutable metadata after deployment
- Event logging for transparency

## Development

### Project Structure

```
kampus_token/
├── sources/
│   ├── kampus_coin.move
│   ├── advanced_kampus_coin.move
│   └── student_reward_token.move
├── Move.toml
└── README.md
```

### Testing

The contracts have been tested on Sui testnet and are ready for production use.

### Gas Costs

- Deployment: ~64 SUI (one-time)
- Token minting: ~0.01 SUI per transaction
- Profile registration: ~0.02 SUI per transaction
- Reward claiming: ~0.02 SUI per transaction

## Use Cases

### Campus Ecosystem

1. **Cafeteria Payments** - Use KAMPUS_COIN for meal purchases
2. **Library Services** - Pay fees with campus tokens
3. **Event Ticketing** - Purchase event tickets with tokens
4. **Scholarship Distribution** - Automated reward distribution

### Student Engagement

1. **Attendance Rewards** - Automatic rewards for class attendance
2. **Academic Performance** - Rewards for assignment and exam completion
3. **Extracurricular Activities** - Tokens for club participation
4. **Campus Services** - Spend tokens for premium services

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support and questions, please open an issue in the repository or contact the development team.

## Deployment Information

- **Deployer Address**: `0xb28d6e725dc3106cfcd5c55ca7ae6db1f9f95b3d83bb7aae11b467914452ba61`
- **Deployment Date**: Block 349180492
- **Total Gas Used**: 64,158,280 MIST
- **Status**: Successfully Deployed

## Quick Start Example

```bash
# 1. Build the project
sui move build

# 2. Deploy to testnet
sui client publish --gas-budget 100000000

# 3. Register as a student
sui client call --package [PACKAGE_ID] --module student_reward_token --function register_student --args 123456 "John Doe"

# 4. Claim attendance reward
sui client call --package [PACKAGE_ID] --module student_reward_token --function claim_achievement_reward --args [REWARD_SYSTEM_ID] [PROFILE_ID] "attendance"
```

Replace `[PACKAGE_ID]`, `[REWARD_SYSTEM_ID]`, and `[PROFILE_ID]` with the actual object IDs from your deployment.
