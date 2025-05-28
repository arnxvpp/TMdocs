# TuneMantra API Reference

<div align="center">
  <img src="../diagrams/api-overview-diagram.svg" alt="TuneMantra API Overview" width="700" />
</div>

## Overview

The TuneMantra API provides a comprehensive set of endpoints for interacting with all aspects of the platform. This reference document covers authentication, request formats, response handling, error codes, and detailed specifications for each API endpoint.

## API Status

**Completion: 98.75% (Core Backend Services)**

| API Group | Status | Completion % |
|-----------|--------|--------------|
| Authentication | Complete | 100.00% |
| User Management | Complete | 100.00% |
| Content Management | Complete | 100.00% |
| Distribution | Complete | 100.00% |
| Rights Management | Complete | 100.00% |
| Royalty Management | Complete | 100.00% |
| Analytics | Advanced development | 87.50% |
| Payment | Complete | 100.00% |
| Search | Complete | 100.00% |
| Webhooks | Near completion | 95.00% |

## Authentication

The TuneMantra API primarily uses session-based authentication for user interactions, managed by Passport.js on the backend. After a successful login, a secure, HTTP-only session cookie is set. For programmatic access or service-to-service communication, API Key authentication is also supported.

### Authentication Methods

#### Session-Based Authentication (Primary for UI Clients)

-   **Login:** Users authenticate via the `/api/login` endpoint (see below) using username/password.
-   **Session Cookie:** Upon successful login, a session is established, and a cookie is set by the server. This cookie is automatically included by the browser in subsequent requests to API endpoints.
-   **Security:** Cookies are configured to be HTTP-only, SameSite=Lax, and Secure (in production).

#### API Key Authentication (For Programmatic Access)

For service-to-service communication or third-party integrations:
```
X-API-Key: tm_a1b2c3d4e5f6g7h8i9j0...
```
API keys can be generated in the Admin Dashboard and have configurable permissions and expiration. The backend includes middleware to validate these keys.

### User Registration & Password Policy

-   **Endpoint:** `POST /api/register`
-   **Password Validation:** New user passwords submitted during registration are validated against the following policy (implemented in `server/auth.ts` via `validatePassword`):
    -   Minimum length of 10 characters.
    -   Must contain at least one uppercase letter.
    -   Must contain at least one lowercase letter.
    -   Must contain at least one digit.
    -   Must contain at least one special character (non-alphanumeric).

### Role-Based Access Control (RBAC)

Many API endpoints are protected by Role-Based Access Control. The system uses a `hasPermission(userRole, requiredPermission)` function and a `requirePermission(permission)` middleware (defined in `server/auth.ts`) to enforce these rules. Specific permissions required for certain operations will be noted in the endpoint documentation where applicable. User roles include 'admin', 'label', 'artist_manager', 'artist', etc., each with a defined set of permissions.

### Login Endpoint (Session Creation)

```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresAt": "2025-03-24T23:59:59Z",
    "user": {
      "id": 123,
      "email": "user@example.com",
      "name": "John Doe",
      "role": "artist"
    }
  }
}
```

## API Request Format

### Base URL

```
https://api.tunemantra.com/v1
```

### Request Headers

All requests should include:

```
Content-Type: application/json
Accept: application/json
Authorization: Bearer <token> (or X-API-Key for API key auth)
```

Optional headers:

```
X-Request-ID: <unique request identifier>
X-Idempotency-Key: <idempotency key for POST/PUT/DELETE>
```

### Request Parameters

- **Path Parameters**: Part of the URL path (e.g., `/users/{userId}`)
- **Query Parameters**: Appended to the URL (e.g., `?page=1&limit=10`)
- **Request Body**: JSON payload for POST, PUT, and PATCH requests

## API Response Format

All API responses follow a consistent format:

```json
{
  "success": true,
  "data": {
    // Response data specific to the endpoint
  },
  "meta": {
    "requestId": "req_1234567890",
    "timestamp": "2025-03-23T15:23:45Z",
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 100,
      "pages": 10
    }
  }
}
```

For error responses:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "The request data is invalid",
    "details": [
      {
        "field": "email",
        "message": "Must be a valid email address"
      }
    ]
  },
  "meta": {
    "requestId": "req_1234567890",
    "timestamp": "2025-03-23T15:23:45Z"
  }
}
```

## Error Codes

| HTTP Status | Error Code | Description |
|-------------|------------|-------------|
| 400 | BAD_REQUEST | The request is malformed |
| 400 | VALIDATION_ERROR | The request data fails validation |
| 401 | UNAUTHORIZED | Authentication is required |
| 403 | FORBIDDEN | Insufficient permissions |
| 404 | NOT_FOUND | The requested resource does not exist |
| 409 | CONFLICT | The request conflicts with the current state |
| 422 | UNPROCESSABLE_ENTITY | The request is valid but cannot be processed |
| 429 | RATE_LIMITED | Too many requests |
| 500 | SERVER_ERROR | An unexpected server error occurred |
| 503 | SERVICE_UNAVAILABLE | The service is temporarily unavailable |

## Core API Endpoints

### User Management API

#### Get Current User

```http
GET /api/users/me
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 123,
    "email": "user@example.com",
    "name": "John Doe",
    "role": "artist",
    "organizationId": 456,
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2025-03-10T14:25:00Z",
    "settings": {
      "notifications": {
        "email": true,
        "push": true
      },
      "theme": "dark"
    }
  }
}
```

#### List Users

```http
GET /api/organizations/{organizationId}/users?page=1&limit=10&role=artist
```

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": 123,
      "email": "user@example.com",
      "name": "John Doe",
      "role": "artist",
      "createdAt": "2024-01-15T10:30:00Z"
    },
    // Additional users...
  ],
  "meta": {
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 45,
      "pages": 5
    }
  }
}
```

#### Create User

```http
POST /api/organizations/{organizationId}/users
Content-Type: application/json

{
  "email": "newuser@example.com",
  "name": "Jane Smith",
  "role": "manager",
  "password": "securePassword123",
  "settings": {
    "notifications": {
      "email": true,
      "push": false
    }
  }
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 124,
    "email": "newuser@example.com",
    "name": "Jane Smith",
    "role": "manager",
    "organizationId": 456,
    "createdAt": "2025-03-23T15:30:00Z",
    "updatedAt": "2025-03-23T15:30:00Z"
  }
}
```

### Content Management API

#### Get Release

```http
GET /api/releases/{releaseId}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": "rel_123456",
    "title": "Summer Vibes",
    "artistName": "DJ Sunshine",
    "releaseDate": "2025-05-15",
    "upc": "123456789012",
    "status": "approved",
    "coverArtUrl": "https://assets.tunemantra.com/covers/rel_123456.jpg",
    "genre": "Electronic",
    "subGenre": "House",
    "language": "English",
    "tracks": [
      {
        "id": "trk_789012",
        "title": "Beach Party",
        "duration": 195,
        "isrc": "ABCDE1234567",
        "trackNumber": 1,
        "explicit": false
      },
      // Additional tracks...
    ],
    "rightsHolders": [
      {
        "id": "rh_456789",
        "name": "John Doe",
        "role": "Primary Artist",
        "share": 50
      },
      {
        "id": "rh_567890",
        "name": "Jane Smith",
        "role": "Producer",
        "share": 50
      }
    ],
    "distributionStatus": {
      "spotify": "live",
      "appleMusic": "pending",
      "amazonMusic": "processing"
    }
  }
}
```

#### Create Release

```http
POST /api/organizations/{organizationId}/releases
Content-Type: application/json

{
  "title": "Summer Vibes",
  "artistName": "DJ Sunshine",
  "releaseDate": "2025-05-15",
  "genre": "Electronic",
  "subGenre": "House",
  "language": "English",
  "tracks": [
    {
      "title": "Beach Party",
      "duration": 195,
      "isrc": "ABCDE1234567",
      "trackNumber": 1,
      "explicit": false,
      "audioFileId": "audio_123456"
    }
  ],
  "rightsHolders": [
    {
      "userId": 123,
      "role": "Primary Artist",
      "share": 50
    },
    {
      "userId": 124,
      "role": "Producer",
      "share": 50
    }
  ],
  "coverArtId": "image_789012"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": "rel_123456",
    "title": "Summer Vibes",
    "status": "draft",
    "createdAt": "2025-03-23T16:00:00Z",
    "updatedAt": "2025-03-23T16:00:00Z"
    // Additional release data...
  }
}
```

### Distribution API

#### Get Distribution Status

```http
GET /api/releases/{releaseId}/distribution
```

Response:

```json
{
  "success": true,
  "data": {
    "releaseId": "rel_123456",
    "status": "partially_distributed",
    "platformStatuses": [
      {
        "platform": "spotify",
        "status": "live",
        "url": "https://open.spotify.com/album/123456",
        "distributedAt": "2025-03-20T10:15:00Z",
        "liveAt": "2025-03-22T00:00:00Z"
      },
      {
        "platform": "appleMusic",
        "status": "pending",
        "scheduledFor": "2025-03-24T00:00:00Z"
      },
      {
        "platform": "amazonMusic",
        "status": "processing",
        "submittedAt": "2025-03-23T09:30:00Z"
      }
    ],
    "issues": []
  }
}
```

#### Create Distribution

```http
POST /api/releases/{releaseId}/distribute
Content-Type: application/json

{
  "platforms": ["spotify", "appleMusic", "amazonMusic", "deezer"],
  "scheduledReleaseDate": "2025-05-15",
  "priority": "standard"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "distributionId": "dist_123456",
    "status": "scheduled",
    "platforms": ["spotify", "appleMusic", "amazonMusic", "deezer"],
    "scheduledReleaseDate": "2025-05-15",
    "estimatedCompletionDate": "2025-05-14T00:00:00Z"
  }
}
```

### Rights Management API

#### Get Rights Information

```http
GET /api/releases/{releaseId}/rights
```

Response:

```json
{
  "success": true,
  "data": {
    "releaseId": "rel_123456",
    "rightsHolders": [
      {
        "id": "rh_456789",
        "userId": 123,
        "name": "John Doe",
        "role": "Primary Artist",
        "share": 50,
        "verified": true,
        "blockchainVerificationId": "0x1234567890abcdef",
        "agreedToTerms": true,
        "agreedAt": "2025-03-15T12:30:00Z"
      },
      {
        "id": "rh_567890",
        "userId": 124,
        "name": "Jane Smith",
        "role": "Producer",
        "share": 50,
        "verified": true,
        "blockchainVerificationId": "0xabcdef1234567890",
        "agreedToTerms": true,
        "agreedAt": "2025-03-15T14:45:00Z"
      }
    ],
    "license": {
      "type": "exclusive",
      "territory": "worldwide",
      "startDate": "2025-05-15",
      "endDate": null
    },
    "copyrightOwner": "TuneMantra Records",
    "publishingRights": "TuneMantra Publishing"
  }
}
```

#### Update Rights Holder

```http
PUT /api/releases/{releaseId}/rights/holders/{rightsHolderId}
Content-Type: application/json

{
  "role": "Primary Artist",
  "share": 40
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": "rh_456789",
    "userId": 123,
    "name": "John Doe",
    "role": "Primary Artist",
    "share": 40,
    "verified": true,
    "updatedAt": "2025-03-23T16:30:00Z"
  }
}
```
#### Create Rights Dispute

Creates a new dispute for a specific asset (e.g., release, track).

```http
POST /api/rights/{assetId}/dispute
```
**Path Parameters:**
-   `assetId` (string, required): The ID of the asset (e.g., releaseId, trackId) for which the dispute is being created. Must be a positive integer.

**Permissions:** Requires authentication. Users involved (e.g., claimant) must have appropriate roles.

**Request Body:**
```json
{
  "claimantId": 123, // User ID of the claimant
  "defendantId": 456, // User ID of the defendant/respondent
  "description": "Disputing the ownership percentage for track 'XYZ'. Evidence attached.",
  "evidenceUrls": [
    "https://storage.tunemantra.com/evidence/dispute_abc/doc1.pdf",
    "https://storage.tunemantra.com/evidence/dispute_abc/screenshot.png"
  ]
}
```

**Response (Success 201):**
```json
{
  "success": true,
  "data": {
    "id": "disp_789012", // Unique ID of the newly created dispute
    "assetId": "rel_123456", // ID of the asset under dispute
    "assetType": "release", // Type of asset (e.g., 'release', 'track')
    "status": "open", // Initial status of the dispute
    "createdAt": "2025-03-24T10:00:00Z"
  }
}
```

**Response (Error 400 - Validation Error):**
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "The request data is invalid.",
    "details": [
      {
        "field": "body.description",
        "message": "String must contain at least 10 character(s)"
      }
    ]
  },
  "meta": {
    "requestId": "req_abcdef1234",
    "timestamp": "2025-03-24T10:05:00Z"
  }
}
```

**Response (Error 404 - Asset Not Found):**
```json
{
  "success": false,
  "error": {
    "code": "NOT_FOUND",
    "message": "Asset with ID 'non_existent_asset' not found."
  },
  "meta": {
    "requestId": "req_ghijkl5678",
    "timestamp": "2025-03-24T10:10:00Z"
  }
}
```

### Blockchain API

This section details endpoints for interacting with blockchain functionalities, such as registering rights and minting NFTs. These operations typically involve interactions with smart contracts on supported networks (e.g., Ethereum, Polygon).

*(Note: The `registerRightsWithBlockchain` service function, which includes gas optimization and specific logic from the implementation plan, is not yet directly exposed via a distinct API route in the current `server/routes/*` files. The documentation below includes both the existing `/api/blockchain/register-rights` endpoint and a conceptual description for an endpoint that would leverage `registerRightsWithBlockchain`.)*

#### Get Configured Blockchain Networks

Retrieves a list of blockchain networks configured in the system.

```http
GET /api/blockchain/networks
```
**Permissions:** Requires authentication.
**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "mumbai",
      "chainId": 80001,
      "name": "Polygon Mumbai Testnet",
      "rpcUrl": "https://rpc-mumbai.maticvigil.com",
      "explorerUrl": "https://mumbai.polygonscan.com",
      "nftContractAddress": "0x...",
      "rightsContractAddress": "0x..."
    }
    // ... other networks
  ]
}
```

#### Get Specific Blockchain Network Info

Retrieves details for a specific blockchain network.

```http
GET /api/blockchain/networks/{networkId}
```
**Path Parameters:**
-   `networkId` (string, required): The ID of the network (e.g., "mumbai").
**Permissions:** Requires authentication.
**Response:** (Similar to one entry in the `/networks` response)

#### Register Rights on Blockchain (Existing Endpoint)

This endpoint registers rights for an asset on a specified blockchain network using the `blockchainConnector.registerRights` service method.

```http
POST /api/blockchain/register-rights
```
**Permissions:** Requires authentication and active subscription.
**Request Body:**
```json
{
  "assetId": "asset_unique_identifier",
  "assetType": "track", // Enum: 'track', 'album', 'composition', etc.
  "rightsType": "master", // Enum: 'master', 'publishing', etc.
  "ownerType": "artist",  // Enum: 'artist', 'label', etc.
  "ownerId": 123, // Optional: TuneMantra user ID of owner
  "walletAddress": "0xYourWalletAddress", // Blockchain address of the rights owner
  "networkId": "mumbai", // e.g., 'ethereum', 'polygon', 'mumbai'
  "percentage": 100, // Ownership percentage (0.01 to 100)
  "startDate": "2024-01-01T00:00:00Z", // ISO 8601 date string
  "endDate": "2025-01-01T00:00:00Z", // Optional: ISO 8601 date string or null
  "territories": ["US", "CA"], // Optional: Array of territory codes
  "metadata": { "key": "value" } // Optional: Additional metadata
}
```
**Response (Success 201):**
```json
{
  "success": true,
  "data": {
    "rightsId": 1, // ID of the rights record in the database
    "transactionHash": "0xTransactionHash...",
    "error": null // Or error message if blockchain part failed but DB part succeeded
  }
}
```
**Response (Error 400/500):**
```json
{
  "success": false,
  "error": "Error message detailing the failure (e.g., 'Failed to register rights on blockchain')"
}
```

#### Register Rights on Blockchain (Conceptual - using `registerRightsWithBlockchain` service)

This describes a conceptual endpoint that would leverage the `registerRightsWithBlockchain` service function, which includes gas optimization and specific logic from the project's implementation plan.

**Conceptual Endpoint:** `POST /api/v2/blockchain/register-rights-optimized` (Path is illustrative)
**Permissions:** Requires authentication and active subscription.
**Request Body:**
```json
{
  "assetId": "asset_unique_identifier",
  "assetType": "track",
  "rightsType": "master",
  "ownerId": 123, // TuneMantra User ID of the rights owner
  "percentage": 100,
  "territory": "GLOBAL", // Optional, defaults to GLOBAL
  "startDate": "2024-01-01T00:00:00Z",
  "endDate": "2025-01-01T00:00:00Z", // Optional
  "networkId": "mumbai" // Optional, defaults to 'ethereum'
}
```
**Response (Success 201):**
```json
{
  "success": true,
  "data": {
    "transactionHash": "0xTransactionHash...",
    "blockNumber": 1234567,
    "status": "success", // or "failed"
    "gasUsed": "21000",
    "effectiveGasPrice": "50000000000" // Gwei
  }
}
```
**Response (Error 400/500):**
```json
{
  "success": false,
  "data": {
    "transactionHash": null, // or actual hash if tx was sent but failed
    "blockNumber": null,
    "status": "failed",
    "error": "Error message detailing the failure."
  }
}
```

#### Verify Rights on Blockchain

Verifies rights on the blockchain.
```http
POST /api/blockchain/verify-rights
```
**Permissions:** Requires authentication.
**Request Body:**
```json
{
  "rightsId": 1, // Database ID of the rights record
  "walletAddress": "0xVerifierWalletAddress",
  "networkId": "mumbai",
  "signature": "0xSignatureString", // Optional, depending on verification method
  "verificationData": { "notes": "Manual verification complete" } // Optional
}
```
**Response (Success 200):**
```json
{
  "success": true,
  "verified": true, // boolean
  "message": "Rights verification complete",
  "transactionHash": "0xOptionalTransactionHashIfApplicable...",
  "verificationStatus": "verified" // or "failed", "pending"
}
```

#### Mint NFT

Mints an NFT for a given asset.
```http
POST /api/blockchain/nfts/mint
```
**Permissions:** Requires authentication and active subscription.
**Request Body:**
```json
{
  "assetId": "trk_123",
  "ownerAddress": "0xOwnerWalletAddress",
  "metadata": {
    "name": "My Awesome Track NFT",
    "description": "Unlockable content and more!",
    "image": "ipfs://CID_for_image"
  },
  "networkId": "mumbai",
  "userId": 1 // User ID of the minter (usually authenticated user)
}
```
**Response (Success 201):**
```json
{
  "success": true,
  "data": {
    "tokenId": "101",
    "transactionHash": "0xMintTransactionHash..."
  }
}
```

#### Get NFT Details

Retrieves details for a specific NFT.
```http
GET /api/blockchain/nfts/{tokenId}?networkId=mumbai
```
**Path Parameters:**
- `tokenId` (string, required): The ID of the NFT.
**Query Parameters:**
- `networkId` (string, required): The blockchain network ID.
**Permissions:** Requires authentication.
**Response (Success 200):**
```json
{
  "success": true,
  "data": {
    "metadata": "ipfs://CID_for_metadata_json",
    "owner": "0xOwnerWalletAddress"
  }
}
```

#### List User's NFTs or Asset's NFTs

Retrieves NFT tokens. If `assetId` is provided, filters for that asset. Otherwise, lists NFTs related to the authenticated user.
```http
GET /api/blockchain/nfts?assetId={assetId}
```
**Query Parameters:**
- `assetId` (string, optional): Filter NFTs by this asset ID.
**Permissions:** Requires authentication.
**Response (Success 200):** (Array of NFT objects similar to `mintNFT` response but with more details from DB)
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "tokenId": "101",
      "assetId": "trk_123",
      "contractAddress": "0xNftContractAddress",
      "ownerAddress": "0xOwnerWalletAddress",
      "transactionHash": "0xMintTransactionHash...",
      "networkId": "mumbai",
      "metadata": { "...": "..." },
      "mintedBy": 1,
      "status": "active",
      "createdAt": "..."
    }
    // ... other NFTs
  ]
}
```
### AI & Audio Processing API

This section covers endpoints related to AI-powered content analysis and audio processing tasks.

#### Analyze Release Content (Existing Endpoint)

This existing endpoint uses a basic version of content tag generation based on title, artist, and type. (Corresponds to `POST /api/releases/analyze` in `server/routes.ts`).

```http
POST /api/releases/analyze
```
**Permissions:** Requires authentication and active subscription.
**Request Body:**
```json
{
  "title": "Sunset Ballad",
  "artistName": "The Crooners",
  "type": "single" 
}
```
**Response (Success 200):**
```json
{
  "success": true,
  "data": {
    "title": "Sunset Ballad",
    "artistName": "The Crooners",
    "type": "single",
    "contentTags": {
      "genres": ["pop"],
      "moods": ["relaxed"],
      "themes": ["contemporary"],
      "keywords": ["pop", "relaxed"],
      "recommendedPlaylists": ["pop essentials"]
    },
    "aiAnalysis": {
      "summary": "Sunset Ballad by The Crooners is a single with pop elements and a relaxed mood.",
      "qualityScore": 85,
      "contentWarnings": [],
      "suggestedImprovements": []
    }
  }
}
```

#### Generate Content Tags via Advanced AI (Conceptual)

This describes a conceptual endpoint that would leverage the more advanced `generateContentTags` service function (from `server/services/ai-tagging.ts`), which uses GPT-4o for deeper analysis based on textual input and includes fallback/caching logic. This service function is not currently wired to a specific route in `server/routes.ts`.

**Conceptual Endpoint:** `POST /api/ai/generate-tags` (Path is illustrative)
**Permissions:** Requires authentication.
**Request Body:**
```json
{
  "title": "Ocean Dreams",
  "artistName": "DJ Wave",
  "type": "audio" // "audio" or "video"
}
```
**Response (Success 200):**
```json
{
  "success": true,
  "data": {
    "tags": {
      "genres": ["electronic", "ambient"],
      "moods": ["calm", "dreamy"],
      "themes": ["nature", "ocean"],
      "explicit": false,
      "languages": ["instrumental"]
    },
    "analysis": {
      "summary": "Ocean Dreams by DJ Wave is an ambient electronic track...",
      "commercialPotential": {
        "score": 75,
        "analysis": "Good potential for sync in relaxation content..."
      },
      "qualityAssessment": {
        "score": 88,
        "analysis": "High production quality, well-mixed."
      },
      "contentWarnings": [],
      "suggestedPlaylists": ["Chill Vibes", "Deep Focus Electronic"],
      "similarArtists": ["Tycho", "Boards of Canada"],
      "suggestedImprovements": ["Consider adding a subtle rhythmic element for wider appeal."],
      "confidence": 0.95
    }
  }
}
```

#### Process Batch Audio Files (Conceptual)

This describes a conceptual endpoint that would leverage the `processBatchAudio` service function (from `server/services/ai-tagging.ts`) for comprehensive audio processing including metadata extraction, fingerprinting, quality analysis, and format conversion. This service function is not currently wired to a specific route in `server/routes.ts`.

**Conceptual Endpoint:** `POST /api/audio/process-batch` (Path is illustrative)
**Permissions:** Requires authentication, potentially admin level depending on resource intensity.
**Request Body:**
```json
{
  "files": [
    { "path": "/path/to/track1.wav" }, 
    "/path/to/track2.mp3"
  ],
  "options": {
    "concurrency": 4,
    "stopOnError": false,
    "formats": ["mp3_320", "aac_256"]
  }
}
```
**Response (Success 200):** (Response indicates batch job started)
```json
{
  "success": true,
  "data": {
    "batchId": "batch-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "status": "processing",
    "totalFiles": 2,
    "message": "Audio batch processing started."
  }
}
```
**Response (Error 400/500):**
```json
{
  "success": false,
  "error": {
    "code": "BATCH_PROCESSING_ERROR",
    "message": "Failed to initiate batch audio processing."
  }
}
```

### Royalty Management API

#### Get Royalty Overview

```http
GET /api/organizations/{organizationId}/royalties/overview?period=2025-02
```

Response:

```json
{
  "success": true,
  "data": {
    "period": "2025-02",
    "totalEarnings": 12345.67,
    "currency": "USD",
    "platforms": [
      {
        "name": "Spotify",
        "earnings": 5678.90,
        "streams": 1234567,
        "avgPerStream": 0.0046
      },
      {
        "name": "Apple Music",
        "earnings": 3456.78,
        "streams": 456789,
        "avgPerStream": 0.0076
      },
      {
        "name": "Amazon Music",
        "earnings": 2345.67,
        "streams": 345678,
        "avgPerStream": 0.0068
      },
      {
        "name": "Others",
        "earnings": 864.32,
        "streams": 123456,
        "avgPerStream": 0.0070
      }
    ],
    "topReleases": [
      {
        "releaseId": "rel_123456",
        "title": "Summer Vibes",
        "artistName": "DJ Sunshine",
        "earnings": 4567.89,
        "streams": 789012
      },
      // Additional releases...
    ],
    "paymentStatus": "processing",
    "estimatedPaymentDate": "2025-04-15"
  }
}
```

#### Get Detailed Royalty Statement

```http
GET /api/organizations/{organizationId}/royalties/statements/{statementId}
```

Response:

```json
{
  "success": true,
  "data": {
    "statementId": "stmt_123456",
    "period": "2025-02",
    "organizationId": 456,
    "generateDate": "2025-03-15T00:00:00Z",
    "totalEarnings": 12345.67,
    "currency": "USD",
    "status": "paid",
    "paymentDate": "2025-03-20T00:00:00Z",
    "paymentMethod": "Bank Transfer",
    "transactionId": "txn_abcdef123456",
    "releases": [
      {
        "releaseId": "rel_123456",
        "title": "Summer Vibes",
        "artistName": "DJ Sunshine",
        "earnings": 4567.89,
        "platforms": [
          {
            "name": "Spotify",
            "earnings": 2345.67,
            "streams": 456789,
            "countries": [
              {
                "code": "US",
                "earnings": 1234.56,
                "streams": 234567
              },
              // Additional countries...
            ]
          },
          // Additional platforms...
        ],
        "tracks": [
          {
            "trackId": "trk_789012",
            "title": "Beach Party",
            "earnings": 3456.78,
            "streams": 567890
          },
          // Additional tracks...
        ]
      },
      // Additional releases...
    ],
    "deductions": [
      {
        "type": "platform_fee",
        "description": "Platform Service Fee",
        "amount": 1234.57
      },
      {
        "type": "tax_withholding",
        "description": "Tax Withholding (US)",
        "amount": 246.91
      }
    ],
    "payees": [
      {
        "userId": 123,
        "name": "John Doe",
        "role": "Primary Artist",
        "amount": 5432.10,
        "percentage": 50
      },
      {
        "userId": 124,
        "name": "Jane Smith",
        "role": "Producer",
        "amount": 5432.09,
        "percentage": 50
      }
    ]
  }
}
```

### Analytics API

#### Get Performance Overview

```http
GET /api/organizations/{organizationId}/analytics/overview?period=last90days
```

Response:

```json
{
  "success": true,
  "data": {
    "period": "last90days",
    "streams": {
      "total": 12345678,
      "previousPeriod": 9876543,
      "change": 25.0,
      "timeline": [
        {
          "date": "2025-01-01",
          "value": 123456
        },
        // Additional date points...
      ]
    },
    "earnings": {
      "total": 45678.90,
      "previousPeriod": 34567.89,
      "change": 32.1,
      "timeline": [
        {
          "date": "2025-01-01",
          "value": 456.78
        },
        // Additional date points...
      ]
    },
    "platforms": [
      {
        "name": "Spotify",
        "streams": 5678901,
        "earnings": 23456.78,
        "change": 15.4
      },
      // Additional platforms...
    ],
    "topReleases": [
      {
        "releaseId": "rel_123456",
        "title": "Summer Vibes",
        "artistName": "DJ Sunshine",
        "streams": 1234567,
        "earnings": 5678.90
      },
      // Additional releases...
    ],
    "topCountries": [
      {
        "code": "US",
        "name": "United States",
        "streams": 3456789,
        "earnings": 15678.90
      },
      // Additional countries...
    ]
  }
}
```

#### Get Release Analytics

```http
GET /api/releases/{releaseId}/analytics?period=last30days&metrics=streams,earnings,listeners
```

Response:

```json
{
  "success": true,
  "data": {
    "releaseId": "rel_123456",
    "title": "Summer Vibes",
    "period": "last30days",
    "metrics": {
      "streams": {
        "total": 456789,
        "previousPeriod": 345678,
        "change": 32.1,
        "timeline": [
          {
            "date": "2025-02-23",
            "value": 15678
          },
          // Additional date points...
        ]
      },
      "earnings": {
        "total": 2345.67,
        "previousPeriod": 1234.56,
        "change": 90.0,
        "timeline": [
          {
            "date": "2025-02-23",
            "value": 78.90
          },
          // Additional date points...
        ]
      },
      "listeners": {
        "total": 123456,
        "previousPeriod": 98765,
        "change": 25.0,
        "timeline": [
          {
            "date": "2025-02-23",
            "value": 4567
          },
          // Additional date points...
        ]
      }
    },
    "platforms": [
      {
        "name": "Spotify",
        "streams": 234567,
        "earnings": 1234.56,
        "listeners": 78901
      },
      // Additional platforms...
    ],
    "countries": [
      {
        "code": "US",
        "name": "United States",
        "streams": 123456,
        "earnings": 678.90,
        "listeners": 34567
      },
      // Additional countries...
    ],
    "tracks": [
      {
        "trackId": "trk_789012",
        "title": "Beach Party",
        "streams": 345678,
        "earnings": 1789.01,
        "listeners": 98765
      },
      // Additional tracks...
    ]
  }
}
```

### Payment API

#### Get Payment Methods

```http
GET /api/organizations/{organizationId}/payment-methods
```

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": "pm_123456",
      "type": "bank_account",
      "name": "Primary Bank Account",
      "details": {
        "accountHolderName": "TuneMantra Records LLC",
        "bankName": "Global Bank",
        "accountNumberLast4": "1234",
        "routingNumber": "******123",
        "currency": "USD"
      },
      "isDefault": true,
      "createdAt": "2024-05-15T10:30:00Z"
    },
    {
      "id": "pm_234567",
      "type": "paypal",
      "name": "PayPal Account",
      "details": {
        "email": "finance@tunemantrarecords.com"
      },
      "isDefault": false,
      "createdAt": "2024-06-20T14:45:00Z"
    }
  ]
}
```

#### Create Payment Method

```http
POST /api/organizations/{organizationId}/payment-methods
Content-Type: application/json

{
  "type": "bank_account",
  "name": "Secondary Bank Account",
  "details": {
    "accountHolderName": "TuneMantra International LLC",
    "bankName": "World Bank",
    "accountNumber": "9876543210",
    "routingNumber": "987654321",
    "currency": "EUR"
  },
  "isDefault": false
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": "pm_345678",
    "type": "bank_account",
    "name": "Secondary Bank Account",
    "details": {
      "accountHolderName": "TuneMantra International LLC",
      "bankName": "World Bank",
      "accountNumberLast4": "3210",
      "routingNumber": "******321",
      "currency": "EUR"
    },
    "isDefault": false,
    "createdAt": "2025-03-23T17:15:00Z"
  }
}
```

#### Get Withdrawal History

```http
GET /api/organizations/{organizationId}/withdrawals?page=1&limit=10
```

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": "with_123456",
      "amount": 12345.67,
      "currency": "USD",
      "status": "completed",
      "paymentMethodId": "pm_123456",
      "paymentMethodType": "bank_account",
      "paymentMethodDetails": {
        "accountHolderName": "TuneMantra Records LLC",
        "bankName": "Global Bank",
        "accountNumberLast4": "1234"
      },
      "requestedAt": "2025-03-01T10:30:00Z",
      "processedAt": "2025-03-03T15:45:00Z",
      "estimatedArrivalDate": "2025-03-05T00:00:00Z",
      "transactionId": "txn_abcdef123456"
    },
    // Additional withdrawals...
  ],
  "meta": {
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 45,
      "pages": 5
    }
  }
}
```

#### Request Withdrawal

```http
POST /api/organizations/{organizationId}/withdrawals
Content-Type: application/json

{
  "amount": 5000.00,
  "currency": "USD",
  "paymentMethodId": "pm_123456",
  "description": "March 2025 earnings withdrawal"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": "with_234567",
    "amount": 5000.00,
    "currency": "USD",
    "status": "pending",
    "paymentMethodId": "pm_123456",
    "paymentMethodType": "bank_account",
    "paymentMethodDetails": {
      "accountHolderName": "TuneMantra Records LLC",
      "bankName": "Global Bank",
      "accountNumberLast4": "1234"
    },
    "requestedAt": "2025-03-23T17:30:00Z",
    "estimatedProcessingDate": "2025-03-25T00:00:00Z",
    "estimatedArrivalDate": "2025-03-27T00:00:00Z",
    "description": "March 2025 earnings withdrawal"
  }
}
```

## Webhook API

TuneMantra provides webhooks for real-time updates on various events.

### Webhook Events

| Event Type | Description |
|------------|-------------|
| `release.created` | A new release has been created |
| `release.updated` | A release has been updated |
| `release.approved` | A release has been approved for distribution |
| `release.rejected` | A release has been rejected |
| `distribution.started` | Distribution process has started |
| `distribution.completed` | Distribution to all platforms is complete |
| `distribution.failed` | Distribution to one or more platforms failed |
| `platform.status_changed` | Status on a specific platform has changed |
| `royalty.statement_generated` | A new royalty statement has been generated |
| `royalty.payment_initiated` | A royalty payment has been initiated |
| `royalty.payment_completed` | A royalty payment has been completed |
| `user.created` | A new user has been created |
| `user.deleted` | A user has been deleted |
| `payment_method.created` | A new payment method has been added |
| `withdrawal.status_changed` | Status of a withdrawal has changed |

### Webhook Payload Format

```json
{
  "id": "evt_123456789",
  "eventType": "release.approved",
  "timestamp": "2025-03-23T17:45:00Z",
  "data": {
    // Event-specific data
  }
}
```

### Register Webhook Endpoint

```http
POST /api/organizations/{organizationId}/webhooks
Content-Type: application/json

{
  "url": "https://example.com/webhooks/tunemantra",
  "events": ["release.approved", "distribution.completed", "royalty.payment_completed"],
  "description": "Production event handler",
  "secret": "whsec_abcdefghijklmnopqrstuvwxyz"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": "wh_123456",
    "url": "https://example.com/webhooks/tunemantra",
    "events": ["release.approved", "distribution.completed", "royalty.payment_completed"],
    "description": "Production event handler",
    "status": "active",
    "createdAt": "2025-03-23T17:45:00Z"
  }
}
```

## API Rate Limits

TuneMantra API implements rate limiting to ensure fair usage and system stability:

| API Group | Basic Plan | Pro Plan | Enterprise Plan |
|-----------|------------|----------|----------------|
| Authentication | 10/min | 20/min | 50/min |
| User Management | 60/min | 300/min | 1000/min |
| Content Management | 120/min | 600/min | 2000/min |
| Distribution | 60/min | 300/min | 1000/min |
| Rights Management | 60/min | 300/min | 1000/min |
| Royalty Management | 60/min | 300/min | 1000/min |
| Analytics | 120/min | 600/min | 2000/min |
| Payment | 60/min | 300/min | 1000/min |
| Search | 300/min | 1000/min | 3000/min |

Exceeded rate limits return a 429 Too Many Requests response with a Retry-After header.

## API Versioning

The TuneMantra API uses semantic versioning:

- Major version changes (e.g., v1 to v2) may include breaking changes
- Minor version updates are backward compatible
- Current API version: v1

Version is specified in the URL path: `/v1/resources`

## Best Practices

1. **Use Idempotency Keys**: For non-GET requests to prevent duplicate operations
2. **Implement Retry Logic**: With exponential backoff for 5xx errors
3. **Validate Webhook Signatures**: To ensure webhook authenticity
4. **Cache Authentication Tokens**: Until close to expiration to reduce authentication requests
5. **Use Compression**: Set `Accept-Encoding: gzip` for improved performance
6. **Include Request IDs**: In all API calls for easier troubleshooting
7. **Pagination**: Use limit and page parameters for large collections
8. **Filtering**: Use query parameters to filter results

## Development Resources

- **API Playground**: [https://api-playground.tunemantra.com](https://api-playground.tunemantra.com)
- **SDK Libraries**: [https://github.com/tunemantra/api-sdks](https://github.com/tunemantra/api-sdks)
- **API Status**: [https://status.tunemantra.com](https://status.tunemantra.com)

---

*For detailed implementation examples and code snippets, please refer to the [API Implementation Guide](../developer/api-implementation-guide.md) (NOTE: This document is currently missing).*