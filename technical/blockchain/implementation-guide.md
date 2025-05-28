# Blockchain Integration: Implementation Guide

This document provides detailed implementation details for the TuneMantra blockchain integration, including code examples, configuration, and best practices for developers.

## Introduction

This guide is intended for developers implementing or extending the blockchain functionality in TuneMantra. It assumes a basic understanding of blockchain technology and smart contract development.

## Prerequisites

Before implementing blockchain features, ensure you have:

- Development environment with Node.js 18+
- Familiarity with TypeScript and ethers.js
- Access to blockchain networks (or simulation mode enabled)
- Understanding of the TuneMantra architecture

## Service Architecture

The blockchain implementation follows a service-oriented architecture:

```
blockchain-connector.ts       # Core connector with blockchain networks
├── rights-management-service.ts  # Rights registration and verification
├── nft-service.ts                # NFT minting and management
└── storage.ts                   # Database interaction for blockchain data
```

## Core Components Implementation

### Blockchain Connector

The BlockchainConnector class provides a unified interface to interact with different blockchain networks:

```typescript
export class BlockchainConnector {
  private networks: Record<string, Network>;
  private defaultNetwork: string;
  private providers: Record<string, ethers.JsonRpcProvider>;
  private contracts: Record<string, Record<string, ethers.Contract>>;
  private simulationMode: boolean;
  
  constructor() {
    // Initialize networks, providers, contracts
    // Load configuration from environment variables
    this.simulationMode = process.env.BLOCKCHAIN_SIMULATION === 'true';
    this.initializeNetworks();
    if (!this.simulationMode) {
      this.initializeProviders();
      this.initializeContracts();
    }
  }
  
  // Methods for blockchain operations
  async registerRights(networkId, contentId, artistId, rightType, signature, startDate, endDate, metadata) {
    // Implementation details
  }
  
  async verifyRights(networkId, rightsId, signature) {
    // Implementation details
  }
  
  // Other blockchain methods
}
```

### Network Configuration

Networks are configured through environment variables:

```
POLYGON_MUMBAI_RPC_URL=https://rpc-mumbai.maticvigil.com
POLYGON_MUMBAI_CHAIN_ID=80001
POLYGON_MUMBAI_RIGHTS_CONTRACT=0x...
POLYGON_MUMBAI_NFT_CONTRACT=0x...
```

The connector loads this configuration during initialization:

```typescript
private initializeNetworks() {
  this.networks = {};
  
  // Polygon Mumbai
  if (process.env.POLYGON_MUMBAI_RPC_URL) {
    this.networks['polygon-mumbai'] = {
      id: 'polygon-mumbai',
      name: 'Polygon Mumbai',
      chainId: parseInt(process.env.POLYGON_MUMBAI_CHAIN_ID || '80001'),
      rpcUrl: process.env.POLYGON_MUMBAI_RPC_URL,
      contracts: {
        rights: process.env.POLYGON_MUMBAI_RIGHTS_CONTRACT,
        nft: process.env.POLYGON_MUMBAI_NFT_CONTRACT
      },
      active: true
    };
  }
  
  // Additional networks configuration...
}
```

## Smart Contract Integration

The platform integrates with two primary smart contracts:

### Rights Registry Contract

This contract handles rights registration and verification:

```typescript
async registerRights(networkId: string, contentId: string, artistId: string, rightType: string, signature: string, startDate: Date, endDate: Date, metadata: any): Promise<RegisterRightsResult> {
  if (this.simulationMode) {
    return this.simulateRegisterRights(networkId, contentId, artistId, rightType, signature, startDate, endDate, metadata);
  }
  
  const network = this.getNetwork(networkId);
  const provider = this.getProvider(networkId);
  const contract = this.getContract(networkId, 'rights');
  
  const wallet = new ethers.Wallet(process.env.ETH_ACCOUNT_PRIVATE_KEY as string, provider);
  const connectedContract = contract.connect(wallet);
  
  const metadataStr = JSON.stringify(metadata);
  const startTimestamp = Math.floor(startDate.getTime() / 1000);
  const endTimestamp = Math.floor(endDate.getTime() / 1000);
  
  try {
    const tx = await connectedContract.registerRights(
      contentId,
      artistId,
      rightType,
      signature,
      startTimestamp,
      endTimestamp,
      metadataStr
    );
    
    const receipt = await tx.wait();
    const event = receipt.events?.find(e => e.event === 'RightsRegistered');
    const rightsId = event?.args?.rightsId?.toString();
    
    return {
      success: true,
      rightsId: rightsId,
      transactionHash: receipt.hash,
      message: 'Rights registered successfully'
    };
  } catch (error) {
    return {
      success: false,
      message: `Error registering rights: ${error.message}`
    };
  }
}
```

### NFT Contract

This contract handles NFT minting and management:

```typescript
async mintTrackNFT(networkId: string, contentId: string, artistId: string, tokenURI: string, metadata: any): Promise<MintNFTResult> {
  if (this.simulationMode) {
    return this.simulateMintNFT(networkId, contentId, artistId, tokenURI, metadata);
  }
  
  const network = this.getNetwork(networkId);
  const provider = this.getProvider(networkId);
  const contract = this.getContract(networkId, 'nft');
  
  const wallet = new ethers.Wallet(process.env.ETH_ACCOUNT_PRIVATE_KEY as string, provider);
  const connectedContract = contract.connect(wallet);
  
  try {
    const tx = await connectedContract.mintTrack(
      process.env.ETH_ACCOUNT_ADDRESS,
      contentId,
      artistId,
      tokenURI
    );
    
    const receipt = await tx.wait();
    const event = receipt.events?.find(e => e.event === 'TrackMinted');
    const tokenId = event?.args?.tokenId?.toString();
    
    return {
      success: true,
      tokenId: tokenId,
      transactionHash: receipt.hash,
      message: 'NFT minted successfully'
    };
  } catch (error) {
    return {
      success: false,
      message: `Error minting NFT: ${error.message}`
    };
  }
}
```

## Simulation Mode

For development and testing, the platform includes a comprehensive simulation mode:

```typescript
private simulateRegisterRights(networkId: string, contentId: string, artistId: string, rightType: string, signature: string, startDate: Date, endDate: Date, metadata: any): Promise<RegisterRightsResult> {
  // Simulate blockchain transaction
  const txHash = `0x${Math.random().toString(16).substring(2).padStart(64, '0')}`;
  const rightsId = `${contentId}-${Date.now()}`;
  
  // Simulate network delay
  return new Promise(resolve => {
    setTimeout(() => {
      // Store in in-memory simulation database
      this.simulationDB.rightsRecords[rightsId] = {
        id: rightsId,
        networkId,
        contentId,
        artistId,
        rightType,
        signature,
        startDate,
        endDate,
        metadata,
        transactionHash: txHash,
        timestamp: Date.now()
      };
      
      resolve({
        success: true,
        rightsId,
        transactionHash: txHash,
        message: 'Rights registered successfully (SIMULATION)'
      });
    }, 1000); // Simulate 1s transaction time
  });
}
```

## Error Handling

The blockchain integration includes robust error handling:

```typescript
async function withRetry<T>(operation: () => Promise<T>, maxRetries = 3, retryDelay = 1000): Promise<T> {
  let lastError: Error;
  
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await operation();
    } catch (error) {
      console.error(`Attempt ${attempt} failed:`, error);
      lastError = error;
      
      if (attempt < maxRetries) {
        console.log(`Retrying in ${retryDelay}ms...`);
        await new Promise(resolve => setTimeout(resolve, retryDelay));
        // Increase delay for next attempt (exponential backoff)
        retryDelay *= 2;
      }
    }
  }
  
  throw lastError;
}
```

## Database Integration

Blockchain transactions and details are stored in the database:

```typescript
async function storeRightsRecord(rightsRecord: RightsRecord): Promise<void> {
  await db.insert(rightsRecordsTable).values({
    id: rightsRecord.id,
    network_id: rightsRecord.networkId,
    content_id: rightsRecord.contentId,
    artist_id: rightsRecord.artistId,
    right_type: rightsRecord.rightType,
    signature: rightsRecord.signature,
    start_date: rightsRecord.startDate,
    end_date: rightsRecord.endDate,
    metadata: JSON.stringify(rightsRecord.metadata),
    transaction_hash: rightsRecord.transactionHash,
    created_at: new Date()
  });
}
```

## API Integration

The blockchain functionality is exposed through REST API endpoints:

```typescript
router.post('/rights/register', async (req, res) => {
  const { networkId, contentId, artistId, rightType, startDate, endDate, metadata } = req.body;
  
  // Validate input
  if (!networkId || !contentId || !artistId || !rightType) {
    return res.status(400).json({ success: false, message: 'Missing required fields' });
  }
  
  try {
    // Generate signature (in a real app, this would be provided by the client)
    const message = `${artistId}:${contentId}:${rightType}`;
    const signature = await blockchainService.generateSignature(message);
    
    // Register rights
    const result = await blockchainService.registerRights(
      networkId,
      contentId,
      artistId,
      rightType,
      signature,
      new Date(startDate),
      new Date(endDate),
      metadata
    );
    
    return res.json(result);
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
});
```

## Security Considerations

When implementing blockchain functionality, consider these security aspects:

1. **Private Key Management**
   - Never store private keys in code or commit them to repositories
   - Use environment variables or secure key management solutions
   - Consider implementing a Key Management Service (KMS) for production

2. **Input Validation**
   - Validate all inputs to blockchain functions
   - Sanitize metadata before storing on-chain
   - Verify signature validity before registering rights

3. **Error Handling**
   - Never expose sensitive information in error messages
   - Log errors for debugging but sanitize logs
   - Return appropriate HTTP status codes for API errors

4. **Transaction Monitoring**
   - Implement a system to monitor transaction status
   - Handle transaction failures gracefully
   - Provide meaningful feedback to users

## Performance Optimization

To optimize blockchain operations:

1. **Caching**
   - Cache frequently accessed blockchain data
   - Implement TTL (Time-To-Live) for cached data
   - Invalidate cache when data changes

2. **Background Processing**
   - Process blockchain transactions in background jobs
   - Use webhooks to notify the application of transaction completion
   - Implement a queuing system for high-volume operations

3. **Lazy Loading**
   - Only load blockchain data when needed
   - Implement pagination for large data sets
   - Use progressive loading for UI elements

## Testing Implementation

Implement comprehensive tests for blockchain functionality:

```typescript
describe('BlockchainConnector', () => {
  let connector: BlockchainConnector;
  
  beforeEach(() => {
    // Set up test environment
    process.env.BLOCKCHAIN_SIMULATION = 'true';
    connector = new BlockchainConnector();
  });
  
  afterEach(() => {
    // Clean up
    process.env.BLOCKCHAIN_SIMULATION = '';
  });
  
  it('should register rights in simulation mode', async () => {
    const result = await connector.registerRights(
      'polygon-mumbai',
      'test-content-id',
      'test-artist-id',
      'master',
      'test-signature',
      new Date(),
      new Date(Date.now() + 86400000), // 1 day later
      { title: 'Test Track' }
    );
    
    expect(result.success).toBeTruthy();
    expect(result.rightsId).toBeDefined();
    expect(result.transactionHash).toBeDefined();
  });
  
  // Additional tests...
});
```

## Deployment Considerations

When deploying to production:

1. **Environment Configuration**
   - Configure all required environment variables
   - Use different wallets for different environments
   - Verify contract addresses on the target networks

2. **Monitoring and Alerting**
   - Implement monitoring for blockchain operations
   - Set up alerts for transaction failures
   - Monitor wallet balances to ensure sufficient funds

3. **Disaster Recovery**
   - Implement backup and recovery procedures
   - Document steps to recover from blockchain failures
   - Test recovery procedures regularly

## Related Documents

- [Overview & Architecture](overview-architecture.md)
- [Smart Contracts](smart-contracts.md)
- [Testing Guide](testing-guide.md)
- [Integration Guide](integration-guide.md)

## Additional Resources

For historical and comprehensive information, refer to the following sections in the consolidated documentation:

- [Section 13: Enhanced Security with Blockchain](../../TuneMantra_Comprehensive_Documentation.md) in the comprehensive documentation
- [Section 13.1: Blockchain Implementation Guide](../../TuneMantra_Comprehensive_Documentation.md) for historical implementation details

This directory-based documentation contains the most current and refined information for active development. The comprehensive documentation provides additional historical context that may be useful for understanding the evolution of the blockchain implementation.