# Deployment Guide

## Overview

This guide covers the deployment process for the TuneMantra platform. TuneMantra is designed to be deployed in various environments, but this guide focuses on deployment with Replit, which provides a straightforward and scalable hosting solution.

## Prerequisites

Before deploying TuneMantra, ensure you have:

1. A Replit account with access to the TuneMantra repository
2. A PostgreSQL database (Neon serverless PostgreSQL recommended)
3. Required environment variables and secrets
4. Access to any third-party services needed (e.g., payment processing, file storage)

## Environment Variables

TuneMantra requires several environment variables to function properly. Set these in your Replit environment:

### Required Variables

```
# Database Connection
DATABASE_URL=postgresql://username:password@hostname:port/database

# Session Management
SESSION_SECRET=your-secure-session-secret

# Admin Access
SUPER_ADMIN_CODE=your-super-admin-registration-code

# API Security
API_KEY_SECRET=your-api-key-encryption-secret
```

### Optional Variables

```
# Environment Configuration
NODE_ENV=production

# Port Configuration (defaults to 5000)
PORT=5000

# External Services
PAYMENT_GATEWAY_API_KEY=your-payment-gateway-key
STORAGE_API_KEY=your-storage-service-key
AI_SERVICE_API_KEY=your-ai-service-key
```

## Deployment Steps

### 1. Prepare for Deployment

Before deploying, ensure your code is ready for production:

1. Run linters and type-checking:
   ```bash
   npm run check
   ```

2. Test the build process locally:
   ```bash
   npm run build
   ```

3. Make sure all dependencies are correctly listed in `package.json`

### 2. Deploy to Replit

Replit provides a simple deployment process:

1. Push your code to the Replit repository

2. In the Replit interface, navigate to the "Deployment" tab

3. Configure deployment settings:
   - Build command: `npm run build`
   - Run command: `npm run start`
   - Environment variables: Add all required variables

4. Click "Deploy" to start the deployment process

### 3. Monitor Deployment

1. Replit will show the build and deployment progress

2. If the build fails, check the logs for errors:
   - Common issues include missing dependencies or environment variables
   - TypeScript errors that weren't caught during development

3. Once deployed, Replit will provide a public URL for your application

### 4. Post-Deployment Configuration

After successful deployment, complete these additional steps:

1. **Create Super Admin Account**:
   - Navigate to `/super-admin/register`
   - Use the `SUPER_ADMIN_CODE` value to register the first admin account

2. **Configure Platforms**:
   - Login as the super admin
   - Navigate to the admin dashboard
   - Set up distribution platforms and their API credentials

3. **Verify Storage Access**:
   - Test file uploads to ensure the storage configuration is working
   - Check that uploaded files are accessible via their URLs

## Database Management

### Initial Setup

If deploying to a new environment, you'll need to set up the database:

1. Ensure your PostgreSQL database is accessible from the deployment environment

2. The initial database schema will be created automatically on first run

3. For a clean installation, run the database migrations:
   ```bash
   npm run db:push
   ```

### Database Migrations

When deploying updates that include schema changes:

1. Always back up the database before deploying

2. Use Drizzle's migration tools to apply changes safely:
   ```bash
   npm run db:push
   ```

3. Monitor the migration process for any errors

## Scaling Considerations

As your user base grows, consider these scaling strategies:

### Database Scaling

1. **Connection Pooling**: Configure the connection pool size based on expected load:
   ```typescript
   // Adjust pool configuration in server/db.ts
   const pool = new Pool({
     connectionString: process.env.DATABASE_URL,
     max: 20 // Increase for higher traffic
   });
   ```

2. **Read Replicas**: For heavy read workloads, consider setting up PostgreSQL read replicas

3. **Database Monitoring**: Implement monitoring for query performance and connection usage

### Application Scaling

1. **Horizontal Scaling**: Deploy multiple instances behind a load balancer

2. **Memory Management**: Monitor memory usage and adjust resource allocation

3. **Caching**: Implement Redis caching for frequently accessed data:
   ```typescript
   // Example Redis caching middleware
   const cacheMiddleware = (req, res, next) => {
     const key = `cache:${req.originalUrl}`;
     redisClient.get(key, (err, data) => {
       if (data) {
         return res.json(JSON.parse(data));
       }
       res.originalJson = res.json;
       res.json = (body) => {
         redisClient.setex(key, 3600, JSON.stringify(body));
         return res.originalJson(body);
       };
       next();
     });
   };
   ```

## Continuous Deployment

For automated deployment workflows:

1. Set up GitHub Actions or similar CI/CD platform

2. Configure automated testing before deployment

3. Implement a multi-environment strategy:
   - Development
   - Staging/QA
   - Production

Example GitHub Actions workflow:

```yaml
name: Deploy to Replit

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Use Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '16'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Type check
        run: npm run check
        
      - name: Build
        run: npm run build
        
      - name: Deploy to Replit
        uses: replit/replit-deploy@v1
        with:
          token: ${{ secrets.REPLIT_TOKEN }}
```

## Monitoring and Logging

### Error Tracking

1. Implement comprehensive error logging:
   ```typescript
   // Global error handler in server/index.ts
   app.use((err, req, res, next) => {
     console.error(`[ERROR] ${new Date().toISOString()}:`, {
       error: err.message,
       stack: err.stack,
       path: req.path,
       method: req.method,
       user: req.userId
     });
     // Send response to client
     res.status(err.status || 500).json({
       error: {
         message: err.message,
         code: err.code || 'INTERNAL_ERROR'
       }
     });
   });
   ```

2. Set up alerts for critical errors

### Performance Monitoring

1. Implement API response time tracking:
   ```typescript
   // Response time middleware
   app.use((req, res, next) => {
     const start = Date.now();
     res.on('finish', () => {
       const duration = Date.now() - start;
       console.log(`${req.method} ${req.path} ${res.statusCode} ${duration}ms`);
       if (duration > 1000) {
         console.warn(`Slow response (${duration}ms): ${req.method} ${req.path}`);
       }
     });
     next();
   });
   ```

2. Monitor database query performance:
   ```typescript
   // Example query logging
   db.on('query', (query) => {
     const start = Date.now();
     query.on('end', () => {
       const duration = Date.now() - start;
       console.log(`Query (${duration}ms): ${query.text}`);
     });
   });
   ```

## Backup Strategy

Implement a robust backup strategy:

1. **Database Backups**:
   - Schedule regular PostgreSQL dumps
   - Store backups in secure, offsite storage
   - Test restore procedures regularly

2. **File Storage Backups**:
   - Back up uploaded files regularly
   - Implement versioning if possible
   - Ensure backup synchronization with database backups

3. **Configuration Backups**:
   - Back up environment variables and configuration
   - Document all external service dependencies
   - Maintain deployment documentation

## Security Checklist

Before launching to production, complete this security checklist:

1. **Secure Communication**:
   - Enforce HTTPS with proper certificates
   - Implement HTTP Strict Transport Security (HSTS)
   - Configure secure cookie settings

2. **Access Controls**:
   - Review all API endpoints for proper authentication
   - Test role-based access controls
   - Verify middleware protection is working

3. **Data Protection**:
   - Ensure sensitive data is encrypted
   - Verify password hashing is secure
   - Implement rate limiting for authentication endpoints

4. **External Dependencies**:
   - Audit npm packages for vulnerabilities:
     ```bash
     npm audit
     ```
   - Keep all dependencies updated
   - Remove unused dependencies

## Troubleshooting Common Issues

### Database Connection Problems

If your application can't connect to the database:

1. Verify the `DATABASE_URL` environment variable is correctly set
2. Ensure database credentials are valid
3. Check network connectivity between your application and database
4. Verify PostgreSQL is running and accessible from your deployment environment

### Application Startup Failures

If the application fails to start:

1. Check logs for error messages
2. Verify all required environment variables are set
3. Ensure the build process completed successfully
4. Check for port conflicts with other services

### Performance Issues

If you experience slow performance:

1. Review database query performance
2. Check memory usage and potential leaks
3. Analyze slow API responses
4. Consider implementing caching for frequent operations

## Rollback Procedures

If a deployment causes issues, follow these rollback steps:

1. **Immediate Mitigation**:
   - If possible, fix forward with a quick patch
   - Otherwise, revert to the previous version

2. **Database Rollback**:
   - If schema changes were made, restore from the pre-deployment backup
   - For data-only issues, run corrective SQL scripts

3. **Post-Rollback Analysis**:
   - Document the failure cause
   - Implement tests to prevent similar issues
   - Review deployment process for improvements

## Maintenance Windows

1. **Scheduled Maintenance**:
   - Plan maintenance during low-traffic periods
   - Notify users at least 24 hours in advance
   - Provide estimated downtime duration

2. **Emergency Maintenance**:
   - Have a communication plan for unplanned downtime
   - Prioritize critical fixes
   - Provide regular status updates during extended outages