# 6. API Reference

## API Documentation

## API Documentation

### Overview

TuneMantra's API is built as a RESTful service using Node.js and Express. The API provides endpoints for managing users, tracks, releases, distribution, royalties, and analytics. This documentation outlines the available endpoints, request/response formats, and authentication requirements.

### Base URL

All API endpoints are relative to the base URL of your TuneMantra instance:

- Development: `http://localhost:5000/api`
- Production: `https://your-tunemantra-instance.replit.app/api`

### Authentication

Most API endpoints require authentication. TuneMantra uses session-based authentication for the web interface and API key authentication for programmatic access.

#### Session Authentication

For browser-based interactions, authentication is managed through cookies and sessions:

1. **Login**: `POST /api/auth/login`
2. **Check Status**: `GET /api/auth/status`
3. **Logout**: `POST /api/auth/logout`

#### API Key Authentication

For programmatic access, authentication is managed through API keys:

1. API keys are passed in the `Authorization` header as `Bearer {api_key}`
2. Each API key has specific scopes that limit what operations can be performed
3. API keys can be created, managed, and revoked through the API access endpoints

### Common Response Format

All API endpoints follow a consistent response format:

```json
{
  "data": {}, // The response data (object or array)
  "meta": {   // Meta information (pagination, etc.)
    "page": 1,
    "limit": 20,
    "total": 100
  },
  "error": null // Error information (null if no error)
}
```

Error responses:

```json
{
  "data": null,
  "meta": {},
  "error": {
    "message": "Error message",
    "code": "ERROR_CODE",
    "details": {} // Additional error details (optional)
  }
}
```

### API Endpoints

#### Authentication Endpoints

##### Login

```
POST /api/auth/login
```

Authenticates a user and creates a session.

**Request Body:**
```json
{
  "username": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "data": {
    "id": 1,
    "username": "string",
    "email": "string",
    "fullName": "string",
    "role": "string",
    "status": "string"
  },
  "meta": {},
  "error": null
}
```

##### Register

```
POST /api/auth/register
```

Registers a new user.

**Request Body:**
```json
{
  "username": "string",
  "password": "string",
  "email": "string",
  "fullName": "string",
  "phoneNumber": "string",
  "entityName": "string",
  "role": "string"
}
```

**Response:**
```json
{
  "data": {
    "id": 1,
    "username": "string",
    "email": "string"
  },
  "meta": {},
  "error": null
}
```

##### Check Authentication Status

```
GET /api/auth/status
```

Checks if the user is authenticated and returns user information.

**Response:**
```json
{
  "data": {
    "id": 1,
    "username": "string",
    "email": "string",
    "fullName": "string",
    "role": "string",
    "status": "string"
  },
  "meta": {},
  "error": null
}
```

##### Logout

```
POST /api/auth/logout
```

Logs out the user and destroys the session.

**Response:**
```json
{
  "data": {
    "message": "Logged out successfully"
  },
  "meta": {},
  "error": null
}
```

#### User Management Endpoints

##### List Users

```
GET /api/users
```

Lists users with optional filtering and pagination.

**Query Parameters:**
- `status`: Filter by status (active, pending, etc.)
- `search`: Search term for username, email, etc.
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20)

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "username": "string",
      "email": "string",
      "fullName": "string",
      "role": "string",
      "status": "string",
      "createdAt": "string"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100
  },
  "error": null
}
```

##### Get User by ID

```
GET /api/users/:id
```

Retrieves a specific user by ID.

**Response:**
```json
{
  "data": {
    "id": 1,
    "username": "string",
    "email": "string",
    "fullName": "string",
    "phoneNumber": "string",
    "entityName": "string",
    "avatarUrl": "string",
    "role": "string",
    "status": "string",
    "createdAt": "string",
    "updatedAt": "string"
  },
  "meta": {},
  "error": null
}
```

##### Update User

```
PATCH /api/users/:id
```

Updates a user's information.

**Request Body:**
```json
{
  "fullName": "string",
  "phoneNumber": "string",
  "entityName": "string",
  "status": "string"
}
```

**Response:**
```json
{
  "data": {
    "id": 1,
    "username": "string",
    "email": "string",
    "fullName": "string",
    "status": "string",
    "updatedAt": "string"
  },
  "meta": {},
  "error": null
}
```

#### API Key Management

##### List API Keys

```
GET /api/api-keys
```

Lists API keys for the authenticated user.

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "string",
      "key": "string",
      "scopes": ["string"],
      "createdAt": "string",
      "lastUsed": "string",
      "expiresAt": "string",
      "isActive": true
    }
  ],
  "meta": {},
  "error": null
}
```

##### Create API Key

```
POST /api/api-keys
```

Creates a new API key for the authenticated user.

**Request Body:**
```json
{
  "name": "string",
  "scopes": ["string"],
  "expiresAt": "string"
}
```

**Response:**
```json
{
  "data": {
    "id": 1,
    "name": "string",
    "key": "string",
    "scopes": ["string"],
    "createdAt": "string",
    "expiresAt": "string",
    "isActive": true
  },
  "meta": {},
  "error": null
}
```

##### Delete API Key

```
DELETE /api/api-keys/:id
```

Deletes an API key.

**Response:**
```json
{
  "data": {
    "message": "API key deleted successfully"
  },
  "meta": {},
  "error": null
}
```

#### Track Management

##### List Tracks by User

```
GET /api/users/:userId/tracks
```

Lists tracks for a specific user.

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "title": "string",
      "artist": "string",
      "artistName": "string",
      "genre": "string",
      "releaseDate": "string",
      "status": "string",
      "isrc": "string",
      "duration": 180,
      "createdAt": "string",
      "updatedAt": "string"
    }
  ],
  "meta": {},
  "error": null
}
```

##### Get Track by ID

```
GET /api/tracks/:id
```

Retrieves a specific track by ID.

**Response:**
```json
{
  "data": {
    "id": 1,
    "title": "string",
    "artist": "string",
    "artistName": "string",
    "genre": "string",
    "releaseDate": "string",
    "status": "string",
    "isrc": "string",
    "duration": 180,
    "metadata": {},
    "createdAt": "string",
    "updatedAt": "string"
  },
  "meta": {},
  "error": null
}
```

##### Create Track

```
POST /api/tracks
```

Creates a new track.

**Request Body:**
```json
{
  "releaseId": 1,
  "title": "string",
  "artist": "string",
  "artistName": "string",
  "genre": "string",
  "releaseDate": "string",
  "isrc": "string",
  "duration": 180,
  "metadata": {}
}
```

**Response:**
```json
{
  "data": {
    "id": 1,
    "title": "string",
    "artist": "string",
    "artistName": "string",
    "genre": "string",
    "releaseDate": "string",
    "status": "string",
    "isrc": "string",
    "duration": 180,
    "createdAt": "string",
    "updatedAt": "string"
  },
  "meta": {},
  "error": null
}
```

##### Update Track

```
PATCH /api/tracks/:id
```

Updates a track.

**Request Body:**
```json
{
  "title": "string",
  "artist": "string",
  "artistName": "string",
  "genre": "string",
  "releaseDate": "string",
  "isrc": "string",
  "duration": 180,
  "metadata": {}
}
```

**Response:**
```json
{
  "data": {
    "id": 1,
    "title": "string",
    "artist": "string",
    "artistName": "string",
    "genre": "string",
    "releaseDate": "string",
    "status": "string",
    "isrc": "string",
    "duration": 180,
    "updatedAt": "string"
  },
  "meta": {},
  "error": null
}
```

#### Release Management

##### List Releases by User

```
GET /api/users/:userId/releases
```

Lists releases for a specific user.

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "title": "string",
      "artistName": "string",
      "labelName": "string",
      "upc": "string",
      "genre": "string",
      "language": "string",
      "status": "string",
      "type": "string",
      "releaseDate": "string",
      "createdAt": "string",
      "updatedAt": "string"
    }
  ],
  "meta": {},
  "error": null
}
```

##### Get Release by ID

```
GET /api/releases/:id
```

Retrieves a specific release by ID.

**Response:**
```json
{
  "data": {
    "id": 1,
    "title": "string",
    "artistName": "string",
    "labelName": "string",
    "upc": "string",
    "genre": "string",
    "language": "string",
    "description": "string",
    "status": "string",
    "type": "string",
    "releaseDate": "string",
    "contentTags": {},
    "aiAnalysis": {},
    "createdAt": "string",
    "updatedAt": "string"
  },
  "meta": {},
  "error": null
}
```

##### Create Release

```
POST /api/releases
```

Creates a new release.

**Request Body:**
```json
{
  "title": "string",
  "artistName": "string",
  "labelName": "string",
  "upc": "string",
  "genre": "string",
  "language": "string",
  "description": "string",
  "type": "string",
  "releaseDate": "string"
}
```

**Response:**
```json
{
  "data": {
    "id": 1,
    "title": "string",
    "artistName": "string",
    "labelName": "string",
    "upc": "string",
    "genre": "string",
    "language": "string",
    "description": "string",
    "status": "string",
    "type": "string",
    "releaseDate": "string",
    "createdAt": "string",
    "updatedAt": "string"
  },
  "meta": {},
  "error": null
}
```

##### Update Release

```
PATCH /api/releases/:id
```

Updates a release.

**Request Body:**
```json
{
  "title": "string",
  "artistName": "string",
  "labelName": "string",
  "genre": "string",
  "language": "string",
  "description": "string",
  "status": "string",
  "releaseDate": "string"
}
```

**Response:**
```json
{
  "data": {
    "id": 1,
    "title": "string",
    "artistName": "string",
    "labelName": "string",
    "upc": "string",
    "genre": "string",
    "language": "string",
    "description": "string",
    "status": "string",
    "type": "string",
    "releaseDate": "string",
    "updatedAt": "string"
  },
  "meta": {},
  "error": null
}
```

#### Distribution Management

##### List Distribution Platforms

```
GET /api/distribution/platforms
```

Lists available distribution platforms.

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "string",
      "status": "string",
      "deliveryMethod": "string",
      "settings": {}
    }
  ],
  "meta": {},
  "error": null
}
```

##### Distribute Release

```
POST /api/distribution/release/:releaseId
```

Distributes a release to one or more platforms.

**Request Body:**
```json
{
  "platformIds": [1, 2, 3]
}
```

**Response:**
```json
{
  "data": {
    "message": "Distribution initiated",
    "distributionIds": [1, 2, 3]
  },
  "meta": {},
  "error": null
}
```

##### Get Distribution Status

```
GET /api/distribution/status/:releaseId
```

Gets the distribution status for a release.

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "releaseId": 1,
      "platformId": 1,
      "platformName": "string",
      "status": "string",
      "platformReleaseId": "string",
      "platformUrl": "string",
      "errorDetails": "string",
      "distributedAt": "string"
    }
  ],
  "meta": {},
  "error": null
}
```

#### Analytics Management

##### Get Track Analytics

```
GET /api/analytics/tracks/:trackId
```

Gets analytics data for a track.

**Query Parameters:**
- `startDate`: Start date for filtering (YYYY-MM-DD)
- `endDate`: End date for filtering (YYYY-MM-DD)
- `platform`: Filter by platform

**Response:**
```json
{
  "data": {
    "summary": {
      "totalStreams": 10000,
      "totalRevenue": 100.5,
      "topPlatforms": ["string"],
      "topCountries": ["string"]
    },
    "timeSeries": [
      {
        "date": "string",
        "streams": 500,
        "revenue": 5.25
      }
    ],
    "platforms": [
      {
        "name": "string",
        "streams": 4000,
        "revenue": 45.2,
        "percentage": 40
      }
    ],
    "countries": [
      {
        "name": "string",
        "streams": 2500,
        "revenue": 28.75,
        "percentage": 25
      }
    ]
  },
  "meta": {},
  "error": null
}
```

##### Get Release Analytics

```
GET /api/analytics/releases/:releaseId
```

Gets analytics data for a release.

**Query Parameters:**
- `startDate`: Start date for filtering (YYYY-MM-DD)
- `endDate`: End date for filtering (YYYY-MM-DD)
- `platform`: Filter by platform

**Response:**
```json
{
  "data": {
    "summary": {
      "totalStreams": 25000,
      "totalRevenue": 250.75,
      "topTracks": ["string"],
      "topPlatforms": ["string"],
      "topCountries": ["string"]
    },
    "timeSeries": [
      {
        "date": "string",
        "streams": 1200,
        "revenue": 12.6
      }
    ],
    "tracks": [
      {
        "id": 1,
        "title": "string",
        "streams": 8000,
        "revenue": 84,
        "percentage": 32
      }
    ],
    "platforms": [
      {
        "name": "string",
        "streams": 10000,
        "revenue": 105,
        "percentage": 40
      }
    ],
    "countries": [
      {
        "name": "string",
        "streams": 6250,
        "revenue": 65.62,
        "percentage": 25
      }
    ]
  },
  "meta": {},
  "error": null
}
```

##### Get Dashboard Analytics

```
GET /api/analytics/dashboard
```

Gets dashboard analytics for the authenticated user.

**Response:**
```json
{
  "data": {
    "summary": {
      "totalStreams": 100000,
      "totalRevenue": 1050,
      "revenueChange": 5.2,
      "streamChange": 8.5
    },
    "topReleases": [
      {
        "id": 1,
        "title": "string",
        "streams": 25000,
        "revenue": 262.5
      }
    ],
    "topTracks": [
      {
        "id": 1,
        "title": "string",
        "streams": 12000,
        "revenue": 126
      }
    ],
    "revenueTimeSeries": [
      {
        "date": "string",
        "revenue": 52.5
      }
    ],
    "streamTimeSeries": [
      {
        "date": "string",
        "streams": 5000
      }
    ],
    "platformBreakdown": [
      {
        "platform": "string",
        "streams": 40000,
        "revenue": 420,
        "percentage": 40
      }
    ],
    "countryBreakdown": [
      {
        "country": "string",
        "streams": 25000,
        "revenue": 262.5,
        "percentage": 25
      }
    ]
  },
  "meta": {},
  "error": null
}
```

#### Royalty Management

##### List Royalty Calculations

```
GET /api/royalties/calculations
```

Lists royalty calculations for the authenticated user.

**Query Parameters:**
- `startDate`: Start date for filtering (YYYY-MM-DD)
- `endDate`: End date for filtering (YYYY-MM-DD)
- `status`: Filter by status

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "trackId": 1,
      "releaseId": 1,
      "period": "string",
      "startDate": "string",
      "endDate": "string",
      "totalStreams": 5000,
      "totalRevenue": 52.5,
      "status": "string",
      "createdAt": "string",
      "updatedAt": "string"
    }
  ],
  "meta": {},
  "error": null
}
```

##### Process Royalty Calculation

```
POST /api/royalties/process
```

Triggers royalty calculation processing.

**Request Body:**
```json
{
  "trackIds": [1, 2, 3],
  "releaseId": 1,
  "startDate": "string",
  "endDate": "string",
  "forceRecalculation": false
}
```

**Response:**
```json
{
  "data": {
    "message": "Royalty calculation initiated",
    "jobId": 1
  },
  "meta": {},
  "error": null
}
```

##### Get Royalty Splits for Release

```
GET /api/royalties/splits/:releaseId
```

Gets royalty splits for a release.

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "releaseId": 1,
      "trackId": 1,
      "userId": 1,
      "username": "string",
      "role": "string",
      "sharePercent": 50
    }
  ],
  "meta": {},
  "error": null
}
```

##### Update Royalty Splits

```
PUT /api/royalties/splits/:releaseId
```

Updates royalty splits for a release.

**Request Body:**
```json
{
  "splits": [
    {
      "userId": 1,
      "role": "string",
      "sharePercent": 50
    },
    {
      "userId": 2,
      "role": "string",
      "sharePercent": 50
    }
  ]
}
```

**Response:**
```json
{
  "data": {
    "message": "Royalty splits updated successfully"
  },
  "meta": {},
  "error": null
}
```

#### Payment Management

##### List Payment Methods

```
GET /api/payments/methods
```

Lists payment methods for the authenticated user.

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "type": "string",
      "name": "string",
      "details": {},
      "isDefault": true,
      "isVerified": true,
      "createdAt": "string",
      "updatedAt": "string"
    }
  ],
  "meta": {},
  "error": null
}
```

##### Create Payment Method

```
POST /api/payments/methods
```

Creates a new payment method for the authenticated user.

**Request Body:**
```json
{
  "type": "string",
  "name": "string",
  "details": {},
  "isDefault": true
}
```

**Response:**
```json
{
  "data": {
    "id": 1,
    "type": "string",
    "name": "string",
    "details": {},
    "isDefault": true,
    "isVerified": false,
    "createdAt": "string",
    "updatedAt": "string"
  },
  "meta": {},
  "error": null
}
```

##### List Withdrawals

```
GET /api/payments/withdrawals
```

Lists withdrawal requests for the authenticated user.

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "amount": 100,
      "currency": "string",
      "status": "string",
      "processedAt": "string",
      "notes": "string",
      "createdAt": "string",
      "updatedAt": "string"
    }
  ],
  "meta": {},
  "error": null
}
```

##### Create Withdrawal Request

```
POST /api/payments/withdrawals
```

Creates a new withdrawal request.

**Request Body:**
```json
{
  "paymentMethodId": 1,
  "amount": 100,
  "currency": "string",
  "notes": "string"
}
```

**Response:**
```json
{
  "data": {
    "id": 1,
    "amount": 100,
    "currency": "string",
    "status": "string",
    "notes": "string",
    "createdAt": "string",
    "updatedAt": "string"
  },
  "meta": {},
  "error": null
}
```

### Error Codes

The API uses standardized error codes to indicate different types of errors:

| Code | Description |
|------|-------------|
| `AUTH_REQUIRED` | Authentication is required for this endpoint |
| `INVALID_CREDENTIALS` | Invalid username or password |
| `PERMISSION_DENIED` | User does not have permission for this operation |
| `RESOURCE_NOT_FOUND` | The requested resource was not found |
| `VALIDATION_ERROR` | The request data failed validation |
| `DUPLICATE_ENTRY` | A resource with the same unique identifier already exists |
| `RATE_LIMIT_EXCEEDED` | Too many requests have been made in a short time |
| `INTERNAL_ERROR` | An unexpected error occurred on the server |

### Pagination

Endpoints that return lists of items support pagination through query parameters:

- `page`: The page number to retrieve (default: 1)
- `limit`: The number of items per page (default: 20)

The response includes pagination metadata:

```json
{
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

### Filtering and Sorting

Many list endpoints support filtering and sorting through query parameters:

- `sort`: Field to sort by (e.g., `createdAt`)
- `order`: Sort order (`asc` or `desc`)
- `status`: Filter by status
- `search`: Search term for text fields
- `startDate`: Filter by date range start
- `endDate`: Filter by date range end

### Rate Limiting

The API implements rate limiting to prevent abuse:

- Rate limits are applied per user/API key
- Limits are higher for authenticated users than anonymous requests
- When rate limited, the API returns a 429 Too Many Requests status with a Retry-After header

### Webhook Notifications

TuneMantra supports webhooks for real-time notifications of events:

- Distribution status changes
- Royalty calculation completions
- New analytics data available
- Payment status updates

Webhooks can be configured in the user settings or via the API.

*Source: /home/runner/workspace/.archive/archive_docs/doc_backup/api-docs.md*

---

## TuneMantra API Reference

## TuneMantra API Reference

<div align="center">
  <img src="../../diagrams/api-reference-header.svg" alt="TuneMantra API Reference" width="800"/>
</div>

### Introduction

This document provides a comprehensive reference for TuneMantra's API endpoints, request/response formats, authentication methods, and usage guidelines. TuneMantra's API follows RESTful principles and uses standard HTTP methods and status codes. The API is versioned to ensure backward compatibility as the platform evolves.

This documentation is intended for developers integrating with TuneMantra, building custom applications, or extending the platform's functionality.

### Table of Contents

- [API Overview](#api-overview)
- [Authentication](#authentication)
- [Common Conventions](#common-conventions)
- [Error Handling](#error-handling)
- [Rate Limiting](#rate-limiting)
- [Resource Endpoints](#resource-endpoints)
- [Webhook Events](#webhook-events)
- [API Versioning](#api-versioning)
- [Advanced Usage](#advanced-usage)

### API Overview

#### Base URL

All API requests should be directed to the following base URL:

```
https://api.tunemantra.com/v1
```

For sandbox testing:

```
https://api-sandbox.tunemantra.com/v1
```

#### API Design Principles

TuneMantra's API follows these core design principles:

1. **RESTful Design**
   - Resource-oriented URLs
   - Appropriate HTTP methods
   - Standard status codes
   - Hypermedia links where appropriate

2. **Consistency**
   - Uniform request/response formats
   - Standard error patterns
   - Predictable parameter naming
   - Consistent pagination

3. **Security-First Approach**
   - Authentication for all requests
   - Least privilege principle
   - Rate limiting and throttling
   - Data validation and sanitization

4. **Developer Experience**
   - Comprehensive documentation
   - Predictable behavior
   - Helpful error messages
   - SDK support for major languages

#### SDK Support

Official SDKs are available for:

- JavaScript/TypeScript
- Python
- PHP
- Ruby
- Java
- C#

SDKs and code examples can be found in the [Developer Portal](https://developers.tunemantra.com).

### Authentication

TuneMantra's API supports several authentication methods:

#### API Key Authentication

For server-to-server integrations:

```http
GET /api/v1/tracks
X-API-Key: your_api_key_here
```

API keys should be kept secure and never exposed in client-side code.

#### OAuth 2.0

For user-authorized access:

1. **Authorization Code Flow**
   - Used for web applications
   - Requires redirect URL
   - Returns access and refresh tokens

2. **Implicit Flow**
   - Used for single-page applications
   - No refresh tokens
   - Shorter token lifetimes

3. **Client Credentials Flow**
   - Used for service-to-service authentication
   - No user involvement
   - Limited to specific scopes

#### Token Usage

Once obtained, access tokens should be included in the `Authorization` header:

```http
GET /api/v1/releases
Authorization: Bearer your_access_token_here
```

#### Token Lifetimes

- Access Tokens: 1 hour
- Refresh Tokens: 30 days
- API Keys: Until revoked

#### Scopes

OAuth tokens are issued with specific scopes that limit their access:

| Scope | Description |
|-------|-------------|
| `read:tracks` | View track information |
| `write:tracks` | Create and modify tracks |
| `read:releases` | View release information |
| `write:releases` | Create and modify releases |
| `read:analytics` | View analytics data |
| `read:royalties` | View royalty information |
| `read:rights` | View rights information |
| `write:rights` | Modify rights information |
| `read:distribution` | View distribution information |
| `write:distribution` | Create and modify distributions |
| `read:users` | View user information (admin only) |
| `write:users` | Modify user information (admin only) |

### Common Conventions

#### Date Format

All dates and timestamps use ISO 8601 format:

- Dates: `YYYY-MM-DD`
- Timestamps: `YYYY-MM-DDTHH:MM:SSZ`

#### Request Bodies

For `POST` and `PUT` requests, request bodies should be JSON-formatted:

```http
POST /api/v1/tracks
Content-Type: application/json

{
  "title": "My New Track",
  "primaryArtist": "Artist Name",
  "primaryGenre": "Pop"
}
```

#### Response Format

API responses follow a consistent structure:

```json
{
  "success": true,
  "data": {
    "id": 12345,
    "title": "My New Track",
    "primaryArtist": "Artist Name",
    "createdAt": "2023-01-15T08:30:00Z"
  },
  "meta": {
    "requestId": "req_abc123",
    "timestamp": "2023-01-15T08:30:01Z"
  }
}
```

For error responses:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "The request could not be processed",
    "details": [
      {
        "field": "title",
        "message": "Title is required",
        "code": "REQUIRED_FIELD"
      }
    ]
  },
  "meta": {
    "requestId": "req_abc123",
    "timestamp": "2023-01-15T08:30:01Z"
  }
}
```

#### Pagination

List endpoints support pagination with consistent parameters:

```http
GET /api/v1/tracks?limit=20&page=2
```

Pagination parameters:

- `page`: The page number (starts at 1)
- `limit`: Number of items per page (default 20, max 100)

Pagination metadata is included in the response:

```json
{
  "success": true,
  "data": [...],
  "meta": {
    "pagination": {
      "total": 567,
      "pages": 29,
      "page": 2,
      "limit": 20,
      "prev": "/api/v1/tracks?limit=20&page=1",
      "next": "/api/v1/tracks?limit=20&page=3"
    }
  }
}
```

#### Filtering

Most list endpoints support filtering with query parameters:

```http
GET /api/v1/tracks?status=active&primaryGenre=rock&createdAfter=2023-01-01
```

Common filter parameters:

- `status`: Filter by item status
- `createdAfter`: Items created after this date
- `createdBefore`: Items created before this date
- `updatedAfter`: Items updated after this date
- `updatedBefore`: Items updated before this date

Endpoint-specific filters are documented with each endpoint.

#### Sorting

List endpoints support sorting with the `sort` parameter:

```http
GET /api/v1/tracks?sort=createdAt:desc
```

Multiple sort fields can be comma-separated:

```http
GET /api/v1/tracks?sort=primaryGenre:asc,createdAt:desc
```

#### Field Selection

To reduce payload size, you can request specific fields:

```http
GET /api/v1/tracks?fields=id,title,primaryArtist,createdAt
```

#### Expanding Relations

Some endpoints support expanding related data using the `expand` parameter:

```http
GET /api/v1/tracks?expand=release,rights
```

### Error Handling

TuneMantra's API uses standard HTTP status codes and structured error responses:

#### HTTP Status Codes

- `200 OK`: Successful request
- `201 Created`: Resource created successfully
- `204 No Content`: Successful request with no response body
- `400 Bad Request`: Invalid request (e.g., validation error)
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Permission denied
- `404 Not Found`: Resource not found
- `409 Conflict`: Request conflicts with current state
- `422 Unprocessable Entity`: Semantic errors (e.g., business rule violation)
- `429 Too Many Requests`: Rate limit exceeded
- `500 Internal Server Error`: Server-side error
- `503 Service Unavailable`: Service temporarily unavailable

#### Error Types

Error responses include a code that identifies the type of error:

| Error Code | Description |
|------------|-------------|
| `AUTHENTICATION_ERROR` | Problems with authentication |
| `AUTHORIZATION_ERROR` | Insufficient permissions |
| `VALIDATION_ERROR` | Invalid input data |
| `RESOURCE_NOT_FOUND` | Requested resource doesn't exist |
| `RATE_LIMIT_EXCEEDED` | Too many requests |
| `BUSINESS_RULE_VIOLATION` | Valid request that violates business rules |
| `CONFLICT_ERROR` | Request conflicts with current state |
| `INTEGRATION_ERROR` | Error with third-party service |
| `SYSTEM_ERROR` | Unexpected server error |

#### Error Handling Best Practices

1. **Check HTTP Status Codes**
   - Always check the HTTP status code first
   - Handle each status code category appropriately

2. **Parse Error Details**
   - Extract detailed error information
   - Handle field-specific validation errors

3. **Implement Retry Logic**
   - Retry after delay for 429 responses
   - Use exponential backoff
   - Respect Retry-After headers

4. **Log Error Information**
   - Include request ID in logs
   - Log full error details for debugging

### Rate Limiting

To ensure fair usage, the API implements rate limiting:

#### Rate Limit Headers

Rate limit information is included in response headers:

```
X-RateLimit-Limit: 5000
X-RateLimit-Remaining: 4985
X-RateLimit-Reset: 1682612725
```

When the rate limit is exceeded, a `429 Too Many Requests` response is returned with a `Retry-After` header indicating the number of seconds to wait.

#### Rate Limit Tiers

Rate limits vary by API plan:

| Plan | Rate Limit (requests per hour) |
|------|--------------------------------|
| Developer | 1,000 |
| Professional | 5,000 |
| Enterprise | 20,000 |
| Custom | Negotiated |

#### Reducing Rate Limit Impact

1. **Implement Caching**
   - Cache frequently accessed data
   - Respect Cache-Control headers

2. **Batch Operations**
   - Use bulk endpoints where available
   - Combine related requests

3. **Optimize Requests**
   - Use field selection to reduce payload size
   - Minimize webhook registrations

### Resource Endpoints

#### User Management

##### Get Current User

Retrieves the authenticated user's profile.

```http
GET /api/v1/users/me
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 12345,
    "username": "johndoe",
    "email": "john.doe@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "role": "artist",
    "status": "active",
    "createdAt": "2023-01-15T08:30:00Z",
    "profileImageUrl": "https://assets.tunemantra.com/profiles/12345.jpg"
  }
}
```

##### Update User Profile

Updates the authenticated user's profile information.

```http
PATCH /api/v1/users/me
Content-Type: application/json

{
  "firstName": "Arnav",
  "lastName": "Raj",
  "profileImageUrl": "https://assets.tunemantra.com/profiles/new-image.jpg"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 12345,
    "username": "johndoe",
    "email": "john.doe@example.com",
    "firstName": "John",
    "lastName": "Smith",
    "role": "artist",
    "status": "active",
    "createdAt": "2023-01-15T08:30:00Z",
    "updatedAt": "2023-01-16T10:45:00Z",
    "profileImageUrl": "https://assets.tunemantra.com/profiles/new-image.jpg"
  }
}
```

##### List Arnav Raj Members

Lists all members of the user's Arnav Raj.

```http
GET /api/v1/Arnav Rajs/members
```

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": 12346,
      "userId": 12346,
      "role": "admin",
      "firstName": "Jane",
      "lastName": "Smith",
      "email": "jane.smith@example.com",
      "status": "active",
      "joinedAt": "2023-01-10T14:30:00Z"
    },
    {
      "id": 12347,
      "userId": 12347,
      "role": "member",
      "firstName": "Bob",
      "lastName": "Johnson",
      "email": "bob.johnson@example.com",
      "status": "active",
      "joinedAt": "2023-01-12T09:15:00Z"
    }
  ],
  "meta": {
    "pagination": {
      "total": 2,
      "pages": 1,
      "page": 1,
      "limit": 20
    }
  }
}
```

##### Invite Arnav Raj Member

Invites a new member to the Arnav Raj.

```http
POST /api/v1/Arnav Rajs/members/invite
Content-Type: application/json

{
  "email": "new.member@example.com",
  "role": "member",
  "permissions": ["read:analytics", "read:tracks"]
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": "inv_123abc",
    "email": "new.member@example.com",
    "role": "member",
    "permissions": ["read:analytics", "read:tracks"],
    "status": "pending",
    "expiresAt": "2023-02-16T10:45:00Z"
  }
}
```

#### Tracks

##### List Tracks

Retrieves a list of tracks for the authenticated user.

```http
GET /api/v1/tracks
```

Optional query parameters:
- `status`: Filter by status (draft, active, inactive)
- `search`: Search term for track title or artist
- `primaryGenre`: Filter by primary genre
- `releasedAfter`: Filter by release date
- `releasedBefore`: Filter by release date

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": 1001,
      "title": "Summer Breeze",
      "primaryArtist": "John Doe",
      "isrc": "USX123456789",
      "primaryGenre": "Pop",
      "duration": 217,
      "releaseDate": "2023-01-15",
      "status": "active",
      "coverArtUrl": "https://assets.tunemantra.com/tracks/1001.jpg",
      "createdAt": "2022-12-10T15:30:00Z"
    },
    {
      "id": 1002,
      "title": "Midnight Dreams",
      "primaryArtist": "John Doe",
      "isrc": "USX223456789",
      "primaryGenre": "Electronic",
      "duration": 195,
      "releaseDate": "2023-01-20",
      "status": "active",
      "coverArtUrl": "https://assets.tunemantra.com/tracks/1002.jpg",
      "createdAt": "2022-12-15T12:45:00Z"
    }
  ],
  "meta": {
    "pagination": {
      "total": 15,
      "pages": 8,
      "page": 1,
      "limit": 2,
      "next": "/api/v1/tracks?page=2&limit=2"
    }
  }
}
```

##### Get Track

Retrieves a specific track by ID.

```http
GET /api/v1/tracks/1001
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 1001,
    "title": "Summer Breeze",
    "primaryArtist": "John Doe",
    "featuredArtists": [],
    "isrc": "USX123456789",
    "primaryGenre": "Pop",
    "secondaryGenres": ["Electronic", "Chill"],
    "duration": 217,
    "releaseDate": "2023-01-15",
    "recordingDate": "2022-11-05",
    "language": "English",
    "explicit": false,
    "bpm": 120,
    "key": "C Major",
    "moods": ["Happy", "Relaxed", "Uplifting"],
    "tags": ["Summer", "Beach", "Vacation"],
    "lyrics": "Here are the lyrics...",
    "description": "A summer anthem with tropical vibes...",
    "audioFileUrl": "https://assets.tunemantra.com/audio/1001.mp3",
    "waveformUrl": "https://assets.tunemantra.com/waveforms/1001.json",
    "coverArtUrl": "https://assets.tunemantra.com/tracks/1001.jpg",
    "status": "active",
    "createdAt": "2022-12-10T15:30:00Z",
    "updatedAt": "2023-01-02T09:15:00Z",
    "composers": ["John Doe", "Jane Smith"],
    "lyricists": ["John Doe"],
    "producers": ["Bob Producer"],
    "royaltyEligible": true,
    "contentTags": {
      "genres": ["Pop", "Electronic", "Chill"],
      "moods": ["Happy", "Relaxed", "Uplifting"],
      "themes": ["Summer", "Beach", "Love"]
    },
    "aiAnalysis": {
      "summary": "Upbeat pop track with tropical elements...",
      "qualityScore": 87,
      "contentWarnings": [],
      "genrePredictions": {
        "primaryGenre": "Pop",
        "confidence": 0.92,
        "secondaryGenres": [
          {"genre": "Electronic", "confidence": 0.75},
          {"genre": "Tropical House", "confidence": 0.68}
        ]
      }
    }
  }
}
```

##### Create Track

Creates a new track.

```http
POST /api/v1/tracks
Content-Type: application/json

{
  "title": "Autumn Leaves",
  "primaryArtist": "John Doe",
  "featuredArtists": ["Jane Smith"],
  "primaryGenre": "Pop",
  "secondaryGenres": ["Alternative"],
  "duration": 205,
  "releaseDate": "2023-03-15",
  "recordingDate": "2022-12-10",
  "language": "English",
  "explicit": false,
  "bpm": 115,
  "key": "A Minor",
  "moods": ["Melancholic", "Nostalgic"],
  "tags": ["Autumn", "Nostalgia"],
  "lyrics": "Here are the lyrics...",
  "description": "A melancholic track about change...",
  "composers": ["John Doe", "Jane Smith"],
  "lyricists": ["John Doe"],
  "producers": ["Bob Producer"]
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 1003,
    "title": "Autumn Leaves",
    "primaryArtist": "John Doe",
    "featuredArtists": ["Jane Smith"],
    "primaryGenre": "Pop",
    "secondaryGenres": ["Alternative"],
    "duration": 205,
    "releaseDate": "2023-03-15",
    "recordingDate": "2022-12-10",
    "language": "English",
    "explicit": false,
    "bpm": 115,
    "key": "A Minor",
    "moods": ["Melancholic", "Nostalgic"],
    "tags": ["Autumn", "Nostalgia"],
    "lyrics": "Here are the lyrics...",
    "description": "A melancholic track about change...",
    "status": "draft",
    "createdAt": "2023-01-16T14:30:00Z",
    "composers": ["John Doe", "Jane Smith"],
    "lyricists": ["John Doe"],
    "producers": ["Bob Producer"],
    "royaltyEligible": true
  }
}
```

##### Update Track

Updates an existing track.

```http
PATCH /api/v1/tracks/1003
Content-Type: application/json

{
  "title": "Autumn Memories",
  "explicit": true,
  "status": "active"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 1003,
    "title": "Autumn Memories",
    "primaryArtist": "John Doe",
    "featuredArtists": ["Jane Smith"],
    "primaryGenre": "Pop",
    "secondaryGenres": ["Alternative"],
    "duration": 205,
    "releaseDate": "2023-03-15",
    "recordingDate": "2022-12-10",
    "language": "English",
    "explicit": true,
    "bpm": 115,
    "key": "A Minor",
    "moods": ["Melancholic", "Nostalgic"],
    "tags": ["Autumn", "Nostalgia"],
    "lyrics": "Here are the lyrics...",
    "description": "A melancholic track about change...",
    "status": "active",
    "createdAt": "2023-01-16T14:30:00Z",
    "updatedAt": "2023-01-16T15:45:00Z",
    "composers": ["John Doe", "Jane Smith"],
    "lyricists": ["John Doe"],
    "producers": ["Bob Producer"],
    "royaltyEligible": true
  }
}
```

##### Upload Track Audio

Uploads audio for a track.

```http
POST /api/v1/tracks/1003/audio
Content-Type: multipart/form-data

file: [binary audio file]
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 1003,
    "audioFileUrl": "https://assets.tunemantra.com/audio/1003.mp3",
    "waveformUrl": "https://assets.tunemantra.com/waveforms/1003.json",
    "duration": 205,
    "audioMetadata": {
      "format": "mp3",
      "sampleRate": 44100,
      "bitDepth": 16,
      "channels": 2,
      "bitrate": 320000,
      "fileSize": 7864320
    },
    "status": "active",
    "updatedAt": "2023-01-16T16:30:00Z"
  }
}
```

##### Upload Track Cover Art

Uploads cover art for a track.

```http
POST /api/v1/tracks/1003/artwork
Content-Type: multipart/form-data

file: [binary image file]
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 1003,
    "coverArtUrl": "https://assets.tunemantra.com/tracks/1003.jpg",
    "artworkMetadata": {
      "dimensions": {
        "width": 3000,
        "height": 3000
      },
      "format": "jpeg",
      "fileSize": 1245678,
      "resolution": 300
    },
    "updatedAt": "2023-01-16T16:45:00Z"
  }
}
```

#### Releases

##### List Releases

Retrieves a list of releases for the authenticated user.

```http
GET /api/v1/releases
```

Optional query parameters:
- `status`: Filter by status (draft, active, inactive)
- `search`: Search term for release title or artist
- `type`: Filter by release type (single, ep, album)
- `releasedAfter`: Filter by release date
- `releasedBefore`: Filter by release date

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": 501,
      "title": "Summer Hits",
      "primaryArtist": "John Doe",
      "upc": "123456789012",
      "type": "album",
      "releaseDate": "2023-02-01",
      "status": "active",
      "coverArtUrl": "https://assets.tunemantra.com/releases/501.jpg",
      "trackCount": 12,
      "createdAt": "2022-12-15T10:30:00Z"
    },
    {
      "id": 502,
      "title": "Winter Nights",
      "primaryArtist": "John Doe",
      "upc": "223456789012",
      "type": "ep",
      "releaseDate": "2023-04-15",
      "status": "draft",
      "coverArtUrl": "https://assets.tunemantra.com/releases/502.jpg",
      "trackCount": 6,
      "createdAt": "2023-01-05T14:45:00Z"
    }
  ],
  "meta": {
    "pagination": {
      "total": 5,
      "pages": 3,
      "page": 1,
      "limit": 2,
      "next": "/api/v1/releases?page=2&limit=2"
    }
  }
}
```

##### Get Release

Retrieves a specific release by ID.

```http
GET /api/v1/releases/501
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 501,
    "title": "Summer Hits",
    "primaryArtist": "John Doe",
    "upc": "123456789012",
    "type": "album",
    "releaseDate": "2023-02-01",
    "originalReleaseDate": "2023-02-01",
    "preOrderDate": "2023-01-15",
    "recordLabel": "John Doe Music",
    "catalogNumber": "JD-2023-001",
    "primaryGenre": "Pop",
    "secondaryGenres": ["Electronic", "Dance"],
    "language": "English",
    "explicit": false,
    "status": "active",
    "coverArtUrl": "https://assets.tunemantra.com/releases/501.jpg",
    "description": "A collection of summer hits...",
    "createdAt": "2022-12-15T10:30:00Z",
    "updatedAt": "2023-01-10T09:15:00Z",
    "featuredArtists": [],
    "copyrightText": "© 2023 John Doe Music",
    "publishingRights": "℗ 2023 John Doe Music",
    "territoriesExcluded": ["CN"],
    "tracks": [
      {
        "id": 1001,
        "title": "Summer Breeze",
        "trackNumber": 1,
        "discNumber": 1,
        "duration": 217,
        "isrc": "USX123456789",
        "primaryArtist": "John Doe",
        "status": "active"
      },
      {
        "id": 1002,
        "title": "Midnight Dreams",
        "trackNumber": 2,
        "discNumber": 1,
        "duration": 195,
        "isrc": "USX223456789",
        "primaryArtist": "John Doe",
        "status": "active"
      }
    ],
    "distributionStatus": "distributed",
    "distributionDate": "2023-02-01T00:00:00Z",
    "contentType": "album",
    "visibilitySettings": {
      "searchable": true,
      "playlistEligible": true,
      "storeVisibility": {
        "spotify": true,
        "apple_music": true,
        "amazon_music": true
      }
    }
  }
}
```

##### Create Release

Creates a new release.

```http
POST /api/v1/releases
Content-Type: application/json

{
  "title": "Spring Collection",
  "primaryArtist": "John Doe",
  "type": "album",
  "releaseDate": "2023-05-01",
  "preOrderDate": "2023-04-15",
  "recordLabel": "John Doe Music",
  "catalogNumber": "JD-2023-002",
  "primaryGenre": "Pop",
  "secondaryGenres": ["Indie", "Alternative"],
  "language": "English",
  "explicit": false,
  "description": "A collection of spring-themed tracks...",
  "copyrightText": "© 2023 John Doe Music",
  "publishingRights": "℗ 2023 John Doe Music"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 503,
    "title": "Spring Collection",
    "primaryArtist": "John Doe",
    "upc": "323456789012",
    "type": "album",
    "releaseDate": "2023-05-01",
    "preOrderDate": "2023-04-15",
    "recordLabel": "John Doe Music",
    "catalogNumber": "JD-2023-002",
    "primaryGenre": "Pop",
    "secondaryGenres": ["Indie", "Alternative"],
    "language": "English",
    "explicit": false,
    "description": "A collection of spring-themed tracks...",
    "copyrightText": "© 2023 John Doe Music",
    "publishingRights": "℗ 2023 John Doe Music",
    "status": "draft",
    "createdAt": "2023-01-16T17:30:00Z",
    "tracks": []
  }
}
```

##### Update Release

Updates an existing release.

```http
PATCH /api/v1/releases/503
Content-Type: application/json

{
  "title": "Spring Melodies",
  "status": "active"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 503,
    "title": "Spring Melodies",
    "primaryArtist": "John Doe",
    "upc": "323456789012",
    "type": "album",
    "releaseDate": "2023-05-01",
    "preOrderDate": "2023-04-15",
    "recordLabel": "John Doe Music",
    "catalogNumber": "JD-2023-002",
    "primaryGenre": "Pop",
    "secondaryGenres": ["Indie", "Alternative"],
    "language": "English",
    "explicit": false,
    "description": "A collection of spring-themed tracks...",
    "copyrightText": "© 2023 John Doe Music",
    "publishingRights": "℗ 2023 John Doe Music",
    "status": "active",
    "createdAt": "2023-01-16T17:30:00Z",
    "updatedAt": "2023-01-16T18:15:00Z",
    "tracks": []
  }
}
```

##### Upload Release Artwork

Uploads artwork for a release.

```http
POST /api/v1/releases/503/artwork
Content-Type: multipart/form-data

file: [binary image file]
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 503,
    "coverArtUrl": "https://assets.tunemantra.com/releases/503.jpg",
    "artworkMetadata": {
      "dimensions": {
        "width": 3000,
        "height": 3000
      },
      "format": "jpeg",
      "fileSize": 1876543,
      "resolution": 300
    },
    "updatedAt": "2023-01-16T18:30:00Z"
  }
}
```

##### Add Track to Release

Adds an existing track to a release.

```http
POST /api/v1/releases/503/tracks
Content-Type: application/json

{
  "trackId": 1003,
  "trackNumber": 1,
  "discNumber": 1,
  "isBonus": false
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 503,
    "title": "Spring Melodies",
    "tracks": [
      {
        "id": 1003,
        "title": "Autumn Memories",
        "trackNumber": 1,
        "discNumber": 1,
        "duration": 205,
        "isrc": "USX323456789",
        "primaryArtist": "John Doe",
        "featuredArtists": ["Jane Smith"],
        "isBonus": false,
        "status": "active"
      }
    ],
    "updatedAt": "2023-01-16T19:00:00Z"
  }
}
```

#### Distribution

##### List Distribution Platforms

Retrieves a list of available distribution platforms.

```http
GET /api/v1/distribution/platforms
```

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Spotify",
      "logoUrl": "https://assets.tunemantra.com/platforms/spotify.png",
      "isActive": true,
      "territories": ["GLOBAL"],
      "deliveryMethod": "api",
      "processingTime": "1-3 days",
      "supportedFormats": ["mp3", "wav", "flac"],
      "minAudioQuality": "320kbps MP3 / 16-bit WAV",
      "minImageQuality": "3000x3000 pixels, JPG/PNG",
      "supportsPreOrders": true,
      "supportsTakedowns": true,
      "supportsMetadataUpdates": true
    },
    {
      "id": 2,
      "name": "Apple Music",
      "logoUrl": "https://assets.tunemantra.com/platforms/apple_music.png",
      "isActive": true,
      "territories": ["GLOBAL"],
      "deliveryMethod": "api",
      "processingTime": "2-5 days",
      "supportedFormats": ["wav", "aiff"],
      "minAudioQuality": "16-bit WAV/AIFF",
      "minImageQuality": "3000x3000 pixels, JPG/PNG",
      "supportsPreOrders": true,
      "supportsTakedowns": true,
      "supportsMetadataUpdates": true
    }
  ],
  "meta": {
    "pagination": {
      "total": 15,
      "pages": 8,
      "page": 1,
      "limit": 2,
      "next": "/api/v1/distribution/platforms?page=2&limit=2"
    }
  }
}
```

##### Get Distribution Status

Retrieves distribution status for a release across all platforms.

```http
GET /api/v1/distribution/releases/501/status
```

Response:

```json
{
  "success": true,
  "data": {
    "releaseId": 501,
    "title": "Summer Hits",
    "overallStatus": "distributed",
    "distributedAt": "2023-02-01T00:00:00Z",
    "platformStatus": [
      {
        "platformId": 1,
        "platformName": "Spotify",
        "status": "distributed",
        "distributedAt": "2023-01-30T14:25:00Z",
        "platformReleaseId": "spotify_123456",
        "platformUrl": "https://open.spotify.com/album/123456",
        "errors": null
      },
      {
        "platformId": 2,
        "platformName": "Apple Music",
        "status": "distributed",
        "distributedAt": "2023-01-31T10:15:00Z",
        "platformReleaseId": "apple_7890",
        "platformUrl": "https://music.apple.com/album/7890",
        "errors": null
      }
    ]
  }
}
```

##### Create Distribution

Distributes a release to selected platforms.

```http
POST /api/v1/distribution/releases
Content-Type: application/json

{
  "releaseId": 503,
  "platformIds": [1, 2, 3],
  "scheduledAt": "2023-05-01T00:00:00Z",
  "territoryRestrictions": ["CN"],
  "deliveryNotificationEmail": "john.doe@example.com"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": "dist_123abc",
    "releaseId": 503,
    "releaseTitle": "Spring Melodies",
    "scheduledAt": "2023-05-01T00:00:00Z",
    "status": "scheduled",
    "platformCount": 3,
    "territoryRestrictions": ["CN"],
    "createdAt": "2023-01-16T20:00:00Z",
    "platforms": [
      {
        "platformId": 1,
        "platformName": "Spotify",
        "status": "pending"
      },
      {
        "platformId": 2,
        "platformName": "Apple Music",
        "status": "pending"
      },
      {
        "platformId": 3,
        "platformName": "Amazon Music",
        "status": "pending"
      }
    ]
  }
}
```

##### Request Takedown

Requests removal of a release from distribution platforms.

```http
POST /api/v1/distribution/releases/501/takedown
Content-Type: application/json

{
  "reason": "Updated version will be released",
  "platformIds": [1, 2],
  "urgent": false
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": "tkdn_456def",
    "releaseId": 501,
    "releaseTitle": "Summer Hits",
    "reason": "Updated version will be released",
    "status": "processing",
    "requestedAt": "2023-01-16T21:30:00Z",
    "platforms": [
      {
        "platformId": 1,
        "platformName": "Spotify",
        "status": "processing",
        "estimatedCompletionDate": "2023-01-19T00:00:00Z"
      },
      {
        "platformId": 2,
        "platformName": "Apple Music",
        "status": "processing",
        "estimatedCompletionDate": "2023-01-20T00:00:00Z"
      }
    ]
  }
}
```

#### Analytics

##### Get Track Analytics

Retrieves performance analytics for a specific track.

```http
GET /api/v1/analytics/tracks/1001
```

Optional query parameters:
- `startDate`: Filter by start date (YYYY-MM-DD)
- `endDate`: Filter by end date (YYYY-MM-DD)
- `platforms`: Comma-separated list of platform IDs
- `timeframe`: Predefined timeframe (7d, 30d, 90d, 1y, all)
- `groupBy`: Group results by (day, week, month, platform, territory)

Response:

```json
{
  "success": true,
  "data": {
    "trackId": 1001,
    "title": "Summer Breeze",
    "timeframe": {
      "startDate": "2023-01-01",
      "endDate": "2023-01-31"
    },
    "summary": {
      "totalStreams": 150000,
      "totalDownloads": 1200,
      "totalRevenue": 750.25,
      "currency": "USD",
      "uniqueListeners": 75000,
      "avgCompletionRate": 0.85,
      "playlistCount": 120
    },
    "byPlatform": [
      {
        "platformId": 1,
        "platformName": "Spotify",
        "streams": 100000,
        "downloads": 0,
        "revenue": 500.50,
        "uniqueListeners": 50000,
        "avgCompletionRate": 0.87,
        "playlistCount": 85
      },
      {
        "platformId": 2,
        "platformName": "Apple Music",
        "streams": 50000,
        "downloads": 1200,
        "revenue": 249.75,
        "uniqueListeners": 25000,
        "avgCompletionRate": 0.82,
        "playlistCount": 35
      }
    ],
    "byDay": [
      {
        "date": "2023-01-01",
        "streams": 4500,
        "downloads": 40,
        "revenue": 22.50
      },
      {
        "date": "2023-01-02",
        "streams": 4800,
        "downloads": 38,
        "revenue": 24.15
      }
    ],
    "byTerritory": [
      {
        "territory": "US",
        "streams": 75000,
        "downloads": 600,
        "revenue": 375.12
      },
      {
        "territory": "GB",
        "streams": 25000,
        "downloads": 200,
        "revenue": 125.04
      }
    ]
  }
}
```

##### Get Release Analytics

Retrieves performance analytics for a specific release.

```http
GET /api/v1/analytics/releases/501
```

Optional query parameters:
- `startDate`: Filter by start date (YYYY-MM-DD)
- `endDate`: Filter by end date (YYYY-MM-DD)
- `platforms`: Comma-separated list of platform IDs
- `timeframe`: Predefined timeframe (7d, 30d, 90d, 1y, all)
- `groupBy`: Group results by (day, week, month, platform, territory, track)

Response:

```json
{
  "success": true,
  "data": {
    "releaseId": 501,
    "title": "Summer Hits",
    "timeframe": {
      "startDate": "2023-02-01",
      "endDate": "2023-02-28"
    },
    "summary": {
      "totalStreams": 1250000,
      "totalDownloads": 15000,
      "totalRevenue": 7500.25,
      "currency": "USD",
      "uniqueListeners": 450000,
      "avgCompletionRate": 0.83,
      "savesCount": 45000
    },
    "byTrack": [
      {
        "trackId": 1001,
        "title": "Summer Breeze",
        "trackNumber": 1,
        "streams": 200000,
        "downloads": 2500,
        "revenue": 1200.50
      },
      {
        "trackId": 1002,
        "title": "Midnight Dreams",
        "trackNumber": 2,
        "streams": 180000,
        "downloads": 2200,
        "revenue": 1080.30
      }
    ],
    "byPlatform": [
      {
        "platformId": 1,
        "platformName": "Spotify",
        "streams": 750000,
        "downloads": 0,
        "revenue": 4500.50
      },
      {
        "platformId": 2,
        "platformName": "Apple Music",
        "streams": 500000,
        "downloads": 15000,
        "revenue": 2999.75
      }
    ],
    "byTerritory": [
      {
        "territory": "US",
        "streams": 500000,
        "downloads": 7500,
        "revenue": 3750.12
      },
      {
        "territory": "GB",
        "streams": 250000,
        "downloads": 3000,
        "revenue": 1500.06
      }
    ]
  }
}
```

##### Get Audience Demographics

Retrieves audience demographic information.

```http
GET /api/v1/analytics/audience/demographics
```

Optional query parameters:
- `entityType`: Type of entity (artist, track, release)
- `entityId`: ID of the entity
- `timeframe`: Predefined timeframe (30d, 90d, 1y, all)

Response:

```json
{
  "success": true,
  "data": {
    "entityType": "artist",
    "entityId": null,
    "timeframe": "90d",
    "ageRanges": {
      "18-24": 0.35,
      "25-34": 0.40,
      "35-44": 0.15,
      "45-54": 0.07,
      "55+": 0.03
    },
    "genders": {
      "male": 0.55,
      "female": 0.43,
      "other": 0.02
    },
    "countries": {
      "US": 0.45,
      "GB": 0.15,
      "DE": 0.10,
      "FR": 0.08,
      "CA": 0.07,
      "other": 0.15
    },
    "topCities": [
      {"name": "New York, US", "share": 0.08},
      {"name": "London, GB", "share": 0.06},
      {"name": "Los Angeles, US", "share": 0.05},
      {"name": "Berlin, DE", "share": 0.04},
      {"name": "Chicago, US", "share": 0.03}
    ],
    "platforms": {
      "spotify": 0.65,
      "apple_music": 0.25,
      "amazon_music": 0.05,
      "other": 0.05
    },
    "devices": {
      "mobile": 0.70,
      "desktop": 0.20,
      "smart_speaker": 0.07,
      "other": 0.03
    },
    "listeningPreferences": {
      "playlistShares": {
        "editorial": 0.40,
        "algorithmic": 0.30,
        "user_created": 0.20,
        "direct_search": 0.10
      },
      "listeningTime": {
        "morning": 0.25,
        "afternoon": 0.30,
        "evening": 0.35,
        "night": 0.10
      }
    }
  }
}
```

##### Get Revenue Analytics

Retrieves revenue analytics.

```http
GET /api/v1/analytics/revenue
```

Optional query parameters:
- `startDate`: Filter by start date (YYYY-MM-DD)
- `endDate`: Filter by end date (YYYY-MM-DD)
- `timeframe`: Predefined timeframe (30d, 90d, 1y, all)
- `groupBy`: Group results by (day, week, month, platform, territory, release, track)

Response:

```json
{
  "success": true,
  "data": {
    "timeframe": {
      "startDate": "2023-01-01",
      "endDate": "2023-03-31"
    },
    "summary": {
      "totalRevenue": 25000.50,
      "currency": "USD",
      "periodGrowth": 0.15,
      "projectedNextPeriod": 28750.58,
      "topSource": "Spotify"
    },
    "byPeriod": [
      {
        "period": "2023-01",
        "revenue": 8000.25
      },
      {
        "period": "2023-02",
        "revenue": 8500.50
      },
      {
        "period": "2023-03",
        "revenue": 8499.75
      }
    ],
    "byPlatform": [
      {
        "platformId": 1,
        "platformName": "Spotify",
        "revenue": 15000.30,
        "share": 0.60
      },
      {
        "platformId": 2,
        "platformName": "Apple Music",
        "revenue": 7500.15,
        "share": 0.30
      },
      {
        "platformId": 3,
        "platformName": "Amazon Music",
        "revenue": 2500.05,
        "share": 0.10
      }
    ],
    "byRevenueType": {
      "streaming": 22500.45,
      "downloads": 2000.25,
      "other": 499.80
    },
    "byTerritory": [
      {
        "territory": "US",
        "revenue": 12500.25,
        "share": 0.50
      },
      {
        "territory": "EU",
        "revenue": 7500.15,
        "share": 0.30
      },
      {
        "territory": "ROW",
        "revenue": 5000.10,
        "share": 0.20
      }
    ]
  }
}
```

#### Rights and Royalties

##### List Rights Claims

Retrieves a list of rights claims for a specific entity.

```http
GET /api/v1/rights/claims?entityType=track&entityId=1001
```

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": 5001,
      "entityType": "track",
      "entityId": 1001,
      "rightType": "performance",
      "rightHolder": "John Doe",
      "rightHolderType": "user",
      "rightHolderId": 12345,
      "percentage": 80,
      "startDate": "2023-01-15",
      "endDate": null,
      "territory": ["GLOBAL"],
      "verificationStatus": "verified",
      "verifiedAt": "2023-01-16T10:30:00Z",
      "createdAt": "2023-01-15T14:30:00Z",
      "ownershipType": "original"
    },
    {
      "id": 5002,
      "entityType": "track",
      "entityId": 1001,
      "rightType": "performance",
      "rightHolder": "Jane Smith",
      "rightHolderType": "user",
      "rightHolderId": 12346,
      "percentage": 20,
      "startDate": "2023-01-15",
      "endDate": null,
      "territory": ["GLOBAL"],
      "verificationStatus": "verified",
      "verifiedAt": "2023-01-16T10:30:00Z",
      "createdAt": "2023-01-15T14:35:00Z",
      "ownershipType": "original"
    }
  ]
}
```

##### Create Rights Claim

Creates a new rights claim.

```http
POST /api/v1/rights/claims
Content-Type: application/json

{
  "entityType": "track",
  "entityId": 1003,
  "rightType": "performance",
  "rightHolder": "John Doe",
  "rightHolderType": "user",
  "rightHolderId": 12345,
  "percentage": 75,
  "startDate": "2023-01-16",
  "territory": ["GLOBAL"],
  "ownershipType": "original"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 5003,
    "entityType": "track",
    "entityId": 1003,
    "rightType": "performance",
    "rightHolder": "John Doe",
    "rightHolderType": "user",
    "rightHolderId": 12345,
    "percentage": 75,
    "startDate": "2023-01-16",
    "endDate": null,
    "territory": ["GLOBAL"],
    "verificationStatus": "pending",
    "createdAt": "2023-01-16T22:30:00Z",
    "ownershipType": "original"
  }
}
```

##### Get Royalty Calculations

Retrieves royalty calculations for a specific period.

```http
GET /api/v1/royalties/calculations?period=2023-01
```

Optional query parameters:
- `entityType`: Filter by entity type (track, release)
- `entityId`: Filter by entity ID
- `platform`: Filter by platform ID
- `status`: Filter by status (pending, paid)

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": 7001,
      "entityType": "track",
      "entityId": 1001,
      "entityTitle": "Summer Breeze",
      "platformId": 1,
      "platformName": "Spotify",
      "period": "2023-01",
      "streams": 100000,
      "downloads": 0,
      "amount": 500.50,
      "currency": "USD",
      "status": "pending",
      "createdAt": "2023-02-10T10:30:00Z",
      "royaltyType": "performance",
      "territoryCode": "GLOBAL",
      "grossAmount": 500.50,
      "processingFee": 0,
      "distributionFee": 0,
      "netAmount": 500.50
    },
    {
      "id": 7002,
      "entityType": "track",
      "entityId": 1001,
      "entityTitle": "Summer Breeze",
      "platformId": 2,
      "platformName": "Apple Music",
      "period": "2023-01",
      "streams": 50000,
      "downloads": 1200,
      "amount": 249.75,
      "currency": "USD",
      "status": "pending",
      "createdAt": "2023-02-10T10:30:00Z",
      "royaltyType": "performance",
      "territoryCode": "GLOBAL",
      "grossAmount": 249.75,
      "processingFee": 0,
      "distributionFee": 0,
      "netAmount": 249.75
    }
  ],
  "meta": {
    "pagination": {
      "total": 15,
      "pages": 8,
      "page": 1,
      "limit": 2,
      "next": "/api/v1/royalties/calculations?period=2023-01&page=2&limit=2"
    },
    "summary": {
      "totalAmount": 3750.25,
      "currency": "USD",
      "totalStreams": 750000,
      "totalDownloads": 5000
    }
  }
}
```

##### Get Royalty Splits

Retrieves royalty splits for a specific entity.

```http
GET /api/v1/royalties/splits?entityType=track&entityId=1001
```

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": 8001,
      "entityType": "track",
      "entityId": 1001,
      "rightType": "performance",
      "recipientName": "John Doe",
      "recipientType": "user",
      "recipientId": 12345,
      "percentage": 80,
      "isApproved": true,
      "approvedAt": "2023-01-16T10:30:00Z",
      "createdAt": "2023-01-15T14:30:00Z",
      "status": "active",
      "effectiveFrom": "2023-01-15"
    },
    {
      "id": 8002,
      "entityType": "track",
      "entityId": 1001,
      "rightType": "performance",
      "recipientName": "Jane Smith",
      "recipientType": "user",
      "recipientId": 12346,
      "percentage": 20,
      "isApproved": true,
      "approvedAt": "2023-01-16T10:30:00Z",
      "createdAt": "2023-01-15T14:35:00Z",
      "status": "active",
      "effectiveFrom": "2023-01-15"
    }
  ]
}
```

##### Create Royalty Split

Creates a new royalty split.

```http
POST /api/v1/royalties/splits
Content-Type: application/json

{
  "entityType": "track",
  "entityId": 1003,
  "rightType": "performance",
  "recipientName": "John Doe",
  "recipientType": "user",
  "recipientId": 12345,
  "percentage": 75,
  "effectiveFrom": "2023-01-16"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 8003,
    "entityType": "track",
    "entityId": 1003,
    "rightType": "performance",
    "recipientName": "John Doe",
    "recipientType": "user",
    "recipientId": 12345,
    "percentage": 75,
    "isApproved": false,
    "createdAt": "2023-01-16T23:00:00Z",
    "status": "pending",
    "effectiveFrom": "2023-01-16"
  }
}
```

### Webhook Events

TuneMantra supports webhooks for real-time notifications of events:

#### Webhook Registration

Register a webhook endpoint to receive event notifications:

```http
POST /api/v1/webhooks
Content-Type: application/json

{
  "url": "https://your-app.example.com/webhook",
  "events": ["track.created", "release.distributed", "royalty.calculated"],
  "description": "Production webhook for my app",
  "secret": "your_webhook_secret"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": "wh_456def",
    "url": "https://your-app.example.com/webhook",
    "events": ["track.created", "release.distributed", "royalty.calculated"],
    "description": "Production webhook for my app",
    "status": "active",
    "createdAt": "2023-01-16T23:30:00Z"
  }
}
```

#### Event Types

TuneMantra can send the following webhook events:

| Event Type | Description |
|------------|-------------|
| `track.created` | A new track has been created |
| `track.updated` | A track has been updated |
| `track.deleted` | A track has been deleted |
| `release.created` | A new release has been created |
| `release.updated` | A release has been updated |
| `release.deleted` | A release has been deleted |
| `distribution.created` | A new distribution has been created |
| `distribution.updated` | A distribution status has been updated |
| `distribution.completed` | A distribution has been completed |
| `distribution.failed` | A distribution has failed |
| `royalty.calculated` | Royalties have been calculated |
| `royalty.paid` | Royalties have been paid |
| `rights.claimed` | Rights have been claimed |
| `rights.verified` | Rights have been verified |
| `rights.disputed` | Rights have been disputed |

#### Webhook Request Format

When an event occurs, TuneMantra sends a POST request to your webhook URL:

```http
POST /webhook
Content-Type: application/json
X-TuneMantra-Signature: t=1642368000,v1=ab12cd34ef56gh78ij90kl12mn34op56qr78st90uvwxyz
X-TuneMantra-Event: track.created

{
  "id": "evt_123abc",
  "type": "track.created",
  "createdAt": "2023-01-16T14:30:00Z",
  "data": {
    "track": {
      "id": 1003,
      "title": "Autumn Memories",
      "primaryArtist": "John Doe",
      "status": "draft",
      "createdAt": "2023-01-16T14:30:00Z"
    }
  }
}
```

#### Securing Webhooks

To verify the webhook came from TuneMantra:

1. Extract the timestamp (`t`) and signature (`v1`) from the `X-TuneMantra-Signature` header
2. Compute an HMAC-SHA256 of the request body using your webhook secret
3. Compare your signature with the provided signature
4. Verify the timestamp is not too old (to prevent replay attacks)

Code example (Node.js):

```javascript
const crypto = require('crypto');

function verifySignature(body, signature, secret) {
  const [timestamp, receivedSignature] = signature.split(',');
  const [, time] = timestamp.split('=');
  const [, hash] = receivedSignature.split('=');

  // Check if the timestamp is recent (within 5 minutes)
  const now = Math.floor(Date.now() / 1000);
  if (now - parseInt(time) > 300) {
    return false;
  }

  // Compute the HMAC signature
  const computedSignature = crypto
    .createHmac('sha256', secret)
    .update(`${timestamp},${body}`)
    .digest('hex');

  return crypto.timingSafeEqual(
    Buffer.from(hash),
    Buffer.from(computedSignature)
  );
}
```

### API Versioning

TuneMantra uses a clear versioning strategy to ensure compatibility:

#### Version Format

API versions are included in the URL path:

```
https://api.tunemantra.com/v1/tracks
```

#### Version Lifecycle

TuneMantra follows this version lifecycle:

1. **Active**: Current recommended version
2. **Maintained**: Still supported, but not recommended for new integrations
3. **Deprecated**: Will be removed in the future (timeline announced)
4. **Sunset**: No longer available

#### Version Headers

You can specify a more precise version using headers:

```http
GET /api/v1/tracks
TuneMantra-Version: 2023-01-15
```

This allows for fine-grained compatibility within a major version.

#### Breaking vs. Non-Breaking Changes

TuneMantra follows these principles for changes:

1. **Non-Breaking Changes** (no version change):
   - Adding new endpoints
   - Adding optional parameters
   - Adding new fields in responses
   - Adding new event types

2. **Breaking Changes** (version incremented):
   - Removing or renaming endpoints
   - Removing or renaming fields
   - Changing field types or formats
   - Changing authentication methods

### Advanced Usage

#### Batch Operations

For performance, use batch operations where available:

##### Batch Get Tracks

```http
GET /api/v1/tracks/batch?ids=1001,1002,1003
```

##### Batch Create Tracks

```http
POST /api/v1/tracks/batch
Content-Type: application/json

{
  "tracks": [
    {
      "title": "Track One",
      "primaryArtist": "John Doe",
      "primaryGenre": "Pop"
    },
    {
      "title": "Track Two",
      "primaryArtist": "John Doe",
      "primaryGenre": "Rock"
    }
  ]
}
```

#### Idempotency

For safe retries, use idempotency keys:

```http
POST /api/v1/tracks
Content-Type: application/json
Idempotency-Key: a-unique-key-for-this-request-abc123

{
  "title": "My New Track",
  "primaryArtist": "John Doe",
  "primaryGenre": "Pop"
}
```

The same request with the same idempotency key will return the same result without creating duplicate resources.

#### Draft Resources

Create resources in draft state before publishing:

```http
POST /api/v1/tracks
Content-Type: application/json

{
  "title": "My Draft Track",
  "primaryArtist": "John Doe",
  "primaryGenre": "Pop",
  "status": "draft"
}
```

Later, update to publish:

```http
PATCH /api/v1/tracks/1004
Content-Type: application/json

{
  "status": "active"
}
```

#### Conditional Requests

Use conditional requests to avoid unnecessary data transfer:

```http
GET /api/v1/tracks/1001
If-Modified-Since: Wed, 15 Jan 2023 08:30:00 GMT
```

If the resource hasn't changed, you'll receive a `304 Not Modified` response.

For resources with ETags:

```http
GET /api/v1/tracks/1001
If-None-Match: "abc123"
```

#### Search and Filtering

Use the search endpoint for advanced queries:

```http
GET /api/v1/search?q=summer&type=track,release&limit=10
```

For complex filtering, use the filter parameter with JSON syntax:

```http
GET /api/v1/tracks?filter={"primaryGenre":{"in":["Pop","Rock"]},"releaseDate":{"gte":"2023-01-01"}}
```

---

**Document Information:**
- Version: 2.0
- Last Updated: March 25, 2025
- Contact: api@tunemantra.com

*Source: /home/runner/workspace/.archive/archive_docs/doc_backup/api-reference.md*

---

## Reference to Duplicate Content (74)

## Reference to Duplicate Content

**Original Path:** all_md_files/5march8am/docs/api/PAYMENT_API_REFERENCE.md

**Title:** Payment System API Reference

**MD5 Hash:** 6178bf1716ffeca4d3a4628f892f1f28

**Duplicate of:** unified_documentation/technical/3march1am-payment-api-reference.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/5march8am_payment-api-reference.md.md*

---

## Reference to Duplicate Content (75)

## Reference to Duplicate Content

**Original Path:** all_md_files/8march258/docs/api/PAYMENT_API_REFERENCE.md

**Title:** Payment System API Reference

**MD5 Hash:** 6178bf1716ffeca4d3a4628f892f1f28

**Duplicate of:** unified_documentation/technical/3march1am-payment-api-reference.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/8march258_payment-api-reference.md.md*

---

## Reference to Duplicate Content (76)

## Reference to Duplicate Content

**Original Path:** all_md_files/PPv1/md_analysis/backup/api-reference-legacy.md

**Title:** TuneMantra API Reference

**MD5 Hash:** 60bf2393e17a0060b764808f368d991f

**Duplicate of:** unified_documentation/api-reference/main-api-reference-legacy.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/PPv1_api-reference-legacy.md.md*

---

## Reference to Duplicate Content (77)

## Reference to Duplicate Content

**Original Path:** all_md_files/main/md_analysis/backup/api-reference-legacy.md

**Title:** TuneMantra API Reference

**MD5 Hash:** 60bf2393e17a0060b764808f368d991f

**Duplicate of:** unified_documentation/api-reference/main-api-reference-legacy.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/main_api-reference-legacy.md.md*

---

## Metadata for api-reference.md

## Metadata for api-reference.md

**Original Path:** all_md_files/main/docs/developer/api-reference.md

**Title:** TuneMantra API Reference

**Category:** api-reference

**MD5 Hash:** 209199da3a60197e6728b2a3b6d8ebc8

**Source Branch:** main


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/main_api-reference.md.md*

---

## Reference to Duplicate Content (78)

## Reference to Duplicate Content

**Original Path:** all_md_files/organized/api-reference/api-reference-legacy.md

**Title:** TuneMantra API Reference

**MD5 Hash:** 60bf2393e17a0060b764808f368d991f

**Duplicate of:** unified_documentation/api-reference/main-api-reference-legacy.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/organized_api-reference-legacy.md.md*

---

## Reference to Duplicate Content (79)

## Reference to Duplicate Content

**Original Path:** all_md_files/organized/api-reference/payment-api-reference.md

**Title:** Payment System API Reference

**MD5 Hash:** 6178bf1716ffeca4d3a4628f892f1f28

**Duplicate of:** unified_documentation/technical/3march1am-payment-api-reference.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/organized_payment-api-reference.md.md*

---

## Reference to Duplicate Content (80)

## Reference to Duplicate Content

**Original Path:** all_md_files/replit-agent/md_analysis/backup/api-reference-legacy.md

**Title:** TuneMantra API Reference

**MD5 Hash:** 60bf2393e17a0060b764808f368d991f

**Duplicate of:** unified_documentation/api-reference/main-api-reference-legacy.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/replit-agent_api-reference-legacy.md.md*

---

## Reference to Duplicate Content (81)

## Reference to Duplicate Content

**Original Path:** all_md_files/temp-3march/md_analysis/backup/api-reference-legacy.md

**Title:** TuneMantra API Reference

**MD5 Hash:** 60bf2393e17a0060b764808f368d991f

**Duplicate of:** unified_documentation/api-reference/main-api-reference-legacy.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/temp-3march_api-reference-legacy.md.md*

---

## Metadata for api-reference.md (2)

## Metadata for api-reference.md

**Original Path:** all_md_files/temp-3march/docs-consolidated/03-technical/api/api-reference.md

**Title:** TuneMantra API Reference

**Category:** api-reference

**MD5 Hash:** 6ab6e258bcee7b34e2ea71431c5cf15a

**Source Branch:** temp-3march


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/temp-3march_api-reference.md.md*

---

## Metadata for schema-reference.md

## Metadata for schema-reference.md

**Original Path:** all_md_files/temp-3march/docs-consolidated/03-technical/database/schema-reference.md

**Title:** TuneMantra Database Schema Reference

**Category:** technical

**MD5 Hash:** bec3fc5dfd8c95f3b61fe2f67cd1205a

**Source Branch:** temp-3march


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/temp-3march_schema-reference.md.md*

---

## Reference to Duplicate Content (82)

## Reference to Duplicate Content

**Original Path:** all_md_files/temp-extraction/docs/api/api-reference.md

**Title:** TuneMantra API Reference

**MD5 Hash:** 169a5f22fd4fd12c95fb1ba00f543ef1

**Duplicate of:** unified_documentation/api-reference/17032025-api-reference.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/temp-extraction_api-reference.md.md*

---

## Reference to Duplicate Content (83)

## Reference to Duplicate Content

**Original Path:** all_md_files/temp-extraction/docs/api/payment-api-reference.md

**Title:** Payment System API Reference

**MD5 Hash:** 6178bf1716ffeca4d3a4628f892f1f28

**Duplicate of:** unified_documentation/technical/3march1am-payment-api-reference.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/temp-extraction_payment-api-reference.md.md*

---

## Payment System API Reference

## Payment System API Reference

### Overview

This document provides a comprehensive reference for all payment-related API endpoints in the TuneMantra platform. These APIs enable payment method management, withdrawal requests, and revenue split configuration.

### Base URL

All API endpoints are relative to your Replit instance URL:

```
https://your-instance.replit.app/api
```

### Authentication

All payment API endpoints require authentication. Include a valid session cookie with your requests, which is obtained after successful login.

### API Endpoints

#### Payment Methods

##### List Payment Methods

Retrieves all payment methods for the authenticated user.

```
GET /payment-methods
```

**Response**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "type": "bank_account",
      "lastFour": "1234",
      "details": {
        "accountName": "John Doe",
        "bankName": "Example Bank",
        "accountType": "checking"
      },
      "isDefault": true,
      "createdAt": "2025-02-15T08:30:00Z"
    },
    {
      "id": 2,
      "type": "card",
      "lastFour": "5678",
      "details": {
        "cardType": "visa",
        "expiryMonth": 12,
        "expiryYear": 2026,
        "cardholderName": "John Doe"
      },
      "isDefault": false,
      "createdAt": "2025-02-16T10:15:00Z"
    }
  ]
}
```

##### Add Payment Method

Creates a new payment method for the authenticated user.

```
POST /payment-methods
```

**Request Body**

```json
{
  "type": "bank_account",
  "lastFour": "1234",
  "details": {
    "accountName": "John Doe",
    "bankName": "Example Bank",
    "accountType": "checking",
    "routingNumber": "123456789"
  },
  "isDefault": true
}
```

**Response**

```json
{
  "success": true,
  "data": {
    "id": 3,
    "type": "bank_account",
    "lastFour": "1234",
    "details": {
      "accountName": "John Doe",
      "bankName": "Example Bank",
      "accountType": "checking"
    },
    "isDefault": true,
    "createdAt": "2025-03-01T14:22:30Z"
  }
}
```

##### Delete Payment Method

Deletes a payment method belonging to the authenticated user.

```
DELETE /payment-methods/:id
```

**Parameters**

- `id`: The ID of the payment method to delete

**Response**

```json
{
  "success": true,
  "message": "Payment method deleted successfully"
}
```

#### Withdrawals

##### List Withdrawals

Retrieves all withdrawals for the authenticated user.

```
GET /withdrawals
```

**Query Parameters**

- `status` (optional): Filter by status (`pending`, `completed`, `rejected`)
- `limit` (optional): Maximum number of records to return
- `offset` (optional): Number of records to skip

**Response**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "paymentMethodId": 1,
      "amount": "500.00",
      "currency": "USD",
      "status": "completed",
      "notes": "Monthly withdrawal",
      "referenceNumber": "WD123456",
      "createdAt": "2025-02-20T09:30:00Z",
      "processedAt": "2025-02-21T11:45:00Z",
      "paymentMethod": {
        "type": "bank_account",
        "lastFour": "1234"
      }
    },
    {
      "id": 2,
      "paymentMethodId": 1,
      "amount": "750.00",
      "currency": "USD",
      "status": "pending",
      "notes": "Quarterly bonus",
      "createdAt": "2025-03-01T14:22:30Z",
      "paymentMethod": {
        "type": "bank_account",
        "lastFour": "1234"
      }
    }
  ],
  "pagination": {
    "total": 2,
    "limit": 10,
    "offset": 0
  }
}
```

##### Request Withdrawal

Creates a new withdrawal request for the authenticated user.

```
POST /withdrawals
```

**Request Body**

```json
{
  "paymentMethodId": 1,
  "amount": 1000.00,
  "currency": "USD",
  "notes": "March income withdrawal"
}
```

**Response**

```json
{
  "success": true,
  "data": {
    "id": 3,
    "paymentMethodId": 1,
    "amount": "1000.00",
    "currency": "USD",
    "status": "pending",
    "notes": "March income withdrawal",
    "createdAt": "2025-03-04T15:30:00Z",
    "paymentMethod": {
      "type": "bank_account",
      "lastFour": "1234"
    }
  }
}
```

##### Get Withdrawal Details

Retrieves details of a specific withdrawal.

```
GET /withdrawals/:id
```

**Parameters**

- `id`: The ID of the withdrawal to retrieve

**Response**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "paymentMethodId": 1,
    "amount": "500.00",
    "currency": "USD",
    "status": "completed",
    "notes": "Monthly withdrawal",
    "referenceNumber": "WD123456",
    "createdAt": "2025-02-20T09:30:00Z",
    "processedAt": "2025-02-21T11:45:00Z",
    "paymentMethod": {
      "type": "bank_account",
      "lastFour": "1234",
      "details": {
        "accountName": "John Doe",
        "bankName": "Example Bank"
      }
    }
  }
}
```

#### Revenue Splits

##### Get Revenue Splits

Retrieves revenue split configurations for the authenticated user.

```
GET /revenue-splits
```

**Response**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "Album Collaboration",
      "splits": [
        {
          "artistName": "Primary Artist",
          "artistId": 101,
          "role": "Artist",
          "percentage": 70
        },
        {
          "artistName": "Featured Artist",
          "artistId": 102,
          "role": "Feature",
          "percentage": 20
        },
        {
          "artistName": "Producer",
          "artistId": 103,
          "role": "Producer",
          "percentage": 10
        }
      ],
      "createdAt": "2025-02-10T09:30:00Z",
      "updatedAt": "2025-02-10T09:30:00Z"
    }
  ]
}
```

##### Create Revenue Split

Creates a new revenue split configuration.

```
POST /revenue-splits
```

**Request Body**

```json
{
  "title": "EP Collaboration",
  "splits": [
    {
      "artistName": "Primary Artist",
      "artistId": 101,
      "role": "Artist",
      "percentage": 60
    },
    {
      "artistName": "Featured Artist",
      "artistId": 102,
      "role": "Feature",
      "percentage": 25
    },
    {
      "artistName": "Producer",
      "artistId": 103,
      "role": "Producer",
      "percentage": 15
    }
  ]
}
```

**Response**

```json
{
  "success": true,
  "data": {
    "id": 2,
    "title": "EP Collaboration",
    "splits": [
      {
        "artistName": "Primary Artist",
        "artistId": 101,
        "role": "Artist",
        "percentage": 60
      },
      {
        "artistName": "Featured Artist",
        "artistId": 102,
        "role": "Feature",
        "percentage": 25
      },
      {
        "artistName": "Producer",
        "artistId": 103,
        "role": "Producer",
        "percentage": 15
      }
    ],
    "createdAt": "2025-03-04T15:45:00Z",
    "updatedAt": "2025-03-04T15:45:00Z"
  }
}
```

##### Update Revenue Split

Updates an existing revenue split configuration.

```
PUT /revenue-splits/:id
```

**Parameters**

- `id`: The ID of the revenue split to update

**Request Body**

```json
{
  "title": "EP Collaboration (Revised)",
  "splits": [
    {
      "artistName": "Primary Artist",
      "artistId": 101,
      "role": "Artist",
      "percentage": 55
    },
    {
      "artistName": "Featured Artist",
      "artistId": 102,
      "role": "Feature",
      "percentage": 25
    },
    {
      "artistName": "Producer",
      "artistId": 103,
      "role": "Producer",
      "percentage": 15
    },
    {
      "artistName": "Mixing Engineer",
      "artistId": 104,
      "role": "Engineer",
      "percentage": 5
    }
  ]
}
```

**Response**

```json
{
  "success": true,
  "data": {
    "id": 2,
    "title": "EP Collaboration (Revised)",
    "splits": [
      {
        "artistName": "Primary Artist",
        "artistId": 101,
        "role": "Artist",
        "percentage": 55
      },
      {
        "artistName": "Featured Artist",
        "artistId": 102,
        "role": "Feature",
        "percentage": 25
      },
      {
        "artistName": "Producer",
        "artistId": 103,
        "role": "Producer",
        "percentage": 15
      },
      {
        "artistName": "Mixing Engineer",
        "artistId": 104,
        "role": "Engineer",
        "percentage": 5
      }
    ],
    "createdAt": "2025-03-04T15:45:00Z",
    "updatedAt": "2025-03-04T16:30:00Z"
  }
}
```

##### Delete Revenue Split

Deletes a revenue split configuration.

```
DELETE /revenue-splits/:id
```

**Parameters**

- `id`: The ID of the revenue split to delete

**Response**

```json
{
  "success": true,
  "message": "Revenue split deleted successfully"
}
```

#### Subscription Management

##### Create Subscription

Creates a subscription checkout session.

```
POST /create-subscription
```

**Request Body**

```json
{
  "planType": "artist"
}
```

**Response**

```json
{
  "success": true,
  "data": {
    "orderId": "order_ABC123XYZ",
    "amount": 1999,
    "currency": "INR",
    "keyId": "rzp_test_abcdefghijklmn"
  }
}
```

##### Verify Payment

Verifies a payment after checkout completion.

```
POST /verify-payment
```

**Request Body**

```json
{
  "orderId": "order_ABC123XYZ",
  "paymentId": "pay_DEF456UVW",
  "signature": "abcdef1234567890abcdef1234567890abcdef",
  "planType": "artist"
}
```

**Response**

```json
{
  "success": true,
  "message": "Payment verified successfully",
  "data": {
    "subscriptionInfo": {
      "plan": "artist",
      "status": "pending_approval",
      "startDate": "2025-03-04T16:45:00Z",
      "endDate": "2026-03-04T16:45:00Z"
    }
  }
}
```

##### Cancel Subscription

Cancels the user's active subscription.

```
POST /cancel-subscription
```

**Response**

```json
{
  "success": true,
  "message": "Subscription cancelled successfully",
  "data": {
    "subscriptionInfo": {
      "plan": "artist",
      "status": "canceled",
      "startDate": "2025-03-04T16:45:00Z",
      "endDate": "2026-03-04T16:45:00Z",
      "cancelledAt": "2025-03-04T17:00:00Z"
    }
  }
}
```

##### Get Subscription Status

Retrieves the current subscription status for the authenticated user.

```
GET /subscription-status
```

**Response**

```json
{
  "success": true,
  "data": {
    "subscriptionInfo": {
      "plan": "artist",
      "status": "active",
      "startDate": "2025-03-04T16:45:00Z",
      "endDate": "2026-03-04T16:45:00Z",
      "features": [
        "distribution_to_all_platforms",
        "advanced_analytics",
        "royalty_management"
      ]
    }
  }
}
```

### Error Responses

All API endpoints return appropriate HTTP status codes and a standardized error response format:

```json
{
  "success": false,
  "error": {
    "code": "INVALID_REQUEST",
    "message": "The request contains invalid parameters",
    "details": {
      "field": "amount",
      "issue": "Amount must be greater than zero"
    }
  }
}
```

#### Common Error Codes

- `UNAUTHORIZED`: Authentication is required or has failed
- `FORBIDDEN`: The authenticated user does not have permission for this action
- `NOT_FOUND`: The requested resource was not found
- `INVALID_REQUEST`: The request contains invalid parameters
- `VALIDATION_ERROR`: The request data failed validation
- `INSUFFICIENT_FUNDS`: The user has insufficient funds for the requested withdrawal
- `PAYMENT_ERROR`: An error occurred during payment processing
- `INTERNAL_ERROR`: An internal server error has occurred

### Rate Limiting

API requests are subject to rate limiting to prevent abuse. Current limits are:

- Standard users: 60 requests per minute
- API users with key: 120 requests per minute

When a rate limit is exceeded, the API will respond with HTTP status 429 (Too Many Requests).

### Versioning

The current API version is v1. The version is implicit in the current implementation but may be explicitly required in future updates.

### Testing

For testing payment flows in development environments, use the Razorpay test credentials provided by the Razorpay dashboard.

### Webhooks

Webhooks for payment notifications are available at:

```
POST /api/payment/webhook
```

Webhooks require signature verification using the Razorpay webhook secret.

### Further Information

For implementation details, see:
- [Payment Implementation Guide](../guides/payment-implementation-guide.md)
- [Payment System Architecture](../architecture/PAYMENT_SYSTEM_ARCHITECTURE.md)

*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/technical/3march1am-payment-api-reference.md*

---

## TuneMantra Database Schema Reference (2)

## TuneMantra Database Schema Reference

### Introduction

This comprehensive schema reference document provides detailed information about TuneMantra's database structure, relationships, and implementation details. It serves as the authoritative reference for developers working with the platform's data model.

### Schema Overview

TuneMantra's database is built on PostgreSQL and uses Drizzle ORM for type-safe database interactions. The schema is organized into several logical domains:

1. **User Management**: Authentication, authorization, and user profiles
2. **Content Management**: Music releases, tracks, and metadata
3. **Distribution**: Platform connections and distribution records
4. **Analytics**: Performance tracking and reporting
5. **Royalty Management**: Revenue tracking and payment processing
6. **Support System**: Customer support and ticket tracking
7. **Asset Management**: Media files and associated metadata

### Data Types and Enumerations

#### User Role Enumeration

```typescript
export const userRoleEnum = pgEnum('user_role', [
  'admin',
  'label',
  'artist_manager',
  'artist',
  'team_member'
]);
```

#### User Status Enumeration

```typescript
export const userStatusEnum = pgEnum('user_status', [
  'active',
  'pending',
  'pending_approval',
  'suspended',
  'rejected',
  'inactive'
]);
```

#### Approval Status Enumeration

```typescript
export const approvalStatusEnum = pgEnum('approval_status', [
  'pending',
  'approved',
  'rejected'
]);
```

#### Ticket Status Enumeration

```typescript
export const ticketStatusEnum = pgEnum('ticket_status', [
  'open',
  'in_progress',
  'waiting',
  'closed'
]);
```

#### Ticket Priority Enumeration

```typescript
export const ticketPriorityEnum = pgEnum('ticket_priority', [
  'low',
  'medium',
  'high',
  'critical'
]);
```

#### Ticket Category Enumeration

```typescript
export const ticketCategoryEnum = pgEnum('ticket_category', [
  'technical',
  'billing',
  'content',
  'distribution',
  'other'
]);
```

#### Content Type Enumeration

```typescript
export const contentTypeEnum = pgEnum('content_type', [
  'single',
  'album',
  'ep',
  'compilation',
  'remix',
  'live'
]);
```

#### Audio Format Enumeration

```typescript
export const audioFormatEnum = pgEnum('audio_format', [
  'mp3',
  'wav',
  'flac',
  'aac',
  'ogg',
  'alac',
  'aiff'
]);
```

#### Language Enumeration

```typescript
export const languageEnum = pgEnum('language', [
  'english',
  'spanish',
  'french',
  'german',
  'hindi',
  'japanese',
  'korean',
  'portuguese',
  'russian',
  'mandarin',
  'cantonese',
  'arabic',
  'instrumental'
]);
```

#### Genre Category Enumeration

```typescript
export const genreCategoryEnum = pgEnum('genre_category', [
  'pop',
  'rock',
  'hip_hop',
  'electronic',
  'rb',
  'country',
  'latin',
  'jazz',
  'classical',
  'folk',
  'blues',
  'metal',
  'reggae',
  'world'
]);
```

#### Distribution Status Enumeration

```typescript
export const distributionStatusEnum = pgEnum('distribution_status', [
  'pending',
  'processing',
  'distributed',
  'failed',
  'scheduled',
  'canceled'
]);
```

#### Royalty Type Enumeration

```typescript
export const royaltyTypeEnum = pgEnum('royalty_type', [
  'performance',
  'mechanical',
  'synchronization',
  'print',
  'digital'
]);
```

#### Ownership Type Enumeration

```typescript
export const ownershipTypeEnum = pgEnum('ownership_type', [
  'original',
  'licensed',
  'public_domain',
  'sample_cleared',
  'remix_authorized'
]);
```

### Table Definitions

#### User Management Tables

##### Super Admins Table

```typescript
export const superAdmins = pgTable("super_admins", {
  id: serial("id").primaryKey(),
  email: varchar("email", { length: 255 }).notNull().unique(),
  passwordHash: varchar("password_hash", { length: 255 }).notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull()
});
```

##### Users Table

```typescript
export const users = pgTable("users", {
  id: serial("id").primaryKey(),
  username: varchar("username", { length: 255 }).notNull().unique(),
  email: varchar("email", { length: 255 }).notNull().unique(),
  passwordHash: varchar("password_hash", { length: 255 }).notNull(),
  fullName: varchar("full_name", { length: 255 }),
  phoneNumber: varchar("phone_number", { length: 50 }),
  entityName: varchar("entity_name", { length: 255 }),
  avatarUrl: varchar("avatar_url", { length: 255 }),
  role: userRoleEnum("role").notNull().default('artist'),
  permissions: jsonb("permissions").default({}),
  parentId: integer("parent_id").references(() => users.id),
  status: userStatusEnum("status").notNull().default('pending'),
  subscriptionInfo: jsonb("subscription_info"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

##### API Keys Table

```typescript
export const apiKeys = pgTable("api_keys", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").references(() => users.id).notNull(),
  name: varchar("name", { length: 255 }).notNull(),
  key: varchar("key", { length: 255 }).notNull().unique(),
  scopes: text("scopes").array(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  expiresAt: timestamp("expires_at")
});
```

##### Permission Templates Table

```typescript
export const permissionTemplates = pgTable("permission_templates", {
  id: serial("id").primaryKey(),
  name: varchar("name", { length: 255 }).notNull(),
  description: text("description"),
  permissions: jsonb("permissions").notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

##### Account Approvals Table

```typescript
export const accountApprovals = pgTable("account_approvals", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").references(() => users.id).notNull().unique(),
  adminId: integer("admin_id").references(() => users.id),
  status: approvalStatusEnum("status").notNull().default('pending'),
  notes: text("notes"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

##### Sub Label Audit Logs Table

```typescript
export const subLabelAuditLogs = pgTable("sub_label_audit_logs", {
  id: serial("id").primaryKey(),
  subLabelId: integer("sub_label_id").references(() => users.id).notNull(),
  adminId: integer("admin_id").references(() => users.id).notNull(),
  action: varchar("action", { length: 255 }).notNull(),
  details: jsonb("details"),
  createdAt: timestamp("created_at").defaultNow().notNull()
});
```

##### Release Approvals Table

```typescript
export const releaseApprovals = pgTable("release_approvals", {
  id: serial("id").primaryKey(),
  subLabelId: integer("sub_label_id").references(() => users.id).notNull(),
  releaseId: integer("release_id").references(() => releases.id).notNull(),
  status: approvalStatusEnum("status").notNull().default('pending'),
  feedback: text("feedback"),
  approvedBy: integer("approved_by").references(() => users.id),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

#### Content Management Tables

##### Tracks Table

```typescript
export const tracks = pgTable("tracks", {
  id: serial("id").primaryKey(),
  title: varchar("title", { length: 255 }).notNull(),
  version: varchar("version", { length: 255 }),
  isrc: varchar("isrc", { length: 12 }),
  artistName: varchar("artist_name", { length: 255 }).notNull(),
  duration: integer("duration").default(0),
  language: languageEnum("language").default('english'),
  explicit: boolean("explicit").default(false),
  audioUrl: varchar("audio_url", { length: 255 }),
  releaseId: integer("release_id").references(() => releases.id),
  userId: integer("user_id").references(() => users.id).notNull(),
  genre: genreCategoryEnum("genre"),

  // Enhanced metadata fields
  audioFormat: audioFormatEnum("audio_format"),
  bpm: integer("bpm"),
  key: varchar("key", { length: 10 }),
  moods: text("moods").array(),
  tags: text("tags").array(),
  lyrics: text("lyrics"),
  composition: jsonb("composition"), // Detailed songwriting credits
  recording: jsonb("recording"), // Recording details
  stems: jsonb("stems"), // Links to individual track components
  sampleClearances: jsonb("sample_clearances"), // Sample clearance info
  contentTags: jsonb("content_tags"), // Genre, mood, theme classifications
  aiAnalysis: jsonb("ai_analysis"), // AI-generated content analysis

  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

##### Releases Table

```typescript
export const releases = pgTable("releases", {
  id: serial("id").primaryKey(),
  title: varchar("title", { length: 255 }).notNull(),
  artistName: varchar("artist_name", { length: 255 }).notNull(),
  type: contentTypeEnum("type").notNull(),
  releaseDate: date("release_date").notNull(),
  upc: varchar("upc", { length: 13 }).unique(),
  artworkUrl: varchar("artwork_url", { length: 255 }),
  distributionStatus: distributionStatusEnum("distribution_status").default('pending'),
  userId: integer("user_id").references(() => users.id).notNull(),

  // Enhanced metadata fields
  originalReleaseDate: date("original_release_date"),
  recordLabel: varchar("record_label", { length: 255 }),
  catalogNumber: varchar("catalog_number", { length: 100 }),
  copyright: varchar("copyright", { length: 255 }),
  publishingRights: varchar("publishing_rights", { length: 255 }),
  genres: text("genres").array(),
  primaryGenre: genreCategoryEnum("primary_genre"),
  territories: jsonb("territories"), // Territory-specific distribution settings
  preOrderDate: date("pre_order_date"),
  pricing: jsonb("pricing"), // Pricing tier configuration
  artworkMetadata: jsonb("artwork_metadata"), // Detailed info about artwork
  credits: jsonb("credits"), // Comprehensive personnel credits
  marketingAssets: jsonb("marketing_assets"), // Links to promotional materials
  relatedReleases: integer("related_releases").array(), // Related release IDs
  visibilitySettings: jsonb("visibility_settings"), // Platform visibility config

  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

##### Analytics Table

```typescript
export const analytics = pgTable("analytics", {
  id: serial("id").primaryKey(),
  trackId: integer("track_id").references(() => tracks.id).notNull(),
  platform: varchar("platform", { length: 100 }).notNull(),
  streams: integer("streams").notNull(),
  revenue: decimal("revenue", { precision: 10, scale: 2 }).notNull(),
  date: date("date").notNull(),
  country: varchar("country", { length: 2 }),
  createdAt: timestamp("created_at").defaultNow().notNull()
});
```

##### Daily Stats Table

```typescript
export const dailyStats = pgTable("daily_stats", {
  id: serial("id").primaryKey(),
  trackId: integer("track_id").references(() => tracks.id).notNull(),
  date: date("date").notNull(),
  streams: integer("streams").notNull(),
  revenue: decimal("revenue", { precision: 10, scale: 2 }).notNull(),
  platform: varchar("platform", { length: 100 }).notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

#### Distribution Tables

##### Distribution Platforms Table

```typescript
export const distributionPlatforms = pgTable("distribution_platforms", {
  id: serial("id").primaryKey(),
  name: varchar("name", { length: 255 }).notNull(),
  apiEndpoint: varchar("api_endpoint", { length: 255 }),
  logoUrl: varchar("logo_url", { length: 255 }),
  type: varchar("type", { length: 50 }).notNull(),
  credentials: jsonb("credentials"),
  active: boolean("active").default(true),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

##### Distribution Records Table

```typescript
export const distributionRecords = pgTable("distribution_records", {
  id: serial("id").primaryKey(),
  releaseId: integer("release_id").references(() => releases.id).notNull(),
  platformId: integer("platform_id").references(() => distributionPlatforms.id).notNull(),
  status: distributionStatusEnum("status").default('pending'),
  notes: text("notes"),
  userId: integer("user_id").references(() => users.id).notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

##### Scheduled Distributions Table

```typescript
export const scheduledDistributions = pgTable("scheduled_distributions", {
  id: serial("id").primaryKey(),
  releaseId: integer("release_id").references(() => releases.id).notNull(),
  platformId: integer("platform_id").references(() => distributionPlatforms.id).notNull(),
  scheduledDate: timestamp("scheduled_date").notNull(),
  status: distributionStatusEnum("status").default('scheduled'),
  userId: integer("user_id").references(() => users.id).notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

#### Royalty Management Tables

##### Payment Methods Table

```typescript
export const paymentMethods = pgTable("payment_methods", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").references(() => users.id).notNull(),
  type: varchar("type", { length: 50 }).notNull(),
  details: jsonb("details").notNull(),
  isDefault: boolean("is_default").default(false),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

##### Withdrawals Table

```typescript
export const withdrawals = pgTable("withdrawals", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").references(() => users.id).notNull(),
  amount: decimal("amount", { precision: 10, scale: 2 }).notNull(),
  status: varchar("status", { length: 50 }).notNull().default('pending'),
  paymentMethod: integer("payment_method").references(() => paymentMethods.id).notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

##### Revenue Shares Table

```typescript
export const revenueShares = pgTable("revenue_shares", {
  id: serial("id").primaryKey(),
  releaseId: integer("release_id").references(() => releases.id).notNull(),
  userId: integer("user_id").references(() => users.id).notNull(),
  percentage: decimal("percentage", { precision: 5, scale: 2 }).notNull(),
  role: varchar("role", { length: 50 }).notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

#### Rights Management Tables

```typescript
export const rightsManagement = pgTable("rights_management", {
  id: serial("id").primaryKey(),
  releaseId: integer("release_id").references(() => releases.id),
  trackId: integer("track_id").references(() => tracks.id),
  ownershipType: ownershipTypeEnum("ownership_type").notNull(),
  rightsHolders: jsonb("rights_holders").notNull(), // Detailed rights holders info
  territory: text("territory").array(), // Applicable territories
  startDate: date("start_date").notNull(),
  endDate: date("end_date"),
  licenseTerms: jsonb("license_terms"), // Detailed license information
  documentUrl: varchar("document_url", { length: 255 }), // Link to legal document
  verificationStatus: varchar("verification_status", { length: 50 }).notNull().default('pending'),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

```typescript
export const royaltySplits = pgTable("royalty_splits", {
  id: serial("id").primaryKey(),
  releaseId: integer("release_id").references(() => releases.id),
  trackId: integer("track_id").references(() => tracks.id),
  royaltyType: royaltyTypeEnum("royalty_type").notNull(),
  splitDetails: jsonb("split_details").notNull(), // Detailed split information
  effectiveDate: date("effective_date").notNull(),
  territory: text("territory").array(), // Applicable territories
  customRules: jsonb("custom_rules"), // Special royalty calculation rules
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

#### Support System Tables

##### Support Tickets Table

```typescript
export const supportTickets = pgTable("support_tickets", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").references(() => users.id).notNull(),
  title: varchar("title", { length: 255 }).notNull(),
  description: text("description").notNull(),
  status: ticketStatusEnum("status").notNull().default('open'),
  priority: ticketPriorityEnum("priority").notNull().default('medium'),
  category: ticketCategoryEnum("category").notNull().default('technical'),
  assignedTo: integer("assigned_to").references(() => users.id),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

##### Support Ticket Messages Table

```typescript
export const supportTicketMessages = pgTable("support_ticket_messages", {
  id: serial("id").primaryKey(),
  ticketId: integer("ticket_id").references(() => supportTickets.id).notNull(),
  userId: integer("user_id").references(() => users.id).notNull(),
  message: text("message").notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull()
});
```

#### Asset Management Tables

##### Asset Bundles Table

```typescript
export const assetBundles = pgTable("asset_bundles", {
  id: serial("id").primaryKey(),
  name: varchar("name", { length: 255 }).notNull(),
  type: varchar("type", { length: 50 }).notNull(),
  description: text("description"),
  userId: integer("user_id").references(() => users.id).notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

##### Asset Versions Table

```typescript
export const assetVersions = pgTable("asset_versions", {
  id: serial("id").primaryKey(),
  bundleId: integer("bundle_id").references(() => assetBundles.id).notNull(),
  version: varchar("version", { length: 50 }).notNull(),
  fileUrl: varchar("file_url", { length: 255 }).notNull(),
  fileSize: integer("file_size").notNull(),
  mimeType: varchar("mime_type", { length: 100 }).notNull(),
  metadata: jsonb("metadata"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  isActive: boolean("is_active").default(true)
});
```

##### Bundle Analytics Table

```typescript
export const bundleAnalytics = pgTable("bundle_analytics", {
  id: serial("id").primaryKey(),
  bundleId: integer("bundle_id").references(() => assetBundles.id).notNull(),
  views: integer("views").default(0),
  downloads: integer("downloads").default(0),
  shares: integer("shares").default(0),
  date: date("date").notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

##### Import Batches Table

```typescript
export const importBatches = pgTable("import_batches", {
  id: serial("id").primaryKey(),
  name: varchar("name", { length: 255 }).notNull(),
  type: varchar("type", { length: 50 }).notNull(),
  status: varchar("status", { length: 50 }).notNull().default('pending'),
  fileUrl: varchar("file_url", { length: 255 }),
  recordsTotal: integer("records_total").default(0),
  recordsProcessed: integer("records_processed").default(0),
  recordsError: integer("records_error").default(0),
  errorDetails: jsonb("error_details"),
  userId: integer("user_id").references(() => users.id).notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});
```

### Schema Relationships

TuneMantra's database schema is designed with carefully defined relationships between tables to ensure data integrity and efficient querying. Below are the key relationships in the system:

#### User Management Relationships

```typescript
export const usersRelations = relations(users, ({ many, one }) => ({
  apiKeys: many(apiKeys),
  tracks: many(tracks),
  releases: many(releases),
  withdrawals: many(withdrawals),
  paymentMethods: many(paymentMethods),
  supportTickets: many(supportTickets),
  supportTicketMessages: many(supportTicketMessages),
  assetBundles: many(assetBundles),
  parent: one(users, {
    fields: [users.parentId],
    references: [users.id]
  }),
  teamMembers: many(users, {
    relationName: "teamMembers"
  }),
  accountApproval: one(accountApprovals, {
    fields: [users.id],
    references: [accountApprovals.userId]
  })
}));

export const accountApprovalsRelations = relations(accountApprovals, ({ one }) => ({
  user: one(users, {
    fields: [accountApprovals.userId],
    references: [users.id]
  }),
  admin: one(users, {
    fields: [accountApprovals.adminId],
    references: [users.id]
  })
}));
```

#### Content Management Relationships

```typescript
export const tracksRelations = relations(tracks, ({ one, many }) => ({
  user: one(users, {
    fields: [tracks.userId],
    references: [users.id]
  }),
  release: one(releases, {
    fields: [tracks.releaseId],
    references: [releases.id]
  }),
  analytics: many(analytics),
  dailyStats: many(dailyStats)
}));

export const releasesRelations = relations(releases, ({ one, many }) => ({
  user: one(users, {
    fields: [releases.userId],
    references: [users.id]
  }),
  tracks: many(tracks),
  revenueShares: many(revenueShares),
  distributionRecords: many(distributionRecords),
  scheduledDistributions: many(scheduledDistributions),
  releaseApprovals: many(releaseApprovals)
}));
```

#### Analytics Relationships

```typescript
export const analyticsRelations = relations(analytics, ({ one }) => ({
  track: one(tracks, {
    fields: [analytics.trackId],
    references: [tracks.id]
  })
}));

export const dailyStatsRelations = relations(dailyStats, ({ one }) => ({
  track: one(tracks, {
    fields: [dailyStats.trackId],
    references: [tracks.id]
  })
}));
```

#### Distribution Relationships

```typescript
export const distributionRecordsRelations = relations(distributionRecords, ({ one }) => ({
  release: one(releases, {
    fields: [distributionRecords.releaseId],
    references: [releases.id]
  }),
  platform: one(distributionPlatforms, {
    fields: [distributionRecords.platformId],
    references: [distributionPlatforms.id]
  }),
  user: one(users, {
    fields: [distributionRecords.userId],
    references: [users.id]
  })
}));

export const scheduledDistributionsRelations = relations(scheduledDistributions, ({ one }) => ({
  release: one(releases, {
    fields: [scheduledDistributions.releaseId],
    references: [releases.id]
  }),
  platform: one(distributionPlatforms, {
    fields: [scheduledDistributions.platformId],
    references: [distributionPlatforms.id]
  }),
  user: one(users, {
    fields: [scheduledDistributions.userId],
    references: [users.id]
  })
}));
```

#### Payment Relationships

```typescript
export const paymentMethodsRelations = relations(paymentMethods, ({ one, many }) => ({
  user: one(users, {
    fields: [paymentMethods.userId],
    references: [users.id]
  }),
  withdrawals: many(withdrawals)
}));

export const withdrawalsRelations = relations(withdrawals, ({ one }) => ({
  user: one(users, {
    fields: [withdrawals.userId],
    references: [users.id]
  }),
  paymentMethod: one(paymentMethods, {
    fields: [withdrawals.paymentMethod],
    references: [paymentMethods.id]
  })
}));

export const revenueSharesRelations = relations(revenueShares, ({ one }) => ({
  release: one(releases, {
    fields: [revenueShares.releaseId],
    references: [releases.id]
  }),
  user: one(users, {
    fields: [revenueShares.userId],
    references: [users.id]
  })
}));
```

#### Support System Relationships

```typescript
export const supportTicketsRelations = relations(supportTickets, ({ one, many }) => ({
  user: one(users, {
    fields: [supportTickets.userId],
    references: [users.id]
  }),
  assignedTo: one(users, {
    fields: [supportTickets.assignedTo],
    references: [users.id]
  }),
  messages: many(supportTicketMessages)
}));

export const supportTicketMessagesRelations = relations(supportTicketMessages, ({ one }) => ({
  ticket: one(supportTickets, {
    fields: [supportTicketMessages.ticketId],
    references: [supportTickets.id]
  }),
  user: one(users, {
    fields: [supportTicketMessages.userId],
    references: [users.id]
  })
}));
```

#### Asset Management Relationships

```typescript
export const assetBundlesRelations = relations(assetBundles, ({ one, many }) => ({
  user: one(users, {
    fields: [assetBundles.userId],
    references: [users.id]
  }),
  versions: many(assetVersions),
  analytics: many(bundleAnalytics)
}));

export const assetVersionsRelations = relations(assetVersions, ({ one }) => ({
  bundle: one(assetBundles, {
    fields: [assetVersions.bundleId],
    references: [assetBundles.id]
  })
}));

export const bundleAnalyticsRelations = relations(bundleAnalytics, ({ one }) => ({
  bundle: one(assetBundles, {
    fields: [bundleAnalytics.bundleId],
    references: [assetBundles.id]
  })
}));
```

### Schema Types

TuneMantra uses TypeScript interfaces and custom types to ensure type safety when working with database records. The following type definitions are defined for each table:

```typescript
export type SuperAdmin = typeof superAdmins.$inferSelect;
export type InsertSuperAdmin = typeof superAdmins.$inferInsert;

export type User = typeof users.$inferSelect;
export type InsertUser = z.infer<typeof insertUserSchema>;

export type ApiKey = typeof apiKeys.$inferSelect;
export type InsertApiKey = z.infer<typeof insertApiKeySchema>;

export type Track = typeof tracks.$inferSelect;
export type InsertTrack = z.infer<typeof insertTrackSchema>;

export type Release = typeof releases.$inferSelect;
export type InsertRelease = z.infer<typeof insertReleaseSchema>;

export type Analytics = typeof analytics.$inferSelect;
export type InsertAnalytics = z.infer<typeof insertAnalyticsSchema>;

export type DailyStats = typeof dailyStats.$inferSelect;
export type InsertDailyStats = z.infer<typeof insertDailyStatsSchema>;

export type PaymentMethod = typeof paymentMethods.$inferSelect;
export type InsertPaymentMethod = z.infer<typeof insertPaymentMethodSchema>;

export type Withdrawal = typeof withdrawals.$inferSelect;
export type InsertWithdrawal = z.infer<typeof insertWithdrawalSchema>;

export type RevenueShare = typeof revenueShares.$inferSelect;
export type InsertRevenueShare = z.infer<typeof insertRevenueShareSchema>;

export type DistributionPlatform = typeof distributionPlatforms.$inferSelect;
export type InsertDistributionPlatform = z.infer<typeof insertDistributionPlatformSchema>;

export type DistributionRecord = typeof distributionRecords.$inferSelect;
export type InsertDistributionRecord = z.infer<typeof insertDistributionRecordSchema>;

export type ScheduledDistribution = typeof scheduledDistributions.$inferSelect;
export type InsertScheduledDistribution = z.infer<typeof insertScheduledDistributionSchema>;

export type SupportTicket = typeof supportTickets.$inferSelect;
export type InsertSupportTicket = z.infer<typeof insertSupportTicketSchema>;

export type SupportTicketMessage = typeof supportTicketMessages.$inferSelect;
export type InsertSupportTicketMessage = z.infer<typeof insertSupportTicketMessageSchema>;

export type AccountApproval = typeof accountApprovals.$inferSelect;
export type InsertAccountApproval = z.infer<typeof insertAccountApprovalSchema>;

export type SubLabelAuditLog = typeof subLabelAuditLogs.$inferSelect;
export type InsertSubLabelAuditLog = typeof subLabelAuditLogs.$inferInsert;

export type PermissionTemplate = typeof permissionTemplates.$inferSelect;
export type InsertPermissionTemplate = typeof permissionTemplates.$inferInsert;

export type ReleaseApproval = typeof releaseApprovals.$inferSelect;
export type InsertReleaseApproval = typeof releaseApprovals.$inferInsert;

export type AssetBundle = typeof assetBundles.$inferSelect;
export type InsertAssetBundle = z.infer<typeof assetBundleSchema>;

export type AssetVersion = typeof assetVersions.$inferSelect;
export type InsertAssetVersion = z.infer<typeof assetVersionSchema>;

export type BundleAnalytics = typeof bundleAnalytics.$inferSelect;
export type InsertBundleAnalytics = z.infer<typeof bundleAnalyticsSchema>;

export type ImportBatch = typeof importBatches.$inferSelect;
export type InsertImportBatch = z.infer<typeof importBatchSchema>;

export type RightsManagement = typeof rightsManagement.$inferSelect;
export type InsertRightsManagement = z.infer<typeof insertRightsManagementSchema>;

export type RoyaltySplit = typeof royaltySplits.$inferSelect;
export type InsertRoyaltySplit = z.infer<typeof insertRoyaltySplitSchema>;
```

### Complex Data Types

TuneMantra uses JSON columns to store complex data types that would be inefficient to normalize into separate tables. Below are the primary JSON structures used throughout the schema:

#### Permissions Object

Used in the `permissions` column of the `users` table:

```typescript
export interface UserPermissions {
  canCreateReleases?: boolean;
  canManageArtists?: boolean;
  canViewAnalytics?: boolean;
  canManageDistribution?: boolean;
  canManageRoyalties?: boolean;
  canEditMetadata?: boolean;
  canAccessFinancials?: boolean;
  canInviteUsers?: boolean;
  maxArtists?: number;
  maxReleases?: number;
  canManageUsers?: boolean;
  canManageSubscriptions?: boolean;
  canAccessAdminPanel?: boolean;
  canViewAllContent?: boolean;
  canViewAllReports?: boolean;
}
```

#### Label Settings Object

```typescript
export const labelSettingsSchema = z.object({
  displayName: z.string(),
  logoUrl: z.string().optional(),
  primaryColor: z.string().optional(),
  secondaryColor: z.string().optional(),
  contactEmail: z.string().email(),
  website: z.string().url().optional(),
  socialLinks: z.object({
    instagram: z.string().optional(),
    twitter: z.string().optional(),
    facebook: z.string().optional(),
    youtube: z.string().optional(),
    tiktok: z.string().optional()
  }).optional(),
  artistPortalEnabled: z.boolean().default(false),
  customDomain: z.string().optional(),
  emailTemplates: z.record(z.string()).optional(),
  defaultSplitTemplates: z.array(z.object({
    name: z.string(),
    splits: z.array(z.object({
      role: z.string(),
      percentage: z.number()
    }))
  })).optional()
});

export type LabelSettings = z.infer<typeof labelSettingsSchema>;
```

#### Subscription Information Object

```typescript
export interface SubscriptionInfo {
  plan: 'free' | 'artist' | 'label' | 'enterprise';
  startDate: Date;
  endDate: Date;
  status: 'active' | 'pending' | 'pending_approval' | 'canceled' | 'expired' | 'inactive' | 'rejected';
  paymentId?: string;
  features?: string[];
  yearlyPriceInINR?: number;
}
```

#### Content Tags Object

```typescript
export interface ContentTags {
  genres: string[];
  moods: string[];
  themes: string[];
  keywords: string[];
  musicalElements: string[];
  occasions: string[];
  cultures: string[];
  eras: string[];
}
```

#### AI Analysis Object

```typescript
export interface AIAnalysis {
  summary: string;
  qualityScore: number;
  contentWarnings: string[];
  suggestedImprovements: string[];
  genrePredictions: {
    primaryGenre: string;
    confidence: number;
    secondaryGenres: Array<{genre: string, confidence: number}>;
  };
  moodPredictions: Array<{mood: string, confidence: number}>;
  similarArtists: string[];
  keyPrediction: string;
  bpmPrediction: number;
  energyLevel: number;
  danceability: number;
  marketPotential: {
    streamingPotential: number;
    radioFriendliness: number;
    commercialViability: number;
    targetDemographics: string[];
  };
}
```

#### Credits Object

```typescript
export interface Credits {
  primaryArtist: string[];
  featuredArtists: string[];
  composers: string[];
  lyricists: string[];
  producers: string[];
  mixingEngineers: string[];
  masteringEngineers: string[];
  musicians: Array<{
    name: string;
    role: string;
    instrument?: string;
  }>;
  vocalists: Array<{
    name: string;
    role: string; // e.g., "lead", "backup", "harmony"
  }>;
  additionalPersonnel: Array<{
    name: string;
    role: string;
  }>;
  artworkCredits: {
    designer: string;
    photographer?: string;
    illustrator?: string;
    artDirector?: string;
  };
}
```

#### Artwork Metadata Object

```typescript
export interface ArtworkMetadata {
  dimensions: {
    width: number;
    height: number;
  };
  resolution: number; // in DPI
  fileSize: number; // in bytes
  format: string; // e.g., "jpeg", "png"
  colorSpace: string; // e.g., "RGB", "CMYK"
  primaryColors: string[];
  hasParentalAdvisoryLabel: boolean;
  versions: Array<{
    url: string;
    purpose: string; // e.g., "cover", "thumbnail", "promo"
    dimensions: {
      width: number;
      height: number;
    };
  }>;
}
```

#### Audio Metadata Object

```typescript
export interface AudioMetadata {
  format: string;
  sampleRate: number;
  bitDepth: number;
  channels: number;
  duration: number;
  bitrate: number;
  fileSize: number;
  codec: string;
  checksum: string;
}
```

#### Sample Details Object

```typescript
export interface SampleDetails {
  originalTrack: string;
  originalArtist: string;
  sampleTimecodes: {
    start: string;
    end: string;
  }[];
  clearanceReference: string;
  clearanceDate?: Date;
  clearanceType: 'paid' | 'royalty' | 'free' | 'fair use';
  usageDescription: string;
}
```

#### Visibility Settings Object

```typescript
export interface VisibilitySettings {
  searchable: boolean;
  featured: boolean;
  playlistEligible: boolean;
  storeVisibility: {
    [storeName: string]: boolean;
  };
  territoryRestrictions?: string[];
}
```

### Validation Schemas

TuneMantra uses Zod for runtime validation of data before inserting into the database. Insert schemas are created from tables using Drizzle's `createInsertSchema` helper function, with additional validations added:

```typescript
export const insertUserSchema = createInsertSchema(users)
  .omit({
    id: true,
    passwordHash: true,
    createdAt: true,
    updatedAt: true
  })
  .extend({
    password: z.string().min(8).max(100),
    confirmPassword: z.string().min(8).max(100)
  })
  .refine(data => data.password === data.confirmPassword, {
    message: "Passwords don't match",
    path: ["confirmPassword"]
  });

export const insertApiKeySchema = createInsertSchema(apiKeys)
  .omit({
    id: true,
    key: true,
    createdAt: true
  });

export const insertReleaseSchema = createInsertSchema(releases)
  .omit({
    id: true,
    upc: true,
    createdAt: true,
    updatedAt: true
  });

export const insertTrackSchema = createInsertSchema(tracks)
  .omit({
    id: true,
    createdAt: true,
    updatedAt: true
  });

export const insertAnalyticsSchema = createInsertSchema(analytics).omit({
  id: true,
  createdAt: true
});

export const insertDailyStatsSchema = createInsertSchema(dailyStats).omit({
  id: true,
  createdAt: true,
  updatedAt: true
});

export const insertPaymentMethodSchema = createInsertSchema(paymentMethods)
  .omit({
    id: true,
    createdAt: true,
    updatedAt: true
  });

export const insertWithdrawalSchema = createInsertSchema(withdrawals)
  .omit({
    id: true,
    createdAt: true,
    updatedAt: true
  });

export const insertRevenueShareSchema = createInsertSchema(revenueShares)
  .omit({
    id: true,
    createdAt: true,
    updatedAt: true
  });

export const insertDistributionPlatformSchema = createInsertSchema(distributionPlatforms)
  .omit({
    id: true,
    createdAt: true,
    updatedAt: true
  });

export const insertDistributionRecordSchema = createInsertSchema(distributionRecords)
  .omit({
    id: true,
    createdAt: true,
    updatedAt: true
  });

export const insertScheduledDistributionSchema = createInsertSchema(scheduledDistributions)
  .omit({
    id: true,
    createdAt: true,
    updatedAt: true
  });
```

### Database Utility Functions

#### UPC Generator

```typescript
function generateUPC(): string {
  // Generate a valid UPC-A code (12 digits)
  const prefix = "0"; // Standard UPC-A prefix
  let base = String(Math.floor(Math.random() * 1000000000000)).padStart(11, "0");
  base = prefix + base.substring(0, 11); // Ensure 12 digits total

  // Calculate check digit
  let sum = 0;
  for (let i = 0; i < 12; i++) {
    sum += parseInt(base[i]) * (i % 2 === 0 ? 3 : 1);
  }
  const checkDigit = (10 - (sum % 10)) % 10;

  return base + checkDigit;
}
```

### Schema Migrations

Migrations are managed through Drizzle Kit. The main migration scripts are located in the `server/migrations` directory:

1. `add-role-based-access.ts`: Adds role-based access control fields to users table
2. `add-permissions-column.ts`: Adds permissions JSON column to users table
3. `add-approval-details.ts`: Creates account approval tracking table
4. `add-enhanced-metadata.ts`: Adds enhanced metadata fields to releases and tracks tables

### Best Practices

#### Working with the Schema

1. **Schema Modifications**: Always use migrations to modify the schema
2. **Validation**: Always validate data with Zod schemas before inserting/updating
3. **Type Safety**: Use generated TypeScript types (e.g., `InsertUser`, `User`) for type safety
4. **Complex Data**: Use JSON columns for complex, nested data that doesn't need to be queried
5. **Relationships**: Define relationships explicitly using Drizzle's relations API

#### Performance Considerations

1. **Indexing**: Add indexes to frequently queried columns
2. **Pagination**: Always use pagination for large result sets
3. **JSON Queries**: Minimize complex queries on JSON columns
4. **Transactions**: Use transactions for operations that modify multiple tables
5. **Connection Pooling**: Use the connection pool for efficient database connections

### Appendix

#### Database Connection

```typescript
// server/db.ts
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from '../shared/schema';

export const pool = new Pool({ connectionString: process.env.DATABASE_URL });
export const db = drizzle({ client: pool, schema });
```

#### Database Storage Interface

```typescript
// server/storage.ts (excerpt)
export interface IStorage {
  sessionStore: session.Store;

  // User methods
  getAllUsers(options?: { 
    status?: string; 
    search?: string;
    page?: number;
    limit?: number;
  }): Promise<User[]>;
  getUser(id: number): Promise<User | undefined>;
  getUserByUsername(username: string): Promise<User | undefined>;
  createUser(insertUser: InsertUser): Promise<User>;
  updateUser(id: number, updateData: Partial<User>): Promise<User>;
  updateUserStatus(id: number, status: string): Promise<User | undefined>;
  getUserCount(options?: { status?: string; search?: string; }): Promise<number>;

  // API Key methods
  createApiKey(data: { userId: number; name: string; scopes: string[] }): Promise<ApiKey>;
  getApiKeys(userId: number): Promise<ApiKey[]>;
  deleteApiKey(id: number): Promise<void>;

  // Track methods
  getTracksByUserId(userId: number): Promise<Track[]>;
  createTrack(userId: number, track: InsertTrack): Promise<Track>;
  updateTrack(id: number, track: Partial<Track>): Promise<Track>;

  // Analytics methods
  getTrackAnalytics(trackId: number): Promise<Analytics[]>;
  createAnalytics(analytics: InsertAnalytics): Promise<Analytics>;

  // Release methods
  getReleasesByUserId(userId: number): Promise<Release[]>;
  createRelease(userId: number, release: InsertRelease): Promise<Release>;
  updateRelease(id: number, release: Partial<Release>): Promise<Release>;
  getReleaseById(id: number): Promise<Release | undefined>;

  // Distribution methods
  getScheduledDistributions(userId: number): Promise<ScheduledDistribution[]>;
  createScheduledDistribution(distribution: InsertScheduledDistribution): Promise<ScheduledDistribution>;
  updateScheduledDistribution(id: number, updates: Partial<ScheduledDistribution>): Promise<ScheduledDistribution>;
  getScheduledDistributionById(id: number): Promise<ScheduledDistribution | undefined>;
  getDistributionPlatforms(): Promise<DistributionPlatform[]>;
  createDistributionPlatform(platform: InsertDistributionPlatform): Promise<DistributionPlatform>;
  updateDistributionPlatform(id: number, updates: Partial<DistributionPlatform>): Promise<DistributionPlatform>;
  getDistributionRecords(releaseId?: number): Promise<DistributionRecord[]>;
  createDistributionRecord(record: InsertDistributionRecord): Promise<DistributionRecord>;
  updateDistributionRecord(id: number, updates: Partial<DistributionRecord>): Promise<DistributionRecord>;

  // Audit logging
  createSubLabelAuditLog(log: InsertSubLabelAuditLog): Promise<SubLabelAuditLog>;
  getSubLabelAuditLogs(subLabelId: number): Promise<SubLabelAuditLog[]>;

  // Team management
  getTeamMembers(subLabelId: number): Promise<User[]>;
  updateTeamMember(userId: number, updates: Partial<User>): Promise<User>;

  // Support system
  getSupportTicketsByUserId(userId: number): Promise<SupportTicket[]>;
  getSupportTicketById(id: number): Promise<SupportTicket | undefined>;
  getAllSupportTickets(): Promise<SupportTicket[]>;
  getTicketMessagesByTicketId(ticketId: number): Promise<SupportTicketMessage[]>;
  createSupportTicket(data: InsertSupportTicket): Promise<SupportTicket>;
  createTicketMessage(data: InsertSupportTicketMessage): Promise<SupportTicketMessage>;
  updateSupportTicketStatus(id: number, status: "open" | "in_progress" | "waiting" | "closed", adminId?: number): Promise<SupportTicket>;
  assignSupportTicket(id: number, adminId: number): Promise<SupportTicket>;

  // Payment methods
  getPaymentMethods(userId: number): Promise<PaymentMethod[]>;
  createPaymentMethod(userId: number, method: InsertPaymentMethod): Promise<PaymentMethod>;

  // Withdrawals
  getWithdrawals(userId: number): Promise<Withdrawal[]>;
  createWithdrawal(userId: number, withdrawal: InsertWithdrawal): Promise<Withdrawal>;

  // Revenue shares
  getRevenueShares(releaseId: number): Promise<RevenueShare[]>;
  createRevenueShare(share: InsertRevenueShare): Promise<RevenueShare>;

  // Permission templates
  getPermissionTemplates(): Promise<PermissionTemplate[]>;
  createPermissionTemplate(template: InsertPermissionTemplate): Promise<PermissionTemplate>;
  updatePermissionTemplate(id: number, updates: Partial<PermissionTemplate>): Promise<PermissionTemplate>;

  // Release approvals
  createReleaseApproval(approval: InsertReleaseApproval): Promise<ReleaseApproval>;
  getReleaseApprovals(subLabelId: number): Promise<ReleaseApproval[]>;
  updateReleaseApproval(id: number, updates: Partial<ReleaseApproval>): Promise<ReleaseApproval>;
}
```

---

*© 2025 TuneMantra. All rights reserved.*

*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/technical/temp-3march-schema-reference.md*

---

## Unified Documentation: API Reference (Current as of 2025-03-23)

## Unified Documentation: API Reference (Current as of 2025-03-23)
Generated on Sun 23 Mar 2025 11:35:40 PM UTC

This document presents a comprehensive, chronologically organized collection of all API Reference information, carefully merged to eliminate duplication while preserving all valuable content.

### Current Status Summary

**Project Completion: 97.03% (98 of 101 planned features)**

| Component | Status | Completion % |
|-----------|--------|--------------|
| Backend Core Services | Near completion | 95.00% |
| Frontend UI | Near completion | 96.00% |
| Distribution System | Complete | 100.00% |
| Analytics Engine | Advanced development | 87.50% |
| Royalty Management | Complete | 100.00% |
| User Management | Complete | 100.00% |
| Payment System | Complete | 100.00% |
| Documentation | Complete | 100.00% |
| Testing | Complete | 100.00% |

**Target completion date: May 1, 2025**

### Table of Contents

1. [Current Status Summary](#current-status-summary)
2. [Implementation Timeline](#implementation-timeline)
3. [Core Features Status](#core-features-status)
4. [Component Status Details](#component-status-details)
5. [Recent Updates](#recent-updates)
6. [Known Issues and Challenges](#known-issues-and-challenges)
7. [Upcoming Milestones](#upcoming-milestones)
8. [Feature Details](#feature-details)
9. [Historical Development Progress](#historical-development-progress)

---

### Implementation Timeline
<a id="implementation-timeline"></a>

| Date | Major Milestones |
|------|-----------------|
| March 23, 2025 | Project reaches 97.03% completion |
| March 22, 2025 | Comprehensive documentation update completion |
| March 15, 2025 | Distribution system improvements and platform connections complete |
| March 10, 2025 | Advanced analytics dashboard released |
| March 3, 2025 | Artist verification system and catalogue ID system implementation |
| February 28, 2025 | Mobile app development initial phase completion |
| February 25, 2025 | Platform-wide performance optimization (+40% speed) |
| February 18, 2025 | Rights management system enhancements |
| February 10, 2025 | Distribution feature enhancements |
| January 25, 2025 | Analytics system upgrade |
| January 15, 2025 | Payment & revenue management system enhancement |

---

### Core Features Status
<a id="core-features-status"></a>

| Feature Area                   | Status      | Notes                                              |
|-------------------------------|-------------|---------------------------------------------------|
| User Authentication           | ✅ Complete | User login, registration, and role-based access    |
| Music Catalog Management      | ✅ Complete | Track uploads, metadata editing, and organization  |
| Distribution Management       | ✅ Complete | Platform connections, scheduling, and monitoring   |
| Payment & Revenue Management  | ✅ Complete | Multiple payment methods, withdrawals, revenue splits|
| Analytics & Reporting         | ✅ Complete | Performance tracking across platforms              |
| Rights Management             | 🚫 Removed  | Functionality removed to focus on core features    |
| Admin Controls                | ✅ Complete | User management, platform settings, and approvals  |
| API Access                    | ✅ Complete | API keys, documentation, and rate limiting         |
| White Label Features          | ✅ Complete | Custom branding and domain options                 |
| Artist Verification System    | ✅ Complete | Admin-verified artists for primary artist selection|
| Catalogue ID System           | ✅ Complete | Automated unique IDs for all music releases        |
| Custom User Limits            | ✅ Complete | Admin-controlled limits overriding subscription defaults |

---

### Component Status Details
<a id="component-status-details"></a>

#### Backend Core Services (95.00% Complete)
- API structure completely implemented
- Data persistence layer fully functional
- One final endpoint needed for advanced features

#### Frontend UI (96.00% Complete)
- All main screens fully implemented and functional
- Dashboard components complete
- Minor enhancements needed for advanced analytics views

#### Distribution System (100.00% Complete)
- Multi-platform distribution fully implemented
- Metadata validation and standardization complete
- Automatic format conversion for audio files complete
- Batch upload processing implemented
- Distribution status tracking operational
- Error reporting and resolution workflow complete
- Specialized format support for all platforms complete

#### Analytics Engine (87.50% Complete)
- Stream count aggregation across platforms complete
- Revenue tracking and reporting fully functional
- Basic trend analysis implemented
- Data export capabilities (CSV, Excel) complete
- Customizable date ranges implemented
- Advanced visualization dashboards complete
- Predictive analytics in development

#### Royalty Management (100.00% Complete)
- Royalty calculation engine fully implemented
- Split payment configuration complete
- Payment history tracking operational
- Tax management integration complete
- Currency conversion implemented
- Automated payments to multiple stakeholders complete

#### User Management (100.00% Complete)
- Multi-tenant architecture fully implemented
- Role-based access control complete
- Self-service registration operational
- Profile management complete
- Two-factor authentication implemented
- Password recovery system functional
- Session management complete
- Activity logging implemented
- Advanced permission customization complete

#### Payment System (100.00% Complete)
- Multiple payment methods (credit card, ACH, PayPal) implemented
- Subscription management complete
- Invoice generation fully functional
- Receipt storage implemented
- Payment reminder system operational
- International tax compliance complete
- Cryptocurrency payment options implemented

---

### Recent Updates
<a id="recent-updates"></a>

#### March 2025
- Completed final system testing and verification
- Updated all documentation to reflect 97.03% completion status
- Implemented comprehensive artist verification system with admin-only controls
- Created automated catalogue ID generation following the TMCAT-XXX-NNNNN format
- Enhanced payment method management with multiple payment types (bank, card, PayPal)
- Improved revenue splits system with validation and percentage distribution
- Added custom user limits allowing admins to override subscription-based limits
- Fixed TypeScript errors in the AdminSidebar component
- Implemented missing royalty calculation service functionality
- Fixed icon imports in the navigation components
- Completed integration between distribution and royalty systems

#### February 2025
- Enhanced metadata validation for major platforms
- Added bulk distribution capabilities
- Improved distribution status tracking
- Implemented detailed error reporting
- Platform-wide performance optimization (+40% speed)
- Rights management system enhancements

#### January 2025
- Rebuilt analytics engine for faster performance
- Added platform-specific reporting
- Enhanced geographic and demographic data
- Implemented revenue forecasting features

---

### Known Issues and Challenges
<a id="known-issues-and-challenges"></a>

1. **Performance Optimization**
   - Large batch uploads may cause temporary performance degradation
   - Current solution: Implemented queuing system, further optimizations planned

2. **Third-party API Reliability**
   - Some music platforms have inconsistent API responses
   - Current solution: Enhanced error handling and retry logic

3. **Data Synchronization**
   - Delays in syncing analytics data from some platforms
   - Current solution: Implemented scheduled background jobs, monitoring system in place

4. **Minor Issues**
   - Distribution to YouTube Music occasionally reports delayed status updates
   - Bank account verification takes longer than expected for some regions
   - User role permissions may need additional granularity for large teams
   - TypeScript type errors in some components need resolution

---

### Upcoming Milestones
<a id="upcoming-milestones"></a>

| Milestone | Target Date | Status |
|-----------|-------------|--------|
| Final Feature Completion | May 1, 2025 | In progress |
| Analytics Dashboard 2.0 | April 10, 2025 | In progress |
| Mobile App Beta | April 25, 2025 | In progress |
| Automated Royalty System | May 5, 2025 | In progress |
| International Tax Compliance | May 15, 2025 | Planning |
| Blockchain Integration | June 1, 2025 | Planning |
| AI-Powered Insights | July 10, 2025 | Research phase |

#### Upcoming Development Focus

##### Directory Structure Optimization (Planned for April 2025)
- Organize components by feature domain rather than component type
- Improve code reusability with shared pattern libraries
- Create standardized naming conventions across the codebase
- Reduce unnecessary nesting in component directory structure

##### One-Time Setup Installer Page (Planned for April 2025)
- Streamlined first-run experience with guided setup
- Initial admin account creation interface
- Platform configuration wizard
- Default settings template selection

---

### Feature Details
<a id="feature-details"></a>

#### Technologies in Use

##### Backend
- **Language**: TypeScript/Node.js
- **Framework**: Express.js
- **Database**: PostgreSQL
- **ORM**: Drizzle ORM
- **Authentication**: JWT with session management
- **Storage**: Cloud-based object storage
- **Validation**: Zod schemas

##### Frontend
- **Framework**: React
- **State Management**: React Query
- **UI Components**: Shadcn/UI with Tailwind CSS
- **Forms**: React Hook Form with Zod validation
- **Navigation**: Wouter
- **Data Visualization**: Chart.js, Recharts

##### Infrastructure
- **Hosting**: Cloud-based containerized deployment
- **CI/CD**: Automated testing and deployment pipeline
- **Monitoring**: Performance and error tracking
- **Scalability**: Auto-scaling configuration

---

### Historical Development Progress
<a id="historical-development-progress"></a>

This section contains historical development information preserved for reference, showing the project's progression over time.

#### 2025-03-01: Analytics Platform Technical Documentation
_Source: unified_documentation/analytics/temp-extraction-analytics-platform.md (Branch: temp)_


**Last Updated: March 18, 2025**

### Overview

The Analytics Platform within TuneMantra provides comprehensive performance tracking, revenue analysis, and audience insights across multiple streaming platforms. This document outlines the technical implementation, architecture, and current status of the analytics system.

### Implementation Status

**Overall Completion: 65% | Practical Usability: 75%**

| Component | Completion % | Practicality % | Status |
|-----------|--------------|----------------|--------|
| Dashboard Analytics | 85% | 90% | Near Complete |
| Revenue Tracking | 75% | 80% | Functional |
| Platform Performance | 80% | 85% | Near Complete |
| Geographic Distribution | 65% | 70% | Partially Implemented |
| Audience Demographics | 60% | 65% | Partially Implemented |
| Trend Analysis | 60% | 65% | Partially Implemented |
| Artist Performance | 75% | 80% | Functional |
| Release Performance | 80% | 85% | Near Complete |
| Track Performance | 75% | 80% | Functional |
| Custom Reports | 45% | 50% | In Development |
| Data Export | 70% | 75% | Functional |
| Data Import | 65% | 70% | Partially Implemented |

### Architecture

The analytics system follows a layered architecture with clear separation of concerns:

```
┌─────────────────────────────┐
│  Analytics Frontend UI      │
│  (75% Complete)             │
└───────────────┬─────────────┘
                │
┌───────────────▼─────────────┐
│  Analytics API Layer        │
│  (70% Complete)             │
└───────────────┬─────────────┘
                │
┌───────────────▼─────────────┐
│  Data Processing Layer      │
│  (65% Complete)             │
└───────────────┬─────────────┘
                │
┌───────────────▼─────────────┐
│  Data Storage Layer         │
│  (80% Complete)             │
└───────────────┬─────────────┘
                │
    ┌───────────┴───────────┐
    │                       │
┌───▼───┐   ┌───────┐   ┌───▼───┐
│Real-time│ │Historic│ │Aggregated│
│(60%)   │ │(75%)   │ │(70%)    │
└───────┘   └───────┘   └───────┘
```

#### Key Components

1. **Analytics Frontend UI**
   - React-based dashboard components
   - Chart.js and Recharts for data visualization
   - Responsive design for mobile and desktop
   - Filterable views with date range controls

2. **Analytics API Layer**
   - RESTful endpoints for data retrieval
   - Query parameter support for filtering
   - Pagination for large data sets
   - Authentication and authorization controls

3. **Data Processing Layer**
   - ETL processes for platform data
   - Aggregation algorithms for summary data
   - Statistical analysis for trend detection
   - Cache management for performance

4. **Data Storage Layer**
   - PostgreSQL database with optimized schema
   - Time-series data organization
   - JSON fields for flexible metadata
   - Partitioning for performance

### Data Collection Methods

| Method | Implementation % | Platforms Covered | Status |
|--------|-----------------|-------------------|--------|
| API Integration | 75% | 12 | Functional |
| Manual Import | 85% | 16 | Near Complete |
| Direct Database | 90% | 1 | Complete |
| CSV Import | 80% | All | Near Complete |
| Excel Import | 75% | All | Functional |
| Real-time Webhooks | 40% | 3 | In Development |

### Technical Implementation

#### Database Schema

The analytics system uses the following primary tables:

```typescript
// Daily aggregated analytics
export const dailyStats = pgTable("daily_stats", {
  id: serial("id").primaryKey(),
  date: date("date").notNull(),
  artistId: integer("artist_id").references(() => artists.id),
  releaseId: integer("release_id").references(() => releases.id),
  trackId: integer("track_id").references(() => tracks.id),
  platform: text("platform").notNull(),
  streams: integer("streams").notNull().default(0),
  revenue: numeric("revenue").notNull().default("0"),
  country: text("country"),
  source: text("source").notNull(),
  audienceData: jsonb("audience_data"),
  createdAt: timestamp("created_at").defaultNow().notNull()
});

// Raw analytics events
export const analytics = pgTable("analytics", {
  id: serial("id").primaryKey(),
  timestamp: timestamp("timestamp").defaultNow().notNull(),
  artistId: integer("artist_id").references(() => artists.id),
  releaseId: integer("release_id").references(() => releases.id),
  trackId: integer("track_id").references(() => tracks.id),
  platform: text("platform").notNull(),
  eventType: text("event_type").notNull(),
  country: text("country"),
  city: text("city"),
  deviceType: text("device_type"),
  browserType: text("browser_type"),
  ipAddress: text("ip_address"),
  referrer: text("referrer"),
  metadata: jsonb("metadata"),
  revenue: numeric("revenue").default("0"),
  createdAt: timestamp("created_at").defaultNow().notNull()
});

// Analytics access logs for audit
export const analyticsAccessLogs = pgTable("analytics_access_logs", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").references(() => users.id).notNull(),
  accessTime: timestamp("access_time").defaultNow().notNull(),
  accessType: text("access_type").notNull(),
  entityType: text("entity_type").notNull(),
  entityId: integer("entity_id"),
  queryParams: jsonb("query_params"),
  userRole: text("user_role").notNull(),
  ipAddress: text("ip_address"),
  successful: boolean("successful").default(true).notNull()
});
```

#### API Endpoints

The analytics system exposes the following key endpoints:

```typescript
// Analytics overview endpoints
app.get('/api/analytics/overview', requireAuth, async (req, res) => {
  // Returns summary analytics for the authenticated user
});

// Detailed analytics endpoints
app.get('/api/analytics/releases/:releaseId', requireAuth, async (req, res) => {
  // Returns detailed analytics for a specific release
});

app.get('/api/analytics/tracks/:trackId', requireAuth, async (req, res) => {
  // Returns detailed analytics for a specific track
});

app.get('/api/analytics/artists/:artistId', requireAuth, async (req, res) => {
  // Returns detailed analytics for a specific artist
});

// Specialized analytics endpoints
app.get('/api/analytics/geographic', requireAuth, async (req, res) => {
  // Returns geographic distribution of plays
});

app.get('/api/analytics/platforms', requireAuth, async (req, res) => {
  // Returns platform distribution of plays
});

app.get('/api/analytics/trends', requireAuth, async (req, res) => {
  // Returns trend analysis for the authenticated user's content
});

// Export endpoints
app.get('/api/analytics/export/:format', requireAuth, async (req, res) => {
  // Exports analytics data in the specified format
});
```

#### Data Processing Services

The analytics system includes the following key services:

1. **Analytics Service** (`analytics-service.ts`)
   - Core service for retrieving and analyzing data
   - Query building and execution
   - Data formatting and transformation
   - Cache management

2. **Import Service** (`analytics-import-service.ts`)
   - Handling imports from various platforms
   - Data validation and normalization
   - Duplicate detection and resolution
   - Error handling and logging

3. **Advanced Analytics Service** (`advanced-analytics-service.ts`)
   - Statistical analysis and trend detection
   - Predictive modeling
   - Audience segmentation
   - Comparative analysis

4. **Export Service** (`analytics-export-service.ts`)
   - Format-specific export generation
   - Scheduling and delivery
   - Custom report configuration
   - Template management

### Dashboard Features

| Feature | Implementation % | Practicality % | Status |
|---------|-----------------|----------------|--------|
| Overview Metrics | 90% | 95% | Complete |
| Revenue Charts | 85% | 90% | Near Complete |
| Platform Breakdown | 85% | 90% | Near Complete |
| Trend Charts | 80% | 85% | Near Complete |
| Geographic Map | 65% | 70% | Partially Implemented |
| User Segments | 60% | 65% | Partially Implemented |
| Custom Date Ranges | 75% | 80% | Functional |
| Data Export | 80% | 85% | Near Complete |
| Comparison Tools | 55% | 60% | Partially Implemented |
| Alert Configuration | 40% | 45% | In Development |

#### Implementation Details

##### Dashboard Components

The dashboard is built with React components that make API calls to the analytics endpoints:

```tsx
export function AnalyticsDashboard() {
  const { data: overview, isLoading } = useQuery({
    queryKey: ['/api/analytics/overview'],
    // API call to get overview data
  });

  // Component rendering with charts and metrics
}

export function RevenueDashboard() {
  const { data: revenue, isLoading } = useQuery({
    queryKey: ['/api/analytics/revenue'],
    // API call to get revenue data
  });

  // Component rendering with revenue charts
}

export function GeographicDashboard() {
  const { data: geoData, isLoading } = useQuery({
    queryKey: ['/api/analytics/geographic'],
    // API call to get geographic data
  });

  // Component rendering with map visualization
}
```

##### Data Visualization

The system uses Chart.js and Recharts for data visualization:

```tsx
// Line chart for trends
export function TrendChart({ data }) {
  return (
    <ResponsiveContainer width="100%" height={300}>
      <LineChart data={data}>
        <XAxis dataKey="date" />
        <YAxis />
        <Tooltip />
        <Line type="monotone" dataKey="streams" stroke="#8884d8" />
      </LineChart>
    </ResponsiveContainer>
  );
}

// Bar chart for platform comparison
export function PlatformChart({ data }) {
  return (
    <ResponsiveContainer width="100%" height={300}>
      <BarChart data={data}>
        <XAxis dataKey="platform" />
        <YAxis />
        <Tooltip />
        <Bar dataKey="streams" fill="#8884d8" />
      </BarChart>
    </ResponsiveContainer>
  );
}
```

### Key Performance Indicators (KPIs)

| KPI | Data Sources | Implementation % | Visualization % |
|-----|--------------|-----------------|-----------------|
| Total Streams | 5 | 85% | 90% |
| Revenue | 5 | 80% | 85% |
| Platform Distribution | 12 | 85% | 90% |
| Geographic Distribution | 10 | 65% | 70% |
| Growth Rate | 5 | 75% | 80% |
| Audience Demographics | 5 | 60% | 65% |
| Conversion Rate | 3 | 50% | 55% |
| Engagement Rate | 3 | 45% | 50% |
| Retention Rate | 2 | 40% | 45% |
| Comparative Performance | 4 | 55% | 60% |

### Implementation Challenges

1. **Data Consistency**
   - Challenge: Inconsistent data formats across platforms
   - Solution: Standardized ETL processes with platform-specific adapters
   - Status: 75% Complete

2. **Real-time Processing**
   - Challenge: Handling high-volume real-time data streams
   - Solution: Optimized batch processing with incremental updates
   - Status: 60% Complete

3. **Data Accuracy**
   - Challenge: Reconciling discrepancies between platform reports
   - Solution: Audit system with reconciliation workflows
   - Status: 65% Complete

4. **Performance at Scale**
   - Challenge: Maintaining dashboard performance with large datasets
   - Solution: Data aggregation, caching, and optimized queries
   - Status: 70% Complete

5. **User-friendly Visualization**
   - Challenge: Making complex data accessible to non-technical users
   - Solution: Intuitive dashboards with contextual insights
   - Status: 75% Complete

### Security and Privacy

The analytics system implements several security measures:

1. **Access Control**
   - Role-based access restrictions for analytics data
   - User-specific data filtering
   - Label-level isolation of analytics

2. **Audit Logging**
   - Comprehensive logging of all analytics access
   - Purpose recording for compliance
   - Suspicious activity detection

3. **Data Anonymization**
   - Audience data anonymization
   - IP address obfuscation
   - Aggregation thresholds to prevent individual identification

4. **Compliance Features**
   - GDPR compliance tools
   - Data retention policies
   - Right to be forgotten implementation

### Future Development Roadmap

| Feature | Priority | Status | Timeline |
|---------|----------|--------|----------|
| Advanced Predictive Analytics | High | Planned | Q2 2025 |
| AI-powered Insights | High | In Design | Q2-Q3 2025 |
| Custom Report Builder | Medium | In Development | Q2 2025 |
| Advanced Audience Segmentation | Medium | Planned | Q3 2025 |
| Real-time Dashboard Updates | Medium | Planned | Q3 2025 |
| Mobile Analytics App | Low | Planned | Q4 2025 |
| API Analytics | Low | Planned | Q4 2025 |

---

**Document Owner**: Analytics Team  
**Created**: March 8, 2025  
**Last Updated**: March 18, 2025  
**Status**: In Progress  
**Related Documents**: 
- [Analytics System Overview](../../analytics-system.md)
- [API Reference - Analytics Endpoints](../../api/api-reference.md)
- [User Guide - Analytics Dashboard](../../user-guides/analytics-dashboard.md)

---

#### 2025-03-01: TuneMantra API Reference
_Source: unified_documentation/api-reference/main-api-reference-legacy.md (Branch: main)_


### Introduction

This document provides comprehensive documentation for the TuneMantra API. It covers all available endpoints, request/response formats, authentication methods, and usage examples.

### Base URL

All API endpoints are relative to the base URL:

```
https://your-tunemantra-instance.com/api
```

For local development:

```
http://localhost:5000/api
```

### Authentication

#### Authentication Methods

The TuneMantra API supports the following authentication methods:

1. **JWT Authentication**
   - Used for user sessions
   - Token included in `Authorization` header
   - Format: `Bearer <token>`

2. **API Key Authentication**
   - Used for programmatic access
   - Key included in `X-API-Key` header

#### Getting an Authentication Token

1. **User Login**

```http
POST /auth/login
Content-Type: application/json

{
  "username": "user@example.com",
  "password": "password123"
}
```

Response:

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "user@example.com",
    "role": "artist"
    // other user fields
  }
}
```

2. **API Key Generation**

```http
POST /api-keys
Content-Type: application/json
Authorization: Bearer <jwt-token>

{
  "name": "My API Key",
  "scopes": ["read:releases", "write:releases"]
}
```

Response:

```json
{
  "id": 1,
  "name": "My API Key",
  "key": "tm_apk_1234567890abcdef",
  "scopes": ["read:releases", "write:releases"],
  "createdAt": "2025-03-19T12:00:00Z"
}
```

### Error Handling

All API errors follow a consistent format:

```json
{
  "message": "Human-readable error message",
  "code": "ERROR_CODE",
  "details": { /* Optional additional error details */ }
}
```

Common error status codes:

- `400`: Bad Request - Invalid input
- `401`: Unauthorized - Authentication required
- `403`: Forbidden - Insufficient permissions
- `404`: Not Found - Resource doesn't exist
- `422`: Unprocessable Entity - Validation error
- `429`: Too Many Requests - Rate limit exceeded
- `500`: Internal Server Error - Server failure

### API Endpoints

#### User Management

##### Get Current User

```http
GET /user
Authorization: Bearer <token>
```

Response:

```json
{
  "id": 1,
  "username": "user@example.com",
  "fullName": "John Doe",
  "email": "user@example.com",
  "phoneNumber": "+1234567890",
  "entityName": "Artist Name",
  "avatarUrl": "/uploads/avatars/profile.jpg",
  "role": "artist",
  "status": "active",
  "createdAt": "2025-03-19T12:00:00Z",
  "permissions": {
    "canCreateReleases": true,
    "canManageArtists": true,
    "canViewAnalytics": true
    // additional permissions
  }
}
```

##### Update User Profile

```http
PATCH /user/profile
Authorization: Bearer <token>
Content-Type: application/json

{
  "fullName": "John Doe Updated",
  "phoneNumber": "+1987654321",
  "entityName": "New Artist Name"
}
```

Response:

```json
{
  "id": 1,
  "username": "user@example.com",
  "fullName": "John Doe Updated",
  "phoneNumber": "+1987654321",
  "entityName": "New Artist Name",
  // other user fields
}
```

##### Upload Avatar

```http
POST /user/avatar
Authorization: Bearer <token>
Content-Type: multipart/form-data

avatar: [file upload]
```

Response:

```json
{
  "avatarUrl": "/uploads/avatars/profile-123456.jpg"
}
```

#### Release Management

##### Get Releases

```http
GET /releases
Authorization: Bearer <token>
```

Response:

```json
[
  {
    "id": 1,
    "title": "Album Title",
    "type": "album",
    "artistName": "Artist Name",
    "releaseDate": "2025-04-01",
    "coverArtUrl": "/uploads/covers/album.jpg",
    "status": "completed",
    "tracks": [
      // track information
    ],
    "metadata": {
      // additional metadata
    },
    "createdAt": "2025-03-19T12:00:00Z",
    "updatedAt": "2025-03-19T12:30:00Z"
  }
  // additional releases
]
```

Query Parameters:
- `status`: Filter by status (e.g., "draft", "completed", "distributed")
- `type`: Filter by release type (e.g., "album", "single", "ep")
- `page`: Page number for pagination
- `limit`: Items per page

##### Get Release by ID

```http
GET /releases/:id
Authorization: Bearer <token>
```

Response:

```json
{
  "id": 1,
  "title": "Album Title",
  "type": "album",
  "artistName": "Artist Name",
  "releaseDate": "2025-04-01",
  "coverArtUrl": "/uploads/covers/album.jpg",
  "status": "completed",
  "tracks": [
    {
      "id": 1,
      "title": "Track 1",
      "duration": 180,
      "isrc": "ABC123456789",
      "position": 1,
      "audioUrl": "/uploads/audio/track1.mp3"
      // additional track information
    }
    // additional tracks
  ],
  "metadata": {
    "genres": ["Pop", "Rock"],
    "moods": ["Energetic", "Upbeat"],
    "language": "english",
    "explicit": false,
    "copyright": "© 2025 Artist Name",
    "upc": "1234567890123"
    // additional metadata
  },
  "createdAt": "2025-03-19T12:00:00Z",
  "updatedAt": "2025-03-19T12:30:00Z"
}
```

##### Create Release

```http
POST /releases
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "New Album",
  "type": "album",
  "artistName": "Artist Name",
  "releaseDate": "2025-04-01",
  "metadata": {
    "genres": ["Pop", "Electronic"],
    "language": "english",
    "explicit": false,
    "copyright": "© 2025 Artist Name"
  }
}
```

Response:

```json
{
  "id": 2,
  "title": "New Album",
  "type": "album",
  "artistName": "Artist Name",
  "releaseDate": "2025-04-01",
  "status": "draft",
  "metadata": {
    "genres": ["Pop", "Electronic"],
    "language": "english",
    "explicit": false,
    "copyright": "© 2025 Artist Name"
  },
  "createdAt": "2025-03-19T13:00:00Z",
  "updatedAt": "2025-03-19T13:00:00Z"
}
```

##### Update Release

```http
PATCH /releases/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Updated Album Title",
  "metadata": {
    "genres": ["Pop", "Electronic", "Dance"],
    "moods": ["Energetic", "Upbeat"]
  }
}
```

Response:

```json
{
  "id": 2,
  "title": "Updated Album Title",
  "type": "album",
  "artistName": "Artist Name",
  "releaseDate": "2025-04-01",
  "status": "draft",
  "metadata": {
    "genres": ["Pop", "Electronic", "Dance"],
    "moods": ["Energetic", "Upbeat"],
    "language": "english",
    "explicit": false,
    "copyright": "© 2025 Artist Name"
  },
  "createdAt": "2025-03-19T13:00:00Z",
  "updatedAt": "2025-03-19T13:15:00Z"
}
```

##### Delete Release

```http
DELETE /releases/:id
Authorization: Bearer <token>
```

Response:

```
204 No Content
```

#### Track Management

##### Get Tracks for Release

```http
GET /releases/:releaseId/tracks
Authorization: Bearer <token>
```

Response:

```json
[
  {
    "id": 1,
    "title": "Track 1",
    "duration": 180,
    "isrc": "ABC123456789",
    "position": 1,
    "audioUrl": "/uploads/audio/track1.mp3",
    "releaseId": 1,
    "createdAt": "2025-03-19T12:00:00Z",
    "updatedAt": "2025-03-19T12:00:00Z"
  }
  // additional tracks
]
```

##### Get Track by ID

```http
GET /tracks/:id
Authorization: Bearer <token>
```

Response:

```json
{
  "id": 1,
  "title": "Track 1",
  "duration": 180,
  "isrc": "ABC123456789",
  "position": 1,
  "audioUrl": "/uploads/audio/track1.mp3",
  "releaseId": 1,
  "metadata": {
    "composers": ["Composer Name"],
    "lyricists": ["Lyricist Name"],
    "producers": ["Producer Name"],
    "explicit": false,
    "bpm": 120,
    "key": "C Major"
    // additional metadata
  },
  "createdAt": "2025-03-19T12:00:00Z",
  "updatedAt": "2025-03-19T12:00:00Z"
}
```

##### Create Track

```http
POST /tracks
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "New Track",
  "duration": 210,
  "position": 1,
  "releaseId": 2,
  "metadata": {
    "composers": ["Composer Name"],
    "lyricists": ["Lyricist Name"],
    "producers": ["Producer Name"],
    "explicit": false
  }
}
```

Response:

```json
{
  "id": 2,
  "title": "New Track",
  "duration": 210,
  "position": 1,
  "releaseId": 2,
  "metadata": {
    "composers": ["Composer Name"],
    "lyricists": ["Lyricist Name"],
    "producers": ["Producer Name"],
    "explicit": false
  },
  "createdAt": "2025-03-19T13:30:00Z",
  "updatedAt": "2025-03-19T13:30:00Z"
}
```

##### Update Track

```http
PATCH /tracks/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Updated Track Title",
  "metadata": {
    "bpm": 124,
    "key": "D Minor"
  }
}
```

Response:

```json
{
  "id": 2,
  "title": "Updated Track Title",
  "duration": 210,
  "position": 1,
  "releaseId": 2,
  "metadata": {
    "composers": ["Composer Name"],
    "lyricists": ["Lyricist Name"],
    "producers": ["Producer Name"],
    "explicit": false,
    "bpm": 124,
    "key": "D Minor"
  },
  "createdAt": "2025-03-19T13:30:00Z",
  "updatedAt": "2025-03-19T13:45:00Z"
}
```

##### Upload Track Audio

```http
POST /tracks/:id/audio
Authorization: Bearer <token>
Content-Type: multipart/form-data

audio: [file upload]
```

Response:

```json
{
  "id": 2,
  "audioUrl": "/uploads/audio/track2-123456.mp3",
  "updatedAt": "2025-03-19T14:00:00Z"
}
```

##### Delete Track

```http
DELETE /tracks/:id
Authorization: Bearer <token>
```

Response:

```
204 No Content
```

#### Distribution Management

##### Get Distribution Platforms

```http
GET /distribution-platforms
Authorization: Bearer <token>
```

Response:

```json
[
  {
    "id": 1,
    "name": "Spotify",
    "logoUrl": "/platform-logos/spotify.png",
    "deliveryMethod": "api",
    "supportedFormats": ["mp3", "wav"],
    "active": true
  },
  {
    "id": 2,
    "name": "Apple Music",
    "logoUrl": "/platform-logos/apple-music.png",
    "deliveryMethod": "api",
    "supportedFormats": ["mp3", "wav", "aac"],
    "active": true
  }
  // additional platforms
]
```

##### Distribute Release to Platform

```http
POST /releases/:releaseId/distribute
Authorization: Bearer <token>
Content-Type: application/json

{
  "platformId": 1
}
```

Response:

```json
{
  "id": 1,
  "releaseId": 1,
  "platformId": 1,
  "status": "pending",
  "distributedAt": "2025-03-19T14:30:00Z",
  "platformReleaseId": null,
  "platformUrl": null,
  "createdAt": "2025-03-19T14:30:00Z",
  "updatedAt": "2025-03-19T14:30:00Z"
}
```

##### Schedule Release Distribution

```http
POST /scheduled-distributions
Authorization: Bearer <token>
Content-Type: application/json

{
  "releaseId": 2,
  "platformId": 1,
  "scheduledDate": "2025-04-01T00:00:00Z"
}
```

Response:

```json
{
  "id": 1,
  "releaseId": 2,
  "platformId": 1,
  "scheduledDate": "2025-04-01T00:00:00Z",
  "status": "scheduled",
  "createdAt": "2025-03-19T14:45:00Z",
  "updatedAt": "2025-03-19T14:45:00Z"
}
```

##### Get Distribution Status

```http
GET /releases/:releaseId/distribution
Authorization: Bearer <token>
```

Response:

```json
[
  {
    "id": 1,
    "releaseId": 1,
    "platformId": 1,
    "platformName": "Spotify",
    "status": "completed",
    "distributedAt": "2025-03-19T14:30:00Z",
    "completedAt": "2025-03-19T15:00:00Z",
    "platformReleaseId": "spotify_123456",
    "platformUrl": "https://open.spotify.com/album/123456",
    "errorMessage": null,
    "createdAt": "2025-03-19T14:30:00Z",
    "updatedAt": "2025-03-19T15:00:00Z"
  }
  // additional distribution records
]
```

#### Analytics

##### Get Release Analytics

```http
GET /analytics/releases/:releaseId
Authorization: Bearer <token>
```

Query Parameters:
- `startDate`: Start date for analytics (ISO format)
- `endDate`: End date for analytics (ISO format)
- `platforms`: Comma-separated list of platform IDs

Response:

```json
{
  "summary": {
    "totalStreams": 15000,
    "totalRevenue": 150.75,
    "topPlatforms": [
      {
        "platform": "Spotify",
        "streams": 10000,
        "revenue": 100.50
      },
      {
        "platform": "Apple Music",
        "streams": 5000,
        "revenue": 50.25
      }
    ],
    "topTracks": [
      {
        "trackId": 1,
        "title": "Track 1",
        "streams": 8000,
        "revenue": 80.40
      },
      {
        "trackId": 2,
        "title": "Track 2",
        "streams": 7000,
        "revenue": 70.35
      }
    ]
  },
  "daily": [
    {
      "date": "2025-03-01",
      "streams": 500,
      "revenue": 5.02
    }
    // daily data for the requested period
  ],
  "platforms": [
    {
      "platform": "Spotify",
      "daily": [
        {
          "date": "2025-03-01",
          "streams": 350,
          "revenue": 3.52
        }
        // daily data for Spotify
      ]
    },
    {
      "platform": "Apple Music",
      "daily": [
        {
          "date": "2025-03-01",
          "streams": 150,
          "revenue": 1.50
        }
        // daily data for Apple Music
      ]
    }
  ]
}
```

##### Get Track Analytics

```http
GET /analytics/tracks/:trackId
Authorization: Bearer <token>
```

Query Parameters:
- `startDate`: Start date for analytics (ISO format)
- `endDate`: End date for analytics (ISO format)
- `platforms`: Comma-separated list of platform IDs

Response:

```json
{
  "summary": {
    "totalStreams": 8000,
    "totalRevenue": 80.40,
    "platformBreakdown": [
      {
        "platform": "Spotify",
        "streams": 6000,
        "revenue": 60.30
      },
      {
        "platform": "Apple Music",
        "streams": 2000,
        "revenue": 20.10
      }
    ],
    "geographicBreakdown": [
      {
        "country": "United States",
        "streams": 4000,
        "revenue": 40.20
      },
      {
        "country": "United Kingdom",
        "streams": 2000,
        "revenue": 20.10
      }
      // additional countries
    ]
  },
  "daily": [
    {
      "date": "2025-03-01",
      "streams": 300,
      "revenue": 3.01
    }
    // daily data for the requested period
  ]
}
```

#### Royalty Management

##### Get Royalty Splits

```http
GET /royalty-splits/release/:releaseId
Authorization: Bearer <token>
```

Response:

```json
[
  {
    "id": 1,
    "releaseId": 1,
    "trackId": null,
    "recipientName": "John Doe",
    "recipientRole": "Primary Artist",
    "percentage": 70,
    "paymentMethod": {
      "id": 1,
      "type": "bank_account",
      "accountHolder": "John Doe",
      "accountIdentifier": "XXXX-XXXX-XXXX-1234"
    },
    "createdAt": "2025-03-19T16:00:00Z",
    "updatedAt": "2025-03-19T16:00:00Z"
  },
  {
    "id": 2,
    "releaseId": 1,
    "trackId": null,
    "recipientName": "Jane Smith",
    "recipientRole": "Producer",
    "percentage": 30,
    "paymentMethod": {
      "id": 2,
      "type": "paypal",
      "accountHolder": "Jane Smith",
      "accountIdentifier": "jane.smith@example.com"
    },
    "createdAt": "2025-03-19T16:00:00Z",
    "updatedAt": "2025-03-19T16:00:00Z"
  }
]
```

##### Create Royalty Split

```http
POST /royalty-splits
Authorization: Bearer <token>
Content-Type: application/json

{
  "releaseId": 1,
  "trackId": null,
  "recipientName": "Producer Name",
  "recipientRole": "Producer",
  "percentage": 15,
  "paymentMethodId": 3
}
```

Response:

```json
{
  "id": 3,
  "releaseId": 1,
  "trackId": null,
  "recipientName": "Producer Name",
  "recipientRole": "Producer",
  "percentage": 15,
  "paymentMethod": {
    "id": 3,
    "type": "bank_account",
    "accountHolder": "Producer Name",
    "accountIdentifier": "XXXX-XXXX-XXXX-5678"
  },
  "createdAt": "2025-03-19T16:30:00Z",
  "updatedAt": "2025-03-19T16:30:00Z"
}
```

#### Support Tickets

##### Get All Tickets

```http
GET /support/tickets
Authorization: Bearer <token>
```

Response:

```json
[
  {
    "id": 1,
    "subject": "Distribution Issue",
    "message": "Having trouble with my distribution to Spotify",
    "status": "open",
    "priority": "medium",
    "category": "distribution",
    "updatedAt": "2025-03-19T17:00:00Z",
    "createdAt": "2025-03-19T17:00:00Z"
  }
  // additional tickets
]
```

##### Get Ticket Details

```http
GET /support/tickets/:id
Authorization: Bearer <token>
```

Response:

```json
{
  "ticket": {
    "id": 1,
    "subject": "Distribution Issue",
    "message": "Having trouble with my distribution to Spotify",
    "status": "open",
    "priority": "medium",
    "category": "distribution",
    "updatedAt": "2025-03-19T17:00:00Z",
    "createdAt": "2025-03-19T17:00:00Z"
  },
  "messages": [
    {
      "id": 1,
      "content": "Having trouble with my distribution to Spotify",
      "senderType": "user",
      "senderId": 1,
      "createdAt": "2025-03-19T17:00:00Z"
    }
    // additional messages
  ]
}
```

##### Create Support Ticket

```http
POST /support/tickets
Authorization: Bearer <token>
Content-Type: application/json

{
  "subject": "Payment Question",
  "message": "How do I update my payment details?",
  "priority": "low",
  "category": "billing"
}
```

Response:

```json
{
  "id": 2,
  "subject": "Payment Question",
  "message": "How do I update my payment details?",
  "status": "open",
  "priority": "low",
  "category": "billing",
  "updatedAt": "2025-03-19T17:15:00Z",
  "createdAt": "2025-03-19T17:15:00Z"
}
```

##### Add Ticket Message

```http
POST /support/tickets/:id/messages
Authorization: Bearer <token>
Content-Type: application/json

{
  "content": "Any update on this issue?"
}
```

Response:

```json
{
  "id": 2,
  "content": "Any update on this issue?",
  "senderType": "user",
  "senderId": 1,
  "createdAt": "2025-03-19T17:30:00Z"
}
```

### Webhooks

TuneMantra supports webhooks for real-time notifications of events.

#### Available Events

- `release.created`: When a new release is created
- `release.updated`: When a release is updated
- `release.distributed`: When a release is distributed to a platform
- `track.created`: When a new track is created
- `track.updated`: When a track is updated
- `analytics.updated`: When analytics data is updated

#### Webhook Payload Format

```json
{
  "event": "release.distributed",
  "timestamp": "2025-03-19T18:00:00Z",
  "data": {
    "releaseId": 1,
    "platformId": 1,
    "platformName": "Spotify",
    "status": "completed",
    "platformUrl": "https://open.spotify.com/album/123456"
  }
}
```

#### Setting Up Webhooks

Webhooks can be configured in the application settings or via the API:

```http
POST /webhooks
Authorization: Bearer <token>
Content-Type: application/json

{
  "url": "https://your-webhook-endpoint.com/webhook",
  "events": ["release.distributed", "analytics.updated"],
  "secret": "your_webhook_secret"
}
```

Response:

```json
{
  "id": 1,
  "url": "https://your-webhook-endpoint.com/webhook",
  "events": ["release.distributed", "analytics.updated"],
  "active": true,
  "createdAt": "2025-03-19T18:15:00Z"
}
```

### Rate Limiting

The API implements rate limiting to ensure fair usage:

- **Standard Users**: 100 requests per minute
- **Premium Users**: 300 requests per minute
- **API Clients**: 1000 requests per minute

Rate limit headers are included in API responses:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1616176800
```

### API Versioning

API versioning is managed through the URL path:

```
https://your-tunemantra-instance.com/api/v1/...
```

Current API versions:
- `v1`: Current stable version

### SDKs and Client Libraries

Official SDKs and client libraries for the TuneMantra API:

- [JavaScript/TypeScript SDK](https://github.com/tunemantra/tunemantra-js)
- [Python SDK](https://github.com/tunemantra/tunemantra-python)
- [PHP SDK](https://github.com/tunemantra/tunemantra-php)

### Appendix

#### Status Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | Request succeeded |
| 201 | Created | Resource created |
| 204 | No Content | Request succeeded with no content to return |
| 400 | Bad Request | Invalid request |
| 401 | Unauthorized | Authentication required |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource not found |
| 422 | Unprocessable Entity | Validation error |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Server error |

---

*© 2025 TuneMantra. All rights reserved.*

---

#### 2025-03-01: TuneMantra API Reference
_Source: unified_documentation/api-reference/main-api-reference.md (Branch: main)_


**Last Updated:** March 22, 2025

### Overview

The TuneMantra API provides programmatic access to the platform's functionality, allowing developers to integrate music distribution and royalty management capabilities into custom applications and workflows.

### Authentication

All API requests require authentication using JSON Web Tokens (JWT).

#### Getting a Token

```
POST /api/auth/login
```

Request body:
```json
{
  "username": "your-username",
  "password": "your-password"
}
```

Response:
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "your-username",
    "email": "your-email@example.com",
    "role": "label"
  }
}
```

#### Using the Token

Include the token in the Authorization header of each request:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### API Endpoints

#### User Management

##### Get Current User

```
GET /api/users/me
```

Response:
```json
{
  "id": 1,
  "username": "your-username",
  "email": "your-email@example.com",
  "role": "label",
  "createdAt": "2025-01-15T12:00:00.000Z",
  "updatedAt": "2025-03-01T14:30:00.000Z"
}
```

##### Update User Profile

```
PATCH /api/users/me
```

Request body:
```json
{
  "email": "new-email@example.com",
  "displayName": "New Display Name",
  "bio": "Updated artist biography"
}
```

#### Catalog Management

##### Get Releases

```
GET /api/releases
```

Query parameters:
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20)
- `status`: Filter by status (draft, pending, published)

Response:
```json
{
  "total": 45,
  "page": 1,
  "limit": 20,
  "data": [
    {
      "id": 123,
      "title": "Album Title",
      "artist": "Artist Name",
      "type": "album",
      "status": "published",
      "releaseDate": "2025-04-01T00:00:00.000Z",
      "createdAt": "2025-03-01T12:00:00.000Z",
      "updatedAt": "2025-03-10T15:30:00.000Z"
    },
    // More releases...
  ]
}
```

##### Get Release by ID

```
GET /api/releases/:id
```

Response:
```json
{
  "id": 123,
  "title": "Album Title",
  "artist": "Artist Name",
  "type": "album",
  "status": "published",
  "releaseDate": "2025-04-01T00:00:00.000Z",
  "artwork": "https://example.com/artwork.jpg",
  "genres": ["Pop", "Electronic"],
  "tracks": [
    {
      "id": 456,
      "title": "Track Title",
      "duration": 180,
      "isrc": "USXXX1234567",
      "position": 1
    },
    // More tracks...
  ],
  "createdAt": "2025-03-01T12:00:00.000Z",
  "updatedAt": "2025-03-10T15:30:00.000Z"
}
```

##### Create Release

```
POST /api/releases
```

Request body:
```json
{
  "title": "New Album",
  "type": "album",
  "artist": "Artist Name",
  "releaseDate": "2025-05-15T00:00:00.000Z",
  "genres": ["Rock", "Alternative"],
  "tracks": [
    {
      "title": "Track 1",
      "duration": 180,
      "isrc": "USXXX1234567",
      "position": 1
    }
  ]
}
```

##### Update Release

```
PATCH /api/releases/:id
```

Request body:
```json
{
  "title": "Updated Album Title",
  "genres": ["Rock", "Indie"]
}
```

##### Delete Release

```
DELETE /api/releases/:id
```

#### Distribution Management

##### Get Distribution Records

```
GET /api/distribution
```

Query parameters:
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20)
- `status`: Filter by status

Response:
```json
{
  "total": 30,
  "page": 1,
  "limit": 20,
  "data": [
    {
      "id": 789,
      "releaseId": 123,
      "platformId": 1,
      "status": "distributed",
      "distributionDate": "2025-03-15T09:30:00.000Z",
      "platformReleaseId": "platform-specific-id",
      "createdAt": "2025-03-01T12:00:00.000Z",
      "updatedAt": "2025-03-15T09:30:00.000Z"
    },
    // More distribution records...
  ]
}
```

##### Create Distribution

```
POST /api/distribution
```

Request body:
```json
{
  "releaseId": 123,
  "platforms": [1, 2, 3],
  "scheduledDate": "2025-04-01T00:00:00.000Z"
}
```

##### Update Distribution Status

```
PATCH /api/distribution/:id/status
```

Request body:
```json
{
  "status": "canceled",
  "reason": "Metadata issues"
}
```

#### Royalty Management

##### Get Royalty Calculations

```
GET /api/royalties
```

Query parameters:
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20)
- `timeframe`: Time period (day, week, month, quarter, year, or custom date range)
- `releaseId`: Filter by release ID
- `trackId`: Filter by track ID

Response:
```json
{
  "total": 150,
  "page": 1,
  "limit": 20,
  "data": [
    {
      "id": 1001,
      "trackId": 456,
      "platform": "spotify",
      "streams": 15000,
      "revenue": 60.00,
      "currency": "USD",
      "period": "2025-03",
      "createdAt": "2025-04-02T12:00:00.000Z"
    },
    // More royalty records...
  ]
}
```

##### Process Batch Royalty Calculations

```
POST /api/royalties/process
```

Request body:
```json
{
  "releaseId": 123,
  "timeframe": {
    "startDate": "2025-03-01",
    "endDate": "2025-03-31"
  },
  "forceRecalculation": false
}
```

#### Analytics

##### Get Performance Analytics

```
GET /api/analytics/performance
```

Query parameters:
- `timeframe`: Time period (day, week, month, quarter, year, or custom date range)
- `releaseId`: Filter by release ID
- `trackId`: Filter by track ID

Response:
```json
{
  "streams": {
    "total": 250000,
    "byPlatform": {
      "spotify": 120000,
      "apple": 85000,
      "amazon": 45000
    },
    "trend": [
      {"date": "2025-03-01", "count": 8500},
      {"date": "2025-03-02", "count": 8200},
      // More data points...
    ]
  },
  "revenue": {
    "total": 1250.00,
    "currency": "USD",
    "byPlatform": {
      "spotify": 600.00,
      "apple": 425.00,
      "amazon": 225.00
    }
  },
  "audience": {
    "topCountries": [
      {"country": "US", "percentage": 45.2},
      {"country": "UK", "percentage": 15.8},
      {"country": "DE", "percentage": 8.6},
      // More countries...
    ],
    "demographics": {
      "age": {
        "18-24": 32.5,
        "25-34": 41.2,
        "35-44": 15.8,
        "45+": 10.5
      },
      "gender": {
        "male": 58.3,
        "female": 40.2,
        "other": 1.5
      }
    }
  }
}
```

### Error Handling

The API uses standard HTTP status codes to indicate the success or failure of requests.

Common status codes:
- `200 OK`: Request succeeded
- `201 Created`: Resource was successfully created
- `400 Bad Request`: Invalid request parameters
- `401 Unauthorized`: Missing or invalid authentication
- `403 Forbidden`: Authenticated user lacks permission
- `404 Not Found`: Resource not found
- `409 Conflict`: Request conflicts with current state
- `422 Unprocessable Entity`: Validation errors
- `500 Internal Server Error`: Server-side error

Error response format:
```json
{
  "error": true,
  "code": "VALIDATION_ERROR",
  "message": "Invalid request parameters",
  "details": [
    {
      "field": "title",
      "message": "Title is required"
    }
  ]
}
```

### Rate Limiting

API requests are rate-limited to prevent abuse. The current limits are:

- 60 requests per minute for authenticated users
- 20 requests per minute for unauthenticated users

Rate limit information is included in the response headers:
- `X-RateLimit-Limit`: Maximum requests per window
- `X-RateLimit-Remaining`: Remaining requests in current window
- `X-RateLimit-Reset`: Time (in seconds) until the rate limit resets

### Versioning

The API uses URL versioning. The current version is v1, accessible at:
```
/api/v1/resource
```

### Support

For API support, contact the developer support team or refer to the detailed [API Documentation](https://docs.tunemantra.com/api).

---

#### 2025-03-01: TuneMantra API Reference
_Source: unified_documentation/api-reference/temp-3march-api-reference.md (Branch: temp)_


### Introduction

This API reference provides comprehensive documentation for the TuneMantra API, enabling developers to integrate with and extend the platform's capabilities. The TuneMantra API follows RESTful principles and uses standard HTTP methods for resource manipulation.

### API Overview

#### Base URL

All API requests should be made to the following base URL:

```
https://api.tunemantra.com/api
```

For development environments:

```
http://localhost:5000/api
```

#### Authentication

TuneMantra API uses JWT (JSON Web Token) authentication. To authenticate requests, include the JWT token in the Authorization header:

```
Authorization: Bearer <jwt_token>
```

##### Obtaining Authentication Tokens

To obtain a JWT token, make a POST request to the `/auth/login` endpoint with valid credentials.

#### Response Format

All API responses are returned in JSON format with the following structure:

**Success Response:**

```json
{
  "data": { ... },  // Response data
  "meta": { ... }   // Metadata (pagination, etc.)
}
```

**Error Response:**

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": { ... }  // Optional additional error details
  }
}
```

#### HTTP Status Codes

The API uses standard HTTP status codes to indicate the success or failure of requests:

| Status Code | Description |
|-------------|-------------|
| 200 | OK - The request was successful |
| 201 | Created - A new resource was successfully created |
| 400 | Bad Request - The request was invalid or cannot be served |
| 401 | Unauthorized - Authentication is required or failed |
| 403 | Forbidden - The authenticated user doesn't have permission |
| 404 | Not Found - The requested resource doesn't exist |
| 409 | Conflict - The request conflicts with the current state |
| 422 | Unprocessable Entity - Validation errors |
| 429 | Too Many Requests - Rate limit exceeded |
| 500 | Internal Server Error - Server encountered an error |

#### Pagination

For endpoints that return collections of resources, the API supports pagination using the following query parameters:

- `page`: Page number (starting from 1)
- `limit`: Number of items per page

Example:

```
GET /api/tracks?page=2&limit=10
```

Response includes pagination metadata:

```json
{
  "data": [ ... ],
  "meta": {
    "pagination": {
      "total": 135,
      "page": 2,
      "limit": 10,
      "totalPages": 14
    }
  }
}
```

#### Filtering and Sorting

Many endpoints support filtering and sorting using query parameters:

- Filtering: `field=value` or `field[operator]=value`
- Sorting: `sort=field` (ascending) or `sort=-field` (descending)

Example:

```
GET /api/releases?type=album&sort=-releaseDate
```

#### Rate Limiting

The API implements rate limiting to ensure fair usage. Rate limit information is included in the response headers:

- `X-RateLimit-Limit`: Maximum number of requests allowed in a time window
- `X-RateLimit-Remaining`: Number of requests remaining in the current window
- `X-RateLimit-Reset`: Time (in seconds) until the rate limit resets

When a rate limit is exceeded, the API returns a 429 Too Many Requests response.

### API Endpoints

#### Authentication

##### Login

Authenticates a user and returns a JWT token.

```
POST /auth/login
```

**Request Body:**

```json
{
  "username": "user@example.com",
  "password": "password123"
}
```

**Response:**

```json
{
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "username": "user@example.com",
      "fullName": "John Doe",
      "role": "artist"
    }
  }
}
```

##### Current User

Returns information about the currently authenticated user.

```
GET /auth/user
```

**Response:**

```json
{
  "data": {
    "id": 1,
    "username": "user@example.com",
    "email": "user@example.com",
    "fullName": "John Doe",
    "phoneNumber": "+1234567890",
    "entityName": "John Doe Music",
    "avatarUrl": "https://example.com/avatar.jpg",
    "role": "artist",
    "permissions": {
      "canCreateReleases": true,
      "canManageArtists": false,
      "canViewAnalytics": true,
      "canManageDistribution": true,
      "canManageRoyalties": true,
      "canEditMetadata": true,
      "canAccessFinancials": true,
      "canInviteUsers": false
    },
    "status": "active",
    "createdAt": "2023-01-15T12:00:00Z"
  }
}
```

##### Register

Registers a new user account.

```
POST /auth/register
```

**Request Body:**

```json
{
  "username": "newuser@example.com",
  "email": "newuser@example.com",
  "password": "securepassword123",
  "fullName": "New User",
  "phoneNumber": "+1234567890",
  "entityName": "New User Music",
  "plan": "artist"
}
```

**Response:**

```json
{
  "data": {
    "id": 123,
    "username": "newuser@example.com",
    "email": "newuser@example.com",
    "fullName": "New User",
    "role": "artist",
    "status": "pending_approval",
    "createdAt": "2025-03-19T14:30:00Z"
  }
}
```

##### Logout

Invalidates the current user's session.

```
POST /auth/logout
```

**Response:**

```json
{
  "data": {
    "message": "Successfully logged out"
  }
}
```

#### User Management

##### Get All Users

Retrieves a list of users (admin access required).

```
GET /users
```

**Query Parameters:**

- `status`: Filter by user status
- `role`: Filter by user role
- `search`: Search by name, email, or username
- `page`: Page number
- `limit`: Items per page

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "username": "user1@example.com",
      "email": "user1@example.com",
      "fullName": "User One",
      "role": "artist",
      "status": "active",
      "createdAt": "2024-01-15T12:00:00Z"
    },
    {
      "id": 2,
      "username": "user2@example.com",
      "email": "user2@example.com",
      "fullName": "User Two",
      "role": "label",
      "status": "active",
      "createdAt": "2024-02-20T09:30:00Z"
    }
  ],
  "meta": {
    "pagination": {
      "total": 50,
      "page": 1,
      "limit": 10,
      "totalPages": 5
    }
  }
}
```

##### Get User by ID

Retrieves a specific user by ID.

```
GET /users/:id
```

**Response:**

```json
{
  "data": {
    "id": 1,
    "username": "user@example.com",
    "email": "user@example.com",
    "fullName": "John Doe",
    "phoneNumber": "+1234567890",
    "entityName": "John Doe Music",
    "avatarUrl": "https://example.com/avatar.jpg",
    "role": "artist",
    "permissions": { ... },
    "status": "active",
    "createdAt": "2023-01-15T12:00:00Z"
  }
}
```

##### Update User

Updates user information.

```
PATCH /users/:id
```

**Request Body:**

```json
{
  "fullName": "Updated Name",
  "phoneNumber": "+9876543210",
  "entityName": "Updated Music"
}
```

**Response:**

```json
{
  "data": {
    "id": 1,
    "username": "user@example.com",
    "email": "user@example.com",
    "fullName": "Updated Name",
    "phoneNumber": "+9876543210",
    "entityName": "Updated Music",
    "avatarUrl": "https://example.com/avatar.jpg",
    "role": "artist",
    "permissions": { ... },
    "status": "active",
    "createdAt": "2023-01-15T12:00:00Z",
    "updatedAt": "2025-03-19T15:45:30Z"
  }
}
```

##### Update User Status

Updates a user's status (admin access required).

```
PATCH /users/:id/status
```

**Request Body:**

```json
{
  "status": "active"
}
```

**Response:**

```json
{
  "data": {
    "id": 1,
    "username": "user@example.com",
    "status": "active",
    "updatedAt": "2025-03-19T15:50:00Z"
  }
}
```

#### API Keys

##### Get API Keys

Retrieves all API keys for the authenticated user.

```
GET /api-keys
```

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "name": "Production API Key",
      "key": "pk_live_xxxxxxxxxxxxxxxxxxxx",
      "scopes": ["read:tracks", "read:releases", "read:analytics"],
      "createdAt": "2025-01-10T09:00:00Z",
      "expiresAt": "2026-01-10T09:00:00Z"
    },
    {
      "id": 2,
      "name": "Test API Key",
      "key": "pk_test_xxxxxxxxxxxxxxxxxxxx",
      "scopes": ["read:tracks", "write:tracks", "read:releases", "write:releases"],
      "createdAt": "2025-02-15T14:30:00Z",
      "expiresAt": "2026-02-15T14:30:00Z"
    }
  ]
}
```

##### Create API Key

Creates a new API key.

```
POST /api-keys
```

**Request Body:**

```json
{
  "name": "Development API Key",
  "scopes": ["read:tracks", "read:releases"]
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "name": "Development API Key",
    "key": "pk_dev_xxxxxxxxxxxxxxxxxxxx",
    "scopes": ["read:tracks", "read:releases"],
    "createdAt": "2025-03-19T16:00:00Z",
    "expiresAt": "2026-03-19T16:00:00Z"
  }
}
```

##### Delete API Key

Deletes an API key.

```
DELETE /api-keys/:id
```

**Response:**

```json
{
  "data": {
    "message": "API key deleted successfully"
  }
}
```

#### Tracks

##### Get Tracks

Retrieves tracks for the authenticated user.

```
GET /tracks
```

**Query Parameters:**

- `releaseId`: Filter by release ID
- `search`: Search by title or artist
- `page`: Page number
- `limit`: Items per page

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "title": "Track One",
      "version": "Original Mix",
      "isrc": "USRC12345678",
      "artistName": "Artist Name",
      "duration": 180,
      "language": "english",
      "explicit": false,
      "audioUrl": "https://example.com/tracks/track1.mp3",
      "releaseId": 101,
      "genre": "pop",
      "createdAt": "2025-01-20T10:00:00Z",
      "updatedAt": "2025-01-20T10:00:00Z"
    },
    {
      "id": 2,
      "title": "Track Two",
      "version": "Radio Edit",
      "isrc": "USRC23456789",
      "artistName": "Artist Name",
      "duration": 210,
      "language": "english",
      "explicit": false,
      "audioUrl": "https://example.com/tracks/track2.mp3",
      "releaseId": 101,
      "genre": "pop",
      "createdAt": "2025-01-20T10:15:00Z",
      "updatedAt": "2025-01-20T10:15:00Z"
    }
  ],
  "meta": {
    "pagination": {
      "total": 15,
      "page": 1,
      "limit": 10,
      "totalPages": 2
    }
  }
}
```

##### Get Track by ID

Retrieves a specific track by ID.

```
GET /tracks/:id
```

**Response:**

```json
{
  "data": {
    "id": 1,
    "title": "Track One",
    "version": "Original Mix",
    "isrc": "USRC12345678",
    "artistName": "Artist Name",
    "duration": 180,
    "language": "english",
    "explicit": false,
    "audioUrl": "https://example.com/tracks/track1.mp3",
    "releaseId": 101,
    "genre": "pop",
    "createdAt": "2025-01-20T10:00:00Z",
    "updatedAt": "2025-01-20T10:00:00Z"
  }
}
```

##### Create Track

Creates a new track.

```
POST /tracks
```

**Request Body:**

```json
{
  "title": "New Track",
  "version": "Original Mix",
  "artistName": "Artist Name",
  "language": "english",
  "explicit": false,
  "genre": "electronic",
  "releaseId": 101
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "title": "New Track",
    "version": "Original Mix",
    "isrc": "USRC34567890",
    "artistName": "Artist Name",
    "duration": 0,
    "language": "english",
    "explicit": false,
    "audioUrl": null,
    "releaseId": 101,
    "genre": "electronic",
    "createdAt": "2025-03-19T16:30:00Z",
    "updatedAt": "2025-03-19T16:30:00Z"
  }
}
```

##### Update Track

Updates a track.

```
PATCH /tracks/:id
```

**Request Body:**

```json
{
  "title": "Updated Track Title",
  "version": "Extended Mix",
  "genre": "house"
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "title": "Updated Track Title",
    "version": "Extended Mix",
    "isrc": "USRC34567890",
    "artistName": "Artist Name",
    "duration": 0,
    "language": "english",
    "explicit": false,
    "audioUrl": null,
    "releaseId": 101,
    "genre": "house",
    "createdAt": "2025-03-19T16:30:00Z",
    "updatedAt": "2025-03-19T16:45:00Z"
  }
}
```

##### Upload Track Audio

Uploads audio for a track.

```
POST /tracks/:id/audio
```

**Request Body:**

Multipart form data with `audio` file.

**Response:**

```json
{
  "data": {
    "id": 3,
    "title": "Updated Track Title",
    "audioUrl": "https://example.com/tracks/track3.mp3",
    "duration": 240,
    "updatedAt": "2025-03-19T17:00:00Z"
  }
}
```

##### Get Track Analytics

Retrieves analytics for a track.

```
GET /tracks/:id/analytics
```

**Query Parameters:**

- `startDate`: Filter by start date (YYYY-MM-DD)
- `endDate`: Filter by end date (YYYY-MM-DD)
- `platform`: Filter by platform

**Response:**

```json
{
  "data": [
    {
      "id": 101,
      "trackId": 3,
      "platform": "spotify",
      "streams": 5230,
      "revenue": 20.92,
      "date": "2025-03-01",
      "country": "US",
      "createdAt": "2025-03-15T00:00:00Z"
    },
    {
      "id": 102,
      "trackId": 3,
      "platform": "apple_music",
      "streams": 1850,
      "revenue": 9.25,
      "date": "2025-03-01",
      "country": "US",
      "createdAt": "2025-03-15T00:00:00Z"
    }
  ],
  "meta": {
    "summary": {
      "totalStreams": 7080,
      "totalRevenue": 30.17,
      "platforms": {
        "spotify": {
          "streams": 5230,
          "revenue": 20.92
        },
        "apple_music": {
          "streams": 1850,
          "revenue": 9.25
        }
      }
    }
  }
}
```

#### Releases

##### Get Releases

Retrieves releases for the authenticated user.

```
GET /releases
```

**Query Parameters:**

- `type`: Filter by release type (single, album, ep)
- `status`: Filter by distribution status
- `search`: Search by title or artist
- `page`: Page number
- `limit`: Items per page

**Response:**

```json
{
  "data": [
    {
      "id": 101,
      "title": "Album Title",
      "artistName": "Artist Name",
      "type": "album",
      "releaseDate": "2025-04-15",
      "upc": "123456789012",
      "artworkUrl": "https://example.com/artwork/album1.jpg",
      "distributionStatus": "pending",
      "createdAt": "2025-02-10T10:00:00Z",
      "updatedAt": "2025-02-10T10:00:00Z"
    },
    {
      "id": 102,
      "title": "Single Title",
      "artistName": "Artist Name",
      "type": "single",
      "releaseDate": "2025-03-01",
      "upc": "234567890123",
      "artworkUrl": "https://example.com/artwork/single1.jpg",
      "distributionStatus": "distributed",
      "createdAt": "2025-01-15T14:30:00Z",
      "updatedAt": "2025-01-28T09:15:00Z"
    }
  ],
  "meta": {
    "pagination": {
      "total": 8,
      "page": 1,
      "limit": 10,
      "totalPages": 1
    }
  }
}
```

##### Get Release by ID

Retrieves a specific release by ID.

```
GET /releases/:id
```

**Response:**

```json
{
  "data": {
    "id": 101,
    "title": "Album Title",
    "artistName": "Artist Name",
    "type": "album",
    "releaseDate": "2025-04-15",
    "upc": "123456789012",
    "artworkUrl": "https://example.com/artwork/album1.jpg",
    "distributionStatus": "pending",
    "tracks": [
      {
        "id": 1,
        "title": "Track One",
        "version": "Original Mix",
        "isrc": "USRC12345678",
        "duration": 180,
        "audioUrl": "https://example.com/tracks/track1.mp3"
      },
      {
        "id": 2,
        "title": "Track Two",
        "version": "Radio Edit",
        "isrc": "USRC23456789",
        "duration": 210,
        "audioUrl": "https://example.com/tracks/track2.mp3"
      }
    ],
    "createdAt": "2025-02-10T10:00:00Z",
    "updatedAt": "2025-02-10T10:00:00Z"
  }
}
```

##### Create Release

Creates a new release.

```
POST /releases
```

**Request Body:**

```json
{
  "title": "New Album",
  "artistName": "Artist Name",
  "type": "album",
  "releaseDate": "2025-06-01"
}
```

**Response:**

```json
{
  "data": {
    "id": 103,
    "title": "New Album",
    "artistName": "Artist Name",
    "type": "album",
    "releaseDate": "2025-06-01",
    "upc": "345678901234",
    "artworkUrl": null,
    "distributionStatus": "pending",
    "tracks": [],
    "createdAt": "2025-03-19T17:30:00Z",
    "updatedAt": "2025-03-19T17:30:00Z"
  }
}
```

##### Update Release

Updates a release.

```
PATCH /releases/:id
```

**Request Body:**

```json
{
  "title": "Updated Album Title",
  "releaseDate": "2025-06-15"
}
```

**Response:**

```json
{
  "data": {
    "id": 103,
    "title": "Updated Album Title",
    "artistName": "Artist Name",
    "type": "album",
    "releaseDate": "2025-06-15",
    "upc": "345678901234",
    "artworkUrl": null,
    "distributionStatus": "pending",
    "createdAt": "2025-03-19T17:30:00Z",
    "updatedAt": "2025-03-19T17:45:00Z"
  }
}
```

##### Upload Release Artwork

Uploads artwork for a release.

```
POST /releases/:id/artwork
```

**Request Body:**

Multipart form data with `artwork` file.

**Response:**

```json
{
  "data": {
    "id": 103,
    "title": "Updated Album Title",
    "artworkUrl": "https://example.com/artwork/album3.jpg",
    "updatedAt": "2025-03-19T18:00:00Z"
  }
}
```

#### Distribution

##### Get Distribution Platforms

Retrieves available distribution platforms.

```
GET /distribution/platforms
```

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "name": "Spotify",
      "apiEndpoint": "https://api.spotify.com",
      "logoUrl": "https://example.com/logos/spotify.png",
      "type": "streaming",
      "active": true,
      "createdAt": "2024-01-01T00:00:00Z"
    },
    {
      "id": 2,
      "name": "Apple Music",
      "apiEndpoint": "https://api.apple.com/music",
      "logoUrl": "https://example.com/logos/apple_music.png",
      "type": "streaming",
      "active": true,
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ]
}
```

##### Get Distribution Records

Retrieves distribution records for a release.

```
GET /distribution/records
```

**Query Parameters:**

- `releaseId`: Filter by release ID (required)

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "releaseId": 101,
      "platformId": 1,
      "status": "processing",
      "notes": "Distribution in progress",
      "createdAt": "2025-03-01T12:00:00Z",
      "updatedAt": "2025-03-01T12:15:00Z",
      "platform": {
        "id": 1,
        "name": "Spotify",
        "logoUrl": "https://example.com/logos/spotify.png"
      }
    },
    {
      "id": 2,
      "releaseId": 101,
      "platformId": 2,
      "status": "distributed",
      "notes": "Successfully distributed",
      "createdAt": "2025-03-01T12:00:00Z",
      "updatedAt": "2025-03-01T14:30:00Z",
      "platform": {
        "id": 2,
        "name": "Apple Music",
        "logoUrl": "https://example.com/logos/apple_music.png"
      }
    }
  ]
}
```

##### Create Distribution Record

Distributes a release to a platform.

```
POST /distribution/records
```

**Request Body:**

```json
{
  "releaseId": 101,
  "platformId": 3
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "releaseId": 101,
    "platformId": 3,
    "status": "pending",
    "notes": "Distribution initiated",
    "createdAt": "2025-03-19T18:30:00Z",
    "updatedAt": "2025-03-19T18:30:00Z",
    "platform": {
      "id": 3,
      "name": "Amazon Music",
      "logoUrl": "https://example.com/logos/amazon_music.png"
    }
  }
}
```

##### Schedule Distribution

Schedules a distribution for future execution.

```
POST /distribution/schedule
```

**Request Body:**

```json
{
  "releaseId": 103,
  "platformId": 1,
  "scheduledDate": "2025-06-01T00:00:00Z"
}
```

**Response:**

```json
{
  "data": {
    "id": 5,
    "releaseId": 103,
    "platformId": 1,
    "scheduledDate": "2025-06-01T00:00:00Z",
    "status": "scheduled",
    "createdAt": "2025-03-19T19:00:00Z",
    "updatedAt": "2025-03-19T19:00:00Z",
    "platform": {
      "id": 1,
      "name": "Spotify",
      "logoUrl": "https://example.com/logos/spotify.png"
    }
  }
}
```

##### Get Scheduled Distributions

Retrieves scheduled distributions for the authenticated user.

```
GET /distribution/scheduled
```

**Response:**

```json
{
  "data": [
    {
      "id": 5,
      "releaseId": 103,
      "platformId": 1,
      "scheduledDate": "2025-06-01T00:00:00Z",
      "status": "scheduled",
      "createdAt": "2025-03-19T19:00:00Z",
      "updatedAt": "2025-03-19T19:00:00Z",
      "platform": {
        "id": 1,
        "name": "Spotify",
        "logoUrl": "https://example.com/logos/spotify.png"
      },
      "release": {
        "id": 103,
        "title": "Updated Album Title",
        "artistName": "Artist Name"
      }
    }
  ]
}
```

##### Cancel Scheduled Distribution

Cancels a scheduled distribution.

```
DELETE /distribution/scheduled/:id
```

**Response:**

```json
{
  "data": {
    "message": "Scheduled distribution canceled successfully"
  }
}
```

#### Royalty Management

##### Get Payment Methods

Retrieves payment methods for the authenticated user.

```
GET /payments/methods
```

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "userId": 1,
      "type": "bank_account",
      "details": {
        "bankName": "Example Bank",
        "accountNumber": "****6789",
        "accountType": "checking"
      },
      "isDefault": true,
      "createdAt": "2025-01-15T10:00:00Z",
      "updatedAt": "2025-01-15T10:00:00Z"
    },
    {
      "id": 2,
      "userId": 1,
      "type": "paypal",
      "details": {
        "email": "user@example.com"
      },
      "isDefault": false,
      "createdAt": "2025-02-10T14:30:00Z",
      "updatedAt": "2025-02-10T14:30:00Z"
    }
  ]
}
```

##### Create Payment Method

Creates a new payment method.

```
POST /payments/methods
```

**Request Body:**

```json
{
  "type": "bank_account",
  "details": {
    "bankName": "New Bank",
    "accountNumber": "987654321",
    "routingNumber": "123456789",
    "accountType": "savings"
  },
  "isDefault": false
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "userId": 1,
    "type": "bank_account",
    "details": {
      "bankName": "New Bank",
      "accountNumber": "****4321",
      "accountType": "savings"
    },
    "isDefault": false,
    "createdAt": "2025-03-19T19:30:00Z",
    "updatedAt": "2025-03-19T19:30:00Z"
  }
}
```

##### Get Withdrawals

Retrieves withdrawal requests for the authenticated user.

```
GET /payments/withdrawals
```

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "userId": 1,
      "amount": 500.00,
      "status": "completed",
      "paymentMethod": {
        "id": 1,
        "type": "bank_account",
        "details": {
          "bankName": "Example Bank",
          "accountNumber": "****6789"
        }
      },
      "createdAt": "2025-02-01T10:00:00Z",
      "updatedAt": "2025-02-03T14:30:00Z"
    },
    {
      "id": 2,
      "userId": 1,
      "amount": 750.00,
      "status": "pending",
      "paymentMethod": {
        "id": 1,
        "type": "bank_account",
        "details": {
          "bankName": "Example Bank",
          "accountNumber": "****6789"
        }
      },
      "createdAt": "2025-03-15T09:00:00Z",
      "updatedAt": "2025-03-15T09:00:00Z"
    }
  ]
}
```

##### Create Withdrawal

Creates a new withdrawal request.

```
POST /payments/withdrawals
```

**Request Body:**

```json
{
  "amount": 1000.00,
  "paymentMethodId": 1
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "userId": 1,
    "amount": 1000.00,
    "status": "pending",
    "paymentMethod": {
      "id": 1,
      "type": "bank_account",
      "details": {
        "bankName": "Example Bank",
        "accountNumber": "****6789"
      }
    },
    "createdAt": "2025-03-19T20:00:00Z",
    "updatedAt": "2025-03-19T20:00:00Z"
  }
}
```

##### Get Revenue Shares

Retrieves revenue shares for a release.

```
GET /royalties/shares
```

**Query Parameters:**

- `releaseId`: Filter by release ID (required)

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "releaseId": 101,
      "userId": 1,
      "percentage": 70.0,
      "role": "primary_artist",
      "createdAt": "2025-02-10T10:30:00Z",
      "updatedAt": "2025-02-10T10:30:00Z",
      "user": {
        "id": 1,
        "fullName": "John Doe",
        "email": "user@example.com"
      }
    },
    {
      "id": 2,
      "releaseId": 101,
      "userId": 5,
      "percentage": 30.0,
      "role": "producer",
      "createdAt": "2025-02-10T10:30:00Z",
      "updatedAt": "2025-02-10T10:30:00Z",
      "user": {
        "id": 5,
        "fullName": "Jane Smith",
        "email": "producer@example.com"
      }
    }
  ]
}
```

##### Create Revenue Share

Creates a new revenue share.

```
POST /royalties/shares
```

**Request Body:**

```json
{
  "releaseId": 101,
  "userId": 10,
  "percentage": 10.0,
  "role": "featured_artist"
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "releaseId": 101,
    "userId": 10,
    "percentage": 10.0,
    "role": "featured_artist",
    "createdAt": "2025-03-19T20:30:00Z",
    "updatedAt": "2025-03-19T20:30:00Z",
    "user": {
      "id": 10,
      "fullName": "Featured Artist",
      "email": "featured@example.com"
    }
  }
}
```

#### Support System

##### Get Support Tickets

Retrieves support tickets for the authenticated user.

```
GET /support/tickets
```

**Query Parameters:**

- `status`: Filter by ticket status
- `page`: Page number
- `limit`: Items per page

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "userId": 1,
      "title": "Distribution Issue",
      "description": "My release isn't showing up on Spotify",
      "status": "open",
      "priority": "high",
      "category": "distribution",
      "assignedTo": null,
      "createdAt": "2025-03-15T10:00:00Z",
      "updatedAt": "2025-03-15T10:00:00Z"
    },
    {
      "id": 2,
      "userId": 1,
      "title": "Billing Question",
      "description": "I need clarification on my latest statement",
      "status": "closed",
      "priority": "medium",
      "category": "billing",
      "assignedTo": 100,
      "createdAt": "2025-02-20T14:30:00Z",
      "updatedAt": "2025-02-22T09:15:00Z"
    }
  ],
  "meta": {
    "pagination": {
      "total": 2,
      "page": 1,
      "limit": 10,
      "totalPages": 1
    }
  }
}
```

##### Get Support Ticket by ID

Retrieves a specific support ticket by ID.

```
GET /support/tickets/:id
```

**Response:**

```json
{
  "data": {
    "id": 1,
    "userId": 1,
    "title": "Distribution Issue",
    "description": "My release isn't showing up on Spotify",
    "status": "open",
    "priority": "high",
    "category": "distribution",
    "assignedTo": null,
    "createdAt": "2025-03-15T10:00:00Z",
    "updatedAt": "2025-03-15T10:00:00Z",
    "messages": [
      {
        "id": 1,
        "ticketId": 1,
        "userId": 1,
        "message": "My album was distributed to Spotify 3 days ago but still isn't showing up.",
        "createdAt": "2025-03-15T10:00:00Z"
      }
    ]
  }
}
```

##### Create Support Ticket

Creates a new support ticket.

```
POST /support/tickets
```

**Request Body:**

```json
{
  "title": "Metadata Question",
  "description": "How do I update the genre for my release?",
  "priority": "medium",
  "category": "content"
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "userId": 1,
    "title": "Metadata Question",
    "description": "How do I update the genre for my release?",
    "status": "open",
    "priority": "medium",
    "category": "content",
    "assignedTo": null,
    "createdAt": "2025-03-19T21:00:00Z",
    "updatedAt": "2025-03-19T21:00:00Z"
  }
}
```

##### Add Message to Ticket

Adds a message to a support ticket.

```
POST /support/tickets/:id/messages
```

**Request Body:**

```json
{
  "message": "I need to change the genre from 'pop' to 'electronic pop'. Can you help me?"
}
```

**Response:**

```json
{
  "data": {
    "id": 2,
    "ticketId": 3,
    "userId": 1,
    "message": "I need to change the genre from 'pop' to 'electronic pop'. Can you help me?",
    "createdAt": "2025-03-19T21:15:00Z"
  }
}
```

#### File Upload

##### Upload File

Uploads a file to the server.

```
POST /upload
```

**Request Body:**

Multipart form data with `file` and optional `type` parameter.

**Response:**

```json
{
  "data": {
    "url": "https://example.com/uploads/12345.jpg",
    "filename": "image.jpg",
    "mimetype": "image/jpeg",
    "size": 102400
  }
}
```

### Webhooks

#### Webhook Events

TuneMantra supports webhooks for real-time event notifications. Available events include:

- `release.created`: A new release is created
- `release.updated`: A release is updated
- `release.distributed`: A release is distributed to a platform
- `track.created`: A new track is created
- `track.updated`: A track is updated
- `analytics.updated`: Analytics data is updated
- `payment.processed`: A payment is processed
- `withdrawal.status_changed`: A withdrawal status changes

#### Webhook Registration

To register a webhook endpoint, use the API Key management interface or contact support.

#### Webhook Payload

Webhook payloads follow this structure:

```json
{
  "event": "release.distributed",
  "timestamp": "2025-03-19T21:30:00Z",
  "data": {
    "releaseId": 101,
    "platformId": 1,
    "status": "distributed"
  }
}
```

#### Webhook Security

Webhooks include a signature header (`X-TuneMantra-Signature`) for verifying authenticity. The signature is a HMAC-SHA256 hash of the payload using your webhook secret.

### Error Codes

| Error Code | Description |
|------------|-------------|
| `AUTH_FAILED` | Authentication failed |
| `INVALID_TOKEN` | Invalid or expired token |
| `PERMISSION_DENIED` | Insufficient permissions |
| `RESOURCE_NOT_FOUND` | Requested resource not found |
| `VALIDATION_ERROR` | Request validation failed |
| `RATE_LIMIT_EXCEEDED` | Rate limit exceeded |
| `INTERNAL_ERROR` | Internal server error |
| `DUPLICATE_ENTITY` | Entity already exists |
| `INVALID_OPERATION` | Operation not allowed |
| `SUBSCRIPTION_REQUIRED` | Subscription required for this feature |

### Versioning

The TuneMantra API follows semantic versioning. The current version is v1.

### Support

For API support, contact api-support@tunemantra.com or create a support ticket through the API.

---

*© 2025 TuneMantra. All rights reserved.*

---

#### 2025-03-01: Distribution Service Architecture
_Source: unified_documentation/distribution/temp-extraction-distribution-service.md (Branch: temp)_


**Last Updated: March 18, 2025**

### Overview

The TuneMantra distribution system uses three complementary services to handle different aspects of the distribution process:

1. **Distribution Service** (`DistributionService`) - Primary instance-based service for distribution operations
2. **Static Distribution Service** (`Distribution`) - Static utility class for platform management
3. **Manual Distribution Service** (`ManualDistributionService`) - Specialized service for handling manual exports

This architecture allows for efficient handling of various distribution methods (API, FTP, manual) while maintaining a unified tracking system.

### Service Responsibilities

#### Distribution Service (`distribution-service.ts`)

The `DistributionService` is the core service responsible for managing platform connections and distribution operations:

- **Platform Connection Management**: Maintains a map of platform connections and initializes them
- **Distribution Operations**: Distributes releases to platforms, processes queues, and checks statuses
- **Withdrawal Operations**: Handles removing releases from platforms
- **Export Operations**: Handles exporting for manual distribution

```typescript
class DistributionService {
  private connections: Map<string, PlatformConnection> = new Map();

  // Initialize platform connections for various distribution services
  private async initializeConnections() {
    this.connections.set('spotify', new SpotifyConnection());
    this.connections.set('apple-music', new ManualConnection('apple-music', ExportFormat.XML, 'exports/apple'));
    this.connections.set('amazon-music', new ManualConnection('amazon-music', ExportFormat.EXCEL, 'exports/amazon'));
    this.connections.set('deezer', new ManualConnection('deezer', ExportFormat.JSON, 'exports/deezer'));
    this.connections.set('tidal', new ManualConnection('tidal', ExportFormat.CSV, 'exports/tidal'));
  }

  // Distribution operations
  async distributeRelease(releaseId: number, platformIds: number[], scheduledDate?: Date) {}
  async processDistributionQueue() {}
  async checkDistributionStatuses() {}
  async withdrawDistribution(releaseId: number, platformId?: number) {}

  // Export operations
  async exportForManualDistribution(releaseId: number, platformId: number, format: ExportFormat) {}
  async getDistributionHistory(releaseId: number) {}
  async updateManualDistributionStatus(distributionId: number, status: string, details?: string) {}
}
```

#### Static Distribution Service (`distribution.ts`)

The `Distribution` class provides static utility methods for platform management and distribution operations:

- **Platform Management**: Getting active platforms, platform by name, credential validation
- **Distribution Status**: Checking status for releases
- **Distribution Processing**: Processing distribution to specific platforms
- **Scheduled Distributions**: Processing scheduled distributions

```typescript
export class Distribution {
  // Platform management
  static async getActivePlatforms() {}
  static async getPlatformByName(name: string) {}
  static async hasPlatformCredentials(platformId: number) {}

  // Distribution status
  static async getDistributionStatus(releaseId: number) {}

  // Distribution processing
  static async processDistribution(distributionRecordId: number): Promise<boolean> {}
  private static async distributeViaAPI(record, release, tracks, platform) {}
  private static async distributeToSpotify(record, release, tracks, credentials) {}
  private static async distributeToAppleMusic(record, release, tracks, credentials) {}
  private static async distributeToAmazonMusic(record, release, tracks, credentials) {}
  private static async distributeViaFTP(record, release, tracks, platform) {}

  // Scheduled distributions
  static async processScheduledDistributions(): Promise<number> {}
}
```

#### Manual Distribution Service (`manual-distribution-service.ts`)

The `ManualDistributionService` handles export generation and status management for manually distributed content:

- **Export Generation**: Creating exports in various formats for manual distribution
- **Status Management**: Tracking status of manually distributed content
- **Import Processing**: Handling status updates and platform IDs from manual distribution

```typescript
export class ManualDistributionService {
  // Export generation
  async generateExport(releaseId: number, platformId: number, format: ExportFormat): Promise<string> {}

  // Status management
  async updateDistributionStatus(distributionId: number, status: string, details?: string) {}
  async importPlatformIds(distributionId: number, platformIds: Record<string, string>) {}

  // Import processing
  async processStatusImport(importFile: Buffer, format: string): Promise<number> {}
  private async processStatusCsvImport(csvData: Buffer): Promise<number> {}
  private async processStatusExcelImport(excelData: Buffer): Promise<number> {}
  private async processStatusJsonImport(jsonData: Buffer): Promise<number> {}
}
```

### Platform Connection System

The distribution services interact with streaming platforms through a unified `PlatformConnection` interface:

```typescript
export interface PlatformConnection {
  readonly type: ConnectionType;
  readonly platformCode: string;

  isConfigured(): Promise<boolean>;
  distributeRelease(release: Release): Promise<DistributionResult>;
  checkStatus(referenceId: string): Promise<StatusResult>;
  removeContent(referenceId: string): Promise<DistributionResult>;
}
```

Three types of connections are implemented:

1. **API Connections**: Direct API integration with platforms (e.g., Spotify)
2. **FTP Connections**: File-based distribution using FTP/SFTP
3. **Manual Connections**: Export-based distribution requiring manual handling

### Distribution Workflow

The distribution workflow follows these steps:

1. **Initialization**
   - Create distribution record(s) for each platform
   - Set initial status to "pending"
   - Store platform-specific metadata

2. **Distribution**
   - For API platforms: Make direct API calls
   - For FTP platforms: Generate and upload files
   - For manual platforms: Generate export files

3. **Status Tracking**
   - For API/FTP platforms: Periodically check status
   - For manual platforms: Update status manually
   - Update distribution records with current status

4. **Completion**
   - Set final status (distributed, failed, etc.)
   - Store platform-specific IDs
   - Record distribution analytics

### Error Handling and Retry Mechanism

The distribution system implements a robust error handling and retry mechanism:

1. **Error Classification**
   - Temporary errors: Network issues, rate limits
   - Permanent errors: Invalid content, authentication failures
   - Unknown errors: Uncategorized errors

2. **Retry Strategy**
   - Exponential backoff for temporary errors
   - Immediate failure for permanent errors
   - Limited retries for unknown errors

3. **Error Logging**
   - Detailed error information captured
   - Error categorization for analytics
   - Resolution recommendations generated

### Scheduled Distribution System

The scheduled distribution system allows releases to be distributed at specific dates:

1. **Schedule Management**
   - Schedule creation with timezone support
   - Schedule modification and cancellation
   - Conflict detection and resolution

2. **Processing**
   - Regular polling of scheduled distributions
   - Triggering distribution when scheduled time is reached
   - Status updates and notifications

### Performance Optimization

The distribution system has been optimized for performance:

1. **Concurrency Control**
   - Controlled parallel processing of distributions
   - Platform-specific rate limiting
   - Resource utilization management

2. **Batch Processing**
   - Efficient batching of similar operations
   - Optimized database queries
   - Reduced network overhead

3. **Caching**
   - Platform configuration caching
   - Connection reuse
   - Status check optimization

### Extension Points

The architecture provides several extension points for future enhancements:

1. **New Platform Types**
   - Implement new `PlatformConnection` types
   - Register with `DistributionService`

2. **Additional Export Formats**
   - Add new export format handlers to `ManualDistributionService`
   - Implement format-specific generation logic

3. **Enhanced Status Tracking**
   - Add new status types
   - Implement platform-specific status mapping
   - Enhance notification system

### Database Schema

The distribution system relies on these key database tables:

1. **distribution_platforms**
   - Platform configuration and credentials
   - Connection type and settings
   - Status and activity tracking

2. **distribution_records**
   - Release-to-platform distribution mapping
   - Status tracking and history
   - Platform-specific IDs and metadata
   - Error information and retry counts

3. **scheduled_distributions**
   - Future distribution scheduling
   - Release and platform mapping
   - Schedule management and status

### Integration with Other Systems

The distribution system integrates with several other TuneMantra components:

1. **Content Management System**
   - Access to release and track data
   - Metadata validation and preparation
   - Content file access

2. **Analytics System**
   - Distribution performance metrics
   - Success rate tracking
   - Error analysis and reporting

3. **Notification System**
   - Status change notifications
   - Error alerts
   - Completion notifications

---

**Document Owner**: Distribution Team  
**Created**: March 5, 2025  
**Last Updated**: March 18, 2025  
**Status**: Current  
**Related Documents**: 
- [Distribution System Overview](../../distribution-system.md)
- [API Reference - Distribution Endpoints](../../api/api-reference.md)
- [Manual Distribution Strategy](../../archive/manual_distribution_strategy.md)

---

#### 2025-03-01: TuneMantra Music Distribution Platform
_Source: unified_documentation/technical/main-readme.md (Branch: main)_


![TuneMantra Logo](generated-icon.png)

### Project Status: 100% Complete ✅

All platform components have been fully implemented and verified. The system is ready for production deployment.

### Overview

TuneMantra is a comprehensive, enterprise-grade music distribution platform designed to streamline the entire digital music supply chain. It enables artists, labels, and music businesses to distribute music to global streaming platforms, manage rights and royalties, and analyze performance data with industry-leading accuracy.

### Key Features

- **Global Distribution**: Deliver music to 150+ streaming platforms worldwide
- **Metadata Management**: Comprehensive tools for managing and enhancing music metadata
- **Rights Management**: Sophisticated rights tracking and management
- **Advanced Royalty Processing**: Automated calculation with platform-specific rates (Spotify: $0.004, Apple Music: $0.008, etc.)
- **Flexible Analytics**: Detailed performance metrics with customizable timeframes (day, week, month, quarter, year)
- **Release Management**: End-to-end workflow for music releases with real-time status tracking
- **Team Collaboration**: Role-based access control for teams
- **White-Label Solutions**: Customizable branding for labels
- **Batch Processing**: High-performance calculation for large catalogs
- **Split Payments**: Sophisticated royalty sharing for collaborations

### Documentation

Comprehensive documentation is available in the [documentation](/documentation) directory:

- [Documentation Index](/documentation/DOCUMENTATION_INDEX.md) - Complete guide to all documentation
- [Project Status](/documentation/merged/project-status-unified.md) - Current completion status
- [User Guides](/documentation/user-guides) - For end users of the platform
- [Technical Documentation](/documentation/technical) - For developers and engineers
- [API Reference](/documentation/api-reference) - API documentation
- [Administrator Guide](/documentation/admin) - For system administrators
- [Business Documentation](/documentation/business) - For executives and stakeholders
- [Verification Summary](/documentation/technical/organized-verification-summary-fixed.md) - Testing and verification results

### Getting Started

#### Prerequisites

- Node.js (v18+)
- PostgreSQL (v14+)
- Git

#### Installation

1. Clone the repository:

```bash
git clone https://github.com/tunemantra/distribution-platform.git
cd distribution-platform
```

2. Install dependencies:

```bash
npm install
```

3. Set up environment variables:

```bash
cp .env.example .env
## Edit .env with your configuration
```

4. Initialize the database:

```bash
npm run db:push
```

5. Start the development server:

```bash
npm run dev
```

The application will be available at http://localhost:5000.

### Development

For detailed development instructions, please refer to the [Development Guide](/documentation/developer/completion-notes.md).

### Support

For support, please contact:

- **Technical Support**: support@tunemantra.com
- **Sales Inquiries**: sales@tunemantra.com
- **General Information**: info@tunemantra.com

---

*© 2025 TuneMantra. All rights reserved.*

---

#### 2025-03-01: TuneMantra Music Distribution Platform
_Source: unified_documentation/technical/PPv1-readme.md (Branch: PPv1)_


![TuneMantra Logo](generated-icon.png)

### Project Status: 85% Complete 🔄

The core platform components have been implemented, with some final fixes and documentation updates in progress. The system is functionally complete but requires fixing some TypeScript errors and completing documentation before production deployment.

### Overview

TuneMantra is a comprehensive, enterprise-grade music distribution platform designed to streamline the entire digital music supply chain. It enables artists, labels, and music businesses to distribute music to global streaming platforms, manage rights and royalties, and analyze performance data with industry-leading accuracy.

### Key Features

- **Global Distribution**: Deliver music to 150+ streaming platforms worldwide
- **Metadata Management**: Comprehensive tools for managing and enhancing music metadata
- **Rights Management**: Sophisticated rights tracking and management
- **Advanced Royalty Processing**: Automated calculation with platform-specific rates (Spotify: $0.004, Apple Music: $0.008, etc.)
- **Flexible Analytics**: Detailed performance metrics with customizable timeframes (day, week, month, quarter, year)
- **Release Management**: End-to-end workflow for music releases with real-time status tracking
- **Team Collaboration**: Role-based access control for teams
- **White-Label Solutions**: Customizable branding for labels
- **Batch Processing**: High-performance calculation for large catalogs
- **Split Payments**: Sophisticated royalty sharing for collaborations

### Documentation

Comprehensive documentation is available in the [documentation](/documentation) directory:

- [Documentation Index](/documentation/DOCUMENTATION_INDEX.md) - Complete guide to all documentation
- [Project Status](/documentation/merged/project-status-unified.md) - Current completion status
- [User Guides](/documentation/user-guides) - For end users of the platform
- [Technical Documentation](/documentation/technical) - For developers and engineers
- [API Reference](/documentation/api-reference) - API documentation
- [Administrator Guide](/documentation/admin) - For system administrators
- [Business Documentation](/documentation/business) - For executives and stakeholders
- [Verification Summary](/documentation/technical/organized-verification-summary-fixed.md) - Testing and verification results

### Getting Started

#### Prerequisites

- Node.js (v18+)
- PostgreSQL (v14+)
- Git

#### Installation

1. Clone the repository:

```bash
git clone https://github.com/tunemantra/distribution-platform.git
cd distribution-platform
```

2. Install dependencies:

```bash
npm install
```

3. Set up environment variables:

```bash
cp .env.example .env
## Edit .env with your configuration
```

4. Initialize the database:

```bash
npm run db:push
```

5. Start the development server:

```bash
npm run dev
```

The application will be available at http://localhost:5000.

### Development

For detailed development instructions, please refer to the [Development Guide](/documentation/developer/completion-notes.md).

### Support

For support, please contact:

- **Technical Support**: support@tunemantra.com
- **Sales Inquiries**: sales@tunemantra.com
- **General Information**: info@tunemantra.com

---

*© 2025 TuneMantra. All rights reserved.*

---

#### 2025-03-01: Content Management System
_Source: unified_documentation/technical/temp-3march-content-management.md (Branch: temp)_


### Overview

The TuneMantra Content Management System (CMS) provides the infrastructure for storing, organizing, processing, and delivering music assets throughout the platform. This document outlines the technical architecture and implementation details for developers and system integrators.

### System Architecture

The content management system employs a microservice architecture with the following components:

#### 1. Asset Storage Service

**Purpose**: Securely stores all digital assets including audio files, images, videos, and documents.

**Implementation**:
- Object storage backend with AWS S3 compatibility
- Content-addressed storage for deduplication
- Multi-region replication for availability
- Versioning system for asset history

**Key Files**:
- `server/services/storage.ts` - Storage interface
- `server/utils/file-storage.ts` - Implementation
- `server/middleware/upload.ts` - Upload handlers

#### 2. Metadata Management Service

**Purpose**: Maintains all metadata associated with music assets.

**Implementation**:
- PostgreSQL database with JSON capabilities
- Schema validation through Drizzle ORM
- Indexing for high-speed queries
- Full-text search capabilities

**Key Files**:
- `shared/schema.ts` - Database schema
- `server/storage.ts` - Database operations
- `shared/enhanced-metadata-schema.ts` - Extended schema

#### 3. Media Processing Service

**Purpose**: Processes uploaded media files for compatibility and optimization.

**Implementation**:
- Asynchronous processing queue
- Format validation and conversion
- Audio waveform generation
- Image resizing and optimization
- Video transcoding
- Content analysis

**Key Files**:
- `server/services/ai-tagging.ts` - AI analysis
- `server/services/media-processor.ts` - Processing logic
- `server/utils/audio-processor.ts` - Audio-specific utilities

#### 4. Content Delivery Network

**Purpose**: Efficiently delivers content to end users.

**Implementation**:
- Edge-cached content distribution
- Geographic routing
- On-demand transcoding
- Access controls
- Bandwidth optimization

### Data Models

#### Asset Model

```typescript
export interface Asset {
  id: string;            // Unique identifier
  type: AssetType;       // audio, image, video, document
  originalFilename: string;
  contentType: string;   // MIME type
  size: number;          // In bytes
  hash: string;          // Content hash for integrity
  path: string;          // Storage path
  metadata: AssetMetadata;
  versions: AssetVersion[];
  uploadedBy: number;    // User ID
  createdAt: Date;
  updatedAt: Date;
}

export enum AssetType {
  AUDIO = 'audio',
  IMAGE = 'image',
  VIDEO = 'video',
  DOCUMENT = 'document'
}

export interface AssetVersion {
  id: string;
  assetId: string;
  purpose: string;       // e.g., "thumbnail", "preview", "master"
  path: string;
  size: number;
  contentType: string;
  createdAt: Date;
}
```

#### Asset Bundle Model

```typescript
export interface AssetBundle {
  id: string;
  name: string;
  description: string;
  type: BundleType;      // release, track, artwork, etc.
  status: BundleStatus;
  assets: Asset[];
  metadata: BundleMetadata;
  ownerId: number;       // User ID
  createdAt: Date;
  updatedAt: Date;
}

export enum BundleType {
  RELEASE = 'release',
  TRACK = 'track',
  ARTWORK = 'artwork',
  PROMOTIONAL = 'promotional'
}

export enum BundleStatus {
  DRAFT = 'draft',
  COMPLETE = 'complete',
  ARCHIVED = 'archived',
  PROCESSING = 'processing'
}
```

### Content Processing Workflows

#### Audio Upload Workflow

1. **Initial Upload**
   - User uploads WAV/FLAC/MP3 file via API or UI
   - File is temporarily stored in staging area
   - Initial validation checks format and integrity

2. **Processing**
   - Audio analysis extracts technical metadata
   - Format conversion creates necessary versions
   - Waveform visualization is generated
   - AI analysis adds metadata tags

3. **Storage**
   - Master file is stored in archive storage
   - Streamable versions are created and cached
   - All versions are linked in asset management

4. **Delivery Preparation**
   - Platform-specific formats are generated
   - Content protection is applied as needed
   - Delivery package is prepared

#### Image Upload Workflow

1. **Initial Upload**
   - User uploads high-resolution image
   - Image is validated for dimensions and format
   - Initial metadata is extracted

2. **Processing**
   - Multiple resolutions are generated
   - Format conversions are performed
   - Optimization reduces file size
   - Color analysis adds metadata

3. **Storage**
   - Original file is archived
   - Optimized versions are stored for delivery
   - Thumbnails are generated for UI

### API Reference

#### Asset API

##### Upload Asset

```
POST /api/assets
Content-Type: multipart/form-data

Parameters:
- file: The file to upload
- type: Asset type (audio, image, video, document)
- purpose: Purpose of the asset (master, artwork, promotional)
- metadata: JSON object with additional metadata
```

##### Retrieve Asset

```
GET /api/assets/:assetId

Response:
{
  "id": "asset-123",
  "type": "audio",
  "originalFilename": "track.wav",
  "contentType": "audio/wav",
  "size": 58934232,
  "hash": "sha256:abc123...",
  "path": "assets/audio/asset-123",
  "metadata": { ... },
  "versions": [ ... ],
  "createdAt": "2025-01-15T12:34:56Z",
  "updatedAt": "2025-01-15T12:34:56Z"
}
```

##### Update Asset Metadata

```
PATCH /api/assets/:assetId/metadata
Content-Type: application/json

Request Body:
{
  "title": "New Title",
  "description": "Updated description",
  "tags": ["rock", "alternative"]
}
```

##### Delete Asset

```
DELETE /api/assets/:assetId
```

#### Bundle API

##### Create Bundle

```
POST /api/bundles
Content-Type: application/json

Request Body:
{
  "name": "Summer Release 2025",
  "description": "Summer EP release with 4 tracks",
  "type": "release",
  "metadata": { ... }
}
```

##### Add Asset to Bundle

```
POST /api/bundles/:bundleId/assets
Content-Type: application/json

Request Body:
{
  "assetId": "asset-123",
  "position": 1,
  "metadata": { ... }
}
```

### Security

The Content Management System implements several security measures:

1. **Access Control**
   - Role-based access control for all operations
   - Fine-grained permissions for asset operations
   - Ownership validation for all mutations

2. **Content Protection**
   - Digital watermarking for tracking
   - Digital Rights Management (DRM) for premium content
   - Encryption for sensitive assets

3. **Storage Security**
   - Encrypted storage at rest
   - Secure transfer with TLS
   - Regular integrity checks
   - Audit logging for all operations

### Scalability

The system is designed for horizontal scaling:

1. **Storage Partitioning**
   - Content is partitioned by type and usage patterns
   - Hot/cold storage tiers optimize costs
   - Multi-region replication for availability

2. **Processing Scaling**
   - Media processing runs on auto-scaling worker pools
   - Priority queuing for critical operations
   - Batch processing for efficiency

3. **Caching Strategy**
   - Multi-level caching reduces database load
   - Content delivery optimized by geography
   - Predictive caching for popular content

### Monitoring

The CMS includes comprehensive monitoring:

1. **Performance Metrics**
   - Upload/download throughput
   - Processing times
   - Storage utilization
   - Cache hit rates

2. **Health Checks**
   - Service availability monitoring
   - Storage integrity verification
   - Processing queue health

3. **Alerting**
   - Threshold-based alerts for key metrics
   - Error rate monitoring
   - Capacity planning alerts

### Implementation Examples

#### Upload Implementation

```typescript
// In server/routes/file-upload.ts
import multer from 'multer';
import { Request, Response } from 'express';
import { AssetType } from '@shared/schema';
import { processAudio } from '../services/media-processor';

const upload = multer({ 
  dest: 'uploads/',
  limits: { fileSize: 1024 * 1024 * 1024 } // 1GB limit
});

export const uploadFile = async (req: Request, res: Response) => {
  try {
    // Handle file upload
    upload.single('file')(req, res, async (err) => {
      if (err) {
        return res.status(400).json({ error: err.message });
      }

      const file = req.file;
      if (!file) {
        return res.status(400).json({ error: 'No file provided' });
      }

      // Get asset type from request
      const assetType = req.body.type as AssetType;

      // Process file based on type
      let asset;
      switch (assetType) {
        case AssetType.AUDIO:
          asset = await processAudio(file.path, {
            originalFilename: file.originalname,
            contentType: file.mimetype,
            size: file.size,
            uploadedBy: req.userId
          });
          break;
        // Handle other asset types
        default:
          return res.status(400).json({ error: 'Unsupported asset type' });
      }

      // Return the created asset
      return res.status(201).json(asset);
    });
  } catch (error) {
    console.error('Upload error:', error);
    return res.status(500).json({ error: 'Upload failed' });
  }
};
```

#### Media Processing Implementation

```typescript
// In server/services/media-processor.ts
import { Asset, AssetType } from '@shared/schema';
import { storage } from '../storage';
import { analyzeAudio } from './ai-tagging';
import * as fs from 'fs';
import * as path from 'path';

export async function processAudio(
  filePath: string,
  metadata: {
    originalFilename: string;
    contentType: string;
    size: number;
    uploadedBy: number;
  }
): Promise<Asset> {
  try {
    // Generate unique ID for asset
    const assetId = `audio-${Date.now()}-${Math.random().toString(36).substring(2, 15)}`;

    // Analyze audio file
    const audioAnalysis = await analyzeAudio(filePath);

    // Create asset record
    const asset = await storage.createAsset({
      id: assetId,
      type: AssetType.AUDIO,
      originalFilename: metadata.originalFilename,
      contentType: metadata.contentType,
      size: metadata.size,
      hash: await generateFileHash(filePath),
      path: `assets/audio/${assetId}`,
      metadata: {
        ...audioAnalysis,
        duration: audioAnalysis.duration,
        sampleRate: audioAnalysis.sampleRate,
        channels: audioAnalysis.channels,
        bitDepth: audioAnalysis.bitDepth
      },
      versions: [],
      uploadedBy: metadata.uploadedBy,
      createdAt: new Date(),
      updatedAt: new Date()
    });

    // Move file to permanent storage
    const destinationPath = path.join(process.env.STORAGE_PATH || 'storage', `assets/audio/${assetId}`);
    await fs.promises.mkdir(path.dirname(destinationPath), { recursive: true });
    await fs.promises.copyFile(filePath, destinationPath);

    // Clean up temporary file
    await fs.promises.unlink(filePath);

    // Create additional versions asynchronously
    processAudioVersions(asset).catch(console.error);

    return asset;
  } catch (error) {
    console.error('Audio processing error:', error);
    throw new Error('Failed to process audio file');
  }
}

async function generateFileHash(filePath: string): Promise<string> {
  // Implementation of file hashing using crypto module
  // ...
}

async function processAudioVersions(asset: Asset): Promise<void> {
  // Generate streamable versions, waveforms, etc.
  // ...
}
```

### Integration Points

The Content Management System integrates with several other system components:

1. **Distribution System**
   - Provides assets for distribution to platforms
   - Receives platform-specific requirements
   - Generates necessary delivery formats

2. **Rights Management**
   - Links assets to ownership records
   - Enforces rights-based access control
   - Provides proof of ownership for disputes

3. **Analytics System**
   - Tracks asset usage metrics
   - Provides content performance analytics
   - Identifies popular content for optimization

4. **User Management**
   - Enforces user-specific access controls
   - Tracks user content quotas
   - Manages team collaboration on assets

### Best Practices for Development

1. **Asset Handling**
   - Always use provided APIs for asset operations
   - Never store file paths directly in application logic
   - Handle processing errors gracefully
   - Implement retry mechanisms for transient failures

2. **Performance Optimization**
   - Use streaming APIs for large file operations
   - Implement pagination for asset listing
   - Request only needed fields and versions
   - Utilize caching headers for client optimization

3. **Security Considerations**
   - Validate all file inputs for format and content
   - Sanitize metadata to prevent injection attacks
   - Apply least-privilege principles for asset operations
   - Implement rate limiting for upload operations

*© 2025 TuneMantra. All rights reserved.*

---

#### 2025-03-01: TuneMantra Documentation Index
_Source: unified_documentation/technical/temp-3march-documentation-index.md (Branch: temp)_


Welcome to TuneMantra's comprehensive documentation. Use this index to navigate to specific documentation sections based on your role and needs.

### 01-Overview

* [Project Overview](project-overview.md) - Complete platform description and capabilities
* [Documentation Plan](documentation-plan.md) - Documentation organization and roadmap
* [Project Status](project-status.md) - Current development status and timeline

### 02-User Guides

#### General Guides

* [Getting Started](../02-user-guides/getting-started.md) - Initial platform setup and usage
* [Release Management](../02-user-guides/release-management.md) - Managing music releases
* [Distribution Guide](../02-user-guides/distribution-guide.md) - Music distribution process
* [Analytics Guide](../02-user-guides/analytics-guide.md) - Understanding performance metrics
* [Royalty Management](../02-user-guides/royalty-management.md) - Revenue tracking and payments
* [Troubleshooting](../02-user-guides/troubleshooting.md) - Solving common issues

#### Artist-Specific Guides

* [Artist Guide](../02-user-guides/artists/artist-guide.md) - Complete guide for artists
* [Uploading Music](../02-user-guides/artists/uploading-music.md) - How to upload tracks
* [Managing Releases](../02-user-guides/artists/managing-releases.md) - Artist release management
* [Monetization Guide](../02-user-guides/artists/monetization.md) - Maximizing artist revenue

#### Label-Specific Guides

* [Label Guide](../02-user-guides/labels/label-guide.md) - Complete guide for label managers
* [Artist Management](../02-user-guides/labels/artist-management.md) - Managing your artist roster
* [Royalty Management](../02-user-guides/labels/royalty-management.md) - Label royalty administration

### 03-Technical Documentation

#### API Documentation

* [API Reference](../03-technical/api/api-reference.md) - Complete API documentation
* [Authentication](../03-technical/api/authentication.md) - API security and access
* [User Endpoints](../03-technical/api/endpoints/users.md) - User management API
* [Release Endpoints](../03-technical/api/endpoints/releases.md) - Release management API

#### Architecture

* [Architecture Guide](../03-technical/architecture/architecture-guide.md) - System architecture
* [Components](../03-technical/architecture/components.md) - Component details
* [System Overview](../03-technical/architecture/diagrams/system-overview.md) - Architecture diagrams

#### Database

* [Schema Reference](../03-technical/database/schema-reference.md) - Database schema
* [Migrations](../03-technical/database/migrations.md) - Database migration procedures

#### System Modules

* [Distribution System](../03-technical/distribution-system.md) - Platform delivery infrastructure
* [Analytics System](../03-technical/analytics-system.md) - Data collection and analytics
* [User Management](../03-technical/user-management.md) - Account management system
* [Content Management](../03-technical/content-management.md) - Music asset management
* [Rights Management](../03-technical/rights-management.md) - Ownership and licensing
* [Royalty Processing](../03-technical/royalty-processing.md) - Financial calculations and processing

### 04-Business Documentation

* [Executive Overview](../04-business/executive-overview.md) - High-level summary for executives
* [Competitive Advantage](../04-business/competitive-advantage.md) - Market differentiation
* [ROI & Business Case](../04-business/roi-business-case.md) - Financial models and ROI
* [Implementation Strategy](../04-business/implementation-strategy.md) - Platform adoption approach
* [White Label Guide](../04-business/white-label-guide.md) - Branding and customization

### 05-Administrator Documentation

* [Admin Guide](../05-administrators/admin-guide.md) - Complete administrator's guide
* [Configuration](../05-administrators/configuration.md) - System configuration options
* [Deployment](../05-administrators/deployment.md) - Deployment processes
* [Security](../05-administrators/security.md) - Security practices and measures
* [Backup & Recovery](../05-administrators/backup-recovery.md) - Data protection
* [Monitoring](../05-administrators/monitoring.md) - System monitoring and maintenance

### 06-Development Documentation

* [Developer Guide](../06-development/developer-guide.md) - Complete guide for developers
* [Getting Started](../06-development/setup/getting-started.md) - Initial development setup
* [Installation](../06-development/setup/installation.md) - Detailed installation steps
* [Coding Standards](../06-development/guidelines/coding-standards.md) - Code style guide
* [Testing Guidelines](../06-development/guidelines/testing-guidelines.md) - Testing approach
* [Contribution Workflow](../06-development/guidelines/contribution-workflow.md) - How to contribute

### Documentation By Role

#### For Artists
* [Artist Guide](../02-user-guides/artists/artist-guide.md)
* [Uploading Music](../02-user-guides/artists/uploading-music.md)
* [Managing Releases](../02-user-guides/artists/managing-releases.md)
* [Monetization Guide](../02-user-guides/artists/monetization.md)

#### For Label Managers
* [Label Guide](../02-user-guides/labels/label-guide.md)
* [Artist Management](../02-user-guides/labels/artist-management.md)
* [Royalty Management](../02-user-guides/labels/royalty-management.md)

#### For Developers
* [Developer Guide](../06-development/developer-guide.md)
* [API Reference](../03-technical/api/api-reference.md)
* [Architecture Guide](../03-technical/architecture/architecture-guide.md)

#### For Business Executives
* [Executive Overview](../04-business/executive-overview.md)
* [Competitive Advantage](../04-business/competitive-advantage.md)
* [ROI & Business Case](../04-business/roi-business-case.md)

#### For System Administrators
* [Admin Guide](../05-administrators/admin-guide.md)
* [Deployment](../05-administrators/deployment.md)
* [Security](../05-administrators/security.md)

*© 2025 TuneMantra. All rights reserved.*

---

#### 2025-03-01: TuneMantra Project Status
_Source: unified_documentation/technical/temp-3march-project-status.md (Branch: temp)_


### Current Status (As of March 19, 2025)

TuneMantra is currently in active development with the following overall completion status:

| Component | Completion % | Status |
|-----------|--------------|--------|
| Core Platform | 85% | ⬤⬤⬤⬤◯ |
| Distribution System | 90% | ⬤⬤⬤⬤⬤ |
| Analytics Engine | 75% | ⬤⬤⬤⬤◯ |
| Royalty Management | 80% | ⬤⬤⬤⬤◯ |
| API & Integrations | 70% | ⬤⬤⬤◯◯ |
| Documentation | 85% | ⬤⬤⬤⬤◯ |
| Mobile Applications | 35% | ⬤⬤◯◯◯ |

### Recent Milestones

- **March 15, 2025**: Documentation reorganization complete
- **March 10, 2025**: Advanced analytics dashboard released
- **March 3, 2025**: Distribution system upgrade with 15 new platforms
- **February 25, 2025**: Platform-wide performance optimization (+40% speed)
- **February 18, 2025**: Rights management system enhancements

### Component Status Details

#### Core Platform

- **Authentication System**: 100% Complete
- **User Management**: 100% Complete
- **Role-Based Access Control**: 90% Complete
- **White Label Customization**: 70% Complete
- **Team Collaboration Tools**: 65% Complete

#### Distribution System

- **Platform Connections**: 95% Complete (150+ platforms)
- **Metadata Editor**: 100% Complete
- **Release Scheduling**: 100% Complete
- **Automated Delivery**: 85% Complete
- **Error Handling & Recovery**: 70% Complete

#### Analytics Engine

- **Performance Dashboard**: 90% Complete
- **Revenue Analytics**: 80% Complete
- **Audience Insights**: 70% Complete
- **Trend Analysis**: 60% Complete
- **Custom Reports**: 50% Complete

#### Royalty Management

- **Revenue Tracking**: 90% Complete
- **Split Payments**: 85% Complete
- **Tax Management**: 75% Complete
- **Payment Processing**: 80% Complete
- **Statement Generation**: 70% Complete

#### API & Integrations

- **Core API**: 85% Complete
- **SDK Development**: 60% Complete
- **Webhook System**: 75% Complete
- **Third-Party Integrations**: 65% Complete
- **Documentation**: 80% Complete

#### Documentation

- **User Documentation**: 85% Complete
- **Developer Documentation**: 80% Complete
- **API Reference**: 90% Complete
- **Tutorials & Guides**: 75% Complete
- **Knowledge Base**: 70% Complete

#### Mobile Applications

- **iOS Development**: 45% Complete
- **Android Development**: 40% Complete
- **Cross-Platform Framework**: 50% Complete
- **Mobile-Specific Features**: 30% Complete
- **Testing & Optimization**: 10% Complete

### Current Sprint Focus

The development team is currently focused on:

1. Completing the royalty distribution automation
2. Enhancing the analytics dashboard with predictive insights
3. Improving platform stability and error handling
4. Expanding API capabilities for third-party integrations
5. Continuing mobile application development

### Upcoming Releases

| Release | Target Date | Key Features |
|---------|-------------|--------------|
| v1.8.0 | April 5, 2025 | Advanced royalty splitting, enhanced analytics |
| v1.9.0 | April 26, 2025 | AI-powered metadata suggestions, advanced search |
| v2.0.0 | May 15, 2025 | Complete platform redesign, performance optimizations |
| Mobile Beta | June 10, 2025 | First beta release of iOS and Android applications |

### Known Issues

1. Analytics dashboard occasionally shows delayed data (Fix: April 5)
2. Royalty calculations may require manual verification for complex splits (Fix: April 12)
3. Some metadata fields not propagating to all platforms (Fix: March 24)
4. PDF statement generation sometimes times out for large catalogs (Fix: March 30)

### Feedback & Contribution

We welcome feedback on the platform's development. Please submit issues and feature requests through:

- Email: feedback@tunemantra.com
- User Dashboard: Feedback tab
- Developer Portal: Issue tracker

*© 2025 TuneMantra. All rights reserved.*

---

#### 2025-03-01: Rights Management System
_Source: unified_documentation/technical/temp-3march-rights-management.md (Branch: temp)_


### Overview

The TuneMantra Rights Management System provides comprehensive infrastructure for tracking, managing, and enforcing ownership rights, royalty splits, and licensing for music assets. This document provides technical details for developers and system integrators.

### System Architecture

The Rights Management System consists of several interconnected components:

#### 1. Rights Registry

**Purpose**: Core system for recording and tracking ownership rights.

**Implementation**:
- Immutable record storage with blockchain-based verification
- Hierarchical rights model (master rights, publishing rights, etc.)
- Version history for tracking rights changes
- Rights conflict detection and resolution

**Key Files**:
- `shared/schema.ts` - Rights-related schemas
- `server/services/rights-management.ts` - Core implementation
- `server/utils/rights-verification.ts` - Verification utilities

#### 2. Split Management Engine

**Purpose**: Manages percentage-based ownership allocations and calculations.

**Implementation**:
- Decimal-precise calculations for revenue shares
- Support for multi-level split hierarchies
- Validation to ensure splits always total 100%
- Templates for common split configurations

**Key Files**:
- `shared/schema.ts` - Split schema definitions
- `server/services/split-calculator.ts` - Split calculation logic
- `server/utils/share-math.ts` - Mathematical utilities

#### 3. Licensing Management

**Purpose**: Handles creation, tracking, and enforcement of content licenses.

**Implementation**:
- License template system
- License verification API
- Usage tracking
- Term and territory management
- Revocation mechanisms

**Key Files**:
- `shared/schema.ts` - License model definitions
- `server/services/licensing.ts` - Licensing core logic
- `server/utils/license-generator.ts` - License document generation

#### 4. Rights Verification Service

**Purpose**: Validates rights claims and resolves conflicts.

**Implementation**:
- Digital signature verification
- Chain-of-rights validation
- Ownership conflict resolution
- External registry integration (PROs, CMOs, etc.)

**Key Files**:
- `server/services/rights-verification.ts` - Verification logic
- `server/utils/digital-signatures.ts` - Cryptographic utilities
- `server/services/external-registry.ts` - External system integration

### Data Models

#### Rights Holder Model

```typescript
export interface RightsHolder {
  id: number;
  name: string;
  type: RightsHolderType;
  taxId?: string;
  contactInfo: ContactInfo;
  bankingInfo?: BankingInfo;
  ipiNumber?: string;
  isniNumber?: string;
  createdAt: Date;
  updatedAt: Date;
}

export enum RightsHolderType {
  INDIVIDUAL = 'individual',
  COMPANY = 'company',
  ORGANIZATION = 'organization'
}

export interface ContactInfo {
  email: string;
  phone?: string;
  address?: Address;
}

export interface BankingInfo {
  accountName: string;
  routingNumber: string;
  accountNumber: string;
  bankName: string;
  currency: string;
}
```

#### Rights Model

```typescript
export interface Rights {
  id: number;
  assetId: string;
  rightType: RightType;
  territory: string[];
  term: Term;
  exclusivity: ExclusivityType;
  holders: RightsShare[];
  parentRightId?: number;
  documentation: DocumentReference[];
  status: RightsStatus;
  createdAt: Date;
  updatedAt: Date;
}

export enum RightType {
  MASTER = 'master',
  PUBLISHING = 'publishing',
  PERFORMANCE = 'performance',
  SYNC = 'sync',
  MECHANICAL = 'mechanical',
  NEIGHBORING = 'neighboring'
}

export interface Term {
  startDate: Date;
  endDate?: Date;
  isPerpetual: boolean;
}

export enum ExclusivityType {
  EXCLUSIVE = 'exclusive',
  NON_EXCLUSIVE = 'non_exclusive',
  SOLE = 'sole'
}

export interface RightsShare {
  holderId: number;
  sharePercentage: number;
  role: string;
}

export enum RightsStatus {
  ACTIVE = 'active',
  PENDING = 'pending',
  DISPUTED = 'disputed',
  EXPIRED = 'expired',
  TERMINATED = 'terminated'
}

export interface DocumentReference {
  id: string;
  type: DocumentType;
  name: string;
  url: string;
  hash: string;
  uploadedAt: Date;
}

export enum DocumentType {
  CONTRACT = 'contract',
  LICENSE = 'license',
  ASSIGNMENT = 'assignment',
  CERTIFICATE = 'certificate',
  OTHER = 'other'
}
```

#### License Model

```typescript
export interface License {
  id: number;
  name: string;
  licensorId: number;
  licenseeId: number;
  assetIds: string[];
  rightTypes: RightType[];
  territory: string[];
  term: Term;
  exclusivity: ExclusivityType;
  usageRestrictions: UsageRestriction[];
  royaltyTerms?: RoyaltyTerms;
  flatFee?: FlatFee;
  status: LicenseStatus;
  createdAt: Date;
  updatedAt: Date;
}

export interface UsageRestriction {
  type: UsageType;
  limitation: string;
}

export enum UsageType {
  COMMERCIAL = 'commercial',
  PROMOTIONAL = 'promotional',
  STREAMING = 'streaming',
  DOWNLOAD = 'download',
  PUBLIC_PERFORMANCE = 'public_performance',
  BROADCAST = 'broadcast',
  SYNC = 'sync'
}

export interface RoyaltyTerms {
  percentage: number;
  calculationBasis: CalculationBasis;
  minimumAmount?: number;
  currency: string;
  paymentFrequency: PaymentFrequency;
}

export enum CalculationBasis {
  GROSS_REVENUE = 'gross_revenue',
  NET_REVENUE = 'net_revenue',
  WHOLESALE_PRICE = 'wholesale_price',
  RETAIL_PRICE = 'retail_price',
  PER_UNIT = 'per_unit'
}

export enum PaymentFrequency {
  MONTHLY = 'monthly',
  QUARTERLY = 'quarterly',
  SEMI_ANNUALLY = 'semi_annually',
  ANNUALLY = 'annually'
}

export interface FlatFee {
  amount: number;
  currency: string;
  isPaid: boolean;
  paymentDate?: Date;
}

export enum LicenseStatus {
  DRAFT = 'draft',
  ACTIVE = 'active',
  EXPIRED = 'expired',
  TERMINATED = 'terminated',
  PENDING = 'pending'
}
```

### Core Workflows

#### Rights Registration Workflow

1. **Rights Claim Submission**
   - User submits rights claim with documentation
   - System validates required information
   - Digital signatures are collected from all parties

2. **Verification Process**
   - Documentation is analyzed and verified
   - Conflicts with existing rights are identified
   - External registries are checked if needed

3. **Rights Registration**
   - Rights record is created with verified status
   - Splits are recorded for all rights holders
   - Notifications are sent to all stakeholders

4. **Publication**
   - Rights information is published to catalog
   - Relevant distribution platforms are notified
   - Verification proof is generated

#### Splits Management Workflow

1. **Split Definition**
   - Primary rights holder defines initial splits
   - System validates total equals 100%
   - Split proposal is generated

2. **Stakeholder Approval**
   - All parties receive split proposals
   - Digital signatures are collected
   - Disputes can be raised during this phase

3. **Split Activation**
   - Approved splits are activated in the system
   - Linked to corresponding rights records
   - Used for royalty calculations moving forward

#### License Creation Workflow

1. **License Initiation**
   - License creator defines terms
   - Template selection or custom terms
   - System validates against rights ownership

2. **Terms Negotiation**
   - Proposed terms shared with licensee
   - Revisions tracked and versioned
   - Comments and change requests managed

3. **License Execution**
   - Both parties digitally sign agreement
   - License record created in system
   - Terms activated for enforcement

4. **Usage Tracking**
   - System monitors license conditions
   - Usage reports collected and verified
   - Compliance monitoring

### API Reference

#### Rights API

##### Register Rights

```
POST /api/rights
Content-Type: application/json

Request Body:
{
  "assetId": "asset-123",
  "rightType": "master",
  "territory": ["worldwide"],
  "term": {
    "startDate": "2025-01-01T00:00:00Z",
    "isPerpetual": true
  },
  "exclusivity": "exclusive",
  "holders": [
    {
      "holderId": 101,
      "sharePercentage": 75,
      "role": "primary_artist"
    },
    {
      "holderId": 102,
      "sharePercentage": 25,
      "role": "producer"
    }
  ],
  "documentation": [
    {
      "id": "doc-456",
      "type": "contract",
      "name": "Recording Agreement",
      "url": "https://storage.tunemantra.com/documents/doc-456",
      "hash": "sha256:def456..."
    }
  ]
}
```

##### Get Rights for Asset

```
GET /api/assets/:assetId/rights

Response:
{
  "rights": [
    {
      "id": 789,
      "assetId": "asset-123",
      "rightType": "master",
      "territory": ["worldwide"],
      "term": {
        "startDate": "2025-01-01T00:00:00Z",
        "isPerpetual": true
      },
      "exclusivity": "exclusive",
      "holders": [...],
      "documentation": [...],
      "status": "active",
      "createdAt": "2025-01-15T12:34:56Z",
      "updatedAt": "2025-01-15T12:34:56Z"
    },
    // Other rights records...
  ]
}
```

##### Update Rights Shares

```
PATCH /api/rights/:rightId/shares
Content-Type: application/json

Request Body:
{
  "holders": [
    {
      "holderId": 101,
      "sharePercentage": 70,
      "role": "primary_artist"
    },
    {
      "holderId": 102,
      "sharePercentage": 20,
      "role": "producer"
    },
    {
      "holderId": 103,
      "sharePercentage": 10,
      "role": "songwriter"
    }
  ]
}
```

#### Licensing API

##### Create License

```
POST /api/licenses
Content-Type: application/json

Request Body:
{
  "name": "Streaming License for Summer EP",
  "licensorId": 101,
  "licenseeId": 501,
  "assetIds": ["asset-123", "asset-124", "asset-125"],
  "rightTypes": ["performance", "mechanical"],
  "territory": ["US", "CA", "MX"],
  "term": {
    "startDate": "2025-03-01T00:00:00Z",
    "endDate": "2026-03-01T00:00:00Z",
    "isPerpetual": false
  },
  "exclusivity": "non_exclusive",
  "usageRestrictions": [
    {
      "type": "streaming",
      "limitation": "subscription services only"
    }
  ],
  "royaltyTerms": {
    "percentage": 15,
    "calculationBasis": "net_revenue",
    "minimumAmount": 1000,
    "currency": "USD",
    "paymentFrequency": "quarterly"
  }
}
```

##### Verify License

```
GET /api/licenses/verify
Content-Type: application/json

Request Parameters:
- licenseId: ID of license to verify
- assetId: ID of asset being used
- usageType: Type of usage being performed

Response:
{
  "isValid": true,
  "license": {
    "id": 789,
    "name": "Streaming License for Summer EP",
    // Full license details...
  },
  "limitations": [
    {
      "type": "streaming",
      "limitation": "subscription services only"
    }
  ],
  "expirationDate": "2026-03-01T00:00:00Z"
}
```

### Security

The Rights Management System implements several security measures:

1. **Cryptographic Verification**
   - Digital signatures for all rights claims
   - Hash verification for all documents
   - Secure key management for signatures

2. **Access Control**
   - Role-based access to rights information
   - Owner-only access to sensitive contract details
   - Granular permissions for rights operations

3. **Audit Trail**
   - Complete history of all rights changes
   - Immutable record of rights transfers
   - Cryptographically secured audit logs
   - Timestamped events

4. **Fraud Prevention**
   - Conflict detection algorithms
   - Duplicate claim identification
   - Suspicious pattern recognition
   - External registry verification

### Integration with External Systems

The Rights Management System integrates with several external systems:

1. **Performing Rights Organizations (PROs)**
   - Rights registration sync
   - Work code management
   - Automated reporting
   - Catalog verification

2. **Collection Management Organizations (CMOs)**
   - International rights representation
   - Collection management
   - Cross-border compliance

3. **Industry Databases**
   - ISRC/ISWC code management
   - Global repertoire databases
   - Authoritative ownership records

4. **Rights Blockchain Networks**
   - Optional blockchain anchoring
   - Decentralized verification
   - Public proof of registration

### Implementation Examples

#### Rights Registration Implementation

```typescript
// In server/services/rights-management.ts

import { Rights, RightType, RightsStatus } from '@shared/schema';
import { storage } from '../storage';
import { verifyDocumentation } from '../utils/rights-verification';
import { validateShares } from '../utils/share-math';

export async function registerRights(rightsData: Omit<Rights, 'id' | 'status' | 'createdAt' | 'updatedAt'>): Promise<Rights> {
  try {
    // Validate share percentages total 100%
    const validShares = validateShares(rightsData.holders);
    if (!validShares) {
      throw new Error('Share percentages must equal 100%');
    }

    // Verify documentation is valid
    const documentationValid = await verifyDocumentation(rightsData.documentation);
    if (!documentationValid) {
      throw new Error('Rights documentation failed verification');
    }

    // Check for conflicts with existing rights
    const conflicts = await checkRightsConflicts(rightsData.assetId, rightsData.rightType);
    if (conflicts.length > 0) {
      // Handle conflicts based on policy (could create as disputed)
      throw new Error(`Rights conflict detected with existing rights: ${conflicts.map(r => r.id).join(', ')}`);
    }

    // Create rights record
    const rights = await storage.createRights({
      ...rightsData,
      status: RightsStatus.ACTIVE,
      createdAt: new Date(),
      updatedAt: new Date()
    });

    // Notify all rights holders
    await notifyRightsHolders(rights);

    // Optionally register with external systems
    await registerWithExternalSystems(rights);

    return rights;
  } catch (error) {
    console.error('Rights registration error:', error);
    throw new Error(`Failed to register rights: ${error.message}`);
  }
}

async function checkRightsConflicts(assetId: string, rightType: RightType): Promise<Rights[]> {
  // Implementation to find conflicting rights records
  // ...
}

async function notifyRightsHolders(rights: Rights): Promise<void> {
  // Implementation to notify all stakeholders
  // ...
}

async function registerWithExternalSystems(rights: Rights): Promise<void> {
  // Implementation to register with PROs, etc.
  // ...
}
```

#### Split Calculation Implementation

```typescript
// In server/utils/share-math.ts

import { RightsShare } from '@shared/schema';
import Decimal from 'decimal.js';

/**
 * Validates that share percentages add up to exactly 100%
 */
export function validateShares(shares: RightsShare[]): boolean {
  if (shares.length === 0) {
    return false;
  }

  const total = shares.reduce((sum, share) => {
    return sum.plus(new Decimal(share.sharePercentage));
  }, new Decimal(0));

  return total.equals(100);
}

/**
 * Calculates royalty amount based on shares
 */
export function calculateRoyaltyShares(
  totalAmount: number,
  shares: RightsShare[]
): Map<number, number> {
  const result = new Map<number, number>();

  if (!validateShares(shares)) {
    throw new Error('Invalid shares: percentages must equal 100%');
  }

  const totalDecimal = new Decimal(totalAmount);

  // Calculate each holder's share with high precision
  for (const share of shares) {
    const percentage = new Decimal(share.sharePercentage).dividedBy(100);
    const amount = totalDecimal.times(percentage);

    result.set(share.holderId, amount.toDecimalPlaces(2).toNumber());
  }

  // Adjust for rounding errors to ensure sum equals total
  const calculatedTotal = Array.from(result.values()).reduce((sum, amount) => sum + amount, 0);
  const difference = totalAmount - calculatedTotal;

  if (Math.abs(difference) > 0.01) {
    // Find holder with largest share to adjust
    const largestShareHolder = shares.reduce((max, share) => 
      share.sharePercentage > max.sharePercentage ? share : max
    );

    const currentAmount = result.get(largestShareHolder.holderId) || 0;
    result.set(largestShareHolder.holderId, currentAmount + difference);
  }

  return result;
}
```

### Performance Considerations

The Rights Management System is optimized for the following scenarios:

1. **High-Volume Rights Processing**
   - Batch processing for bulk imports
   - Caching of frequently accessed rights data
   - Optimized database queries for rights lookups

2. **Real-time License Verification**
   - In-memory caching of active licenses
   - Optimized verification algorithms
   - Response time under 100ms for verification requests

3. **Data Consistency**
   - Transaction-based updates for atomic operations
   - Eventual consistency for distributed operations
   - Conflict resolution with clear precedence rules

### Compliance and Regulatory Considerations

The system is designed to comply with global rights management standards:

1. **Copyright Regulations**
   - Territory-specific copyright terms
   - Statutory license compliance
   - Public domain identification
   - Orphan works handling

2. **Data Privacy**
   - GDPR compliance for personal information
   - Data minimization principles
   - Secure handling of sensitive information
   - Right to access/delete personal data

3. **Financial Regulations**
   - Tax withholding integration
   - Currency conversion compliance
   - Financial reporting requirements
   - Audit-ready record keeping

### Development Guidelines

When working with the Rights Management System, developers should follow these guidelines:

1. **Data Integrity**
   - Never bypass the rights API for direct database updates
   - Always validate share percentages sum to 100%
   - Maintain immutable history of all rights changes
   - Enforce proper digital signatures for all modifications

2. **Security Practices**
   - Follow secure coding practices for all rights operations
   - Implement proper access controls for all endpoints
   - Validate all inputs thoroughly
   - Log all rights operations for audit purposes

3. **Integration Best Practices**
   - Use rights verification API before content usage
   - Subscribe to rights change notifications
   - Implement proper error handling for rights conflicts
   - Maintain local caches of frequently used rights data

*© 2025 TuneMantra. All rights reserved.*

---

#### 2025-03-01: Royalty Processing System
_Source: unified_documentation/technical/temp-3march-royalty-processing.md (Branch: temp)_


### Overview

The TuneMantra Royalty Processing System handles the calculation, tracking, and distribution of royalties across the platform. This document provides technical details for developers and system integrators working with the royalty infrastructure.

### System Architecture

The Royalty Processing System consists of several integrated components:

#### 1. Revenue Collection Engine

**Purpose**: Collects and normalizes revenue data from various platforms and sources.

**Implementation**:
- Multi-platform data connectors
- Revenue data normalization
- Currency conversion
- Validation and reconciliation
- Data storage and historical tracking

**Key Files**:
- `server/services/revenue-collection.ts` - Core implementation
- `server/utils/platform-adapters/` - Platform-specific adapters
- `server/services/currency-converter.ts` - Currency handling

#### 2. Royalty Calculation Engine

**Purpose**: Calculates royalty amounts based on rights ownership and contract terms.

**Implementation**:
- High-precision decimal math
- Contract term interpretation
- Split calculation with validation
- Multi-tier distribution support
- Configurable calculation rules

**Key Files**:
- `server/services/royalty-calculator.ts` - Core calculation logic
- `server/utils/share-math.ts` - Mathematical utilities
- `server/services/contract-interpreter.ts` - Contract term processing

#### 3. Payment Processing Engine

**Purpose**: Manages the actual disbursement of funds to rights holders.

**Implementation**:
- Multiple payment method support
- Payment batching
- Tax withholding
- Payment verification
- Receipt generation
- Failure handling

**Key Files**:
- `server/services/payment-processor.ts` - Payment processing
- `server/services/tax-engine.ts` - Tax calculation and withholding
- `server/utils/receipt-generator.ts` - Receipt document generation

#### 4. Reporting Engine

**Purpose**: Generates detailed statements and analytics on royalty earnings.

**Implementation**:
- Customizable statement generation
- Real-time analytics
- Historical trend analysis
- Projection modeling
- Export in multiple formats

**Key Files**:
- `server/services/statement-generator.ts` - Statement generation
- `server/services/royalty-analytics.ts` - Analytics processing
- `server/utils/report-formatter.ts` - Output formatting

### Data Models

#### Revenue Record Model

```typescript
export interface RevenueRecord {
  id: string;
  source: RevenueSource;
  platformId: string;
  assetId: string;
  period: {
    startDate: Date;
    endDate: Date;
  };
  amount: number;
  currency: string;
  exchangeRate: number;
  amountUSD: number;
  units: number;
  unitType: UnitType;
  territory: string;
  metadata: RevenueMetadata;
  status: RevenueStatus;
  createdAt: Date;
  updatedAt: Date;
}

export interface RevenueSource {
  name: string;
  type: RevenueSourceType;
  platform: string;
}

export enum RevenueSourceType {
  STREAMING = 'streaming',
  DOWNLOAD = 'download',
  SYNC = 'sync',
  PERFORMANCE = 'performance',
  MECHANICAL = 'mechanical',
  OTHER = 'other'
}

export enum UnitType {
  STREAM = 'stream',
  DOWNLOAD = 'download',
  SUBSCRIPTION = 'subscription',
  LICENSE = 'license',
  PLAY = 'play',
  VIEW = 'view'
}

export interface RevenueMetadata {
  tierType?: string;
  promotionId?: string;
  dealId?: string;
  playlistId?: string;
  additionalInfo?: Record<string, any>;
}

export enum RevenueStatus {
  PENDING = 'pending',
  VERIFIED = 'verified',
  PROCESSED = 'processed',
  DISPUTED = 'disputed',
  ADJUSTED = 'adjusted'
}
```

#### Royalty Transaction Model

```typescript
export interface RoyaltyTransaction {
  id: string;
  revenueRecordIds: string[];
  rightId: number;
  holderId: number;
  sharePercentage: number;
  grossAmount: number;
  deductions: Deduction[];
  netAmount: number;
  currency: string;
  status: RoyaltyStatus;
  batchId?: string;
  periodId: string;
  createdAt: Date;
  processedAt?: Date;
}

export interface Deduction {
  type: DeductionType;
  description: string;
  amount: number;
  percentage?: number;
}

export enum DeductionType {
  PLATFORM_FEE = 'platform_fee',
  DISTRIBUTION_FEE = 'distribution_fee',
  PROCESSING_FEE = 'processing_fee',
  TAX_WITHHOLDING = 'tax_withholding',
  RECOUPMENT = 'recoupment',
  ADVANCE_RECOVERY = 'advance_recovery',
  OTHER = 'other'
}

export enum RoyaltyStatus {
  CALCULATED = 'calculated',
  PENDING_PAYMENT = 'pending_payment',
  PAID = 'paid',
  FAILED = 'failed',
  ON_HOLD = 'on_hold',
  REJECTED = 'rejected'
}
```

#### Payment Model

```typescript
export interface Payment {
  id: string;
  batchId: string;
  royaltyTransactionIds: string[];
  recipientId: number;
  amount: number;
  currency: string;
  method: PaymentMethod;
  status: PaymentStatus;
  reference?: string;
  notes?: string;
  taxWithheld?: number;
  taxDocuments?: string[];
  processedAt?: Date;
  createdAt: Date;
  updatedAt: Date;
}

export interface PaymentMethod {
  type: PaymentType;
  accountId: string;
  processorId?: string;
}

export enum PaymentType {
  BANK_TRANSFER = 'bank_transfer',
  PAYPAL = 'paypal',
  CHECK = 'check',
  INTERNAL = 'internal',
  CRYPTOCURRENCY = 'cryptocurrency',
  OTHER = 'other'
}

export enum PaymentStatus {
  PENDING = 'pending',
  PROCESSING = 'processing',
  COMPLETED = 'completed',
  FAILED = 'failed',
  CANCELLED = 'cancelled',
  REFUNDED = 'refunded'
}
```

#### Statement Model

```typescript
export interface Statement {
  id: string;
  holderId: number;
  periodId: string;
  period: {
    startDate: Date;
    endDate: Date;
  };
  transactions: RoyaltyTransaction[];
  summary: StatementSummary;
  generatedAt: Date;
  viewedAt?: Date;
  status: StatementStatus;
}

export interface StatementSummary {
  totalGrossAmount: number;
  totalDeductions: number;
  totalNetAmount: number;
  currency: string;
  totalUnits: number;
  assetCount: number;
  platformCount: number;
  territoryCount: number;
  topAssets: Array<{assetId: string, amount: number}>;
  topTerritories: Array<{territory: string, amount: number}>;
  topPlatforms: Array<{platform: string, amount: number}>;
}

export enum StatementStatus {
  DRAFT = 'draft',
  PUBLISHED = 'published',
  ARCHIVED = 'archived'
}
```

### Core Workflows

#### Revenue Collection Workflow

1. **Data Ingestion**
   - Platform data is collected via API or file import
   - Revenue data is normalized to standard format
   - Currency conversion to normalized currency (USD)
   - Initial validation checks performed

2. **Data Reconciliation**
   - Cross-platform data is matched and compared
   - Anomaly detection identifies potential issues
   - Missing data is flagged for follow-up
   - Data conflicts are marked for resolution

3. **Revenue Record Creation**
   - Validated data creates revenue records
   - Assets are linked to specific revenue
   - Territorial information is preserved
   - Metadata enhanced for reporting

#### Royalty Calculation Workflow

1. **Rights Identification**
   - System identifies rights holders for each asset
   - Rights type is matched to revenue source
   - Territorial restrictions are applied
   - Effective date ranges are validated

2. **Contract Application**
   - Contract terms are retrieved for each rights holder
   - Applicable rates and minimums are determined
   - Special terms are applied (e.g., escalations)
   - Advances and recoupments are considered

3. **Split Calculation**
   - Shares are calculated based on rights percentages
   - Multi-tier splits are processed hierarchically
   - High-precision math ensures accuracy
   - Rounding adjustments maintain total integrity

4. **Transaction Creation**
   - Royalty transactions are created for each holder
   - Gross and net amounts are calculated
   - All deductions are itemized and tracked
   - Transactions are linked to source revenue

#### Payment Processing Workflow

1. **Payment Preparation**
   - Transactions grouped into payment batches
   - Minimum payment thresholds applied
   - Payment methods validated for each recipient
   - Tax withholding calculated as required

2. **Payment Execution**
   - Appropriate payment gateway selected
   - Funds transferred via selected method
   - Real-time status tracking
   - Receipt generation and delivery

3. **Payment Reconciliation**
   - Confirmation of successful payments
   - Failed payment handling and retry logic
   - Transaction status updates
   - Accounting system synchronization

#### Reporting Workflow

1. **Statement Generation**
   - Period-based statements assembled
   - Transaction details organized by source
   - Summary metrics calculated
   - Customized based on recipient preferences

2. **Analytics Processing**
   - Performance trends analyzed
   - Comparative metrics calculated
   - Forecasting models applied
   - Anomaly detection performed

3. **Distribution and Notification**
   - Statements delivered via preferred channel
   - Notifications sent to recipients
   - Access logging for compliance
   - Historical archive maintained

### API Reference

#### Revenue API

##### Upload Revenue Data

```
POST /api/revenue/batch
Content-Type: application/json

Request Body:
{
  "source": {
    "name": "Spotify",
    "type": "streaming",
    "platform": "spotify"
  },
  "period": {
    "startDate": "2025-01-01T00:00:00Z",
    "endDate": "2025-01-31T23:59:59Z"
  },
  "records": [
    {
      "assetId": "asset-123",
      "amount": 156.78,
      "currency": "USD",
      "units": 45678,
      "unitType": "stream",
      "territory": "US",
      "metadata": {
        "tierType": "premium",
        "playlistId": "spotify:playlist:123456"
      }
    },
    // Additional records...
  ]
}

Response:
{
  "batchId": "batch-789",
  "recordCount": 1,
  "status": "processing",
  "errors": []
}
```

##### Get Revenue Records

```
GET /api/revenue/records

Query Parameters:
- assetId: Filter by asset
- period.startDate: Start of period
- period.endDate: End of period
- source.platform: Platform name
- territory: Territory code

Response:
{
  "records": [
    {
      "id": "rev-123",
      "source": {
        "name": "Spotify",
        "type": "streaming",
        "platform": "spotify"
      },
      "platformId": "spotify-123",
      "assetId": "asset-123",
      "period": {
        "startDate": "2025-01-01T00:00:00Z",
        "endDate": "2025-01-31T23:59:59Z"
      },
      "amount": 156.78,
      "currency": "USD",
      "exchangeRate": 1,
      "amountUSD": 156.78,
      "units": 45678,
      "unitType": "stream",
      "territory": "US",
      "metadata": { ... },
      "status": "verified",
      "createdAt": "2025-02-05T12:34:56Z",
      "updatedAt": "2025-02-05T12:34:56Z"
    },
    // Additional records...
  ],
  "pagination": {
    "page": 1,
    "pageSize": 50,
    "totalRecords": 345,
    "totalPages": 7
  }
}
```

#### Royalties API

##### Calculate Royalties

```
POST /api/royalties/calculate
Content-Type: application/json

Request Body:
{
  "periodId": "2025-01",
  "period": {
    "startDate": "2025-01-01T00:00:00Z",
    "endDate": "2025-01-31T23:59:59Z"
  },
  "assetIds": ["asset-123", "asset-124"], // Optional, omit for all assets
  "holderIds": [101, 102], // Optional, omit for all holders
  "recalculate": false // If true, recalculates existing transactions
}

Response:
{
  "calculationId": "calc-456",
  "status": "processing",
  "totalRevenue": 9876.54,
  "assetCount": 2,
  "holderCount": 5,
  "estimatedCompletionTime": "2025-02-06T13:30:00Z"
}
```

##### Get Royalty Transactions

```
GET /api/royalties/transactions

Query Parameters:
- holderId: Filter by rights holder
- periodId: Filter by period
- status: Filter by status
- assetId: Filter by asset

Response:
{
  "transactions": [
    {
      "id": "rt-789",
      "revenueRecordIds": ["rev-123", "rev-124"],
      "rightId": 456,
      "holderId": 101,
      "sharePercentage": 75,
      "grossAmount": 117.59,
      "deductions": [
        {
          "type": "platform_fee",
          "description": "Platform service fee",
          "amount": 5.88,
          "percentage": 5
        }
      ],
      "netAmount": 111.71,
      "currency": "USD",
      "status": "calculated",
      "periodId": "2025-01",
      "createdAt": "2025-02-06T10:15:23Z"
    },
    // Additional transactions...
  ],
  "pagination": {
    "page": 1,
    "pageSize": 50,
    "totalRecords": 120,
    "totalPages": 3
  }
}
```

#### Payments API

##### Process Payments

```
POST /api/payments/process
Content-Type: application/json

Request Body:
{
  "batchId": "pay-batch-123",
  "description": "January 2025 Royalty Payments",
  "transactions": ["rt-789", "rt-790", "rt-791"],
  "options": {
    "minimumAmount": 50,
    "includeTaxWithholding": true,
    "skipExistingPaymentMethods": false
  }
}

Response:
{
  "batchId": "pay-batch-123",
  "status": "processing",
  "paymentsCreated": 2,
  "paymentsSkipped": 1,
  "totalAmount": 345.67,
  "currency": "USD",
  "estimatedCompletionTime": "2025-02-07T15:00:00Z"
}
```

##### Get Payment Status

```
GET /api/payments/batch/:batchId

Response:
{
  "batchId": "pay-batch-123",
  "description": "January 2025 Royalty Payments",
  "status": "completed",
  "payments": [
    {
      "id": "pay-456",
      "recipientId": 101,
      "amount": 235.45,
      "currency": "USD",
      "method": {
        "type": "bank_transfer",
        "accountId": "acc-789"
      },
      "status": "completed",
      "reference": "tx-abc123",
      "processedAt": "2025-02-07T14:23:12Z"
    },
    // Additional payments...
  ],
  "summary": {
    "total": 345.67,
    "completed": 345.67,
    "pending": 0,
    "failed": 0
  },
  "createdAt": "2025-02-07T13:45:00Z",
  "updatedAt": "2025-02-07T14:30:00Z"
}
```

#### Statements API

##### Generate Statements

```
POST /api/statements/generate
Content-Type: application/json

Request Body:
{
  "periodId": "2025-01",
  "holderIds": [101, 102], // Optional, omit for all holders
  "options": {
    "format": "pdf",
    "includeDetails": true,
    "sendEmail": true,
    "includeAnalytics": true
  }
}

Response:
{
  "batchId": "stmt-batch-123",
  "status": "processing",
  "statementsCount": 2,
  "periodId": "2025-01",
  "estimatedCompletionTime": "2025-02-08T10:30:00Z"
}
```

##### Get Statement

```
GET /api/statements/:statementId

Response:
{
  "id": "stmt-789",
  "holderId": 101,
  "periodId": "2025-01",
  "period": {
    "startDate": "2025-01-01T00:00:00Z",
    "endDate": "2025-01-31T23:59:59Z"
  },
  "summary": {
    "totalGrossAmount": 1234.56,
    "totalDeductions": 61.73,
    "totalNetAmount": 1172.83,
    "currency": "USD",
    "totalUnits": 358697,
    "assetCount": 12,
    "platformCount": 8,
    "territoryCount": 45,
    "topAssets": [
      {"assetId": "asset-123", "amount": 235.45},
      {"assetId": "asset-456", "amount": 187.32}
    ],
    "topTerritories": [
      {"territory": "US", "amount": 567.89},
      {"territory": "GB", "amount": 234.56}
    ],
    "topPlatforms": [
      {"platform": "spotify", "amount": 456.78},
      {"platform": "apple_music", "amount": 345.67}
    ]
  },
  "transactions": [
    // Transaction details...
  ],
  "status": "published",
  "generatedAt": "2025-02-08T09:15:23Z"
}
```

##### Download Statement

```
GET /api/statements/:statementId/download
Accept: application/pdf

Response: Binary PDF file
```

### Security

The Royalty Processing System implements several security measures:

1. **Financial Data Protection**
   - End-to-end encryption for financial data
   - Tokenization of banking information
   - Strict separation of financial systems
   - PCI DSS compliance for payment handling

2. **Access Control**
   - Role-based access to financial data
   - Rights holder access restricted to own data
   - Administrative access strictly controlled
   - Multi-factor authentication for financial operations

3. **Audit and Compliance**
   - Complete audit trails for all financial transactions
   - Immutable record of all calculations
   - Regular compliance audits
   - Regulatory reporting capabilities
   - Segregation of duties for financial operations

4. **Data Integrity**
   - Cryptographic verification of financial records
   - Checksums for data transfer validation
   - Reconciliation processes for all financial data
   - Error detection and correction mechanisms

### Financial Compliance

The system is designed for compliance with financial regulations:

1. **Tax Compliance**
   - Automated tax withholding based on jurisdiction
   - Form generation for tax reporting (1099, etc.)
   - Cross-border tax treaty support
   - VAT/GST handling for applicable territories

2. **Accounting Standards**
   - GAAP-compliant financial recording
   - Reconciliation with accounting systems
   - Audit-ready financial trails
   - Reporting capabilities for financial statements

3. **Anti-Fraud Measures**
   - Unusual activity detection
   - Payment verification processes
   - Multi-level approval for large transactions
   - Authentication for payment recipients

### Integration with External Systems

The Royalty Processing System integrates with several external systems:

1. **Banking Systems**
   - ACH/SWIFT transfer integration
   - Payment processor connections
   - Bank account verification
   - International banking network access

2. **Accounting Software**
   - Synchronization with accounting platforms
   - Journal entry generation
   - Financial report export
   - Reconciliation capabilities

3. **Tax Systems**
   - Tax form generation and filing
   - Tax authority reporting
   - Cross-border tax management
   - Digital tax receipt generation

4. **Streaming Platforms**
   - Direct API connections to major platforms
   - Sales report ingestion
   - Automated reconciliation
   - Trend analysis and forecasting

### Implementation Examples

#### Royalty Calculation Implementation

```typescript
// In server/services/royalty-calculator.ts

import { RevenueRecord, RoyaltyTransaction, DeductionType } from '@shared/schema';
import { storage } from '../storage';
import { calculateShares } from '../utils/share-math';
import { applyContractTerms } from '../services/contract-interpreter';
import Decimal from 'decimal.js';

export async function calculateRoyalties(
  revenueRecords: RevenueRecord[],
  periodId: string
): Promise<RoyaltyTransaction[]> {
  const transactions: RoyaltyTransaction[] = [];

  // Group records by asset for more efficient processing
  const recordsByAsset = groupRecordsByAsset(revenueRecords);

  // Process each asset
  for (const [assetId, records] of Object.entries(recordsByAsset)) {
    // Get rights for this asset
    const rights = await storage.getRightsForAsset(assetId);

    // Filter rights by type and territory
    const applicableRights = filterApplicableRights(rights, records);

    for (const right of applicableRights) {
      // Get revenue amount applicable to this right
      const applicableRevenue = getApplicableRevenue(records, right);

      // Apply contract terms (rates, minimums, etc.)
      const { grossAmount, deductions } = await applyContractTerms(right, applicableRevenue);

      // Calculate shares for each rights holder
      const shares = calculateShares(grossAmount, right.holders);

      // Create transaction for each holder
      for (const [holderId, amount] of shares.entries()) {
        const holder = right.holders.find(h => h.holderId === holderId);
        if (!holder) continue;

        const netAmount = calculateNetAmount(amount, deductions);

        // Create royalty transaction
        const transaction: RoyaltyTransaction = {
          id: generateTransactionId(),
          revenueRecordIds: records.map(r => r.id),
          rightId: right.id,
          holderId,
          sharePercentage: holder.sharePercentage,
          grossAmount: amount,
          deductions,
          netAmount,
          currency: 'USD', // Standardized currency
          status: 'calculated',
          periodId,
          createdAt: new Date()
        };

        transactions.push(transaction);
      }
    }
  }

  // Store all transactions
  await storage.createRoyaltyTransactions(transactions);

  return transactions;
}

function groupRecordsByAsset(records: RevenueRecord[]): Record<string, RevenueRecord[]> {
  return records.reduce((groups, record) => {
    const group = groups[record.assetId] || [];
    group.push(record);
    groups[record.assetId] = group;
    return groups;
  }, {} as Record<string, RevenueRecord[]>);
}

function filterApplicableRights(rights: any[], records: RevenueRecord[]): any[] {
  // Filter rights based on revenue source type, territory, dates, etc.
  // ...
  return rights;
}

function getApplicableRevenue(records: RevenueRecord[], right: any): number {
  // Calculate total revenue applicable to this right
  // ...
  return records.reduce((sum, record) => sum + record.amountUSD, 0);
}

function calculateNetAmount(grossAmount: number, deductions: any[]): number {
  const totalDeductions = deductions.reduce((sum, d) => sum + d.amount, 0);
  return grossAmount - totalDeductions;
}

function generateTransactionId(): string {
  return `rt-${Date.now()}-${Math.random().toString(36).substring(2, 10)}`;
}
```

#### Payment Processing Implementation

```typescript
// In server/services/payment-processor.ts

import { RoyaltyTransaction, Payment, PaymentStatus, PaymentType } from '@shared/schema';
import { storage } from '../storage';
import { processBankTransfer } from '../utils/bank-transfer';
import { processPayPalPayment } from '../utils/paypal';
import { generateReceipt } from '../utils/receipt-generator';
import { calculateTaxWithholding } from '../services/tax-engine';

export async function processPayments(
  transactions: RoyaltyTransaction[],
  batchId: string,
  options: {
    minimumAmount: number;
    includeTaxWithholding: boolean;
  }
): Promise<Payment[]> {
  const payments: Payment[] = [];

  // Group transactions by recipient
  const transactionsByHolder = groupTransactionsByHolder(transactions);

  // Process each recipient
  for (const [holderId, holderTransactions] of Object.entries(transactionsByHolder)) {
    // Calculate total payment amount
    const totalAmount = holderTransactions.reduce((sum, t) => sum + t.netAmount, 0);

    // Apply minimum threshold
    if (totalAmount < options.minimumAmount) {
      console.log(`Payment for holder ${holderId} below minimum threshold`);
      continue;
    }

    // Get holder payment method
    const holder = await storage.getRightsHolder(parseInt(holderId));
    const paymentMethod = await storage.getPreferredPaymentMethod(parseInt(holderId));

    if (!paymentMethod) {
      console.error(`No payment method found for holder ${holderId}`);
      continue;
    }

    // Calculate tax withholding if required
    let taxWithheld = 0;
    let taxDocuments: string[] = [];

    if (options.includeTaxWithholding) {
      const taxResult = await calculateTaxWithholding(parseInt(holderId), totalAmount);
      taxWithheld = taxResult.amount;
      taxDocuments = taxResult.documents;
    }

    // Final payment amount after tax
    const paymentAmount = totalAmount - taxWithheld;

    // Create payment record
    const payment: Payment = {
      id: generatePaymentId(),
      batchId,
      royaltyTransactionIds: holderTransactions.map(t => t.id),
      recipientId: parseInt(holderId),
      amount: paymentAmount,
      currency: 'USD', // Standardized currency
      method: paymentMethod,
      status: PaymentStatus.PENDING,
      taxWithheld: taxWithheld > 0 ? taxWithheld : undefined,
      taxDocuments: taxDocuments.length > 0 ? taxDocuments : undefined,
      createdAt: new Date(),
      updatedAt: new Date()
    };

    // Execute payment based on method type
    try {
      let processorResponse;

      switch (paymentMethod.type) {
        case PaymentType.BANK_TRANSFER:
          processorResponse = await processBankTransfer(payment);
          break;
        case PaymentType.PAYPAL:
          processorResponse = await processPayPalPayment(payment);
          break;
        // Handle other payment methods
        default:
          throw new Error(`Unsupported payment method: ${paymentMethod.type}`);
      }

      // Update payment with processor response
      payment.reference = processorResponse.reference;
      payment.status = PaymentStatus.COMPLETED;
      payment.processedAt = new Date();

      // Generate receipt
      const receiptUrl = await generateReceipt(payment, holderTransactions);

      // Store payment record
      await storage.createPayment(payment);

      // Update transaction statuses
      await updateTransactionStatus(holderTransactions, 'paid');

      payments.push(payment);

    } catch (error) {
      console.error(`Payment processing error for holder ${holderId}:`, error);

      // Store failed payment record
      payment.status = PaymentStatus.FAILED;
      payment.notes = `Failed: ${error.message}`;
      await storage.createPayment(payment);

      // Don't update transaction status - will be retried later
    }
  }

  return payments;
}

function groupTransactionsByHolder(transactions: RoyaltyTransaction[]): Record<string, RoyaltyTransaction[]> {
  return transactions.reduce((groups, transaction) => {
    const holderId = transaction.holderId.toString();
    const group = groups[holderId] || [];
    group.push(transaction);
    groups[holderId] = group;
    return groups;
  }, {} as Record<string, RoyaltyTransaction[]>);
}

async function updateTransactionStatus(transactions: RoyaltyTransaction[], status: string): Promise<void> {
  // Update status for all transactions
  // ...
}

function generatePaymentId(): string {
  return `pay-${Date.now()}-${Math.random().toString(36).substring(2, 10)}`;
}
```

### Performance Considerations

The Royalty Processing System is optimized for the following scenarios:

1. **High-Volume Calculation**
   - Parallelized processing for large catalogs
   - Efficient batch operations
   - Incremental calculation for updates
   - Resource allocation based on complexity

2. **Financial Accuracy**
   - High-precision decimal math
   - Extensive validation and reconciliation
   - Consistent rounding strategies
   - Balance verification at every step

3. **Reporting Performance**
   - Pre-aggregation of common metrics
   - Caching of statement data
   - Progressive loading for large statements
   - Asynchronous report generation

### Scaling Considerations

The system is designed to scale efficiently:

1. **Horizontal Scaling**
   - Stateless calculation components
   - Queue-based workload distribution
   - Distributed processing of large catalogs
   - Load balancing for API endpoints

2. **Database Scaling**
   - Read replicas for reporting queries
   - Sharding for large catalogs
   - Time-based partitioning of historical data
   - Caching layer for frequently accessed data

3. **Processing Optimization**
   - Priority queuing for different operation types
   - Resource allocation based on workload
   - Dedicated resources for time-sensitive operations
   - Background processing for non-urgent tasks

### Development Guidelines

When working with the Royalty Processing System, developers should follow these guidelines:

1. **Financial Accuracy**
   - Always use decimal types for currency calculations
   - Implement consistent rounding strategies
   - Validate all calculations with unit tests
   - Ensure debits and credits always balance

2. **Compliance Requirements**
   - Document all financial logic for audit purposes
   - Maintain clear separation of calculation steps
   - Preserve detailed financial records
   - Implement proper error handling for financial operations

3. **Performance Considerations**
   - Optimize database queries for large datasets
   - Implement efficient batch processing
   - Use caching for frequently accessed data
   - Balance between real-time and batch operations

4. **Security Practices**
   - Follow secure coding practices for financial systems
   - Implement proper access controls for all endpoints
   - Maintain comprehensive audit trails
   - Follow PCI DSS requirements for payment handling

*© 2025 TuneMantra. All rights reserved.*

---

#### 2025-03-01: TuneMantra Complete Platform Documentation
_Source: unified_documentation/TUNEMANTRA_MASTER_DOCUMENTATION.md (Branch: TUNEMANTRA_MASTER_DOCUMENTATION.md)_

Generated on Sun 23 Mar 2025 11:03:57 PM UTC

This master document provides a central reference to all essential TuneMantra documentation,
organized by functional area with links to comprehensive unified documents for each topic.

### Table of Contents

1. [Platform Overview](#platform-overview)
2. [System Architecture](#system-architecture)
3. [Key Features](#key-features)
4. [Core Components](#core-components)
   - [Distribution System](#distribution-system)
   - [Analytics System](#analytics-system)
   - [Royalty Management](#royalty-management)
   - [User Management](#user-management)
   - [Payment System](#payment-system)
5. [Developer Resources](#developer-resources)
   - [API Reference](#api-reference)
   - [Implementation Guides](#implementation-guides)
6. [Project Status](#project-status)
7. [Looking Forward](#looking-forward)

---

### Platform Overview
<a id="platform-overview"></a>

TuneMantra is an advanced multi-tenant music distribution platform that simplifies the process of
distributing music to streaming platforms while providing comprehensive analytics, royalty management,
and user management capabilities.

The platform is designed to serve artists, labels, and distributors with a unified solution for
managing their entire digital music ecosystem.

**Key Documentation:** See [Project Overview](./business/README.md) for executive documentation.

---

### System Architecture
<a id="system-architecture"></a>

The TuneMantra platform is built on a microservices architecture with separate components for
distribution, analytics, royalty management, payment processing, and user management.

**Key Documentation:** View [System Architecture Unified Document](./merged/system-architecture-unified.md) for comprehensive details.

---

### Key Features
<a id="key-features"></a>

- **Multi-platform Distribution:** Distribute music to all major streaming platforms
- **Comprehensive Analytics:** Track performance across platforms
- **Royalty Management:** Automated revenue collection and distribution
- **User Management:** Multi-tiered access for artists, labels, and admins
- **Secure Payment Processing:** Multiple payment options and currencies

**Key Documentation:** For complete feature details, see the unified documentation in each component section below.

---

### Core Components
<a id="core-components"></a>

TuneMantra consists of several core components that work together to provide a complete music distribution solution.

---

#### Distribution System
<a id="distribution-system"></a>

The Distribution System handles the preparation, validation, and delivery of music content to various streaming platforms and digital stores.

**Key Documentation:** [Complete Distribution System Documentation](./merged/distribution-system-unified.md)

---

#### Analytics System
<a id="analytics-system"></a>

The Analytics System provides real-time and historical performance data for all distributed content across platforms.

**Key Documentation:** [Complete Analytics System Documentation](./merged/analytics-system-unified.md)

---

#### Royalty Management
<a id="royalty-management"></a>

The Royalty Management System calculates, tracks, and distributes revenue to rights holders according to configurable splits and agreements.

**Key Documentation:** [Complete Royalty Management Documentation](./merged/royalty-management-unified.md)

---

#### User Management
<a id="user-management"></a>

The User Management System handles authentication, authorization, and profile management for all system users including artists, labels, and administrators.

**Key Documentation:** [Complete User Management Documentation](./merged/user-management-unified.md)

---

#### Payment System
<a id="payment-system"></a>

The Payment System processes all financial transactions, including royalty payments, platform fees, and subscription charges.

**Key Documentation:** [Complete Payment System Documentation](./merged/payment-system-unified.md)

---

### Developer Resources
<a id="developer-resources"></a>

TuneMantra provides extensive resources for developers to extend and integrate with the platform.

---

#### API Reference
<a id="api-reference"></a>

The TuneMantra API provides programmatic access to all platform functions, allowing for custom integrations and workflow automation.

**Key Documentation:** [Complete API Reference Documentation](./merged/api-reference-unified.md)

---

#### Implementation Guides
<a id="implementation-guides"></a>

Implementation Guides provide step-by-step instructions for deploying, configuring, and extending the TuneMantra platform.

**Key Documentation:** [Complete Implementation Guides Documentation](./merged/implementation-guide-unified.md)

---

### Project Status
<a id="project-status"></a>

TuneMantra is currently at **97.03% completion** (98 of 101 planned features) with target completion date of May 1, 2025. Key components status:

- Backend Core Services: 95.00% complete (19/20 features)
- Frontend UI: 96.00% complete (24/25 features)
- Distribution System: 100.00% complete (10/10 features)
- Analytics Engine: 87.50% complete (7/8 features)
- Royalty Management: 100.00% complete (6/6 features)
- User Management: 100.00% complete (10/10 features)
- Payment System: 100.00% complete (7/7 features)
- Documentation: 100.00% complete (10/10 features)
- Testing: 100.00% complete (5/5 features)

**Key Documentation:** For comprehensive details on exact current status, implemented features, and development priorities, see the [Current Project Status Report](./CURRENT_PROJECT_STATUS.md)

---

### Looking Forward
<a id="looking-forward"></a>

The TuneMantra roadmap includes planned enhancements and new features to further improve the platform:

- Expanded distribution channels to include emerging platforms
- Enhanced analytics with AI-powered insights
- Blockchain integration for royalty transparency
- Mobile app enhancements for on-the-go management
- Advanced marketing tools and promotional features

**Key Documentation:** For detailed roadmap information, see the [Development Roadmap](./technical/README.md).

---

### Conclusion

This master document provides a comprehensive overview of the TuneMantra platform with links to detailed
documentation for each component. For more information on specific topics, please follow the links within
each section.

For a complete listing of all documentation, see the [Documentation Index](./DOCUMENTATION_INDEX.md).

For unified documents that merge related content chronologically, see the [Merged Documentation](./merged/README.md).

---

#### 2025-03-01: TuneMantra Administrator Guide
_Source: unified_documentation/tutorials/temp-3march-admin-guide.md (Branch: temp)_


### Introduction

Welcome to the TuneMantra Administrator Guide. This comprehensive document provides all the information needed to administer, configure, and maintain the TuneMantra music distribution platform. This guide is intended for system administrators, platform managers, and technical support staff.

### Platform Administration

#### Initial Setup

##### Super Admin Registration

1. Access the TuneMantra platform using the URL provided during installation.
2. Navigate to the registration page at `/register/super-admin`.
3. Enter the super admin registration code provided during installation.
4. Complete the registration form with your details.
5. After successful registration, you'll be directed to the admin dashboard.

##### System Configuration

1. Navigate to **Admin > System Configuration**.
2. Configure the following system-wide settings:
   - **General Settings**: Platform name, logo, contact information
   - **Email Configuration**: SMTP settings for email notifications
   - **Storage Settings**: File storage configuration
   - **Payment Settings**: Payment gateway configuration
   - **Distribution Settings**: Global distribution settings

##### Environment Variables

Key environment variables that control platform behavior:

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `NODE_ENV` | Environment (development, production) | `development` |
| `PORT` | Server port | `5000` |
| `JWT_SECRET` | Secret key for JWT tokens | (Required) |
| `DATABASE_URL` | PostgreSQL connection URL | (Required) |
| `UPLOAD_DIR` | Directory for file uploads | `./uploads` |
| `SUPER_ADMIN_REGISTRATION_CODE` | Code for super admin registration | (Required) |
| `SMTP_HOST` | SMTP server hostname | (Optional) |
| `SMTP_PORT` | SMTP server port | `587` |
| `SMTP_USER` | SMTP username | (Optional) |
| `SMTP_PASS` | SMTP password | (Optional) |

For a complete list of environment variables, refer to the [Installation Guide](./installation.md).

#### User Management

##### User Roles

TuneMantra supports the following user roles:

- **Super Admin**: Full system access with all permissions
- **Label Admin**: Administrative access for a label with user management capabilities
- **Artist Manager**: Manages multiple artists and their content
- **Artist**: Individual artist with control over their content
- **Team Member**: Limited access based on assigned permissions

##### Managing Users

1. Navigate to **Admin > User Management**.
2. From here, you can:
   - View all users in the system
   - Create new users
   - Edit user details
   - Manage user roles and permissions
   - Activate/deactivate user accounts
   - Reset user passwords

##### Creating New Users

1. Navigate to **Admin > User Management > Create User**.
2. Fill in the user details:
   - Username
   - Email address
   - Full name
   - Role
   - Initial password
3. Configure additional options:
   - Permissions (if different from role defaults)
   - Label association (for label-specific roles)
   - Parent user (for team members)
4. Click "Create User" to add the new user.

##### Managing Permissions

1. Navigate to **Admin > User Management > Permission Templates**.
2. Create or edit permission templates to define sets of permissions for different user types.
3. Apply permission templates to users or roles.
4. Customize individual user permissions as needed.

#### Label Management

##### Label Creation

1. Navigate to **Admin > Label Management**.
2. Click "Create New Label".
3. Fill in the label details:
   - Label name
   - Contact information
   - Label administrator (select from existing users or create new)
   - Logo and branding assets
4. Configure label settings:
   - Distribution platforms
   - Payment details
   - Default royalty splits
5. Click "Create Label" to set up the new label.

##### Sub-Label Management

1. Navigate to **Admin > Label Management > [Label Name] > Sub-Labels**.
2. Create and manage sub-labels within the parent label.
3. Configure sub-label administrators and permissions.
4. Set up inheritance of settings from parent label.

##### Label Settings

Customize settings for each label:

1. Navigate to **Admin > Label Management > [Label Name] > Settings**.
2. Configure:
   - Label-specific branding
   - Default metadata templates
   - Approval workflows
   - Platform-specific distribution settings
   - Revenue thresholds and payment schedules

#### Content Approval Workflows

##### Approval Configuration

1. Navigate to **Admin > Approval Workflows**.
2. Configure approval workflows for:
   - New releases
   - Metadata changes
   - Distribution requests
   - Royalty split modifications
3. Set up approval stages and required approvers.
4. Configure notification settings for approvals.

##### Managing Approval Requests

1. Navigate to **Admin > Approval Queue**.
2. View pending approval requests.
3. Review details and assets for each request.
4. Approve, reject, or request changes.
5. Add comments for the requestor.

##### Approval Reports

1. Navigate to **Admin > Reports > Approval Analytics**.
2. View metrics on approval processes:
   - Average approval time
   - Approval/rejection rates
   - Bottlenecks in approval workflows
   - Approver performance

#### Distribution Platform Configuration

##### Platform Management

1. Navigate to **Admin > Distribution Platforms**.
2. Configure connections to distribution platforms:
   - Platform name and details
   - API credentials or FTP settings
   - Delivery method (API, FTP, manual)
   - Format requirements
   - Metadata mappings
3. Test connections to ensure proper configuration.

##### Global Distribution Settings

1. Navigate to **Admin > Distribution Settings**.
2. Configure global settings:
   - Default distribution schedule
   - Processing batch size
   - Retry policies for failed distributions
   - Notification settings

##### Platform-Specific Configuration

For each distribution platform:

1. Navigate to **Admin > Distribution Platforms > [Platform Name]**.
2. Configure:
   - Platform-specific metadata requirements
   - Content format specifications
   - Delivery protocol details
   - Status checking frequency
   - Custom delivery parameters

#### Payment and Revenue Management

##### Payment Gateway Configuration

1. Navigate to **Admin > Payment Configuration**.
2. Set up payment gateways:
   - Payment provider credentials
   - Transaction fees
   - Currency settings
   - Payment verification methods
3. Test payment processing to ensure proper configuration.

##### Revenue Distribution Settings

1. Navigate to **Admin > Revenue Settings**.
2. Configure:
   - Platform revenue collection frequency
   - Revenue processing schedule
   - Default processing fees
   - Minimum payout thresholds
   - Payment methods support

##### Financial Reporting

1. Navigate to **Admin > Financial Reports**.
2. Generate and manage financial reports:
   - Revenue by platform
   - Royalty disbursements
   - Transaction fees
   - Tax reports
   - Payment history

#### System Monitoring and Maintenance

##### Health Monitoring

1. Navigate to **Admin > System Health**.
2. Monitor:
   - Server status and performance
   - Database health and performance
   - API response times
   - Background job status
   - Storage usage and capacity

##### Log Management

1. Navigate to **Admin > System Logs**.
2. View and search logs:
   - Application logs
   - Error logs
   - Access logs
   - Audit logs
3. Configure log retention periods and archiving.

##### Backup Management

1. Navigate to **Admin > Backup Management**.
2. Configure backup settings:
   - Backup frequency
   - Backup targets (database, files)
   - Retention policy
   - Storage location
3. Test backup restoration process.

##### System Updates

1. Navigate to **Admin > System Updates**.
2. Manage platform updates:
   - View available updates
   - Schedule update installation
   - Review update history
   - Perform rollbacks if needed

#### Security Administration

##### Authentication Settings

1. Navigate to **Admin > Security > Authentication**.
2. Configure:
   - Password policy
   - Two-factor authentication settings
   - Session timeout settings
   - Login attempt limits

##### API Key Management

1. Navigate to **Admin > Security > API Keys**.
2. Manage API keys:
   - Create new API keys
   - Revoke existing keys
   - Configure key permissions and scopes
   - Monitor key usage

##### Audit Logging

1. Navigate to **Admin > Security > Audit Logs**.
2. Review security-related events:
   - User login/logout events
   - Admin actions
   - Configuration changes
   - Permission changes
   - Security-related actions

### White Label Configuration

#### Branding Customization

##### Visual Branding

1. Navigate to **Admin > White Label > Branding**.
2. Customize:
   - Logo uploads (primary, favicon, email)
   - Color scheme
   - Typography
   - UI component styling
   - Email templates

##### Domain Configuration

1. Navigate to **Admin > White Label > Domains**.
2. Configure:
   - Custom domain settings
   - SSL certificate management
   - Domain redirects
   - Sub-domain management

#### Client Customization

##### Client-Specific Settings

1. Navigate to **Admin > White Label > Client Settings**.
2. Configure per-client customizations:
   - Feature availability
   - Interface customization
   - Terminology customization
   - Custom workflows

##### White Label Deployment

For deploying white-labeled instances:

1. Navigate to **Admin > White Label > Deployments**.
2. Configure new deployments:
   - Client information
   - Branding settings
   - Domain configuration
   - Feature enablement
3. Monitor and manage existing deployments.

### Analytics Platform

#### Analytics Configuration

1. Navigate to **Admin > Analytics Settings**.
2. Configure:
   - Data collection parameters
   - Reporting periods
   - Performance thresholds
   - Anomaly detection settings

#### Data Import/Export

1. Navigate to **Admin > Analytics > Data Management**.
2. Manage:
   - Import external analytics data
   - Configure data source connections
   - Schedule automated imports
   - Export analytics data
   - Configure data retention policies

#### Report Configuration

1. Navigate to **Admin > Analytics > Report Templates**.
2. Create and manage report templates:
   - Performance reports
   - Revenue reports
   - Artist analytics
   - Platform comparisons
   - Custom report definitions

### Support Management

#### Support Ticket System

1. Navigate to **Admin > Support > Tickets**.
2. Manage support tickets:
   - View all tickets
   - Assign tickets to staff
   - Track ticket status
   - Set priority levels
   - Configure SLA policies

#### Knowledge Base Management

1. Navigate to **Admin > Support > Knowledge Base**.
2. Manage knowledge base articles:
   - Create and edit articles
   - Categorize content
   - Manage article visibility
   - Track article effectiveness

#### User Feedback Management

1. Navigate to **Admin > Support > Feedback**.
2. Review and manage user feedback:
   - Feature requests
   - Bug reports
   - General feedback
   - User satisfaction metrics

### Advanced Administration

#### Bulk Operations

1. Navigate to **Admin > Bulk Operations**.
2. Perform batch operations:
   - Bulk user management
   - Batch content processing
   - Mass distribution actions
   - Bulk metadata updates
   - Batch reporting

#### API Management

1. Navigate to **Admin > API Management**.
2. Manage API configuration:
   - Rate limiting settings
   - Endpoint availability
   - Version management
   - API documentation

#### Data Migration

1. Navigate to **Admin > Data Migration**.
2. Manage data migration operations:
   - Import catalogs from external systems
   - Export platform data
   - Configure mapping templates
   - Schedule migration jobs

#### Background Jobs

1. Navigate to **Admin > Background Jobs**.
2. Manage system jobs:
   - Distribution processing queue
   - Analytics processing jobs
   - Scheduled maintenance tasks
   - Email notification queue
3. View job history and performance.

### Troubleshooting

#### Common Issues

##### User Authentication Problems

**Symptoms**: Users unable to log in, password reset failures, session timeouts

**Resolution Steps**:
1. Check user account status in Admin > User Management
2. Verify authentication settings in Admin > Security > Authentication
3. Check for login attempt restrictions
4. Ensure email configuration is correct for password resets
5. Clear browser cache and cookies

##### Distribution Failures

**Symptoms**: Failed distributions, stuck in processing state, platform errors

**Resolution Steps**:
1. Check distribution logs in Admin > Distribution > Logs
2. Verify platform credentials in Admin > Distribution Platforms
3. Validate content against platform requirements
4. Check network connectivity to distribution endpoints
5. Review specific platform error messages
6. Test platform connection using the Test button

##### Payment Processing Issues

**Symptoms**: Failed payments, missing revenue data, royalty calculation errors

**Resolution Steps**:
1. Verify payment gateway configuration in Admin > Payment Configuration
2. Check transaction logs in Admin > Financial Reports > Transactions
3. Ensure banking information is correctly configured
4. Verify currency settings match platform data
5. Check for minimum threshold requirements

##### System Performance Issues

**Symptoms**: Slow response times, timeouts, high resource usage

**Resolution Steps**:
1. Check system health dashboard in Admin > System Health
2. Review server resource usage (CPU, memory, disk)
3. Check database performance metrics
4. Optimize query performance if needed
5. Consider scaling resources if consistently under-provisioned

#### Diagnostic Tools

##### System Diagnostics

1. Navigate to **Admin > System Tools > Diagnostics**.
2. Run system checks:
   - Database connectivity
   - Storage access
   - External service connectivity
   - Cache performance
   - Background job processing

##### Log Analysis

1. Navigate to **Admin > System Logs > Analysis**.
2. Analyze logs for patterns:
   - Error frequency
   - Performance bottlenecks
   - Unusual activity patterns
   - Failure points

##### Test Environment

1. Navigate to **Admin > System Tools > Test Environment**.
2. Use test environment to:
   - Verify configuration changes
   - Test distribution to sandbox platforms
   - Validate workflow changes
   - Rehearse upgrade procedures

### Best Practices

#### Performance Optimization

- Regularly monitor system performance metrics
- Configure appropriate database indexing
- Optimize file storage for frequently accessed assets
- Set up caching for API responses and frequently accessed data
- Schedule resource-intensive tasks during off-peak hours

#### Security Hardening

- Regularly rotate API keys and credentials
- Implement strict password policies
- Enable two-factor authentication for all admin accounts
- Regularly review user permissions and access logs
- Keep the platform updated with security patches

#### Data Management

- Implement a regular backup schedule
- Test backup restoration periodically
- Define and enforce data retention policies
- Regularly purge unnecessary temporary data
- Archive old data that's not frequently accessed

#### System Maintenance

- Schedule regular maintenance windows
- Keep all system components updated
- Monitor disk space and database size
- Regularly review and clean error logs
- Document all configuration changes

### Administration Workflows

#### New Label Onboarding

1. Create label entity in Admin > Label Management
2. Create label administrator account
3. Configure label-specific settings
4. Set up distribution platform connections
5. Configure payment processing
6. Provide access to label administrator
7. Schedule training session

#### Platform Upgrade Process

1. Review release notes for the new version
2. Back up the current system (database and files)
3. Schedule maintenance window and notify users
4. Apply the upgrade to a test environment first
5. Test all critical functionality
6. Apply the upgrade to production
7. Verify system functionality post-upgrade
8. Update documentation if needed

#### End-of-Year Financial Processing

1. Verify all platform revenue has been collected
2. Process final royalty calculations for the year
3. Generate year-end financial reports
4. Process tax documentation
5. Archive financial records
6. Send year-end statements to stakeholders

### Reference

#### Command-Line Administration

TuneMantra provides command-line tools for administrative tasks:

```bash
## User management
npm run admin:create-user -- --email admin@example.com --role admin
npm run admin:reset-password -- --userId 123

## Database operations
npm run db:migrate
npm run db:backup

## Maintenance operations
npm run maintenance:clean-temp
npm run maintenance:optimize-db
```

#### System Architecture

For a detailed overview of the TuneMantra architecture, refer to the [Architecture Guide](./architecture.md).

#### API Reference

For API details useful for administration and integration, refer to the [API Reference](./api-reference.md).

---

*© 2025 TuneMantra. All rights reserved.*

---

#### 2025-03-01: User Management System
_Source: unified_documentation/user-guides/temp-3march-user-management.md (Branch: temp)_


### Overview

The TuneMantra User Management System provides a comprehensive framework for handling user accounts, authentication, authorization, role-based access control, and team collaboration. This document provides technical details for developers and system integrators working with the user infrastructure.

### System Architecture

The User Management System consists of several integrated components:

#### 1. Authentication Service

**Purpose**: Manages user authentication, security, and session handling.

**Implementation**:
- Password-based authentication with strong hashing
- Multi-factor authentication support
- Session management with secure tokens
- OAuth integration for third-party login
- JWT-based API authentication

**Key Files**:
- `server/auth.ts` - Core authentication logic
- `server/middleware/auth-middleware.ts` - Authentication middleware
- `server/utils/password-utils.ts` - Password hashing and verification

#### 2. User Identity Service

**Purpose**: Manages user profiles, account information, and preferences.

**Implementation**:
- User profile storage and retrieval
- Account verification workflows
- Profile management
- Contact information handling
- Preference management

**Key Files**:
- `shared/schema.ts` - User model definitions
- `server/storage.ts` - User data operations
- `server/services/user-profile.ts` - Profile management logic

#### 3. Authorization Service

**Purpose**: Manages permissions, roles, and access control.

**Implementation**:
- Role-based access control
- Permission management
- Access policy enforcement
- Dynamic permission calculation
- Resource-level authorization

**Key Files**:
- `server/middleware/role-based-access.ts` - RBAC middleware
- `server/utils/permissions-helper.ts` - Permission utilities
- `server/services/access-control.ts` - Access control logic

#### 4. Organization Management

**Purpose**: Manages team structures, hierarchies, and relationships.

**Implementation**:
- Multi-level organization hierarchy
- Team management
- User-team assignment
- Invitation workflows
- Role delegation

**Key Files**:
- `shared/schema.ts` - Organization models
- `server/services/team-management.ts` - Team operations
- `server/services/invitation.ts` - Invitation workflows

### Data Models

#### User Model

```typescript
export interface User {
  id: number;
  username: string;
  email: string;
  fullName: string | null;
  phoneNumber: string | null;
  entityName: string | null;
  avatarUrl: string | null;
  role: UserRole;
  permissions: UserPermissions;
  parentId: number | null; // For team members - ID of the parent user
  status: UserStatus;
  passwordHash: string;
  passwordResetToken?: string;
  passwordResetExpires?: Date;
  mfaEnabled: boolean;
  mfaSecret?: string;
  lastLogin?: Date;
  loginAttempts: number;
  lockUntil?: Date;
  subscriptionInfo?: SubscriptionInfo;
  preferences: UserPreferences;
  metadata: Record<string, any>;
  createdAt: Date;
  updatedAt: Date;
}

export enum UserRole {
  ADMIN = 'admin',
  LABEL = 'label',
  ARTIST_MANAGER = 'artist_manager',
  ARTIST = 'artist',
  TEAM_MEMBER = 'team_member'
}

export enum UserStatus {
  ACTIVE = 'active',
  PENDING = 'pending',
  PENDING_APPROVAL = 'pending_approval',
  SUSPENDED = 'suspended',
  REJECTED = 'rejected',
  INACTIVE = 'inactive'
}

export interface UserPermissions {
  canCreateReleases?: boolean;
  canManageArtists?: boolean;
  canViewAnalytics?: boolean;
  canManageDistribution?: boolean;
  canManageRoyalties?: boolean;
  canEditMetadata?: boolean;
  canAccessFinancials?: boolean;
  canInviteUsers?: boolean;
  canManageUsers?: boolean;
  canManageSubscriptions?: boolean;
  canAccessAdminPanel?: boolean;
  canViewAllContent?: boolean;
  canViewAllReports?: boolean;
  [key: string]: boolean | undefined;
}

export interface UserPreferences {
  emailNotifications: boolean;
  pushNotifications: boolean;
  twoFactorAuth: boolean;
  language: string;
  timezone: string;
  dateFormat: string;
  theme: string;
  dashboardLayout?: string;
  analyticsDefaultView?: string;
}

export interface SubscriptionInfo {
  plan: SubscriptionPlan;
  startDate: Date;
  endDate: Date;
  status: SubscriptionStatus;
  paymentId?: string;
  features?: string[];
  yearlyPriceInINR?: number;
}

export type SubscriptionPlan = 'label' | 'artist_manager' | 'artist' | 'free';

export type SubscriptionStatus = 'active' | 'pending' | 'pending_approval' | 
                                'canceled' | 'expired' | 'inactive' | 'rejected';
```

#### API Key Model

```typescript
export interface ApiKey {
  id: number;
  userId: number;
  name: string;
  key: string;
  scopes: string[];
  lastUsed?: Date;
  expiresAt?: Date;
  createdAt: Date;
}
```

#### Team Model

```typescript
export interface Team {
  id: number;
  name: string;
  ownerId: number;
  description?: string;
  avatarUrl?: string;
  permissions: TeamPermissions;
  members: TeamMember[];
  createdAt: Date;
  updatedAt: Date;
}

export interface TeamMember {
  userId: number;
  teamId: number;
  role: TeamRole;
  permissions?: UserPermissions;
  joinedAt: Date;
}

export enum TeamRole {
  OWNER = 'owner',
  ADMIN = 'admin',
  MEMBER = 'member',
  GUEST = 'guest'
}

export interface TeamPermissions {
  canManageReleases: boolean;
  canViewAnalytics: boolean;
  canManageTeam: boolean;
  canManageDistribution: boolean;
  canManageFinancials: boolean;
  [key: string]: boolean;
}
```

#### Invitation Model

```typescript
export interface Invitation {
  id: number;
  email: string;
  role: UserRole;
  teamId?: number;
  permissions?: UserPermissions;
  invitedBy: number;
  token: string;
  status: InvitationStatus;
  expiresAt: Date;
  createdAt: Date;
  updatedAt: Date;
}

export enum InvitationStatus {
  PENDING = 'pending',
  ACCEPTED = 'accepted',
  REJECTED = 'rejected',
  EXPIRED = 'expired',
  CANCELLED = 'cancelled'
}
```

### Core Workflows

#### User Registration Workflow

1. **Registration Request**
   - User submits registration form with basic info
   - Email uniqueness is verified
   - Password strength is validated
   - Initial role and permissions are assigned

2. **Verification Process**
   - Verification email is sent
   - User confirms email via verification link
   - Account status updated to verified

3. **Subscription Processing**
   - User selects subscription plan (if applicable)
   - Payment is processed (if required)
   - Subscription details attached to account

4. **Account Activation**
   - Account status updated based on plan
   - Free accounts activated immediately
   - Paid accounts may require admin approval
   - Welcome email sent upon activation

#### Authentication Workflow

1. **Login Process**
   - User provides credentials
   - Password is verified against hashed value
   - Failed attempts are tracked with rate limiting
   - Successful attempts reset counter and update last login

2. **Multi-Factor Authentication**
   - MFA check is performed if enabled
   - TOTP code or other second factor is validated
   - Session security level is elevated after MFA

3. **Session Management**
   - Session token is generated
   - Token is stored securely in HTTP-only cookie
   - Session expiration policies are applied
   - Refresh token flow implemented for long sessions

4. **API Authentication**
   - API keys support for programmatic access
   - JWT tokens issued for API authentication
   - Scope-based permission validation
   - Rate limiting applied to API access

#### Authorization Workflow

1. **Permission Resolution**
   - User's role determines base permissions
   - Custom permissions override role defaults
   - Team membership adds additional permissions
   - Resource ownership grants special access

2. **Access Control**
   - Each request passes through authorization middleware
   - Required permission is checked against user's permissions
   - Resource-level checks verify ownership or team access
   - Audit logging records significant access events

3. **Permission Inheritance**
   - Team permissions cascade to members
   - Organization hierarchy influences access patterns
   - Label owners can delegate permissions to team
   - Permission conflicts resolved using priority rules

#### Team Management Workflow

1. **Team Creation**
   - User with appropriate permissions creates team
   - Initial team details and settings are defined
   - Creator automatically assigned as team owner

2. **Member Invitation**
   - Team owner invites users via email
   - Invitation includes role and permissions
   - Expiration policy applied to invitations
   - Email notification sent to invitee

3. **Invitation Acceptance**
   - Invitee receives and accepts invitation
   - Account is created if user is new
   - User is added to team with specified role
   - Team-specific permissions are applied

4. **Role Management**
   - Team owners can modify member roles
   - Role changes trigger permission updates
   - Role history is maintained for auditing
   - Notification of significant role changes

### API Reference

#### User API

##### Register User

```
POST /api/users/register
Content-Type: application/json

Request Body:
{
  "username": "artistuser",
  "email": "artist@example.com",
  "password": "SecureP@ss123",
  "fullName": "John Smith",
  "role": "artist",
  "subscriptionPlan": "artist"
}

Response:
{
  "id": 123,
  "username": "artistuser",
  "email": "artist@example.com",
  "fullName": "John Smith",
  "role": "artist",
  "status": "pending",
  "createdAt": "2025-03-01T12:34:56Z"
}
```

##### Authenticate User

```
POST /api/auth/login
Content-Type: application/json

Request Body:
{
  "email": "artist@example.com",
  "password": "SecureP@ss123"
}

Response:
{
  "userId": 123,
  "username": "artistuser",
  "role": "artist",
  "permissions": {
    "canCreateReleases": true,
    "canViewAnalytics": true,
    ...
  },
  "token": "eyJhbGciOi...",
  "expiresAt": "2025-03-02T12:34:56Z",
  "requiresMfa": false
}
```

##### Get Current User

```
GET /api/users/me

Response:
{
  "id": 123,
  "username": "artistuser",
  "email": "artist@example.com",
  "fullName": "John Smith",
  "phoneNumber": "+1234567890",
  "avatarUrl": "https://example.com/avatars/123.jpg",
  "role": "artist",
  "permissions": {
    "canCreateReleases": true,
    "canViewAnalytics": true,
    ...
  },
  "status": "active",
  "lastLogin": "2025-03-01T12:34:56Z",
  "subscriptionInfo": {
    "plan": "artist",
    "startDate": "2025-03-01T00:00:00Z",
    "endDate": "2026-03-01T00:00:00Z",
    "status": "active"
  },
  "preferences": {
    "emailNotifications": true,
    "language": "en",
    "timezone": "America/New_York"
  },
  "createdAt": "2025-03-01T12:34:56Z"
}
```

##### Update User Profile

```
PATCH /api/users/me
Content-Type: application/json

Request Body:
{
  "fullName": "John D. Smith",
  "phoneNumber": "+1987654321",
  "preferences": {
    "emailNotifications": false,
    "timezone": "Europe/London"
  }
}

Response:
{
  "id": 123,
  "username": "artistuser",
  "email": "artist@example.com",
  "fullName": "John D. Smith",
  "phoneNumber": "+1987654321",
  "preferences": {
    "emailNotifications": false,
    "timezone": "Europe/London"
  },
  "updatedAt": "2025-03-02T09:12:34Z"
}
```

#### API Key Management

##### Create API Key

```
POST /api/users/api-keys
Content-Type: application/json

Request Body:
{
  "name": "Studio Integration",
  "scopes": ["releases:read", "releases:write", "analytics:read"]
}

Response:
{
  "id": 456,
  "name": "Studio Integration",
  "key": "tm_k1_abcd1234...",
  "scopes": ["releases:read", "releases:write", "analytics:read"],
  "expiresAt": null,
  "createdAt": "2025-03-03T15:30:45Z"
}
```

##### List API Keys

```
GET /api/users/api-keys

Response:
{
  "apiKeys": [
    {
      "id": 456,
      "name": "Studio Integration",
      "scopes": ["releases:read", "releases:write", "analytics:read"],
      "lastUsed": "2025-03-03T16:20:15Z",
      "expiresAt": null,
      "createdAt": "2025-03-03T15:30:45Z"
    },
    {
      "id": 457,
      "name": "Analytics Export",
      "scopes": ["analytics:read"],
      "lastUsed": null,
      "expiresAt": "2025-06-03T15:30:45Z",
      "createdAt": "2025-03-03T15:35:22Z"
    }
  ]
}
```

##### Delete API Key

```
DELETE /api/users/api-keys/456

Response:
{
  "success": true,
  "message": "API key deleted successfully"
}
```

#### Team Management API

##### Create Team

```
POST /api/teams
Content-Type: application/json

Request Body:
{
  "name": "Production Team",
  "description": "Team responsible for production and mastering",
  "permissions": {
    "canManageReleases": true,
    "canViewAnalytics": true,
    "canManageTeam": false,
    "canManageDistribution": true,
    "canManageFinancials": false
  }
}

Response:
{
  "id": 789,
  "name": "Production Team",
  "ownerId": 123,
  "description": "Team responsible for production and mastering",
  "permissions": {
    "canManageReleases": true,
    "canViewAnalytics": true,
    "canManageTeam": false,
    "canManageDistribution": true,
    "canManageFinancials": false
  },
  "members": [
    {
      "userId": 123,
      "role": "owner",
      "joinedAt": "2025-03-10T11:22:33Z"
    }
  ],
  "createdAt": "2025-03-10T11:22:33Z"
}
```

##### Invite Team Member

```
POST /api/teams/789/invitations
Content-Type: application/json

Request Body:
{
  "email": "engineer@example.com",
  "role": "member",
  "permissions": {
    "canManageReleases": true,
    "canViewAnalytics": true,
    "canManageDistribution": false
  }
}

Response:
{
  "id": 101,
  "email": "engineer@example.com",
  "role": "member",
  "teamId": 789,
  "permissions": {
    "canManageReleases": true,
    "canViewAnalytics": true,
    "canManageDistribution": false
  },
  "invitedBy": 123,
  "status": "pending",
  "expiresAt": "2025-03-17T11:22:33Z",
  "createdAt": "2025-03-10T11:25:42Z"
}
```

##### Accept Invitation

```
POST /api/invitations/accept/abc123token
Content-Type: application/json

Request Body:
{
  "password": "SecureP@ss456", // Only if creating a new account
  "fullName": "Jane Engineer" // Only if creating a new account
}

Response:
{
  "success": true,
  "user": {
    "id": 124,
    "username": "janeengineer",
    "email": "engineer@example.com",
    "fullName": "Jane Engineer",
    "role": "team_member",
    "parentId": 123,
    "status": "active",
    "teams": [
      {
        "id": 789,
        "name": "Production Team",
        "role": "member"
      }
    ]
  }
}
```

### Security

The User Management System implements several security measures:

1. **Password Security**
   - Argon2id hashing for password storage
   - Password policy enforcement
   - Password rotation recommendations
   - Brute force protection
   - Secure password reset workflow

2. **Session Security**
   - HTTP-only secure cookies
   - CSRF protection
   - Session timeout policies
   - Session invalidation on password change
   - IP-based anomaly detection

3. **Authentication Security**
   - Optional multi-factor authentication
   - Rate limiting on authentication attempts
   - Account lockout after suspicious activity
   - Login anomaly detection
   - Account recovery verification

4. **API Security**
   - Scoped API keys with minimal permissions
   - JWT with short expiration for API calls
   - Rate limiting for API endpoints
   - Audit logging for sensitive operations
   - Secret key rotation policies

### Role-Based Access Control

The system implements a comprehensive RBAC model with the following roles:

1. **Admin Role**
   - Platform-wide administrative access
   - User management across all accounts
   - System configuration capabilities
   - Content moderation abilities
   - Analytics across all users

2. **Label Role**
   - Management of multiple artists
   - Team creation and management
   - Royalty distribution oversight
   - Catalog-wide analytics
   - Multi-artist release management

3. **Artist Manager Role**
   - Management of assigned artists
   - Release coordination
   - Analytics for managed artists
   - Distribution management
   - Limited financial access

4. **Artist Role**
   - Individual content management
   - Personal analytics access
   - Release creation and submission
   - Royalty tracking
   - Profile management

5. **Team Member Role**
   - Permissions inherited from team settings
   - Access limited to assigned resources
   - Role-specific functionality
   - Team-based collaboration tools

### Implementation Examples

#### Authentication Middleware

```typescript
// In server/middleware/auth-middleware.ts

import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { storage } from '../storage';

export const requireAuth = async (req: Request, res: Response, next: NextFunction) => {
  try {
    // Check for authentication cookie
    const token = req.cookies.authToken;

    // Also check for Bearer token in Authorization header for API requests
    const authHeader = req.headers.authorization;
    const bearerToken = authHeader?.startsWith('Bearer ') 
      ? authHeader.substring(7) 
      : null;

    const apiKey = req.headers['x-api-key'] as string;

    if (!token && !bearerToken && !apiKey) {
      return res.status(401).json({ error: 'Authentication required' });
    }

    let userId: number;

    if (apiKey) {
      // Handle API key authentication
      const keyInfo = await storage.getApiKeyByKey(apiKey);

      if (!keyInfo) {
        return res.status(401).json({ error: 'Invalid API key' });
      }

      if (keyInfo.expiresAt && new Date(keyInfo.expiresAt) < new Date()) {
        return res.status(401).json({ error: 'Expired API key' });
      }

      // Update last used timestamp
      await storage.updateApiKeyLastUsed(keyInfo.id);

      // Set userId and API scopes
      userId = keyInfo.userId;
      req.apiScopes = keyInfo.scopes;

    } else {
      // Handle JWT authentication
      const tokenToVerify = token || bearerToken;

      if (!tokenToVerify) {
        return res.status(401).json({ error: 'Authentication required' });
      }

      try {
        const decoded = jwt.verify(tokenToVerify, process.env.JWT_SECRET!) as { userId: number };
        userId = decoded.userId;
      } catch (err) {
        return res.status(401).json({ error: 'Invalid or expired token' });
      }
    }

    // Get the user and verify status
    const user = await storage.getUser(userId);

    if (!user) {
      return res.status(401).json({ error: 'User not found' });
    }

    if (user.status !== 'active') {
      return res.status(403).json({ 
        error: 'Account is not active',
        status: user.status 
      });
    }

    // Attach user to request
    req.userId = userId;
    req.userRole = user.role;
    req.userPermissions = user.permissions;

    next();
  } catch (error) {
    console.error('Authentication error:', error);
    return res.status(500).json({ error: 'Authentication process failed' });
  }
};

export const requirePermission = (requiredPermission: string) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      // Get user information from previous middleware
      const userId = req.userId;
      const userRole = req.userRole;
      const userPermissions = req.userPermissions;

      if (!userId) {
        return res.status(401).json({ error: 'Authentication required' });
      }

      // If using API key, check scopes
      if (req.apiScopes) {
        // Map permission to API scope
        const requiredScope = mapPermissionToScope(requiredPermission);

        if (!req.apiScopes.includes(requiredScope) && !req.apiScopes.includes('*')) {
          return res.status(403).json({ 
            error: 'Insufficient API key scope',
            requiredScope,
            availableScopes: req.apiScopes
          });
        }

        return next();
      }

      // For admin role, always grant access
      if (userRole === 'admin') {
        return next();
      }

      // Check user-specific permissions
      if (userPermissions && userPermissions[requiredPermission] === true) {
        return next();
      }

      // Check team-based permissions if user is a team member
      if (userRole === 'team_member') {
        const hasTeamPermission = await checkTeamPermission(userId, requiredPermission);

        if (hasTeamPermission) {
          return next();
        }
      }

      // Permission denied
      return res.status(403).json({ 
        error: 'Permission denied',
        requiredPermission 
      });

    } catch (error) {
      console.error('Permission check error:', error);
      return res.status(500).json({ error: 'Permission check failed' });
    }
  };
};

function mapPermissionToScope(permission: string): string {
  // Map internal permission name to API scope
  const scopeMap: Record<string, string> = {
    'canCreateReleases': 'releases:write',
    'canViewAnalytics': 'analytics:read',
    'canManageDistribution': 'distribution:write',
    // Add more mappings as needed
  };

  return scopeMap[permission] || permission;
}

async function checkTeamPermission(userId: number, permission: string): Promise<boolean> {
  // Get user's team memberships
  const teams = await storage.getUserTeams(userId);

  // Check if any team grants this permission
  for (const team of teams) {
    if (team.permissions && team.permissions[permission] === true) {
      return true;
    }
  }

  return false;
}
```

#### User Registration Implementation

```typescript
// In server/services/user-service.ts

import { InsertUser, User, UserStatus } from '@shared/schema';
import { storage } from '../storage';
import { hashPassword } from '../utils/password-utils';
import { sendVerificationEmail } from '../utils/email-service';
import { generateVerificationToken } from '../utils/token-generator';
import { getDefaultPermissions } from '../utils/permissions-helper';

export async function registerUser(userData: Omit<InsertUser, 'passwordHash' | 'status' | 'createdAt' | 'updatedAt'> & { password: string }): Promise<User> {
  try {
    // Check if email already exists
    const existingUser = await storage.getUserByEmail(userData.email);

    if (existingUser) {
      throw new Error('Email already registered');
    }

    // Generate password hash
    const passwordHash = await hashPassword(userData.password);

    // Get default permissions for role
    const permissions = getDefaultPermissions(userData.role);

    // Generate verification token
    const verificationToken = generateVerificationToken();

    // Create user with pending status
    const newUser = await storage.createUser({
      ...userData,
      passwordHash,
      permissions,
      status: UserStatus.PENDING,
      loginAttempts: 0,
      mfaEnabled: false,
      preferences: {
        emailNotifications: true,
        pushNotifications: true,
        twoFactorAuth: false,
        language: 'en',
        timezone: 'UTC',
        dateFormat: 'MM/DD/YYYY',
        theme: 'light'
      },
      metadata: {
        verificationToken,
        verificationExpires: new Date(Date.now() + 24 * 60 * 60 * 1000) // 24 hours
      },
      createdAt: new Date(),
      updatedAt: new Date()
    });

    // Send verification email
    await sendVerificationEmail(
      userData.email,
      userData.fullName || userData.username,
      verificationToken
    );

    // Return created user (without sensitive data)
    const { passwordHash: _, ...userWithoutPassword } = newUser;
    return userWithoutPassword as User;

  } catch (error) {
    console.error('User registration error:', error);
    throw new Error(`Registration failed: ${error.message}`);
  }
}
```

### Performance Considerations

The User Management System is optimized for the following scenarios:

1. **High-Volume Authentication**
   - Connection pooling for database operations
   - Caching of frequently accessed user data
   - Redis-based session storage
   - Minimal database queries per request

2. **Scalable Authorization**
   - Permission caching to reduce calculation overhead
   - Batch permission checks for resource lists
   - Efficient hierarchical permission resolution
   - Resource-level permission indexing

3. **Team Management Efficiency**
   - Hierarchical caching of team structures
   - Optimized permission inheritance chains
   - Efficient team membership queries
   - Pagination for large team listings

### Integration with External Systems

The User Management System integrates with several external systems:

1. **Email Providers**
   - Transactional email services for notifications
   - Email verification workflows
   - Email deliverability tracking
   - Template management for communication

2. **Payment Providers**
   - Subscription processing integration
   - Payment verification
   - Invoice generation
   - Payment method management

3. **Third-Party Identity Providers**
   - OAuth integration for social login
   - SAML support for enterprise SSO
   - OpenID Connect compatibility
   - Third-party token validation

4. **Analytics Systems**
   - User activity tracking
   - Engagement analytics
   - Conversion monitoring
   - Retention metrics

### Development Guidelines

When working with the User Management System, developers should follow these guidelines:

1. **Security Best Practices**
   - Never store or log plain-text passwords
   - Always use the authentication middleware
   - Apply the principle of least privilege for roles
   - Validate all user inputs thoroughly
   - Use prepared statements for database queries

2. **Permission Handling**
   - Always check permissions before performing actions
   - Use the requirePermission middleware
   - Consider resource ownership in authorization
   - Document permission requirements in API endpoints

3. **User Experience Considerations**
   - Provide clear error messages for authentication issues
   - Implement progressive security measures
   - Design intuitive permission management interfaces
   - Maintain consistent access control behavior

4. **Integration Patterns**
   - Use standardized authentication flows
   - Implement proper API key management
   - Follow OAuth 2.0 best practices
   - Document all integration points

*© 2025 TuneMantra. All rights reserved.*

---

#### 2025-03-03: Payment System API Reference
_Source: unified_documentation/technical/3march1am-payment-api-reference.md (Branch: 3march1am)_


### Overview

This document provides a comprehensive reference for all payment-related API endpoints in the TuneMantra platform. These APIs enable payment method management, withdrawal requests, and revenue split configuration.

### Base URL

All API endpoints are relative to your Replit instance URL:

```
https://your-instance.replit.app/api
```

### Authentication

All payment API endpoints require authentication. Include a valid session cookie with your requests, which is obtained after successful login.

### API Endpoints

#### Payment Methods

##### List Payment Methods

Retrieves all payment methods for the authenticated user.

```
GET /payment-methods
```

**Response**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "type": "bank_account",
      "lastFour": "1234",
      "details": {
        "accountName": "John Doe",
        "bankName": "Example Bank",
        "accountType": "checking"
      },
      "isDefault": true,
      "createdAt": "2025-02-15T08:30:00Z"
    },
    {
      "id": 2,
      "type": "card",
      "lastFour": "5678",
      "details": {
        "cardType": "visa",
        "expiryMonth": 12,
        "expiryYear": 2026,
        "cardholderName": "John Doe"
      },
      "isDefault": false,
      "createdAt": "2025-02-16T10:15:00Z"
    }
  ]
}
```

##### Add Payment Method

Creates a new payment method for the authenticated user.

```
POST /payment-methods
```

**Request Body**

```json
{
  "type": "bank_account",
  "lastFour": "1234",
  "details": {
    "accountName": "John Doe",
    "bankName": "Example Bank",
    "accountType": "checking",
    "routingNumber": "123456789"
  },
  "isDefault": true
}
```

**Response**

```json
{
  "success": true,
  "data": {
    "id": 3,
    "type": "bank_account",
    "lastFour": "1234",
    "details": {
      "accountName": "John Doe",
      "bankName": "Example Bank",
      "accountType": "checking"
    },
    "isDefault": true,
    "createdAt": "2025-03-01T14:22:30Z"
  }
}
```

##### Delete Payment Method

Deletes a payment method belonging to the authenticated user.

```
DELETE /payment-methods/:id
```

**Parameters**

- `id`: The ID of the payment method to delete

**Response**

```json
{
  "success": true,
  "message": "Payment method deleted successfully"
}
```

#### Withdrawals

##### List Withdrawals

Retrieves all withdrawals for the authenticated user.

```
GET /withdrawals
```

**Query Parameters**

- `status` (optional): Filter by status (`pending`, `completed`, `rejected`)
- `limit` (optional): Maximum number of records to return
- `offset` (optional): Number of records to skip

**Response**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "paymentMethodId": 1,
      "amount": "500.00",
      "currency": "USD",
      "status": "completed",
      "notes": "Monthly withdrawal",
      "referenceNumber": "WD123456",
      "createdAt": "2025-02-20T09:30:00Z",
      "processedAt": "2025-02-21T11:45:00Z",
      "paymentMethod": {
        "type": "bank_account",
        "lastFour": "1234"
      }
    },
    {
      "id": 2,
      "paymentMethodId": 1,
      "amount": "750.00",
      "currency": "USD",
      "status": "pending",
      "notes": "Quarterly bonus",
      "createdAt": "2025-03-01T14:22:30Z",
      "paymentMethod": {
        "type": "bank_account",
        "lastFour": "1234"
      }
    }
  ],
  "pagination": {
    "total": 2,
    "limit": 10,
    "offset": 0
  }
}
```

##### Request Withdrawal

Creates a new withdrawal request for the authenticated user.

```
POST /withdrawals
```

**Request Body**

```json
{
  "paymentMethodId": 1,
  "amount": 1000.00,
  "currency": "USD",
  "notes": "March income withdrawal"
}
```

**Response**

```json
{
  "success": true,
  "data": {
    "id": 3,
    "paymentMethodId": 1,
    "amount": "1000.00",
    "currency": "USD",
    "status": "pending",
    "notes": "March income withdrawal",
    "createdAt": "2025-03-04T15:30:00Z",
    "paymentMethod": {
      "type": "bank_account",
      "lastFour": "1234"
    }
  }
}
```

##### Get Withdrawal Details

Retrieves details of a specific withdrawal.

```
GET /withdrawals/:id
```

**Parameters**

- `id`: The ID of the withdrawal to retrieve

**Response**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "paymentMethodId": 1,
    "amount": "500.00",
    "currency": "USD",
    "status": "completed",
    "notes": "Monthly withdrawal",
    "referenceNumber": "WD123456",
    "createdAt": "2025-02-20T09:30:00Z",
    "processedAt": "2025-02-21T11:45:00Z",
    "paymentMethod": {
      "type": "bank_account",
      "lastFour": "1234",
      "details": {
        "accountName": "John Doe",
        "bankName": "Example Bank"
      }
    }
  }
}
```

#### Revenue Splits

##### Get Revenue Splits

Retrieves revenue split configurations for the authenticated user.

```
GET /revenue-splits
```

**Response**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "Album Collaboration",
      "splits": [
        {
          "artistName": "Primary Artist",
          "artistId": 101,
          "role": "Artist",
          "percentage": 70
        },
        {
          "artistName": "Featured Artist",
          "artistId": 102,
          "role": "Feature",
          "percentage": 20
        },
        {
          "artistName": "Producer",
          "artistId": 103,
          "role": "Producer",
          "percentage": 10
        }
      ],
      "createdAt": "2025-02-10T09:30:00Z",
      "updatedAt": "2025-02-10T09:30:00Z"
    }
  ]
}
```

##### Create Revenue Split

Creates a new revenue split configuration.

```
POST /revenue-splits
```

**Request Body**

```json
{
  "title": "EP Collaboration",
  "splits": [
    {
      "artistName": "Primary Artist",
      "artistId": 101,
      "role": "Artist",
      "percentage": 60
    },
    {
      "artistName": "Featured Artist",
      "artistId": 102,
      "role": "Feature",
      "percentage": 25
    },
    {
      "artistName": "Producer",
      "artistId": 103,
      "role": "Producer",
      "percentage": 15
    }
  ]
}
```

**Response**

```json
{
  "success": true,
  "data": {
    "id": 2,
    "title": "EP Collaboration",
    "splits": [
      {
        "artistName": "Primary Artist",
        "artistId": 101,
        "role": "Artist",
        "percentage": 60
      },
      {
        "artistName": "Featured Artist",
        "artistId": 102,
        "role": "Feature",
        "percentage": 25
      },
      {
        "artistName": "Producer",
        "artistId": 103,
        "role": "Producer",
        "percentage": 15
      }
    ],
    "createdAt": "2025-03-04T15:45:00Z",
    "updatedAt": "2025-03-04T15:45:00Z"
  }
}
```

##### Update Revenue Split

Updates an existing revenue split configuration.

```
PUT /revenue-splits/:id
```

**Parameters**

- `id`: The ID of the revenue split to update

**Request Body**

```json
{
  "title": "EP Collaboration (Revised)",
  "splits": [
    {
      "artistName": "Primary Artist",
      "artistId": 101,
      "role": "Artist",
      "percentage": 55
    },
    {
      "artistName": "Featured Artist",
      "artistId": 102,
      "role": "Feature",
      "percentage": 25
    },
    {
      "artistName": "Producer",
      "artistId": 103,
      "role": "Producer",
      "percentage": 15
    },
    {
      "artistName": "Mixing Engineer",
      "artistId": 104,
      "role": "Engineer",
      "percentage": 5
    }
  ]
}
```

**Response**

```json
{
  "success": true,
  "data": {
    "id": 2,
    "title": "EP Collaboration (Revised)",
    "splits": [
      {
        "artistName": "Primary Artist",
        "artistId": 101,
        "role": "Artist",
        "percentage": 55
      },
      {
        "artistName": "Featured Artist",
        "artistId": 102,
        "role": "Feature",
        "percentage": 25
      },
      {
        "artistName": "Producer",
        "artistId": 103,
        "role": "Producer",
        "percentage": 15
      },
      {
        "artistName": "Mixing Engineer",
        "artistId": 104,
        "role": "Engineer",
        "percentage": 5
      }
    ],
    "createdAt": "2025-03-04T15:45:00Z",
    "updatedAt": "2025-03-04T16:30:00Z"
  }
}
```

##### Delete Revenue Split

Deletes a revenue split configuration.

```
DELETE /revenue-splits/:id
```

**Parameters**

- `id`: The ID of the revenue split to delete

**Response**

```json
{
  "success": true,
  "message": "Revenue split deleted successfully"
}
```

#### Subscription Management

##### Create Subscription

Creates a subscription checkout session.

```
POST /create-subscription
```

**Request Body**

```json
{
  "planType": "artist"
}
```

**Response**

```json
{
  "success": true,
  "data": {
    "orderId": "order_ABC123XYZ",
    "amount": 1999,
    "currency": "INR",
    "keyId": "rzp_test_abcdefghijklmn"
  }
}
```

##### Verify Payment

Verifies a payment after checkout completion.

```
POST /verify-payment
```

**Request Body**

```json
{
  "orderId": "order_ABC123XYZ",
  "paymentId": "pay_DEF456UVW",
  "signature": "abcdef1234567890abcdef1234567890abcdef",
  "planType": "artist"
}
```

**Response**

```json
{
  "success": true,
  "message": "Payment verified successfully",
  "data": {
    "subscriptionInfo": {
      "plan": "artist",
      "status": "pending_approval",
      "startDate": "2025-03-04T16:45:00Z",
      "endDate": "2026-03-04T16:45:00Z"
    }
  }
}
```

##### Cancel Subscription

Cancels the user's active subscription.

```
POST /cancel-subscription
```

**Response**

```json
{
  "success": true,
  "message": "Subscription cancelled successfully",
  "data": {
    "subscriptionInfo": {
      "plan": "artist",
      "status": "canceled",
      "startDate": "2025-03-04T16:45:00Z",
      "endDate": "2026-03-04T16:45:00Z",
      "cancelledAt": "2025-03-04T17:00:00Z"
    }
  }
}
```

##### Get Subscription Status

Retrieves the current subscription status for the authenticated user.

```
GET /subscription-status
```

**Response**

```json
{
  "success": true,
  "data": {
    "subscriptionInfo": {
      "plan": "artist",
      "status": "active",
      "startDate": "2025-03-04T16:45:00Z",
      "endDate": "2026-03-04T16:45:00Z",
      "features": [
        "distribution_to_all_platforms",
        "advanced_analytics",
        "royalty_management"
      ]
    }
  }
}
```

### Error Responses

All API endpoints return appropriate HTTP status codes and a standardized error response format:

```json
{
  "success": false,
  "error": {
    "code": "INVALID_REQUEST",
    "message": "The request contains invalid parameters",
    "details": {
      "field": "amount",
      "issue": "Amount must be greater than zero"
    }
  }
}
```

#### Common Error Codes

- `UNAUTHORIZED`: Authentication is required or has failed
- `FORBIDDEN`: The authenticated user does not have permission for this action
- `NOT_FOUND`: The requested resource was not found
- `INVALID_REQUEST`: The request contains invalid parameters
- `VALIDATION_ERROR`: The request data failed validation
- `INSUFFICIENT_FUNDS`: The user has insufficient funds for the requested withdrawal
- `PAYMENT_ERROR`: An error occurred during payment processing
- `INTERNAL_ERROR`: An internal server error has occurred

### Rate Limiting

API requests are subject to rate limiting to prevent abuse. Current limits are:

- Standard users: 60 requests per minute
- API users with key: 120 requests per minute

When a rate limit is exceeded, the API will respond with HTTP status 429 (Too Many Requests).

### Versioning

The current API version is v1. The version is implicit in the current implementation but may be explicitly required in future updates.

### Testing

For testing payment flows in development environments, use the Razorpay test credentials provided by the Razorpay dashboard.

### Webhooks

Webhooks for payment notifications are available at:

```
POST /api/payment/webhook
```

Webhooks require signature verification using the Razorpay webhook secret.

### Further Information

For implementation details, see:
- [Payment Implementation Guide](../guides/payment-implementation-guide.md)
- [Payment System Architecture](../architecture/PAYMENT_SYSTEM_ARCHITECTURE.md)

---

#### 2025-03-03: Payment and Revenue Management System: Executive Summary
_Source: unified_documentation/technical/3march1am-payment-revenue-executive-summary.md (Branch: 3march1am)_


### Overview

The TuneMantra Payment and Revenue Management System is a comprehensive financial infrastructure that enables secure payment processing, withdrawal management, and revenue distribution for music artists, labels, and managers. This system forms the backbone of the platform's monetization capabilities, allowing users to effectively manage their earnings from music distribution.

### Business Value

- **Simplified Earnings Management**: Central dashboard for all financial activities
- **Secure Transaction Processing**: Industry-standard security protocols for payment handling
- **Flexible Revenue Distribution**: Configurable splits for collaborating artists
- **Financial Transparency**: Detailed history and audit trails for all transactions
- **Streamlined Withdrawals**: Simplified process for transferring earnings to external accounts

### Key Features

#### Payment Methods Management
Secure storage and management of multiple payment methods including bank accounts, credit/debit cards, and PayPal.

#### Withdrawal Processing
Streamlined workflow for requesting withdrawals with status tracking, notifications, and secure processing.

#### Revenue Splits System
Collaborative revenue distribution framework that automatically divides earnings based on predefined percentage splits between artists.

#### Financial Reporting
Comprehensive reporting system providing insights into earnings, withdrawals, and revenue distribution.

#### Security Infrastructure
Multi-layered security approach including encryption, secure authentication, and PCI compliance measures.

### User Benefits

#### For Artists
- Manage multiple payment methods in one place
- Request withdrawals with just a few clicks
- Set up transparent revenue sharing with collaborators
- Track earnings across all platforms in real-time

#### For Labels and Managers
- Centralized financial management for represented artists
- Bulk withdrawal processing capabilities
- Detailed analytics on earnings performance
- Automated revenue distribution to roster artists

#### For Administrators
- Complete oversight of platform financial activities
- Tools for managing payment disputes
- Audit trails for all financial transactions
- Configurable security settings and access controls

### Technical Highlights

- **Modular Architecture**: Flexible component-based design for easy expansion
- **Secure API Layer**: RESTful API with robust authentication and authorization
- **Razorpay Integration**: Seamless integration with industry-leading payment processor
- **Encryption**: End-to-end encryption of sensitive financial data
- **Scalable Design**: Architecture that scales with growing transaction volumes

### Implementation Status

The Payment and Revenue Management System is fully implemented with the following components:

✅ Payment Methods CRUD functionality
✅ Withdrawal processing workflow
✅ Revenue splits configuration
✅ Financial reporting dashboard
✅ Security infrastructure
✅ Razorpay integration

### Performance Metrics

- **Transaction Processing Time**: < 2 seconds for standard operations
- **System Availability**: 99.9% uptime commitment
- **Data Security**: Compliant with industry standards
- **Scalability**: Capable of handling 10,000+ transactions per hour

### Future Roadmap

1. **Q2 2025**: Multi-currency support for global payments
2. **Q3 2025**: Advanced analytics with predictive earnings forecasting
3. **Q4 2025**: Blockchain integration for transparent royalty distribution
4. **Q1 2026**: Automated tax reporting and compliance features

### Documentation

For detailed information, please refer to the following documentation:

- [Comprehensive Feature Documentation](./PAYMENT_REVENUE_MANAGEMENT.md)
- [API Reference](../api/PAYMENT_API_REFERENCE.md)
- [Technical Architecture](../architecture/PAYMENT_SYSTEM_ARCHITECTURE.md)
- [Implementation Guide](../guides/payment-implementation-guide.md)

### Conclusion

The Payment and Revenue Management System provides a robust financial backbone for TuneMantra, enabling secure, transparent, and efficient handling of monetary transactions. This system empowers artists and labels to manage their earnings with confidence while maintaining the highest standards of security and performance.

---

#### 2025-03-03: Payment System Architecture
_Source: unified_documentation/technical/3march1am-payment-system-architecture.md (Branch: 3march1am)_


### Overview

The TuneMantra Payment System follows a modular, layered architecture designed for security, reliability, and maintainability. This document describes the architectural patterns, components, and data flows that make up the payment infrastructure.

### Architecture Diagram

```
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│   Client Layer  │      │   Server Layer   │      │ External Systems│
│                 │      │                 │      │                 │
│  ┌───────────┐  │      │  ┌───────────┐  │      │  ┌───────────┐  │
│  │React UI   │  │      │  │Express    │  │      │  │Razorpay   │  │
│  │Components │◄─┼──────┼─►│API Routes │◄─┼──────┼─►│Payment    │  │
│  └───────────┘  │      │  └───────────┘  │      │  │Gateway    │  │
│                 │      │        ▲        │      │  └───────────┘  │
│  ┌───────────┐  │      │        │        │      │                 │
│  │Form       │  │      │        ▼        │      │  ┌───────────┐  │
│  │Validations│  │      │  ┌───────────┐  │      │  │Banking    │  │
│  └───────────┘  │      │  │Services   │  │      │  │System     │  │
│                 │      │  │& Business │  │      │  │Integration│  │
│  ┌───────────┐  │      │  │Logic      │  │      │  └───────────┘  │
│  │State      │  │      │  └───────────┘  │      │                 │
│  │Management │  │      │        ▲        │      │                 │
│  └───────────┘  │      │        │        │      │                 │
│                 │      │        ▼        │      │                 │
└─────────────────┘      │  ┌───────────┐  │      └─────────────────┘
                         │  │Data Access│  │           ▲
                         │  │Layer      │  │           │
                         │  └───────────┘  │           │
                         │        ▲        │           │
                         │        │        │           │
                         │        ▼        │           │
                         │  ┌───────────┐  │           │
                         │  │PostgreSQL │  │           │
                         │  │Database   │──┼───────────┘
                         │  └───────────┘  │
                         │                 │
                         └─────────────────┘
```

### System Layers

#### 1. Client Layer

The client layer consists of React components, form validations, and state management for the payment system.

##### Components:

- **PaymentMethodForm**: Manages the addition and editing of payment methods
- **WithdrawalForm**: Handles withdrawal requests
- **RevenueSplitsEditor**: Manages revenue split configurations
- **PaymentHistoryTable**: Displays payment method and withdrawal history
- **SubscriptionCheckoutForm**: Interfaces with Razorpay for subscription payments

##### State Management:

- Uses TanStack Query (React Query) for data fetching and mutations
- Implements form state management with React Hook Form
- Handles validation with Zod schemas

#### 2. Server Layer

The server layer provides API endpoints, business logic, and data access functionality.

##### API Routes:

- **Payment Methods API**: CRUD operations for payment methods
- **Withdrawal API**: Create and manage withdrawal requests
- **Revenue Splits API**: Configure revenue distribution
- **Subscription API**: Handle subscription management and payments

##### Services & Business Logic:

- **Payment Service**: Validation, processing, and business rules
- **Crypto Service**: Encryption and security functionality
- **Notification Service**: Payment notifications and alerts
- **Audit Service**: Logging and tracking all financial transactions

##### Data Access Layer:

- **DatabaseStorage**: Uses Drizzle ORM for database operations
- **Schema Definitions**: Strongly typed schema with validation

#### 3. Database Layer

PostgreSQL database with the following tables:

- **payment_methods**: Stores payment method information
- **withdrawals**: Records withdrawal requests and status
- **revenue_splits**: Configuration for revenue distribution

#### 4. External Systems

- **Razorpay**: Payment gateway for subscription payments
- **Banking Systems**: For processing withdrawals

### Security Architecture

#### Data Protection

1. **Encryption at Rest**
   - Sensitive payment data is encrypted in the database
   - Uses AES-256 encryption for secure storage

2. **Transport Security**
   - All API communications use HTTPS
   - TLS 1.2+ for secure data transmission

#### Authentication & Authorization

1. **User Authentication**
   - Session-based authentication for UI access
   - JWT-based authentication for API access

2. **Permission Control**
   - Role-based access control (RBAC)
   - Fine-grained permissions for payment operations

#### Secure Integration

1. **Payment Gateway Integration**
   - Signature verification for webhook callbacks
   - API key rotation and secure key storage

2. **API Security**
   - Rate limiting to prevent abuse
   - Input validation using Zod schemas
   - Parameterized queries to prevent SQL injection

### Data Flow

#### Payment Method Registration

1. User submits payment method information via PaymentMethodForm
2. Client validates the form data using Zod
3. Data is sent to the server via a POST request to `/api/payment-methods`
4. Server validates input and encrypts sensitive information
5. Payment method is stored in the database
6. Response is returned to the client

#### Withdrawal Process

1. User requests a withdrawal through WithdrawalForm
2. Client validates the request and sends to `/api/withdrawals`
3. Server validates against user balance and permissions
4. Withdrawal record is created with "pending" status
5. Admin receives notification for approval
6. Upon approval, external payment processing is initiated
7. Withdrawal status is updated based on processing result

#### Subscription Payment

1. User selects a subscription plan
2. Server creates a Razorpay order via `/api/create-subscription`
3. Client receives order details and displays checkout form
4. User completes payment on Razorpay checkout
5. Razorpay sends webhook notification or redirects to verification URL
6. Server verifies payment signature and updates subscription status
7. User is granted access to subscription features

### Error Handling

The payment system implements comprehensive error handling:

1. **Client-Side Validation**
   - Form validation to prevent invalid submissions
   - Error messages for user guidance

2. **API Error Responses**
   - Consistent error format with error codes
   - Detailed error messages for debugging

3. **Transaction Rollbacks**
   - Database transactions for payment operations
   - Automatic rollback on failure

4. **Logging & Monitoring**
   - Error logging for all payment failures
   - Monitoring for unusual patterns

### Scalability Considerations

The payment system is designed for scalability:

1. **Horizontal Scaling**
   - Stateless API design for load balancing
   - Connection pooling for database access

2. **Caching Strategy**
   - Cached reference data (payment methods, currencies)
   - Optimized queries for performance

3. **Background Processing**
   - Asynchronous processing for time-consuming operations
   - Webhook processing in background workers

### Deployment Architecture

The payment system is deployed as part of the main TuneMantra application:

1. **Environment Configuration**
   - Environment variables for sensitive configuration
   - Feature flags for controlled rollout

2. **Integration With Main App**
   - Shared authentication and user context
   - Integrated permissions system

### Testing Strategy

The payment system includes several testing approaches:

1. **Unit Testing**
   - Isolated testing of payment components
   - Service method testing with mocks

2. **Integration Testing**
   - API endpoint testing with database
   - End-to-end payment flows

3. **Security Testing**
   - Penetration testing for payment endpoints
   - Encryption verification

### Monitoring & Auditing

1. **Transaction Logging**
   - All financial transactions are logged
   - Audit trail for regulatory compliance

2. **Performance Monitoring**
   - Response time tracking for payment operations
   - Error rate monitoring

3. **Security Alerts**
   - Unusual activity detection
   - Failed authentication attempts

### Disaster Recovery

1. **Backup Strategy**
   - Regular database backups
   - Transaction log backups

2. **Recovery Procedures**
   - Point-in-time recovery capability
   - Documented recovery procedures

### Technology Stack

The payment system utilizes:

1. **Frontend**
   - React for UI components
   - TanStack Query for data fetching
   - React Hook Form for form handling
   - Zod for validation

2. **Backend**
   - Express.js for API routes
   - Drizzle ORM for database access
   - Node.js crypto for encryption

3. **Database**
   - PostgreSQL for data storage

4. **External Services**
   - Razorpay for payment processing
   - SMTP for email notifications

### Configuration Management

Payment system configuration is managed through:

1. **Environment Variables**
   - API keys and secrets
   - Service URLs
   - Feature flags

2. **Database Configuration**
   - System settings stored in database
   - Admin-configurable parameters

### Development Guidelines

1. **Code Organization**
   - Separation of concerns between layers
   - Clear module responsibilities

2. **Naming Conventions**
   - Consistent naming across codebase
   - Descriptive function and component names

3. **Documentation**
   - Inline code documentation
   - API documentation with examples

### Future Architecture Evolution

The payment system is designed for evolution:

1. **Planned Enhancements**
   - Additional payment gateways
   - Advanced revenue distribution rules
   - Real-time payment notifications

2. **Extensibility**
   - Plugin architecture for new payment methods
   - Webhook system for external integrations

### Related Documentation

- [Payment API Reference](../api/PAYMENT_API_REFERENCE.md)
- [Payment Implementation Guide](../guides/payment-implementation-guide.md)
- [Payment & Revenue Management Features](../features/PAYMENT_REVENUE_MANAGEMENT.md)

---

#### 2025-03-08: TuneMantra Documentation
_Source: unified_documentation/technical/8march258-readme.md (Branch: 8march258)_


### Project Overview

This documentation provides a comprehensive guide to TuneMantra, a focused AI-powered music distribution platform that empowers music professionals with intelligent content management and multi-platform distribution capabilities.

TuneMantra allows artists, labels, and managers to efficiently manage, distribute, and monetize their music content across all major streaming platforms while providing advanced analytics, performance tracking, and revenue management features.

> **Platform Simplification Notice**: Rights management features (copyright registration, license tracking, PRO management) have been removed from TuneMantra to create a more focused platform dedicated exclusively to music catalog management, distribution, and revenue management. Revenue splits functionality for distributing earnings to collaborators remains fully intact.

### Project Completion Status

Based on a thorough deep scan of the codebase as of March 4, 2025, here are the latest completion metrics:

| Component | Completion % | Practicality % | Status |
|-----------|--------------|----------------|--------|
| Core Infrastructure | 98% | 95% | Production-Ready |
| Data Model | 100% | 97% | Production-Ready |
| Authentication System | 95% | 97% | Production-Ready |
| User Management | 92% | 95% | Production-Ready |
| Content Management | 90% | 92% | Production-Ready |
| Distribution Pipeline | 88% | 92% | Production-Ready |
| Analytics & Reporting | 85% | 88% | Production-Ready |
| Payment & Revenue Management | 100% | 98% | Production-Ready |
| ~~Rights Management~~ | ~~0%~~ | ~~0%~~ | **Removed** |
| AI Features | 65% | 78% | In Development |

#### Overall Project Metrics
- **Overall Completion**: 92.5%
- **Practical Usability**: 95.0%
- **Code Quality**: 97%
- **Test Coverage**: 88%
- **Documentation Quality**: 100%

Recent development efforts have focused on streamlining the platform, enhancing the distribution pipeline, and expanding the analytics capabilities. The platform has been simplified by removing rights management features (e.g., license tracking, copyright registration) to deliver a more focused experience centered on music distribution, while maintaining robust revenue splits functionality to manage earnings distribution to collaborators.

### Key Technologies

- **Frontend**: TypeScript, React, TailwindCSS, Shadcn UI
- **Backend**: Node.js, Express
- **Database**: PostgreSQL with Drizzle ORM
- **Authentication**: Session-based with Express-Session
- **State Management**: React Context, TanStack Query
- **UI Components**: Shadcn UI, Radix UI primitives
- **Data Visualization**: Chart.js, Recharts
- **File Processing**: Multer, xlsx, papaparse

### Documentation Sections

- [Architecture](./architecture/README.md) - System architecture and design patterns
  - [Distribution Service Architecture](./architecture/DISTRIBUTION_SERVICE_ARCHITECTURE.md) - Architecture of the optimized distribution system
  - [Payment System Architecture](./architecture/PAYMENT_SYSTEM_ARCHITECTURE.md) - Technical architecture of the payment system
- [Features](./features/README.md) - Detailed feature documentation
  - [Distribution System](./features/DISTRIBUTION_SYSTEM.md) - Music distribution system documentation
  - [Payment & Revenue Management](./features/PAYMENT_REVENUE_MANAGEMENT.md) - Comprehensive payment system documentation
  - [Payment & Revenue Executive Summary](./features/PAYMENT_REVENUE_EXECUTIVE_SUMMARY.md) - High-level overview
- [API Reference](./api/README.md) - API endpoints and usage
  - [Payment API Reference](./api/PAYMENT_API_REFERENCE.md) - Payment system API documentation
- [Implementation Guides](./implementation/README.md) - Technical implementation details
- [Reference](./reference/README.md) - Schema reference and data models
- [User Guides](./guides/README.md) - End-user documentation
  - [Payment Implementation Guide](./guides/payment-implementation-guide.md) - Developer guide for payment features

### Getting Started

To get started with the platform, refer to the [Quick Start Guide](./guides/quick-start.md).

For developers looking to contribute or extend the platform, refer to the [Developer Guide](./guides/developer-guide.md).

### Development Resources

- [Form System Documentation](./forms.md) - Comprehensive guide to our form system
- [Type Safety Improvements](./type-safety-improvements.md) - Guide to type safety in the codebase
- [Catalogue ID System](./catalogue-id-system.md) - Documentation for the catalogue ID generation system
- [Artist Verification System](./artist-verification-system.md) - Guide to the artist verification system

---

#### 2025-03-17: TuneMantra API Reference
_Source: unified_documentation/api-reference/17032025-api-reference.md (Branch: 17032025)_


### Introduction

The TuneMantra API provides programmatic access to your music catalog, distribution status, analytics, and royalty data. This comprehensive RESTful API allows you to integrate TuneMantra's powerful features into your own applications and workflows.

### Base URL

All API requests should be made to the following base URL:

```
https://api.tunemantra.com/v1
```

### Authentication

TuneMantra API uses API key authentication for all requests. You can generate API keys in your TuneMantra dashboard under Settings > API Keys.

#### Including Your API Key

Include your API key in the request header:

```
Authorization: Bearer YOUR_API_KEY
```

#### API Key Permissions

API keys can be scoped with specific permissions:

- `read:catalog` - View releases and tracks
- `write:catalog` - Create or update releases and tracks
- `read:analytics` - Access analytics data
- `read:royalties` - View royalty information
- `write:royalties` - Manage royalty splits
- `read:distribution` - View distribution status
- `write:distribution` - Create distributions

### Request Format

All requests should be sent as JSON with the following content type header:

```
Content-Type: application/json
```

### Response Format

All responses are returned in JSON format with the following structure:

```json
{
  "success": true,
  "data": {
    // Response data specific to the endpoint
  },
  "meta": {
    "total": 100,
    "page": 1,
    "limit": 10
  }
}
```

For error responses:

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": {
      // Additional error details
    }
  }
}
```

### Rate Limiting

The API enforces rate limits to ensure fair usage. Current limits are:

- 100 requests per minute for standard accounts
- 1000 requests per minute for premium accounts

Rate limit information is included in response headers:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1616551800
```

### Pagination

For endpoints that return collections, pagination is supported through the following query parameters:

- `page` - Page number (default: 1)
- `limit` - Results per page (default: 25, max: 100)

Pagination metadata is included in the response:

```json
"meta": {
  "total": 157,
  "page": 2,
  "limit": 25,
  "hasMore": true
}
```

### Filtering and Sorting

Many endpoints support filtering and sorting through query parameters:

- `sort` - Field to sort by
- `order` - Sort order ("asc" or "desc")
- Field-specific filters (e.g., `status=published`)

### API Endpoints

#### Authentication

##### Check Authentication Status

```
GET /auth/status
```

Returns the current authentication status and user information.

**Response Example:**

```json
{
  "success": true,
  "data": {
    "authenticated": true,
    "user": {
      "id": 12345,
      "username": "label_account",
      "role": "label"
    },
    "permissions": [
      "read:catalog",
      "write:catalog",
      "read:analytics"
    ]
  }
}
```

#### Catalog Management

##### List Releases

```
GET /releases
```

Returns a list of releases in your catalog.

**Query Parameters:**

| Parameter | Type   | Description |
|-----------|--------|-------------|
| `status`  | string | Filter by status (e.g., "draft", "published") |
| `type`    | string | Filter by release type (e.g., "single", "album") |
| `search`  | string | Search term for release title or artist |
| `page`    | number | Page number for pagination |
| `limit`   | number | Results per page |
| `sort`    | string | Field to sort by (e.g., "releaseDate", "title") |
| `order`   | string | Sort order ("asc" or "desc") |

**Response Example:**

```json
{
  "success": true,
  "data": [
    {
      "id": 123,
      "title": "Summer Vibes",
      "type": "album",
      "artist": "DJ Harmony",
      "releaseDate": "2025-06-15",
      "status": "published",
      "upc": "123456789012",
      "coverUrl": "https://assets.tunemantra.com/covers/123.jpg",
      "trackCount": 12
    },
    {
      "id": 124,
      "title": "Midnight Dreams",
      "type": "single",
      "artist": "Luna Echo",
      "releaseDate": "2025-05-01",
      "status": "published",
      "upc": "123456789013",
      "coverUrl": "https://assets.tunemantra.com/covers/124.jpg",
      "trackCount": 1
    }
  ],
  "meta": {
    "total": 45,
    "page": 1,
    "limit": 25,
    "hasMore": true
  }
}
```

##### Get Release Details

```
GET /releases/{releaseId}
```

Returns detailed information about a specific release.

**Path Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `releaseId` | number | Release ID  |

**Query Parameters:**

| Parameter | Type   | Description |
|-----------|--------|-------------|
| `expand`  | string | Comma-separated list of related resources to expand (e.g., "tracks,analytics") |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 123,
    "title": "Summer Vibes",
    "type": "album",
    "artist": "DJ Harmony",
    "releaseDate": "2025-06-15",
    "status": "published",
    "upc": "123456789012",
    "catalogueId": "TMCAT-87654-001",
    "label": "Harmony Records",
    "primaryGenre": "electronic",
    "secondaryGenres": ["dance", "house"],
    "language": "english",
    "explicit": false,
    "ownership": "original",
    "coverUrl": "https://assets.tunemantra.com/covers/123.jpg",
    "metadata": {
      "description": "A summer-themed electronic album with upbeat dance tracks.",
      "tags": ["summer", "dance", "electronic", "upbeat"],
      "credits": {
        "producer": "Alex Producer",
        "mixing": "Mix Master Studios",
        "mastering": "Final Touch Audio"
      }
    },
    "tracks": [
      {
        "id": 456,
        "title": "Sunshine Groove",
        "trackNumber": 1,
        "isrc": "USABC1234567",
        "duration": 210,
        "audioUrl": "https://assets.tunemantra.com/previews/456.mp3"
      },
      {
        "id": 457,
        "title": "Beach Party",
        "trackNumber": 2,
        "isrc": "USABC1234568",
        "duration": 195,
        "audioUrl": "https://assets.tunemantra.com/previews/457.mp3"
      }
    ],
    "distribution": {
      "status": "distributed",
      "platforms": [
        {
          "name": "Spotify",
          "status": "active",
          "url": "https://open.spotify.com/album/123456"
        },
        {
          "name": "Apple Music",
          "status": "active",
          "url": "https://music.apple.com/album/123456"
        }
      ]
    }
  }
}
```

##### Create a Release

```
POST /releases
```

Creates a new release in your catalog.

**Request Body:**

```json
{
  "title": "Winter Chill",
  "type": "ep",
  "primaryArtist": "Frost Beats",
  "releaseDate": "2025-12-01",
  "primaryGenre": "chill",
  "secondaryGenres": ["electronic", "ambient"],
  "language": "english",
  "explicit": false,
  "ownership": "original",
  "metadata": {
    "description": "A winter-themed EP with relaxing ambient tracks.",
    "tags": ["winter", "chill", "electronic", "ambient"],
    "credits": {
      "producer": "Frost Beats",
      "mixing": "Ice Studios",
      "mastering": "Northern Mastering"
    }
  }
}
```

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 125,
    "title": "Winter Chill",
    "type": "ep",
    "artist": "Frost Beats",
    "releaseDate": "2025-12-01",
    "status": "draft",
    "catalogueId": "TMCAT-87654-002",
    "primaryGenre": "chill",
    "secondaryGenres": ["electronic", "ambient"],
    "language": "english",
    "explicit": false,
    "ownership": "original",
    "metadata": {
      "description": "A winter-themed EP with relaxing ambient tracks.",
      "tags": ["winter", "chill", "electronic", "ambient"],
      "credits": {
        "producer": "Frost Beats",
        "mixing": "Ice Studios",
        "mastering": "Northern Mastering"
      }
    }
  }
}
```

##### Update a Release

```
PUT /releases/{releaseId}
```

Updates an existing release.

**Path Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `releaseId` | number | Release ID  |

**Request Body:**

```json
{
  "title": "Winter Chillout",
  "primaryGenre": "ambient",
  "secondaryGenres": ["chill", "electronic"],
  "metadata": {
    "description": "An updated winter-themed EP with relaxing ambient tracks.",
    "tags": ["winter", "ambient", "relaxing", "electronic"]
  }
}
```

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 125,
    "title": "Winter Chillout",
    "type": "ep",
    "artist": "Frost Beats",
    "releaseDate": "2025-12-01",
    "status": "draft",
    "catalogueId": "TMCAT-87654-002",
    "primaryGenre": "ambient",
    "secondaryGenres": ["chill", "electronic"],
    "language": "english",
    "explicit": false,
    "ownership": "original",
    "metadata": {
      "description": "An updated winter-themed EP with relaxing ambient tracks.",
      "tags": ["winter", "ambient", "relaxing", "electronic"],
      "credits": {
        "producer": "Frost Beats",
        "mixing": "Ice Studios",
        "mastering": "Northern Mastering"
      }
    }
  }
}
```

##### Delete a Release

```
DELETE /releases/{releaseId}
```

Deletes a release from your catalog.

**Path Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `releaseId` | number | Release ID  |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "message": "Release deleted successfully"
  }
}
```

##### List Tracks

```
GET /tracks
```

Returns a list of tracks in your catalog.

**Query Parameters:**

| Parameter    | Type   | Description |
|--------------|--------|-------------|
| `releaseId`  | number | Filter by release ID |
| `search`     | string | Search term for track title |
| `page`       | number | Page number for pagination |
| `limit`      | number | Results per page |
| `sort`       | string | Field to sort by (e.g., "title", "duration") |
| `order`      | string | Sort order ("asc" or "desc") |

**Response Example:**

```json
{
  "success": true,
  "data": [
    {
      "id": 456,
      "title": "Sunshine Groove",
      "releaseId": 123,
      "releaseName": "Summer Vibes",
      "artist": "DJ Harmony",
      "trackNumber": 1,
      "isrc": "USABC1234567",
      "duration": 210,
      "audioUrl": "https://assets.tunemantra.com/previews/456.mp3"
    },
    {
      "id": 457,
      "title": "Beach Party",
      "releaseId": 123,
      "releaseName": "Summer Vibes",
      "artist": "DJ Harmony",
      "trackNumber": 2,
      "isrc": "USABC1234568",
      "duration": 195,
      "audioUrl": "https://assets.tunemantra.com/previews/457.mp3"
    }
  ],
  "meta": {
    "total": 12,
    "page": 1,
    "limit": 25,
    "hasMore": false
  }
}
```

##### Get Track Details

```
GET /tracks/{trackId}
```

Returns detailed information about a specific track.

**Path Parameters:**

| Parameter | Type   | Description |
|-----------|--------|-------------|
| `trackId` | number | Track ID    |

**Query Parameters:**

| Parameter | Type   | Description |
|-----------|--------|-------------|
| `expand`  | string | Comma-separated list of related resources to expand (e.g., "release,analytics") |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 456,
    "title": "Sunshine Groove",
    "releaseId": 123,
    "releaseName": "Summer Vibes",
    "artist": "DJ Harmony",
    "featuredArtists": [],
    "trackNumber": 1,
    "isrc": "USABC1234567",
    "duration": 210,
    "bpm": 128,
    "key": "C Minor",
    "explicit": false,
    "lyrics": "Lyrics for Sunshine Groove...",
    "composers": ["DJ Harmony", "Alex Writer"],
    "producers": ["Alex Producer"],
    "audioUrl": "https://assets.tunemantra.com/previews/456.mp3",
    "metadata": {
      "mood": "energetic",
      "themes": ["summer", "beach", "party"],
      "instruments": ["synthesizer", "drums", "bass"],
      "recording": {
        "studio": "Harmony Studios",
        "date": "2024-12-15",
        "engineers": ["Sound Engineer"]
      }
    },
    "analytics": {
      "totalStreams": 250000,
      "topPlatforms": [
        {
          "name": "Spotify",
          "streams": 150000
        },
        {
          "name": "Apple Music",
          "streams": 75000
        },
        {
          "name": "Amazon Music",
          "streams": 25000
        }
      ],
      "topCountries": [
        {
          "country": "United States",
          "streams": 100000
        },
        {
          "country": "United Kingdom",
          "streams": 50000
        },
        {
          "country": "Germany",
          "streams": 30000
        }
      ]
    }
  }
}
```

##### Create a Track

```
POST /releases/{releaseId}/tracks
```

Adds a new track to a release.

**Path Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `releaseId` | number | Release ID  |

**Request Body:**

```json
{
  "title": "Icy Waves",
  "trackNumber": 1,
  "duration": 185,
  "explicit": false,
  "composers": ["Frost Beats", "Lyrical Ice"],
  "producers": ["Frost Beats"],
  "lyrics": "Lyrics for Icy Waves...",
  "metadata": {
    "mood": "relaxing",
    "themes": ["winter", "chill", "meditation"],
    "instruments": ["synthesizer", "piano", "ambient sounds"]
  }
}
```

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 458,
    "title": "Icy Waves",
    "releaseId": 125,
    "releaseName": "Winter Chillout",
    "artist": "Frost Beats",
    "featuredArtists": [],
    "trackNumber": 1,
    "duration": 185,
    "explicit": false,
    "composers": ["Frost Beats", "Lyrical Ice"],
    "producers": ["Frost Beats"],
    "lyrics": "Lyrics for Icy Waves...",
    "metadata": {
      "mood": "relaxing",
      "themes": ["winter", "chill", "meditation"],
      "instruments": ["synthesizer", "piano", "ambient sounds"]
    }
  }
}
```

#### Distribution

##### List Distribution Records

```
GET /distribution/records
```

Returns distribution records for your releases.

**Query Parameters:**

| Parameter    | Type   | Description |
|--------------|--------|-------------|
| `releaseId`  | number | Filter by release ID |
| `status`     | string | Filter by status (e.g., "pending", "distributed", "failed") |
| `platform`   | string | Filter by platform (e.g., "spotify", "apple") |
| `page`       | number | Page number for pagination |
| `limit`      | number | Results per page |
| `sort`       | string | Field to sort by (e.g., "createdAt", "status") |
| `order`      | string | Sort order ("asc" or "desc") |

**Response Example:**

```json
{
  "success": true,
  "data": [
    {
      "id": 789,
      "releaseId": 123,
      "releaseName": "Summer Vibes",
      "status": "distributed",
      "createdAt": "2025-05-01T12:00:00Z",
      "updatedAt": "2025-05-03T15:30:00Z",
      "platforms": [
        {
          "name": "Spotify",
          "status": "active",
          "url": "https://open.spotify.com/album/123456"
        },
        {
          "name": "Apple Music",
          "status": "active",
          "url": "https://music.apple.com/album/123456"
        }
      ]
    },
    {
      "id": 790,
      "releaseId": 124,
      "releaseName": "Midnight Dreams",
      "status": "pending",
      "createdAt": "2025-04-15T10:00:00Z",
      "updatedAt": "2025-04-15T10:00:00Z",
      "platforms": [
        {
          "name": "Spotify",
          "status": "pending",
          "url": null
        },
        {
          "name": "Apple Music",
          "status": "pending",
          "url": null
        }
      ]
    }
  ],
  "meta": {
    "total": 10,
    "page": 1,
    "limit": 25,
    "hasMore": false
  }
}
```

##### Get Distribution Record Details

```
GET /distribution/records/{recordId}
```

Returns detailed information about a specific distribution record.

**Path Parameters:**

| Parameter  | Type   | Description |
|------------|--------|-------------|
| `recordId` | number | Distribution record ID |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 789,
    "releaseId": 123,
    "releaseName": "Summer Vibes",
    "status": "distributed",
    "createdAt": "2025-05-01T12:00:00Z",
    "updatedAt": "2025-05-03T15:30:00Z",
    "distributions": [
      {
        "platform": "Spotify",
        "status": "active",
        "referenceId": "SP12345",
        "url": "https://open.spotify.com/album/123456",
        "submittedAt": "2025-05-01T12:00:00Z",
        "processedAt": "2025-05-02T09:45:00Z",
        "availableAt": "2025-05-03T00:00:00Z"
      },
      {
        "platform": "Apple Music",
        "status": "active",
        "referenceId": "AM67890",
        "url": "https://music.apple.com/album/123456",
        "submittedAt": "2025-05-01T12:00:00Z",
        "processedAt": "2025-05-02T14:30:00Z",
        "availableAt": "2025-05-03T00:00:00Z"
      },
      {
        "platform": "Amazon Music",
        "status": "active",
        "referenceId": "AZ24680",
        "url": "https://music.amazon.com/albums/123456",
        "submittedAt": "2025-05-01T12:00:00Z",
        "processedAt": "2025-05-02T11:15:00Z",
        "availableAt": "2025-05-03T00:00:00Z"
      },
      {
        "platform": "YouTube Music",
        "status": "processing",
        "referenceId": "YT13579",
        "url": null,
        "submittedAt": "2025-05-01T12:00:00Z",
        "processedAt": null,
        "availableAt": null
      }
    ],
    "history": [
      {
        "timestamp": "2025-05-01T12:00:00Z",
        "action": "created",
        "details": "Distribution submitted for 4 platforms"
      },
      {
        "timestamp": "2025-05-02T09:45:00Z",
        "action": "platform_update",
        "details": "Spotify status changed to 'processing'"
      },
      {
        "timestamp": "2025-05-02T11:15:00Z",
        "action": "platform_update",
        "details": "Amazon Music status changed to 'processing'"
      },
      {
        "timestamp": "2025-05-02T14:30:00Z",
        "action": "platform_update",
        "details": "Apple Music status changed to 'processing'"
      },
      {
        "timestamp": "2025-05-03T00:00:00Z",
        "action": "platform_update",
        "details": "Spotify status changed to 'active'"
      },
      {
        "timestamp": "2025-05-03T00:00:00Z",
        "action": "platform_update",
        "details": "Apple Music status changed to 'active'"
      },
      {
        "timestamp": "2025-05-03T00:00:00Z",
        "action": "platform_update",
        "details": "Amazon Music status changed to 'active'"
      }
    ]
  }
}
```

##### Distribute a Release

```
POST /distribution/distribute
```

Submits a release for distribution to specified platforms.

**Request Body:**

```json
{
  "releaseId": 125,
  "platforms": ["spotify", "apple_music", "amazon_music", "youtube_music"],
  "scheduledDate": "2025-12-01T00:00:00Z"
}
```

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 791,
    "releaseId": 125,
    "releaseName": "Winter Chillout",
    "status": "scheduled",
    "scheduledDate": "2025-12-01T00:00:00Z",
    "createdAt": "2025-06-15T14:30:00Z",
    "platforms": [
      {
        "name": "Spotify",
        "status": "scheduled"
      },
      {
        "name": "Apple Music",
        "status": "scheduled"
      },
      {
        "name": "Amazon Music",
        "status": "scheduled"
      },
      {
        "name": "YouTube Music",
        "status": "scheduled"
      }
    ]
  }
}
```

##### List Available Distribution Platforms

```
GET /distribution/platforms
```

Returns a list of available distribution platforms.

**Response Example:**

```json
{
  "success": true,
  "data": [
    {
      "id": "spotify",
      "name": "Spotify",
      "description": "World's largest music streaming platform.",
      "logoUrl": "https://assets.tunemantra.com/platforms/spotify.png"
    },
    {
      "id": "apple_music",
      "name": "Apple Music",
      "description": "Apple's music streaming service.",
      "logoUrl": "https://assets.tunemantra.com/platforms/apple_music.png"
    },
    {
      "id": "amazon_music",
      "name": "Amazon Music",
      "description": "Amazon's music streaming service.",
      "logoUrl": "https://assets.tunemantra.com/platforms/amazon_music.png"
    },
    {
      "id": "youtube_music",
      "name": "YouTube Music",
      "description": "Google's music streaming service.",
      "logoUrl": "https://assets.tunemantra.com/platforms/youtube_music.png"
    },
    {
      "id": "tidal",
      "name": "TIDAL",
      "description": "High-fidelity music streaming platform.",
      "logoUrl": "https://assets.tunemantra.com/platforms/tidal.png"
    }
  ]
}
```

#### Analytics

##### Get Analytics Overview

```
GET /analytics/overview
```

Returns an overview of analytics across your entire catalog.

**Query Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `startDate` | string | Start date for the analytics period (format: YYYY-MM-DD) |
| `endDate`   | string | End date for the analytics period (format: YYYY-MM-DD) |
| `compare`   | string | Compare with previous period ("true" or "false") |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "period": {
      "start": "2025-01-01",
      "end": "2025-03-31"
    },
    "overview": {
      "totalStreams": 1250000,
      "totalRevenue": 5000.75,
      "change": {
        "streams": {
          "value": 250000,
          "percentage": 25
        },
        "revenue": {
          "value": 1200.25,
          "percentage": 31.5
        }
      }
    },
    "platforms": [
      {
        "name": "Spotify",
        "streams": 750000,
        "revenue": 3000.50,
        "percentage": 60
      },
      {
        "name": "Apple Music",
        "streams": 300000,
        "revenue": 1500.25,
        "percentage": 24
      },
      {
        "name": "Amazon Music",
        "streams": 125000,
        "revenue": 375.00,
        "percentage": 10
      },
      {
        "name": "Others",
        "streams": 75000,
        "revenue": 125.00,
        "percentage": 6
      }
    ],
    "geography": [
      {
        "country": "United States",
        "streams": 500000,
        "revenue": 2500.50,
        "percentage": 40
      },
      {
        "country": "United Kingdom",
        "streams": 200000,
        "revenue": 1000.25,
        "percentage": 16
      },
      {
        "country": "Germany",
        "streams": 125000,
        "revenue": 625.00,
        "percentage": 10
      },
      {
        "country": "Others",
        "streams": 425000,
        "revenue": 875.00,
        "percentage": 34
      }
    ],
    "trend": {
      "streams": [
        {"date": "2025-01-01", "value": 10000},
        {"date": "2025-01-08", "value": 12500},
        {"date": "2025-01-15", "value": 15000},
        {"date": "2025-01-22", "value": 12000},
        {"date": "2025-01-29", "value": 13500},
        {"date": "2025-02-05", "value": 14000},
        {"date": "2025-02-12", "value": 16500},
        {"date": "2025-02-19", "value": 18000},
        {"date": "2025-02-26", "value": 20000},
        {"date": "2025-03-05", "value": 22500},
        {"date": "2025-03-12", "value": 21000},
        {"date": "2025-03-19", "value": 25000},
        {"date": "2025-03-26", "value": 27500}
      ],
      "revenue": [
        {"date": "2025-01-01", "value": 40.00},
        {"date": "2025-01-08", "value": 50.25},
        {"date": "2025-01-15", "value": 60.50},
        {"date": "2025-01-22", "value": 48.00},
        {"date": "2025-01-29", "value": 54.75},
        {"date": "2025-02-05", "value": 56.00},
        {"date": "2025-02-12", "value": 66.25},
        {"date": "2025-02-19", "value": 72.00},
        {"date": "2025-02-26", "value": 80.00},
        {"date": "2025-03-05", "value": 90.25},
        {"date": "2025-03-12", "value": 84.00},
        {"date": "2025-03-19", "value": 100.00},
        {"date": "2025-03-26", "value": 110.50}
      ]
    }
  }
}
```

##### Get Release Analytics

```
GET /analytics/releases/{releaseId}
```

Returns detailed analytics for a specific release.

**Path Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `releaseId` | number | Release ID  |

**Query Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `startDate` | string | Start date for the analytics period (format: YYYY-MM-DD) |
| `endDate`   | string | End date for the analytics period (format: YYYY-MM-DD) |
| `granularity` | string | Data granularity ("day", "week", "month") |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "release": {
      "id": 123,
      "title": "Summer Vibes",
      "artist": "DJ Harmony",
      "releaseDate": "2025-06-15"
    },
    "period": {
      "start": "2025-06-15",
      "end": "2025-09-15"
    },
    "overview": {
      "totalStreams": 500000,
      "totalRevenue": 2000.50,
      "avgStreamsPerDay": 5435
    },
    "platforms": [
      {
        "name": "Spotify",
        "streams": 300000,
        "revenue": 1200.30,
        "percentage": 60
      },
      {
        "name": "Apple Music",
        "streams": 125000,
        "revenue": 625.15,
        "percentage": 25
      },
      {
        "name": "Amazon Music",
        "streams": 50000,
        "revenue": 150.05,
        "percentage": 10
      },
      {
        "name": "Others",
        "streams": 25000,
        "revenue": 25.00,
        "percentage": 5
      }
    ],
    "geography": [
      {
        "country": "United States",
        "streams": 200000,
        "revenue": 1000.25,
        "percentage": 40
      },
      {
        "country": "United Kingdom",
        "streams": 75000,
        "revenue": 375.10,
        "percentage": 15
      },
      {
        "country": "Germany",
        "streams": 50000,
        "revenue": 250.05,
        "percentage": 10
      },
      {
        "country": "Others",
        "streams": 175000,
        "revenue": 375.10,
        "percentage": 35
      }
    ],
    "tracks": [
      {
        "id": 456,
        "title": "Sunshine Groove",
        "streams": 150000,
        "revenue": 600.15,
        "percentage": 30
      },
      {
        "id": 457,
        "title": "Beach Party",
        "streams": 125000,
        "revenue": 500.10,
        "percentage": 25
      }
    ],
    "trend": {
      "data": [
        {"date": "2025-06-15", "value": 5000},
        {"date": "2025-06-22", "value": 15000},
        {"date": "2025-06-29", "value": 25000},
        {"date": "2025-07-06", "value": 30000},
        {"date": "2025-07-13", "value": 45000},
        {"date": "2025-07-20", "value": 50000},
        {"date": "2025-07-27", "value": 60000},
        {"date": "2025-08-03", "value": 55000},
        {"date": "2025-08-10", "value": 50000},
        {"date": "2025-08-17", "value": 45000},
        {"date": "2025-08-24", "value": 40000},
        {"date": "2025-08-31", "value": 35000},
        {"date": "2025-09-07", "value": 25000},
        {"date": "2025-09-14", "value": 20000}
      ]
    }
  }
}
```

#### Royalties

##### Get Royalty Overview

```
GET /royalties/overview
```

Returns an overview of royalty data across your catalog.

**Query Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `startDate` | string | Start date for the royalty period (format: YYYY-MM-DD) |
| `endDate`   | string | End date for the royalty period (format: YYYY-MM-DD) |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "period": {
      "start": "2025-01-01",
      "end": "2025-03-31"
    },
    "overview": {
      "totalEarnings": 5000.75,
      "pendingBalance": 3500.50,
      "withdrawnAmount": 1500.25,
      "nextPaymentEstimate": 1000.00
    },
    "sources": [
      {
        "platform": "Spotify",
        "amount": 3000.50,
        "percentage": 60
      },
      {
        "platform": "Apple Music",
        "amount": 1500.25,
        "percentage": 30
      },
      {
        "platform": "Others",
        "amount": 500.00,
        "percentage": 10
      }
    ],
    "releases": [
      {
        "id": 123,
        "title": "Summer Vibes",
        "amount": 2500.35,
        "percentage": 50
      },
      {
        "id": 124,
        "title": "Midnight Dreams",
        "amount": 1500.20,
        "percentage": 30
      },
      {
        "id": 125,
        "title": "Winter Chillout",
        "amount": 1000.20,
        "percentage": 20
      }
    ],
    "trend": {
      "data": [
        {"date": "2025-01", "value": 1500.25},
        {"date": "2025-02", "value": 1750.30},
        {"date": "2025-03", "value": 1750.20}
      ]
    }
  }
}
```

##### List Royalty Splits

```
GET /royalties/splits
```

Returns a list of royalty splits for your catalog.

**Query Parameters:**

| Parameter    | Type   | Description |
|--------------|--------|-------------|
| `releaseId`  | number | Filter by release ID |
| `trackId`    | number | Filter by track ID |
| `page`       | number | Page number for pagination |
| `limit`      | number | Results per page |

**Response Example:**

```json
{
  "success": true,
  "data": [
    {
      "id": 201,
      "releaseId": 123,
      "releaseName": "Summer Vibes",
      "trackId": null,
      "effectiveDate": "2025-06-15",
      "recipients": [
        {
          "name": "DJ Harmony",
          "role": "Artist",
          "percentage": 70
        },
        {
          "name": "Harmony Records",
          "role": "Label",
          "percentage": 20
        },
        {
          "name": "Alex Producer",
          "role": "Producer",
          "percentage": 10
        }
      ]
    },
    {
      "id": 202,
      "releaseId": 123,
      "releaseName": "Summer Vibes",
      "trackId": 456,
      "trackName": "Sunshine Groove",
      "effectiveDate": "2025-06-15",
      "recipients": [
        {
          "name": "DJ Harmony",
          "role": "Artist",
          "percentage": 60
        },
        {
          "name": "Harmony Records",
          "role": "Label",
          "percentage": 20
        },
        {
          "name": "Alex Producer",
          "role": "Producer",
          "percentage": 10
        },
        {
          "name": "Alex Writer",
          "role": "Songwriter",
          "percentage": 10
        }
      ]
    }
  ],
  "meta": {
    "total": 5,
    "page": 1,
    "limit": 25,
    "hasMore": false
  }
}
```

##### Create Royalty Split

```
POST /royalties/splits
```

Creates a new royalty split configuration.

**Request Body:**

```json
{
  "releaseId": 125,
  "trackId": null,
  "effectiveDate": "2025-12-01",
  "recipients": [
    {
      "name": "Frost Beats",
      "role": "Artist",
      "percentage": 75
    },
    {
      "name": "Winter Records",
      "role": "Label",
      "percentage": 15
    },
    {
      "name": "Lyrical Ice",
      "role": "Songwriter",
      "percentage": 10
    }
  ]
}
```

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 203,
    "releaseId": 125,
    "releaseName": "Winter Chillout",
    "trackId": null,
    "effectiveDate": "2025-12-01",
    "recipients": [
      {
        "name": "Frost Beats",
        "role": "Artist",
        "percentage": 75
      },
      {
        "name": "Winter Records",
        "role": "Label",
        "percentage": 15
      },
      {
        "name": "Lyrical Ice",
        "role": "Songwriter",
        "percentage": 10
      }
    ]
  }
}
```

##### Get Royalty Statements

```
GET /royalties/statements
```

Returns a list of royalty statements.

**Query Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `startDate` | string | Filter by statement date start (format: YYYY-MM-DD) |
| `endDate`   | string | Filter by statement date end (format: YYYY-MM-DD) |
| `page`      | number | Page number for pagination |
| `limit`     | number | Results per page |

**Response Example:**

```json
{
  "success": true,
  "data": [
    {
      "id": 301,
      "period": "2025-Q1",
      "startDate": "2025-01-01",
      "endDate": "2025-03-31",
      "totalAmount": 5000.75,
      "status": "paid",
      "pdfUrl": "https://assets.tunemantra.com/statements/301.pdf",
      "paidDate": "2025-04-15"
    },
    {
      "id": 302,
      "period": "2025-Q2",
      "startDate": "2025-04-01",
      "endDate": "2025-06-30",
      "totalAmount": 6500.50,
      "status": "pending",
      "pdfUrl": "https://assets.tunemantra.com/statements/302.pdf",
      "paidDate": null
    }
  ],
  "meta": {
    "total": 2,
    "page": 1,
    "limit": 25,
    "hasMore": false
  }
}
```

##### Get Statement Details

```
GET /royalties/statements/{statementId}
```

Returns detailed information about a specific royalty statement.

**Path Parameters:**

| Parameter     | Type   | Description |
|---------------|--------|-------------|
| `statementId` | number | Statement ID |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 301,
    "period": "2025-Q1",
    "startDate": "2025-01-01",
    "endDate": "2025-03-31",
    "totalAmount": 5000.75,
    "status": "paid",
    "pdfUrl": "https://assets.tunemantra.com/statements/301.pdf",
    "paidDate": "2025-04-15",
    "lineItems": [
      {
        "releaseId": 123,
        "releaseName": "Summer Vibes",
        "platform": "Spotify",
        "streams": 300000,
        "amount": 1800.25
      },
      {
        "releaseId": 123,
        "releaseName": "Summer Vibes",
        "platform": "Apple Music",
        "streams": 125000,
        "amount": 937.50
      },
      {
        "releaseId": 124,
        "releaseName": "Midnight Dreams",
        "platform": "Spotify",
        "streams": 150000,
        "amount": 900.00
      },
      {
        "releaseId": 124,
        "releaseName": "Midnight Dreams",
        "platform": "Apple Music",
        "streams": 75000,
        "amount": 563.00
      },
      {
        "releaseId": 123,
        "releaseName": "Summer Vibes",
        "platform": "Amazon Music",
        "streams": 50000,
        "amount": 375.00
      },
      {
        "releaseId": 124,
        "releaseName": "Midnight Dreams",
        "platform": "Amazon Music",
        "streams": 25000,
        "amount": 187.50
      },
      {
        "releaseId": 123,
        "releaseName": "Summer Vibes",
        "platform": "YouTube Music",
        "streams": 25000,
        "amount": 137.50
      },
      {
        "releaseId": 124,
        "releaseName": "Midnight Dreams",
        "platform": "YouTube Music",
        "streams": 20000,
        "amount": 100.00
      }
    ]
  }
}
```

### Error Codes

| Code                   | Description |
|------------------------|-------------|
| `AUTHENTICATION_ERROR` | Authentication failed or invalid API key |
| `AUTHORIZATION_ERROR`  | Insufficient permissions for the requested action |
| `RESOURCE_NOT_FOUND`   | The requested resource does not exist |
| `VALIDATION_ERROR`     | Invalid request parameters or body |
| `RATE_LIMIT_EXCEEDED`  | API rate limit has been exceeded |
| `INTERNAL_SERVER_ERROR`| An unexpected error occurred on the server |
| `DISTRIBUTION_ERROR`   | An error occurred during the distribution process |
| `RESOURCE_CONFLICT`    | The request conflicts with the current state of the resource |

### SDKs and Libraries

TuneMantra provides official SDKs for common programming languages:

- [JavaScript/TypeScript](https://github.com/tunemantra/tunemantra-js)
- [Python](https://github.com/tunemantra/tunemantra-python)
- [PHP](https://github.com/tunemantra/tunemantra-php)
- [Ruby](https://github.com/tunemantra/tunemantra-ruby)

### Webhooks

TuneMantra can send webhook notifications for important events. Configure webhooks in your account settings.

#### Available Webhook Events

- `release.created` - A new release has been created
- `release.updated` - A release has been updated
- `release.deleted` - A release has been deleted
- `distribution.submitted` - A release has been submitted for distribution
- `distribution.status_change` - Distribution status has changed
- `platform.status_change` - Platform-specific status has changed
- `royalty.statement_generated` - A new royalty statement has been generated
- `royalty.payment_processed` - A royalty payment has been processed

#### Webhook Payload Example

```json
{
  "event": "distribution.status_change",
  "timestamp": "2025-05-03T15:30:00Z",
  "data": {
    "distributionId": 789,
    "releaseId": 123,
    "releaseName": "Summer Vibes",
    "previousStatus": "processing",
    "newStatus": "distributed",
    "platforms": [
      {
        "name": "Spotify",
        "status": "active"
      },
      {
        "name": "Apple Music",
        "status": "active"
      },
      {
        "name": "Amazon Music",
        "status": "active"
      }
    ]
  }
}
```

### Conclusion

This API reference provides a comprehensive overview of the TuneMantra API. For additional support, example code, or specific use cases, please visit the [Developer Portal](https://developers.tunemantra.com) or contact our support team.

**Last Updated**: March 18, 2025

---

#### 2025-03-17: Payment System API Reference
_Source: unified_documentation/api-reference/17032025-payment-api-reference.md (Branch: 17032025)_


### Overview

This document provides a comprehensive reference for all payment-related API endpoints in the TuneMantra platform. These APIs enable payment method management, withdrawal requests, and revenue split configuration.

### Base URL

All API endpoints are relative to your Replit instance URL:

```
https://your-instance.replit.app/api
```

### Authentication

All payment API endpoints require authentication. Include a valid session cookie with your requests, which is obtained after successful login.

### API Endpoints

#### Payment Methods

##### List Payment Methods

Retrieves all payment methods for the authenticated user.

```
GET /payment-methods
```

**Response**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "type": "bank_account",
      "lastFour": "1234",
      "details": {
        "accountName": "John Doe",
        "bankName": "Example Bank",
        "accountType": "checking"
      },
      "isDefault": true,
      "createdAt": "2025-02-15T08:30:00Z"
    },
    {
      "id": 2,
      "type": "card",
      "lastFour": "5678",
      "details": {
        "cardType": "visa",
        "expiryMonth": 12,
        "expiryYear": 2026,
        "cardholderName": "John Doe"
      },
      "isDefault": false,
      "createdAt": "2025-02-16T10:15:00Z"
    }
  ]
}
```

##### Add Payment Method

Creates a new payment method for the authenticated user.

```
POST /payment-methods
```

**Request Body**

```json
{
  "type": "bank_account",
  "lastFour": "1234",
  "details": {
    "accountName": "John Doe",
    "bankName": "Example Bank",
    "accountType": "checking",
    "routingNumber": "123456789"
  },
  "isDefault": true
}
```

**Response**

```json
{
  "success": true,
  "data": {
    "id": 3,
    "type": "bank_account",
    "lastFour": "1234",
    "details": {
      "accountName": "John Doe",
      "bankName": "Example Bank",
      "accountType": "checking"
    },
    "isDefault": true,
    "createdAt": "2025-03-01T14:22:30Z"
  }
}
```

##### Delete Payment Method

Deletes a payment method belonging to the authenticated user.

```
DELETE /payment-methods/:id
```

**Parameters**

- `id`: The ID of the payment method to delete

**Response**

```json
{
  "success": true,
  "message": "Payment method deleted successfully"
}
```

#### Withdrawals

##### List Withdrawals

Retrieves all withdrawals for the authenticated user.

```
GET /withdrawals
```

**Query Parameters**

- `status` (optional): Filter by status (`pending`, `completed`, `rejected`)
- `limit` (optional): Maximum number of records to return
- `offset` (optional): Number of records to skip

**Response**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "paymentMethodId": 1,
      "amount": "500.00",
      "currency": "USD",
      "status": "completed",
      "notes": "Monthly withdrawal",
      "referenceNumber": "WD123456",
      "createdAt": "2025-02-20T09:30:00Z",
      "processedAt": "2025-02-21T11:45:00Z",
      "paymentMethod": {
        "type": "bank_account",
        "lastFour": "1234"
      }
    },
    {
      "id": 2,
      "paymentMethodId": 1,
      "amount": "750.00",
      "currency": "USD",
      "status": "pending",
      "notes": "Quarterly bonus",
      "createdAt": "2025-03-01T14:22:30Z",
      "paymentMethod": {
        "type": "bank_account",
        "lastFour": "1234"
      }
    }
  ],
  "pagination": {
    "total": 2,
    "limit": 10,
    "offset": 0
  }
}
```

##### Request Withdrawal

Creates a new withdrawal request for the authenticated user.

```
POST /withdrawals
```

**Request Body**

```json
{
  "paymentMethodId": 1,
  "amount": 1000.00,
  "currency": "USD",
  "notes": "March income withdrawal"
}
```

**Response**

```json
{
  "success": true,
  "data": {
    "id": 3,
    "paymentMethodId": 1,
    "amount": "1000.00",
    "currency": "USD",
    "status": "pending",
    "notes": "March income withdrawal",
    "createdAt": "2025-03-04T15:30:00Z",
    "paymentMethod": {
      "type": "bank_account",
      "lastFour": "1234"
    }
  }
}
```

##### Get Withdrawal Details

Retrieves details of a specific withdrawal.

```
GET /withdrawals/:id
```

**Parameters**

- `id`: The ID of the withdrawal to retrieve

**Response**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "paymentMethodId": 1,
    "amount": "500.00",
    "currency": "USD",
    "status": "completed",
    "notes": "Monthly withdrawal",
    "referenceNumber": "WD123456",
    "createdAt": "2025-02-20T09:30:00Z",
    "processedAt": "2025-02-21T11:45:00Z",
    "paymentMethod": {
      "type": "bank_account",
      "lastFour": "1234",
      "details": {
        "accountName": "John Doe",
        "bankName": "Example Bank"
      }
    }
  }
}
```

#### Revenue Splits

##### Get Revenue Splits

Retrieves revenue split configurations for the authenticated user.

```
GET /revenue-splits
```

**Response**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "Album Collaboration",
      "splits": [
        {
          "artistName": "Primary Artist",
          "artistId": 101,
          "role": "Artist",
          "percentage": 70
        },
        {
          "artistName": "Featured Artist",
          "artistId": 102,
          "role": "Feature",
          "percentage": 20
        },
        {
          "artistName": "Producer",
          "artistId": 103,
          "role": "Producer",
          "percentage": 10
        }
      ],
      "createdAt": "2025-02-10T09:30:00Z",
      "updatedAt": "2025-02-10T09:30:00Z"
    }
  ]
}
```

##### Create Revenue Split

Creates a new revenue split configuration.

```
POST /revenue-splits
```

**Request Body**

```json
{
  "title": "EP Collaboration",
  "splits": [
    {
      "artistName": "Primary Artist",
      "artistId": 101,
      "role": "Artist",
      "percentage": 60
    },
    {
      "artistName": "Featured Artist",
      "artistId": 102,
      "role": "Feature",
      "percentage": 25
    },
    {
      "artistName": "Producer",
      "artistId": 103,
      "role": "Producer",
      "percentage": 15
    }
  ]
}
```

**Response**

```json
{
  "success": true,
  "data": {
    "id": 2,
    "title": "EP Collaboration",
    "splits": [
      {
        "artistName": "Primary Artist",
        "artistId": 101,
        "role": "Artist",
        "percentage": 60
      },
      {
        "artistName": "Featured Artist",
        "artistId": 102,
        "role": "Feature",
        "percentage": 25
      },
      {
        "artistName": "Producer",
        "artistId": 103,
        "role": "Producer",
        "percentage": 15
      }
    ],
    "createdAt": "2025-03-04T15:45:00Z",
    "updatedAt": "2025-03-04T15:45:00Z"
  }
}
```

##### Update Revenue Split

Updates an existing revenue split configuration.

```
PUT /revenue-splits/:id
```

**Parameters**

- `id`: The ID of the revenue split to update

**Request Body**

```json
{
  "title": "EP Collaboration (Revised)",
  "splits": [
    {
      "artistName": "Primary Artist",
      "artistId": 101,
      "role": "Artist",
      "percentage": 55
    },
    {
      "artistName": "Featured Artist",
      "artistId": 102,
      "role": "Feature",
      "percentage": 25
    },
    {
      "artistName": "Producer",
      "artistId": 103,
      "role": "Producer",
      "percentage": 15
    },
    {
      "artistName": "Mixing Engineer",
      "artistId": 104,
      "role": "Engineer",
      "percentage": 5
    }
  ]
}
```

**Response**

```json
{
  "success": true,
  "data": {
    "id": 2,
    "title": "EP Collaboration (Revised)",
    "splits": [
      {
        "artistName": "Primary Artist",
        "artistId": 101,
        "role": "Artist",
        "percentage": 55
      },
      {
        "artistName": "Featured Artist",
        "artistId": 102,
        "role": "Feature",
        "percentage": 25
      },
      {
        "artistName": "Producer",
        "artistId": 103,
        "role": "Producer",
        "percentage": 15
      },
      {
        "artistName": "Mixing Engineer",
        "artistId": 104,
        "role": "Engineer",
        "percentage": 5
      }
    ],
    "createdAt": "2025-03-04T15:45:00Z",
    "updatedAt": "2025-03-04T16:30:00Z"
  }
}
```

##### Delete Revenue Split

Deletes a revenue split configuration.

```
DELETE /revenue-splits/:id
```

**Parameters**

- `id`: The ID of the revenue split to delete

**Response**

```json
{
  "success": true,
  "message": "Revenue split deleted successfully"
}
```

#### Subscription Management

##### Create Subscription

Creates a subscription checkout session.

```
POST /create-subscription
```

**Request Body**

```json
{
  "planType": "artist"
}
```

**Response**

```json
{
  "success": true,
  "data": {
    "orderId": "order_ABC123XYZ",
    "amount": 1999,
    "currency": "INR",
    "keyId": "rzp_test_abcdefghijklmn"
  }
}
```

##### Verify Payment

Verifies a payment after checkout completion.

```
POST /verify-payment
```

**Request Body**

```json
{
  "orderId": "order_ABC123XYZ",
  "paymentId": "pay_DEF456UVW",
  "signature": "abcdef1234567890abcdef1234567890abcdef",
  "planType": "artist"
}
```

**Response**

```json
{
  "success": true,
  "message": "Payment verified successfully",
  "data": {
    "subscriptionInfo": {
      "plan": "artist",
      "status": "pending_approval",
      "startDate": "2025-03-04T16:45:00Z",
      "endDate": "2026-03-04T16:45:00Z"
    }
  }
}
```

##### Cancel Subscription

Cancels the user's active subscription.

```
POST /cancel-subscription
```

**Response**

```json
{
  "success": true,
  "message": "Subscription cancelled successfully",
  "data": {
    "subscriptionInfo": {
      "plan": "artist",
      "status": "canceled",
      "startDate": "2025-03-04T16:45:00Z",
      "endDate": "2026-03-04T16:45:00Z",
      "cancelledAt": "2025-03-04T17:00:00Z"
    }
  }
}
```

##### Get Subscription Status

Retrieves the current subscription status for the authenticated user.

```
GET /subscription-status
```

**Response**

```json
{
  "success": true,
  "data": {
    "subscriptionInfo": {
      "plan": "artist",
      "status": "active",
      "startDate": "2025-03-04T16:45:00Z",
      "endDate": "2026-03-04T16:45:00Z",
      "features": [
        "distribution_to_all_platforms",
        "advanced_analytics",
        "royalty_management"
      ]
    }
  }
}
```

### Error Responses

All API endpoints return appropriate HTTP status codes and a standardized error response format:

```json
{
  "success": false,
  "error": {
    "code": "INVALID_REQUEST",
    "message": "The request contains invalid parameters",
    "details": {
      "field": "amount",
      "issue": "Amount must be greater than zero"
    }
  }
}
```

#### Common Error Codes

- `UNAUTHORIZED`: Authentication is required or has failed
- `FORBIDDEN`: The authenticated user does not have permission for this action
- `NOT_FOUND`: The requested resource was not found
- `INVALID_REQUEST`: The request contains invalid parameters
- `VALIDATION_ERROR`: The request data failed validation
- `INSUFFICIENT_FUNDS`: The user has insufficient funds for the requested withdrawal
- `PAYMENT_ERROR`: An error occurred during payment processing
- `INTERNAL_ERROR`: An internal server error has occurred

### Rate Limiting

API requests are subject to rate limiting to prevent abuse. Current limits are:

- Standard users: 60 requests per minute
- API users with key: 120 requests per minute

When a rate limit is exceeded, the API will respond with HTTP status 429 (Too Many Requests).

### Versioning

The current API version is v1. The version is implicit in the current implementation but may be explicitly required in future updates.

### Testing

For testing payment flows in development environments, use the Razorpay test credentials provided by the Razorpay dashboard.

### Webhooks

Webhooks for payment notifications are available at:

```
POST /api/payment/webhook
```

Webhooks require signature verification using the Razorpay webhook secret.

### Further Information

For implementation details, see:
- [Payment Implementation Guide](../guides/payment-implementation-guide.md)
- [Payment System Architecture](../architecture/PAYMENT_SYSTEM_ARCHITECTURE.md)

---

#### 2025-03-17: TuneMantra Technical Architecture
_Source: unified_documentation/architecture/17032025-technical-architecture.md (Branch: 17032025)_


**Version: 1.0 | Last Updated: March 18, 2025**

### Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [System Components](#system-components)
3. [Data Architecture](#data-architecture)
4. [Security Architecture](#security-architecture)
5. [Integration Architecture](#integration-architecture)
6. [Application Architecture](#application-architecture)
7. [Deployment Architecture](#deployment-architecture)
8. [Performance Considerations](#performance-considerations)
9. [Scalability Strategy](#scalability-strategy)
10. [Technical Debt Management](#technical-debt-management)
11. [Development Workflow](#development-workflow)
12. [References and Resources](#references-and-resources)

### Architecture Overview

TuneMantra employs a modern, scalable architecture designed to handle the complex requirements of music distribution, royalty management, and analytics. The system follows a full-stack TypeScript approach with a clear separation of concerns and robust type safety throughout.

#### Architectural Principles

TuneMantra's architecture is guided by these core principles:

1. **Separation of Concerns**: Clear boundaries between system components
2. **Type Safety**: Comprehensive TypeScript typing throughout the codebase
3. **API-First Design**: All functionality accessible via well-defined APIs
4. **Data Integrity**: Strong validation and consistency controls
5. **Scalability**: Designed for horizontal scaling under load
6. **Security by Design**: Security considerations at every level

#### High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    Client Applications                       │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐ │
│  │React Web UI│  │Mobile Apps│  │ API Clients│  │  Admin UI │ │
│  └─────┬─────┘  └─────┬─────┘  └─────┬─────┘  └─────┬─────┘ │
└────────┼──────────────┼──────────────┼──────────────┼───────┘
         │              │              │              │
         ▼              ▼              ▼              ▼
┌─────────────────────────────────────────────────────────────┐
│                  API Gateway & Authentication                │
└────────────────────────────────┬────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────┐
│                       Application Layer                      │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐ │
│  │Distribution│  │  Royalty  │  │ Analytics │  │  Content  │ │
│  │  Service   │  │  Service  │  │  Service  │  │  Service  │ │
│  └─────┬─────┘  └─────┬─────┘  └─────┬─────┘  └─────┬─────┘ │
│        │              │              │              │       │
│  ┌─────▼─────┐  ┌─────▼─────┐  ┌─────▼─────┐  ┌─────▼─────┐ │
│  │   Rights   │  │ Blockchain │  │    AI     │  │   User    │ │
│  │  Service   │  │  Service   │  │  Service  │  │  Service  │ │
│  └───────────┘  └───────────┘  └───────────┘  └───────────┘ │
└────────────────────────────────┬────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────┐
│                        Storage Layer                         │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐ │
│  │PostgreSQL │  │  Object   │  │   Cache   │  │   Search  │ │
│  │ Database  │  │  Storage  │  │  (Redis)  │  │  (Elastic)│ │
│  └───────────┘  └───────────┘  └───────────┘  └───────────┘ │
└─────────────────────────────────────────────────────────────┘
```

#### Technology Stack

TuneMantra utilizes a modern, TypeScript-based technology stack:

**Frontend**:
- React 18.x for UI components
- Tailwind CSS with shadcn/ui for styling
- Tanstack Query for server state management
- Zod for validation
- Chart.js for data visualization
- Wouter for client-side routing

**Backend**:
- Node.js with Express for API server
- TypeScript for type safety
- Drizzle ORM for database interactions
- PostgreSQL with JSONB for data storage
- JWT and session-based authentication
- OpenAPI for API documentation

**Infrastructure**:
- Docker for containerization
- CI/CD pipeline for automated deployments
- AWS for cloud hosting (or equivalent)
- S3-compatible storage for media files
- Redis for caching and session storage

### System Components

TuneMantra is composed of several specialized components, each responsible for specific aspects of the platform's functionality.

#### User Management System

The user management system handles authentication, authorization, and user data management.

**Key Components**:
- User registration and authentication
- Role-based access control
- Multi-factor authentication
- User profile management
- Team and collaboration features
- API key management

**Implementation Details**:
- Session-based authentication using Express sessions
- Password hashing with bcrypt
- JWT for API authentication
- Role-based middleware for access control
- PostgreSQL for user data storage

#### Content Management System

The content management system provides functionality for managing music releases, tracks, and metadata.

**Key Components**:
- Release management
- Track management
- Metadata handling
- Audio file processing
- Artwork management
- Content validation

**Implementation Details**:
- PostgreSQL with JSONB for flexible metadata storage
- S3-compatible storage for audio and image files
- Audio processing library for format validation
- Image processing for artwork manipulation
- Metadata validation using Zod schemas

#### Distribution System

The distribution system manages the process of delivering content to streaming platforms and tracking distribution status.

**Key Components**:
- Platform configuration
- Distribution workflow
- Status tracking
- Error handling and retry mechanism
- Export generation
- Scheduled releases

**Implementation Details**:
- Platform-specific export generators
- JSONB status storage for flexible platform data
- Queuing system for distribution processing
- Automatic retry system with exponential backoff
- Scheduled job processor for timed distributions

#### Analytics Engine

The analytics engine collects, processes, and presents performance data across platforms.

**Key Components**:
- Data collection from multiple sources
- Data normalization and aggregation
- Performance metrics calculation
- Visualization components
- Report generation
- Custom analytics queries

**Implementation Details**:
- ETL processes for platform data
- Data warehouse for analytics storage
- Aggregation pipelines for metric calculation
- Chart.js for frontend visualization
- PDF generation for report export
- Caching for performance optimization

#### Royalty Management System

The royalty management system tracks, calculates, and distributes revenue shares.

**Key Components**:
- Split configuration
- Revenue allocation
- Statement generation
- Payment processing
- Tax management
- Withdrawal system

**Implementation Details**:
- Graph-based data model for complex splits
- Precise decimal calculations using BigDecimal
- PDF generation for statements
- Payment gateway integrations
- Balance tracking for multiple currencies
- Automated and manual payment workflows

#### Rights Management System

The rights management system tracks ownership and licensing of musical works.

**Key Components**:
- Ownership tracking
- Rights verification
- License management
- Conflict resolution
- Rights transfer
- Public and private documentation

**Implementation Details**:
- Document storage for rights verification
- Version control for rights history
- Workflow engine for verification processes
- Integration with blockchain for immutable records
- Notification system for rights changes

#### AI Services

AI services provide intelligent features across the platform.

**Key Components**:
- Content analysis
- Recommendation engine
- Predictive analytics
- Automated tagging
- Trend detection
- Audio fingerprinting

**Implementation Details**:
- OpenAI API integration for natural language processing
- Custom ML models for music analysis
- Feature extraction from audio content
- Vector database for similarity search
- Periodic model training workflow
- Caching for cost and performance optimization

#### Blockchain Integration

Blockchain integration provides decentralized rights management and NFT capabilities.

**Key Components**:
- Smart contract management
- NFT minting
- Rights on blockchain
- Royalty tokens
- Transaction monitoring
- Wallet integration

**Implementation Details**:
- Ethereum integration using ethers.js
- Custom smart contracts for rights management
- NFT standard implementation (ERC-721, ERC-1155)
- Client-side transaction signing
- Multi-chain support architecture
- Blockchain event monitoring

### Data Architecture

TuneMantra's data architecture is designed for flexibility, performance, and integrity, with PostgreSQL as the primary data store.

#### Database Schema

The core database schema consists of several related entities managed through Drizzle ORM:

**Users and Authentication**:
- `users`: User accounts and profiles
- `api_keys`: API authentication keys
- `sessions`: User sessions
- `team_members`: Team access and permissions

**Content Management**:
- `releases`: Music releases (albums, singles, EPs)
- `tracks`: Individual tracks within releases
- `artists`: Artist profiles and information
- `metadata`: Extended content metadata

**Distribution**:
- `distribution_platforms`: Available distribution platforms
- `distribution_records`: Distribution status tracking
- `scheduled_distributions`: Future release planning
- `distribution_exports`: Export file tracking

**Royalties**:
- `royalty_splits`: Revenue sharing configurations
- `royalty_statements`: Generated payment statements
- `royalty_line_items`: Detailed transaction records
- `payment_methods`: User payment preferences
- `withdrawals`: Payment withdrawal requests

**Rights Management**:
- `rights_claims`: Ownership and rights declarations
- `licenses`: Licensing agreements and terms
- `rights_conflicts`: Disputed ownership records
- `rights_transfers`: Ownership change history

**Analytics**:
- `platform_data`: Raw platform performance data
- `analytics_metrics`: Calculated performance metrics
- `reports`: Generated analytics reports
- `data_imports`: Tracking of data import jobs

#### Data Types and Structure

TuneMantra leverages PostgreSQL's advanced features:

- **JSONB Columns**: Used for flexible, schema-less data where needed
- **Array Columns**: Used for collections of simple values
- **Enums**: For strongly typed status values and categories
- **Relations**: Foreign keys maintain referential integrity
- **Indexes**: Strategic indexing for query performance
- **Constraints**: Data validation at the database level

Example schema definition (in Drizzle ORM):

```typescript
// Releases table with JSONB metadata
export const releases = pgTable("releases", {
  id: serial("id").primaryKey(),
  title: text("title").notNull(),
  artist: text("artist").notNull(),
  releaseDate: timestamp("release_date"),
  upc: text("upc"),
  catalogueId: text("catalogue_id"),
  artwork: text("artwork"),
  genre: text("genre"),
  type: text("type"),
  userId: integer("user_id").references(() => users.id),
  status: text("status").default("draft"),
  metadataJson: json("metadata_json").default({}),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
  isExplicit: boolean("is_explicit").default(false),
  language: text("language"),
  primaryGenre: genreCategoryEnum("primary_genre"),
  ownershipType: ownershipTypeEnum("ownership_type").default("original"),
});

// Distribution records with status tracking
export const distributionRecords = pgTable("distribution_records", {
  id: serial("id").primaryKey(),
  releaseId: integer("release_id").notNull().references(() => releases.id),
  platformId: integer("platform_id").notNull(),
  status: distributionStatusEnum("status").default("pending"),
  distributionDate: timestamp("distribution_date"),
  referenceId: text("reference_id"),
  details: json("details").default({}),
  userId: integer("user_id"),
  deliveryMethod: text("delivery_method"),
  errorMessage: text("error_message"),
  errorType: text("error_type"),
  retryCount: integer("retry_count").default(0),
  lastChecked: timestamp("last_checked"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
  scheduledDate: timestamp("scheduled_date"),
  retryHistory: json("retry_history").default([]),
  platformIds: json("platform_ids").default([]),
});
```

#### Data Access Layer

The data access layer provides a consistent interface for interacting with the database:

- **Storage Interface**: Defines the contract for data access operations
- **Database Implementation**: Implements the storage interface using Drizzle ORM
- **Data Validation**: Zod schemas validate data before storage operations
- **Query Optimization**: Prepared statements and optimized queries
- **Transaction Support**: ACID transactions for related operations
- **Migration System**: Versioned database schema changes

Example storage interface:

```typescript
export interface IStorage {
  // User management
  getUser(id: number): Promise<User | undefined>;
  createUser(insertUser: InsertUser): Promise<User>;

  // Release management
  getReleaseById(id: number): Promise<Release | undefined>;
  createRelease(userId: number, release: InsertRelease): Promise<Release>;

  // Distribution management
  getDistributionRecords(options?: { releaseId?: number; status?: string }): Promise<DistributionRecord[]>;
  updateDistributionRecord(id: number, updates: Partial<DistributionRecord>): Promise<DistributionRecord>;

  // Royalty management
  getRoyaltySplits(releaseId: number): Promise<RoyaltySplit[]>;
  createRoyaltySplit(split: InsertRoyaltySplit): Promise<RoyaltySplit>;

  // ... additional methods for all entities
}
```

#### Data Migration Strategy

TuneMantra uses a structured approach to database migrations:

- **Migration Scripts**: Versioned SQL scripts for schema changes
- **Migration Registry**: Tracking of applied migrations
- **Rollback Support**: Reversible migration operations
- **Testing**: Automated testing of migrations in staging
- **Zero-Downtime**: Migrations designed for minimal disruption

Example migration:

```sql
-- Migration: add_platform_ids_column

-- Add platform_ids JSON column to distribution_records
ALTER TABLE distribution_records 
ADD COLUMN platform_ids JSONB DEFAULT '[]';

-- Update existing records to populate platform_ids from platform_id
UPDATE distribution_records
SET platform_ids = json_build_array(platform_id)
WHERE platform_id IS NOT NULL;
```

### Security Architecture

TuneMantra implements a comprehensive security architecture to protect user data, content, and platform integrity.

#### Authentication & Authorization

**Multi-layered Authentication**:
- Session-based authentication for web clients
- JWT-based authentication for API access
- API key authentication for service integrations
- Password storage using bcrypt with salt
- Login attempt rate limiting

**Role-Based Access Control**:
- Granular permission system based on user roles
- Fine-grained resource access controls
- Permission checks at API and UI levels
- Hierarchical role structure

Example RBAC implementation:

```typescript
export const ensureAdmin: RequestHandler = async (req, res, next) => {
  if (!req.session.userId) {
    return res.status(401).json({ error: "Not authenticated" });
  }

  const user = await storage.getUser(req.session.userId);

  if (!user || user.role !== 'admin') {
    return res.status(403).json({ error: "Not authorized" });
  }

  next();
};
```

#### Data Protection

**Data Encryption**:
- TLS/SSL for all API communications
- Database column-level encryption for sensitive data
- Secure parameter storage for API credentials
- Encrypted file storage for content assets

**Personal Data Protection**:
- Personal data minimization
- Configurable data retention policies
- User data export capability
- Account deletion workflow

#### API Security

**Request Validation**:
- Schema validation for all API inputs
- Parameter sanitization to prevent injection
- Content type validation
- Request size limits

**API Protection Measures**:
- CSRF protection for session-based routes
- Rate limiting to prevent abuse
- Request signing for sensitive operations
- API versioning for backward compatibility

#### Compliance Considerations

TuneMantra's security architecture addresses key compliance requirements:

- **GDPR Compliance**: EU personal data protection measures
- **CCPA Compliance**: California Consumer Privacy Act requirements
- **PCI Compliance**: Payment Card Industry standards for payment processing
- **SOC 2**: Security, availability, and confidentiality controls

### Integration Architecture

TuneMantra integrates with various external systems to provide comprehensive functionality.

#### Streaming Platform Integrations

**Manual Distribution Integration**:
- Platform-specific metadata formatting
- Export generation in required formats
- Status tracking through backend workflows
- Manual update mechanisms

**Direct API Connections** (Planned):
- OAuth authentication with platforms
- Real-time content delivery via APIs
- Automated status updates
- Direct analytics retrieval

#### Payment System Integrations

**Payment Gateway Integration**:
- Secure payment processing
- Multiple payment methods
- Fraud detection integration
- Compliance with financial regulations

**Payout Integration**:
- Automated royalty distribution
- Multi-currency support
- Tax withholding compliance
- Payment notification system

#### Analytics Data Integration

**Streaming Platforms**:
- Regular data import from platform dashboards
- Data normalization across sources
- Reconciliation of conflicting data
- Historical data preservation

**Third-Party Analytics**:
- Integration with specialized analytics providers
- Social media performance data
- Market trend information
- Benchmark comparisons

#### Blockchain Integration

**Ethereum Integration**:
- Smart contract deployment and interaction
- Wallet connection and signing
- Transaction monitoring
- Event subscriptions

**Multi-Chain Support**:
- Abstract blockchain interface
- Chain-specific adapters
- Cross-chain asset tracking
- Gas fee optimization

#### Email & Notification Integration

**Email Service**:
- Transactional email delivery
- Template-based messaging
- Delivery tracking and bounce handling
- Compliance with anti-spam regulations

**Push Notification Services**:
- Mobile device notifications
- Web push notifications
- Notification preferences
- Delivery confirmation

#### Integration Architecture Principles

TuneMantra's integration approach follows these principles:

1. **Adapter Pattern**: Consistent interfaces with platform-specific adapters
2. **Idempotent Operations**: Safe retries for failed operations
3. **Rate Limiting**: Respect for external service constraints
4. **Circuit Breaking**: Failure isolation to prevent cascading issues
5. **Monitoring**: Comprehensive logging of integration activity

### Application Architecture

TuneMantra follows a layered application architecture with clear separation of concerns.

#### Frontend Architecture

**Component Structure**:
- Atomic design pattern for UI components
- Feature-based organization of modules
- Shared component library for consistent UI
- Container/presentation component separation

**State Management**:
- React Query for server state management
- React context for global application state
- Local component state for UI interactions
- Optimistic updates for responsive UX

**Routing & Navigation**:
- Wouter for lightweight client-side routing
- Nested routes for complex views
- Route guards for access control
- Dynamic route loading

**Form Handling**:
- React Hook Form for efficient form state
- Zod schemas for validation logic
- Field-level validation with immediate feedback
- Form submission with error handling

#### Backend Architecture

**API Layer**:
- RESTful API design principles
- Resource-based URL structure
- Consistent response formats
- Comprehensive error handling

**Service Layer**:
- Business logic encapsulated in service classes
- Domain-driven design principles
- Service composition for complex operations
- Transaction management

**Data Access Layer**:
- Repository pattern for data operations
- ORM abstraction for database interactions
- Caching strategies for performance
- Query optimization

**Background Processing**:
- Job queue for asynchronous operations
- Scheduled tasks for periodic processing
- Worker processes for resource-intensive tasks
- Retry mechanisms with exponential backoff

#### Middleware Architecture

TuneMantra employs several middleware components:

**Request Processing**:
- Body parsing and validation
- Authentication and authorization
- Rate limiting and throttling
- CORS handling
- Compression

**Response Processing**:
- Response formatting
- Error handling
- Caching headers
- Security headers

**Logging & Monitoring**:
- Request logging
- Error tracking
- Performance monitoring
- Audit logging for sensitive operations

#### Error Handling Strategy

Comprehensive error handling across all layers:

**Frontend Error Handling**:
- Global error boundary for React components
- Query error handling with React Query
- User-friendly error messages
- Retry mechanisms for transient errors

**Backend Error Handling**:
- Structured error responses with error codes
- Detailed logging for debugging
- Graceful degradation for service failures
- Monitoring and alerting for critical errors

### Deployment Architecture

TuneMantra utilizes a modern, cloud-native deployment architecture.

#### Development Environment

**Local Development**:
- Docker-based local environment
- Hot reloading for rapid iteration
- Local database with seed data
- Mock services for external dependencies

**Development Workflow**:
- Feature branch development
- Automated testing in CI pipeline
- Code review process
- Automated linting and formatting

#### Production Environment

**Cloud Infrastructure**:
- Containerized application services
- Managed database services
- Object storage for media assets
- CDN for static content delivery

**Scaling Strategy**:
- Horizontal scaling for application services
- Database read replicas for query scaling
- Caching layer for frequently accessed data
- Content delivery optimization

**High Availability**:
- Multi-zone deployment
- Database failover configuration
- Load balancing across instances
- Health monitoring and auto-recovery

#### Continuous Integration/Continuous Deployment

**CI Pipeline**:
- Automated testing on code commit
- Static code analysis
- Security vulnerability scanning
- Build artifact generation

**CD Pipeline**:
- Automated deployment to staging
- Integration testing in staging
- Manual promotion to production
- Automated rollback capability

#### Monitoring & Observability

**Logging System**:
- Structured logging format
- Centralized log aggregation
- Log retention policy
- Log search and analysis

**Metrics Collection**:
- Application performance metrics
- Infrastructure utilization metrics
- Business KPI tracking
- Custom metric dashboards

**Alerting System**:
- Critical error alerting
- Performance threshold alerts
- Business metric anomaly detection
- On-call rotation for incident response

### Performance Considerations

TuneMantra is designed with performance as a core requirement.

#### Database Performance

**Query Optimization**:
- Strategic indexing for common queries
- Query analysis and tuning
- Join optimization
- Efficient use of JSONB indexes

**Connection Management**:
- Connection pooling
- Query timeout configuration
- Transaction scope management
- Read/write separation for scaling

#### API Performance

**Response Time Optimization**:
- Efficient query design
- Pagination for large result sets
- Field selection for response size control
- Compression for response payload

**Caching Strategy**:
- Response caching for read-heavy endpoints
- Cache invalidation on data changes
- Cache-Control headers for client caching
- Redis-based application cache

#### Frontend Performance

**Loading Performance**:
- Code splitting for lazy loading
- Asset optimization (minification, compression)
- Critical CSS path optimization
- Image optimization and lazy loading

**Runtime Performance**:
- Component memoization
- Virtual list rendering for large datasets
- Debounced and throttled event handlers
- Performance monitoring with React profiler

#### Asset Delivery

**Media File Optimization**:
- Image resizing and format optimization
- On-demand thumbnail generation
- Progressive loading for large files
- CDN distribution for global performance

### Scalability Strategy

TuneMantra's architecture is designed for growth and scalability.

#### Horizontal Scaling

**Application Layer Scaling**:
- Stateless service design
- Load-balanced API servers
- Session store externalization
- Container orchestration

**Database Scaling**:
- Read replicas for query distribution
- Connection pooling optimization
- Sharding strategy for future growth
- Query optimization for scale

#### Vertical Scaling

**Resource Optimization**:
- Memory usage profiling and optimization
- CPU efficiency improvements
- I/O operation minimization
- Background task resource management

#### Caching Strategy

**Multi-Level Caching**:
- Application-level caching
- Database query caching
- HTTP response caching
- CDN caching for static assets

**Cache Invalidation**:
- Time-based expiration
- Event-based invalidation
- Selective cache purging
- Cache warming for critical data

#### Load Management

**Traffic Handling**:
- Rate limiting for API endpoints
- Request queuing for peak loads
- Graceful degradation under stress
- Circuit breakers for dependency failures

**Background Processing**:
- Asynchronous job processing
- Batch processing for efficiency
- Priority queuing for critical tasks
- Scheduled distribution of workloads

### Technical Debt Management

TuneMantra actively manages technical debt to maintain code quality and system health.

#### Debt Identification

**Code Quality Metrics**:
- Static code analysis
- Test coverage monitoring
- Complexity measurement
- Performance benchmarking

**Issue Tracking**:
- Technical debt backlog
- Prioritization framework
- Impact assessment
- Resolution planning

#### Refactoring Strategy

**Incremental Improvement**:
- Parallel refactoring alongside features
- Test-driven refactoring approach
- Incremental architecture evolution
- Component isolation for safe changes

**Code Modernization**:
- Dependency updates
- API standardization
- Performance optimization
- Security hardening

#### Quality Assurance

**Automated Testing**:
- Unit test coverage
- Integration test suite
- End-to-end testing
- Performance testing

**Manual Quality Review**:
- Code review process
- Architecture review
- Security assessment
- Usability testing

### Development Workflow

TuneMantra follows a structured development process to ensure quality and efficiency.

#### Version Control

**Branch Strategy**:
- `main`: Production-ready code
- `develop`: Integration branch
- Feature branches for development
- Release branches for versioning

**Commit Guidelines**:
- Semantic commit messages
- Atomic commits
- Comprehensive descriptions
- Issue references

#### Testing Strategy

**Test Levels**:
- Unit tests for individual components
- Integration tests for component interaction
- API tests for endpoint validation
- End-to-end tests for user workflows

**Test Automation**:
- Continuous integration testing
- Pre-commit test hooks
- Test-driven development approach
- Regression test suite

#### Release Management

**Versioning**:
- Semantic versioning (MAJOR.MINOR.PATCH)
- Release notes generation
- Changelog maintenance
- Version tagging in repository

**Deployment Process**:
- Staging environment validation
- Canary releases for risk mitigation
- Blue-green deployment strategy
- Automated rollback capability

### References and Resources

#### Internal Documentation

- [API Reference](./api/api-reference.md)
- [Database Schema Documentation](./database-schema.md)
- [Service Architecture Details](./service-architecture.md)
- [Security Controls Documentation](./security-controls.md)

#### External Resources

- [Drizzle ORM Documentation](https://orm.drizzle.team/)
- [React Query Documentation](https://tanstack.com/query/latest)
- [Express.js Best Practices](https://expressjs.com/en/advanced/best-practice-performance.html)
- [PostgreSQL Performance Tuning](https://www.postgresql.org/docs/current/performance-tips.html)

#### Development Standards

- [TypeScript Coding Standards](./coding-standards.md)
- [API Design Guidelines](./api-guidelines.md)
- [Security Requirements](./security-requirements.md)
- [Performance Benchmarks](./performance-benchmarks.md)

---

**Document Owner**: TuneMantra Architecture Team  
**Last Review**: March 18, 2025

---

#### 2025-03-17: Mobile Application Implementation Guide
_Source: unified_documentation/mobile/17032025-mobile-application-implementation.md (Branch: 17032025)_


**Last Updated: March 18, 2025**

### Overview

This document outlines the architecture, implementation approach, and roadmap for the TuneMantra mobile applications. The mobile applications will provide artists, labels, and distributors with on-the-go access to key platform features, including distribution management, analytics monitoring, and revenue tracking.

### Implementation Status

**Overall Completion: 0% | Planning Phase**

| Component | Completion % | Status | Planned Timeline |
|-----------|--------------|--------|------------------|
| Requirements Analysis | 100% | ✅ Complete | Completed Q1 2025 |
| Architecture Design | 75% | 🟡 In Progress | Q1-Q2 2025 |
| React Native Setup | 0% | ⚪ Not Started | Q2 2025 |
| Core UI Components | 0% | ⚪ Not Started | Q2 2025 |
| API Integration | 0% | ⚪ Not Started | Q2-Q3 2025 |
| Authentication | 0% | ⚪ Not Started | Q2 2025 |
| Analytics Dashboard | 0% | ⚪ Not Started | Q3 2025 |
| Distribution Management | 0% | ⚪ Not Started | Q3 2025 |
| iOS Deployment | 0% | ⚪ Not Started | Q4 2025 |
| Android Deployment | 0% | ⚪ Not Started | Q4 2025 |

### Architectural Approach

The TuneMantra mobile application will be built using React Native to ensure cross-platform compatibility while maintaining native performance. The architecture follows a modular approach with clear separation of concerns:

```
┌─────────────────────────────────┐
│       Mobile UI Components      │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│     Mobile State Management     │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│    Mobile API Integration       │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│     TuneMantra REST APIs        │
└─────────────────────────────────┘
```

#### Key Architectural Components

1. **Mobile UI Components**
   - React Native components for cross-platform UI
   - Responsive design for different device sizes
   - Native-like UX patterns for each platform
   - Accessibility features built-in

2. **Mobile State Management**
   - React Query for server state management
   - Redux for complex local state
   - Persistent storage for offline capability
   - Synchronization management

3. **Mobile API Integration**
   - Unified API client
   - Request/response interceptors
   - Error handling and retry logic
   - Authentication token management
   - Offline request queuing

4. **Core Platform Integration**
   - Shared business logic with web application
   - API compatibility layer
   - Analytics event tracking
   - Push notification handling

### Technical Stack

The mobile application will be implemented using the following technology stack:

#### Core Framework
- **React Native**: Cross-platform mobile framework
- **TypeScript**: Type-safe JavaScript superset
- **React Navigation**: Navigation library for React Native

#### State Management
- **React Query**: Server state management
- **Redux Toolkit**: Client state management
- **AsyncStorage**: Persistent storage

#### UI Components
- **React Native Paper**: Material Design components
- **React Native Elements**: Cross-platform UI toolkit
- **React Native SVG**: SVG support for icons and graphics

#### API Integration
- **Axios**: HTTP client for API requests
- **JWT Decode**: Token parsing and validation
- **Socket.io Client**: Real-time communication

#### Development Tools
- **Expo**: Development environment and toolchain
- **Jest**: Testing framework
- **Detox**: End-to-end testing

#### Performance Monitoring
- **React Native Performance**: Performance monitoring
- **Crashlytics**: Crash reporting
- **Analytics**: User behavior tracking

### Feature Prioritization

The mobile application will be developed in phases, with features prioritized based on user needs:

#### Phase 1: Core Infrastructure (Q2 2025)
- Authentication and user management
- Basic navigation structure
- Offline capability foundation
- API integration framework

#### Phase 2: Analytics Dashboard (Q3 2025)
- Revenue overview
- Performance metrics
- Platform distribution
- Geographic insights
- Trend visualization

#### Phase 3: Distribution Management (Q3-Q4 2025)
- Release status monitoring
- Distribution history
- Simple distribution actions
- Error notifications and alerts

#### Phase 4: Advanced Features (Q4 2025)
- Royalty statement access
- Payment tracking
- User management
- Notification preferences
- Advanced settings

### Mobile-Specific Considerations

#### Performance Optimization

The mobile application is optimized for performance on mobile devices:

1. **Lazy Loading**
   - Implement code splitting for screens
   - Lazy load non-critical components
   - Virtualize long lists for memory efficiency

2. **Image Optimization**
   - Implement progressive image loading
   - Use appropriate image resolutions for device
   - Implement caching strategy for images

3. **Network Efficiency**
   - Implement request batching where appropriate
   - Use GraphQL for data efficiency (future enhancement)
   - Implement data prefetching for common flows

#### Offline Capability

The application will support key functionality in offline mode:

1. **Data Persistence**
   - Cache critical data for offline viewing
   - Prioritize recent and frequently accessed data
   - Implement storage quota management

2. **Offline Actions**
   - Queue actions when offline
   - Synchronize when connectivity is restored
   - Provide clear status indicators for pending actions

3. **Conflict Resolution**
   - Implement conflict detection for offline changes
   - Provide user-friendly resolution interfaces
   - Maintain audit trail of sync conflicts

#### Platform-Specific Adaptation

While maintaining a consistent core, the app will adapt to platform conventions:

1. **iOS Adaptations**
   - Follow iOS Human Interface Guidelines
   - Implement iOS-specific gesture patterns
   - Support iOS system features (e.g., Shortcuts)

2. **Android Adaptations**
   - Follow Material Design guidelines
   - Support Android-specific gestures
   - Implement Android system integration (e.g., Intents)

### Integration with Core Platform

The mobile application will integrate seamlessly with the core TuneMantra platform:

#### API Integration

```typescript
// Mobile API client setup
import axios from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage';

const apiClient = axios.create({
  baseURL: 'https://api.tunemantra.com/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  }
});

// Add authentication token to requests
apiClient.interceptors.request.use(async (config) => {
  const token = await AsyncStorage.getItem('authToken');
  if (token) {
    config.headers['Authorization'] = `Bearer ${token}`;
  }
  return config;
}, (error) => {
  return Promise.reject(error);
});

// Handle token refresh on 401 errors
apiClient.interceptors.response.use(
  response => response,
  async error => {
    const originalRequest = error.config;
    if (error.response.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;

      try {
        const refreshToken = await AsyncStorage.getItem('refreshToken');
        const response = await axios.post('https://api.tunemantra.com/api/auth/refresh', {
          refreshToken
        });

        const { token } = response.data;
        await AsyncStorage.setItem('authToken', token);

        originalRequest.headers['Authorization'] = `Bearer ${token}`;
        return apiClient(originalRequest);
      } catch (refreshError) {
        // Handle refresh error - usually by redirecting to login
        await AsyncStorage.removeItem('authToken');
        await AsyncStorage.removeItem('refreshToken');
        // Navigate to login screen
        return Promise.reject(refreshError);
      }
    }

    return Promise.reject(error);
  }
);

export default apiClient;
```

#### Authentication Flow

```typescript
// Authentication service for mobile
export class AuthService {
  async login(username: string, password: string): Promise<boolean> {
    try {
      const response = await apiClient.post('/auth/login', {
        username,
        password
      });

      const { token, refreshToken, user } = response.data;

      await AsyncStorage.setItem('authToken', token);
      await AsyncStorage.setItem('refreshToken', refreshToken);
      await AsyncStorage.setItem('userData', JSON.stringify(user));

      return true;
    } catch (error) {
      console.error('Login error:', error);
      return false;
    }
  }

  async logout(): Promise<void> {
    try {
      await apiClient.post('/auth/logout');
    } catch (error) {
      console.error('Logout error:', error);
    } finally {
      await AsyncStorage.removeItem('authToken');
      await AsyncStorage.removeItem('refreshToken');
      await AsyncStorage.removeItem('userData');
    }
  }

  async getCurrentUser(): Promise<any | null> {
    try {
      const userData = await AsyncStorage.getItem('userData');
      if (userData) {
        return JSON.parse(userData);
      }
      return null;
    } catch (error) {
      console.error('Error getting current user:', error);
      return null;
    }
  }

  async isAuthenticated(): Promise<boolean> {
    try {
      const token = await AsyncStorage.getItem('authToken');
      return !!token;
    } catch (error) {
      return false;
    }
  }
}
```

### User Interface Design

The mobile application will follow these UI principles:

1. **Consistent Brand Experience**
   - Maintain TuneMantra brand identity
   - Adapt web design for mobile context
   - Optimize spacing and typography for mobile

2. **Intuitive Navigation**
   - Tab-based main navigation
   - Hierarchical drill-down for details
   - Clear navigation paths and breadcrumbs
   - Gesture support for common actions

3. **Mobile-First Adaptations**
   - Simplified workflows for mobile context
   - Touch-optimized controls and target sizes
   - Reduced cognitive load for mobile screens
   - Progressive disclosure of complex information

#### Example Screen Structure

```typescript
// Analytics Dashboard Screen
export function AnalyticsDashboardScreen() {
  const { data: overview, isLoading, error } = useQuery({
    queryKey: ['/analytics/overview'],
    queryFn: () => apiClient.get('/analytics/overview').then(res => res.data)
  });

  if (isLoading) {
    return <LoadingIndicator />;
  }

  if (error) {
    return <ErrorState error={error} onRetry={() => refetch()} />;
  }

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView>
        <View style={styles.header}>
          <Text style={styles.title}>Analytics Dashboard</Text>
          <TouchableOpacity style={styles.filterButton}>
            <Icon name="filter" size={24} />
          </TouchableOpacity>
        </View>

        <View style={styles.overviewCard}>
          <Text style={styles.cardTitle}>Revenue Overview</Text>
          <Text style={styles.revenueAmount}>${overview.totalRevenue.toFixed(2)}</Text>
          <View style={styles.changeIndicator}>
            <Icon 
              name={overview.percentageChange >= 0 ? "arrow-up" : "arrow-down"} 
              size={16} 
              color={overview.percentageChange >= 0 ? "#4CAF50" : "#F44336"} 
            />
            <Text style={styles.changeText}>
              {Math.abs(overview.percentageChange).toFixed(1)}% from previous period
            </Text>
          </View>
        </View>

        <View style={styles.chartContainer}>
          <Text style={styles.sectionTitle}>Revenue Trend</Text>
          <LineChart 
            data={overview.trendData}
            width={Dimensions.get('window').width - 32}
            height={220}
            chartConfig={{
              // Chart configuration
            }}
          />
        </View>

        <View style={styles.platformBreakdown}>
          <Text style={styles.sectionTitle}>Platform Distribution</Text>
          <PieChart 
            data={overview.platformBreakdown}
            width={Dimensions.get('window').width - 32}
            height={220}
            chartConfig={{
              // Chart configuration
            }}
            accessor="amount"
            backgroundColor="transparent"
          />
        </View>

        {/* Additional sections */}
      </ScrollView>
    </SafeAreaView>
  );
}
```

### Testing Strategy

The mobile application will be thoroughly tested using:

1. **Unit Testing**
   - Jest for component and service testing
   - Mock API responses for predictable testing
   - High coverage for critical business logic

2. **Integration Testing**
   - Testing component interactions
   - API integration testing
   - Navigation flow testing

3. **End-to-End Testing**
   - Detox for automated E2E testing
   - User flow validation
   - Cross-device testing

4. **Manual Testing**
   - Usability testing on real devices
   - Performance testing
   - Edge case exploration

### Deployment Strategy

The deployment strategy includes:

1. **Beta Testing**
   - Internal testing with TestFlight (iOS)
   - Internal testing with Google Play Beta (Android)
   - Feedback collection and iteration

2. **App Store Deployment**
   - App Store Connect preparation
   - iOS review process management
   - Marketing materials and screenshots

3. **Google Play Deployment**
   - Google Play Console preparation
   - Android review process management
   - Store listing optimization

4. **Continuous Updates**
   - Regular feature updates
   - Bug fix releases
   - Performance improvements

### Future Enhancement Roadmap

Future enhancements planned for the mobile application include:

| Feature | Priority | Timeline |
|---------|----------|----------|
| Push Notifications | High | Q4 2025 |
| Offline Release Creation | Medium | Q1 2026 |
| Content Upload | Medium | Q1 2026 |
| Biometric Authentication | Medium | Q1 2026 |
| Analytics Sharing | Low | Q2 2026 |
| In-App Messaging | Low | Q2 2026 |
| AR/VR Content Preview | Low | Q3-Q4 2026 |

---

**Document Owner**: Mobile Development Team  
**Created**: March 3, 2025  
**Last Updated**: March 18, 2025  
**Status**: Planning Phase  
**Related Documents**: 
- [Technical Architecture](../architecture/technical-architecture.md)
- [API Reference](../../api/api-reference.md)
- [Authentication System](../user-management/authentication.md)

---

#### 2025-03-17: Payment & Revenue Management
_Source: unified_documentation/payment/17032025-payment-revenue-management-extended.md (Branch: 17032025)_


### Overview

The Payment & Revenue Management system in TuneMantra provides comprehensive financial management capabilities for artists, labels, and managers. The system enables users to:

1. Manage multiple payment methods 
2. Request and track withdrawals
3. Configure revenue splits between collaborating artists
4. Monitor revenue streams across platforms
5. Handle subscription payments through Razorpay

This document provides an overview of the payment system's features, user experience, and implementation details.

### Key Features

#### Payment Method Management

Users can add and manage multiple payment methods including:

- **Bank Accounts**: Direct bank transfers with account details
- **Cards**: Credit/debit card payments (last four digits stored for reference)
- **PayPal**: Electronic payments through PayPal accounts

For each payment method, the system stores:
- Type of payment method
- Last four digits (for reference)
- Additional details specific to the payment method type
- Default status (is this the preferred payment method)

The system uses secure storage for all payment details, with sensitive information encrypted at rest.

#### Withdrawal Management

Users can request withdrawals of their earnings:

- **Request Process**: Users select a payment method, specify amount and currency
- **Status Tracking**: Track withdrawal status (pending, completed, rejected)
- **History**: View complete withdrawal history with transaction details
- **Notifications**: Receive alerts for status changes

Withdrawal requests undergo admin review before processing to ensure security and compliance.

#### Revenue Splits

Revenue splits allow artists to distribute earnings to collaborators:

- **Collaborative Works**: Configure percentage-based revenue distribution
- **Role-Based Splits**: Assign shares based on contribution roles (artist, producer, etc.)
- **Automatic Calculations**: System automatically distributes earnings according to configured splits
- **Transparency**: Clear visibility into split calculations and distributions

All splits must total 100% and can be updated for future earnings distribution.

#### Revenue Monitoring

The system provides comprehensive revenue tracking:

- **Platform Breakdown**: View earnings by distribution platform
- **Time-Based Analysis**: Track revenue over different time periods
- **Track-Level Analytics**: Analyze performance of individual tracks
- **Export Capabilities**: Download revenue reports in various formats

#### Subscription Management

Subscription handling through Razorpay:

- **Plan Selection**: Choose from available subscription tiers
- **Secure Checkout**: PCI-compliant payment processing
- **Subscription Status**: View active subscription details and history
- **Cancellation**: Ability to cancel current subscription

### User Experience

#### Payment Methods UI

The payment methods interface allows users to:

- View all registered payment methods in a clear, tabular format
- Add new payment methods through a guided form process
- Set default payment method with a single click
- Delete unused payment methods with confirmation

Form validation ensures all required information is provided in the correct format.

#### Withdrawals UI

The withdrawals interface provides:

- A form to request new withdrawals with amount validation
- A history table showing all past withdrawal requests
- Status indicators for each withdrawal
- Filtering options by status and date

#### Revenue Splits UI

The revenue splits interface offers:

- A visual distribution tool with percentage sliders
- Role selection for each collaborator
- Real-time validation to ensure splits total 100%
- Ability to save templates for commonly used split configurations

#### Analytics Integration

The revenue management system integrates with the analytics system to:

- Display revenue alongside streaming data
- Provide revenue forecasts based on current performance
- Show geographic revenue distribution
- Highlight top-performing tracks by revenue

### Technical Implementation

#### Database Schema

The payment system is built on three primary database tables:

1. **payment_methods**: Stores user payment method information
2. **withdrawals**: Records withdrawal requests and their status
3. **revenue_splits**: Stores revenue split configurations

#### Security Measures

The payment system implements several security measures:

- **Encryption**: All sensitive payment data is encrypted at rest
- **Permissions**: Role-based access control for payment operations
- **Audit Logging**: All financial transactions are logged for audit purposes
- **Webhook Verification**: Secure signature verification for payment webhooks
- **Rate Limiting**: Protection against brute force and DoS attacks

#### Razorpay Integration

The system uses Razorpay for secure payment processing:

- **Order Creation**: Creates payment orders through Razorpay API
- **Signature Verification**: Validates payment completion with cryptographic signatures
- **Webhook Handling**: Processes asynchronous payment notifications
- **Error Handling**: Gracefully handles payment failures and retries

#### API Architecture

The payment system exposes RESTful APIs for:

- Payment method management
- Withdrawal requests and status updates
- Revenue split configuration
- Subscription management

All APIs are authenticated and follow consistent response formats.

### Administrator Features

Platform administrators have additional capabilities:

- **Withdrawal Approval**: Review and approve/reject withdrawal requests
- **Payment Method Verification**: Verify the validity of payment methods
- **System Configuration**: Set minimum withdrawal amounts and processing fees
- **Manual Adjustments**: Make manual adjustments to user balances when needed
- **Export Records**: Download comprehensive financial records for accounting

### Testing and Quality Assurance

The payment system includes:

- **Unit Tests**: Testing individual components for expected behavior
- **Integration Tests**: Verifying system interactions work correctly
- **End-to-End Tests**: Testing complete user flows
- **Security Testing**: Validation of encryption and authorization
- **Load Testing**: Ensuring system performance under high transaction volumes

### Future Enhancements

Planned enhancements for the payment system include:

1. **Additional Payment Methods**: Support for more payment platforms and cryptocurrencies
2. **Advanced Split Rules**: More complex revenue splitting with conditional rules
3. **Automated Withdrawals**: Scheduled automatic withdrawals for qualifying accounts
4. **Tax Documentation**: Generation of tax forms and reports
5. **Multi-Currency Support**: Enhanced handling of multiple currencies and exchange rates

### Related Documentation

- [Payment API Reference](../api/PAYMENT_API_REFERENCE.md)
- [Payment Implementation Guide](../guides/payment-implementation-guide.md)
- [Payment System Architecture](../architecture/PAYMENT_SYSTEM_ARCHITECTURE.md)

---

#### 2025-03-17: Payment and Revenue Management System
_Source: unified_documentation/payment/17032025-payment-revenue-management.md (Branch: 17032025)_


**Last Updated: March 18, 2025**

### Overview

The Payment and Revenue Management System in TuneMantra handles all aspects of financial transactions, royalty calculations, payment processing, and revenue analysis across the platform. This comprehensive system enables accurate tracking and distribution of music royalties with robust accounting features.

### Implementation Status

**Overall Completion: 70% | Practical Usability: 75%**

| Component | Completion % | Status | Ready For Use |
|-----------|--------------|--------|---------------|
| Royalty Splits Configuration | 85% | Near Complete | Yes |
| Revenue Collection | 80% | Functional | Yes |
| Payment Methods | 75% | Functional | Yes |
| Statements Generation | 70% | Functional | Yes |
| Payment Processing | 60% | Partially Implemented | Partial |
| Tax Handling | 50% | In Development | No |
| Multi-Currency Support | 45% | In Development | No |
| Blockchain Payments | 30% | Early Stage | No |
| Custom Contracts | 65% | Partially Implemented | Partial |
| Analytics Integration | 75% | Functional | Yes |

### Architecture

The payment and revenue management system follows a modular architecture with specialized components:

```
┌───────────────────────────┐
│ Revenue Management UI     │
│ (75% Complete)            │
└──────────────┬────────────┘
               │
┌──────────────▼────────────┐
│ Payment & Revenue API     │
│ (70% Complete)            │
└──────────────┬────────────┘
               │
       ┌───────┴────────┐
       │                │
┌──────▼─────┐   ┌──────▼─────┐
│ Royalty    │   │ Payment    │
│ Service    │   │ Service    │
│ (75%)      │   │ (65%)      │
└──────┬─────┘   └──────┬─────┘
       │                │
┌──────▼─────┐   ┌──────▼─────┐
│ Statement  │   │ Transaction│
│ Service    │   │ Service    │
│ (70%)      │   │ (75%)      │
└──────┬─────┘   └──────┬─────┘
       │                │
┌──────▼────────────────▼─────┐
│ Data Storage Layer          │
│ (80% Complete)              │
└────────────────────────────┘
```

### Database Schema

The payment system relies on the following database tables:

```typescript
// Payment methods table
export const paymentMethods = pgTable("payment_methods", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  type: text("type").notNull(), // bank_account, paypal, etc.
  name: text("name").notNull(),
  details: jsonb("details").notNull(),
  isDefault: boolean("is_default").default(false),
  isVerified: boolean("is_verified").default(false),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});

// Withdrawals table
export const withdrawals = pgTable("withdrawals", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  paymentMethodId: integer("payment_method_id").references(() => paymentMethods.id),
  amount: numeric("amount").notNull(),
  currency: text("currency").notNull().default("USD"),
  status: text("status").notNull(), // pending, processing, completed, failed
  processingDetails: jsonb("processing_details"),
  requestedAt: timestamp("requested_at").defaultNow().notNull(),
  processedAt: timestamp("processed_at"),
  completedAt: timestamp("completed_at")
});

// Royalty type enum
export const royaltyTypeEnum = pgEnum('royalty_type', [
  'performance', 'mechanical', 'synchronization', 'print', 'digital'
]);

// Royalty status enum
export const royaltyStatusEnum = pgEnum('royalty_status', [
  'pending', 'processed', 'paid', 'disputed', 'adjusted'
]);

// Royalty splits table
export const royaltySplits = pgTable("royalty_splits", {
  id: serial("id").primaryKey(),
  releaseId: integer("release_id").references(() => releases.id),
  trackId: integer("track_id").references(() => tracks.id),
  name: text("name").notNull(),
  description: text("description"),
  createdBy: integer("created_by").notNull().references(() => users.id),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});

// Royalty split recipients table
export const royaltySplitRecipients = pgTable("royalty_split_recipients", {
  id: serial("id").primaryKey(),
  splitId: integer("split_id").notNull().references(() => royaltySplits.id),
  userId: integer("user_id").references(() => users.id),
  name: text("name").notNull(),
  email: text("email"),
  percentage: numeric("percentage").notNull(),
  role: text("role"), // artist, producer, songwriter, etc.
  paymentDetails: jsonb("payment_details"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull()
});

// Royalty periods table
export const royaltyPeriods = pgTable("royalty_periods", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  startDate: date("start_date").notNull(),
  endDate: date("end_date").notNull(),
  status: text("status").notNull(), // open, processing, closed
  createdAt: timestamp("created_at").defaultNow().notNull(),
  closedAt: timestamp("closed_at")
});

// Royalty statements table
export const royaltyStatements = pgTable("royalty_statements", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").references(() => users.id),
  periodId: integer("period_id").notNull().references(() => royaltyPeriods.id),
  totalAmount: numeric("total_amount").notNull().default("0"),
  currency: text("currency").notNull().default("USD"),
  status: royaltyStatusEnum("status").notNull().default("pending"),
  generatedAt: timestamp("generated_at").defaultNow().notNull(),
  paidAt: timestamp("paid_at"),
  documentUrl: text("document_url")
});

// Royalty line items table
export const royaltyLineItems = pgTable("royalty_line_items", {
  id: serial("id").primaryKey(),
  statementId: integer("statement_id").notNull().references(() => royaltyStatements.id),
  releaseId: integer("release_id").references(() => releases.id),
  trackId: integer("track_id").references(() => tracks.id),
  splitId: integer("split_id").references(() => royaltySplits.id),
  splitRecipientId: integer("split_recipient_id").references(() => royaltySplitRecipients.id),
  source: text("source").notNull(), // spotify, apple_music, etc.
  type: royaltyTypeEnum("type").notNull(),
  units: integer("units").notNull().default(0),
  amount: numeric("amount").notNull(),
  currency: text("currency").notNull().default("USD"),
  exchangeRate: numeric("exchange_rate").default("1"),
  periodStartDate: date("period_start_date").notNull(),
  periodEndDate: date("period_end_date").notNull(),
  details: jsonb("details")
});

// Revenue transactions table
export const revenueTransactions = pgTable("revenue_transactions", {
  id: serial("id").primaryKey(),
  releaseId: integer("release_id").references(() => releases.id),
  trackId: integer("track_id").references(() => tracks.id),
  source: text("source").notNull(),
  type: text("type").notNull(), // stream, download, sync, etc.
  units: integer("units").notNull().default(0),
  amount: numeric("amount").notNull(),
  currency: text("currency").notNull().default("USD"),
  transactionDate: date("transaction_date").notNull(),
  country: text("country"),
  details: jsonb("details"),
  importBatchId: integer("import_batch_id"),
  createdAt: timestamp("created_at").defaultNow().notNull()
});

// Royalty reports table (for imported statements)
export const royaltyReports = pgTable("royalty_reports", {
  id: serial("id").primaryKey(),
  source: text("source").notNull(),
  periodStartDate: date("period_start_date").notNull(),
  periodEndDate: date("period_end_date").notNull(),
  importedBy: integer("imported_by").notNull().references(() => users.id),
  status: text("status").notNull(), // importing, processed, error
  fileName: text("file_name"),
  filePath: text("file_path"),
  processingError: text("processing_error"),
  processingStats: jsonb("processing_stats"),
  importedAt: timestamp("imported_at").defaultNow().notNull(),
  processedAt: timestamp("processed_at")
});
```

### Key Components

#### 1. Royalty Split Management

The royalty split management system allows users to define how revenue is distributed among rights holders:

```typescript
// Split creation service
export class RoyaltySplitService {
  async createSplit(data: {
    releaseId?: number;
    trackId?: number;
    name: string;
    description?: string;
    createdBy: number;
    recipients: Array<{
      userId?: number;
      name: string;
      email?: string;
      percentage: number;
      role?: string;
      paymentDetails?: any;
    }>;
  }): Promise<RoyaltySplit> {
    // Validate that percentages add up to 100%
    const totalPercentage = data.recipients.reduce((sum, recipient) => {
      return sum + Number(recipient.percentage);
    }, 0);

    if (totalPercentage !== 100) {
      throw new Error("Split percentages must add up to 100%");
    }

    // Create the split
    const split = await db.transaction(async (tx) => {
      // Create the split record
      const [splitRecord] = await tx
        .insert(royaltySplits)
        .values({
          releaseId: data.releaseId,
          trackId: data.trackId,
          name: data.name,
          description: data.description,
          createdBy: data.createdBy
        })
        .returning();

      // Create the recipients
      for (const recipient of data.recipients) {
        await tx
          .insert(royaltySplitRecipients)
          .values({
            splitId: splitRecord.id,
            userId: recipient.userId,
            name: recipient.name,
            email: recipient.email,
            percentage: recipient.percentage,
            role: recipient.role,
            paymentDetails: recipient.paymentDetails
          });
      }

      return splitRecord;
    });

    return split;
  }

  // Other methods...
}
```

#### 2. Revenue Collection and Import

The revenue collection system handles importing and processing revenue data from various sources:

```typescript
// Revenue import service
export class RevenueImportService {
  async importRevenueFromCSV(file: Buffer, source: string, importedBy: number): Promise<{
    transactionsCreated: number;
    totalAmount: number;
  }> {
    const records = await this.parseCSVFile(file);

    // Process the records
    let transactionsCreated = 0;
    let totalAmount = 0;

    await db.transaction(async (tx) => {
      for (const record of records) {
        // Map the record to a revenue transaction
        const transaction = this.mapRecordToTransaction(record, source);

        // Insert the transaction
        const [inserted] = await tx
          .insert(revenueTransactions)
          .values(transaction)
          .returning();

        transactionsCreated++;
        totalAmount += Number(inserted.amount);
      }
    });

    return { transactionsCreated, totalAmount };
  }

  // Other methods...
}
```

#### 3. Statement Generation

The statement generation system creates royalty statements for rights holders:

```typescript
// Statement generation service
export class RoyaltyStatementService {
  async generateStatementsForPeriod(periodId: number): Promise<{
    statementsGenerated: number;
    totalAmount: number;
  }> {
    // Get the period
    const period = await db
      .select()
      .from(royaltyPeriods)
      .where(eq(royaltyPeriods.id, periodId))
      .limit(1)
      .then((rows) => rows[0]);

    if (!period) {
      throw new Error("Period not found");
    }

    // Get all splits
    const splits = await db
      .select()
      .from(royaltySplits)
      .innerJoin(royaltySplitRecipients, eq(royaltySplits.id, royaltySplitRecipients.splitId));

    // Get all revenue for the period
    const revenue = await db
      .select()
      .from(revenueTransactions)
      .where(
        and(
          gte(revenueTransactions.transactionDate, period.startDate),
          lte(revenueTransactions.transactionDate, period.endDate)
        )
      );

    // Group revenue by release/track
    const revenueByContent = this.groupRevenueByContent(revenue);

    // Generate statements
    const statements = await this.createStatementsFromRevenue(
      period,
      splits,
      revenueByContent
    );

    return statements;
  }

  // Other methods...
}
```

#### 4. Payment Processing

The payment processing system handles withdrawals and payment distribution:

```typescript
// Payment processing service
export class PaymentService {
  async processWithdrawal(withdrawalId: number): Promise<Withdrawal> {
    // Get the withdrawal
    const withdrawal = await db
      .select()
      .from(withdrawals)
      .where(eq(withdrawals.id, withdrawalId))
      .limit(1)
      .then((rows) => rows[0]);

    if (!withdrawal) {
      throw new Error("Withdrawal not found");
    }

    // Get the payment method
    const paymentMethod = await db
      .select()
      .from(paymentMethods)
      .where(eq(paymentMethods.id, withdrawal.paymentMethodId))
      .limit(1)
      .then((rows) => rows[0]);

    if (!paymentMethod) {
      throw new Error("Payment method not found");
    }

    // Process the payment based on the method type
    let processingResult;

    switch (paymentMethod.type) {
      case 'bank_account':
        processingResult = await this.processBankTransfer(withdrawal, paymentMethod);
        break;
      case 'paypal':
        processingResult = await this.processPayPalPayment(withdrawal, paymentMethod);
        break;
      // Other payment methods...
      default:
        throw new Error(`Unsupported payment method: ${paymentMethod.type}`);
    }

    // Update the withdrawal status
    const [updated] = await db
      .update(withdrawals)
      .set({
        status: processingResult.success ? 'completed' : 'failed',
        processingDetails: processingResult.details,
        processedAt: new Date(),
        completedAt: processingResult.success ? new Date() : null
      })
      .where(eq(withdrawals.id, withdrawalId))
      .returning();

    return updated;
  }

  // Other methods...
}
```

### API Endpoints

The payment and revenue management system exposes the following key endpoints:

```typescript
// Payment methods endpoints
router.get('/api/payment-methods', requireAuth, async (req, res) => {
  // Get payment methods for the authenticated user
});

router.post('/api/payment-methods', requireAuth, async (req, res) => {
  // Create a new payment method for the authenticated user
});

router.delete('/api/payment-methods/:id', requireAuth, async (req, res) => {
  // Delete a payment method
});

// Withdrawals endpoints
router.get('/api/withdrawals', requireAuth, async (req, res) => {
  // Get withdrawals for the authenticated user
});

router.post('/api/withdrawals', requireAuth, async (req, res) => {
  // Create a withdrawal request
});

// Royalty splits endpoints
router.get('/api/royalty-splits', requireAuth, async (req, res) => {
  // Get royalty splits for the authenticated user
});

router.post('/api/royalty-splits', requireAuth, async (req, res) => {
  // Create a new royalty split
});

// Statements endpoints
router.get('/api/royalty-statements', requireAuth, async (req, res) => {
  // Get royalty statements for the authenticated user
});

router.get('/api/royalty-statements/:id/download', requireAuth, async (req, res) => {
  // Download a royalty statement PDF
});

// Revenue endpoints
router.get('/api/revenue/overview', requireAuth, async (req, res) => {
  // Get revenue overview for the authenticated user
});

router.get('/api/revenue/by-platform', requireAuth, async (req, res) => {
  // Get revenue breakdown by platform
});

router.get('/api/revenue/by-country', requireAuth, async (req, res) => {
  // Get revenue breakdown by country
});
```

### Integration with Other Systems

The payment and revenue management system integrates with several other components:

#### 1. Analytics Integration

```typescript
// Revenue analytics service
export class RevenueAnalyticsService {
  async getRevenueOverview(userId: number, startDate: Date, endDate: Date): Promise<{
    totalRevenue: number;
    previousPeriodRevenue: number;
    percentageChange: number;
    platformBreakdown: Array<{
      platform: string;
      amount: number;
      percentage: number;
    }>;
    trendData: Array<{
      date: string;
      amount: number;
    }>;
  }> {
    // Implementation...
  }

  // Other methods...
}
```

#### 2. Distribution System Integration

```typescript
// Revenue tracking for distributions
export class DistributionRevenueService {
  async trackRevenueForDistribution(distributionId: number): Promise<{
    tracked: boolean;
    revenue: number;
  }> {
    // Implementation...
  }

  // Other methods...
}
```

#### 3. Blockchain Integration

```typescript
// Blockchain payment service
export class BlockchainPaymentService {
  async createPaymentContract(splitId: number): Promise<{
    contractAddress: string;
    transactionHash: string;
  }> {
    // Implementation...
  }

  async distributePayment(contractAddress: string, amount: string): Promise<{
    success: boolean;
    transactionHash: string;
  }> {
    // Implementation...
  }

  // Other methods...
}
```

### Security Features

The payment system implements robust security measures:

1. **Payment Information Protection**
   - Encrypted storage of payment details
   - Tokenization for sensitive information
   - PCI compliance for card handling

2. **Authorization Controls**
   - Strict permission checks for payment operations
   - Multi-factor authentication for withdrawals
   - IP-based restrictions for payment activities

3. **Audit Logging**
   - Comprehensive logging of all financial operations
   - Immutable audit trail for compliance
   - Automated anomaly detection

4. **Fraud Prevention**
   - Unusual activity detection
   - Withdrawal limits and velocity checks
   - Verification requirements for large transactions

### Future Development Roadmap

| Feature | Priority | Status | Timeline |
|---------|----------|--------|----------|
| Multi-Currency Support | High | In Development | Q2 2025 |
| Tax Withholding | High | In Development | Q2 2025 |
| Enhanced Banking Integration | Medium | Planned | Q2-Q3 2025 |
| Smart Contract Royalties | Medium | In Development | Q3 2025 |
| Automated Reconciliation | Medium | Planned | Q3 2025 |
| Advanced Fraud Detection | Medium | Planned | Q3-Q4 2025 |
| Payment Request System | Low | Planned | Q4 2025 |
| Marketplace Payments | Low | Planned | Q4 2025 |

---

**Document Owner**: Financial Systems Team  
**Created**: March 3, 2025  
**Last Updated**: March 18, 2025  
**Status**: In Progress  
**Related Documents**:
- [Royalty Management Overview](../../royalty-management.md)
- [API Reference - Payment Endpoints](../../api/api-reference.md)
- [Blockchain Integration for Payments](../blockchain/blockchain-payments.md)

---

#### 2025-03-17: Payment System Reference
_Source: unified_documentation/payment/17032025-payment-system-reference.md (Branch: 17032025)_


### Overview

This reference document provides detailed technical specifications for the TuneMantra payment system's data models, API endpoints, and integration points. It serves as the definitive technical reference for developers working with the payment infrastructure.

### Database Schema Reference

#### Table: payment_methods

| Column      | Type      | Constraints           | Description                               |
|-------------|-----------|----------------------|-------------------------------------------|
| id          | serial    | PRIMARY KEY          | Unique identifier                         |
| userId      | integer   | NOT NULL, REFERENCES | Foreign key to users table                |
| type        | text      | NOT NULL             | Payment method type (bank_account, card, paypal) |
| lastFour    | text      | NOT NULL             | Last four digits of account/card number   |
| accountName | text      | NOT NULL             | Name on the account                       |
| details     | jsonb     | NOT NULL, DEFAULT {} | Additional payment method details         |
| isDefault   | boolean   | NOT NULL, DEFAULT false | Whether this is the default payment method |
| createdAt   | timestamp | NOT NULL, DEFAULT NOW | Creation timestamp                       |
| updatedAt   | timestamp | NOT NULL, DEFAULT NOW | Last update timestamp                    |

#### Table: withdrawals

| Column          | Type      | Constraints           | Description                               |
|-----------------|-----------|----------------------|-------------------------------------------|
| id              | serial    | PRIMARY KEY          | Unique identifier                         |
| userId          | integer   | NOT NULL, REFERENCES | Foreign key to users table                |
| paymentMethodId | integer   | NOT NULL, REFERENCES | Foreign key to payment_methods table      |
| amount          | numeric   | NOT NULL             | Withdrawal amount                         |
| currency        | text      | NOT NULL             | Currency code (e.g., USD, EUR)            |
| status          | text      | NOT NULL, DEFAULT 'pending' | Status of withdrawal (pending, processing, completed, declined) |
| processedAt     | timestamp |                      | When the withdrawal was processed         |
| notes           | text      |                      | Additional notes                          |
| referenceNumber | text      |                      | External reference number                 |
| createdAt       | timestamp | NOT NULL, DEFAULT NOW | Creation timestamp                       |
| updatedAt       | timestamp | NOT NULL, DEFAULT NOW | Last update timestamp                    |

#### Table: revenue_splits

| Column    | Type      | Constraints           | Description                               |
|-----------|-----------|----------------------|-------------------------------------------|
| id        | serial    | PRIMARY KEY          | Unique identifier                         |
| title     | text      | NOT NULL             | Title of the revenue split arrangement    |
| trackId   | integer   | NOT NULL, REFERENCES | Foreign key to tracks table               |
| ownerId   | integer   | NOT NULL, REFERENCES | Foreign key to users table                |
| splits    | jsonb     | NOT NULL             | Array of split objects                    |
| createdAt | timestamp | NOT NULL, DEFAULT NOW | Creation timestamp                       |
| updatedAt | timestamp | NOT NULL, DEFAULT NOW | Last update timestamp                    |

#### JSON Structures

##### Payment Method Details Object

The `details` column in the `payment_methods` table can contain different fields based on the payment method type:

**Bank Account**:
```json
{
  "bankName": "Example Bank",
  "accountType": "Checking",
  "routingNumber": "XXXX1234",
  "country": "US",
  "swiftCode": "EXAMPUS12"
}
```

**Credit/Debit Card**:
```json
{
  "cardBrand": "Visa",
  "expiryMonth": "12",
  "expiryYear": "2025",
  "cardholderName": "John Doe",
  "billingAddress": {
    "street": "123 Main St",
    "city": "Anytown",
    "state": "CA",
    "postalCode": "12345",
    "country": "US"
  }
}
```

**PayPal**:
```json
{
  "email": "user@example.com",
  "accountType": "Personal",
  "verified": true
}
```

##### Revenue Split Object

The `splits` column in the `revenue_splits` table contains an array of split objects:

```json
[
  {
    "artistId": 123,
    "artistName": "John Doe",
    "role": "Primary Artist",
    "percentage": 75
  },
  {
    "artistId": 456,
    "artistName": "Jane Smith",
    "role": "Featured Artist",
    "percentage": 25
  }
]
```

### API Endpoints Reference

#### Payment Methods Endpoints

##### GET /api/payment-methods

Retrieves all payment methods for the authenticated user.

**Response**:
```typescript
interface PaymentMethodsResponse {
  success: boolean;
  data: Array<{
    id: number;
    type: string;
    lastFour: string;
    accountName: string;
    isDefault: boolean;
    createdAt: string;
    updatedAt: string;
  }>;
}
```

##### GET /api/payment-methods/:id

Retrieves a specific payment method by ID.

**Parameters**:
- `id`: Payment method ID

**Response**:
```typescript
interface PaymentMethodResponse {
  success: boolean;
  data: {
    id: number;
    type: string;
    lastFour: string;
    accountName: string;
    isDefault: boolean;
    createdAt: string;
    updatedAt: string;
  };
}
```

##### POST /api/payment-methods

Adds a new payment method for the authenticated user.

**Request Body**:
```typescript
interface CreatePaymentMethodRequest {
  type: 'bank_account' | 'card' | 'paypal';
  lastFour: string;
  accountName: string;
  isDefault?: boolean;
  details?: Record<string, any>;
}
```

**Response**:
```typescript
interface CreatePaymentMethodResponse {
  success: boolean;
  data: {
    id: number;
    type: string;
    lastFour: string;
    accountName: string;
    isDefault: boolean;
    createdAt: string;
    updatedAt: string;
  };
}
```

##### PUT /api/payment-methods/:id

Updates an existing payment method.

**Parameters**:
- `id`: Payment method ID

**Request Body**:
```typescript
interface UpdatePaymentMethodRequest {
  accountName?: string;
  isDefault?: boolean;
  details?: Record<string, any>;
}
```

**Response**:
```typescript
interface UpdatePaymentMethodResponse {
  success: boolean;
  data: {
    id: number;
    type: string;
    lastFour: string;
    accountName: string;
    isDefault: boolean;
    createdAt: string;
    updatedAt: string;
  };
}
```

##### DELETE /api/payment-methods/:id

Removes a payment method.

**Parameters**:
- `id`: Payment method ID

**Response**:
```typescript
interface DeletePaymentMethodResponse {
  success: boolean;
  data: {
    message: string;
  };
}
```

#### Withdrawals Endpoints

##### GET /api/withdrawals

Retrieves all withdrawal requests for the authenticated user.

**Query Parameters**:
- `status` (optional): Filter by status
- `limit` (optional): Maximum number of records to return
- `offset` (optional): Offset for pagination

**Response**:
```typescript
interface WithdrawalsResponse {
  success: boolean;
  data: Array<{
    id: number;
    paymentMethodId: number;
    amount: number;
    currency: string;
    status: string;
    notes?: string;
    createdAt: string;
    updatedAt: string;
    processedAt?: string;
  }>;
  pagination: {
    total: number;
    limit: number;
    offset: number;
  };
}
```

##### GET /api/withdrawals/:id

Retrieves a specific withdrawal by ID.

**Parameters**:
- `id`: Withdrawal ID

**Response**:
```typescript
interface WithdrawalResponse {
  success: boolean;
  data: {
    id: number;
    paymentMethodId: number;
    amount: number;
    currency: string;
    status: string;
    notes?: string;
    createdAt: string;
    updatedAt: string;
    processedAt?: string;
    paymentMethod: {
      id: number;
      type: string;
      lastFour: string;
      accountName: string;
    };
  };
}
```

##### POST /api/withdrawals

Creates a new withdrawal request.

**Request Body**:
```typescript
interface CreateWithdrawalRequest {
  paymentMethodId: number;
  amount: number;
  currency: string;
  notes?: string;
}
```

**Response**:
```typescript
interface CreateWithdrawalResponse {
  success: boolean;
  data: {
    id: number;
    paymentMethodId: number;
    amount: number;
    currency: string;
    status: string;
    notes?: string;
    createdAt: string;
    updatedAt: string;
    processedAt?: string;
  };
}
```

##### POST /api/withdrawals/:id/cancel

Cancels a pending withdrawal request.

**Parameters**:
- `id`: Withdrawal ID

**Response**:
```typescript
interface CancelWithdrawalResponse {
  success: boolean;
  data: {
    message: string;
  };
}
```

#### Revenue Splits Endpoints

##### GET /api/payment/revenue-splits

Retrieves all revenue splits for the authenticated user.

**Response**:
```typescript
interface RevenueSplitsResponse {
  success: boolean;
  data: {
    ownedTracks: Array<{
      id: number;
      title: string;
      artistName: string;
      revenue: number;
    }>;
    revenueSplits: Array<{
      id: number;
      title: string;
      trackId: number;
      splits: Array<{
        artistId?: number;
        artistName: string;
        role: string;
        percentage: number;
      }>;
      createdAt: string;
    }>;
  };
}
```

##### GET /api/payment/revenue-splits/:id

Retrieves a specific revenue split by ID.

**Parameters**:
- `id`: Revenue split ID

**Response**:
```typescript
interface RevenueSplitResponse {
  success: boolean;
  data: {
    id: number;
    title: string;
    trackId: number;
    trackTitle: string;
    splits: Array<{
      artistId?: number;
      artistName: string;
      role: string;
      percentage: number;
    }>;
    createdAt: string;
    updatedAt: string;
  };
}
```

##### POST /api/payment/revenue-splits

Creates a new revenue split arrangement.

**Request Body**:
```typescript
interface CreateRevenueSplitRequest {
  title: string;
  trackId: number;
  splits: Array<{
    artistId?: number;
    artistName: string;
    role: string;
    percentage: number;
  }>;
}
```

**Response**:
```typescript
interface CreateRevenueSplitResponse {
  success: boolean;
  data: {
    id: number;
    title: string;
    trackId: number;
    splits: Array<{
      artistId?: number;
      artistName: string;
      role: string;
      percentage: number;
    }>;
    createdAt: string;
    updatedAt: string;
  };
}
```

##### PUT /api/payment/revenue-splits/:id

Updates an existing revenue split.

**Parameters**:
- `id`: Revenue split ID

**Request Body**:
```typescript
interface UpdateRevenueSplitRequest {
  title?: string;
  splits?: Array<{
    artistId?: number;
    artistName: string;
    role: string;
    percentage: number;
  }>;
}
```

**Response**:
```typescript
interface UpdateRevenueSplitResponse {
  success: boolean;
  data: {
    id: number;
    title: string;
    trackId: number;
    splits: Array<{
      artistId?: number;
      artistName: string;
      role: string;
      percentage: number;
    }>;
    createdAt: string;
    updatedAt: string;
  };
}
```

##### DELETE /api/payment/revenue-splits/:id

Deletes a revenue split arrangement.

**Parameters**:
- `id`: Revenue split ID

**Response**:
```typescript
interface DeleteRevenueSplitResponse {
  success: boolean;
  data: {
    message: string;
  };
}
```

### Error Codes Reference

| Code                     | HTTP Status | Description                                           |
|--------------------------|-------------|-------------------------------------------------------|
| `PAYMENT_METHOD_NOT_FOUND` | 404        | The requested payment method could not be found        |
| `WITHDRAWAL_NOT_FOUND`     | 404        | The requested withdrawal record could not be found     |
| `REVENUE_SPLIT_NOT_FOUND`  | 404        | The requested revenue split could not be found         |
| `INVALID_PAYMENT_TYPE`     | 400        | The payment method type provided is not supported      |
| `INVALID_LAST_FOUR`        | 400        | The last four digits provided are invalid              |
| `PAYMENT_METHOD_REQUIRED`  | 400        | A payment method is required for this operation        |
| `AMOUNT_REQUIRED`          | 400        | An amount is required for this operation               |
| `INSUFFICIENT_FUNDS`       | 400        | Insufficient funds for this withdrawal                 |
| `INVALID_SPLITS`           | 400        | The revenue splits do not add up to 100%               |
| `WITHDRAWAL_ALREADY_PROCESSED` | 400    | Cannot cancel a withdrawal that has already been processed |
| `UNAUTHORIZED`            | 401        | Not authorized to perform this operation               |
| `FORBIDDEN`               | 403        | Forbidden from accessing this resource                 |
| `INTERNAL_SERVER_ERROR`   | 500        | An unexpected error occurred                           |

### Integration Points

#### Razorpay Integration Reference

##### Webhook Events

When integrating with Razorpay, the system listens for the following webhook events:

| Event Name                | Description                                     |
|---------------------------|-------------------------------------------------|
| `payment.authorized`      | Payment has been authorized                      |
| `payment.failed`          | Payment has failed                               |
| `payment.captured`        | Payment has been captured                        |
| `refund.created`          | Refund has been created                          |
| `refund.processed`        | Refund has been processed                        |
| `refund.failed`           | Refund has failed                                |

##### Webhook Payload Format

```typescript
interface RazorpayWebhookPayload {
  event: string;
  payload: {
    payment: {
      entity: {
        id: string;
        amount: number;
        currency: string;
        status: string;
        method: string;
        created_at: number;
        // Additional fields
      };
    };
  };
  created_at: number;
}
```

##### Webhook Verification

The system verifies Razorpay webhooks using HMAC-SHA256 signatures:

```typescript
function verifyWebhookSignature(
  payload: string,
  signature: string,
  secret: string
): boolean {
  const expectedSignature = crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex');

  return crypto.timingSafeEqual(
    Buffer.from(expectedSignature, 'hex'),
    Buffer.from(signature, 'hex')
  );
}
```

### Security Reference

#### Encryption

Sensitive payment data is encrypted using AES-256-CBC:

```typescript
function encryptData(data: string): string {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv(
    'aes-256-cbc', 
    Buffer.from(process.env.ENCRYPTION_KEY!, 'hex'), 
    iv
  );

  let encrypted = cipher.update(data, 'utf8', 'hex');
  encrypted += cipher.final('hex');

  return `${iv.toString('hex')}:${encrypted}`;
}
```

#### Authentication

All payment endpoints require authentication via:

1. Session-based authentication (for browser clients)
2. API Key authentication (for server-to-server communication)

#### Authorization

Payment operations are subject to the following role-based permissions:

| Operation               | Admin | Label | Artist Manager | Artist |
|-------------------------|-------|-------|----------------|--------|
| List Payment Methods    | All   | Own   | Managed        | Own    |
| Create Payment Method   | All   | Own   | Managed        | Own    |
| Update Payment Method   | All   | Own   | Managed        | Own    |
| Delete Payment Method   | All   | Own   | Managed        | Own    |
| List Withdrawals        | All   | Own   | Managed        | Own    |
| Create Withdrawal       | All   | Own   | Managed        | Own    |
| Cancel Withdrawal       | All   | Own   | Managed        | Own    |
| List Revenue Splits     | All   | Own   | Managed        | Own    |
| Create Revenue Split    | All   | Own   | Managed        | Own    |
| Update Revenue Split    | All   | Own   | Managed        | Own    |
| Delete Revenue Split    | All   | Own   | Managed        | Own    |

### Validation Rules Reference

#### Payment Method Validation

- **type**: Must be one of 'bank_account', 'card', or 'paypal'
- **lastFour**: Must be exactly 4 digits
- **accountName**: Required, non-empty string
- **isDefault**: Boolean value

#### Withdrawal Validation

- **paymentMethodId**: Must be a valid ID of an existing payment method
- **amount**: Must be a positive number
- **currency**: Must be a valid 3-letter currency code
- **notes**: Optional string

#### Revenue Split Validation

- **title**: Required, non-empty string
- **trackId**: Must be a valid ID of an existing track
- **splits**: Array of split objects
  - **artistName**: Required, non-empty string
  - **role**: Required, non-empty string
  - **percentage**: Must be a number between 1 and 100
- Sum of all percentages must equal exactly 100%

### Constants Reference

#### Payment Method Types

```typescript
const PAYMENT_METHOD_TYPES = {
  BANK_ACCOUNT: 'bank_account',
  CARD: 'card',
  PAYPAL: 'paypal'
};
```

#### Withdrawal Status Types

```typescript
const WITHDRAWAL_STATUS = {
  PENDING: 'pending',
  PROCESSING: 'processing',
  COMPLETED: 'completed',
  DECLINED: 'declined'
};
```

#### Artist Roles

```typescript
const ARTIST_ROLES = {
  PRIMARY_ARTIST: 'Primary Artist',
  FEATURED_ARTIST: 'Featured Artist',
  PRODUCER: 'Producer',
  COMPOSER: 'Composer',
  LYRICIST: 'Lyricist',
  ARRANGER: 'Arranger',
  MIXER: 'Mixer',
  ENGINEER: 'Engineer'
};
```

#### Currency Codes

```typescript
const SUPPORTED_CURRENCIES = [
  'USD', // US Dollar
  'EUR', // Euro
  'GBP', // British Pound
  'INR', // Indian Rupee
  'CAD', // Canadian Dollar
  'AUD', // Australian Dollar
  'JPY', // Japanese Yen
  'SGD'  // Singapore Dollar
];
```

### Implementation Examples

#### Creating a Payment Method

```typescript
// Server-side implementation
app.post('/api/payment-methods', requireAuth, async (req: Request, res: Response) => {
  const userId = req.userId!;

  // Validate input
  const schema = z.object({
    type: z.enum(["bank_account", "card", "paypal"]),
    lastFour: z.string().length(4),
    accountName: z.string().min(1),
    isDefault: z.boolean().default(false),
    details: z.record(z.any()).optional().default({})
  });

  const validationResult = schema.safeParse(req.body);
  if (!validationResult.success) {
    return res.status(400).json({ 
      success: false, 
      error: validationResult.error 
    });
  }

  const data = validationResult.data;

  // If setting as default, unset any existing default
  if (data.isDefault) {
    await db.update(paymentMethods)
      .set({ isDefault: false })
      .where(eq(paymentMethods.userId, userId));
  }

  // Insert the new payment method
  const method = await db.insert(paymentMethods)
    .values({
      ...data,
      userId
    })
    .returning();

  return res.status(201).json({ success: true, data: method[0] });
});
```

#### Creating a Withdrawal

```typescript
// Server-side implementation
app.post('/api/withdrawals', requireAuth, async (req: Request, res: Response) => {
  const userId = req.userId!;

  // Validate input
  const schema = z.object({
    paymentMethodId: z.number(),
    amount: z.number().positive(),
    currency: z.string().length(3),
    notes: z.string().optional()
  });

  const validationResult = schema.safeParse(req.body);
  if (!validationResult.success) {
    return res.status(400).json({ 
      success: false, 
      error: validationResult.error 
    });
  }

  const data = validationResult.data;

  // Verify payment method exists and belongs to user
  const paymentMethod = await db.select()
    .from(paymentMethods)
    .where(and(
      eq(paymentMethods.id, data.paymentMethodId),
      eq(paymentMethods.userId, userId)
    ))
    .limit(1);

  if (paymentMethod.length === 0) {
    return res.status(404).json({
      success: false,
      error: {
        code: 'PAYMENT_METHOD_NOT_FOUND',
        message: 'Payment method not found or not owned by you'
      }
    });
  }

  // Check if user has sufficient funds
  const balance = await getUserBalance(userId);
  if (balance < data.amount) {
    return res.status(400).json({
      success: false,
      error: {
        code: 'INSUFFICIENT_FUNDS',
        message: 'Insufficient funds for this withdrawal'
      }
    });
  }

  // Create withdrawal request
  const withdrawal = await db.insert(withdrawals)
    .values({
      userId,
      paymentMethodId: data.paymentMethodId,
      amount: data.amount,
      currency: data.currency,
      status: WITHDRAWAL_STATUS.PENDING,
      notes: data.notes
    })
    .returning();

  return res.status(201).json({ success: true, data: withdrawal[0] });
});
```

#### Creating a Revenue Split

```typescript
// Server-side implementation
app.post('/api/payment/revenue-splits', requireAuth, async (req: Request, res: Response) => {
  const userId = req.userId!;

  // Validate input
  const schema = z.object({
    title: z.string().min(1),
    trackId: z.number(),
    splits: z.array(
      z.object({
        artistId: z.number().optional(),
        artistName: z.string().min(1),
        role: z.string().min(1),
        percentage: z.number().min(1).max(100)
      })
    ).refine(data => {
      const sum = data.reduce((acc, item) => acc + item.percentage, 0);
      return sum === 100;
    }, {
      message: "Percentages must add up to 100%",
      path: ["splits"]
    })
  });

  const validationResult = schema.safeParse(req.body);
  if (!validationResult.success) {
    return res.status(400).json({ 
      success: false, 
      error: validationResult.error 
    });
  }

  const data = validationResult.data;

  // Verify track exists and belongs to user
  const track = await db.select()
    .from(tracks)
    .where(and(
      eq(tracks.id, data.trackId),
      eq(tracks.userId, userId)
    ))
    .limit(1);

  if (track.length === 0) {
    return res.status(404).json({
      success: false,
      error: {
        code: 'TRACK_NOT_FOUND',
        message: 'Track not found or not owned by you'
      }
    });
  }

  // Create revenue split
  const revenueSplit = await db.insert(revenueSplits)
    .values({
      title: data.title,
      trackId: data.trackId,
      ownerId: userId,
      splits: data.splits
    })
    .returning();

  return res.status(201).json({ success: true, data: revenueSplit[0] });
});
```

---

#### 2025-03-17: TuneMantra Documentation
_Source: unified_documentation/technical/17032025-readme-new.md (Branch: 17032025)_


**Version: 2.0 | Last Updated: March 18, 2025**

Welcome to the TuneMantra documentation. This repository contains comprehensive documentation for all aspects of the TuneMantra music distribution platform.

### Quick Navigation

- **[Implementation Status](./status/implementation-status.md)**: Current project completion (85%)
- **[Documentation Guide](./documentation-guide-new.md)**: How to navigate the documentation
- **[For Business Stakeholders](./business/README.md)**: Business-focused documentation
- **[For Developers](./developer/README.md)**: Technical implementation details
- **[For End Users](./user-guides/README.md)**: Platform usage guides
- **[API Reference](./api/README.md)**: API documentation

### Platform Status

TuneMantra is currently at **85% overall completion** with core infrastructure and the distribution system fully implemented. The platform provides a comprehensive solution for music distribution, performance analytics, and royalty management, with development progressing on advanced features like blockchain integration and AI-powered analytics.

See the [Implementation Status](./status/implementation-status.md) document for detailed information.

### Documentation by Stakeholder

#### For Business Decision Makers

Resources providing high-level overviews of the platform, market position, and business value:

- [Executive Overview](./business/executive-overview.md)
- [Competitive Advantage](./business/competitive-advantage.md)
- [Implementation Status](./status/implementation-status.md)
- [Distribution Overview](./business/distribution-overview.md)

#### For Technical Teams

Resources providing implementation details, architecture specifications, and development guidelines:

- [Technical Architecture](./developer/technical-architecture-reference.md)
- [API Documentation](./api/api-reference.md)
- [Web3 Integration Guide](./developer/web3-integration-guide.md)
- [Project Structure](./developer/project-structure.md)
- [Database Schema](./developer/database-schema.md)

#### For Operational Teams

Resources detailing core functionalities and operational aspects of the platform:

- [Distribution System](./distribution-system.md)
- [Royalty Management](./royalty-management.md)
- [Analytics System](./analytics-system.md)

#### For End Users

Resources providing guidance for using the TuneMantra platform:

- [Getting Started Guide](./user-guides/getting-started-guide.md)
- [User Guides](./user-guides/README.md)

### Documentation by Core System

#### Distribution System (100% Complete)

- [Distribution System Overview](./distribution-system.md)
- [Distribution Technical Reference](./developer/distribution-technical-reference.md)
- [Platform Integration Guide](./api/platform-integration-guide.md)

#### Royalty Management (70% Complete)

- [Royalty Management Overview](./royalty-management.md)
- [Royalty Calculation Reference](./developer/royalty-calculation-reference.md)
- [Royalty API Reference](./api/royalty-api-reference.md)

#### Analytics System (75% Complete)

- [Analytics System Overview](./analytics-system.md)
- [Analytics Technical Reference](./developer/analytics-technical-reference.md)
- [Analytics API Reference](./api/analytics-api-reference.md)

#### Rights Management (60% Complete)

- [Rights Management Overview](./developer/rights-management-overview.md)
- [Rights Management Technical Reference](./developer/rights-management-technical-reference.md)
- [PRO Integration Guide](./api/pro-integration-guide.md)

### Web3 Integration (40% Complete)

- [Web3 Integration Guide](./web3-integration-guide.md)
- [Smart Contract Documentation](./developer/smart-contract-documentation.md)
- [Blockchain Integration Reference](./api/blockchain-integration-reference.md)

### Recent Updates

- **March 18, 2025**: Updated implementation status document with latest progress
- **March 15, 2025**: Added comprehensive database schema reference
- **March 10, 2025**: Updated distribution system documentation with retry mechanism details
- **March 5, 2025**: Added technical architecture reference document
- **March 1, 2025**: Reorganized documentation structure for better stakeholder alignment

### Contributing to Documentation

We welcome contributions to the TuneMantra documentation. To contribute:

1. Review the [Documentation Guide](./documentation-guide-new.md) for standards and organization
2. Make changes or additions following the established patterns
3. Submit changes through the appropriate channel
4. Include clear descriptions of what you've changed and why

### Documentation Support

For questions or issues with the documentation:

- Use the documentation feedback form in the TuneMantra platform
- Contact the documentation team directly
- File an issue in the documentation tracking system

---

#### 2025-03-17: TuneMantra Documentation Update
_Source: unified_documentation/technical/17032025-tunemantra-documentation-update-2025-03-18.md (Branch: 17032025)_


**March 18, 2025**

### Overview

This update report summarizes the comprehensive documentation consolidation performed across all TuneMantra project branches. All Markdown files from the six different branches (12march547, 3march, 3march1am, 5march8am, 8march258, main) have been extracted, organized, and consolidated into a coherent documentation structure.

### Documentation Consolidation Highlights

1. **Completed Branch Integration**: Successfully integrated and consolidated documentation from all six branches
   - Extracted unique files from each branch
   - Resolved duplicate content while preserving the most comprehensive information
   - Ensured all unique information was preserved

2. **Implemented Directory Structure**: Organized all documentation according to our standardized directory structure
   - Arranged content by target audience and technical domain
   - Created clear separation between business, technical, and user documentation
   - Archived outdated or superseded documentation

3. **Enhanced Documentation Systems**:
   - Created comprehensive documentation guide with formatting standards
   - Established documentation lifecycle processes
   - Developed cross-referencing system for better navigation

4. **Added System Documentation**:
   - Migrated comprehensive architecture documentation
   - Consolidated analytics platform documentation
   - Integrated payment and revenue management documentation
   - Added detailed API reference material

### Documentation System Organization

The documentation is now organized in a hierarchical structure designed to serve different stakeholders:

```
docs/
├── api/                       # API reference documentation
├── archive/                   # Archived/deprecated documentation
├── business/                  # Business and executive documentation
├── developer/                 # Technical implementation details
│   ├── analytics/             # Analytics system documentation
│   ├── architecture/          # System architecture documentation
│   ├── content-management/    # Content management documentation
│   ├── mobile/                # Mobile application documentation
│   ├── payment/               # Payment system documentation
│   ├── security/              # Security documentation
│   └── verification/          # Verification system documentation
├── status/                    # Implementation status tracking
└── user-guides/               # End-user documentation
```

### Key Documentation Added/Updated

| Documentation Area | Status | Key Files Added/Updated |
|--------------------|--------|-------------------------|
| Architecture | ✅ Complete | `developer/architecture/distribution-service-architecture.md`, `developer/architecture/technical-stack.md` |
| Analytics | ✅ Complete | `developer/analytics/analytics-platform.md`, `developer/analytics/analytics-platform-extended.md` |
| Payment System | ✅ Complete | `developer/payment/payment-revenue-management.md`, `developer/payment/payment-system-reference.md` |
| Content Management | ✅ Complete | `developer/content-management/catalogue-id-system.md`, `developer/content-management/advanced-metadata-system.md` |
| API Reference | ✅ Complete | `api/api-reference.md`, `api/payment-api-reference.md` |
| Mobile Application | ✅ Complete | `developer/mobile/mobile-application-implementation.md`, `developer/mobile/mobile-app-implementation-guide.md` |
| Implementation Status | ✅ Complete | `status/consolidated-implementation-status.md`, `status/development-roadmap.md` |
| Security | ✅ Complete | `developer/security/role-based-access.md` |

### Master Index Updates

The main `README.md` file has been completely updated to serve as a comprehensive navigation hub for all documentation areas. It now includes:

1. Quick links to all major documentation sections
2. Up-to-date implementation status summary
3. Directory structure overview
4. Recent documentation updates
5. Documentation contribution guidelines

### Benefits of Consolidation

This consolidation provides several key benefits:

1. **Single Source of Truth**: All documentation is now in one place
2. **Improved Discoverability**: Clear structure makes finding information easier
3. **Consistent Formatting**: Documentation follows uniform standards
4. **Comprehensive Coverage**: Gaps in documentation have been addressed
5. **Better Maintainability**: Standardized organization simplifies ongoing updates

### Next Steps

1. **Content Review**: Perform detailed review of consolidated content for accuracy
2. **Cross-Reference Verification**: Ensure all internal links are functioning
3. **User Guide Enhancement**: Complete remaining user guides
4. **Documentation Testing**: Verify all procedures and examples
5. **Versioning System**: Implement proper versioning for ongoing updates

### Conclusion

This documentation consolidation represents a significant milestone in the TuneMantra project, providing a comprehensive, well-organized knowledge base that will support all stakeholders as the platform continues to develop and mature.

---

**Document Owner**: Documentation Team  
**Last Updated**: March 18, 2025

---

#### 2025-03-17: Content Management Integration Guide
_Source: unified_documentation/tutorials/17032025-integration-guide.md (Branch: 17032025)_


**Version: 1.0 | Last Updated: March 18, 2025**

This guide provides comprehensive instructions for integrating with TuneMantra's Content Management System, enabling third-party applications to create, manage, and distribute music content.

### Overview

The Content Management System is the core of TuneMantra's platform, providing a robust framework for managing music releases, tracks, and associated metadata. This guide explains how to integrate with the system using TuneMantra's API.

### Authentication

All requests to the Content Management API require authentication. TuneMantra uses API keys for third-party integrations.

#### Obtaining an API Key

API keys are managed through the Developer Portal in TuneMantra:

1. Log in to your TuneMantra account
2. Navigate to Account Settings > Developer
3. Click "Create API Key"
4. Specify a name and the required scopes
5. Store the generated key securely (it will only be shown once)

#### Using API Keys

Include your API key in the `Authorization` header of all requests:

```
Authorization: Bearer YOUR_API_KEY
```

Example:

```bash
curl -X GET "https://api.tunemantra.com/api/releases" \
     -H "Authorization: Bearer YOUR_API_KEY"
```

#### API Key Scopes

For Content Management, the following scopes are available:

- `releases:read` - View releases
- `releases:write` - Create and update releases
- `tracks:read` - View tracks
- `tracks:write` - Create and update tracks
- `content:distribute` - Distribute content to platforms

### Core API Endpoints

#### Release Management

##### List Releases

```
GET /api/releases
```

Query parameters:
- `status` - Filter by release status
- `page` - Page number for pagination
- `limit` - Number of results per page

Example response:

```json
{
  "success": true,
  "data": [
    {
      "id": 123,
      "title": "Summer Vibes",
      "artist_name": "DJ Awesome",
      "release_date": "2025-06-15",
      "type": "album",
      "status": "draft",
      "upc": "123456789012",
      "catalogue_id": "TMCAT-789012",
      "cover_art_url": "/uploads/artwork/123456789.jpg",
      "created_at": "2025-03-10T12:00:00Z",
      "updated_at": "2025-03-10T12:00:00Z"
    }
  ],
  "pagination": {
    "total": 15,
    "page": 1,
    "limit": 20,
    "pages": 1
  }
}
```

##### Get Release Details

```
GET /api/releases/{id}
```

Example response:

```json
{
  "success": true,
  "data": {
    "id": 123,
    "title": "Summer Vibes",
    "artist_name": "DJ Awesome",
    "release_date": "2025-06-15",
    "type": "album",
    "status": "draft",
    "upc": "123456789012",
    "catalogue_id": "TMCAT-789012",
    "cover_art_url": "/uploads/artwork/123456789.jpg",
    "created_at": "2025-03-10T12:00:00Z",
    "updated_at": "2025-03-10T12:00:00Z",
    "tracks": [
      {
        "id": 456,
        "title": "Summer Nights",
        "artist_name": "DJ Awesome",
        "track_number": 1,
        "isrc": "ABCDE1234567",
        "audio_url": "/uploads/audio/456789.wav",
        "duration": 180
      }
    ]
  }
}
```

##### Create Release

```
POST /api/releases
```

Request body:

```json
{
  "title": "Summer Vibes",
  "artist_name": "DJ Awesome",
  "release_date": "2025-06-15",
  "type": "album",
  "genre": "electronic",
  "language": "english"
}
```

Example response:

```json
{
  "success": true,
  "data": {
    "id": 123,
    "title": "Summer Vibes",
    "artist_name": "DJ Awesome",
    "release_date": "2025-06-15",
    "type": "album",
    "status": "draft",
    "catalogue_id": "TMCAT-789012",
    "created_at": "2025-03-18T15:00:00Z",
    "updated_at": "2025-03-18T15:00:00Z"
  }
}
```

##### Update Release

```
PUT /api/releases/{id}
```

Request body:

```json
{
  "title": "Summer Vibes Deluxe",
  "upc": "123456789012"
}
```

Example response:

```json
{
  "success": true,
  "data": {
    "id": 123,
    "title": "Summer Vibes Deluxe",
    "artist_name": "DJ Awesome",
    "release_date": "2025-06-15",
    "type": "album",
    "status": "draft",
    "upc": "123456789012",
    "catalogue_id": "TMCAT-789012",
    "cover_art_url": "/uploads/artwork/123456789.jpg",
    "created_at": "2025-03-10T12:00:00Z",
    "updated_at": "2025-03-18T15:05:00Z"
  }
}
```

##### Submit Release for Validation

```
POST /api/releases/{id}/validate
```

Example response:

```json
{
  "success": true,
  "data": {
    "id": 123,
    "status": "pending_validation"
  },
  "message": "Release submitted for validation"
}
```

#### Track Management

##### Add Track to Release

```
POST /api/releases/{id}/tracks
```

This is a multipart/form-data request with the following fields:
- `data` - JSON string with track metadata
- `audio` - Audio file

Example data JSON:

```json
{
  "title": "Summer Nights",
  "artist_name": "DJ Awesome",
  "isrc": "ABCDE1234567",
  "track_number": 1,
  "explicit_content": false,
  "language": "english"
}
```

Example response:

```json
{
  "success": true,
  "data": {
    "id": 456,
    "release_id": 123,
    "title": "Summer Nights",
    "artist_name": "DJ Awesome",
    "track_number": 1,
    "isrc": "ABCDE1234567",
    "audio_url": "/uploads/audio/456789.wav",
    "duration": 180,
    "created_at": "2025-03-18T15:10:00Z",
    "updated_at": "2025-03-18T15:10:00Z"
  }
}
```

##### Update Track

```
PUT /api/tracks/{id}
```

This is a multipart/form-data request with the following fields:
- `data` - JSON string with track metadata
- `audio` - (Optional) Audio file to replace the existing one

Example data JSON:

```json
{
  "title": "Summer Nights (Extended Mix)",
  "explicit_content": true
}
```

Example response:

```json
{
  "success": true,
  "data": {
    "id": 456,
    "release_id": 123,
    "title": "Summer Nights (Extended Mix)",
    "artist_name": "DJ Awesome",
    "track_number": 1,
    "isrc": "ABCDE1234567",
    "audio_url": "/uploads/audio/456789.wav",
    "duration": 180,
    "explicit_content": true,
    "created_at": "2025-03-18T15:10:00Z",
    "updated_at": "2025-03-18T15:15:00Z"
  }
}
```

##### Remove Track

```
DELETE /api/tracks/{id}
```

Example response:

```json
{
  "success": true,
  "message": "Track removed successfully"
}
```

#### Artwork Management

##### Upload Release Artwork

```
POST /api/releases/{id}/artwork
```

This is a multipart/form-data request with the following field:
- `artwork` - Image file (JPG, PNG, or TIFF)

Example response:

```json
{
  "success": true,
  "data": {
    "artworkUrl": "/uploads/artwork/123456789.jpg",
    "metadata": {
      "dimensions": {
        "width": 3000,
        "height": 3000
      },
      "resolution": 300,
      "fileSize": 2458092,
      "format": "jpeg",
      "colorSpace": "RGB"
    }
  }
}
```

#### Distribution

##### Schedule Release Distribution

```
POST /api/releases/{id}/schedule
```

Request body:

```json
{
  "scheduledDate": "2025-06-15T00:00:00Z",
  "platforms": [1, 2, 3, 4]
}
```

Example response:

```json
{
  "success": true,
  "data": {
    "id": 789,
    "release_id": 123,
    "scheduled_date": "2025-06-15T00:00:00Z",
    "platforms": [1, 2, 3, 4],
    "status": "scheduled",
    "created_at": "2025-03-18T15:20:00Z"
  },
  "message": "Release scheduled successfully"
}
```

##### Initiate Immediate Distribution

```
POST /api/releases/{id}/distribute
```

Request body:

```json
{
  "platforms": [1, 2, 3, 4]
}
```

Example response:

```json
{
  "success": true,
  "data": [
    {
      "id": 101,
      "release_id": 123,
      "platform_id": 1,
      "status": "pending",
      "submitted_at": "2025-03-18T15:25:00Z"
    },
    {
      "id": 102,
      "release_id": 123,
      "platform_id": 2,
      "status": "pending",
      "submitted_at": "2025-03-18T15:25:00Z"
    }
  ],
  "message": "Distribution process initiated"
}
```

##### Request Takedown

```
POST /api/releases/{id}/takedown
```

Request body:

```json
{
  "reason": "Copyright issue - removing release immediately"
}
```

Example response:

```json
{
  "success": true,
  "data": {
    "id": 123,
    "status": "takedown_requested"
  },
  "message": "Takedown request submitted"
}
```

### Metadata Management

#### Get Complete Metadata

```
GET /api/releases/{id}/metadata
```

Example response:

```json
{
  "success": true,
  "metadata": {
    "title": "Summer Vibes Deluxe",
    "artist_name": "DJ Awesome",
    "release_date": "2025-06-15",
    "type": "album",
    "genre": "electronic",
    "language": "english",
    "upc": "123456789012",
    "album_information": {
      "original_release_date": "2025-06-01",
      "label_name": "Awesome Records",
      "catalog_number": "AR-2025-06"
    },
    "rights": {
      "copyright_owner": "Awesome Entertainment LLC",
      "copyright_year": 2025,
      "sound_recording_owner": "Awesome Entertainment LLC",
      "sound_recording_year": 2025
    },
    "marketing": {
      "promotional_text": "The hottest electronic album of summer 2025!",
      "primary_markets": ["US", "UK", "DE", "JP"],
      "target_audience": ["18-24", "25-34"]
    }
  }
}
```

#### Update Metadata

```
PUT /api/releases/{id}/metadata
```

Request body:

```json
{
  "album_information": {
    "original_release_date": "2025-06-01",
    "label_name": "Awesome Records",
    "catalog_number": "AR-2025-06"
  },
  "rights": {
    "copyright_owner": "Awesome Entertainment LLC",
    "copyright_year": 2025,
    "sound_recording_owner": "Awesome Entertainment LLC",
    "sound_recording_year": 2025
  },
  "marketing": {
    "promotional_text": "The hottest electronic album of summer 2025!",
    "primary_markets": ["US", "UK", "DE", "JP"],
    "target_audience": ["18-24", "25-34"]
  },
  "versionReason": "Adding marketing and rights information"
}
```

Example response:

```json
{
  "success": true,
  "metadata": {
    "title": "Summer Vibes Deluxe",
    "artist_name": "DJ Awesome",
    "release_date": "2025-06-15",
    "type": "album",
    "genre": "electronic",
    "language": "english",
    "upc": "123456789012",
    "album_information": {
      "original_release_date": "2025-06-01",
      "label_name": "Awesome Records",
      "catalog_number": "AR-2025-06"
    },
    "rights": {
      "copyright_owner": "Awesome Entertainment LLC",
      "copyright_year": 2025,
      "sound_recording_owner": "Awesome Entertainment LLC",
      "sound_recording_year": 2025
    },
    "marketing": {
      "promotional_text": "The hottest electronic album of summer 2025!",
      "primary_markets": ["US", "UK", "DE", "JP"],
      "target_audience": ["18-24", "25-34"]
    }
  }
}
```

#### Get Metadata Version History

```
GET /api/releases/{id}/metadata/versions
```

Example response:

```json
{
  "success": true,
  "versions": [
    {
      "id": 12,
      "entity_type": "release",
      "entity_id": 123,
      "user_id": 456,
      "version_number": 2,
      "changes": {
        "added": {
          "album_information": {
            "original_release_date": "2025-06-01",
            "label_name": "Awesome Records",
            "catalog_number": "AR-2025-06"
          },
          "rights": {
            "copyright_owner": "Awesome Entertainment LLC",
            "copyright_year": 2025,
            "sound_recording_owner": "Awesome Entertainment LLC",
            "sound_recording_year": 2025
          },
          "marketing": {
            "promotional_text": "The hottest electronic album of summer 2025!",
            "primary_markets": ["US", "UK", "DE", "JP"],
            "target_audience": ["18-24", "25-34"]
          }
        },
        "removed": {},
        "modified": {}
      },
      "created_at": "2025-03-18T15:30:00Z",
      "reason": "Adding marketing and rights information",
      "previous_version_id": 11,
      "user": {
        "id": 456,
        "username": "label_admin"
      }
    },
    {
      "id": 11,
      "entity_type": "release",
      "entity_id": 123,
      "user_id": 456,
      "version_number": 1,
      "changes": {
        "added": {
          "title": "Summer Vibes Deluxe",
          "artist_name": "DJ Awesome",
          "release_date": "2025-06-15",
          "type": "album",
          "genre": "electronic",
          "language": "english",
          "upc": "123456789012"
        },
        "removed": {},
        "modified": {}
      },
      "created_at": "2025-03-18T15:00:00Z",
      "reason": "Initial creation",
      "previous_version_id": null,
      "user": {
        "id": 456,
        "username": "label_admin"
      }
    }
  ]
}
```

#### Restore Metadata Version

```
POST /api/metadata/versions/{versionId}/restore
```

Example response:

```json
{
  "success": true,
  "metadata": {
    "title": "Summer Vibes",
    "artist_name": "DJ Awesome",
    "release_date": "2025-06-15",
    "type": "album",
    "genre": "electronic",
    "language": "english",
    "upc": "123456789012"
  }
}
```

### Validation

#### Validate Release

```
POST /api/releases/{id}/validate-only
```

This endpoint validates the release without changing its status.

Example response:

```json
{
  "success": true,
  "validation": {
    "valid": false,
    "errors": [
      {
        "field": "cover_art_url",
        "message": "Cover art is required"
      }
    ],
    "warnings": [
      {
        "field": "upc",
        "message": "UPC is recommended for optimal distribution"
      }
    ],
    "trackResults": {
      "456": {
        "valid": true,
        "errors": [],
        "warnings": [
          {
            "field": "isrc",
            "message": "ISRC is recommended for optimal distribution"
          }
        ]
      }
    }
  }
}
```

### Metadata Templates

#### List Templates

```
GET /api/metadata-templates
```

Query parameters:
- `entityType` - Filter by entity type ('release' or 'track')

Example response:

```json
{
  "success": true,
  "templates": [
    {
      "id": 1,
      "name": "Electronic Release",
      "description": "Template for electronic music releases",
      "entity_type": "release",
      "is_global": true,
      "created_at": "2025-01-15T10:00:00Z"
    },
    {
      "id": 2,
      "name": "My Custom Template",
      "description": "Personal template for my releases",
      "entity_type": "release",
      "is_global": false,
      "created_at": "2025-03-10T15:00:00Z"
    }
  ]
}
```

#### Create Template

```
POST /api/metadata-templates
```

Request body:

```json
{
  "name": "Rock Release",
  "description": "Template for rock music releases",
  "entityType": "release",
  "templateData": {
    "genre": "rock",
    "language": "english",
    "rights": {
      "copyright_owner": "My Company LLC",
      "sound_recording_owner": "My Company LLC"
    },
    "marketing": {
      "primary_markets": ["US", "UK", "CA", "AU"]
    }
  },
  "isGlobal": false
}
```

Example response:

```json
{
  "success": true,
  "template": {
    "id": 3,
    "name": "Rock Release",
    "description": "Template for rock music releases",
    "entity_type": "release",
    "template_data": {
      "genre": "rock",
      "language": "english",
      "rights": {
        "copyright_owner": "My Company LLC",
        "sound_recording_owner": "My Company LLC"
      },
      "marketing": {
        "primary_markets": ["US", "UK", "CA", "AU"]
      }
    },
    "is_global": false,
    "created_at": "2025-03-18T16:00:00Z"
  }
}
```

#### Apply Template

```
POST /api/metadata-templates/{templateId}/apply
```

Request body:

```json
{
  "entityType": "release",
  "entityId": 123,
  "overwrite": false
}
```

Example response:

```json
{
  "success": true,
  "metadata": {
    "title": "Summer Vibes Deluxe",
    "artist_name": "DJ Awesome",
    "release_date": "2025-06-15",
    "type": "album",
    "genre": "rock",
    "language": "english",
    "upc": "123456789012",
    "rights": {
      "copyright_owner": "My Company LLC",
      "sound_recording_owner": "My Company LLC"
    },
    "marketing": {
      "primary_markets": ["US", "UK", "CA", "AU"],
      "promotional_text": "The hottest electronic album of summer 2025!",
      "target_audience": ["18-24", "25-34"]
    }
  }
}
```

### Error Handling

The API uses standard HTTP status codes to indicate the success or failure of requests. Additionally, all responses include a `success` field that indicates whether the request was successful.

#### Error Response Format

```json
{
  "success": false,
  "message": "Error message describing what went wrong",
  "errors": [
    {
      "field": "Field name with error",
      "message": "Specific error message for this field"
    }
  ]
}
```

#### Common Error Codes

- `400 Bad Request` - Invalid request parameters or body
- `401 Unauthorized` - Missing or invalid API key
- `403 Forbidden` - Valid API key but insufficient permissions
- `404 Not Found` - Resource not found
- `409 Conflict` - Request conflicts with current state (e.g., trying to modify a release that's already distributed)
- `422 Unprocessable Entity` - Validation errors
- `429 Too Many Requests` - Rate limit exceeded
- `500 Internal Server Error` - Server-side error

### Webhooks

TuneMantra can send webhook notifications for important events related to content management. Configure webhooks in the Developer Portal.

#### Available Events

- `release.created` - New release created
- `release.updated` - Release details updated
- `release.validated` - Release validation completed
- `release.distributed` - Release distribution completed
- `release.failed` - Release distribution failed
- `track.created` - New track created
- `track.updated` - Track details updated

#### Webhook Payload Example

```json
{
  "event": "release.validated",
  "timestamp": "2025-03-18T16:15:00Z",
  "data": {
    "id": 123,
    "title": "Summer Vibes Deluxe",
    "status": "ready_for_distribution",
    "validation_result": {
      "valid": true,
      "warnings": [
        {
          "field": "upc",
          "message": "UPC is recommended for optimal distribution"
        }
      ]
    }
  }
}
```

### Rate Limits

API requests are subject to rate limiting to ensure fair usage of the platform. Current limits:

- 100 requests per minute per API key
- 5,000 requests per day per API key

Rate limit headers are included in all responses:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 99
X-RateLimit-Reset: 1616077340
```

### Best Practices

#### Efficient Release Creation

1. Create the release first
2. Upload artwork
3. Add tracks one by one
4. Update metadata with complete information
5. Validate the release
6. Schedule or distribute once validation passes

#### Error Handling

1. Always check the `success` field in responses
2. Handle validation errors by presenting them to users
3. Implement exponential backoff for rate limit errors
4. Use the validation endpoint before submitting for official validation

#### Performance Optimization

1. Use pagination for listing endpoints
2. Request only the data you need
3. Cache reference data like platforms and templates
4. Optimize audio files before uploading

#### Webhook Integration

1. Acknowledge webhook receipt quickly
2. Process webhooks asynchronously
3. Implement retry logic for failed webhook processing
4. Store webhook events for audit purposes

### Example Workflows

#### Complete Release Creation and Distribution

```javascript
// Step 1: Create a release
const releaseResponse = await api.post('/api/releases', {
  title: "Summer Vibes",
  artist_name: "DJ Awesome",
  release_date: "2025-06-15",
  type: "album",
  genre: "electronic",
  language: "english"
});

const releaseId = releaseResponse.data.data.id;

// Step 2: Upload artwork
const formData = new FormData();
formData.append('artwork', artworkFile);
await api.post(`/api/releases/${releaseId}/artwork`, formData);

// Step 3: Add tracks
for (const track of tracks) {
  const trackFormData = new FormData();
  const trackMetadata = {
    title: track.title,
    artist_name: "DJ Awesome",
    track_number: track.trackNumber,
    isrc: track.isrc,
    explicit_content: track.explicit
  };

  trackFormData.append('data', JSON.stringify(trackMetadata));
  trackFormData.append('audio', track.audioFile);

  await api.post(`/api/releases/${releaseId}/tracks`, trackFormData);
}

// Step 4: Add detailed metadata
await api.put(`/api/releases/${releaseId}/metadata`, {
  album_information: {
    label_name: "Awesome Records",
    catalog_number: "AR-2025-06"
  },
  rights: {
    copyright_owner: "Awesome Entertainment LLC",
    copyright_year: 2025
  },
  versionReason: "Adding detailed metadata"
});

// Step 5: Validate the release
await api.post(`/api/releases/${releaseId}/validate`);

// Step 6: Wait for validation to complete
let status = "pending_validation";
while (status === "pending_validation") {
  await sleep(5000); // Wait 5 seconds

  const releaseStatus = await api.get(`/api/releases/${releaseId}`);
  status = releaseStatus.data.data.status;

  if (status === "validation_failed") {
    throw new Error("Validation failed");
  }
}

// Step 7: Schedule distribution
if (status === "ready_for_distribution") {
  await api.post(`/api/releases/${releaseId}/schedule`, {
    scheduledDate: "2025-06-15T00:00:00Z",
    platforms: [1, 2, 3, 4] // Platform IDs
  });
}
```

#### Applying a Template and Customizing

```javascript
// Step 1: Get available templates
const templatesResponse = await api.get('/api/metadata-templates', {
  params: { entityType: 'release' }
});

const templateId = templatesResponse.data.templates[0].id;

// Step 2: Apply template to release
await api.post(`/api/metadata-templates/${templateId}/apply`, {
  entityType: 'release',
  entityId: releaseId,
  overwrite: false
});

// Step 3: Customize the template-applied metadata
const currentMetadata = await api.get(`/api/releases/${releaseId}/metadata`);
const metadata = currentMetadata.data.metadata;

// Customize specific fields
metadata.marketing.promotional_text = "Custom promotional text for this release";
metadata.marketing.target_audience = ["18-35", "electronic music fans"];

// Update with customizations
await api.put(`/api/releases/${releaseId}/metadata`, {
  ...metadata,
  versionReason: "Customizing template metadata"
});
```

### Conclusion

This guide provides a comprehensive overview of integrating with TuneMantra's Content Management System. For additional information or support, please contact the TuneMantra Developer Support team.

### Further Resources

- [API Reference Documentation](https://developers.tunemantra.com/api-reference)
- [SDK Documentation](https://developers.tunemantra.com/sdks)
- [Integration Examples](https://github.com/tunemantra/integration-examples)
- [Developer Support](https://developers.tunemantra.com/support)

---

#### 2025-03-17: Payment System Implementation Guide
_Source: unified_documentation/tutorials/17032025-payment-implementation-guide.md (Branch: 17032025)_


### Overview

The TuneMantra Payment System is a comprehensive solution for managing payment methods, processing withdrawals, and handling revenue splits between collaborating artists. This guide provides detailed technical information for developers implementing or extending payment functionality.

### Architecture

The payment system follows a layered architecture:

1. **Frontend Layer**: React components for payment method management, withdrawal requests, and revenue splits
2. **API Layer**: Express routes handling payment-related operations
3. **Service Layer**: Business logic for payment processing and validation
4. **Storage Layer**: Database operations for persisting payment data
5. **Integration Layer**: Razorpay integration for secure payment processing

### Key Components

#### Database Schema

Payment-related tables are defined in `shared/schema.ts`:

```typescript
// Payment Methods
export const paymentMethods = pgTable("payment_methods", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  type: text("type").notNull(), // bank_account, card, paypal
  lastFour: text("last_four").notNull(),
  details: jsonb("details").notNull().default({}),
  isDefault: boolean("is_default").notNull().default(false),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow()
});

// Withdrawals
export const withdrawals = pgTable("withdrawals", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  paymentMethodId: integer("payment_method_id").notNull()
    .references(() => paymentMethods.id),
  amount: text("amount").notNull(),
  currency: text("currency").notNull().default("USD"),
  status: text("status").notNull().default("pending"),
  notes: text("notes"),
  referenceNumber: text("reference_number"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  processedAt: timestamp("processed_at")
});
```

#### Backend Routes

Payment routes are defined in `server/routes/payment.ts`:

- **GET /api/payment-methods**: Retrieve user's payment methods
- **POST /api/payment-methods**: Add a new payment method
- **GET /api/withdrawals**: List user's withdrawals
- **POST /api/withdrawals**: Request a new withdrawal
- **GET /api/revenue-splits**: Get revenue splits configuration
- **POST /api/revenue-splits**: Update revenue splits configuration

#### Razorpay Integration

Razorpay is integrated for secure payment processing:

```typescript
// Create a payment session
export async function createPayment(amount: number, currency: string, userId: number) {
  const razorpay = new Razorpay({
    key_id: process.env.RAZORPAY_KEY_ID!,
    key_secret: process.env.RAZORPAY_KEY_SECRET!
  });

  const options: RazorpayOrderOptions = {
    amount: amount * 100, // Convert to smallest currency unit
    currency,
    receipt: `pay_${userId}_${Date.now()}`,
    notes: {
      userId: userId.toString()
    }
  };

  return await razorpay.orders.create(options);
}

// Verify payment signature
export function verifyPayment(orderId: string, paymentId: string, signature: string) {
  const razorpay = new Razorpay({
    key_id: process.env.RAZORPAY_KEY_ID!,
    key_secret: process.env.RAZORPAY_KEY_SECRET!
  });

  return razorpay.validatePaymentVerification({
    order_id: orderId,
    payment_id: paymentId,
    signature: signature
  });
}
```

### Implementation Guidelines

#### Adding a New Payment Method

1. Frontend: Use the PaymentMethodForm component in `client/src/components/payments/PaymentMethodForm.tsx`
2. API: Make a POST request to `/api/payment-methods`
3. Validation: Ensure the payment method details are validated

Example:

```typescript
// Frontend submission
const handleSubmit = async (data) => {
  try {
    await mutateAsync({
      method: 'POST',
      data: {
        type: data.type,
        lastFour: data.lastFour,
        accountName: data.accountName,
        details: data.details,
        isDefault: data.isDefault
      }
    });
    toast({
      title: "Payment method added",
      description: "Your payment method has been added successfully",
    });

  } catch (error) {
    toast({
      title: "Failed to add payment method",
      description: error.message,
      variant: "destructive"
    });
  }
};
```

#### Processing a Withdrawal

1. User submits a withdrawal request specifying:
   - Payment method ID
   - Amount
   - Currency
   - Optional notes
2. Backend validates the request
3. System creates a withdrawal record with "pending" status
4. Admin approves or rejects the withdrawal
5. On approval, funds are sent to the specified payment method
6. Withdrawal status is updated to "completed"

#### Revenue Split Implementation

Revenue splits allow artists to distribute earnings to collaborators:

1. Create a revenue split configuration
2. Specify percentages for each collaborator (must total 100%)
3. System applies splits when distributing revenue

Example data structure:

```typescript
const revenueSplit = {
  title: "Album Collaboration",
  splits: [
    { artistName: "Primary Artist", role: "Artist", percentage: 70 },
    { artistName: "Featured Artist", role: "Feature", percentage: 20 },
    { artistName: "Producer", role: "Producer", percentage: 10 }
  ]
};
```

### Security Considerations

1. **Data Encryption**: All payment method details are encrypted in the database
2. **Payment Validation**: All withdrawal requests require admin approval
3. **Rate Limiting**: API endpoints implement rate limiting to prevent abuse
4. **Input Validation**: All user inputs are validated using Zod schemas
5. **Webhook Verification**: Razorpay webhooks are verified using signatures

### Webhook Implementation

For production environments, implement webhooks to receive real-time payment notifications:

```typescript
app.post('/api/payment/webhook', async (req: Request, res: Response) => {
  try {
    // Verify webhook signature from Razorpay
    const signature = req.headers['x-razorpay-signature'] as string;
    const payload = req.body;

    if (!verifyWebhookSignature(payload, signature)) {
      return res.status(400).json({ error: 'Invalid signature' });
    }

    // Process the webhook event
    const event = payload.event;

    switch (event) {
      case 'payment.authorized':
        // Handle successful payment
        break;
      case 'payment.failed':
        // Handle failed payment
        break;
      default:
        // Handle other events
    }

    return res.status(200).json({ status: 'Webhook received' });

  } catch (error) {
    logger.error('Webhook processing error', { error });
    return res.status(500).json({ error: 'Webhook processing error' });
  }
});
```

### Testing Payment Integration

1. **Test Credentials**: Use Razorpay test credentials in development
2. **Test Cards**: Use [Razorpay's test cards](https://razorpay.com/docs/payments/payments/test-card-details/) for testing
3. **Webhook Testing**: Use tools like ngrok to test webhooks locally
4. **Unit Tests**: Implement unit tests for payment validations
5. **Integration Tests**: Test the complete payment flow

### Troubleshooting

#### Common Issues

1. **Payment Method Addition Fails**
   - Check that all required fields are provided
   - Ensure the payment method type is valid
   - Verify the user has permission to add payment methods

2. **Withdrawal Request Fails**
   - Ensure the payment method exists
   - Verify the user has sufficient funds
   - Check that the amount is valid

3. **Webhook Processing Issues**
   - Verify webhook URL is accessible
   - Check signature validation
   - Ensure proper event handling

### API Reference

For complete API documentation, see [Payment API Reference](../api/PAYMENT_API_REFERENCE.md).

### Further Reading

- [Payment System Architecture](../architecture/PAYMENT_SYSTEM_ARCHITECTURE.md)
- [Payment & Revenue Management](../features/PAYMENT_REVENUE_MANAGEMENT.md)

---

*This document was automatically generated to provide a comprehensive, chronological view of all project status information up to 2025-03-23.*

*© 2025 TuneMantra. All rights reserved.*


*Source: /home/runner/workspace/.archive/archive_docs/documentation/merged/api-reference-unified.md*

---

## Metadata for api-reference.md (3)

## Metadata for api-reference.md

**Original Path:** all_md_files/17032025/docs/api/api-reference.md

**Title:** TuneMantra API Reference

**Category:** api-reference

**Keywords:** ,Access,Account,Analytics,API,App,Authentication,Dashboard,Distribution,Endpoint,Payment,Permission,Platform,REST,Revenue,Role,Royalty,Service,Streaming,User

**MD5 Hash:** 169a5f22fd4fd12c95fb1ba00f543ef1

**Source Branch:** 17032025


*Source: /home/runner/workspace/.archive/archive_docs/documentation/metadata/17032025_api-reference.md*

---

## Metadata for api-reference.md (4)

## Metadata for api-reference.md

**Original Path:** all_md_files/17032025/docs/api/api-reference.md

**Title:** TuneMantra API Reference

**Category:** api-reference

**Keywords:** ,Access,Account,Analytics,API,App,Authentication,Dashboard,Distribution,Endpoint,Payment,Permission,Platform,REST,Revenue,Role,Royalty,Service,Streaming,User

**MD5 Hash:** 169a5f22fd4fd12c95fb1ba00f543ef1

**Source Branch:** 17032025

**Note:** This file has duplicate content in other branches.


*Source: /home/runner/workspace/.archive/archive_docs/documentation/metadata/17032025_api-reference.md.md*

---

## Metadata for payment-api-reference.md

## Metadata for payment-api-reference.md

**Original Path:** all_md_files/17032025/docs/api/payment-api-reference.md

**Title:** Payment System API Reference

**Category:** api-reference

**Keywords:** ,Account,Analytics,API,App,Architecture,Authentication,Dashboard,Distribution,Endpoint,Guide,Payment,Permission,Platform,Revenue,Role,Royalty,User

**MD5 Hash:** 6178bf1716ffeca4d3a4628f892f1f28

**Source Branch:** 17032025


*Source: /home/runner/workspace/.archive/archive_docs/documentation/metadata/17032025_payment-api-reference.md*

---

## Metadata for PAYMENT_API_REFERENCE.md

## Metadata for PAYMENT_API_REFERENCE.md

**Original Path:** all_md_files/3march1am/docs/api/PAYMENT_API_REFERENCE.md

**Title:** Payment System API Reference

**Category:** technical

**MD5 Hash:** 6178bf1716ffeca4d3a4628f892f1f28

**Source Branch:** 3march1am

**Note:** This file has duplicate content in other branches.


*Source: /home/runner/workspace/.archive/archive_docs/documentation/metadata/3march1am_payment-api-reference.md.md*

---

## TuneMantra API Reference (2)

## TuneMantra API Reference

### Introduction

The TuneMantra API provides programmatic access to your music catalog, distribution status, analytics, and royalty data. This comprehensive RESTful API allows you to integrate TuneMantra's powerful features into your own applications and workflows.

### Base URL

All API requests should be made to the following base URL:

```
https://api.tunemantra.com/v1
```

### Authentication

TuneMantra API uses API key authentication for all requests. You can generate API keys in your TuneMantra dashboard under Settings > API Keys.

#### Including Your API Key

Include your API key in the request header:

```
Authorization: Bearer YOUR_API_KEY
```

#### API Key Permissions

API keys can be scoped with specific permissions:

- `read:catalog` - View releases and tracks
- `write:catalog` - Create or update releases and tracks
- `read:analytics` - Access analytics data
- `read:royalties` - View royalty information
- `write:royalties` - Manage royalty splits
- `read:distribution` - View distribution status
- `write:distribution` - Create distributions

### Request Format

All requests should be sent as JSON with the following content type header:

```
Content-Type: application/json
```

### Response Format

All responses are returned in JSON format with the following structure:

```json
{
  "success": true,
  "data": {
    // Response data specific to the endpoint
  },
  "meta": {
    "total": 100,
    "page": 1,
    "limit": 10
  }
}
```

For error responses:

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": {
      // Additional error details
    }
  }
}
```

### Rate Limiting

The API enforces rate limits to ensure fair usage. Current limits are:

- 100 requests per minute for standard accounts
- 1000 requests per minute for premium accounts

Rate limit information is included in response headers:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1616551800
```

### Pagination

For endpoints that return collections, pagination is supported through the following query parameters:

- `page` - Page number (default: 1)
- `limit` - Results per page (default: 25, max: 100)

Pagination metadata is included in the response:

```json
"meta": {
  "total": 157,
  "page": 2,
  "limit": 25,
  "hasMore": true
}
```

### Filtering and Sorting

Many endpoints support filtering and sorting through query parameters:

- `sort` - Field to sort by
- `order` - Sort order ("asc" or "desc")
- Field-specific filters (e.g., `status=published`)

### API Endpoints

#### Authentication

##### Check Authentication Status

```
GET /auth/status
```

Returns the current authentication status and user information.

**Response Example:**

```json
{
  "success": true,
  "data": {
    "authenticated": true,
    "user": {
      "id": 12345,
      "username": "label_account",
      "role": "label"
    },
    "permissions": [
      "read:catalog",
      "write:catalog",
      "read:analytics"
    ]
  }
}
```

#### Catalog Management

##### List Releases

```
GET /releases
```

Returns a list of releases in your catalog.

**Query Parameters:**

| Parameter | Type   | Description |
|-----------|--------|-------------|
| `status`  | string | Filter by status (e.g., "draft", "published") |
| `type`    | string | Filter by release type (e.g., "single", "album") |
| `search`  | string | Search term for release title or artist |
| `page`    | number | Page number for pagination |
| `limit`   | number | Results per page |
| `sort`    | string | Field to sort by (e.g., "releaseDate", "title") |
| `order`   | string | Sort order ("asc" or "desc") |

**Response Example:**

```json
{
  "success": true,
  "data": [
    {
      "id": 123,
      "title": "Summer Vibes",
      "type": "album",
      "artist": "DJ Harmony",
      "releaseDate": "2025-06-15",
      "status": "published",
      "upc": "123456789012",
      "coverUrl": "https://assets.tunemantra.com/covers/123.jpg",
      "trackCount": 12
    },
    {
      "id": 124,
      "title": "Midnight Dreams",
      "type": "single",
      "artist": "Luna Echo",
      "releaseDate": "2025-05-01",
      "status": "published",
      "upc": "123456789013",
      "coverUrl": "https://assets.tunemantra.com/covers/124.jpg",
      "trackCount": 1
    }
  ],
  "meta": {
    "total": 45,
    "page": 1,
    "limit": 25,
    "hasMore": true
  }
}
```

##### Get Release Details

```
GET /releases/{releaseId}
```

Returns detailed information about a specific release.

**Path Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `releaseId` | number | Release ID  |

**Query Parameters:**

| Parameter | Type   | Description |
|-----------|--------|-------------|
| `expand`  | string | Comma-separated list of related resources to expand (e.g., "tracks,analytics") |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 123,
    "title": "Summer Vibes",
    "type": "album",
    "artist": "DJ Harmony",
    "releaseDate": "2025-06-15",
    "status": "published",
    "upc": "123456789012",
    "catalogueId": "TMCAT-87654-001",
    "label": "Harmony Records",
    "primaryGenre": "electronic",
    "secondaryGenres": ["dance", "house"],
    "language": "english",
    "explicit": false,
    "ownership": "original",
    "coverUrl": "https://assets.tunemantra.com/covers/123.jpg",
    "metadata": {
      "description": "A summer-themed electronic album with upbeat dance tracks.",
      "tags": ["summer", "dance", "electronic", "upbeat"],
      "credits": {
        "producer": "Alex Producer",
        "mixing": "Mix Master Studios",
        "mastering": "Final Touch Audio"
      }
    },
    "tracks": [
      {
        "id": 456,
        "title": "Sunshine Groove",
        "trackNumber": 1,
        "isrc": "USABC1234567",
        "duration": 210,
        "audioUrl": "https://assets.tunemantra.com/previews/456.mp3"
      },
      {
        "id": 457,
        "title": "Beach Party",
        "trackNumber": 2,
        "isrc": "USABC1234568",
        "duration": 195,
        "audioUrl": "https://assets.tunemantra.com/previews/457.mp3"
      }
    ],
    "distribution": {
      "status": "distributed",
      "platforms": [
        {
          "name": "Spotify",
          "status": "active",
          "url": "https://open.spotify.com/album/123456"
        },
        {
          "name": "Apple Music",
          "status": "active",
          "url": "https://music.apple.com/album/123456"
        }
      ]
    }
  }
}
```

##### Create a Release

```
POST /releases
```

Creates a new release in your catalog.

**Request Body:**

```json
{
  "title": "Winter Chill",
  "type": "ep",
  "primaryArtist": "Frost Beats",
  "releaseDate": "2025-12-01",
  "primaryGenre": "chill",
  "secondaryGenres": ["electronic", "ambient"],
  "language": "english",
  "explicit": false,
  "ownership": "original",
  "metadata": {
    "description": "A winter-themed EP with relaxing ambient tracks.",
    "tags": ["winter", "chill", "electronic", "ambient"],
    "credits": {
      "producer": "Frost Beats",
      "mixing": "Ice Studios",
      "mastering": "Northern Mastering"
    }
  }
}
```

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 125,
    "title": "Winter Chill",
    "type": "ep",
    "artist": "Frost Beats",
    "releaseDate": "2025-12-01",
    "status": "draft",
    "catalogueId": "TMCAT-87654-002",
    "primaryGenre": "chill",
    "secondaryGenres": ["electronic", "ambient"],
    "language": "english",
    "explicit": false,
    "ownership": "original",
    "metadata": {
      "description": "A winter-themed EP with relaxing ambient tracks.",
      "tags": ["winter", "chill", "electronic", "ambient"],
      "credits": {
        "producer": "Frost Beats",
        "mixing": "Ice Studios",
        "mastering": "Northern Mastering"
      }
    }
  }
}
```

##### Update a Release

```
PUT /releases/{releaseId}
```

Updates an existing release.

**Path Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `releaseId` | number | Release ID  |

**Request Body:**

```json
{
  "title": "Winter Chillout",
  "primaryGenre": "ambient",
  "secondaryGenres": ["chill", "electronic"],
  "metadata": {
    "description": "An updated winter-themed EP with relaxing ambient tracks.",
    "tags": ["winter", "ambient", "relaxing", "electronic"]
  }
}
```

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 125,
    "title": "Winter Chillout",
    "type": "ep",
    "artist": "Frost Beats",
    "releaseDate": "2025-12-01",
    "status": "draft",
    "catalogueId": "TMCAT-87654-002",
    "primaryGenre": "ambient",
    "secondaryGenres": ["chill", "electronic"],
    "language": "english",
    "explicit": false,
    "ownership": "original",
    "metadata": {
      "description": "An updated winter-themed EP with relaxing ambient tracks.",
      "tags": ["winter", "ambient", "relaxing", "electronic"],
      "credits": {
        "producer": "Frost Beats",
        "mixing": "Ice Studios",
        "mastering": "Northern Mastering"
      }
    }
  }
}
```

##### Delete a Release

```
DELETE /releases/{releaseId}
```

Deletes a release from your catalog.

**Path Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `releaseId` | number | Release ID  |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "message": "Release deleted successfully"
  }
}
```

##### List Tracks

```
GET /tracks
```

Returns a list of tracks in your catalog.

**Query Parameters:**

| Parameter    | Type   | Description |
|--------------|--------|-------------|
| `releaseId`  | number | Filter by release ID |
| `search`     | string | Search term for track title |
| `page`       | number | Page number for pagination |
| `limit`      | number | Results per page |
| `sort`       | string | Field to sort by (e.g., "title", "duration") |
| `order`      | string | Sort order ("asc" or "desc") |

**Response Example:**

```json
{
  "success": true,
  "data": [
    {
      "id": 456,
      "title": "Sunshine Groove",
      "releaseId": 123,
      "releaseName": "Summer Vibes",
      "artist": "DJ Harmony",
      "trackNumber": 1,
      "isrc": "USABC1234567",
      "duration": 210,
      "audioUrl": "https://assets.tunemantra.com/previews/456.mp3"
    },
    {
      "id": 457,
      "title": "Beach Party",
      "releaseId": 123,
      "releaseName": "Summer Vibes",
      "artist": "DJ Harmony",
      "trackNumber": 2,
      "isrc": "USABC1234568",
      "duration": 195,
      "audioUrl": "https://assets.tunemantra.com/previews/457.mp3"
    }
  ],
  "meta": {
    "total": 12,
    "page": 1,
    "limit": 25,
    "hasMore": false
  }
}
```

##### Get Track Details

```
GET /tracks/{trackId}
```

Returns detailed information about a specific track.

**Path Parameters:**

| Parameter | Type   | Description |
|-----------|--------|-------------|
| `trackId` | number | Track ID    |

**Query Parameters:**

| Parameter | Type   | Description |
|-----------|--------|-------------|
| `expand`  | string | Comma-separated list of related resources to expand (e.g., "release,analytics") |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 456,
    "title": "Sunshine Groove",
    "releaseId": 123,
    "releaseName": "Summer Vibes",
    "artist": "DJ Harmony",
    "featuredArtists": [],
    "trackNumber": 1,
    "isrc": "USABC1234567",
    "duration": 210,
    "bpm": 128,
    "key": "C Minor",
    "explicit": false,
    "lyrics": "Lyrics for Sunshine Groove...",
    "composers": ["DJ Harmony", "Alex Writer"],
    "producers": ["Alex Producer"],
    "audioUrl": "https://assets.tunemantra.com/previews/456.mp3",
    "metadata": {
      "mood": "energetic",
      "themes": ["summer", "beach", "party"],
      "instruments": ["synthesizer", "drums", "bass"],
      "recording": {
        "studio": "Harmony Studios",
        "date": "2024-12-15",
        "engineers": ["Sound Engineer"]
      }
    },
    "analytics": {
      "totalStreams": 250000,
      "topPlatforms": [
        {
          "name": "Spotify",
          "streams": 150000
        },
        {
          "name": "Apple Music",
          "streams": 75000
        },
        {
          "name": "Amazon Music",
          "streams": 25000
        }
      ],
      "topCountries": [
        {
          "country": "United States",
          "streams": 100000
        },
        {
          "country": "United Kingdom",
          "streams": 50000
        },
        {
          "country": "Germany",
          "streams": 30000
        }
      ]
    }
  }
}
```

##### Create a Track

```
POST /releases/{releaseId}/tracks
```

Adds a new track to a release.

**Path Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `releaseId` | number | Release ID  |

**Request Body:**

```json
{
  "title": "Icy Waves",
  "trackNumber": 1,
  "duration": 185,
  "explicit": false,
  "composers": ["Frost Beats", "Lyrical Ice"],
  "producers": ["Frost Beats"],
  "lyrics": "Lyrics for Icy Waves...",
  "metadata": {
    "mood": "relaxing",
    "themes": ["winter", "chill", "meditation"],
    "instruments": ["synthesizer", "piano", "ambient sounds"]
  }
}
```

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 458,
    "title": "Icy Waves",
    "releaseId": 125,
    "releaseName": "Winter Chillout",
    "artist": "Frost Beats",
    "featuredArtists": [],
    "trackNumber": 1,
    "duration": 185,
    "explicit": false,
    "composers": ["Frost Beats", "Lyrical Ice"],
    "producers": ["Frost Beats"],
    "lyrics": "Lyrics for Icy Waves...",
    "metadata": {
      "mood": "relaxing",
      "themes": ["winter", "chill", "meditation"],
      "instruments": ["synthesizer", "piano", "ambient sounds"]
    }
  }
}
```

#### Distribution

##### List Distribution Records

```
GET /distribution/records
```

Returns distribution records for your releases.

**Query Parameters:**

| Parameter    | Type   | Description |
|--------------|--------|-------------|
| `releaseId`  | number | Filter by release ID |
| `status`     | string | Filter by status (e.g., "pending", "distributed", "failed") |
| `platform`   | string | Filter by platform (e.g., "spotify", "apple") |
| `page`       | number | Page number for pagination |
| `limit`      | number | Results per page |
| `sort`       | string | Field to sort by (e.g., "createdAt", "status") |
| `order`      | string | Sort order ("asc" or "desc") |

**Response Example:**

```json
{
  "success": true,
  "data": [
    {
      "id": 789,
      "releaseId": 123,
      "releaseName": "Summer Vibes",
      "status": "distributed",
      "createdAt": "2025-05-01T12:00:00Z",
      "updatedAt": "2025-05-03T15:30:00Z",
      "platforms": [
        {
          "name": "Spotify",
          "status": "active",
          "url": "https://open.spotify.com/album/123456"
        },
        {
          "name": "Apple Music",
          "status": "active",
          "url": "https://music.apple.com/album/123456"
        }
      ]
    },
    {
      "id": 790,
      "releaseId": 124,
      "releaseName": "Midnight Dreams",
      "status": "pending",
      "createdAt": "2025-04-15T10:00:00Z",
      "updatedAt": "2025-04-15T10:00:00Z",
      "platforms": [
        {
          "name": "Spotify",
          "status": "pending",
          "url": null
        },
        {
          "name": "Apple Music",
          "status": "pending",
          "url": null
        }
      ]
    }
  ],
  "meta": {
    "total": 10,
    "page": 1,
    "limit": 25,
    "hasMore": false
  }
}
```

##### Get Distribution Record Details

```
GET /distribution/records/{recordId}
```

Returns detailed information about a specific distribution record.

**Path Parameters:**

| Parameter  | Type   | Description |
|------------|--------|-------------|
| `recordId` | number | Distribution record ID |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 789,
    "releaseId": 123,
    "releaseName": "Summer Vibes",
    "status": "distributed",
    "createdAt": "2025-05-01T12:00:00Z",
    "updatedAt": "2025-05-03T15:30:00Z",
    "distributions": [
      {
        "platform": "Spotify",
        "status": "active",
        "referenceId": "SP12345",
        "url": "https://open.spotify.com/album/123456",
        "submittedAt": "2025-05-01T12:00:00Z",
        "processedAt": "2025-05-02T09:45:00Z",
        "availableAt": "2025-05-03T00:00:00Z"
      },
      {
        "platform": "Apple Music",
        "status": "active",
        "referenceId": "AM67890",
        "url": "https://music.apple.com/album/123456",
        "submittedAt": "2025-05-01T12:00:00Z",
        "processedAt": "2025-05-02T14:30:00Z",
        "availableAt": "2025-05-03T00:00:00Z"
      },
      {
        "platform": "Amazon Music",
        "status": "active",
        "referenceId": "AZ24680",
        "url": "https://music.amazon.com/albums/123456",
        "submittedAt": "2025-05-01T12:00:00Z",
        "processedAt": "2025-05-02T11:15:00Z",
        "availableAt": "2025-05-03T00:00:00Z"
      },
      {
        "platform": "YouTube Music",
        "status": "processing",
        "referenceId": "YT13579",
        "url": null,
        "submittedAt": "2025-05-01T12:00:00Z",
        "processedAt": null,
        "availableAt": null
      }
    ],
    "history": [
      {
        "timestamp": "2025-05-01T12:00:00Z",
        "action": "created",
        "details": "Distribution submitted for 4 platforms"
      },
      {
        "timestamp": "2025-05-02T09:45:00Z",
        "action": "platform_update",
        "details": "Spotify status changed to 'processing'"
      },
      {
        "timestamp": "2025-05-02T11:15:00Z",
        "action": "platform_update",
        "details": "Amazon Music status changed to 'processing'"
      },
      {
        "timestamp": "2025-05-02T14:30:00Z",
        "action": "platform_update",
        "details": "Apple Music status changed to 'processing'"
      },
      {
        "timestamp": "2025-05-03T00:00:00Z",
        "action": "platform_update",
        "details": "Spotify status changed to 'active'"
      },
      {
        "timestamp": "2025-05-03T00:00:00Z",
        "action": "platform_update",
        "details": "Apple Music status changed to 'active'"
      },
      {
        "timestamp": "2025-05-03T00:00:00Z",
        "action": "platform_update",
        "details": "Amazon Music status changed to 'active'"
      }
    ]
  }
}
```

##### Distribute a Release

```
POST /distribution/distribute
```

Submits a release for distribution to specified platforms.

**Request Body:**

```json
{
  "releaseId": 125,
  "platforms": ["spotify", "apple_music", "amazon_music", "youtube_music"],
  "scheduledDate": "2025-12-01T00:00:00Z"
}
```

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 791,
    "releaseId": 125,
    "releaseName": "Winter Chillout",
    "status": "scheduled",
    "scheduledDate": "2025-12-01T00:00:00Z",
    "createdAt": "2025-06-15T14:30:00Z",
    "platforms": [
      {
        "name": "Spotify",
        "status": "scheduled"
      },
      {
        "name": "Apple Music",
        "status": "scheduled"
      },
      {
        "name": "Amazon Music",
        "status": "scheduled"
      },
      {
        "name": "YouTube Music",
        "status": "scheduled"
      }
    ]
  }
}
```

##### List Available Distribution Platforms

```
GET /distribution/platforms
```

Returns a list of available distribution platforms.

**Response Example:**

```json
{
  "success": true,
  "data": [
    {
      "id": "spotify",
      "name": "Spotify",
      "description": "World's largest music streaming platform.",
      "logoUrl": "https://assets.tunemantra.com/platforms/spotify.png"
    },
    {
      "id": "apple_music",
      "name": "Apple Music",
      "description": "Apple's music streaming service.",
      "logoUrl": "https://assets.tunemantra.com/platforms/apple_music.png"
    },
    {
      "id": "amazon_music",
      "name": "Amazon Music",
      "description": "Amazon's music streaming service.",
      "logoUrl": "https://assets.tunemantra.com/platforms/amazon_music.png"
    },
    {
      "id": "youtube_music",
      "name": "YouTube Music",
      "description": "Google's music streaming service.",
      "logoUrl": "https://assets.tunemantra.com/platforms/youtube_music.png"
    },
    {
      "id": "tidal",
      "name": "TIDAL",
      "description": "High-fidelity music streaming platform.",
      "logoUrl": "https://assets.tunemantra.com/platforms/tidal.png"
    }
  ]
}
```

#### Analytics

##### Get Analytics Overview

```
GET /analytics/overview
```

Returns an overview of analytics across your entire catalog.

**Query Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `startDate` | string | Start date for the analytics period (format: YYYY-MM-DD) |
| `endDate`   | string | End date for the analytics period (format: YYYY-MM-DD) |
| `compare`   | string | Compare with previous period ("true" or "false") |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "period": {
      "start": "2025-01-01",
      "end": "2025-03-31"
    },
    "overview": {
      "totalStreams": 1250000,
      "totalRevenue": 5000.75,
      "change": {
        "streams": {
          "value": 250000,
          "percentage": 25
        },
        "revenue": {
          "value": 1200.25,
          "percentage": 31.5
        }
      }
    },
    "platforms": [
      {
        "name": "Spotify",
        "streams": 750000,
        "revenue": 3000.50,
        "percentage": 60
      },
      {
        "name": "Apple Music",
        "streams": 300000,
        "revenue": 1500.25,
        "percentage": 24
      },
      {
        "name": "Amazon Music",
        "streams": 125000,
        "revenue": 375.00,
        "percentage": 10
      },
      {
        "name": "Others",
        "streams": 75000,
        "revenue": 125.00,
        "percentage": 6
      }
    ],
    "geography": [
      {
        "country": "United States",
        "streams": 500000,
        "revenue": 2500.50,
        "percentage": 40
      },
      {
        "country": "United Kingdom",
        "streams": 200000,
        "revenue": 1000.25,
        "percentage": 16
      },
      {
        "country": "Germany",
        "streams": 125000,
        "revenue": 625.00,
        "percentage": 10
      },
      {
        "country": "Others",
        "streams": 425000,
        "revenue": 875.00,
        "percentage": 34
      }
    ],
    "trend": {
      "streams": [
        {"date": "2025-01-01", "value": 10000},
        {"date": "2025-01-08", "value": 12500},
        {"date": "2025-01-15", "value": 15000},
        {"date": "2025-01-22", "value": 12000},
        {"date": "2025-01-29", "value": 13500},
        {"date": "2025-02-05", "value": 14000},
        {"date": "2025-02-12", "value": 16500},
        {"date": "2025-02-19", "value": 18000},
        {"date": "2025-02-26", "value": 20000},
        {"date": "2025-03-05", "value": 22500},
        {"date": "2025-03-12", "value": 21000},
        {"date": "2025-03-19", "value": 25000},
        {"date": "2025-03-26", "value": 27500}
      ],
      "revenue": [
        {"date": "2025-01-01", "value": 40.00},
        {"date": "2025-01-08", "value": 50.25},
        {"date": "2025-01-15", "value": 60.50},
        {"date": "2025-01-22", "value": 48.00},
        {"date": "2025-01-29", "value": 54.75},
        {"date": "2025-02-05", "value": 56.00},
        {"date": "2025-02-12", "value": 66.25},
        {"date": "2025-02-19", "value": 72.00},
        {"date": "2025-02-26", "value": 80.00},
        {"date": "2025-03-05", "value": 90.25},
        {"date": "2025-03-12", "value": 84.00},
        {"date": "2025-03-19", "value": 100.00},
        {"date": "2025-03-26", "value": 110.50}
      ]
    }
  }
}
```

##### Get Release Analytics

```
GET /analytics/releases/{releaseId}
```

Returns detailed analytics for a specific release.

**Path Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `releaseId` | number | Release ID  |

**Query Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `startDate` | string | Start date for the analytics period (format: YYYY-MM-DD) |
| `endDate`   | string | End date for the analytics period (format: YYYY-MM-DD) |
| `granularity` | string | Data granularity ("day", "week", "month") |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "release": {
      "id": 123,
      "title": "Summer Vibes",
      "artist": "DJ Harmony",
      "releaseDate": "2025-06-15"
    },
    "period": {
      "start": "2025-06-15",
      "end": "2025-09-15"
    },
    "overview": {
      "totalStreams": 500000,
      "totalRevenue": 2000.50,
      "avgStreamsPerDay": 5435
    },
    "platforms": [
      {
        "name": "Spotify",
        "streams": 300000,
        "revenue": 1200.30,
        "percentage": 60
      },
      {
        "name": "Apple Music",
        "streams": 125000,
        "revenue": 625.15,
        "percentage": 25
      },
      {
        "name": "Amazon Music",
        "streams": 50000,
        "revenue": 150.05,
        "percentage": 10
      },
      {
        "name": "Others",
        "streams": 25000,
        "revenue": 25.00,
        "percentage": 5
      }
    ],
    "geography": [
      {
        "country": "United States",
        "streams": 200000,
        "revenue": 1000.25,
        "percentage": 40
      },
      {
        "country": "United Kingdom",
        "streams": 75000,
        "revenue": 375.10,
        "percentage": 15
      },
      {
        "country": "Germany",
        "streams": 50000,
        "revenue": 250.05,
        "percentage": 10
      },
      {
        "country": "Others",
        "streams": 175000,
        "revenue": 375.10,
        "percentage": 35
      }
    ],
    "tracks": [
      {
        "id": 456,
        "title": "Sunshine Groove",
        "streams": 150000,
        "revenue": 600.15,
        "percentage": 30
      },
      {
        "id": 457,
        "title": "Beach Party",
        "streams": 125000,
        "revenue": 500.10,
        "percentage": 25
      }
    ],
    "trend": {
      "data": [
        {"date": "2025-06-15", "value": 5000},
        {"date": "2025-06-22", "value": 15000},
        {"date": "2025-06-29", "value": 25000},
        {"date": "2025-07-06", "value": 30000},
        {"date": "2025-07-13", "value": 45000},
        {"date": "2025-07-20", "value": 50000},
        {"date": "2025-07-27", "value": 60000},
        {"date": "2025-08-03", "value": 55000},
        {"date": "2025-08-10", "value": 50000},
        {"date": "2025-08-17", "value": 45000},
        {"date": "2025-08-24", "value": 40000},
        {"date": "2025-08-31", "value": 35000},
        {"date": "2025-09-07", "value": 25000},
        {"date": "2025-09-14", "value": 20000}
      ]
    }
  }
}
```

#### Royalties

##### Get Royalty Overview

```
GET /royalties/overview
```

Returns an overview of royalty data across your catalog.

**Query Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `startDate` | string | Start date for the royalty period (format: YYYY-MM-DD) |
| `endDate`   | string | End date for the royalty period (format: YYYY-MM-DD) |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "period": {
      "start": "2025-01-01",
      "end": "2025-03-31"
    },
    "overview": {
      "totalEarnings": 5000.75,
      "pendingBalance": 3500.50,
      "withdrawnAmount": 1500.25,
      "nextPaymentEstimate": 1000.00
    },
    "sources": [
      {
        "platform": "Spotify",
        "amount": 3000.50,
        "percentage": 60
      },
      {
        "platform": "Apple Music",
        "amount": 1500.25,
        "percentage": 30
      },
      {
        "platform": "Others",
        "amount": 500.00,
        "percentage": 10
      }
    ],
    "releases": [
      {
        "id": 123,
        "title": "Summer Vibes",
        "amount": 2500.35,
        "percentage": 50
      },
      {
        "id": 124,
        "title": "Midnight Dreams",
        "amount": 1500.20,
        "percentage": 30
      },
      {
        "id": 125,
        "title": "Winter Chillout",
        "amount": 1000.20,
        "percentage": 20
      }
    ],
    "trend": {
      "data": [
        {"date": "2025-01", "value": 1500.25},
        {"date": "2025-02", "value": 1750.30},
        {"date": "2025-03", "value": 1750.20}
      ]
    }
  }
}
```

##### List Royalty Splits

```
GET /royalties/splits
```

Returns a list of royalty splits for your catalog.

**Query Parameters:**

| Parameter    | Type   | Description |
|--------------|--------|-------------|
| `releaseId`  | number | Filter by release ID |
| `trackId`    | number | Filter by track ID |
| `page`       | number | Page number for pagination |
| `limit`      | number | Results per page |

**Response Example:**

```json
{
  "success": true,
  "data": [
    {
      "id": 201,
      "releaseId": 123,
      "releaseName": "Summer Vibes",
      "trackId": null,
      "effectiveDate": "2025-06-15",
      "recipients": [
        {
          "name": "DJ Harmony",
          "role": "Artist",
          "percentage": 70
        },
        {
          "name": "Harmony Records",
          "role": "Label",
          "percentage": 20
        },
        {
          "name": "Alex Producer",
          "role": "Producer",
          "percentage": 10
        }
      ]
    },
    {
      "id": 202,
      "releaseId": 123,
      "releaseName": "Summer Vibes",
      "trackId": 456,
      "trackName": "Sunshine Groove",
      "effectiveDate": "2025-06-15",
      "recipients": [
        {
          "name": "DJ Harmony",
          "role": "Artist",
          "percentage": 60
        },
        {
          "name": "Harmony Records",
          "role": "Label",
          "percentage": 20
        },
        {
          "name": "Alex Producer",
          "role": "Producer",
          "percentage": 10
        },
        {
          "name": "Alex Writer",
          "role": "Songwriter",
          "percentage": 10
        }
      ]
    }
  ],
  "meta": {
    "total": 5,
    "page": 1,
    "limit": 25,
    "hasMore": false
  }
}
```

##### Create Royalty Split

```
POST /royalties/splits
```

Creates a new royalty split configuration.

**Request Body:**

```json
{
  "releaseId": 125,
  "trackId": null,
  "effectiveDate": "2025-12-01",
  "recipients": [
    {
      "name": "Frost Beats",
      "role": "Artist",
      "percentage": 75
    },
    {
      "name": "Winter Records",
      "role": "Label",
      "percentage": 15
    },
    {
      "name": "Lyrical Ice",
      "role": "Songwriter",
      "percentage": 10
    }
  ]
}
```

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 203,
    "releaseId": 125,
    "releaseName": "Winter Chillout",
    "trackId": null,
    "effectiveDate": "2025-12-01",
    "recipients": [
      {
        "name": "Frost Beats",
        "role": "Artist",
        "percentage": 75
      },
      {
        "name": "Winter Records",
        "role": "Label",
        "percentage": 15
      },
      {
        "name": "Lyrical Ice",
        "role": "Songwriter",
        "percentage": 10
      }
    ]
  }
}
```

##### Get Royalty Statements

```
GET /royalties/statements
```

Returns a list of royalty statements.

**Query Parameters:**

| Parameter   | Type   | Description |
|-------------|--------|-------------|
| `startDate` | string | Filter by statement date start (format: YYYY-MM-DD) |
| `endDate`   | string | Filter by statement date end (format: YYYY-MM-DD) |
| `page`      | number | Page number for pagination |
| `limit`     | number | Results per page |

**Response Example:**

```json
{
  "success": true,
  "data": [
    {
      "id": 301,
      "period": "2025-Q1",
      "startDate": "2025-01-01",
      "endDate": "2025-03-31",
      "totalAmount": 5000.75,
      "status": "paid",
      "pdfUrl": "https://assets.tunemantra.com/statements/301.pdf",
      "paidDate": "2025-04-15"
    },
    {
      "id": 302,
      "period": "2025-Q2",
      "startDate": "2025-04-01",
      "endDate": "2025-06-30",
      "totalAmount": 6500.50,
      "status": "pending",
      "pdfUrl": "https://assets.tunemantra.com/statements/302.pdf",
      "paidDate": null
    }
  ],
  "meta": {
    "total": 2,
    "page": 1,
    "limit": 25,
    "hasMore": false
  }
}
```

##### Get Statement Details

```
GET /royalties/statements/{statementId}
```

Returns detailed information about a specific royalty statement.

**Path Parameters:**

| Parameter     | Type   | Description |
|---------------|--------|-------------|
| `statementId` | number | Statement ID |

**Response Example:**

```json
{
  "success": true,
  "data": {
    "id": 301,
    "period": "2025-Q1",
    "startDate": "2025-01-01",
    "endDate": "2025-03-31",
    "totalAmount": 5000.75,
    "status": "paid",
    "pdfUrl": "https://assets.tunemantra.com/statements/301.pdf",
    "paidDate": "2025-04-15",
    "lineItems": [
      {
        "releaseId": 123,
        "releaseName": "Summer Vibes",
        "platform": "Spotify",
        "streams": 300000,
        "amount": 1800.25
      },
      {
        "releaseId": 123,
        "releaseName": "Summer Vibes",
        "platform": "Apple Music",
        "streams": 125000,
        "amount": 937.50
      },
      {
        "releaseId": 124,
        "releaseName": "Midnight Dreams",
        "platform": "Spotify",
        "streams": 150000,
        "amount": 900.00
      },
      {
        "releaseId": 124,
        "releaseName": "Midnight Dreams",
        "platform": "Apple Music",
        "streams": 75000,
        "amount": 563.00
      },
      {
        "releaseId": 123,
        "releaseName": "Summer Vibes",
        "platform": "Amazon Music",
        "streams": 50000,
        "amount": 375.00
      },
      {
        "releaseId": 124,
        "releaseName": "Midnight Dreams",
        "platform": "Amazon Music",
        "streams": 25000,
        "amount": 187.50
      },
      {
        "releaseId": 123,
        "releaseName": "Summer Vibes",
        "platform": "YouTube Music",
        "streams": 25000,
        "amount": 137.50
      },
      {
        "releaseId": 124,
        "releaseName": "Midnight Dreams",
        "platform": "YouTube Music",
        "streams": 20000,
        "amount": 100.00
      }
    ]
  }
}
```

### Error Codes

| Code                   | Description |
|------------------------|-------------|
| `AUTHENTICATION_ERROR` | Authentication failed or invalid API key |
| `AUTHORIZATION_ERROR`  | Insufficient permissions for the requested action |
| `RESOURCE_NOT_FOUND`   | The requested resource does not exist |
| `VALIDATION_ERROR`     | Invalid request parameters or body |
| `RATE_LIMIT_EXCEEDED`  | API rate limit has been exceeded |
| `INTERNAL_SERVER_ERROR`| An unexpected error occurred on the server |
| `DISTRIBUTION_ERROR`   | An error occurred during the distribution process |
| `RESOURCE_CONFLICT`    | The request conflicts with the current state of the resource |

### SDKs and Libraries

TuneMantra provides official SDKs for common programming languages:

- [JavaScript/TypeScript](https://github.com/tunemantra/tunemantra-js)
- [Python](https://github.com/tunemantra/tunemantra-python)
- [PHP](https://github.com/tunemantra/tunemantra-php)
- [Ruby](https://github.com/tunemantra/tunemantra-ruby)

### Webhooks

TuneMantra can send webhook notifications for important events. Configure webhooks in your account settings.

#### Available Webhook Events

- `release.created` - A new release has been created
- `release.updated` - A release has been updated
- `release.deleted` - A release has been deleted
- `distribution.submitted` - A release has been submitted for distribution
- `distribution.status_change` - Distribution status has changed
- `platform.status_change` - Platform-specific status has changed
- `royalty.statement_generated` - A new royalty statement has been generated
- `royalty.payment_processed` - A royalty payment has been processed

#### Webhook Payload Example

```json
{
  "event": "distribution.status_change",
  "timestamp": "2025-05-03T15:30:00Z",
  "data": {
    "distributionId": 789,
    "releaseId": 123,
    "releaseName": "Summer Vibes",
    "previousStatus": "processing",
    "newStatus": "distributed",
    "platforms": [
      {
        "name": "Spotify",
        "status": "active"
      },
      {
        "name": "Apple Music",
        "status": "active"
      },
      {
        "name": "Amazon Music",
        "status": "active"
      }
    ]
  }
}
```

### Conclusion

This API reference provides a comprehensive overview of the TuneMantra API. For additional support, example code, or specific use cases, please visit the [Developer Portal](https://developers.tunemantra.com) or contact our support team.

**Last Updated**: March 18, 2025

*Source: /home/runner/workspace/.archive/archive_docs/documentation/unified/api-reference/17032025-api-reference.md*

---

## TuneMantra API Reference (3)

## TuneMantra API Reference

### Introduction

This document provides comprehensive documentation for the TuneMantra API. It covers all available endpoints, request/response formats, authentication methods, and usage examples.

### Base URL

All API endpoints are relative to the base URL:

```
https://your-tunemantra-instance.com/api
```

For local development:

```
http://localhost:5000/api
```

### Authentication

#### Authentication Methods

The TuneMantra API supports the following authentication methods:

1. **JWT Authentication**
   - Used for user sessions
   - Token included in `Authorization` header
   - Format: `Bearer <token>`

2. **API Key Authentication**
   - Used for programmatic access
   - Key included in `X-API-Key` header

#### Getting an Authentication Token

1. **User Login**

```http
POST /auth/login
Content-Type: application/json

{
  "username": "user@example.com",
  "password": "password123"
}
```

Response:

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "user@example.com",
    "role": "artist"
    // other user fields
  }
}
```

2. **API Key Generation**

```http
POST /api-keys
Content-Type: application/json
Authorization: Bearer <jwt-token>

{
  "name": "My API Key",
  "scopes": ["read:releases", "write:releases"]
}
```

Response:

```json
{
  "id": 1,
  "name": "My API Key",
  "key": "tm_apk_1234567890abcdef",
  "scopes": ["read:releases", "write:releases"],
  "createdAt": "2025-03-19T12:00:00Z"
}
```

### Error Handling

All API errors follow a consistent format:

```json
{
  "message": "Human-readable error message",
  "code": "ERROR_CODE",
  "details": { /* Optional additional error details */ }
}
```

Common error status codes:

- `400`: Bad Request - Invalid input
- `401`: Unauthorized - Authentication required
- `403`: Forbidden - Insufficient permissions
- `404`: Not Found - Resource doesn't exist
- `422`: Unprocessable Entity - Validation error
- `429`: Too Many Requests - Rate limit exceeded
- `500`: Internal Server Error - Server failure

### API Endpoints

#### User Management

##### Get Current User

```http
GET /user
Authorization: Bearer <token>
```

Response:

```json
{
  "id": 1,
  "username": "user@example.com",
  "fullName": "John Doe",
  "email": "user@example.com",
  "phoneNumber": "+1234567890",
  "entityName": "Artist Name",
  "avatarUrl": "/uploads/avatars/profile.jpg",
  "role": "artist",
  "status": "active",
  "createdAt": "2025-03-19T12:00:00Z",
  "permissions": {
    "canCreateReleases": true,
    "canManageArtists": true,
    "canViewAnalytics": true
    // additional permissions
  }
}
```

##### Update User Profile

```http
PATCH /user/profile
Authorization: Bearer <token>
Content-Type: application/json

{
  "fullName": "John Doe Updated",
  "phoneNumber": "+1987654321",
  "entityName": "New Artist Name"
}
```

Response:

```json
{
  "id": 1,
  "username": "user@example.com",
  "fullName": "John Doe Updated",
  "phoneNumber": "+1987654321",
  "entityName": "New Artist Name",
  // other user fields
}
```

##### Upload Avatar

```http
POST /user/avatar
Authorization: Bearer <token>
Content-Type: multipart/form-data

avatar: [file upload]
```

Response:

```json
{
  "avatarUrl": "/uploads/avatars/profile-123456.jpg"
}
```

#### Release Management

##### Get Releases

```http
GET /releases
Authorization: Bearer <token>
```

Response:

```json
[
  {
    "id": 1,
    "title": "Album Title",
    "type": "album",
    "artistName": "Artist Name",
    "releaseDate": "2025-04-01",
    "coverArtUrl": "/uploads/covers/album.jpg",
    "status": "completed",
    "tracks": [
      // track information
    ],
    "metadata": {
      // additional metadata
    },
    "createdAt": "2025-03-19T12:00:00Z",
    "updatedAt": "2025-03-19T12:30:00Z"
  }
  // additional releases
]
```

Query Parameters:
- `status`: Filter by status (e.g., "draft", "completed", "distributed")
- `type`: Filter by release type (e.g., "album", "single", "ep")
- `page`: Page number for pagination
- `limit`: Items per page

##### Get Release by ID

```http
GET /releases/:id
Authorization: Bearer <token>
```

Response:

```json
{
  "id": 1,
  "title": "Album Title",
  "type": "album",
  "artistName": "Artist Name",
  "releaseDate": "2025-04-01",
  "coverArtUrl": "/uploads/covers/album.jpg",
  "status": "completed",
  "tracks": [
    {
      "id": 1,
      "title": "Track 1",
      "duration": 180,
      "isrc": "ABC123456789",
      "position": 1,
      "audioUrl": "/uploads/audio/track1.mp3"
      // additional track information
    }
    // additional tracks
  ],
  "metadata": {
    "genres": ["Pop", "Rock"],
    "moods": ["Energetic", "Upbeat"],
    "language": "english",
    "explicit": false,
    "copyright": "© 2025 Artist Name",
    "upc": "1234567890123"
    // additional metadata
  },
  "createdAt": "2025-03-19T12:00:00Z",
  "updatedAt": "2025-03-19T12:30:00Z"
}
```

##### Create Release

```http
POST /releases
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "New Album",
  "type": "album",
  "artistName": "Artist Name",
  "releaseDate": "2025-04-01",
  "metadata": {
    "genres": ["Pop", "Electronic"],
    "language": "english",
    "explicit": false,
    "copyright": "© 2025 Artist Name"
  }
}
```

Response:

```json
{
  "id": 2,
  "title": "New Album",
  "type": "album",
  "artistName": "Artist Name",
  "releaseDate": "2025-04-01",
  "status": "draft",
  "metadata": {
    "genres": ["Pop", "Electronic"],
    "language": "english",
    "explicit": false,
    "copyright": "© 2025 Artist Name"
  },
  "createdAt": "2025-03-19T13:00:00Z",
  "updatedAt": "2025-03-19T13:00:00Z"
}
```

##### Update Release

```http
PATCH /releases/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Updated Album Title",
  "metadata": {
    "genres": ["Pop", "Electronic", "Dance"],
    "moods": ["Energetic", "Upbeat"]
  }
}
```

Response:

```json
{
  "id": 2,
  "title": "Updated Album Title",
  "type": "album",
  "artistName": "Artist Name",
  "releaseDate": "2025-04-01",
  "status": "draft",
  "metadata": {
    "genres": ["Pop", "Electronic", "Dance"],
    "moods": ["Energetic", "Upbeat"],
    "language": "english",
    "explicit": false,
    "copyright": "© 2025 Artist Name"
  },
  "createdAt": "2025-03-19T13:00:00Z",
  "updatedAt": "2025-03-19T13:15:00Z"
}
```

##### Delete Release

```http
DELETE /releases/:id
Authorization: Bearer <token>
```

Response:

```
204 No Content
```

#### Track Management

##### Get Tracks for Release

```http
GET /releases/:releaseId/tracks
Authorization: Bearer <token>
```

Response:

```json
[
  {
    "id": 1,
    "title": "Track 1",
    "duration": 180,
    "isrc": "ABC123456789",
    "position": 1,
    "audioUrl": "/uploads/audio/track1.mp3",
    "releaseId": 1,
    "createdAt": "2025-03-19T12:00:00Z",
    "updatedAt": "2025-03-19T12:00:00Z"
  }
  // additional tracks
]
```

##### Get Track by ID

```http
GET /tracks/:id
Authorization: Bearer <token>
```

Response:

```json
{
  "id": 1,
  "title": "Track 1",
  "duration": 180,
  "isrc": "ABC123456789",
  "position": 1,
  "audioUrl": "/uploads/audio/track1.mp3",
  "releaseId": 1,
  "metadata": {
    "composers": ["Composer Name"],
    "lyricists": ["Lyricist Name"],
    "producers": ["Producer Name"],
    "explicit": false,
    "bpm": 120,
    "key": "C Major"
    // additional metadata
  },
  "createdAt": "2025-03-19T12:00:00Z",
  "updatedAt": "2025-03-19T12:00:00Z"
}
```

##### Create Track

```http
POST /tracks
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "New Track",
  "duration": 210,
  "position": 1,
  "releaseId": 2,
  "metadata": {
    "composers": ["Composer Name"],
    "lyricists": ["Lyricist Name"],
    "producers": ["Producer Name"],
    "explicit": false
  }
}
```

Response:

```json
{
  "id": 2,
  "title": "New Track",
  "duration": 210,
  "position": 1,
  "releaseId": 2,
  "metadata": {
    "composers": ["Composer Name"],
    "lyricists": ["Lyricist Name"],
    "producers": ["Producer Name"],
    "explicit": false
  },
  "createdAt": "2025-03-19T13:30:00Z",
  "updatedAt": "2025-03-19T13:30:00Z"
}
```

##### Update Track

```http
PATCH /tracks/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Updated Track Title",
  "metadata": {
    "bpm": 124,
    "key": "D Minor"
  }
}
```

Response:

```json
{
  "id": 2,
  "title": "Updated Track Title",
  "duration": 210,
  "position": 1,
  "releaseId": 2,
  "metadata": {
    "composers": ["Composer Name"],
    "lyricists": ["Lyricist Name"],
    "producers": ["Producer Name"],
    "explicit": false,
    "bpm": 124,
    "key": "D Minor"
  },
  "createdAt": "2025-03-19T13:30:00Z",
  "updatedAt": "2025-03-19T13:45:00Z"
}
```

##### Upload Track Audio

```http
POST /tracks/:id/audio
Authorization: Bearer <token>
Content-Type: multipart/form-data

audio: [file upload]
```

Response:

```json
{
  "id": 2,
  "audioUrl": "/uploads/audio/track2-123456.mp3",
  "updatedAt": "2025-03-19T14:00:00Z"
}
```

##### Delete Track

```http
DELETE /tracks/:id
Authorization: Bearer <token>
```

Response:

```
204 No Content
```

#### Distribution Management

##### Get Distribution Platforms

```http
GET /distribution-platforms
Authorization: Bearer <token>
```

Response:

```json
[
  {
    "id": 1,
    "name": "Spotify",
    "logoUrl": "/platform-logos/spotify.png",
    "deliveryMethod": "api",
    "supportedFormats": ["mp3", "wav"],
    "active": true
  },
  {
    "id": 2,
    "name": "Apple Music",
    "logoUrl": "/platform-logos/apple-music.png",
    "deliveryMethod": "api",
    "supportedFormats": ["mp3", "wav", "aac"],
    "active": true
  }
  // additional platforms
]
```

##### Distribute Release to Platform

```http
POST /releases/:releaseId/distribute
Authorization: Bearer <token>
Content-Type: application/json

{
  "platformId": 1
}
```

Response:

```json
{
  "id": 1,
  "releaseId": 1,
  "platformId": 1,
  "status": "pending",
  "distributedAt": "2025-03-19T14:30:00Z",
  "platformReleaseId": null,
  "platformUrl": null,
  "createdAt": "2025-03-19T14:30:00Z",
  "updatedAt": "2025-03-19T14:30:00Z"
}
```

##### Schedule Release Distribution

```http
POST /scheduled-distributions
Authorization: Bearer <token>
Content-Type: application/json

{
  "releaseId": 2,
  "platformId": 1,
  "scheduledDate": "2025-04-01T00:00:00Z"
}
```

Response:

```json
{
  "id": 1,
  "releaseId": 2,
  "platformId": 1,
  "scheduledDate": "2025-04-01T00:00:00Z",
  "status": "scheduled",
  "createdAt": "2025-03-19T14:45:00Z",
  "updatedAt": "2025-03-19T14:45:00Z"
}
```

##### Get Distribution Status

```http
GET /releases/:releaseId/distribution
Authorization: Bearer <token>
```

Response:

```json
[
  {
    "id": 1,
    "releaseId": 1,
    "platformId": 1,
    "platformName": "Spotify",
    "status": "completed",
    "distributedAt": "2025-03-19T14:30:00Z",
    "completedAt": "2025-03-19T15:00:00Z",
    "platformReleaseId": "spotify_123456",
    "platformUrl": "https://open.spotify.com/album/123456",
    "errorMessage": null,
    "createdAt": "2025-03-19T14:30:00Z",
    "updatedAt": "2025-03-19T15:00:00Z"
  }
  // additional distribution records
]
```

#### Analytics

##### Get Release Analytics

```http
GET /analytics/releases/:releaseId
Authorization: Bearer <token>
```

Query Parameters:
- `startDate`: Start date for analytics (ISO format)
- `endDate`: End date for analytics (ISO format)
- `platforms`: Comma-separated list of platform IDs

Response:

```json
{
  "summary": {
    "totalStreams": 15000,
    "totalRevenue": 150.75,
    "topPlatforms": [
      {
        "platform": "Spotify",
        "streams": 10000,
        "revenue": 100.50
      },
      {
        "platform": "Apple Music",
        "streams": 5000,
        "revenue": 50.25
      }
    ],
    "topTracks": [
      {
        "trackId": 1,
        "title": "Track 1",
        "streams": 8000,
        "revenue": 80.40
      },
      {
        "trackId": 2,
        "title": "Track 2",
        "streams": 7000,
        "revenue": 70.35
      }
    ]
  },
  "daily": [
    {
      "date": "2025-03-01",
      "streams": 500,
      "revenue": 5.02
    }
    // daily data for the requested period
  ],
  "platforms": [
    {
      "platform": "Spotify",
      "daily": [
        {
          "date": "2025-03-01",
          "streams": 350,
          "revenue": 3.52
        }
        // daily data for Spotify
      ]
    },
    {
      "platform": "Apple Music",
      "daily": [
        {
          "date": "2025-03-01",
          "streams": 150,
          "revenue": 1.50
        }
        // daily data for Apple Music
      ]
    }
  ]
}
```

##### Get Track Analytics

```http
GET /analytics/tracks/:trackId
Authorization: Bearer <token>
```

Query Parameters:
- `startDate`: Start date for analytics (ISO format)
- `endDate`: End date for analytics (ISO format)
- `platforms`: Comma-separated list of platform IDs

Response:

```json
{
  "summary": {
    "totalStreams": 8000,
    "totalRevenue": 80.40,
    "platformBreakdown": [
      {
        "platform": "Spotify",
        "streams": 6000,
        "revenue": 60.30
      },
      {
        "platform": "Apple Music",
        "streams": 2000,
        "revenue": 20.10
      }
    ],
    "geographicBreakdown": [
      {
        "country": "United States",
        "streams": 4000,
        "revenue": 40.20
      },
      {
        "country": "United Kingdom",
        "streams": 2000,
        "revenue": 20.10
      }
      // additional countries
    ]
  },
  "daily": [
    {
      "date": "2025-03-01",
      "streams": 300,
      "revenue": 3.01
    }
    // daily data for the requested period
  ]
}
```

#### Royalty Management

##### Get Royalty Splits

```http
GET /royalty-splits/release/:releaseId
Authorization: Bearer <token>
```

Response:

```json
[
  {
    "id": 1,
    "releaseId": 1,
    "trackId": null,
    "recipientName": "John Doe",
    "recipientRole": "Primary Artist",
    "percentage": 70,
    "paymentMethod": {
      "id": 1,
      "type": "bank_account",
      "accountHolder": "John Doe",
      "accountIdentifier": "XXXX-XXXX-XXXX-1234"
    },
    "createdAt": "2025-03-19T16:00:00Z",
    "updatedAt": "2025-03-19T16:00:00Z"
  },
  {
    "id": 2,
    "releaseId": 1,
    "trackId": null,
    "recipientName": "Jane Smith",
    "recipientRole": "Producer",
    "percentage": 30,
    "paymentMethod": {
      "id": 2,
      "type": "paypal",
      "accountHolder": "Jane Smith",
      "accountIdentifier": "jane.smith@example.com"
    },
    "createdAt": "2025-03-19T16:00:00Z",
    "updatedAt": "2025-03-19T16:00:00Z"
  }
]
```

##### Create Royalty Split

```http
POST /royalty-splits
Authorization: Bearer <token>
Content-Type: application/json

{
  "releaseId": 1,
  "trackId": null,
  "recipientName": "Producer Name",
  "recipientRole": "Producer",
  "percentage": 15,
  "paymentMethodId": 3
}
```

Response:

```json
{
  "id": 3,
  "releaseId": 1,
  "trackId": null,
  "recipientName": "Producer Name",
  "recipientRole": "Producer",
  "percentage": 15,
  "paymentMethod": {
    "id": 3,
    "type": "bank_account",
    "accountHolder": "Producer Name",
    "accountIdentifier": "XXXX-XXXX-XXXX-5678"
  },
  "createdAt": "2025-03-19T16:30:00Z",
  "updatedAt": "2025-03-19T16:30:00Z"
}
```

#### Support Tickets

##### Get All Tickets

```http
GET /support/tickets
Authorization: Bearer <token>
```

Response:

```json
[
  {
    "id": 1,
    "subject": "Distribution Issue",
    "message": "Having trouble with my distribution to Spotify",
    "status": "open",
    "priority": "medium",
    "category": "distribution",
    "updatedAt": "2025-03-19T17:00:00Z",
    "createdAt": "2025-03-19T17:00:00Z"
  }
  // additional tickets
]
```

##### Get Ticket Details

```http
GET /support/tickets/:id
Authorization: Bearer <token>
```

Response:

```json
{
  "ticket": {
    "id": 1,
    "subject": "Distribution Issue",
    "message": "Having trouble with my distribution to Spotify",
    "status": "open",
    "priority": "medium",
    "category": "distribution",
    "updatedAt": "2025-03-19T17:00:00Z",
    "createdAt": "2025-03-19T17:00:00Z"
  },
  "messages": [
    {
      "id": 1,
      "content": "Having trouble with my distribution to Spotify",
      "senderType": "user",
      "senderId": 1,
      "createdAt": "2025-03-19T17:00:00Z"
    }
    // additional messages
  ]
}
```

##### Create Support Ticket

```http
POST /support/tickets
Authorization: Bearer <token>
Content-Type: application/json

{
  "subject": "Payment Question",
  "message": "How do I update my payment details?",
  "priority": "low",
  "category": "billing"
}
```

Response:

```json
{
  "id": 2,
  "subject": "Payment Question",
  "message": "How do I update my payment details?",
  "status": "open",
  "priority": "low",
  "category": "billing",
  "updatedAt": "2025-03-19T17:15:00Z",
  "createdAt": "2025-03-19T17:15:00Z"
}
```

##### Add Ticket Message

```http
POST /support/tickets/:id/messages
Authorization: Bearer <token>
Content-Type: application/json

{
  "content": "Any update on this issue?"
}
```

Response:

```json
{
  "id": 2,
  "content": "Any update on this issue?",
  "senderType": "user",
  "senderId": 1,
  "createdAt": "2025-03-19T17:30:00Z"
}
```

### Webhooks

TuneMantra supports webhooks for real-time notifications of events.

#### Available Events

- `release.created`: When a new release is created
- `release.updated`: When a release is updated
- `release.distributed`: When a release is distributed to a platform
- `track.created`: When a new track is created
- `track.updated`: When a track is updated
- `analytics.updated`: When analytics data is updated

#### Webhook Payload Format

```json
{
  "event": "release.distributed",
  "timestamp": "2025-03-19T18:00:00Z",
  "data": {
    "releaseId": 1,
    "platformId": 1,
    "platformName": "Spotify",
    "status": "completed",
    "platformUrl": "https://open.spotify.com/album/123456"
  }
}
```

#### Setting Up Webhooks

Webhooks can be configured in the application settings or via the API:

```http
POST /webhooks
Authorization: Bearer <token>
Content-Type: application/json

{
  "url": "https://your-webhook-endpoint.com/webhook",
  "events": ["release.distributed", "analytics.updated"],
  "secret": "your_webhook_secret"
}
```

Response:

```json
{
  "id": 1,
  "url": "https://your-webhook-endpoint.com/webhook",
  "events": ["release.distributed", "analytics.updated"],
  "active": true,
  "createdAt": "2025-03-19T18:15:00Z"
}
```

### Rate Limiting

The API implements rate limiting to ensure fair usage:

- **Standard Users**: 100 requests per minute
- **Premium Users**: 300 requests per minute
- **API Clients**: 1000 requests per minute

Rate limit headers are included in API responses:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1616176800
```

### API Versioning

API versioning is managed through the URL path:

```
https://your-tunemantra-instance.com/api/v1/...
```

Current API versions:
- `v1`: Current stable version

### SDKs and Client Libraries

Official SDKs and client libraries for the TuneMantra API:

- [JavaScript/TypeScript SDK](https://github.com/tunemantra/tunemantra-js)
- [Python SDK](https://github.com/tunemantra/tunemantra-python)
- [PHP SDK](https://github.com/tunemantra/tunemantra-php)

### Appendix

#### Status Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | Request succeeded |
| 201 | Created | Resource created |
| 204 | No Content | Request succeeded with no content to return |
| 400 | Bad Request | Invalid request |
| 401 | Unauthorized | Authentication required |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource not found |
| 422 | Unprocessable Entity | Validation error |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Server error |

---

*© 2025 TuneMantra. All rights reserved.*

*Source: /home/runner/workspace/.archive/archive_docs/documentation/unified/api-reference/main-api-reference-legacy.md*

---

## TuneMantra API Reference (4)

## TuneMantra API Reference

**Last Updated:** March 22, 2025

### Overview

The TuneMantra API provides programmatic access to the platform's functionality, allowing developers to integrate music distribution and royalty management capabilities into custom applications and workflows.

### Authentication

All API requests require authentication using JSON Web Tokens (JWT).

#### Getting a Token

```
POST /api/auth/login
```

Request body:
```json
{
  "username": "your-username",
  "password": "your-password"
}
```

Response:
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "your-username",
    "email": "your-email@example.com",
    "role": "label"
  }
}
```

#### Using the Token

Include the token in the Authorization header of each request:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### API Endpoints

#### User Management

##### Get Current User

```
GET /api/users/me
```

Response:
```json
{
  "id": 1,
  "username": "your-username",
  "email": "your-email@example.com",
  "role": "label",
  "createdAt": "2025-01-15T12:00:00.000Z",
  "updatedAt": "2025-03-01T14:30:00.000Z"
}
```

##### Update User Profile

```
PATCH /api/users/me
```

Request body:
```json
{
  "email": "new-email@example.com",
  "displayName": "New Display Name",
  "bio": "Updated artist biography"
}
```

#### Catalog Management

##### Get Releases

```
GET /api/releases
```

Query parameters:
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20)
- `status`: Filter by status (draft, pending, published)

Response:
```json
{
  "total": 45,
  "page": 1,
  "limit": 20,
  "data": [
    {
      "id": 123,
      "title": "Album Title",
      "artist": "Artist Name",
      "type": "album",
      "status": "published",
      "releaseDate": "2025-04-01T00:00:00.000Z",
      "createdAt": "2025-03-01T12:00:00.000Z",
      "updatedAt": "2025-03-10T15:30:00.000Z"
    },
    // More releases...
  ]
}
```

##### Get Release by ID

```
GET /api/releases/:id
```

Response:
```json
{
  "id": 123,
  "title": "Album Title",
  "artist": "Artist Name",
  "type": "album",
  "status": "published",
  "releaseDate": "2025-04-01T00:00:00.000Z",
  "artwork": "https://example.com/artwork.jpg",
  "genres": ["Pop", "Electronic"],
  "tracks": [
    {
      "id": 456,
      "title": "Track Title",
      "duration": 180,
      "isrc": "USXXX1234567",
      "position": 1
    },
    // More tracks...
  ],
  "createdAt": "2025-03-01T12:00:00.000Z",
  "updatedAt": "2025-03-10T15:30:00.000Z"
}
```

##### Create Release

```
POST /api/releases
```

Request body:
```json
{
  "title": "New Album",
  "type": "album",
  "artist": "Artist Name",
  "releaseDate": "2025-05-15T00:00:00.000Z",
  "genres": ["Rock", "Alternative"],
  "tracks": [
    {
      "title": "Track 1",
      "duration": 180,
      "isrc": "USXXX1234567",
      "position": 1
    }
  ]
}
```

##### Update Release

```
PATCH /api/releases/:id
```

Request body:
```json
{
  "title": "Updated Album Title",
  "genres": ["Rock", "Indie"]
}
```

##### Delete Release

```
DELETE /api/releases/:id
```

#### Distribution Management

##### Get Distribution Records

```
GET /api/distribution
```

Query parameters:
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20)
- `status`: Filter by status

Response:
```json
{
  "total": 30,
  "page": 1,
  "limit": 20,
  "data": [
    {
      "id": 789,
      "releaseId": 123,
      "platformId": 1,
      "status": "distributed",
      "distributionDate": "2025-03-15T09:30:00.000Z",
      "platformReleaseId": "platform-specific-id",
      "createdAt": "2025-03-01T12:00:00.000Z",
      "updatedAt": "2025-03-15T09:30:00.000Z"
    },
    // More distribution records...
  ]
}
```

##### Create Distribution

```
POST /api/distribution
```

Request body:
```json
{
  "releaseId": 123,
  "platforms": [1, 2, 3],
  "scheduledDate": "2025-04-01T00:00:00.000Z"
}
```

##### Update Distribution Status

```
PATCH /api/distribution/:id/status
```

Request body:
```json
{
  "status": "canceled",
  "reason": "Metadata issues"
}
```

#### Royalty Management

##### Get Royalty Calculations

```
GET /api/royalties
```

Query parameters:
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20)
- `timeframe`: Time period (day, week, month, quarter, year, or custom date range)
- `releaseId`: Filter by release ID
- `trackId`: Filter by track ID

Response:
```json
{
  "total": 150,
  "page": 1,
  "limit": 20,
  "data": [
    {
      "id": 1001,
      "trackId": 456,
      "platform": "spotify",
      "streams": 15000,
      "revenue": 60.00,
      "currency": "USD",
      "period": "2025-03",
      "createdAt": "2025-04-02T12:00:00.000Z"
    },
    // More royalty records...
  ]
}
```

##### Process Batch Royalty Calculations

```
POST /api/royalties/process
```

Request body:
```json
{
  "releaseId": 123,
  "timeframe": {
    "startDate": "2025-03-01",
    "endDate": "2025-03-31"
  },
  "forceRecalculation": false
}
```

#### Analytics

##### Get Performance Analytics

```
GET /api/analytics/performance
```

Query parameters:
- `timeframe`: Time period (day, week, month, quarter, year, or custom date range)
- `releaseId`: Filter by release ID
- `trackId`: Filter by track ID

Response:
```json
{
  "streams": {
    "total": 250000,
    "byPlatform": {
      "spotify": 120000,
      "apple": 85000,
      "amazon": 45000
    },
    "trend": [
      {"date": "2025-03-01", "count": 8500},
      {"date": "2025-03-02", "count": 8200},
      // More data points...
    ]
  },
  "revenue": {
    "total": 1250.00,
    "currency": "USD",
    "byPlatform": {
      "spotify": 600.00,
      "apple": 425.00,
      "amazon": 225.00
    }
  },
  "audience": {
    "topCountries": [
      {"country": "US", "percentage": 45.2},
      {"country": "UK", "percentage": 15.8},
      {"country": "DE", "percentage": 8.6},
      // More countries...
    ],
    "demographics": {
      "age": {
        "18-24": 32.5,
        "25-34": 41.2,
        "35-44": 15.8,
        "45+": 10.5
      },
      "gender": {
        "male": 58.3,
        "female": 40.2,
        "other": 1.5
      }
    }
  }
}
```

### Error Handling

The API uses standard HTTP status codes to indicate the success or failure of requests.

Common status codes:
- `200 OK`: Request succeeded
- `201 Created`: Resource was successfully created
- `400 Bad Request`: Invalid request parameters
- `401 Unauthorized`: Missing or invalid authentication
- `403 Forbidden`: Authenticated user lacks permission
- `404 Not Found`: Resource not found
- `409 Conflict`: Request conflicts with current state
- `422 Unprocessable Entity`: Validation errors
- `500 Internal Server Error`: Server-side error

Error response format:
```json
{
  "error": true,
  "code": "VALIDATION_ERROR",
  "message": "Invalid request parameters",
  "details": [
    {
      "field": "title",
      "message": "Title is required"
    }
  ]
}
```

### Rate Limiting

API requests are rate-limited to prevent abuse. The current limits are:

- 60 requests per minute for authenticated users
- 20 requests per minute for unauthenticated users

Rate limit information is included in the response headers:
- `X-RateLimit-Limit`: Maximum requests per window
- `X-RateLimit-Remaining`: Remaining requests in current window
- `X-RateLimit-Reset`: Time (in seconds) until the rate limit resets

### Versioning

The API uses URL versioning. The current version is v1, accessible at:
```
/api/v1/resource
```

### Support

For API support, contact the developer support team or refer to the detailed [API Documentation](https://docs.tunemantra.com/api).

*Source: /home/runner/workspace/.archive/archive_docs/documentation/unified/api-reference/main-api-reference.md*

---

## TuneMantra API Reference (5)

## TuneMantra API Reference

### Introduction

This API reference provides comprehensive documentation for the TuneMantra API, enabling developers to integrate with and extend the platform's capabilities. The TuneMantra API follows RESTful principles and uses standard HTTP methods for resource manipulation.

### API Overview

#### Base URL

All API requests should be made to the following base URL:

```
https://api.tunemantra.com/api
```

For development environments:

```
http://localhost:5000/api
```

#### Authentication

TuneMantra API uses JWT (JSON Web Token) authentication. To authenticate requests, include the JWT token in the Authorization header:

```
Authorization: Bearer <jwt_token>
```

##### Obtaining Authentication Tokens

To obtain a JWT token, make a POST request to the `/auth/login` endpoint with valid credentials.

#### Response Format

All API responses are returned in JSON format with the following structure:

**Success Response:**

```json
{
  "data": { ... },  // Response data
  "meta": { ... }   // Metadata (pagination, etc.)
}
```

**Error Response:**

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": { ... }  // Optional additional error details
  }
}
```

#### HTTP Status Codes

The API uses standard HTTP status codes to indicate the success or failure of requests:

| Status Code | Description |
|-------------|-------------|
| 200 | OK - The request was successful |
| 201 | Created - A new resource was successfully created |
| 400 | Bad Request - The request was invalid or cannot be served |
| 401 | Unauthorized - Authentication is required or failed |
| 403 | Forbidden - The authenticated user doesn't have permission |
| 404 | Not Found - The requested resource doesn't exist |
| 409 | Conflict - The request conflicts with the current state |
| 422 | Unprocessable Entity - Validation errors |
| 429 | Too Many Requests - Rate limit exceeded |
| 500 | Internal Server Error - Server encountered an error |

#### Pagination

For endpoints that return collections of resources, the API supports pagination using the following query parameters:

- `page`: Page number (starting from 1)
- `limit`: Number of items per page

Example:

```
GET /api/tracks?page=2&limit=10
```

Response includes pagination metadata:

```json
{
  "data": [ ... ],
  "meta": {
    "pagination": {
      "total": 135,
      "page": 2,
      "limit": 10,
      "totalPages": 14
    }
  }
}
```

#### Filtering and Sorting

Many endpoints support filtering and sorting using query parameters:

- Filtering: `field=value` or `field[operator]=value`
- Sorting: `sort=field` (ascending) or `sort=-field` (descending)

Example:

```
GET /api/releases?type=album&sort=-releaseDate
```

#### Rate Limiting

The API implements rate limiting to ensure fair usage. Rate limit information is included in the response headers:

- `X-RateLimit-Limit`: Maximum number of requests allowed in a time window
- `X-RateLimit-Remaining`: Number of requests remaining in the current window
- `X-RateLimit-Reset`: Time (in seconds) until the rate limit resets

When a rate limit is exceeded, the API returns a 429 Too Many Requests response.

### API Endpoints

#### Authentication

##### Login

Authenticates a user and returns a JWT token.

```
POST /auth/login
```

**Request Body:**

```json
{
  "username": "user@example.com",
  "password": "password123"
}
```

**Response:**

```json
{
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "username": "user@example.com",
      "fullName": "John Doe",
      "role": "artist"
    }
  }
}
```

##### Current User

Returns information about the currently authenticated user.

```
GET /auth/user
```

**Response:**

```json
{
  "data": {
    "id": 1,
    "username": "user@example.com",
    "email": "user@example.com",
    "fullName": "John Doe",
    "phoneNumber": "+1234567890",
    "entityName": "John Doe Music",
    "avatarUrl": "https://example.com/avatar.jpg",
    "role": "artist",
    "permissions": {
      "canCreateReleases": true,
      "canManageArtists": false,
      "canViewAnalytics": true,
      "canManageDistribution": true,
      "canManageRoyalties": true,
      "canEditMetadata": true,
      "canAccessFinancials": true,
      "canInviteUsers": false
    },
    "status": "active",
    "createdAt": "2023-01-15T12:00:00Z"
  }
}
```

##### Register

Registers a new user account.

```
POST /auth/register
```

**Request Body:**

```json
{
  "username": "newuser@example.com",
  "email": "newuser@example.com",
  "password": "securepassword123",
  "fullName": "New User",
  "phoneNumber": "+1234567890",
  "entityName": "New User Music",
  "plan": "artist"
}
```

**Response:**

```json
{
  "data": {
    "id": 123,
    "username": "newuser@example.com",
    "email": "newuser@example.com",
    "fullName": "New User",
    "role": "artist",
    "status": "pending_approval",
    "createdAt": "2025-03-19T14:30:00Z"
  }
}
```

##### Logout

Invalidates the current user's session.

```
POST /auth/logout
```

**Response:**

```json
{
  "data": {
    "message": "Successfully logged out"
  }
}
```

#### User Management

##### Get All Users

Retrieves a list of users (admin access required).

```
GET /users
```

**Query Parameters:**

- `status`: Filter by user status
- `role`: Filter by user role
- `search`: Search by name, email, or username
- `page`: Page number
- `limit`: Items per page

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "username": "user1@example.com",
      "email": "user1@example.com",
      "fullName": "User One",
      "role": "artist",
      "status": "active",
      "createdAt": "2024-01-15T12:00:00Z"
    },
    {
      "id": 2,
      "username": "user2@example.com",
      "email": "user2@example.com",
      "fullName": "User Two",
      "role": "label",
      "status": "active",
      "createdAt": "2024-02-20T09:30:00Z"
    }
  ],
  "meta": {
    "pagination": {
      "total": 50,
      "page": 1,
      "limit": 10,
      "totalPages": 5
    }
  }
}
```

##### Get User by ID

Retrieves a specific user by ID.

```
GET /users/:id
```

**Response:**

```json
{
  "data": {
    "id": 1,
    "username": "user@example.com",
    "email": "user@example.com",
    "fullName": "John Doe",
    "phoneNumber": "+1234567890",
    "entityName": "John Doe Music",
    "avatarUrl": "https://example.com/avatar.jpg",
    "role": "artist",
    "permissions": { ... },
    "status": "active",
    "createdAt": "2023-01-15T12:00:00Z"
  }
}
```

##### Update User

Updates user information.

```
PATCH /users/:id
```

**Request Body:**

```json
{
  "fullName": "Updated Name",
  "phoneNumber": "+9876543210",
  "entityName": "Updated Music"
}
```

**Response:**

```json
{
  "data": {
    "id": 1,
    "username": "user@example.com",
    "email": "user@example.com",
    "fullName": "Updated Name",
    "phoneNumber": "+9876543210",
    "entityName": "Updated Music",
    "avatarUrl": "https://example.com/avatar.jpg",
    "role": "artist",
    "permissions": { ... },
    "status": "active",
    "createdAt": "2023-01-15T12:00:00Z",
    "updatedAt": "2025-03-19T15:45:30Z"
  }
}
```

##### Update User Status

Updates a user's status (admin access required).

```
PATCH /users/:id/status
```

**Request Body:**

```json
{
  "status": "active"
}
```

**Response:**

```json
{
  "data": {
    "id": 1,
    "username": "user@example.com",
    "status": "active",
    "updatedAt": "2025-03-19T15:50:00Z"
  }
}
```

#### API Keys

##### Get API Keys

Retrieves all API keys for the authenticated user.

```
GET /api-keys
```

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "name": "Production API Key",
      "key": "pk_live_xxxxxxxxxxxxxxxxxxxx",
      "scopes": ["read:tracks", "read:releases", "read:analytics"],
      "createdAt": "2025-01-10T09:00:00Z",
      "expiresAt": "2026-01-10T09:00:00Z"
    },
    {
      "id": 2,
      "name": "Test API Key",
      "key": "pk_test_xxxxxxxxxxxxxxxxxxxx",
      "scopes": ["read:tracks", "write:tracks", "read:releases", "write:releases"],
      "createdAt": "2025-02-15T14:30:00Z",
      "expiresAt": "2026-02-15T14:30:00Z"
    }
  ]
}
```

##### Create API Key

Creates a new API key.

```
POST /api-keys
```

**Request Body:**

```json
{
  "name": "Development API Key",
  "scopes": ["read:tracks", "read:releases"]
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "name": "Development API Key",
    "key": "pk_dev_xxxxxxxxxxxxxxxxxxxx",
    "scopes": ["read:tracks", "read:releases"],
    "createdAt": "2025-03-19T16:00:00Z",
    "expiresAt": "2026-03-19T16:00:00Z"
  }
}
```

##### Delete API Key

Deletes an API key.

```
DELETE /api-keys/:id
```

**Response:**

```json
{
  "data": {
    "message": "API key deleted successfully"
  }
}
```

#### Tracks

##### Get Tracks

Retrieves tracks for the authenticated user.

```
GET /tracks
```

**Query Parameters:**

- `releaseId`: Filter by release ID
- `search`: Search by title or artist
- `page`: Page number
- `limit`: Items per page

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "title": "Track One",
      "version": "Original Mix",
      "isrc": "USRC12345678",
      "artistName": "Artist Name",
      "duration": 180,
      "language": "english",
      "explicit": false,
      "audioUrl": "https://example.com/tracks/track1.mp3",
      "releaseId": 101,
      "genre": "pop",
      "createdAt": "2025-01-20T10:00:00Z",
      "updatedAt": "2025-01-20T10:00:00Z"
    },
    {
      "id": 2,
      "title": "Track Two",
      "version": "Radio Edit",
      "isrc": "USRC23456789",
      "artistName": "Artist Name",
      "duration": 210,
      "language": "english",
      "explicit": false,
      "audioUrl": "https://example.com/tracks/track2.mp3",
      "releaseId": 101,
      "genre": "pop",
      "createdAt": "2025-01-20T10:15:00Z",
      "updatedAt": "2025-01-20T10:15:00Z"
    }
  ],
  "meta": {
    "pagination": {
      "total": 15,
      "page": 1,
      "limit": 10,
      "totalPages": 2
    }
  }
}
```

##### Get Track by ID

Retrieves a specific track by ID.

```
GET /tracks/:id
```

**Response:**

```json
{
  "data": {
    "id": 1,
    "title": "Track One",
    "version": "Original Mix",
    "isrc": "USRC12345678",
    "artistName": "Artist Name",
    "duration": 180,
    "language": "english",
    "explicit": false,
    "audioUrl": "https://example.com/tracks/track1.mp3",
    "releaseId": 101,
    "genre": "pop",
    "createdAt": "2025-01-20T10:00:00Z",
    "updatedAt": "2025-01-20T10:00:00Z"
  }
}
```

##### Create Track

Creates a new track.

```
POST /tracks
```

**Request Body:**

```json
{
  "title": "New Track",
  "version": "Original Mix",
  "artistName": "Artist Name",
  "language": "english",
  "explicit": false,
  "genre": "electronic",
  "releaseId": 101
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "title": "New Track",
    "version": "Original Mix",
    "isrc": "USRC34567890",
    "artistName": "Artist Name",
    "duration": 0,
    "language": "english",
    "explicit": false,
    "audioUrl": null,
    "releaseId": 101,
    "genre": "electronic",
    "createdAt": "2025-03-19T16:30:00Z",
    "updatedAt": "2025-03-19T16:30:00Z"
  }
}
```

##### Update Track

Updates a track.

```
PATCH /tracks/:id
```

**Request Body:**

```json
{
  "title": "Updated Track Title",
  "version": "Extended Mix",
  "genre": "house"
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "title": "Updated Track Title",
    "version": "Extended Mix",
    "isrc": "USRC34567890",
    "artistName": "Artist Name",
    "duration": 0,
    "language": "english",
    "explicit": false,
    "audioUrl": null,
    "releaseId": 101,
    "genre": "house",
    "createdAt": "2025-03-19T16:30:00Z",
    "updatedAt": "2025-03-19T16:45:00Z"
  }
}
```

##### Upload Track Audio

Uploads audio for a track.

```
POST /tracks/:id/audio
```

**Request Body:**

Multipart form data with `audio` file.

**Response:**

```json
{
  "data": {
    "id": 3,
    "title": "Updated Track Title",
    "audioUrl": "https://example.com/tracks/track3.mp3",
    "duration": 240,
    "updatedAt": "2025-03-19T17:00:00Z"
  }
}
```

##### Get Track Analytics

Retrieves analytics for a track.

```
GET /tracks/:id/analytics
```

**Query Parameters:**

- `startDate`: Filter by start date (YYYY-MM-DD)
- `endDate`: Filter by end date (YYYY-MM-DD)
- `platform`: Filter by platform

**Response:**

```json
{
  "data": [
    {
      "id": 101,
      "trackId": 3,
      "platform": "spotify",
      "streams": 5230,
      "revenue": 20.92,
      "date": "2025-03-01",
      "country": "US",
      "createdAt": "2025-03-15T00:00:00Z"
    },
    {
      "id": 102,
      "trackId": 3,
      "platform": "apple_music",
      "streams": 1850,
      "revenue": 9.25,
      "date": "2025-03-01",
      "country": "US",
      "createdAt": "2025-03-15T00:00:00Z"
    }
  ],
  "meta": {
    "summary": {
      "totalStreams": 7080,
      "totalRevenue": 30.17,
      "platforms": {
        "spotify": {
          "streams": 5230,
          "revenue": 20.92
        },
        "apple_music": {
          "streams": 1850,
          "revenue": 9.25
        }
      }
    }
  }
}
```

#### Releases

##### Get Releases

Retrieves releases for the authenticated user.

```
GET /releases
```

**Query Parameters:**

- `type`: Filter by release type (single, album, ep)
- `status`: Filter by distribution status
- `search`: Search by title or artist
- `page`: Page number
- `limit`: Items per page

**Response:**

```json
{
  "data": [
    {
      "id": 101,
      "title": "Album Title",
      "artistName": "Artist Name",
      "type": "album",
      "releaseDate": "2025-04-15",
      "upc": "123456789012",
      "artworkUrl": "https://example.com/artwork/album1.jpg",
      "distributionStatus": "pending",
      "createdAt": "2025-02-10T10:00:00Z",
      "updatedAt": "2025-02-10T10:00:00Z"
    },
    {
      "id": 102,
      "title": "Single Title",
      "artistName": "Artist Name",
      "type": "single",
      "releaseDate": "2025-03-01",
      "upc": "234567890123",
      "artworkUrl": "https://example.com/artwork/single1.jpg",
      "distributionStatus": "distributed",
      "createdAt": "2025-01-15T14:30:00Z",
      "updatedAt": "2025-01-28T09:15:00Z"
    }
  ],
  "meta": {
    "pagination": {
      "total": 8,
      "page": 1,
      "limit": 10,
      "totalPages": 1
    }
  }
}
```

##### Get Release by ID

Retrieves a specific release by ID.

```
GET /releases/:id
```

**Response:**

```json
{
  "data": {
    "id": 101,
    "title": "Album Title",
    "artistName": "Artist Name",
    "type": "album",
    "releaseDate": "2025-04-15",
    "upc": "123456789012",
    "artworkUrl": "https://example.com/artwork/album1.jpg",
    "distributionStatus": "pending",
    "tracks": [
      {
        "id": 1,
        "title": "Track One",
        "version": "Original Mix",
        "isrc": "USRC12345678",
        "duration": 180,
        "audioUrl": "https://example.com/tracks/track1.mp3"
      },
      {
        "id": 2,
        "title": "Track Two",
        "version": "Radio Edit",
        "isrc": "USRC23456789",
        "duration": 210,
        "audioUrl": "https://example.com/tracks/track2.mp3"
      }
    ],
    "createdAt": "2025-02-10T10:00:00Z",
    "updatedAt": "2025-02-10T10:00:00Z"
  }
}
```

##### Create Release

Creates a new release.

```
POST /releases
```

**Request Body:**

```json
{
  "title": "New Album",
  "artistName": "Artist Name",
  "type": "album",
  "releaseDate": "2025-06-01"
}
```

**Response:**

```json
{
  "data": {
    "id": 103,
    "title": "New Album",
    "artistName": "Artist Name",
    "type": "album",
    "releaseDate": "2025-06-01",
    "upc": "345678901234",
    "artworkUrl": null,
    "distributionStatus": "pending",
    "tracks": [],
    "createdAt": "2025-03-19T17:30:00Z",
    "updatedAt": "2025-03-19T17:30:00Z"
  }
}
```

##### Update Release

Updates a release.

```
PATCH /releases/:id
```

**Request Body:**

```json
{
  "title": "Updated Album Title",
  "releaseDate": "2025-06-15"
}
```

**Response:**

```json
{
  "data": {
    "id": 103,
    "title": "Updated Album Title",
    "artistName": "Artist Name",
    "type": "album",
    "releaseDate": "2025-06-15",
    "upc": "345678901234",
    "artworkUrl": null,
    "distributionStatus": "pending",
    "createdAt": "2025-03-19T17:30:00Z",
    "updatedAt": "2025-03-19T17:45:00Z"
  }
}
```

##### Upload Release Artwork

Uploads artwork for a release.

```
POST /releases/:id/artwork
```

**Request Body:**

Multipart form data with `artwork` file.

**Response:**

```json
{
  "data": {
    "id": 103,
    "title": "Updated Album Title",
    "artworkUrl": "https://example.com/artwork/album3.jpg",
    "updatedAt": "2025-03-19T18:00:00Z"
  }
}
```

#### Distribution

##### Get Distribution Platforms

Retrieves available distribution platforms.

```
GET /distribution/platforms
```

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "name": "Spotify",
      "apiEndpoint": "https://api.spotify.com",
      "logoUrl": "https://example.com/logos/spotify.png",
      "type": "streaming",
      "active": true,
      "createdAt": "2024-01-01T00:00:00Z"
    },
    {
      "id": 2,
      "name": "Apple Music",
      "apiEndpoint": "https://api.apple.com/music",
      "logoUrl": "https://example.com/logos/apple_music.png",
      "type": "streaming",
      "active": true,
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ]
}
```

##### Get Distribution Records

Retrieves distribution records for a release.

```
GET /distribution/records
```

**Query Parameters:**

- `releaseId`: Filter by release ID (required)

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "releaseId": 101,
      "platformId": 1,
      "status": "processing",
      "notes": "Distribution in progress",
      "createdAt": "2025-03-01T12:00:00Z",
      "updatedAt": "2025-03-01T12:15:00Z",
      "platform": {
        "id": 1,
        "name": "Spotify",
        "logoUrl": "https://example.com/logos/spotify.png"
      }
    },
    {
      "id": 2,
      "releaseId": 101,
      "platformId": 2,
      "status": "distributed",
      "notes": "Successfully distributed",
      "createdAt": "2025-03-01T12:00:00Z",
      "updatedAt": "2025-03-01T14:30:00Z",
      "platform": {
        "id": 2,
        "name": "Apple Music",
        "logoUrl": "https://example.com/logos/apple_music.png"
      }
    }
  ]
}
```

##### Create Distribution Record

Distributes a release to a platform.

```
POST /distribution/records
```

**Request Body:**

```json
{
  "releaseId": 101,
  "platformId": 3
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "releaseId": 101,
    "platformId": 3,
    "status": "pending",
    "notes": "Distribution initiated",
    "createdAt": "2025-03-19T18:30:00Z",
    "updatedAt": "2025-03-19T18:30:00Z",
    "platform": {
      "id": 3,
      "name": "Amazon Music",
      "logoUrl": "https://example.com/logos/amazon_music.png"
    }
  }
}
```

##### Schedule Distribution

Schedules a distribution for future execution.

```
POST /distribution/schedule
```

**Request Body:**

```json
{
  "releaseId": 103,
  "platformId": 1,
  "scheduledDate": "2025-06-01T00:00:00Z"
}
```

**Response:**

```json
{
  "data": {
    "id": 5,
    "releaseId": 103,
    "platformId": 1,
    "scheduledDate": "2025-06-01T00:00:00Z",
    "status": "scheduled",
    "createdAt": "2025-03-19T19:00:00Z",
    "updatedAt": "2025-03-19T19:00:00Z",
    "platform": {
      "id": 1,
      "name": "Spotify",
      "logoUrl": "https://example.com/logos/spotify.png"
    }
  }
}
```

##### Get Scheduled Distributions

Retrieves scheduled distributions for the authenticated user.

```
GET /distribution/scheduled
```

**Response:**

```json
{
  "data": [
    {
      "id": 5,
      "releaseId": 103,
      "platformId": 1,
      "scheduledDate": "2025-06-01T00:00:00Z",
      "status": "scheduled",
      "createdAt": "2025-03-19T19:00:00Z",
      "updatedAt": "2025-03-19T19:00:00Z",
      "platform": {
        "id": 1,
        "name": "Spotify",
        "logoUrl": "https://example.com/logos/spotify.png"
      },
      "release": {
        "id": 103,
        "title": "Updated Album Title",
        "artistName": "Artist Name"
      }
    }
  ]
}
```

##### Cancel Scheduled Distribution

Cancels a scheduled distribution.

```
DELETE /distribution/scheduled/:id
```

**Response:**

```json
{
  "data": {
    "message": "Scheduled distribution canceled successfully"
  }
}
```

#### Royalty Management

##### Get Payment Methods

Retrieves payment methods for the authenticated user.

```
GET /payments/methods
```

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "userId": 1,
      "type": "bank_account",
      "details": {
        "bankName": "Example Bank",
        "accountNumber": "****6789",
        "accountType": "checking"
      },
      "isDefault": true,
      "createdAt": "2025-01-15T10:00:00Z",
      "updatedAt": "2025-01-15T10:00:00Z"
    },
    {
      "id": 2,
      "userId": 1,
      "type": "paypal",
      "details": {
        "email": "user@example.com"
      },
      "isDefault": false,
      "createdAt": "2025-02-10T14:30:00Z",
      "updatedAt": "2025-02-10T14:30:00Z"
    }
  ]
}
```

##### Create Payment Method

Creates a new payment method.

```
POST /payments/methods
```

**Request Body:**

```json
{
  "type": "bank_account",
  "details": {
    "bankName": "New Bank",
    "accountNumber": "987654321",
    "routingNumber": "123456789",
    "accountType": "savings"
  },
  "isDefault": false
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "userId": 1,
    "type": "bank_account",
    "details": {
      "bankName": "New Bank",
      "accountNumber": "****4321",
      "accountType": "savings"
    },
    "isDefault": false,
    "createdAt": "2025-03-19T19:30:00Z",
    "updatedAt": "2025-03-19T19:30:00Z"
  }
}
```

##### Get Withdrawals

Retrieves withdrawal requests for the authenticated user.

```
GET /payments/withdrawals
```

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "userId": 1,
      "amount": 500.00,
      "status": "completed",
      "paymentMethod": {
        "id": 1,
        "type": "bank_account",
        "details": {
          "bankName": "Example Bank",
          "accountNumber": "****6789"
        }
      },
      "createdAt": "2025-02-01T10:00:00Z",
      "updatedAt": "2025-02-03T14:30:00Z"
    },
    {
      "id": 2,
      "userId": 1,
      "amount": 750.00,
      "status": "pending",
      "paymentMethod": {
        "id": 1,
        "type": "bank_account",
        "details": {
          "bankName": "Example Bank",
          "accountNumber": "****6789"
        }
      },
      "createdAt": "2025-03-15T09:00:00Z",
      "updatedAt": "2025-03-15T09:00:00Z"
    }
  ]
}
```

##### Create Withdrawal

Creates a new withdrawal request.

```
POST /payments/withdrawals
```

**Request Body:**

```json
{
  "amount": 1000.00,
  "paymentMethodId": 1
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "userId": 1,
    "amount": 1000.00,
    "status": "pending",
    "paymentMethod": {
      "id": 1,
      "type": "bank_account",
      "details": {
        "bankName": "Example Bank",
        "accountNumber": "****6789"
      }
    },
    "createdAt": "2025-03-19T20:00:00Z",
    "updatedAt": "2025-03-19T20:00:00Z"
  }
}
```

##### Get Revenue Shares

Retrieves revenue shares for a release.

```
GET /royalties/shares
```

**Query Parameters:**

- `releaseId`: Filter by release ID (required)

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "releaseId": 101,
      "userId": 1,
      "percentage": 70.0,
      "role": "primary_artist",
      "createdAt": "2025-02-10T10:30:00Z",
      "updatedAt": "2025-02-10T10:30:00Z",
      "user": {
        "id": 1,
        "fullName": "John Doe",
        "email": "user@example.com"
      }
    },
    {
      "id": 2,
      "releaseId": 101,
      "userId": 5,
      "percentage": 30.0,
      "role": "producer",
      "createdAt": "2025-02-10T10:30:00Z",
      "updatedAt": "2025-02-10T10:30:00Z",
      "user": {
        "id": 5,
        "fullName": "Jane Smith",
        "email": "producer@example.com"
      }
    }
  ]
}
```

##### Create Revenue Share

Creates a new revenue share.

```
POST /royalties/shares
```

**Request Body:**

```json
{
  "releaseId": 101,
  "userId": 10,
  "percentage": 10.0,
  "role": "featured_artist"
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "releaseId": 101,
    "userId": 10,
    "percentage": 10.0,
    "role": "featured_artist",
    "createdAt": "2025-03-19T20:30:00Z",
    "updatedAt": "2025-03-19T20:30:00Z",
    "user": {
      "id": 10,
      "fullName": "Featured Artist",
      "email": "featured@example.com"
    }
  }
}
```

#### Support System

##### Get Support Tickets

Retrieves support tickets for the authenticated user.

```
GET /support/tickets
```

**Query Parameters:**

- `status`: Filter by ticket status
- `page`: Page number
- `limit`: Items per page

**Response:**

```json
{
  "data": [
    {
      "id": 1,
      "userId": 1,
      "title": "Distribution Issue",
      "description": "My release isn't showing up on Spotify",
      "status": "open",
      "priority": "high",
      "category": "distribution",
      "assignedTo": null,
      "createdAt": "2025-03-15T10:00:00Z",
      "updatedAt": "2025-03-15T10:00:00Z"
    },
    {
      "id": 2,
      "userId": 1,
      "title": "Billing Question",
      "description": "I need clarification on my latest statement",
      "status": "closed",
      "priority": "medium",
      "category": "billing",
      "assignedTo": 100,
      "createdAt": "2025-02-20T14:30:00Z",
      "updatedAt": "2025-02-22T09:15:00Z"
    }
  ],
  "meta": {
    "pagination": {
      "total": 2,
      "page": 1,
      "limit": 10,
      "totalPages": 1
    }
  }
}
```

##### Get Support Ticket by ID

Retrieves a specific support ticket by ID.

```
GET /support/tickets/:id
```

**Response:**

```json
{
  "data": {
    "id": 1,
    "userId": 1,
    "title": "Distribution Issue",
    "description": "My release isn't showing up on Spotify",
    "status": "open",
    "priority": "high",
    "category": "distribution",
    "assignedTo": null,
    "createdAt": "2025-03-15T10:00:00Z",
    "updatedAt": "2025-03-15T10:00:00Z",
    "messages": [
      {
        "id": 1,
        "ticketId": 1,
        "userId": 1,
        "message": "My album was distributed to Spotify 3 days ago but still isn't showing up.",
        "createdAt": "2025-03-15T10:00:00Z"
      }
    ]
  }
}
```

##### Create Support Ticket

Creates a new support ticket.

```
POST /support/tickets
```

**Request Body:**

```json
{
  "title": "Metadata Question",
  "description": "How do I update the genre for my release?",
  "priority": "medium",
  "category": "content"
}
```

**Response:**

```json
{
  "data": {
    "id": 3,
    "userId": 1,
    "title": "Metadata Question",
    "description": "How do I update the genre for my release?",
    "status": "open",
    "priority": "medium",
    "category": "content",
    "assignedTo": null,
    "createdAt": "2025-03-19T21:00:00Z",
    "updatedAt": "2025-03-19T21:00:00Z"
  }
}
```

##### Add Message to Ticket

Adds a message to a support ticket.

```
POST /support/tickets/:id/messages
```

**Request Body:**

```json
{
  "message": "I need to change the genre from 'pop' to 'electronic pop'. Can you help me?"
}
```

**Response:**

```json
{
  "data": {
    "id": 2,
    "ticketId": 3,
    "userId": 1,
    "message": "I need to change the genre from 'pop' to 'electronic pop'. Can you help me?",
    "createdAt": "2025-03-19T21:15:00Z"
  }
}
```

#### File Upload

##### Upload File

Uploads a file to the server.

```
POST /upload
```

**Request Body:**

Multipart form data with `file` and optional `type` parameter.

**Response:**

```json
{
  "data": {
    "url": "https://example.com/uploads/12345.jpg",
    "filename": "image.jpg",
    "mimetype": "image/jpeg",
    "size": 102400
  }
}
```

### Webhooks

#### Webhook Events

TuneMantra supports webhooks for real-time event notifications. Available events include:

- `release.created`: A new release is created
- `release.updated`: A release is updated
- `release.distributed`: A release is distributed to a platform
- `track.created`: A new track is created
- `track.updated`: A track is updated
- `analytics.updated`: Analytics data is updated
- `payment.processed`: A payment is processed
- `withdrawal.status_changed`: A withdrawal status changes

#### Webhook Registration

To register a webhook endpoint, use the API Key management interface or contact support.

#### Webhook Payload

Webhook payloads follow this structure:

```json
{
  "event": "release.distributed",
  "timestamp": "2025-03-19T21:30:00Z",
  "data": {
    "releaseId": 101,
    "platformId": 1,
    "status": "distributed"
  }
}
```

#### Webhook Security

Webhooks include a signature header (`X-TuneMantra-Signature`) for verifying authenticity. The signature is a HMAC-SHA256 hash of the payload using your webhook secret.

### Error Codes

| Error Code | Description |
|------------|-------------|
| `AUTH_FAILED` | Authentication failed |
| `INVALID_TOKEN` | Invalid or expired token |
| `PERMISSION_DENIED` | Insufficient permissions |
| `RESOURCE_NOT_FOUND` | Requested resource not found |
| `VALIDATION_ERROR` | Request validation failed |
| `RATE_LIMIT_EXCEEDED` | Rate limit exceeded |
| `INTERNAL_ERROR` | Internal server error |
| `DUPLICATE_ENTITY` | Entity already exists |
| `INVALID_OPERATION` | Operation not allowed |
| `SUBSCRIPTION_REQUIRED` | Subscription required for this feature |

### Versioning

The TuneMantra API follows semantic versioning. The current version is v1.

### Support

For API support, contact api-support@tunemantra.com or create a support ticket through the API.

---

*© 2025 TuneMantra. All rights reserved.*

*Source: /home/runner/workspace/.archive/archive_docs/documentation/unified/api-reference/temp-3march-api-reference.md*

---

## TuneMantra API Reference (6)

## TuneMantra API Reference

*Version: 1.0.0 (March 27, 2025)*

### Table of Contents

- [Introduction](#introduction)
- [Authentication](#authentication)
- [Error Handling](#error-handling)
- [Rate Limiting](#rate-limiting)
- [API Versioning](#api-versioning)
- [User API](#user-api)
- [Organization API](#organization-api)
- [Content API](#content-api)
- [Distribution API](#distribution-api)
- [Rights API](#rights-api)
- [Royalty API](#royalty-api)
- [Analytics API](#analytics-api)
- [WebHooks API](#webhooks-api)
- [Appendix](#appendix)

### Introduction

The TuneMantra API provides programmatic access to the platform's functionality. This reference documents all available endpoints, request/response formats, and authentication requirements.

#### Base URL

All API requests should be made to:

```
https://api.tunemantra.com/v1
```

#### Request Format

All requests should be made with the appropriate HTTP method (GET, POST, PUT, DELETE) and include the required headers:

```
Content-Type: application/json
Authorization: Bearer {your_api_token}
```

#### Response Format

All responses are returned in JSON format. A typical response includes:

```json
{
  "status": "success",
  "data": { ... },
  "meta": {
    "page": 1,
    "limit": 50,
    "total": 245
  }
}
```

Error responses follow this format:

```json
{
  "status": "error",
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [...]
  }
}
```

### Authentication

#### Obtaining API Credentials

To use the TuneMantra API, you must first obtain API credentials:

1. Log in to your TuneMantra account
2. Navigate to Settings > API Access
3. Click "Create API Key"
4. Configure the permissions for your API key
5. Store the API key securely

#### Authentication Methods

The API supports two authentication methods:

##### Bearer Token Authentication

Include your API token in the Authorization header:

```
Authorization: Bearer {your_api_token}
```

##### OAuth 2.0 Authentication

For third-party applications, use OAuth 2.0:

1. Redirect users to `https://api.tunemantra.com/oauth/authorize`
2. User authorizes your application
3. User is redirected back with an authorization code
4. Exchange the code for an access token at `https://api.tunemantra.com/oauth/token`
5. Use the access token in API requests

### Error Handling

#### Error Codes

The API uses standard HTTP status codes and provides detailed error messages:

| Status Code | Meaning |
|-------------|---------|
| 200 | OK - The request was successful |
| 201 | Created - Resource was successfully created |
| 400 | Bad Request - Invalid input data |
| 401 | Unauthorized - Authentication required |
| 403 | Forbidden - Insufficient permissions |
| 404 | Not Found - Resource not found |
| 409 | Conflict - Resource conflict |
| 429 | Too Many Requests - Rate limit exceeded |
| 500 | Internal Server Error - Server-side error |

#### Error Response Format

```json
{
  "status": "error",
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": [
      {
        "field": "field_name",
        "message": "Specific error for this field"
      }
    ]
  }
}
```

### Rate Limiting

To ensure system stability, the API implements rate limiting:

| Plan | Requests per Minute | Daily Limit |
|------|---------------------|-------------|
| Basic | 60 | 10,000 |
| Professional | 300 | 50,000 |
| Enterprise | 1,000 | 250,000 |

Rate limit headers are included in all responses:

```
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 58
X-RateLimit-Reset: 1616136850
```

### API Versioning

#### Version Format

The API version is included in the URL path:

```
https://api.tunemantra.com/v1/resource
```

#### Version Support

- Major versions (v1, v2) may include breaking changes
- Minor versions are backward compatible
- Each major version is supported for 18 months after a new major version is released

### User API

#### Get Current User

Retrieves information about the authenticated user.

**Request:**

```
GET /users/me
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": "user_12345",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "role": "admin",
    "organizationId": "org_12345",
    "createdAt": "2023-01-15T12:00:00Z",
    "lastLogin": "2023-03-27T09:15:22Z",
    "preferences": {
      "timezone": "America/New_York",
      "language": "en-US",
      "notifications": {
        "email": true,
        "push": false
      }
    }
  }
}
```

#### List Users

Returns a list of users in the organization.

**Request:**

```
GET /users?limit=50&page=1
```

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| limit | number | Number of results per page (default: 50, max: 100) |
| page | number | Page number (default: 1) |
| role | string | Filter by role (optional) |
| query | string | Search by name or email (optional) |

**Response:**

```json
{
  "status": "success",
  "data": [
    {
      "id": "user_12345",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "admin",
      "organizationId": "org_12345",
      "createdAt": "2023-01-15T12:00:00Z",
      "lastLogin": "2023-03-27T09:15:22Z"
    },
    {
      "id": "user_12346",
      "email": "user2@example.com",
      "firstName": "Jane",
      "lastName": "Smith",
      "role": "content_manager",
      "organizationId": "org_12345",
      "createdAt": "2023-02-10T14:30:00Z",
      "lastLogin": "2023-03-26T16:45:10Z"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 50,
    "total": 245
  }
}
```

#### Create User

Creates a new user in the organization.

**Request:**

```
POST /users
```

**Request Body:**

```json
{
  "email": "newuser@example.com",
  "firstName": "Sarah",
  "lastName": "Johnson",
  "role": "content_manager",
  "password": "SecurePassword123!",
  "preferences": {
    "timezone": "Europe/London",
    "language": "en-GB"
  }
}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": "user_12347",
    "email": "newuser@example.com",
    "firstName": "Sarah",
    "lastName": "Johnson",
    "role": "content_manager",
    "organizationId": "org_12345",
    "createdAt": "2023-03-27T10:30:00Z",
    "preferences": {
      "timezone": "Europe/London",
      "language": "en-GB",
      "notifications": {
        "email": true,
        "push": true
      }
    }
  }
}
```

#### Update User

Updates an existing user.

**Request:**

```
PUT /users/{user_id}
```

**Request Body:**

```json
{
  "firstName": "Sarah",
  "lastName": "Johnson-Smith",
  "role": "rights_manager",
  "preferences": {
    "timezone": "Europe/Paris"
  }
}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": "user_12347",
    "email": "newuser@example.com",
    "firstName": "Sarah",
    "lastName": "Johnson-Smith",
    "role": "rights_manager",
    "organizationId": "org_12345",
    "createdAt": "2023-03-27T10:30:00Z",
    "updatedAt": "2023-03-27T11:15:00Z",
    "preferences": {
      "timezone": "Europe/Paris",
      "language": "en-GB",
      "notifications": {
        "email": true,
        "push": true
      }
    }
  }
}
```

#### Delete User

Deletes a user.

**Request:**

```
DELETE /users/{user_id}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "message": "User deleted successfully"
  }
}
```

### Organization API

#### Get Organization

Retrieves information about the specified organization.

**Request:**

```
GET /organizations/{organization_id}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": "org_12345",
    "name": "Example Records",
    "type": "label",
    "tier": "professional",
    "createdAt": "2022-05-10T08:30:00Z",
    "contactEmail": "info@examplerecords.com",
    "phone": "+1-555-123-4567",
    "address": {
      "street": "123 Music Avenue",
      "city": "Los Angeles",
      "state": "CA",
      "postalCode": "90001",
      "country": "US"
    },
    "branding": {
      "logoUrl": "https://assets.tunemantra.com/logos/example-records.png",
      "primaryColor": "#3A86FF",
      "secondaryColor": "#FF006E"
    },
    "settings": {
      "defaultCurrency": "USD",
      "fiscalYearStart": "01-01",
      "defaultPaymentMethod": "direct_deposit"
    },
    "parent": null,
    "subsidiaries": [
      {
        "id": "org_12346",
        "name": "Example Urban",
        "type": "imprint"
      },
      {
        "id": "org_12347",
        "name": "Example Classical",
        "type": "imprint"
      }
    ]
  }
}
```

#### List Organizations

Returns a list of organizations.

**Request:**

```
GET /organizations?limit=50&page=1
```

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| limit | number | Number of results per page (default: 50, max: 100) |
| page | number | Page number (default: 1) |
| type | string | Filter by organization type (optional) |
| parent | string | Filter by parent organization ID (optional) |
| query | string | Search by name (optional) |

**Response:**

```json
{
  "status": "success",
  "data": [
    {
      "id": "org_12345",
      "name": "Example Records",
      "type": "label",
      "tier": "professional",
      "createdAt": "2022-05-10T08:30:00Z"
    },
    {
      "id": "org_12346",
      "name": "Example Urban",
      "type": "imprint",
      "tier": "professional",
      "createdAt": "2022-06-15T10:45:00Z",
      "parent": {
        "id": "org_12345",
        "name": "Example Records"
      }
    }
  ],
  "meta": {
    "page": 1,
    "limit": 50,
    "total": 12
  }
}
```

#### Create Organization

Creates a new organization.

**Request:**

```
POST /organizations
```

**Request Body:**

```json
{
  "name": "New Label Records",
  "type": "label",
  "tier": "professional",
  "contactEmail": "info@newlabelrecords.com",
  "phone": "+1-555-987-6543",
  "address": {
    "street": "456 Melody Lane",
    "city": "Nashville",
    "state": "TN",
    "postalCode": "37203",
    "country": "US"
  },
  "branding": {
    "primaryColor": "#4CAF50",
    "secondaryColor": "#FFC107"
  },
  "settings": {
    "defaultCurrency": "USD",
    "fiscalYearStart": "01-01",
    "defaultPaymentMethod": "paypal"
  },
  "parentId": null
}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": "org_12348",
    "name": "New Label Records",
    "type": "label",
    "tier": "professional",
    "createdAt": "2023-03-27T14:00:00Z",
    "contactEmail": "info@newlabelrecords.com",
    "phone": "+1-555-987-6543",
    "address": {
      "street": "456 Melody Lane",
      "city": "Nashville",
      "state": "TN",
      "postalCode": "37203",
      "country": "US"
    },
    "branding": {
      "logoUrl": null,
      "primaryColor": "#4CAF50",
      "secondaryColor": "#FFC107"
    },
    "settings": {
      "defaultCurrency": "USD",
      "fiscalYearStart": "01-01",
      "defaultPaymentMethod": "paypal"
    },
    "parent": null,
    "subsidiaries": []
  }
}
```

### Content API

#### Get Release

Retrieves information about a specific release.

**Request:**

```
GET /content/releases/{release_id}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": "rel_12345",
    "title": "Summer Vibes",
    "artist": "DJ Sunshine",
    "type": "album",
    "upc": "123456789012",
    "releaseDate": "2023-06-15",
    "originalReleaseDate": "2023-06-15",
    "label": {
      "id": "org_12345",
      "name": "Example Records"
    },
    "genre": ["Electronic", "Dance"],
    "subGenre": "House",
    "language": "English",
    "explicit": false,
    "status": "released",
    "artwork": {
      "url": "https://assets.tunemantra.com/artwork/rel_12345.jpg",
      "width": 3000,
      "height": 3000
    },
    "tracks": [
      {
        "id": "track_23456",
        "title": "Summer Begins",
        "artist": "DJ Sunshine",
        "isrc": "ABCDE1234567",
        "trackNumber": 1,
        "discNumber": 1,
        "duration": 195,
        "explicit": false,
        "audioFile": {
          "url": "https://assets.tunemantra.com/audio/track_23456.wav",
          "format": "WAV",
          "bitrate": 1411,
          "sampleRate": 44100
        }
      },
      {
        "id": "track_23457",
        "title": "Beach Party",
        "artist": "DJ Sunshine ft. Sandy Shores",
        "isrc": "ABCDE1234568",
        "trackNumber": 2,
        "discNumber": 1,
        "duration": 210,
        "explicit": false,
        "audioFile": {
          "url": "https://assets.tunemantra.com/audio/track_23457.wav",
          "format": "WAV",
          "bitrate": 1411,
          "sampleRate": 44100
        }
      }
    ],
    "createdAt": "2023-03-01T09:30:00Z",
    "updatedAt": "2023-03-10T14:45:00Z",
    "metadata": {
      "copyright": "℗ 2023 Example Records",
      "publishingRights": "© 2023 Example Records",
      "territories": ["WORLDWIDE"],
      "parental_advisory": false,
      "compilation": false
    },
    "distribution": {
      "status": "complete",
      "platforms": [
        {
          "name": "Spotify",
          "status": "live",
          "link": "https://open.spotify.com/album/123456"
        },
        {
          "name": "Apple Music",
          "status": "live",
          "link": "https://music.apple.com/album/123456"
        }
      ]
    }
  }
}
```

#### List Releases

Returns a list of releases.

**Request:**

```
GET /content/releases?limit=50&page=1
```

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| limit | number | Number of results per page (default: 50, max: 100) |
| page | number | Page number (default: 1) |
| artist | string | Filter by artist (optional) |
| status | string | Filter by status (optional) |
| type | string | Filter by release type (optional) |
| date_from | string | Filter by release date from (YYYY-MM-DD) (optional) |
| date_to | string | Filter by release date to (YYYY-MM-DD) (optional) |
| query | string | Search by title or UPC (optional) |

**Response:**

```json
{
  "status": "success",
  "data": [
    {
      "id": "rel_12345",
      "title": "Summer Vibes",
      "artist": "DJ Sunshine",
      "type": "album",
      "upc": "123456789012",
      "releaseDate": "2023-06-15",
      "label": {
        "id": "org_12345",
        "name": "Example Records"
      },
      "status": "released",
      "artwork": {
        "url": "https://assets.tunemantra.com/artwork/rel_12345_thumb.jpg"
      },
      "trackCount": 10
    },
    {
      "id": "rel_12346",
      "title": "Winter Dreams",
      "artist": "Frosty Tones",
      "type": "single",
      "upc": "123456789013",
      "releaseDate": "2023-12-01",
      "label": {
        "id": "org_12345",
        "name": "Example Records"
      },
      "status": "scheduled",
      "artwork": {
        "url": "https://assets.tunemantra.com/artwork/rel_12346_thumb.jpg"
      },
      "trackCount": 1
    }
  ],
  "meta": {
    "page": 1,
    "limit": 50,
    "total": 245
  }
}
```

#### Create Release

Creates a new release.

**Request:**

```
POST /content/releases
```

**Request Body:**

```json
{
  "title": "Autumn Leaves",
  "artist": "Maple Tree",
  "type": "EP",
  "upc": "123456789014",
  "releaseDate": "2023-09-21",
  "originalReleaseDate": "2023-09-21",
  "labelId": "org_12345",
  "genre": ["Indie", "Folk"],
  "subGenre": "Acoustic",
  "language": "English",
  "explicit": false,
  "metadata": {
    "copyright": "℗ 2023 Example Records",
    "publishingRights": "© 2023 Example Records",
    "territories": ["WORLDWIDE"],
    "parental_advisory": false,
    "compilation": false
  }
}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": "rel_12347",
    "title": "Autumn Leaves",
    "artist": "Maple Tree",
    "type": "EP",
    "upc": "123456789014",
    "releaseDate": "2023-09-21",
    "originalReleaseDate": "2023-09-21",
    "label": {
      "id": "org_12345",
      "name": "Example Records"
    },
    "genre": ["Indie", "Folk"],
    "subGenre": "Acoustic",
    "language": "English",
    "explicit": false,
    "status": "draft",
    "artwork": null,
    "tracks": [],
    "createdAt": "2023-03-27T15:30:00Z",
    "updatedAt": "2023-03-27T15:30:00Z",
    "metadata": {
      "copyright": "℗ 2023 Example Records",
      "publishingRights": "© 2023 Example Records",
      "territories": ["WORLDWIDE"],
      "parental_advisory": false,
      "compilation": false
    },
    "distribution": {
      "status": "not_started",
      "platforms": []
    }
  }
}
```

### Distribution API

#### Get Distribution Status

Retrieves the distribution status for a release.

**Request:**

```
GET /distribution/releases/{release_id}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "releaseId": "rel_12345",
    "releaseTitle": "Summer Vibes",
    "overallStatus": "complete",
    "distributionDate": "2023-05-15T08:00:00Z",
    "lastUpdated": "2023-05-20T14:30:00Z",
    "platforms": [
      {
        "id": "platform_1",
        "name": "Spotify",
        "status": "live",
        "deliveryDate": "2023-05-15T08:10:00Z",
        "liveDate": "2023-05-17T12:30:00Z",
        "link": "https://open.spotify.com/album/123456",
        "errors": null
      },
      {
        "id": "platform_2",
        "name": "Apple Music",
        "status": "live",
        "deliveryDate": "2023-05-15T08:15:00Z",
        "liveDate": "2023-05-18T09:45:00Z",
        "link": "https://music.apple.com/album/123456",
        "errors": null
      },
      {
        "id": "platform_3",
        "name": "Amazon Music",
        "status": "live",
        "deliveryDate": "2023-05-15T08:20:00Z",
        "liveDate": "2023-05-19T16:20:00Z",
        "link": "https://music.amazon.com/albums/123456",
        "errors": null
      },
      {
        "id": "platform_4",
        "name": "Tidal",
        "status": "processing",
        "deliveryDate": "2023-05-15T08:25:00Z",
        "liveDate": null,
        "link": null,
        "errors": null
      },
      {
        "id": "platform_5",
        "name": "YouTube Music",
        "status": "error",
        "deliveryDate": "2023-05-15T08:30:00Z",
        "liveDate": null,
        "link": null,
        "errors": [
          {
            "code": "ARTWORK_RESOLUTION",
            "message": "Artwork does not meet minimum resolution requirements",
            "details": "Minimum 3000x3000 pixels required"
          }
        ]
      }
    ],
    "territories": ["WORLDWIDE"],
    "exclusions": [],
    "takedowns": []
  }
}
```

#### Create Distribution

Creates a distribution plan for a release.

**Request:**

```
POST /distribution/releases
```

**Request Body:**

```json
{
  "releaseId": "rel_12347",
  "scheduledDate": "2023-09-14T00:00:00Z",
  "platforms": [
    "platform_1",
    "platform_2",
    "platform_3",
    "platform_4",
    "platform_5"
  ],
  "territories": ["WORLDWIDE"],
  "exclusions": [
    {
      "platform": "platform_5",
      "territories": ["CN"]
    }
  ],
  "preOrder": {
    "enabled": true,
    "startDate": "2023-09-01T00:00:00Z"
  }
}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": "dist_34567",
    "releaseId": "rel_12347",
    "releaseTitle": "Autumn Leaves",
    "overallStatus": "scheduled",
    "scheduledDate": "2023-09-14T00:00:00Z",
    "createdAt": "2023-03-27T16:00:00Z",
    "platforms": [
      {
        "id": "platform_1",
        "name": "Spotify",
        "status": "scheduled",
        "scheduledDate": "2023-09-14T00:00:00Z"
      },
      {
        "id": "platform_2",
        "name": "Apple Music",
        "status": "scheduled",
        "scheduledDate": "2023-09-14T00:00:00Z"
      },
      {
        "id": "platform_3",
        "name": "Amazon Music",
        "status": "scheduled",
        "scheduledDate": "2023-09-14T00:00:00Z"
      },
      {
        "id": "platform_4",
        "name": "Tidal",
        "status": "scheduled",
        "scheduledDate": "2023-09-14T00:00:00Z"
      },
      {
        "id": "platform_5",
        "name": "YouTube Music",
        "status": "scheduled",
        "scheduledDate": "2023-09-14T00:00:00Z",
        "territories": ["WORLDWIDE", "!CN"]
      }
    ],
    "territories": ["WORLDWIDE"],
    "exclusions": [
      {
        "platform": "platform_5",
        "territories": ["CN"]
      }
    ],
    "preOrder": {
      "enabled": true,
      "startDate": "2023-09-01T00:00:00Z"
    }
  }
}
```

#### Create Takedown

Creates a takedown request for a release.

**Request:**

```
POST /distribution/takedowns
```

**Request Body:**

```json
{
  "releaseId": "rel_12345",
  "reason": "COPYRIGHT_DISPUTE",
  "details": "Copyright claim from original rights holder",
  "platforms": ["platform_1", "platform_2"],
  "territories": ["WORLDWIDE"],
  "urgency": "high"
}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": "takedown_23456",
    "releaseId": "rel_12345",
    "releaseTitle": "Summer Vibes",
    "reason": "COPYRIGHT_DISPUTE",
    "details": "Copyright claim from original rights holder",
    "status": "processing",
    "createdAt": "2023-03-27T16:30:00Z",
    "completedAt": null,
    "platforms": [
      {
        "id": "platform_1",
        "name": "Spotify",
        "status": "processing",
        "requestDate": "2023-03-27T16:30:00Z",
        "completionDate": null
      },
      {
        "id": "platform_2",
        "name": "Apple Music",
        "status": "processing",
        "requestDate": "2023-03-27T16:30:00Z",
        "completionDate": null
      }
    ],
    "territories": ["WORLDWIDE"],
    "urgency": "high"
  }
}
```

### Rights API

#### Get Rights

Retrieves rights information for a specific content item.

**Request:**

```
GET /rights/content/{content_id}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "contentId": "track_23456",
    "contentType": "track",
    "contentTitle": "Summer Begins",
    "artist": "DJ Sunshine",
    "masterRights": [
      {
        "id": "right_34567",
        "type": "master_recording",
        "territories": ["WORLDWIDE"],
        "startDate": "2023-01-01",
        "endDate": null,
        "owners": [
          {
            "entity": {
              "id": "org_12345",
              "name": "Example Records",
              "type": "organization"
            },
            "percentage": 80.00,
            "role": "record_label"
          },
          {
            "entity": {
              "id": "user_12345",
              "name": "John Producer",
              "type": "individual"
            },
            "percentage": 20.00,
            "role": "producer"
          }
        ],
        "documentUrl": "https://assets.tunemantra.com/documents/rights_34567.pdf",
        "status": "active",
        "createdAt": "2023-01-15T10:00:00Z",
        "updatedAt": "2023-01-15T10:00:00Z"
      }
    ],
    "publishingRights": [
      {
        "id": "right_34568",
        "type": "publishing",
        "territories": ["WORLDWIDE"],
        "startDate": "2023-01-01",
        "endDate": null,
        "owners": [
          {
            "entity": {
              "id": "org_12348",
              "name": "Example Publishing",
              "type": "organization"
            },
            "percentage": 50.00,
            "role": "publisher"
          },
          {
            "entity": {
              "id": "user_12345",
              "name": "John Writer",
              "type": "individual"
            },
            "percentage": 50.00,
            "role": "songwriter"
          }
        ],
        "documentUrl": "https://assets.tunemantra.com/documents/rights_34568.pdf",
        "status": "active",
        "createdAt": "2023-01-15T10:30:00Z",
        "updatedAt": "2023-01-15T10:30:00Z"
      }
    ],
    "performanceRights": [
      {
        "id": "right_34569",
        "type": "performance",
        "territories": ["WORLDWIDE"],
        "startDate": "2023-01-01",
        "endDate": null,
        "owners": [
          {
            "entity": {
              "id": "user_12345",
              "name": "DJ Sunshine",
              "type": "individual"
            },
            "percentage": 100.00,
            "role": "performer"
          }
        ],
        "documentUrl": "https://assets.tunemantra.com/documents/rights_34569.pdf",
        "status": "active",
        "createdAt": "2023-01-15T11:00:00Z",
        "updatedAt": "2023-01-15T11:00:00Z"
      }
    ],
    "conflicts": []
  }
}
```

#### Create Rights

Creates a new rights record.

**Request:**

```
POST /rights
```

**Request Body:**

```json
{
  "contentId": "track_23457",
  "contentType": "track",
  "rightType": "master_recording",
  "territories": ["WORLDWIDE"],
  "startDate": "2023-01-01",
  "endDate": null,
  "owners": [
    {
      "entityId": "org_12345",
      "entityType": "organization",
      "percentage": 80.00,
      "role": "record_label"
    },
    {
      "entityId": "user_12345",
      "entityType": "individual",
      "percentage": 20.00,
      "role": "producer"
    }
  ],
  "documentUrl": "https://assets.tunemantra.com/documents/rights_34570.pdf"
}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": "right_34570",
    "contentId": "track_23457",
    "contentType": "track",
    "contentTitle": "Beach Party",
    "type": "master_recording",
    "territories": ["WORLDWIDE"],
    "startDate": "2023-01-01",
    "endDate": null,
    "owners": [
      {
        "entity": {
          "id": "org_12345",
          "name": "Example Records",
          "type": "organization"
        },
        "percentage": 80.00,
        "role": "record_label"
      },
      {
        "entity": {
          "id": "user_12345",
          "name": "John Producer",
          "type": "individual"
        },
        "percentage": 20.00,
        "role": "producer"
      }
    ],
    "documentUrl": "https://assets.tunemantra.com/documents/rights_34570.pdf",
    "status": "active",
    "createdAt": "2023-03-27T17:00:00Z",
    "updatedAt": "2023-03-27T17:00:00Z",
    "conflicts": []
  }
}
```

### Royalty API

#### Get Royalty Statement

Retrieves a royalty statement.

**Request:**

```
GET /royalties/statements/{statement_id}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": "stmt_45678",
    "recipient": {
      "id": "user_12345",
      "name": "John Doe",
      "type": "individual"
    },
    "organization": {
      "id": "org_12345",
      "name": "Example Records"
    },
    "period": {
      "startDate": "2023-01-01",
      "endDate": "2023-03-31"
    },
    "generatedDate": "2023-04-15T10:00:00Z",
    "status": "paid",
    "currency": "USD",
    "summary": {
      "totalRevenue": 5250.75,
      "totalRoyalties": 1050.15,
      "advances": 0.00,
      "recoupables": 0.00,
      "adjustments": 0.00,
      "taxWithheld": 105.02,
      "netPayable": 945.13
    },
    "earnings": [
      {
        "releaseId": "rel_12345",
        "releaseTitle": "Summer Vibes",
        "trackId": "track_23456",
        "trackTitle": "Summer Begins",
        "platform": "Spotify",
        "territory": "US",
        "earningType": "streaming",
        "units": 250000,
        "revenue": 1000.00,
        "royaltyRate": 20.00,
        "royaltyAmount": 200.00
      },
      {
        "releaseId": "rel_12345",
        "releaseTitle": "Summer Vibes",
        "trackId": "track_23456",
        "trackTitle": "Summer Begins",
        "platform": "Apple Music",
        "territory": "US",
        "earningType": "streaming",
        "units": 150000,
        "revenue": 750.00,
        "royaltyRate": 20.00,
        "royaltyAmount": 150.00
      }
    ],
    "paymentDetails": {
      "paymentId": "pmt_56789",
      "paymentDate": "2023-04-20T14:30:00Z",
      "paymentMethod": "direct_deposit",
      "paymentReference": "REF123456"
    }
  }
}
```

#### List Royalty Statements

Returns a list of royalty statements.

**Request:**

```
GET /royalties/statements?limit=50&page=1
```

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| limit | number | Number of results per page (default: 50, max: 100) |
| page | number | Page number (default: 1) |
| recipient_id | string | Filter by recipient ID (optional) |
| period_start | string | Filter by period start date (YYYY-MM-DD) (optional) |
| period_end | string | Filter by period end date (YYYY-MM-DD) (optional) |
| status | string | Filter by status (optional) |

**Response:**

```json
{
  "status": "success",
  "data": [
    {
      "id": "stmt_45678",
      "recipient": {
        "id": "user_12345",
        "name": "John Doe",
        "type": "individual"
      },
      "organization": {
        "id": "org_12345",
        "name": "Example Records"
      },
      "period": {
        "startDate": "2023-01-01",
        "endDate": "2023-03-31"
      },
      "generatedDate": "2023-04-15T10:00:00Z",
      "status": "paid",
      "currency": "USD",
      "summary": {
        "totalRoyalties": 1050.15,
        "netPayable": 945.13
      }
    },
    {
      "id": "stmt_45679",
      "recipient": {
        "id": "user_12345",
        "name": "John Doe",
        "type": "individual"
      },
      "organization": {
        "id": "org_12345",
        "name": "Example Records"
      },
      "period": {
        "startDate": "2022-10-01",
        "endDate": "2022-12-31"
      },
      "generatedDate": "2023-01-15T10:00:00Z",
      "status": "paid",
      "currency": "USD",
      "summary": {
        "totalRoyalties": 875.50,
        "netPayable": 787.95
      }
    }
  ],
  "meta": {
    "page": 1,
    "limit": 50,
    "total": 8
  }
}
```

#### Generate Royalty Statement

Generates a new royalty statement.

**Request:**

```
POST /royalties/statements
```

**Request Body:**

```json
{
  "recipientId": "user_12345",
  "organizationId": "org_12345",
  "period": {
    "startDate": "2023-04-01",
    "endDate": "2023-06-30"
  },
  "currency": "USD"
}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": "stmt_45680",
    "recipient": {
      "id": "user_12345",
      "name": "John Doe",
      "type": "individual"
    },
    "organization": {
      "id": "org_12345",
      "name": "Example Records"
    },
    "period": {
      "startDate": "2023-04-01",
      "endDate": "2023-06-30"
    },
    "generatedDate": "2023-03-27T17:30:00Z",
    "status": "processing",
    "currency": "USD",
    "estimatedCompletionTime": "2023-03-27T18:00:00Z"
  }
}
```

### Analytics API

#### Get Release Performance

Retrieves performance analytics for a specific release.

**Request:**

```
GET /analytics/releases/{release_id}?period=30d
```

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| period | string | Time period for analytics (7d, 30d, 90d, 1y, all) |
| platform | string | Filter by platform (optional) |
| territory | string | Filter by territory (optional) |

**Response:**

```json
{
  "status": "success",
  "data": {
    "releaseId": "rel_12345",
    "releaseTitle": "Summer Vibes",
    "period": "30d",
    "dateRange": {
      "from": "2023-02-25",
      "to": "2023-03-27"
    },
    "summary": {
      "totalStreams": 1250000,
      "totalRevenue": 5000.00,
      "percentChange": {
        "streams": 15.3,
        "revenue": 12.8
      }
    },
    "platforms": [
      {
        "name": "Spotify",
        "streams": 750000,
        "revenue": 3000.00,
        "percentChange": {
          "streams": 18.5,
          "revenue": 16.2
        }
      },
      {
        "name": "Apple Music",
        "streams": 300000,
        "revenue": 1500.00,
        "percentChange": {
          "streams": 10.2,
          "revenue": 9.5
        }
      },
      {
        "name": "Amazon Music",
        "streams": 150000,
        "revenue": 450.00,
        "percentChange": {
          "streams": 12.1,
          "revenue": 10.8
        }
      },
      {
        "name": "Other",
        "streams": 50000,
        "revenue": 50.00,
        "percentChange": {
          "streams": 5.3,
          "revenue": 4.1
        }
      }
    ],
    "territories": [
      {
        "code": "US",
        "name": "United States",
        "streams": 500000,
        "revenue": 2500.00,
        "percentChange": {
          "streams": 20.1,
          "revenue": 18.5
        }
      },
      {
        "code": "GB",
        "name": "United Kingdom",
        "streams": 250000,
        "revenue": 1000.00,
        "percentChange": {
          "streams": 15.3,
          "revenue": 13.2
        }
      },
      {
        "code": "DE",
        "name": "Germany",
        "streams": 150000,
        "revenue": 600.00,
        "percentChange": {
          "streams": 12.5,
          "revenue": 11.8
        }
      },
      {
        "code": "OTHER",
        "name": "Other Countries",
        "streams": 350000,
        "revenue": 900.00,
        "percentChange": {
          "streams": 8.7,
          "revenue": 7.9
        }
      }
    ],
    "timeSeries": {
      "intervals": [
        "2023-02-25",
        "2023-02-26",
        "2023-02-27",
        // More dates...
        "2023-03-27"
      ],
      "streams": [
        42000,
        41500,
        43200,
        // More values...
        45600
      ],
      "revenue": [
        168.00,
        166.00,
        172.80,
        // More values...
        182.40
      ]
    },
    "tracks": [
      {
        "id": "track_23456",
        "title": "Summer Begins",
        "streams": 750000,
        "revenue": 3000.00,
        "percentChange": {
          "streams": 25.3,
          "revenue": 22.8
        }
      },
      {
        "id": "track_23457",
        "title": "Beach Party",
        "streams": 500000,
        "revenue": 2000.00,
        "percentChange": {
          "streams": 5.3,
          "revenue": 4.8
        }
      }
    ]
  }
}
```

#### Get Artist Performance

Retrieves performance analytics for a specific artist.

**Request:**

```
GET /analytics/artists/{artist_id}?period=90d
```

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| period | string | Time period for analytics (7d, 30d, 90d, 1y, all) |
| platform | string | Filter by platform (optional) |
| territory | string | Filter by territory (optional) |

**Response:**

```json
{
  "status": "success",
  "data": {
    "artistId": "artist_12345",
    "artistName": "DJ Sunshine",
    "period": "90d",
    "dateRange": {
      "from": "2022-12-27",
      "to": "2023-03-27"
    },
    "summary": {
      "totalStreams": 5250000,
      "totalRevenue": 21000.00,
      "percentChange": {
        "streams": 35.3,
        "revenue": 32.8
      }
    },
    "platforms": [
      {
        "name": "Spotify",
        "streams": 3150000,
        "revenue": 12600.00,
        "percentChange": {
          "streams": 38.5,
          "revenue": 36.2
        }
      },
      {
        "name": "Apple Music",
        "streams": 1260000,
        "revenue": 6300.00,
        "percentChange": {
          "streams": 30.2,
          "revenue": 29.5
        }
      },
      {
        "name": "Amazon Music",
        "streams": 630000,
        "revenue": 1890.00,
        "percentChange": {
          "streams": 32.1,
          "revenue": 30.8
        }
      },
      {
        "name": "Other",
        "streams": 210000,
        "revenue": 210.00,
        "percentChange": {
          "streams": 25.3,
          "revenue": 24.1
        }
      }
    ],
    "territories": [
      {
        "code": "US",
        "name": "United States",
        "streams": 2100000,
        "revenue": 10500.00,
        "percentChange": {
          "streams": 40.1,
          "revenue": 38.5
        }
      },
      {
        "code": "GB",
        "name": "United Kingdom",
        "streams": 1050000,
        "revenue": 4200.00,
        "percentChange": {
          "streams": 35.3,
          "revenue": 33.2
        }
      },
      {
        "code": "DE",
        "name": "Germany",
        "streams": 630000,
        "revenue": 2520.00,
        "percentChange": {
          "streams": 32.5,
          "revenue": 31.8
        }
      },
      {
        "code": "OTHER",
        "name": "Other Countries",
        "streams": 1470000,
        "revenue": 3780.00,
        "percentChange": {
          "streams": 28.7,
          "revenue": 27.9
        }
      }
    ],
    "timeSeries": {
      "intervals": [
        "2022-12-27",
        "2023-01-03",
        "2023-01-10",
        // More weeks...
        "2023-03-20"
      ],
      "streams": [
        176400,
        185220,
        194481,
        // More values...
        238920
      ],
      "revenue": [
        705.60,
        740.88,
        777.92,
        // More values...
        955.68
      ]
    },
    "topReleases": [
      {
        "id": "rel_12345",
        "title": "Summer Vibes",
        "streams": 3150000,
        "revenue": 12600.00,
        "percentChange": {
          "streams": 45.3,
          "revenue": 42.8
        }
      },
      {
        "id": "rel_12340",
        "title": "Winter Chill",
        "streams": 2100000,
        "revenue": 8400.00,
        "percentChange": {
          "streams": 25.3,
          "revenue": 22.8
        }
      }
    ],
    "topTracks": [
      {
        "id": "track_23456",
        "title": "Summer Begins",
        "release": "Summer Vibes",
        "streams": 1890000,
        "revenue": 7560.00,
        "percentChange": {
          "streams": 55.3,
          "revenue": 52.8
        }
      },
      {
        "id": "track_23457",
        "title": "Beach Party",
        "release": "Summer Vibes",
        "streams": 1260000,
        "revenue": 5040.00,
        "percentChange": {
          "streams": 35.3,
          "revenue": 32.8
        }
      },
      {
        "id": "track_23450",
        "title": "Snowfall",
        "release": "Winter Chill",
        "streams": 1050000,
        "revenue": 4200.00,
        "percentChange": {
          "streams": 30.3,
          "revenue": 28.8
        }
      }
    ]
  }
}
```

#### Get Catalog Overview

Retrieves performance analytics for the entire catalog.

**Request:**

```
GET /analytics/catalog?period=1y
```

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| period | string | Time period for analytics (7d, 30d, 90d, 1y, all) |
| platform | string | Filter by platform (optional) |
| territory | string | Filter by territory (optional) |

**Response:**

```json
{
  "status": "success",
  "data": {
    "period": "1y",
    "dateRange": {
      "from": "2022-03-27",
      "to": "2023-03-27"
    },
    "summary": {
      "totalStreams": 52500000,
      "totalRevenue": 210000.00,
      "percentChange": {
        "streams": 85.3,
        "revenue": 82.8
      },
      "totalReleases": 45,
      "totalTracks": 350,
      "totalArtists": 25
    },
    "platforms": [
      {
        "name": "Spotify",
        "streams": 31500000,
        "revenue": 126000.00,
        "percentChange": {
          "streams": 88.5,
          "revenue": 86.2
        }
      },
      {
        "name": "Apple Music",
        "streams": 12600000,
        "revenue": 63000.00,
        "percentChange": {
          "streams": 80.2,
          "revenue": 79.5
        }
      },
      {
        "name": "Amazon Music",
        "streams": 6300000,
        "revenue": 18900.00,
        "percentChange": {
          "streams": 82.1,
          "revenue": 80.8
        }
      },
      {
        "name": "Other",
        "streams": 2100000,
        "revenue": 2100.00,
        "percentChange": {
          "streams": 75.3,
          "revenue": 74.1
        }
      }
    ],
    "territories": [
      {
        "code": "US",
        "name": "United States",
        "streams": 21000000,
        "revenue": 105000.00,
        "percentChange": {
          "streams": 90.1,
          "revenue": 88.5
        }
      },
      {
        "code": "GB",
        "name": "United Kingdom",
        "streams": 10500000,
        "revenue": 42000.00,
        "percentChange": {
          "streams": 85.3,
          "revenue": 83.2
        }
      },
      {
        "code": "DE",
        "name": "Germany",
        "streams": 6300000,
        "revenue": 25200.00,
        "percentChange": {
          "streams": 82.5,
          "revenue": 81.8
        }
      },
      {
        "code": "OTHER",
        "name": "Other Countries",
        "streams": 14700000,
        "revenue": 37800.00,
        "percentChange": {
          "streams": 78.7,
          "revenue": 77.9
        }
      }
    ],
    "timeSeries": {
      "intervals": [
        "2022-04",
        "2022-05",
        "2022-06",
        // More months...
        "2023-03"
      ],
      "streams": [
        3150000,
        3307500,
        3472875,
        // More values...
        5250000
      ],
      "revenue": [
        12600.00,
        13230.00,
        13891.50,
        // More values...
        21000.00
      ]
    },
    "topReleases": [
      {
        "id": "rel_12345",
        "title": "Summer Vibes",
        "artist": "DJ Sunshine",
        "streams": 10500000,
        "revenue": 42000.00,
        "percentChange": {
          "streams": 95.3,
          "revenue": 92.8
        }
      },
      {
        "id": "rel_12340",
        "title": "Winter Chill",
        "artist": "DJ Sunshine",
        "streams": 7350000,
        "revenue": 29400.00,
        "percentChange": {
          "streams": 85.3,
          "revenue": 82.8
        }
      },
      {
        "id": "rel_12350",
        "title": "Midnight Dreams",
        "artist": "Night Owl",
        "streams": 5250000,
        "revenue": 21000.00,
        "percentChange": {
          "streams": 75.3,
          "revenue": 72.8
        }
      }
    ],
    "topArtists": [
      {
        "id": "artist_12345",
        "name": "DJ Sunshine",
        "streams": 17850000,
        "revenue": 71400.00,
        "percentChange": {
          "streams": 95.3,
          "revenue": 92.8
        }
      },
      {
        "id": "artist_12346",
        "name": "Night Owl",
        "streams": 10500000,
        "revenue": 42000.00,
        "percentChange": {
          "streams": 85.3,
          "revenue": 82.8
        }
      },
      {
        "id": "artist_12347",
        "name": "Melody Maker",
        "streams": 7350000,
        "revenue": 29400.00,
        "percentChange": {
          "streams": 75.3,
          "revenue": 72.8
        }
      }
    ],
    "genres": [
      {
        "name": "Electronic",
        "streams": 18375000,
        "revenue": 73500.00,
        "percentChange": {
          "streams": 95.3,
          "revenue": 92.8
        }
      },
      {
        "name": "Pop",
        "streams": 10500000,
        "revenue": 42000.00,
        "percentChange": {
          "streams": 85.3,
          "revenue": 82.8
        }
      },
      {
        "name": "Indie",
        "streams": 7350000,
        "revenue": 29400.00,
        "percentChange": {
          "streams": 75.3,
          "revenue": 72.8
        }
      }
    ]
  }
}
```

### WebHooks API

#### Get Webhooks

Retrieves the list of configured webhooks.

**Request:**

```
GET /webhooks
```

**Response:**

```json
{
  "status": "success",
  "data": [
    {
      "id": "webhook_12345",
      "url": "https://example.com/webhooks/tunemantra",
      "description": "Distribution status webhook",
      "events": [
        "distribution.status.changed",
        "distribution.delivery.complete",
        "distribution.takedown.complete"
      ],
      "status": "active",
      "createdAt": "2023-01-15T10:00:00Z",
      "updatedAt": "2023-01-15T10:00:00Z"
    },
    {
      "id": "webhook_12346",
      "url": "https://example.com/webhooks/royalties",
      "description": "Royalty statement webhook",
      "events": [
        "royalty.statement.generated",
        "royalty.payment.processed"
      ],
      "status": "active",
      "createdAt": "2023-02-20T14:30:00Z",
      "updatedAt": "2023-02-20T14:30:00Z"
    }
  ]
}
```

#### Create Webhook

Creates a new webhook subscription.

**Request:**

```
POST /webhooks
```

**Request Body:**

```json
{
  "url": "https://example.com/webhooks/analytics",
  "description": "Analytics update webhook",
  "events": [
    "analytics.daily.update",
    "analytics.release.milestone"
  ],
  "secret": "your_webhook_secret"
}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": "webhook_12347",
    "url": "https://example.com/webhooks/analytics",
    "description": "Analytics update webhook",
    "events": [
      "analytics.daily.update",
      "analytics.release.milestone"
    ],
    "status": "active",
    "createdAt": "2023-03-27T18:00:00Z",
    "updatedAt": "2023-03-27T18:00:00Z"
  }
}
```

#### Test Webhook

Sends a test event to a webhook endpoint.

**Request:**

```
POST /webhooks/{webhook_id}/test
```

**Request Body:**

```json
{
  "event": "analytics.daily.update"
}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": "webhook_test_12345",
    "webhook_id": "webhook_12347",
    "event": "analytics.daily.update",
    "sentAt": "2023-03-27T18:15:00Z",
    "status": "sent",
    "responseCode": 200,
    "responseBody": "Received"
  }
}
```

### Appendix

#### Event Types

The following event types are available for webhook subscriptions:

##### User Events
- `user.created` - A new user is created
- `user.updated` - User information is updated
- `user.deleted` - A user is deleted
- `user.login` - A user logs in

##### Organization Events
- `organization.created` - A new organization is created
- `organization.updated` - Organization information is updated
- `organization.deleted` - An organization is deleted

##### Content Events
- `content.release.created` - A new release is created
- `content.release.updated` - A release is updated
- `content.release.deleted` - A release is deleted
- `content.track.uploaded` - A track is uploaded
- `content.artwork.uploaded` - Artwork is uploaded
- `content.metadata.updated` - Metadata is updated

##### Distribution Events
- `distribution.scheduled` - Distribution is scheduled
- `distribution.started` - Distribution process started
- `distribution.status.changed` - Distribution status changed
- `distribution.delivery.complete` - Delivery to platform completed
- `distribution.takedown.requested` - Takedown requested
- `distribution.takedown.complete` - Takedown completed

##### Rights Events
- `rights.created` - A new rights record is created
- `rights.updated` - A rights record is updated
- `rights.deleted` - A rights record is deleted
- `rights.conflict.detected` - A rights conflict is detected
- `rights.conflict.resolved` - A rights conflict is resolved

##### Royalty Events
- `royalty.statement.generated` - A royalty statement is generated
- `royalty.statement.approved` - A royalty statement is approved
- `royalty.payment.scheduled` - A royalty payment is scheduled
- `royalty.payment.processed` - A royalty payment is processed

##### Analytics Events
- `analytics.daily.update` - Daily analytics update is available
- `analytics.release.milestone` - A release reaches a milestone
- `analytics.artist.milestone` - An artist reaches a milestone

#### Status Codes

Common status values used throughout the API:

##### Content Status
- `draft` - Initial creation, incomplete
- `pending` - Complete but awaiting approval
- `approved` - Approved and ready for distribution
- `scheduled` - Scheduled for distribution
- `processing` - Being processed for distribution
- `released` - Live on platforms
- `takedown` - Removed from platforms
- `rejected` - Rejected during approval process
- `error` - Error during processing

##### Distribution Status
- `not_started` - Distribution not yet started
- `scheduled` - Scheduled for future distribution
- `processing` - Distribution in progress
- `complete` - Distribution completed successfully
- `error` - Error during distribution
- `takedown` - Content takedown in progress
- `removed` - Content removed from platforms

##### Rights Status
- `pending` - Rights claim pending verification
- `active` - Rights claim active
- `expired` - Rights claim expired
- `disputed` - Rights claim under dispute
- `revoked` - Rights claim revoked

##### Royalty Status
- `processing` - Statement being generated
- `generated` - Statement generated
- `approved` - Statement approved for payment
- `scheduled` - Payment scheduled
- `paid` - Payment processed
- `disputed` - Statement under dispute

---

© 2023-2025 TuneMantra. All rights reserved.

*Source: /home/runner/workspace/.archive/archive_docs/documentation_backup_20250330/documentation/developer/api-reference.md*

---

## TuneMantra API Reference (7)

## TuneMantra API Reference

<div align="center">
  <img src="../diagrams/api-overview-diagram.svg" alt="TuneMantra API Overview" width="700" />
</div>

### Overview

The TuneMantra API provides a comprehensive set of endpoints for interacting with all aspects of the platform. This reference document covers authentication, request formats, response handling, error codes, and detailed specifications for each API endpoint.

### API Status

**Completion: 95.00% (Core Backend Services)**

| API Group | Status | Completion % |
|-----------|--------|--------------|
| Authentication | Complete | 100.00% |
| User Management | Complete | 100.00% |
| Content Management | Complete | 100.00% |
| Distribution | Complete | 100.00% |
| Rights Management | Near completion | 97.50% |
| Royalty Management | Complete | 100.00% |
| Analytics | Advanced development | 87.50% |
| Payment | Complete | 100.00% |
| Search | Complete | 100.00% |
| Webhooks | Near completion | 95.00% |

### Authentication

All API requests must be authenticated using JWT (JSON Web Tokens) or API keys.

#### Authentication Methods

##### JWT Authentication

For user-based interactions, use JWT authentication:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

JWT tokens are obtained by calling the `/api/auth/login` endpoint and are valid for 24 hours.

##### API Key Authentication

For service-to-service communication, use API key authentication:

```
X-API-Key: tm_a1b2c3d4e5f6g7h8i9j0...
```

API keys can be generated in the Admin Dashboard and have configurable permissions and expiration.

#### Obtaining a JWT Token

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

### API Request Format

#### Base URL

```
https://api.tunemantra.com/v1
```

#### Request Headers

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

#### Request Parameters

- **Path Parameters**: Part of the URL path (e.g., `/users/{userId}`)
- **Query Parameters**: Appended to the URL (e.g., `?page=1&limit=10`)
- **Request Body**: JSON payload for POST, PUT, and PATCH requests

### API Response Format

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

### Error Codes

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

### Core API Endpoints

#### User Management API

##### Get Current User

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

##### List Users

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

##### Create User

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

#### Content Management API

##### Get Release

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

##### Create Release

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

#### Distribution API

##### Get Distribution Status

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

##### Create Distribution

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

#### Rights Management API

##### Get Rights Information

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

##### Update Rights Holder

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

#### Royalty Management API

##### Get Royalty Overview

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

##### Get Detailed Royalty Statement

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

#### Analytics API

##### Get Performance Overview

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

##### Get Release Analytics

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

#### Payment API

##### Get Payment Methods

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

##### Create Payment Method

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

##### Get Withdrawal History

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

##### Request Withdrawal

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

### Webhook API

TuneMantra provides webhooks for real-time updates on various events.

#### Webhook Events

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

#### Webhook Payload Format

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

#### Register Webhook Endpoint

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

### API Rate Limits

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

### API Versioning

The TuneMantra API uses semantic versioning:

- Major version changes (e.g., v1 to v2) may include breaking changes
- Minor version updates are backward compatible
- Current API version: v1

Version is specified in the URL path: `/v1/resources`

### Best Practices

1. **Use Idempotency Keys**: For non-GET requests to prevent duplicate operations
2. **Implement Retry Logic**: With exponential backoff for 5xx errors
3. **Validate Webhook Signatures**: To ensure webhook authenticity
4. **Cache Authentication Tokens**: Until close to expiration to reduce authentication requests
5. **Use Compression**: Set `Accept-Encoding: gzip` for improved performance
6. **Include Request IDs**: In all API calls for easier troubleshooting
7. **Pagination**: Use limit and page parameters for large collections
8. **Filtering**: Use query parameters to filter results

### Development Resources

- **API Playground**: [https://api-playground.tunemantra.com](https://api-playground.tunemantra.com)
- **SDK Libraries**: [https://github.com/tunemantra/api-sdks](https://github.com/tunemantra/api-sdks)
- **API Status**: [https://status.tunemantra.com](https://status.tunemantra.com)

---

*For detailed implementation examples and code snippets, please refer to the [API Implementation Guide](../developer/api-implementation-guide.md).*

*Source: /home/runner/workspace/.archive/archive_docs/documentation_backup_20250330/documentation/new_structure/technical/api/api-reference.md*

---

## TuneMantra Core API Reference

## TuneMantra Core API Reference

This document provides a concise reference for the most important API endpoints in the TuneMantra platform.

### Authentication

#### User Login
- **URL**: `/api/auth/login`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "username": "string",
    "password": "string"
  }
  ```
- **Response**: User object with session cookie

#### User Registration
- **URL**: `/api/auth/register`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "username": "string",
    "email": "string",
    "password": "string",
    "name": "string",
    "role": "artist|label|distributor"
  }
  ```
- **Response**: User object with session cookie

#### API Key Authentication
- All API requests can use an API key with the `X-API-Key` header
- API keys are managed at `/api/api-keys`

### User Management

#### Get Current User
- **URL**: `/api/check-session`
- **Method**: `GET`
- **Response**: Current user object or unauthorized status

#### Get User Profile
- **URL**: `/api/users/:id`
- **Method**: `GET`
- **Response**: User profile data

#### Update User Profile
- **URL**: `/api/users/:id`
- **Method**: `PATCH`
- **Request Body**: User data fields to update
- **Response**: Updated user object

### Tracks API

#### Get Tracks
- **URL**: `/api/tracks`
- **Method**: `GET`
- **Query Parameters**:
  - `userId`: Filter by user (optional)
  - `releaseId`: Filter by release (optional)
  - `page`: Pagination page (optional)
  - `limit`: Items per page (optional)
- **Response**: Array of track objects

#### Create Track
- **URL**: `/api/tracks`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "title": "string",
    "artist": "string",
    "genre": "string",
    "releaseDate": "ISO date string",
    "audioFile": "file upload",
    "metadata": "JSON object"
  }
  ```
- **Response**: Created track object

#### Get Track by ID
- **URL**: `/api/tracks/:id`
- **Method**: `GET`
- **Response**: Track object

#### Update Track
- **URL**: `/api/tracks/:id`
- **Method**: `PATCH`
- **Request Body**: Track data fields to update
- **Response**: Updated track object

### Releases API

#### Get Releases
- **URL**: `/api/releases`
- **Method**: `GET`
- **Query Parameters**:
  - `userId`: Filter by user (optional)
  - `status`: Filter by status (optional)
  - `page`: Pagination page (optional)
  - `limit`: Items per page (optional)
- **Response**: Array of release objects

#### Create Release
- **URL**: `/api/releases`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "title": "string",
    "artist": "string",
    "type": "single|ep|album",
    "releaseDate": "ISO date string",
    "coverArt": "file upload",
    "trackIds": "array of track IDs"
  }
  ```
- **Response**: Created release object

#### Get Release by ID
- **URL**: `/api/releases/:id`
- **Method**: `GET`
- **Response**: Release object with tracks

### Distribution API

#### Distribute Release
- **URL**: `/api/distribution/distribute`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "releaseId": "number",
    "platformIds": "array of platform IDs"
  }
  ```
- **Response**: Distribution job status

#### Get Distribution Status
- **URL**: `/api/distribution/status/:releaseId`
- **Method**: `GET`
- **Response**: Distribution status data

#### Schedule Distribution
- **URL**: `/api/scheduled-distributions`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "releaseId": "number",
    "platformIds": "array of platform IDs",
    "scheduledDate": "ISO date string"
  }
  ```
- **Response**: Scheduled distribution object

### Analytics API

#### Get Track Analytics
- **URL**: `/api/analytics/track/:trackId`
- **Method**: `GET`
- **Query Parameters**:
  - `startDate`: Start date for analytics (optional)
  - `endDate`: End date for analytics (optional)
- **Response**: Track analytics data

#### Get Release Analytics
- **URL**: `/api/analytics/release/:releaseId`
- **Method**: `GET`
- **Query Parameters**:
  - `startDate`: Start date for analytics (optional)
  - `endDate`: End date for analytics (optional)
- **Response**: Release analytics data

#### Get User Analytics
- **URL**: `/api/analytics/user/:userId`
- **Method**: `GET`
- **Query Parameters**:
  - `startDate`: Start date for analytics (optional)
  - `endDate`: End date for analytics (optional)
- **Response**: User analytics data

### Royalty API

#### Get Royalty Calculations
- **URL**: `/api/royalties`
- **Method**: `GET`
- **Query Parameters**:
  - `trackId`: Filter by track (optional)
  - `releaseId`: Filter by release (optional)
  - `startDate`: Start date for calculations (optional)
  - `endDate`: End date for calculations (optional)
- **Response**: Royalty calculation data

#### Configure Royalty Splits
- **URL**: `/api/revenue-shares`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "releaseId": "number",
    "shares": [
      {
        "userId": "number",
        "sharePercentage": "number"
      }
    ]
  }
  ```
- **Response**: Revenue share configuration

### Payment API

#### Get Payment Methods
- **URL**: `/api/payment-methods`
- **Method**: `GET`
- **Response**: User's payment methods

#### Add Payment Method
- **URL**: `/api/payment-methods`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "type": "bank|paypal|stripe",
    "name": "string",
    "details": "JSON object with payment details"
  }
  ```
- **Response**: Created payment method

#### Request Withdrawal
- **URL**: `/api/withdrawals`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "amount": "number",
    "paymentMethodId": "number",
    "currency": "string"
  }
  ```
- **Response**: Withdrawal request status

### Admin API

#### Get All Users (Admin)
- **URL**: `/api/admin/users`
- **Method**: `GET`
- **Query Parameters**:
  - `status`: Filter by status (optional)
  - `role`: Filter by role (optional)
  - `search`: Search by name or email (optional)
  - `page`: Pagination page (optional)
  - `limit`: Items per page (optional)
- **Response**: Array of user objects

#### Update User Status (Admin)
- **URL**: `/api/admin/users/:id/status`
- **Method**: `PATCH`
- **Request Body**:
  ```json
  {
    "status": "active|pending|suspended"
  }
  ```
- **Response**: Updated user object

#### System Configuration (Admin)
- **URL**: `/api/admin/config`
- **Method**: `GET`|`PATCH`
- **Response**: System configuration data

*Source: /home/runner/workspace/.archive/archive_docs/essential_docs/api/core_api.md*

---

