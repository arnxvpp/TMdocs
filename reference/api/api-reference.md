# TuneMantra API Reference

*Version: 1.0.0 (March 27, 2025)*

## Table of Contents

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
- [Historical API Endpoints](endpoints/archive-endpoints-inventory.md)

## Introduction

The TuneMantra API provides programmatic access to the platform's functionality. This reference documents all available endpoints, request/response formats, and authentication requirements.

### Base URL

All API requests should be made to:

```
https://api.tunemantra.com/v1
```

### Request Format

All requests should be made with the appropriate HTTP method (GET, POST, PUT, DELETE) and include the required headers:

```
Content-Type: application/json
Authorization: Bearer {your_api_token}
```

### Response Format

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

## Authentication

### Obtaining API Credentials

To use the TuneMantra API, you must first obtain API credentials:

1. Log in to your TuneMantra account
2. Navigate to Settings > API Access
3. Click "Create API Key"
4. Configure the permissions for your API key
5. Store the API key securely

### Authentication Methods

The API supports two authentication methods:

#### Bearer Token Authentication

Include your API token in the Authorization header:

```
Authorization: Bearer {your_api_token}
```

#### OAuth 2.0 Authentication

For third-party applications, use OAuth 2.0:

1. Redirect users to `https://api.tunemantra.com/oauth/authorize`
2. User authorizes your application
3. User is redirected back with an authorization code
4. Exchange the code for an access token at `https://api.tunemantra.com/oauth/token`
5. Use the access token in API requests

## Error Handling

### Error Codes

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

### Error Response Format

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

## Rate Limiting

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

## API Versioning

### Version Format

The API version is included in the URL path:

```
https://api.tunemantra.com/v1/resource
```

### Version Support

- Major versions (v1, v2) may include breaking changes
- Minor versions are backward compatible
- Each major version is supported for 18 months after a new major version is released

## User API

### Get Current User

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

### List Users

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

### Create User

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

### Update User

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

### Delete User

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

## Organization API

### Get Organization

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

### List Organizations

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

### Create Organization

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

## Content API

### Get Release

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

### List Releases

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

### Create Release

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

## Distribution API

### Get Distribution Status

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

### Create Distribution

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

### Create Takedown

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

## Rights API

### Get Rights

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

### Create Rights

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

## Royalty API

### Get Royalty Statement

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

### List Royalty Statements

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

### Generate Royalty Statement

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

## Analytics API

### Get Release Performance

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

### Get Artist Performance

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

### Get Catalog Overview

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

## WebHooks API

### Get Webhooks

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

### Create Webhook

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

### Test Webhook

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

## Appendix

### Event Types

The following event types are available for webhook subscriptions:

#### User Events
- `user.created` - A new user is created
- `user.updated` - User information is updated
- `user.deleted` - A user is deleted
- `user.login` - A user logs in

#### Organization Events
- `organization.created` - A new organization is created
- `organization.updated` - Organization information is updated
- `organization.deleted` - An organization is deleted

#### Content Events
- `content.release.created` - A new release is created
- `content.release.updated` - A release is updated
- `content.release.deleted` - A release is deleted
- `content.track.uploaded` - A track is uploaded
- `content.artwork.uploaded` - Artwork is uploaded
- `content.metadata.updated` - Metadata is updated

#### Distribution Events
- `distribution.scheduled` - Distribution is scheduled
- `distribution.started` - Distribution process started
- `distribution.status.changed` - Distribution status changed
- `distribution.delivery.complete` - Delivery to platform completed
- `distribution.takedown.requested` - Takedown requested
- `distribution.takedown.complete` - Takedown completed

#### Rights Events
- `rights.created` - A new rights record is created
- `rights.updated` - A rights record is updated
- `rights.deleted` - A rights record is deleted
- `rights.conflict.detected` - A rights conflict is detected
- `rights.conflict.resolved` - A rights conflict is resolved

#### Royalty Events
- `royalty.statement.generated` - A royalty statement is generated
- `royalty.statement.approved` - A royalty statement is approved
- `royalty.payment.scheduled` - A royalty payment is scheduled
- `royalty.payment.processed` - A royalty payment is processed

#### Analytics Events
- `analytics.daily.update` - Daily analytics update is available
- `analytics.release.milestone` - A release reaches a milestone
- `analytics.artist.milestone` - An artist reaches a milestone

### Status Codes

Common status values used throughout the API:

#### Content Status
- `draft` - Initial creation, incomplete
- `pending` - Complete but awaiting approval
- `approved` - Approved and ready for distribution
- `scheduled` - Scheduled for distribution
- `processing` - Being processed for distribution
- `released` - Live on platforms
- `takedown` - Removed from platforms
- `rejected` - Rejected during approval process
- `error` - Error during processing

#### Distribution Status
- `not_started` - Distribution not yet started
- `scheduled` - Scheduled for future distribution
- `processing` - Distribution in progress
- `complete` - Distribution completed successfully
- `error` - Error during distribution
- `takedown` - Content takedown in progress
- `removed` - Content removed from platforms

#### Rights Status
- `pending` - Rights claim pending verification
- `active` - Rights claim active
- `expired` - Rights claim expired
- `disputed` - Rights claim under dispute
- `revoked` - Rights claim revoked

#### Royalty Status
- `processing` - Statement being generated
- `generated` - Statement generated
- `approved` - Statement approved for payment
- `scheduled` - Payment scheduled
- `paid` - Payment processed
- `disputed` - Statement under dispute

---

## Historical API Endpoints

A comprehensive inventory of historical API endpoints from various branches of TuneMantra development is available in the [Historical API Endpoints Inventory](endpoints/archive-endpoints-inventory.md).

This inventory provides valuable context for understanding the evolution of the TuneMantra API and includes endpoints that may have been consolidated or renamed in the current API structure.

---

© 2023-2025 TuneMantra. All rights reserved.