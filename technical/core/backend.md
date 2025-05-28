# Backend Architecture Documentation

## Overview

TuneMantra's backend is built on a Node.js/Express foundation, providing a robust API layer for the React frontend and other clients. The architecture follows modern best practices with a focus on type safety, modular design, and scalability.

## Architecture Principles

The backend follows these core principles:

1. **Type Safety**: TypeScript throughout the codebase with strict typing
2. **Separation of Concerns**: Clear boundaries between layers
3. **Dependency Injection**: Loose coupling between components
4. **Schema-First Design**: Database and API schemas as the source of truth
5. **Comprehensive Testing**: Testable architecture with high coverage
6. **Secure by Default**: Security built into the architecture

## System Components

### Server Core

The server core (`server/index.ts`) sets up the Express application with:

- CORS configuration
- Security middleware (Helmet)
- JSON request parsing
- Cookie parsing
- Static file serving
- Session management
- Error handling

### API Routes

API routes (`server/routes.ts`) define the RESTful endpoints:

- Authentication endpoints
- User management
- Content management (tracks, releases)
- Distribution management
- Analytics endpoints
- Royalty management

Routes follow a consistent pattern:
- Clear path structure
- Proper HTTP method usage
- Input validation
- Authentication/authorization checks
- Consistent response format

### Authentication System

The authentication system (`server/auth.ts`) provides:

- Session-based authentication
- Password security (hashing with scrypt)
- Login/logout functionality
- User registration
- Authorization middleware
- API key authentication

### Storage Layer

The storage layer (`server/storage.ts`) abstracts database operations:

- Implementation of the `IStorage` interface
- CRUD operations for all entity types
- Transaction management
- Query optimization
- Connection pooling

### Services

Specialized service modules implement complex business logic:

- **Distribution Service**: Handles music distribution to platforms
- **Analytics Service**: Processes and aggregates analytics data
- **Royalty Calculation Service**: Implements royalty calculation logic
- **AI Tagging Service**: Provides AI-powered content analysis
- **Integration Service**: Manages integrations with external systems

### Database Connection

Database connectivity (`server/db.ts`) manages PostgreSQL connections:

- Connection pool configuration
- WebSocket support for Neon Serverless
- Environment-based configuration
- Drizzle ORM initialization

### Utilities

Shared utility modules provide reusable functionality:

- **Validation**: Request validation and sanitization
- **Error Handling**: Standardized error handling
- **ID Generation**: Secure ID generation and validation
- **Permissions**: Permission checking and role management
- **File Handling**: File upload and processing utilities

## Data Flow

### Request Lifecycle

1. **Request Arrival**: Client sends HTTP request to API endpoint
2. **Middleware Processing**:
   - Security headers applied
   - Session validation
   - CORS checks
   - Rate limiting
3. **Route Handling**:
   - Endpoint matched
   - Authentication/authorization checks
   - Input validation
4. **Business Logic**:
   - Service layer processes request
   - Storage layer executes database operations
5. **Response Generation**:
   - Standardized response format
   - Error handling if needed
   - Response sent to client

### Data Access Pattern

1. **API Layer**: Routes receive and validate requests
2. **Service Layer**: Implements business logic
3. **Storage Layer**: Executes database operations
4. **Database**: Stores and retrieves persistent data

## Code Organization

The backend code is organized into the following structure:

```
server/
├── config/          # Configuration files
├── lib/             # Shared libraries
├── middleware/      # Express middleware
├── routes/          # API routes
├── services/        # Business logic services
├── utils/           # Utility functions
├── auth.ts          # Authentication system
├── db.ts            # Database connection
├── index.ts         # Server entry point
├── routes.ts        # Route registration
├── storage.ts       # Data storage interface
├── types.ts         # TypeScript type definitions
└── vite.ts          # Development server configuration
```

## Key Interfaces

### IStorage Interface

The `IStorage` interface (`server/types.ts`) defines the contract for all data storage operations:

```typescript
export interface IStorage {
  sessionStore: session.Store;

  // User management methods
  getAllUsers(options?: {...}): Promise<User[]>;
  getUser(id: number): Promise<User | undefined>;
  // ... more user methods

  // Track management methods
  getTracksByUserId(userId: number): Promise<Track[]>;
  getTrackById(id: number): Promise<Track | undefined>;
  // ... more track methods

  // Release management methods
  getReleasesByUserId(userId: number): Promise<Release[]>;
  createRelease(userId: number, release: InsertRelease): Promise<Release>;
  // ... more release methods

  // Distribution methods
  getDistributionPlatforms(): Promise<DistributionPlatform[]>;
  createDistributionRecord(record: InsertDistributionRecord): Promise<DistributionRecord>;
  // ... more distribution methods

  // Analytics methods
  getTrackAnalytics(trackId: number): Promise<Analytics[]>;
  createAnalytics(analyticsData: InsertAnalytics): Promise<Analytics>;
  // ... more analytics methods

  // Royalty management methods
  getRoyaltyCalculations(userId: number): Promise<RoyaltyCalculation[]>;
  createRoyaltyCalculation(calculation: InsertRoyaltyCalculation): Promise<RoyaltyCalculation>;
  // ... more royalty methods
}
```

### Service Interfaces

Each service module implements a specific interface focused on its domain:

```typescript
// Example: Distribution Service Interface
interface IDistributionService {
  distributeRelease(releaseId: number, platformIds: number[]): Promise<DistributionRecord[]>;
  distributeToPlatform(releaseId: number, platformId: number): Promise<DistributionRecord>;
  processDistribution(distributionId: number): Promise<boolean>;
  getDistributionStatus(releaseId: number): Promise<DistributionStatus[]>;
  cancelDistribution(distributionId: number): Promise<boolean>;
  scheduleDistribution(releaseId: number, platformIds: number[], scheduleDate: Date): Promise<ScheduledDistribution>;
}
```

## Authentication Flow

### Session-Based Authentication

1. User submits login credentials
2. Server validates credentials
3. On success, creates session with user ID
4. Session ID stored in cookie
5. Subsequent requests include cookie for authentication

```typescript
// Login endpoint implementation
app.post('/api/auth/login', (req, res, next) => {
  passport.authenticate('local', (err, user, info) => {
    if (err) return next(err);
    if (!user) {
      return res.status(401).json({
        error: {
          message: info.message || 'Invalid credentials',
          code: 'INVALID_CREDENTIALS'
        }
      });
    }
    req.login(user, (err) => {
      if (err) return next(err);
      return res.json({ data: sanitizeUser(user), meta: {} });
    });
  })(req, res, next);
});
```

### API Key Authentication

1. Client includes API key in Authorization header
2. Server validates API key against database
3. Server checks key permissions against requested operation
4. On validation, request proceeds with associated user context

```typescript
// API key authentication middleware
const apiKeyAuth = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      error: {
        message: 'API key required',
        code: 'AUTH_REQUIRED'
      }
    });
  }

  const apiKey = authHeader.split(' ')[1];
  try {
    const keyData = await storage.getApiKeyByValue(apiKey);
    if (!keyData || !keyData.isActive) {
      return res.status(401).json({
        error: {
          message: 'Invalid API key',
          code: 'INVALID_API_KEY'
        }
      });
    }

    // Check if key has required scope
    if (req.requiredScope && !keyData.scopes.includes(req.requiredScope)) {
      return res.status(403).json({
        error: {
          message: 'Insufficient permissions',
          code: 'INSUFFICIENT_SCOPE'
        }
      });
    }

    // Set user context
    req.userId = keyData.userId;
    req.apiKey = keyData;
    next();
  } catch (error) {
    next(error);
  }
};
```

## Error Handling

The backend implements a standardized error handling approach:

1. **Custom Error Types**: Defined for different error scenarios
2. **Global Error Handler**: Catches and formats all errors
3. **Consistent Response Format**: All errors follow the same structure
4. **Error Logging**: Comprehensive error logging for troubleshooting

```typescript
// Global error handler
app.use((err: any, _req: Request, res: Response, _next: NextFunction) => {
  // Log error
  console.error(`[ERROR] ${new Date().toISOString()}:`, {
    message: err.message,
    stack: process.env.NODE_ENV !== 'production' ? err.stack : undefined,
    code: err.code
  });

  // Send standardized response
  res.status(err.status || 500).json({
    data: null,
    meta: {},
    error: {
      message: err.message || 'An unexpected error occurred',
      code: err.code || 'INTERNAL_ERROR',
      details: err.details || undefined
    }
  });
});
```

## Database Access

### Drizzle ORM Integration

The backend uses Drizzle ORM for type-safe database access:

1. **Schema Definition**: Schemas defined in `shared/schema.ts`
2. **Type Generation**: TypeScript types generated from schema
3. **Query Building**: Type-safe query construction
4. **Migrations**: Schema migration through Drizzle Kit

```typescript
// Example Drizzle ORM usage
export async function getUserByUsername(username: string): Promise<User | undefined> {
  const result = await db.select().from(schema.users).where(eq(schema.users.username, username)).limit(1);
  return result[0];
}

export async function createUser(insertUser: InsertUser): Promise<User> {
  if (insertUser.password) {
    insertUser.password = await hashPassword(insertUser.password);
  }
  
  const [result] = await db.insert(schema.users).values({
    ...insertUser,
    createdAt: new Date(),
    updatedAt: new Date()
  }).returning();
  
  return result;
}
```

### Connection Pooling

The backend uses connection pooling for efficient database access:

```typescript
// Connection pool configuration
export const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  max: 20,                 // Maximum connections in pool
  idleTimeoutMillis: 30000, // Close idle connections after 30s
  connectionTimeoutMillis: 2000, // Connection timeout
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

// Initialize Drizzle with the connection pool
export const db = drizzle({ client: pool, schema });
```

## Middleware Components

The backend uses various middleware components:

### Authentication Middleware

```typescript
export const requireAuth = (req: Request, res: Response, next: NextFunction) => {
  if (!req.isAuthenticated() || !req.user) {
    return res.status(401).json({
      error: {
        message: 'Authentication required',
        code: 'AUTH_REQUIRED'
      }
    });
  }
  
  req.userId = req.user.id;
  next();
};
```

### Validation Middleware

```typescript
export function validateRequest(schema: z.ZodType<any>, source: 'body' | 'query' | 'params' = 'body') {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      const data = schema.parse(req[source]);
      req[source] = data; // Replace with validated data
      next();
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({
          error: {
            message: 'Validation error',
            code: 'VALIDATION_ERROR',
            details: error.errors
          }
        });
      }
      next(error);
    }
  };
}
```

### Rate Limiting Middleware

```typescript
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  standardHeaders: true,
  message: {
    error: {
      message: 'Too many requests, please try again later',
      code: 'RATE_LIMIT_EXCEEDED'
    }
  }
});

app.use('/api/', apiLimiter);
```

## Service Implementation Patterns

### Singleton Services

Most services are implemented as static classes:

```typescript
export class AnalyticsService {
  static async getTrackAnalytics(trackId: number, startDate?: Date, endDate?: Date) {
    // Implementation
  }
  
  static async getReleaseAnalytics(releaseId: number, startDate?: Date, endDate?: Date) {
    // Implementation
  }
  
  // More methods...
}
```

### Dependency Injection

Some services use dependency injection for testing:

```typescript
export class RoyaltyService {
  private storage: IStorage;
  private analyticsService: IAnalyticsService;
  
  constructor(storage: IStorage, analyticsService: IAnalyticsService) {
    this.storage = storage;
    this.analyticsService = analyticsService;
  }
  
  async calculateRoyalties(trackId: number, period: string) {
    const analytics = await this.analyticsService.getTrackAnalytics(trackId);
    // Implementation using this.storage and analytics
  }
  
  // More methods...
}
```

## Performance Considerations

The backend implements several performance optimizations:

### Query Optimization

- Use of appropriate indexes
- Pagination for large result sets
- Selection of only needed fields
- Query parameterization

```typescript
// Example of optimized query with pagination
async function getAllUsers({ 
  status, 
  search,
  page = 1,
  limit = 20
}: { 
  status?: string; 
  search?: string;
  page?: number;
  limit?: number;
}): Promise<User[]> {
  let query = db.select().from(schema.users);
  
  if (status) {
    query = query.where(eq(schema.users.status, status));
  }
  
  if (search) {
    query = query.where(
      or(
        like(schema.users.username, `%${search}%`),
        like(schema.users.email, `%${search}%`),
        like(schema.users.fullName, `%${search}%`)
      )
    );
  }
  
  // Apply pagination
  const offset = (page - 1) * limit;
  query = query.limit(limit).offset(offset);
  
  return await query;
}
```

### Caching Strategies

- In-memory caching for frequently accessed data
- Cache invalidation on update operations
- TTL-based cache expiration

```typescript
// Example of caching implementation
const cache = new Map<string, { data: any, expiry: number }>();

async function getCachedData(key: string, ttlMs: number, fetchFn: () => Promise<any>) {
  const now = Date.now();
  const cached = cache.get(key);
  
  if (cached && cached.expiry > now) {
    return cached.data;
  }
  
  const data = await fetchFn();
  cache.set(key, { data, expiry: now + ttlMs });
  return data;
}

// Usage
async function getDistributionPlatforms() {
  return getCachedData(
    'distribution_platforms',
    1000 * 60 * 60, // 1 hour TTL
    () => db.select().from(schema.distributionPlatforms)
  );
}
```

### Batch Processing

- Batch operations for multiple database updates
- Background job processing for long-running tasks
- Chunked processing for large datasets

```typescript
// Example of batch processing
async function processBulkDistributionJob(jobId: number) {
  const job = await storage.getBulkDistributionJobById(jobId);
  const platforms = await storage.getDistributionPlatforms();
  
  // Update job status
  await storage.updateBulkDistributionJob(jobId, { status: 'processing' });
  
  try {
    // Process in chunks to avoid memory issues
    const releases = await storage.getReleasesByIds(job.releaseIds);
    const chunkSize = 10;
    
    for (let i = 0; i < releases.length; i += chunkSize) {
      const chunk = releases.slice(i, i + chunkSize);
      
      // Process chunk in parallel
      await Promise.all(chunk.map(async (release) => {
        for (const platformId of job.platformIds) {
          const platform = platforms.find(p => p.id === platformId);
          if (!platform) continue;
          
          try {
            await storage.createDistributionRecord({
              releaseId: release.id,
              platformId,
              status: 'pending',
              createdAt: new Date(),
              updatedAt: new Date()
            });
            
            // Update platform status
            await storage.updateBulkDistributionJobPlatformStatus(
              jobId, 
              platformId, 
              'processing', 
              { releaseId: release.id }
            );
            
            // Actual distribution process
            await distributionService.processDistribution(release.id, platformId);
            
            // Update success status
            await storage.updateBulkDistributionJobPlatformStatus(
              jobId, 
              platformId, 
              'completed', 
              { releaseId: release.id }
            );
          } catch (error) {
            // Log error and update status
            console.error(`Distribution error for release ${release.id} to platform ${platformId}:`, error);
            await storage.updateBulkDistributionJobPlatformStatus(
              jobId, 
              platformId, 
              'failed', 
              { 
                releaseId: release.id, 
                error: error.message 
              }
            );
          }
        }
      }));
    }
    
    // Update job completion
    await storage.updateBulkDistributionJob(jobId, { 
      status: 'completed',
      completedAt: new Date()
    });
  } catch (error) {
    // Handle overall job failure
    console.error(`Bulk distribution job ${jobId} failed:`, error);
    await storage.updateBulkDistributionJob(jobId, { 
      status: 'failed',
      error: error.message
    });
  }
}
```

## Security Implementation

The backend implements multiple security measures:

### Input Validation

All user input is validated using Zod schemas:

```typescript
export const insertUserSchema = createInsertSchema(users)
  .extend({
    password: z.string().min(8).max(100),
    confirmPassword: z.string().min(8).max(100)
  })
  .refine(data => data.password === data.confirmPassword, {
    message: "Passwords don't match",
    path: ["confirmPassword"]
  });
```

### Authentication Security

Secure password hashing and verification:

```typescript
export async function hashPassword(password: string): Promise<string> {
  const salt = randomBytes(16).toString('hex');
  const hash = await scryptAsync(password, salt, 64);
  return `${hash.toString('hex')}.${salt}`;
}

async function comparePasswords(supplied: string, stored: string): Promise<boolean> {
  const [hash, salt] = stored.split('.');
  const suppliedHash = await scryptAsync(supplied, salt, 64);
  return timingSafeEqual(
    Buffer.from(hash, 'hex'),
    suppliedHash
  );
}
```

### API Security

- HTTPS enforcement
- CORS configuration
- Rate limiting
- Content Security Policy

```typescript
// Security middleware configuration
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      connectSrc: ["'self'", "https://api.example.com"],
      scriptSrc: ["'self'", "'unsafe-inline'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "https://assets.example.com"],
      fontSrc: ["'self'", "https://fonts.googleapis.com"],
    }
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  }
}));
```

## Testing Approach

The backend is designed for comprehensive testing:

### Unit Testing

- Testing individual functions and methods
- Mocking dependencies
- Testing edge cases and error handling

```typescript
// Example unit test
describe('hashPassword', () => {
  it('should hash a password', async () => {
    const password = 'securePassword123';
    const hashedPassword = await hashPassword(password);
    
    expect(hashedPassword).not.toBe(password);
    expect(hashedPassword).toContain('.');
    
    const parts = hashedPassword.split('.');
    expect(parts).toHaveLength(2);
  });
});
```

### Integration Testing

- Testing API endpoints
- Testing database interactions
- Testing service integrations

```typescript
// Example integration test
describe('User API', () => {
  beforeAll(async () => {
    await setupTestDatabase();
  });
  
  afterAll(async () => {
    await teardownTestDatabase();
  });
  
  it('should create a new user', async () => {
    const response = await request(app)
      .post('/api/auth/register')
      .send({
        username: 'testuser',
        password: 'password123',
        confirmPassword: 'password123',
        email: 'test@example.com',
        fullName: 'Test User'
      });
    
    expect(response.status).toBe(200);
    expect(response.body.data).toHaveProperty('id');
    expect(response.body.data.username).toBe('testuser');
  });
});
```

## External Integrations

The backend integrates with various external systems:

### Music Streaming Platforms

- API-based integrations with major streaming services
- Platform-specific authentication
- Content delivery protocols
- Response handling and error management

### Payment Processors

- Integration with payment gateways
- Secure handling of payment information
- Transaction processing and verification
- Refund and chargeback handling

### Analytics Services

- Data exchange with analytics providers
- ETL processes for data consolidation
- Reporting API integration
- Custom metrics tracking

## Deployment Considerations

The backend is designed for flexible deployment:

### Environment Configuration

- Environment-specific settings through `.env` files
- Validation of required environment variables
- Default values for optional settings
- Secrets management

### Scaling Strategy

- Stateless design for horizontal scaling
- Connection pooling for database efficiency
- Caching for reduced database load
- Background job processing for long-running tasks

### Monitoring

- Structured logging for observability
- Performance metrics collection
- Error tracking and alerting
- Health check endpoints

## Conclusion

TuneMantra's backend architecture provides a solid foundation for the platform with its focus on type safety, modular design, and scalability. The clear separation of concerns, comprehensive testing approach, and attention to security make it robust and maintainable.

The architecture balances flexibility and structure, allowing for future growth while maintaining consistency throughout the codebase. The use of TypeScript and Drizzle ORM provides strong guarantees about data types and database interactions, reducing the risk of runtime errors.

By following this architecture documentation, developers can understand the system's design, extend its functionality, and maintain its performance and security characteristics.