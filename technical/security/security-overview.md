# Security Implementation Documentation

## Overview

The TuneMantra platform implements a comprehensive security strategy to protect user data, intellectual property, and financial information. This document outlines the security measures implemented across the application stack.

## Authentication and Authorization

### Authentication Mechanisms

1. **Session-based Authentication**
   - Uses Express-session with PostgreSQL session store
   - Sessions are persistent across server restarts
   - Session cookies are HttpOnly to prevent JavaScript access
   - Session expiration is enforced (30 days by default)

2. **Password Security**
   - Password hashing using scrypt (cryptographically secure key derivation function)
   - Salt generation for each password to prevent rainbow table attacks
   - Support for BCrypt format for legacy compatibility
   - Secure password comparison to prevent timing attacks

3. **API Key Authentication**
   - Unique API keys for programmatic access
   - Keys are scoped to specific permissions
   - Keys can be rotated and revoked by users
   - Key expiration can be set for time-limited access

### Authorization Systems

1. **Role-Based Access Control (RBAC)**
   - User roles include: admin, label, artist_manager, artist, team_member
   - Each role has predefined permissions
   - Routes are protected based on role requirements

2. **Permission System**
   - Fine-grained permissions beyond role-based access
   - Custom permission templates can be created and assigned
   - Permissions are stored as JSON and validated on requests

3. **Multi-tenant Isolation**
   - Users can only access their own resources
   - Label owners can access their artists' resources
   - Artist managers can access their managed artists' resources

4. **Middleware Protection**
   - `requireAuth` middleware ensures authentication
   - Role-specific middlewares (e.g., `requireAdmin`)
   - Resource ownership validation middleware

## Data Security

### Database Security

1. **Connection Security**
   - PostgreSQL connection over SSL/TLS
   - Connection pooling for secure reuse
   - Environment variable-based configuration

2. **Query Security**
   - Parameterized queries to prevent SQL injection
   - Type-safe queries using Drizzle ORM
   - Input validation before database operations

3. **Sensitive Data Storage**
   - Passwords are hashed, never stored in plaintext
   - Payment details are encrypted or tokenized
   - API credentials are stored securely

### API Security

1. **Input Validation**
   - Zod schema validation for all inputs
   - Validation middleware for routes
   - File upload validation for size and type

2. **Output Sanitization**
   - Sensitive fields are removed from responses
   - Data is filtered based on user permissions
   - XSS prevention in API responses

3. **HTTP Security Headers**
   - Content-Security-Policy
   - X-Content-Type-Options
   - X-Frame-Options
   - Referrer-Policy
   - Implemented using Helmet.js

## Network Security

1. **HTTPS Enforcement**
   - All production traffic uses HTTPS
   - HSTS headers for secure connection enforcement
   - Secure cookie settings in production

2. **Rate Limiting**
   - API rate limiting to prevent brute force and DoS attacks
   - IP-based and user-based rate limits
   - Increasing backoff for repeated failures

3. **CORS Policy**
   - Restrictive CORS policy for API endpoints
   - Allows only trusted origins in production
   - Credentials allowed only from trusted origins

## Audit and Logging

1. **Activity Logging**
   - User login/logout events
   - Critical data modifications
   - API key usage tracking
   - Admin actions logging

2. **Audit Trails**
   - `subLabelAuditLogs` table tracks sub-label changes
   - Captures who made changes and what was changed
   - Stores previous and new values for comparison

3. **Error Logging**
   - Structured error logging
   - Stack traces in development only
   - Client-safe error messages in production

## Vulnerability Prevention

1. **Dependency Security**
   - Regular updates of dependencies
   - Security vulnerability scanning
   - Minimal dependency approach

2. **XSS Prevention**
   - Content security policy configuration
   - Input sanitization and validation
   - React's built-in XSS protection
   - XSS filtering library for user content

3. **CSRF Protection**
   - CSRF token validation for state-changing operations
   - SameSite cookie settings
   - Origin verification

4. **Injection Prevention**
   - SQL injection prevention through parameterized queries
   - NoSQL injection prevention in JSON operations
   - Command injection prevention in system calls

## File Upload Security

1. **File Validation**
   - File type validation based on content (MIME) type
   - Size limits for different file types
   - Maximum file count per user

2. **Storage Security**
   - Files stored outside the web root
   - Randomized filenames to prevent guessing
   - Validation before serving files

3. **Content Scanning**
   - Malware scanning for uploaded files
   - Audio file validation for music tracks
   - Image safety verification

## Financial Security

1. **Payment Processing**
   - Integration with secure payment providers
   - PCI compliance considerations
   - Tokenization of payment methods

2. **Royalty Calculations**
   - Audit trails for all royalty calculations
   - Transparent split payments with verification
   - Multi-step approval for large payments

3. **Withdrawal Security**
   - Verification steps for withdrawal requests
   - Limits and thresholds to prevent fraud
   - Notification of withdrawal events

## Infrastructure Security

1. **Deployment Security**
   - Secure environment variable management
   - Production vs. development configuration
   - Database migration safety

2. **Server Configuration**
   - Restrictive file permissions
   - Principle of least privilege
   - Regular security updates

3. **Monitoring**
   - Error rate monitoring
   - Authentication failure monitoring
   - Unusual traffic patterns detection

## Security Disclosure Policy

TuneMantra has an established security disclosure policy:

1. **Vulnerability Reporting**
   - Secure channel for reporting vulnerabilities
   - Responsible disclosure timeline
   - Recognition for security researchers

2. **Incident Response**
   - Documented incident response plan
   - User notification procedures
   - Post-incident analysis process

3. **Regular Security Reviews**
   - Periodic security audits
   - Penetration testing
   - Code review for security issues

## Implementation Examples

### Password Hashing Implementation

```typescript
// Hash a password for secure storage
export async function hashPassword(password: string): Promise<string> {
  // Generate a random salt
  const salt = randomBytes(16).toString('hex');
  
  // Hash the password with the salt using scrypt
  const hash = await scryptAsync(password, salt, 64);
  
  // Return the hash and salt combined as a single string
  return `${hash.toString('hex')}.${salt}`;
}

// Compare a supplied password with a stored hashed password
async function comparePasswords(supplied: string, stored: string): Promise<boolean> {
  // Handle multiple password formats
  
  // Format: "hashed.salt" (scrypt)
  if (stored.includes('.')) {
    const [hashedPassword, salt] = stored.split('.');
    const suppliedHash = await scryptAsync(supplied, salt, 64);
    return timingSafeEqual(
      Buffer.from(hashedPassword, 'hex'),
      suppliedHash
    );
  }
  
  // Format: "salt:hashed" (legacy)
  if (stored.includes(':')) {
    const [salt, hashedPassword] = stored.split(':');
    const suppliedHash = await scryptAsync(supplied, salt, 64);
    return timingSafeEqual(
      Buffer.from(hashedPassword, 'hex'),
      suppliedHash
    );
  }
  
  // Format: "$2b$..." (bcrypt)
  if (stored.startsWith('$2b$')) {
    return bcrypt.compare(supplied, stored);
  }
  
  // Unknown format
  return false;
}
```

### Authentication Middleware

```typescript
// Authentication middleware for protected routes
export const requireAuth = (req: Request, res: Response, next: NextFunction) => {
  // Check if user is authenticated via session
  if (!req.isAuthenticated() || !req.user) {
    return res.status(401).json({
      error: {
        message: 'Authentication required',
        code: 'AUTH_REQUIRED'
      }
    });
  }

  // Perform safety checks on the user object
  if (!req.user.id) {
    return res.status(401).json({
      error: {
        message: 'Invalid user session',
        code: 'INVALID_SESSION'
      }
    });
  }

  // Set userId for convenience in route handlers
  req.userId = req.user.id;

  // Enforce access restrictions based on account status
  if (req.user.status === 'suspended') {
    return res.status(403).json({
      error: {
        message: 'Your account has been suspended',
        code: 'ACCOUNT_SUSPENDED'
      }
    });
  }

  // Check if payment approval is pending
  if (req.user.status === 'pending_approval') {
    return res.status(402).json({
      error: {
        message: 'Your account is pending payment approval',
        code: 'PAYMENT_REQUIRED'
      }
    });
  }

  // Account is valid, proceed to the next middleware
  next();
};
```

### API Rate Limiting Configuration

```typescript
// Configure rate limiting
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  standardHeaders: true, // Return rate limit info in the `RateLimit-*` headers
  legacyHeaders: false, // Disable the `X-RateLimit-*` headers
  message: {
    error: {
      message: 'Too many requests, please try again later',
      code: 'RATE_LIMIT_EXCEEDED'
    }
  }
});

// Higher limits for authenticated users
const authenticatedLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 300, // higher limit for authenticated users
  standardHeaders: true,
  legacyHeaders: false,
  // Skip rate limiting for certain IPs or special users
  skip: (req, res) => req.user?.role === 'admin',
  message: {
    error: {
      message: 'Too many requests, please try again later',
      code: 'RATE_LIMIT_EXCEEDED'
    }
  }
});

// Apply rate limiting to routes
app.use('/api/', apiLimiter);
app.use('/api/auth/', authLimiter);
app.use('/api/users/', authenticatedLimiter);
```

## Security Best Practices for Developers

1. **Authentication**
   - Always use the provided authentication middlewares
   - Never store sensitive credentials in code or logs
   - Implement proper session invalidation on logout

2. **Data Protection**
   - Always validate user input using Zod schemas
   - Use parameterized queries for database access
   - Follow the principle of least privilege for data access

3. **Error Handling**
   - Use structured error handling
   - Do not expose sensitive information in error messages
   - Log security-relevant errors appropriately

4. **Frontend Security**
   - Implement proper authentication state management
   - Sanitize user-generated content before rendering
   - Use HTTPS for all API requests

5. **API Development**
   - Apply proper authentication checks to all endpoints
   - Implement rate limiting for public endpoints
   - Validate ownership of resources in all operations