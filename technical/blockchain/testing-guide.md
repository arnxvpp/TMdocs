# Blockchain Integration: Testing Guide

This document provides detailed guidance on testing TuneMantra's blockchain integration, including various testing methodologies, tools, and best practices.

## Introduction

Testing blockchain integration is critical to ensure reliability, security, and performance of our rights management and NFT creation features. This guide covers all aspects of testing, from local development to production validation.

## Testing Environments

TuneMantra supports multiple testing environments:

| Environment | Purpose | Configuration |
|-------------|---------|--------------|
| Local Development | Individual developer testing | Simulation mode enabled |
| Development | Team integration testing | Mumbai testnet with test wallets |
| Staging | Pre-production validation | Mumbai testnet with production-like data |
| Production | Live operations | Polygon and Ethereum mainnets |

## Test Types

### 1. Simulation-Based Testing

Simulation testing allows for rapid development and testing without requiring actual blockchain transactions:

- **Setup**: Set `BLOCKCHAIN_SIMULATION=true` in your environment variables
- **Coverage**: All blockchain operations are simulated with realistic responses
- **Benefits**: Fast, no cost, no external dependencies
- **Limitations**: Does not test actual blockchain interactions

Example:
```bash
BLOCKCHAIN_SIMULATION=true ./run_blockchain_tests.sh
```

### 2. Testnet Testing

Testing on actual blockchain test networks provides more realistic validation:

- **Setup**: Configure RPC URLs and contract addresses for Mumbai testnet
- **Coverage**: Tests actual blockchain interactions on a test network
- **Benefits**: Real blockchain behavior without real-world costs
- **Limitations**: Requires test tokens, can be slower than simulation

Example:
```bash
POLYGON_MUMBAI_RPC_URL=https://polygon-mumbai.infura.io/v3/your_key ./run_blockchain_tests.sh
```

### 3. Component Testing

Testing individual blockchain components in isolation:

- **Blockchain Connector**: Tests the connector service's interface with blockchains
- **Rights Management**: Tests rights registration and verification
- **NFT Service**: Tests NFT minting and token management
- **Smart Contracts**: Tests contract interactions

### 4. Integration Testing

Testing the interaction between blockchain components and other system parts:

- **API Integration**: Tests blockchain API endpoints
- **Database Integration**: Tests storage and retrieval of blockchain records
- **UI Integration**: Tests user interfaces for blockchain operations

### 5. End-to-End Testing

Complete workflow testing from user interface to blockchain and back:

- **Rights Registration Flow**: Complete rights registration process
- **NFT Creation Flow**: Complete NFT creation process
- **Rights Verification Flow**: Complete rights verification process

## Testing Tools

### Master Test Script

The main entry point for blockchain testing is `run_blockchain_tests.sh`, which:

- Automatically detects the environment and configures accordingly
- Runs all test scripts in the appropriate sequence
- Provides comprehensive reporting of test results
- Works in both simulation and real blockchain modes

Usage:
```bash
./run_blockchain_tests.sh
```

### Specialized Test Scripts

Various specialized test scripts are available for specific testing needs:

| Script | Purpose |
|--------|---------|
| `scripts/blockchain-connector-test.ts` | Tests the core blockchain connector service |
| `scripts/blockchain-simulator-flow-test.ts` | Tests complete flows in simulation mode |
| `scripts/blockchain-verification-test.ts` | Tests rights verification specifically |
| `scripts/complete-blockchain-test-suite.ts` | Comprehensive test suite for all functionality |
| `scripts/production-readiness-check.ts` | Validates production configuration |

### Production Readiness Check

The production readiness check script ensures all required configuration is present:

- Verifies environment variables
- Tests blockchain network connections
- Validates smart contract addresses
- Checks wallet configuration and balances
- Confirms IPFS configuration

Usage:
```bash
NODE_ENV=production npx tsx scripts/production-readiness-check.ts
```

## Testing Methodology

### Unit Testing

1. **Setup**: Initialize the blockchain connector with mock dependencies
2. **Execution**: Call individual methods with test parameters
3. **Assertion**: Verify correct return values and side effects
4. **Cleanup**: Reset state for next test

Example:
```typescript
describe('BlockchainConnector', () => {
  let connector: BlockchainConnector;
  
  beforeEach(() => {
    connector = new BlockchainConnector();
  });
  
  it('should return supported networks', () => {
    const networks = connector.getSupportedNetworks();
    expect(networks.length).toBeGreaterThan(0);
  });
});
```

### Integration Testing

1. **Setup**: Initialize real services with test configuration
2. **Execution**: Perform complete operations (register rights, mint NFT, etc.)
3. **Assertion**: Verify correct database state and blockchain records
4. **Cleanup**: Revert changes where possible

Example:
```typescript
describe('Rights Management Integration', () => {
  it('should register rights and store in database', async () => {
    // Setup
    const rightsService = new RightsManagementService();
    
    // Execution
    const result = await rightsService.registerRights({
      contentId: 'test-track-001',
      artistId: 'test-artist-001',
      rightType: 'master'
    });
    
    // Assertion
    expect(result.success).toBeTruthy();
    const dbRecord = await db.query('SELECT * FROM rights_records WHERE id = $1', [result.rightsId]);
    expect(dbRecord).toBeDefined();
  });
});
```

### End-to-End Testing

1. **Setup**: Start application with test configuration
2. **Execution**: Perform user actions through UI or API
3. **Assertion**: Verify correct UI feedback and database state
4. **Cleanup**: Reset application state

## Test Data Management

### Test Wallets

For testnet testing, dedicated test wallets should be used:

- Configure `ETH_ACCOUNT_PRIVATE_KEY` with a test account private key
- Ensure the test wallet has sufficient test tokens
- Never use production wallets for testing

### Test Content

Standardized test content should be used for consistent testing:

- Test tracks with known metadata
- Test artists with known details
- Test rights declarations with known parameters

## Test Reporting

The blockchain test scripts provide structured reporting:

- Success/failure status for each test case
- Detailed logs for troubleshooting
- Summary statistics of test results
- Visual indicators for pass/fail status

Example:
```
=== Test Results Summary ===
Standalone Connector Test: ✅ PASSED
Simulation Flow Test: ✅ PASSED
Rights Verification Test: ✅ PASSED
Complete Test Suite: ✅ PASSED
Production Readiness Check: ⚠️ WARNING (Missing optional configuration)

Total Tests: 5
Passed: 4
Warnings: 1
Failed: 0
```

## Troubleshooting Common Issues

### Network Connection Issues

- Verify RPC URL is correct and accessible
- Check network status (testnets can be unreliable)
- Try using an alternative RPC provider

### Smart Contract Errors

- Verify contract addresses are correct
- Check that contracts are deployed on the expected network
- Validate contract ABI against deployed contract

### Transaction Failures

- Ensure wallet has sufficient funds
- Check gas price and limits
- Verify transaction parameters

### Simulation Mode Issues

- Confirm `BLOCKCHAIN_SIMULATION=true` is set
- Check for inconsistencies in the simulation logic
- Verify all required methods are implemented in the simulator

## Continuous Integration

Blockchain tests are integrated into the CI/CD pipeline:

- Simulation tests run on every pull request
- Testnet tests run on merge to development branch
- Production readiness checks run before deployment

## Best Practices

1. **Always start with simulation mode** for rapid iteration
2. **Progress to testnet testing** for validation before production
3. **Isolate blockchain tests** from other system tests
4. **Mock blockchain dependencies** in non-blockchain tests
5. **Use dedicated test wallets** with limited funds
6. **Never test with production credentials**
7. **Include positive and negative test cases**
8. **Test edge cases** such as network timeouts and failures
9. **Clean up test data** after test completion
10. **Document test scenarios** for future reference

## Related Documents

- [Overview & Architecture](overview-architecture.md)
- [Implementation Guide](implementation-guide.md)
- [Smart Contracts](smart-contracts.md)
- [Integration Guide](integration-guide.md)