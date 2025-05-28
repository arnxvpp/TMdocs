# Blockchain Integration: Integration Guide

This document provides a comprehensive guide for integrating with TuneMantra's blockchain services, including API endpoints, client libraries, and best practices for third-party integrations.

## Introduction

TuneMantra's blockchain integration provides powerful capabilities for rights management and NFT creation. This guide explains how to integrate with these services using our APIs and client libraries.

## Integration Options

There are several ways to integrate with TuneMantra's blockchain services:

1. **REST API** - Standard HTTP endpoints for all blockchain operations
2. **JavaScript SDK** - Simplified client library for web applications
3. **Server-side Libraries** - Libraries for Node.js, Python, and other languages
4. **Direct Smart Contract Interaction** - For advanced integrations that need direct blockchain access

## REST API

The TuneMantra API provides comprehensive endpoints for all blockchain operations.

### Base URL

```
Production: https://api.tunemantra.com/v1
Development: https://dev-api.tunemantra.com/v1
```

### Authentication

All API requests require authentication using JWT tokens:

```
Authorization: Bearer <your_jwt_token>
```

To obtain a token, use the authentication endpoint:

```http
POST /auth/login
Content-Type: application/json

{
  "email": "your-email@example.com",
  "password": "your-password"
}
```

Response:

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 86400
}
```

### Rights Management Endpoints

#### Register Rights

```http
POST /blockchain/rights/register
Content-Type: application/json
Authorization: Bearer <your_jwt_token>

{
  "networkId": "polygon-mumbai",
  "contentId": "track-123456",
  "artistId": "artist-654321",
  "rightType": "master",
  "startDate": "2023-01-01T00:00:00Z",
  "endDate": "2093-01-01T00:00:00Z",
  "metadata": {
    "title": "My Track",
    "genre": "Electronic",
    "isrc": "USXXX2112345",
    "publisher": "My Publisher",
    "label": "My Label"
  }
}
```

Response:

```json
{
  "success": true,
  "rightsId": "rights-789012",
  "transactionHash": "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef",
  "message": "Rights registered successfully"
}
```

#### Verify Rights

```http
POST /blockchain/rights/verify
Content-Type: application/json
Authorization: Bearer <your_jwt_token>

{
  "networkId": "polygon-mumbai",
  "rightsId": "rights-789012",
  "signature": "0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890"
}
```

Response:

```json
{
  "success": true,
  "verified": true,
  "rights": {
    "contentId": "track-123456",
    "artistId": "artist-654321",
    "rightType": "master",
    "startDate": "2023-01-01T00:00:00Z",
    "endDate": "2093-01-01T00:00:00Z",
    "metadata": {
      "title": "My Track",
      "genre": "Electronic",
      "isrc": "USXXX2112345"
    },
    "registrant": "0x1234567890123456789012345678901234567890",
    "timestamp": "2023-01-15T12:34:56Z"
  },
  "message": "Rights verified successfully"
}
```

#### Get Rights Information

```http
GET /blockchain/rights/{rightsId}
Authorization: Bearer <your_jwt_token>
```

Response:

```json
{
  "success": true,
  "rights": {
    "id": "rights-789012",
    "contentId": "track-123456",
    "artistId": "artist-654321",
    "rightType": "master",
    "startDate": "2023-01-01T00:00:00Z",
    "endDate": "2093-01-01T00:00:00Z",
    "metadata": {
      "title": "My Track",
      "genre": "Electronic",
      "isrc": "USXXX2112345"
    },
    "registrant": "0x1234567890123456789012345678901234567890",
    "transactionHash": "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef",
    "timestamp": "2023-01-15T12:34:56Z",
    "networkId": "polygon-mumbai"
  },
  "message": "Rights retrieved successfully"
}
```

### NFT Endpoints

#### Mint NFT

```http
POST /blockchain/nft/mint
Content-Type: application/json
Authorization: Bearer <your_jwt_token>

{
  "networkId": "polygon-mumbai",
  "contentId": "track-123456",
  "artistId": "artist-654321",
  "metadata": {
    "name": "My Track NFT",
    "description": "NFT for My Track by Artist",
    "image": "ipfs://QmImage123456789",
    "animation_url": "ipfs://QmAudio123456789",
    "external_url": "https://tunemantra.com/tracks/123456",
    "attributes": [
      { "trait_type": "Genre", "value": "Electronic" },
      { "trait_type": "BPM", "value": 120 },
      { "trait_type": "Key", "value": "C Major" },
      { "trait_type": "Duration", "value": "3:45" },
      { "trait_type": "Release Year", "value": 2023 }
    ]
  }
}
```

Response:

```json
{
  "success": true,
  "tokenId": "123",
  "transactionHash": "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef",
  "tokenURI": "ipfs://QmXyZ123456789ABCDEF",
  "message": "NFT minted successfully"
}
```

#### Get NFT Details

```http
GET /blockchain/nft/{tokenId}
Authorization: Bearer <your_jwt_token>
```

Response:

```json
{
  "success": true,
  "nft": {
    "tokenId": "123",
    "contentId": "track-123456",
    "artistId": "artist-654321",
    "owner": "0x1234567890123456789012345678901234567890",
    "tokenURI": "ipfs://QmXyZ123456789ABCDEF",
    "metadata": {
      "name": "My Track NFT",
      "description": "NFT for My Track by Artist",
      "image": "ipfs://QmImage123456789",
      "animation_url": "ipfs://QmAudio123456789",
      "external_url": "https://tunemantra.com/tracks/123456",
      "attributes": [
        { "trait_type": "Genre", "value": "Electronic" },
        { "trait_type": "BPM", "value": 120 },
        { "trait_type": "Key", "value": "C Major" },
        { "trait_type": "Duration", "value": "3:45" },
        { "trait_type": "Release Year", "value": 2023 }
      ]
    },
    "transactionHash": "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef",
    "timestamp": "2023-01-15T12:34:56Z",
    "networkId": "polygon-mumbai"
  },
  "message": "NFT details retrieved successfully"
}
```

### Network Information

#### Get Supported Networks

```http
GET /blockchain/networks
Authorization: Bearer <your_jwt_token>
```

Response:

```json
{
  "success": true,
  "networks": [
    {
      "id": "polygon-mumbai",
      "name": "Polygon Mumbai",
      "chainId": 80001,
      "type": "testnet",
      "active": true
    },
    {
      "id": "polygon",
      "name": "Polygon Mainnet",
      "chainId": 137,
      "type": "mainnet",
      "active": true
    },
    {
      "id": "ethereum",
      "name": "Ethereum Mainnet",
      "chainId": 1,
      "type": "mainnet",
      "active": true
    }
  ],
  "message": "Networks retrieved successfully"
}
```

## JavaScript SDK

For frontend applications, we provide a JavaScript SDK that simplifies integration with our blockchain services.

### Installation

```bash
npm install @tunemantra/blockchain-sdk
# or
yarn add @tunemantra/blockchain-sdk
```

### Usage

```javascript
import { TuneMantraBlockchain } from '@tunemantra/blockchain-sdk';

// Initialize the SDK
const blockchain = new TuneMantraBlockchain({
  apiUrl: 'https://api.tunemantra.com/v1',
  token: 'your_jwt_token'
});

// Register rights
const registerRights = async () => {
  try {
    const result = await blockchain.registerRights({
      networkId: 'polygon-mumbai',
      contentId: 'track-123456',
      artistId: 'artist-654321',
      rightType: 'master',
      startDate: new Date('2023-01-01'),
      endDate: new Date('2093-01-01'),
      metadata: {
        title: 'My Track',
        genre: 'Electronic',
        isrc: 'USXXX2112345'
      }
    });
    
    console.log('Rights registered:', result);
    return result.rightsId;
  } catch (error) {
    console.error('Error registering rights:', error);
  }
};

// Mint NFT
const mintNFT = async () => {
  try {
    const result = await blockchain.mintNFT({
      networkId: 'polygon-mumbai',
      contentId: 'track-123456',
      artistId: 'artist-654321',
      metadata: {
        name: 'My Track NFT',
        description: 'NFT for My Track by Artist',
        image: 'ipfs://QmImage123456789',
        animation_url: 'ipfs://QmAudio123456789',
        attributes: [
          { trait_type: 'Genre', value: 'Electronic' },
          { trait_type: 'BPM', value: 120 }
        ]
      }
    });
    
    console.log('NFT minted:', result);
    return result.tokenId;
  } catch (error) {
    console.error('Error minting NFT:', error);
  }
};
```

## Server-side Libraries

For server-side integration, we provide libraries for various programming languages.

### Node.js

```bash
npm install @tunemantra/blockchain-node
# or
yarn add @tunemantra/blockchain-node
```

```javascript
const { TuneMantraBlockchain } = require('@tunemantra/blockchain-node');

// Initialize the client
const blockchain = new TuneMantraBlockchain({
  apiUrl: 'https://api.tunemantra.com/v1',
  token: 'your_jwt_token'
});

// Register rights
async function registerRights() {
  try {
    const result = await blockchain.registerRights({
      networkId: 'polygon-mumbai',
      contentId: 'track-123456',
      artistId: 'artist-654321',
      rightType: 'master',
      startDate: new Date('2023-01-01'),
      endDate: new Date('2093-01-01'),
      metadata: {
        title: 'My Track',
        genre: 'Electronic',
        isrc: 'USXXX2112345'
      }
    });
    
    console.log('Rights registered:', result);
    return result.rightsId;
  } catch (error) {
    console.error('Error registering rights:', error);
  }
}

// Call the function
registerRights();
```

### Python

```bash
pip install tunemantra-blockchain
```

```python
from tunemantra_blockchain import TuneMantraBlockchain
from datetime import datetime, timedelta

# Initialize the client
blockchain = TuneMantraBlockchain(
    api_url='https://api.tunemantra.com/v1',
    token='your_jwt_token'
)

# Register rights
def register_rights():
    try:
        start_date = datetime.now()
        end_date = start_date + timedelta(days=365 * 70)  # 70 years
        
        result = blockchain.register_rights(
            network_id='polygon-mumbai',
            content_id='track-123456',
            artist_id='artist-654321',
            right_type='master',
            start_date=start_date,
            end_date=end_date,
            metadata={
                'title': 'My Track',
                'genre': 'Electronic',
                'isrc': 'USXXX2112345'
            }
        )
        
        print('Rights registered:', result)
        return result['rightsId']
    except Exception as e:
        print('Error registering rights:', e)

# Call the function
rights_id = register_rights()
```

## Direct Smart Contract Interaction

For advanced integrations, you can interact directly with our smart contracts.

### Contract Addresses

| Contract | Network | Address |
|----------|---------|---------|
| RightsRegistry | Polygon Mumbai | 0x1234567890123456789012345678901234567890 |
| MusicNFT | Polygon Mumbai | 0x2345678901234567890123456789012345678901 |
| RightsRegistry | Polygon Mainnet | 0x3456789012345678901234567890123456789012 |
| MusicNFT | Polygon Mainnet | 0x4567890123456789012345678901234567890123 |
| RightsRegistry | Ethereum Mainnet | 0x5678901234567890123456789012345678901234 |
| MusicNFT | Ethereum Mainnet | 0x6789012345678901234567890123456789012345 |

### Contract ABIs

The smart contract ABIs are available at:

```
https://api.tunemantra.com/v1/blockchain/contracts/abi/RightsRegistry
https://api.tunemantra.com/v1/blockchain/contracts/abi/MusicNFT
```

### Example with ethers.js

```javascript
const { ethers } = require('ethers');

async function interactWithContracts() {
  // Connect to the network
  const provider = new ethers.providers.JsonRpcProvider('https://rpc-mumbai.maticvigil.com');
  const wallet = new ethers.Wallet('your_private_key', provider);
  
  // Load the contract ABI
  const rightsRegistryAbi = [ /* ABI from API */ ];
  const rightsRegistry = new ethers.Contract(
    '0x1234567890123456789012345678901234567890',
    rightsRegistryAbi,
    wallet
  );
  
  // Register rights
  const contentId = 'track-123456';
  const artistId = 'artist-654321';
  const rightType = 'master';
  const signature = '0x...'; // Generated signature
  const startTime = Math.floor(Date.now() / 1000);
  const endTime = startTime + (60 * 60 * 24 * 365 * 70); // 70 years
  const metadata = JSON.stringify({
    title: 'My Track',
    genre: 'Electronic',
    isrc: 'USXXX2112345'
  });
  
  const tx = await rightsRegistry.registerRights(
    contentId,
    artistId,
    rightType,
    signature,
    startTime,
    endTime,
    metadata
  );
  
  const receipt = await tx.wait();
  console.log('Transaction hash:', receipt.transactionHash);
  
  // Find the RightsRegistered event
  const event = receipt.events.find(e => e.event === 'RightsRegistered');
  const rightsId = event.args.rightsId;
  console.log('Rights ID:', rightsId);
}
```

## Webhook Integration

TuneMantra provides webhooks to notify your application of blockchain events:

1. Set up a webhook endpoint in your application
2. Register this endpoint in the TuneMantra dashboard
3. Configure the event types you want to receive

### Webhook Configuration

```http
POST /webhook/configure
Content-Type: application/json
Authorization: Bearer <your_jwt_token>

{
  "url": "https://your-app.com/webhook/blockchain",
  "events": [
    "rights.registered",
    "rights.verified",
    "nft.minted",
    "transaction.confirmed"
  ],
  "secret": "your_webhook_secret"
}
```

### Webhook Events

Each webhook event includes:

```json
{
  "event": "rights.registered",
  "timestamp": "2023-01-15T12:34:56Z",
  "data": {
    "rightsId": "rights-789012",
    "contentId": "track-123456",
    "artistId": "artist-654321",
    "rightType": "master",
    "transactionHash": "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef",
    "networkId": "polygon-mumbai"
  },
  "signature": "sha256=..."
}
```

### Webhook Verification

To verify webhook authenticity, compute an HMAC signature:

```javascript
const crypto = require('crypto');

function verifyWebhook(body, signature, secret) {
  const hmac = crypto.createHmac('sha256', secret);
  const digest = 'sha256=' + hmac.update(JSON.stringify(body)).digest('hex');
  return crypto.timingSafeEqual(Buffer.from(digest), Buffer.from(signature));
}

// In your webhook handler
app.post('/webhook/blockchain', (req, res) => {
  const signature = req.headers['x-tunemantra-signature'];
  
  if (verifyWebhook(req.body, signature, 'your_webhook_secret')) {
    // Process the webhook
    console.log('Valid webhook:', req.body);
    res.status(200).send('Webhook received');
  } else {
    console.error('Invalid webhook signature');
    res.status(401).send('Invalid signature');
  }
});
```

## IPFS Integration

TuneMantra uses IPFS for decentralized storage of metadata and media files.

### IPFS Structure

```
ipfs://QmXyZ123456789ABCDEF
└── metadata.json
    ├── name: "My Track NFT"
    ├── description: "NFT for My Track by Artist"
    ├── image: "ipfs://QmImage123456789"
    └── animation_url: "ipfs://QmAudio123456789"
```

### Accessing IPFS Content

You can access IPFS content through our gateway:

```
https://ipfs.tunemantra.com/ipfs/QmXyZ123456789ABCDEF
```

Or through public IPFS gateways:

```
https://ipfs.io/ipfs/QmXyZ123456789ABCDEF
https://gateway.pinata.cloud/ipfs/QmXyZ123456789ABCDEF
```

## Best Practices

### Error Handling

Implement robust error handling for blockchain interactions:

```javascript
try {
  const result = await blockchain.registerRights({
    // parameters
  });
  
  // Success handling
} catch (error) {
  // Check error type
  if (error.code === 'NETWORK_ERROR') {
    // Network issue - retry with exponential backoff
    await retryWithBackoff(() => blockchain.registerRights(params));
  } else if (error.code === 'VALIDATION_ERROR') {
    // Input validation error - fix parameters
    console.error('Invalid parameters:', error.details);
  } else if (error.code === 'BLOCKCHAIN_ERROR') {
    // Blockchain transaction error
    console.error('Blockchain error:', error.message);
  } else {
    // General error
    console.error('Unknown error:', error);
  }
}
```

### Rate Limiting

Our API implements rate limiting:

- 100 requests per minute for regular endpoints
- 20 requests per minute for blockchain operations

If you exceed these limits, you'll receive a 429 response:

```json
{
  "error": "Rate limit exceeded",
  "retryAfter": 30
}
```

Implement exponential backoff for retries:

```javascript
async function retryWithBackoff(operation, maxRetries = 5) {
  let retryCount = 0;
  let delay = 1000; // Start with 1s delay
  
  while (retryCount < maxRetries) {
    try {
      return await operation();
    } catch (error) {
      if (error.status === 429) {
        retryCount++;
        console.log(`Rate limited. Retrying in ${delay}ms...`);
        await new Promise(resolve => setTimeout(resolve, delay));
        delay *= 2; // Exponential backoff
      } else {
        throw error; // Rethrow non-rate-limit errors
      }
    }
  }
  
  throw new Error(`Failed after ${maxRetries} retries`);
}
```

### Webhook Reliability

To ensure webhook reliability:

1. **Acknowledge Quickly**: Respond to webhooks with a 200 status code as soon as possible
2. **Process Asynchronously**: Handle the webhook data processing after acknowledgement
3. **Implement Idempotency**: Webhooks may be delivered multiple times - design for idempotency
4. **Verify Signatures**: Always verify webhook signatures
5. **Maintain a Queue**: Keep a queue of unprocessed webhooks with retry logic

```javascript
app.post('/webhook/blockchain', async (req, res) => {
  const signature = req.headers['x-tunemantra-signature'];
  
  // Acknowledge quickly
  if (verifyWebhook(req.body, signature, 'your_webhook_secret')) {
    res.status(200).send('Webhook received');
    
    // Process asynchronously
    processWebhookAsync(req.body).catch(error => {
      console.error('Error processing webhook:', error);
      // Store in error queue for retry
      errorQueue.add(req.body);
    });
  } else {
    res.status(401).send('Invalid signature');
  }
});

async function processWebhookAsync(webhookData) {
  // Check if already processed (idempotency)
  const eventId = webhookData.data.transactionHash;
  const alreadyProcessed = await db.checkEventProcessed(eventId);
  
  if (!alreadyProcessed) {
    // Process the webhook data
    await db.processBlockchainEvent(webhookData);
    
    // Mark as processed
    await db.markEventAsProcessed(eventId);
  }
}
```

## Common Integration Scenarios

### Music Distribution Platform

For a music distribution platform integrating with TuneMantra:

1. **During Track Upload**:
   - Register rights for the uploaded track
   - Store the `rightsId` in your database

2. **After Successfully Distributing to Platforms**:
   - Mint an NFT representing the track
   - Link the NFT to the previously registered rights

3. **For Royalty Distribution**:
   - Verify rights before distributing royalties
   - Use the rights metadata for royalty split calculations

### Rights Verification Service

For a service that verifies music rights:

1. **When Scanning Content**:
   - Query TuneMantra's API to check if rights exist for the content
   - Use the `verifyRights` endpoint to validate the rights

2. **For Reporting**:
   - Maintain a database of verified rights
   - Update status based on webhook notifications

### Music NFT Marketplace

For an NFT marketplace supporting TuneMantra NFTs:

1. **Listing NFTs**:
   - Use the NFT endpoints to get token details
   - Display the associated rights information

2. **During Purchase**:
   - Verify the rights status before completing the purchase
   - Use webhooks to keep the listing updated

## Troubleshooting

### Common Issues

1. **Authentication Errors**
   - Ensure your JWT token is valid and not expired
   - Check that you're using the correct token format

2. **Network Selection Errors**
   - Verify the `networkId` is one of the supported networks
   - Check network status at `/blockchain/networks`

3. **Transaction Failures**
   - Check the blockchain network status
   - Ensure the wallet has sufficient funds
   - Verify input parameters are correctly formatted

4. **Webhook Delivery Issues**
   - Ensure your webhook endpoint is publicly accessible
   - Check for firewall or security settings blocking webhooks
   - Verify your webhook handler is acknowledging webhooks properly

### Support Resources

- **API Status**: Check the API status at https://status.tunemantra.com
- **Documentation**: Full API documentation at https://docs.tunemantra.com
- **Support**: Contact support at blockchain-support@tunemantra.com
- **Developer Forum**: Discuss integration issues at https://community.tunemantra.com/developers

## Related Documents

- [Overview & Architecture](overview-architecture.md)
- [Implementation Guide](implementation-guide.md)
- [Smart Contracts](smart-contracts.md)
- [Testing Guide](testing-guide.md)