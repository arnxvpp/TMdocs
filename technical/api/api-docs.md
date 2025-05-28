# API Documentation

## Overview

TuneMantra's API is built as a RESTful service using Node.js and Express. The API provides endpoints for managing users, tracks, releases, distribution, royalties, and analytics. This documentation outlines the available endpoints, request/response formats, and authentication requirements.

## Base URL

All API endpoints are relative to the base URL of your TuneMantra instance:

- Development: `http://localhost:5000/api`
- Production: `https://your-tunemantra-instance.replit.app/api`

## Authentication

Most API endpoints require authentication. TuneMantra uses session-based authentication for the web interface and API key authentication for programmatic access.

### Session Authentication

For browser-based interactions, authentication is managed through cookies and sessions:

1. **Login**: `POST /api/auth/login`
2. **Check Status**: `GET /api/auth/status`
3. **Logout**: `POST /api/auth/logout`

### API Key Authentication

For programmatic access, authentication is managed through API keys:

1. API keys are passed in the `Authorization` header as `Bearer {api_key}`
2. Each API key has specific scopes that limit what operations can be performed
3. API keys can be created, managed, and revoked through the API access endpoints

## Common Response Format

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

## API Endpoints

### Authentication Endpoints

#### Login

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

#### Register

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

#### Check Authentication Status

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

#### Logout

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

### User Management Endpoints

#### List Users

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

#### Get User by ID

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

#### Update User

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

### API Key Management

#### List API Keys

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

#### Create API Key

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

#### Delete API Key

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

### Track Management

#### List Tracks by User

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

#### Get Track by ID

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

#### Create Track

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

#### Update Track

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

### Release Management

#### List Releases by User

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

#### Get Release by ID

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

#### Create Release

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

#### Update Release

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

### Distribution Management

#### List Distribution Platforms

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

#### Distribute Release

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

#### Get Distribution Status

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

### Analytics Management

#### Get Track Analytics

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

#### Get Release Analytics

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

#### Get Dashboard Analytics

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

### Royalty Management

#### List Royalty Calculations

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

#### Process Royalty Calculation

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

#### Get Royalty Splits for Release

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

#### Update Royalty Splits

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

### Payment Management

#### List Payment Methods

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

#### Create Payment Method

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

#### List Withdrawals

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

#### Create Withdrawal Request

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

## Error Codes

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

## Pagination

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

## Filtering and Sorting

Many list endpoints support filtering and sorting through query parameters:

- `sort`: Field to sort by (e.g., `createdAt`)
- `order`: Sort order (`asc` or `desc`)
- `status`: Filter by status
- `search`: Search term for text fields
- `startDate`: Filter by date range start
- `endDate`: Filter by date range end

## Rate Limiting

The API implements rate limiting to prevent abuse:

- Rate limits are applied per user/API key
- Limits are higher for authenticated users than anonymous requests
- When rate limited, the API returns a 429 Too Many Requests status with a Retry-After header

## Webhook Notifications

TuneMantra supports webhooks for real-time notifications of events:

- Distribution status changes
- Royalty calculation completions
- New analytics data available
- Payment status updates

Webhooks can be configured in the user settings or via the API.