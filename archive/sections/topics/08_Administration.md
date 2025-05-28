# 8. Administration

## Deployment Guide

## Deployment Guide

### Overview

This guide covers the deployment process for the TuneMantra platform. TuneMantra is designed to be deployed in various environments, but this guide focuses on deployment with Replit, which provides a straightforward and scalable hosting solution.

### Prerequisites

Before deploying TuneMantra, ensure you have:

1. A Replit account with access to the TuneMantra repository
2. A PostgreSQL database (Neon serverless PostgreSQL recommended)
3. Required environment variables and secrets
4. Access to any third-party services needed (e.g., payment processing, file storage)

### Environment Variables

TuneMantra requires several environment variables to function properly. Set these in your Replit environment:

#### Required Variables

```
## Database Connection
DATABASE_URL=postgresql://username:password@hostname:port/database

## Session Management
SESSION_SECRET=your-secure-session-secret

## Admin Access
SUPER_ADMIN_CODE=your-super-admin-registration-code

## API Security
API_KEY_SECRET=your-api-key-encryption-secret
```

#### Optional Variables

```
## Environment Configuration
NODE_ENV=production

## Port Configuration (defaults to 5000)
PORT=5000

## External Services
PAYMENT_GATEWAY_API_KEY=your-payment-gateway-key
STORAGE_API_KEY=your-storage-service-key
AI_SERVICE_API_KEY=your-ai-service-key
```

### Deployment Steps

#### 1. Prepare for Deployment

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

#### 2. Deploy to Replit

Replit provides a simple deployment process:

1. Push your code to the Replit repository

2. In the Replit interface, navigate to the "Deployment" tab

3. Configure deployment settings:
   - Build command: `npm run build`
   - Run command: `npm run start`
   - Environment variables: Add all required variables

4. Click "Deploy" to start the deployment process

#### 3. Monitor Deployment

1. Replit will show the build and deployment progress

2. If the build fails, check the logs for errors:
   - Common issues include missing dependencies or environment variables
   - TypeScript errors that weren't caught during development

3. Once deployed, Replit will provide a public URL for your application

#### 4. Post-Deployment Configuration

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

### Database Management

#### Initial Setup

If deploying to a new environment, you'll need to set up the database:

1. Ensure your PostgreSQL database is accessible from the deployment environment

2. The initial database schema will be created automatically on first run

3. For a clean installation, run the database migrations:
   ```bash
   npm run db:push
   ```

#### Database Migrations

When deploying updates that include schema changes:

1. Always back up the database before deploying

2. Use Drizzle's migration tools to apply changes safely:
   ```bash
   npm run db:push
   ```

3. Monitor the migration process for any errors

### Scaling Considerations

As your user base grows, consider these scaling strategies:

#### Database Scaling

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

#### Application Scaling

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

### Continuous Deployment

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

### Monitoring and Logging

#### Error Tracking

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

#### Performance Monitoring

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

### Backup Strategy

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

### Security Checklist

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

### Troubleshooting Common Issues

#### Database Connection Problems

If your application can't connect to the database:

1. Verify the `DATABASE_URL` environment variable is correctly set
2. Ensure database credentials are valid
3. Check network connectivity between your application and database
4. Verify PostgreSQL is running and accessible from your deployment environment

#### Application Startup Failures

If the application fails to start:

1. Check logs for error messages
2. Verify all required environment variables are set
3. Ensure the build process completed successfully
4. Check for port conflicts with other services

#### Performance Issues

If you experience slow performance:

1. Review database query performance
2. Check memory usage and potential leaks
3. Analyze slow API responses
4. Consider implementing caching for frequent operations

### Rollback Procedures

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

### Maintenance Windows

1. **Scheduled Maintenance**:
   - Plan maintenance during low-traffic periods
   - Notify users at least 24 hours in advance
   - Provide estimated downtime duration

2. **Emergency Maintenance**:
   - Have a communication plan for unplanned downtime
   - Prioritize critical fixes
   - Provide regular status updates during extended outages

*Source: /home/runner/workspace/.archive/archive_docs/doc_backup/deployment.md*

---

## TuneMantra Platform Management Guide

## TuneMantra Platform Management Guide

### Introduction

This guide is designed for TuneMantra administrators responsible for managing and maintaining the platform. It covers all aspects of platform administration, from user management to system configuration and reporting.

### Administrator Roles and Permissions

TuneMantra implements a hierarchical admin structure:

#### Super Admin

- Has complete access to all platform features
- Can create other admin accounts
- Manages global platform settings
- Accesses system-level configurations

#### Platform Admin

- Manages users and content across the platform
- Approves/rejects new user registrations
- Handles royalty distribution issues
- Monitors platform performance

#### Label Admin

- Manages specific label accounts
- Approves artist content under their label
- Handles support for their artists
- Reviews analytics for their roster

### Admin Dashboard

#### Accessing Admin Features

1. Log in with your admin credentials
2. Navigate to the Admin Dashboard via:
   - Direct URL: `/admin/dashboard`
   - Admin dropdown in the top navigation bar

#### Dashboard Overview

The admin dashboard provides a comprehensive view of platform activity:

- **User Activity**: New registrations, active users, login trends
- **Content Metrics**: Track uploads, release submissions, distribution status
- **Financial Overview**: Royalty calculations, payment processing, revenue trends
- **System Status**: Server health, database performance, API usage
- **Alerts**: Critical issues requiring admin attention

### User Management

#### User Overview

1. Navigate to "Admin" > "User Management"
2. View a list of all platform users with filtering options:
   - By status (active, pending, suspended)
   - By role (artist, label, admin)
   - By registration date
   - By subscription tier

#### User Verification

New user accounts often require verification:

1. Go to "Admin" > "User Management" > "Pending Verification"
2. Review submitted documentation:
   - Identity verification
   - Business registration (for labels)
   - Tax information
3. Approve or reject with comments
4. Set appropriate role and permissions

#### Edit User Details

1. Find the user in the User Management section
2. Click "Edit" to modify:
   - Contact information
   - Role and permissions
   - Subscription details
   - Account status

#### Account Actions

Administrative actions available for user accounts:

- **Suspend Account**: Temporarily disable access
- **Terminate Account**: Permanently disable with data preservation
- **Delete Account**: Permanently remove account and associated data
- **Reset Password**: Generate a password reset link
- **Login As User**: Temporarily access account for troubleshooting

### Content Management

#### Content Approval Workflow

New releases may require admin approval:

1. Navigate to "Admin" > "Content Management" > "Pending Approval"
2. Review the release details:
   - Artist/label information
   - Track metadata
   - Audio quality
   - Cover artwork
   - Rights declarations
3. Approve, reject with comments, or request changes
4. Once approved, release is queued for distribution

#### Content Moderation

For content that violates terms of service:

1. Go to "Admin" > "Content Management" > "Content Moderation"
2. Review flagged content (either automatic or user-reported)
3. Take appropriate action:
   - Approve content (false positive)
   - Request modifications
   - Remove content
   - Issue user warning
   - Take account action if necessary

#### Bulk Content Management

For managing multiple content items:

1. Navigate to "Admin" > "Content Management" > "Bulk Actions"
2. Filter content by various criteria
3. Select multiple items
4. Apply bulk actions:
   - Approve/reject
   - Change status
   - Re-queue for distribution
   - Generate reports

### Financial Administration

#### Royalty Management

1. Navigate to "Admin" > "Finance" > "Royalty Management"
2. Monitor the royalty calculation process:
   - View calculation status
   - Troubleshoot failed calculations
   - Manually trigger recalculations if needed
3. Approve batch royalty calculations before payment
4. Handle special cases and disputes

#### Payment Processing

1. Go to "Admin" > "Finance" > "Payment Processing"
2. Review pending withdrawal requests
3. Approve or flag for review
4. Monitor payment processor status
5. Handle failed payments and exceptions

#### Financial Reporting

Generate comprehensive financial reports:

1. Navigate to "Admin" > "Finance" > "Reports"
2. Select report type:
   - Revenue overview
   - Royalty distribution summary
   - Tax withholding report
   - Platform fee summary
3. Choose date range and filtering options
4. Export in various formats (Excel, CSV, PDF)

### Platform Configuration

#### Distribution Platforms

Manage connections to music distribution platforms:

1. Navigate to "Admin" > "Platform Configuration" > "Distribution Platforms"
2. Add new platforms with:
   - Platform name and details
   - API credentials
   - Delivery specifications
   - Platform-specific metadata requirements
3. Edit existing platform configurations
4. Monitor platform status and performance

#### Subscription Tiers

Configure subscription plans:

1. Go to "Admin" > "Platform Configuration" > "Subscription Plans"
2. Manage existing plans:
   - Modify features and limitations
   - Adjust pricing
   - Change billing cycles
3. Create new subscription tiers
4. Set up promotional offers and discounts

#### System Settings

Configure global system parameters:

1. Navigate to "Admin" > "Platform Configuration" > "System Settings"
2. Adjust key settings:
   - Registration requirements
   - Content approval workflows
   - Royalty calculation parameters
   - System notifications
   - API rate limits

### Analytics and Reporting

#### Platform Analytics

View comprehensive platform metrics:

1. Navigate to "Admin" > "Analytics" > "Platform Overview"
2. Monitor key performance indicators:
   - User growth and retention
   - Content volume and quality
   - Distribution performance
   - Revenue and royalty trends
3. Filter by date range and segment
4. Export reports for stakeholders

#### Custom Reports

Generate specialized reports for business intelligence:

1. Go to "Admin" > "Analytics" > "Custom Reports"
2. Select report parameters:
   - Data points to include
   - Grouping and aggregation methods
   - Filtering criteria
   - Visualization options
3. Save report templates for future use
4. Schedule automated report generation

#### Audit Logs

Review system activity for security and troubleshooting:

1. Navigate to "Admin" > "System" > "Audit Logs"
2. Filter logs by:
   - User/admin ID
   - Action type
   - Time period
   - Affected resource
3. Export logs for compliance and investigation
4. Set up alerts for suspicious activities

### Support Management

#### Ticket System

Manage user support requests:

1. Navigate to "Admin" > "Support" > "Tickets"
2. View all support tickets with status:
   - New/unassigned
   - In progress
   - Waiting for user
   - Resolved
   - Closed
3. Assign tickets to support staff
4. Track resolution time and user satisfaction

#### Knowledge Base Management

Maintain the user help resources:

1. Go to "Admin" > "Support" > "Knowledge Base"
2. Create, edit, and organize help articles
3. Update FAQs based on common support issues
4. Manage video tutorials and guides
5. Track article effectiveness and usage

#### Announcement System

Communicate with platform users:

1. Navigate to "Admin" > "Support" > "Announcements"
2. Create platform-wide or targeted announcements
3. Schedule announcement publication
4. Track announcement delivery and read status
5. Manage notification preferences

### System Maintenance

#### Database Management

Monitor and maintain database health:

1. Navigate to "Admin" > "System" > "Database"
2. View database status and performance metrics
3. Schedule maintenance operations:
   - Backup creation
   - Optimization tasks
   - Index rebuilding
4. Manage database growth and scaling

#### File Storage Management

Monitor and manage uploaded content:

1. Go to "Admin" > "System" > "Storage"
2. View storage usage by:
   - Content type
   - User/label
   - Age of content
3. Implement storage policies:
   - Archiving old content
   - Compression settings
   - Redundancy configuration

#### API Management

Monitor and configure API functionality:

1. Navigate to "Admin" > "System" > "API Management"
2. View API usage metrics:
   - Request volume
   - Response times
   - Error rates
   - User/client distribution
3. Configure:
   - Rate limiting
   - Access controls
   - Monitoring thresholds

### Security Administration

#### Access Control

Manage admin access to the platform:

1. Navigate to "Admin" > "Security" > "Access Control"
2. Manage admin accounts:
   - Create new admin users
   - Define role-based permissions
   - Implement team-based access
   - Configure MFA requirements
3. Review admin activity logs

#### Security Monitoring

Monitor the platform for security issues:

1. Go to "Admin" > "Security" > "Monitoring"
2. View security alerts:
   - Failed login attempts
   - Permission violations
   - Unusual activity patterns
   - API abuse
3. Configure alert thresholds and notification settings

#### Compliance Management

Ensure platform compliance with regulations:

1. Navigate to "Admin" > "Security" > "Compliance"
2. Access compliance tools:
   - Privacy policy management
   - Data protection settings
   - Regulatory reporting
   - Consent management
3. Generate compliance reports for auditing

### Disaster Recovery

#### Backup Management

Manage system backup strategy:

1. Navigate to "Admin" > "System" > "Backup"
2. View backup status:
   - Last successful backup
   - Backup size and content
   - Storage location
3. Configure backup schedule and retention
4. Test restoration process periodically

#### Recovery Procedures

In case of system failure:

1. Access recovery tools through "Admin" > "System" > "Recovery"
2. Follow structured recovery workflow:
   - Assess failure impact
   - Select appropriate recovery point
   - Initiate restoration process
   - Verify system integrity post-recovery
3. Document incidents and follow-up actions

### Integrations Management

#### Third-party Services

Configure and monitor external service integrations:

1. Navigate to "Admin" > "Integrations"
2. Manage connections to:
   - Payment processors
   - Analytics services
   - Email delivery services
   - Storage providers
   - Distribution partners
3. Monitor integration health and performance
4. Update API credentials and configurations

#### Webhook Configuration

Manage event notifications to external systems:

1. Go to "Admin" > "Integrations" > "Webhooks"
2. Configure webhooks for:
   - User events (registration, subscription changes)
   - Content events (uploads, status changes)
   - Financial events (royalty calculations, payments)
3. Monitor delivery status and retry failed webhooks

### Best Practices

#### User Management

- Verify identity documents thoroughly before approval
- Implement progressive permissions for new users
- Regularly audit user activity for unusual patterns
- Respond promptly to account support requests

#### Content Administration

- Apply consistent standards for content approval
- Document content rejection reasons clearly
- Implement random quality checks for approved content
- Maintain a database of common issues for reference

#### Financial Operations

- Schedule regular audits of royalty calculations
- Implement four-eye principle for large payments
- Maintain clear documentation of financial exceptions
- Follow consistent processes for dispute resolution

#### System Performance

- Monitor key performance metrics with alerting
- Schedule maintenance during low-usage periods
- Document all system changes and updates
- Test scaling capabilities proactively

### Troubleshooting Common Issues

#### User Registration Problems

- **Issue**: Users unable to complete registration
- **Checks**:
  - Verify email delivery service status
  - Check validation rules configuration
  - Look for database constraints or errors
  - Review recent changes to registration flow

#### Content Distribution Failures

- **Issue**: Content fails to distribute to platforms
- **Checks**:
  - Verify platform API credentials
  - Check for platform-specific errors
  - Review content format and metadata
  - Check network connectivity to distribution services

#### Royalty Calculation Issues

- **Issue**: Royalty calculations failing or inaccurate
- **Checks**:
  - Review platform reporting data completeness
  - Check calculation parameters and rules
  - Verify database query performance
  - Look for data inconsistencies in analytics records

#### System Performance Degradation

- **Issue**: Platform becoming slow or unresponsive
- **Checks**:
  - Monitor database query performance
  - Check server resource utilization
  - Review recent traffic patterns
  - Identify potential bottlenecks in application code

### Escalation Procedures

#### Support Escalation

For complex support issues:

1. Initial support agent documents attempted solutions
2. Supervisor reviews and assigns appropriate specialist
3. Engineering team consulted for technical issues
4. Management involved for policy or business decisions
5. Resolution documented and shared for knowledge base

#### Emergency Response

For critical system issues:

1. On-call admin receives alert via monitoring system
2. Severity assessment determines response team
3. Incident commander coordinates response efforts
4. Regular status updates provided to stakeholders
5. Post-incident review conducted and documented

### Administrator Training

New platform administrators should complete:

1. User management and verification training
2. Content moderation and approval procedures
3. Financial administration and compliance requirements
4. System monitoring and maintenance procedures
5. Security and access control protocols

### Appendices

#### Admin Command Reference

Quick reference for administrative CLI commands:

```
## User management
admin:user:verify [user_id] --approve|--reject --reason="text"
admin:user:modify [user_id] --role=[role] --status=[status]

## Content management
admin:content:approve [content_id] --comment="text"
admin:content:reject [content_id] --reason="text"

## System maintenance
admin:system:backup --full|--incremental
admin:system:optimize-db
admin:system:clear-cache
```

#### Monthly Admin Checklist

- [ ] Review pending user verifications older than 72 hours
- [ ] Audit user permissions for recently promoted accounts
- [ ] Check error logs for recurring issues
- [ ] Review and approve monthly royalty calculations
- [ ] Verify backup integrity and test restoration
- [ ] Update knowledge base with common support issues
- [ ] Review security alerts and access logs
- [ ] Generate and review monthly platform performance report

*Source: /home/runner/workspace/.archive/archive_docs/doc_backup/platform-management.md*

---

## Reference to Duplicate Content (110)

## Reference to Duplicate Content

**Original Path:** all_md_files/3march1am/docs/features/PAYMENT_REVENUE_MANAGEMENT.md

**Title:** Payment & Revenue Management

**MD5 Hash:** 6e2588ac6adee112b597e52e0b47371e

**Duplicate of:** unified_documentation/payment/17032025-payment-revenue-management-extended.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/3march1am_payment-revenue-management.md.md*

---

## Reference to Duplicate Content (111)

## Reference to Duplicate Content

**Original Path:** all_md_files/5march8am/ADMIN-SETUP.md

**Title:** TuneMantra Admin Setup Guide

**MD5 Hash:** a274b7b868d6c928321fc47e8e34f9a4

**Duplicate of:** unified_documentation/technical/3march1am-admin-setup.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/5march8am_admin-setup.md.md*

---

## Reference to Duplicate Content (112)

## Reference to Duplicate Content

**Original Path:** all_md_files/5march8am/docs/features/PAYMENT_REVENUE_MANAGEMENT.md

**Title:** Payment & Revenue Management

**MD5 Hash:** 6e2588ac6adee112b597e52e0b47371e

**Duplicate of:** unified_documentation/payment/17032025-payment-revenue-management-extended.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/5march8am_payment-revenue-management.md.md*

---

## Reference to Duplicate Content (113)

## Reference to Duplicate Content

**Original Path:** all_md_files/8march258/ADMIN-SETUP.md

**Title:** TuneMantra Admin Setup Guide

**MD5 Hash:** a274b7b868d6c928321fc47e8e34f9a4

**Duplicate of:** unified_documentation/technical/3march1am-admin-setup.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/8march258_admin-setup.md.md*

---

## Reference to Duplicate Content (114)

## Reference to Duplicate Content

**Original Path:** all_md_files/8march258/docs/features/PAYMENT_REVENUE_MANAGEMENT.md

**Title:** Payment & Revenue Management

**MD5 Hash:** 6e2588ac6adee112b597e52e0b47371e

**Duplicate of:** unified_documentation/payment/17032025-payment-revenue-management-extended.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/8march258_payment-revenue-management.md.md*

---

## Reference to Duplicate Content (115)

## Reference to Duplicate Content

**Original Path:** all_md_files/PPv1/docs/user-guides/catalog-management.md

**Title:** Catalog Management Guide

**MD5 Hash:** a5e5a51ad21e1bc4b932628caa326350

**Duplicate of:** unified_documentation/technical/organized-catalog-management.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/PPv1_catalog-management.md.md*

---

## Reference to Duplicate Content (116)

## Reference to Duplicate Content

**Original Path:** all_md_files/organized/api-reference/ADMIN-SETUP.md

**Title:** TuneMantra Admin Setup Guide

**MD5 Hash:** a274b7b868d6c928321fc47e8e34f9a4

**Duplicate of:** unified_documentation/technical/3march1am-admin-setup.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/organized_admin-setup.md.md*

---

## Metadata for catalog-management.md

## Metadata for catalog-management.md

**Original Path:** all_md_files/organized/tutorials/catalog-management.md

**Title:** Catalog Management Guide

**Category:** technical

**MD5 Hash:** a5e5a51ad21e1bc4b932628caa326350

**Source Branch:** organized

**Note:** This file has duplicate content in other branches.


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/organized_catalog-management.md.md*

---

## Reference to Duplicate Content (117)

## Reference to Duplicate Content

**Original Path:** all_md_files/organized/api-reference/payment-revenue-management-extended.md

**Title:** Payment & Revenue Management

**MD5 Hash:** 6e2588ac6adee112b597e52e0b47371e

**Duplicate of:** unified_documentation/payment/17032025-payment-revenue-management-extended.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/organized_payment-revenue-management-extended.md.md*

---

## Reference to Duplicate Content (118)

## Reference to Duplicate Content

**Original Path:** all_md_files/replit-agent/docs/user-guides/catalog-management.md

**Title:** Catalog Management Guide

**MD5 Hash:** a5e5a51ad21e1bc4b932628caa326350

**Duplicate of:** unified_documentation/technical/organized-catalog-management.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/replit-agent_catalog-management.md.md*

---

## Metadata for artist-management.md

## Metadata for artist-management.md

**Original Path:** all_md_files/temp-3march/docs-consolidated/02-user-guides/labels/artist-management.md

**Title:** Artist Management Guide for Labels

**Category:** technical

**MD5 Hash:** b2d07c5018037b72a5939eecb1d2c9fc

**Source Branch:** temp-3march


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/temp-3march_artist-management.md.md*

---

## Metadata for content-management.md

## Metadata for content-management.md

**Original Path:** all_md_files/temp-3march/docs-consolidated/03-technical/content-management.md

**Title:** Content Management System

**Category:** technical

**MD5 Hash:** 68b6664b37a5d428e0e17fb140589856

**Source Branch:** temp-3march


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/temp-3march_content-management.md.md*

---

## Metadata for deployment.md

## Metadata for deployment.md

**Original Path:** all_md_files/temp-3march/docs-consolidated/05-administrators/deployment.md

**Title:** Deployment Guide

**Category:** technical

**MD5 Hash:** f1e4d7418842ba21d7c3e1f2dc06aa5c

**Source Branch:** temp-3march


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/temp-3march_deployment.md.md*

---

## Metadata for release-management.md

## Metadata for release-management.md

**Original Path:** all_md_files/temp-3march/docs-consolidated/02-user-guides/release-management.md

**Title:** Release Management Guide

**Category:** technical

**MD5 Hash:** 73aad665d18d1ede6d0f14afa2506c17

**Source Branch:** temp-3march


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/temp-3march_release-management.md.md*

---

## Reference to Duplicate Content (119)

## Reference to Duplicate Content

**Original Path:** all_md_files/temp-extraction/docs/developer/payment/payment-revenue-management-extended.md

**Title:** Payment & Revenue Management

**MD5 Hash:** 6e2588ac6adee112b597e52e0b47371e

**Duplicate of:** unified_documentation/payment/17032025-payment-revenue-management-extended.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/temp-extraction_payment-revenue-management-extended.md.md*

---

## Reference to Duplicate Content (120)

## Reference to Duplicate Content

**Original Path:** all_md_files/temp-extraction/docs/developer/payment/payment-revenue-management.md

**Title:** Payment and Revenue Management System

**MD5 Hash:** 3e3f5067d7d6e72a3ed40c81d6a48cf0

**Duplicate of:** unified_documentation/payment/17032025-payment-revenue-management.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/temp-extraction_payment-revenue-management.md.md*

---

## Reference to Duplicate Content (121)

## Reference to Duplicate Content

**Original Path:** all_md_files/temp-extraction/docs/developer/content-management/release-management.md

**Title:** Comprehensive Release Management System

**MD5 Hash:** dfddebdc6175a8b1913e92e20821e863

**Duplicate of:** unified_documentation/technical/17032025-release-management.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/temp-extraction_release-management.md.md*

---

## Payment & Revenue Management

## Payment & Revenue Management

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

*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/payment/17032025-payment-revenue-management-extended.md*

---

## Payment and Revenue Management System

## Payment and Revenue Management System

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

*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/payment/17032025-payment-revenue-management.md*

---

## Comprehensive Release Management System

## Comprehensive Release Management System

**Version: 2.0 | Last Updated: March 18, 2025**

This document provides a detailed overview of the Release Management System in TuneMantra, which handles the creation, management, and distribution of music releases across multiple platforms.

### System Overview

The Release Management System is the core content workflow system in TuneMantra, enabling users to create, organize, and distribute their music while maintaining complete metadata control and visibility into the distribution process.

```
┌─────────────────────────────────────────────────────────────┐
│                 Release Management System                   │
│                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐     │
│  │  Release    │    │  Track      │    │  Asset      │     │
│  │  Workflow   │───▶│  Management │───▶│  Management │     │
│  └─────────────┘    └─────────────┘    └─────────────┘     │
│         │                 │                  │             │
│         ▼                 ▼                  ▼             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Validation & Approval                  │   │
│  └─────────────────────────────────────────────────────┘   │
│         │                 │                  │             │
│         ▼                 ▼                  ▼             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐     │
│  │  Metadata   │    │  Distribution│    │  Analytics  │     │
│  │  Management │───▶│  System     │───▶│  Integration │     │
│  └─────────────┘    └─────────────┘    └─────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

### 1. Core Components and Data Model

#### Release Entity

The Release entity represents albums, EPs, singles, and other music releases.

```typescript
export const releases = pgTable("releases", {
  id: serial("id").primaryKey(),
  user_id: integer("user_id").notNull().references(() => users.id),
  title: varchar("title", { length: 255 }).notNull(),
  artist_name: varchar("artist_name", { length: 255 }).notNull(),
  release_date: date("release_date"),
  type: contentTypeEnum("type").notNull(),
  status: varchar("status", { length: 255 }).notNull().default("draft"),
  upc: varchar("upc", { length: 255 }),
  catalogue_id: varchar("catalogue_id", { length: 255 }).notNull().unique(),
  cover_art_url: varchar("cover_art_url", { length: 255 }),
  created_at: timestamp("created_at", { withTimezone: true }).defaultNow(),
  updated_at: timestamp("updated_at", { withTimezone: true }).defaultNow(),
  metadata: jsonb("metadata"),
  language: languageEnum("language").notNull().default("english"),
  genre: genreCategoryEnum("genre").notNull(),
  territories: varchar("territories", { length: 255 }).array(),
  ownership_type: ownershipTypeEnum("ownership_type").notNull().default("original"),
  tags: jsonb("tags"),
  ai_analysis: jsonb("ai_analysis")
});
```

#### Track Entity

The Track entity represents individual songs within releases.

```typescript
export const tracks = pgTable("tracks", {
  id: serial("id").primaryKey(),
  release_id: integer("release_id").references(() => releases.id, { onDelete: "cascade" }),
  user_id: integer("user_id").notNull().references(() => users.id),
  title: varchar("title", { length: 255 }).notNull(),
  artist_name: varchar("artist_name", { length: 255 }).notNull(),
  isrc: varchar("isrc", { length: 255 }),
  audio_url: varchar("audio_url", { length: 255 }).notNull(),
  duration: integer("duration"),
  track_number: integer("track_number"),
  created_at: timestamp("created_at", { withTimezone: true }).defaultNow(),
  updated_at: timestamp("updated_at", { withTimezone: true }).defaultNow(),
  metadata: jsonb("metadata"),
  language: languageEnum("language").notNull().default("english"),
  explicit_content: boolean("explicit_content").default(false),
  ownership_type: ownershipTypeEnum("ownership_type").notNull().default("original"),
  audio_format: audioFormatEnum("audio_format").notNull().default("wav"),
  lyrics: text("lyrics"),
  stems_available: boolean("stems_available").default(false),
  stem_details: jsonb("stem_details"),
  ai_analysis: jsonb("ai_analysis"),
  credits: jsonb("credits")
});
```

#### Release Approval Entity

The Release Approval entity tracks the approval workflow for releases.

```typescript
export const releaseApprovals = pgTable("release_approvals", {
  id: serial("id").primaryKey(),
  release_id: integer("release_id").notNull().references(() => releases.id, { onDelete: "cascade" }),
  status: approvalStatusEnum("status").notNull().default("pending"),
  requested_by: integer("requested_by").notNull().references(() => users.id),
  reviewed_by: integer("reviewed_by").references(() => users.id),
  requested_at: timestamp("requested_at", { withTimezone: true }).defaultNow(),
  reviewed_at: timestamp("reviewed_at", { withTimezone: true }),
  notes: text("notes"),
  rejection_reason: text("rejection_reason"),
  validation_results: jsonb("validation_results")
});
```

### 2. Release Workflow

The release workflow manages the lifecycle of a music release from creation to distribution.

#### Release States and Transitions

Releases move through a defined set of states:

1. **Draft**: Initial creation state
2. **Pending Validation**: Submitted for validation
3. **Validation Failed**: Issues found during validation
4. **Ready for Distribution**: Validated and ready to distribute
5. **Scheduled**: Scheduled for future distribution
6. **In Distribution**: Currently being distributed
7. **Distributed**: Successfully distributed
8. **Distribution Failed**: Issues occurred during distribution
9. **Takedown Requested**: Removal requested
10. **Removed**: Removed from all platforms

#### Workflow Implementation

```typescript
/**
 * Release workflow manager
 */
class ReleaseWorkflowManager {
  /**
   * Creates a new release in draft state
   * 
   * @param userId The ID of the user creating the release
   * @param releaseData The release data
   * @returns The created release
   */
  async createRelease(
    userId: number,
    releaseData: Omit<InsertRelease, 'id' | 'user_id' | 'status' | 'catalogue_id' | 'created_at' | 'updated_at'>
  ): Promise<Release> {
    // Generate catalogue ID
    const catalogueId = generateCatalogueId();

    // Create release
    const insertResult = await db.insert(releases).values({
      ...releaseData,
      user_id: userId,
      status: 'draft',
      catalogue_id: catalogueId
    }).returning();

    return insertResult[0];
  }

  /**
   * Submits a release for validation
   * 
   * @param releaseId The ID of the release
   * @param userId The ID of the user submitting the release
   * @returns Updated release
   */
  async submitForValidation(
    releaseId: number,
    userId: number
  ): Promise<Release> {
    // Get release
    const release = await db.query.releases.findFirst({
      where: eq(releases.id, releaseId)
    });

    if (!release) {
      throw new Error(`Release with ID ${releaseId} not found`);
    }

    // Check release is in draft state
    if (release.status !== 'draft' && release.status !== 'validation_failed') {
      throw new Error(`Release must be in draft or validation_failed state to submit for validation`);
    }

    // Update release status
    const updateResult = await db.update(releases)
      .set({
        status: 'pending_validation',
        updated_at: new Date()
      })
      .where(eq(releases.id, releaseId))
      .returning();

    // Trigger validation process
    this.validateRelease(releaseId, userId).catch(error => {
      console.error(`Error validating release ${releaseId}:`, error);
    });

    return updateResult[0];
  }

  /**
   * Validates a release
   * 
   * @param releaseId The ID of the release to validate
   * @param userId The ID of the user initiating validation
   */
  private async validateRelease(
    releaseId: number,
    userId: number
  ): Promise<void> {
    try {
      // Get release with tracks
      const release = await db.query.releases.findFirst({
        where: eq(releases.id, releaseId),
        with: {
          tracks: true
        }
      });

      if (!release) {
        throw new Error(`Release with ID ${releaseId} not found`);
      }

      // Create validation instance
      const validator = new ReleaseValidator();

      // Validate release and all tracks
      const validationResult = await validator.validateRelease(release);

      // Update release status based on validation result
      if (validationResult.valid) {
        await db.update(releases)
          .set({
            status: 'ready_for_distribution',
            updated_at: new Date()
          })
          .where(eq(releases.id, releaseId));
      } else {
        await db.update(releases)
          .set({
            status: 'validation_failed',
            updated_at: new Date()
          })
          .where(eq(releases.id, releaseId));
      }

      // Create approval record
      await db.insert(releaseApprovals).values({
        release_id: releaseId,
        status: validationResult.valid ? 'approved' : 'rejected',
        requested_by: userId,
        reviewed_by: null, // Automatic validation
        requested_at: new Date(),
        reviewed_at: new Date(),
        notes: validationResult.valid ? 'Automatic validation passed' : 'Automatic validation failed',
        rejection_reason: validationResult.valid ? null : 'Validation issues detected',
        validation_results: validationResult
      });
    } catch (error) {
      // Update release status to validation failed
      await db.update(releases)
        .set({
          status: 'validation_failed',
          updated_at: new Date()
        })
        .where(eq(releases.id, releaseId));

      // Create approval record with error
      await db.insert(releaseApprovals).values({
        release_id: releaseId,
        status: 'rejected',
        requested_by: userId,
        reviewed_by: null, // Automatic validation
        requested_at: new Date(),
        reviewed_at: new Date(),
        notes: 'Validation process error',
        rejection_reason: error.message,
        validation_results: { valid: false, errors: [{ message: error.message }] }
      });

      throw error;
    }
  }

  /**
   * Schedules a release for distribution
   * 
   * @param releaseId The ID of the release
   * @param userId The ID of the user scheduling the release
   * @param scheduledDate The scheduled distribution date
   * @param platforms Array of platform IDs to distribute to
   * @returns The scheduled distribution
   */
  async scheduleRelease(
    releaseId: number,
    userId: number,
    scheduledDate: Date,
    platforms: number[]
  ): Promise<ScheduledDistribution> {
    // Get release
    const release = await db.query.releases.findFirst({
      where: eq(releases.id, releaseId)
    });

    if (!release) {
      throw new Error(`Release with ID ${releaseId} not found`);
    }

    // Check release is ready for distribution
    if (release.status !== 'ready_for_distribution') {
      throw new Error(`Release must be in ready_for_distribution state to schedule`);
    }

    // Validate scheduled date is in the future
    if (scheduledDate <= new Date()) {
      throw new Error('Scheduled date must be in the future');
    }

    // Update release status
    await db.update(releases)
      .set({
        status: 'scheduled',
        updated_at: new Date()
      })
      .where(eq(releases.id, releaseId));

    // Create scheduled distribution
    const insertResult = await db.insert(scheduledDistributions).values({
      release_id: releaseId,
      scheduled_date: scheduledDate,
      platforms: platforms,
      status: 'scheduled',
      created_by: userId
    }).returning();

    return insertResult[0];
  }

  /**
   * Initiates immediate distribution of a release
   * 
   * @param releaseId The ID of the release
   * @param userId The ID of the user initiating distribution
   * @param platforms Array of platform IDs to distribute to
   * @returns Array of distribution records
   */
  async distributeRelease(
    releaseId: number,
    userId: number,
    platforms: number[]
  ): Promise<DistributionRecord[]> {
    // Get release
    const release = await db.query.releases.findFirst({
      where: eq(releases.id, releaseId)
    });

    if (!release) {
      throw new Error(`Release with ID ${releaseId} not found`);
    }

    // Check release is ready for distribution
    if (release.status !== 'ready_for_distribution') {
      throw new Error(`Release must be in ready_for_distribution state to distribute`);
    }

    // Update release status
    await db.update(releases)
      .set({
        status: 'in_distribution',
        updated_at: new Date()
      })
      .where(eq(releases.id, releaseId));

    // Create distribution records
    const distributionRecords: DistributionRecord[] = [];

    for (const platformId of platforms) {
      const insertResult = await db.insert(distributionRecords).values({
        release_id: releaseId,
        platform_id: platformId,
        status: 'pending',
        submitted_at: new Date()
      }).returning();

      distributionRecords.push(insertResult[0]);
    }

    // Trigger distribution process
    this.processDistribution(releaseId, distributionRecords).catch(error => {
      console.error(`Error processing distribution for release ${releaseId}:`, error);
    });

    return distributionRecords;
  }

  /**
   * Processes distribution of a release
   * 
   * @param releaseId The ID of the release
   * @param records The distribution records
   */
  private async processDistribution(
    releaseId: number,
    records: DistributionRecord[]
  ): Promise<void> {
    // This would integrate with the Distribution System
    // Simplified implementation for documentation

    try {
      // Initialize distribution service
      const distributionService = new DistributionService();

      // Process each distribution record
      for (const record of records) {
        await distributionService.distributeContent(record.id);
      }

      // Check all distribution records
      const allRecords = await db.query.distributionRecords.findMany({
        where: eq(distributionRecords.release_id, releaseId)
      });

      // Calculate overall status
      const allDistributed = allRecords.every(
        record => record.status === 'distributed'
      );

      const anyFailed = allRecords.some(
        record => record.status === 'failed'
      );

      let releaseStatus: string;

      if (allDistributed) {
        releaseStatus = 'distributed';
      } else if (anyFailed) {
        releaseStatus = 'distribution_partially_failed';
      } else {
        releaseStatus = 'in_distribution';
      }

      // Update release status
      await db.update(releases)
        .set({
          status: releaseStatus,
          updated_at: new Date()
        })
        .where(eq(releases.id, releaseId));
    } catch (error) {
      // Update release status on error
      await db.update(releases)
        .set({
          status: 'distribution_failed',
          updated_at: new Date()
        })
        .where(eq(releases.id, releaseId));

      throw error;
    }
  }

  /**
   * Requests takedown of a release
   * 
   * @param releaseId The ID of the release
   * @param userId The ID of the user requesting takedown
   * @param reason The reason for takedown
   * @returns Updated release
   */
  async requestTakedown(
    releaseId: number,
    userId: number,
    reason: string
  ): Promise<Release> {
    // Get release
    const release = await db.query.releases.findFirst({
      where: eq(releases.id, releaseId)
    });

    if (!release) {
      throw new Error(`Release with ID ${releaseId} not found`);
    }

    // Check release is distributed
    if (release.status !== 'distributed' && 
        release.status !== 'distribution_partially_failed') {
      throw new Error(`Release must be in distributed or distribution_partially_failed state to request takedown`);
    }

    // Update release status
    const updateResult = await db.update(releases)
      .set({
        status: 'takedown_requested',
        updated_at: new Date()
      })
      .where(eq(releases.id, releaseId))
      .returning();

    // Mark distribution records for takedown
    await db.update(distributionRecords)
      .set({
        takedown_requested: true
      })
      .where(
        and(
          eq(distributionRecords.release_id, releaseId),
          eq(distributionRecords.status, 'distributed')
        )
      );

    // Create takedown record
    await db.insert(takedownRequests).values({
      release_id: releaseId,
      user_id: userId,
      reason: reason,
      status: 'pending'
    });

    // Trigger takedown process
    this.processTakedown(releaseId).catch(error => {
      console.error(`Error processing takedown for release ${releaseId}:`, error);
    });

    return updateResult[0];
  }

  /**
   * Processes takedown of a release
   * 
   * @param releaseId The ID of the release
   */
  private async processTakedown(releaseId: number): Promise<void> {
    // This would integrate with the Distribution System for takedowns
    // Simplified implementation for documentation

    try {
      // Initialize distribution service
      const distributionService = new DistributionService();

      // Get distribution records
      const records = await db.query.distributionRecords.findMany({
        where: and(
          eq(distributionRecords.release_id, releaseId),
          eq(distributionRecords.takedown_requested, true)
        )
      });

      // Process each takedown
      for (const record of records) {
        await distributionService.removeContent(record.id);
      }

      // Check all takedown records
      const allRecords = await db.query.distributionRecords.findMany({
        where: eq(distributionRecords.release_id, releaseId)
      });

      // Calculate overall status
      const allRemoved = allRecords.every(
        record => record.status === 'takedown_complete'
      );

      // Update release status
      if (allRemoved) {
        await db.update(releases)
          .set({
            status: 'removed',
            updated_at: new Date()
          })
          .where(eq(releases.id, releaseId));

        // Update takedown request
        await db.update(takedownRequests)
          .set({
            status: 'completed',
            completed_at: new Date()
          })
          .where(
            and(
              eq(takedownRequests.release_id, releaseId),
              eq(takedownRequests.status, 'pending')
            )
          );
      }
    } catch (error) {
      // Update takedown request on error
      await db.update(takedownRequests)
        .set({
          status: 'failed',
          error_details: error.message
        })
        .where(
          and(
            eq(takedownRequests.release_id, releaseId),
            eq(takedownRequests.status, 'pending')
          )
        );

      throw error;
    }
  }
}
```

### 3. Track Management

The track management system handles the lifecycle of tracks within releases.

#### Track Upload and Processing

```typescript
/**
 * Track management service
 */
class TrackManager {
  /**
   * Adds a track to a release
   * 
   * @param releaseId The ID of the release
   * @param userId The ID of the user adding the track
   * @param trackData The track data
   * @param audioFile The audio file
   * @returns The created track
   */
  async addTrack(
    releaseId: number,
    userId: number,
    trackData: Omit<InsertTrack, 'id' | 'user_id' | 'release_id' | 'audio_url' | 'created_at' | 'updated_at'>,
    audioFile: Express.Multer.File
  ): Promise<Track> {
    // Get release
    const release = await db.query.releases.findFirst({
      where: eq(releases.id, releaseId)
    });

    if (!release) {
      throw new Error(`Release with ID ${releaseId} not found`);
    }

    // Check release is in editable state
    if (release.status !== 'draft' && release.status !== 'validation_failed') {
      throw new Error(`Cannot add tracks to a release in ${release.status} state`);
    }

    // Process audio file
    const audioProcessor = new AudioProcessor();
    const processingResult = await audioProcessor.processAudio(audioFile);

    // Calculate track number if not provided
    let trackNumber = trackData.track_number;
    if (!trackNumber) {
      const existingTracks = await db.query.tracks.findMany({
        where: eq(tracks.release_id, releaseId),
        orderBy: [desc(tracks.track_number)]
      });

      trackNumber = existingTracks.length > 0
        ? existingTracks[0].track_number + 1
        : 1;
    }

    // Create track
    const insertResult = await db.insert(tracks).values({
      ...trackData,
      release_id: releaseId,
      user_id: userId,
      audio_url: processingResult.audioUrl,
      duration: processingResult.duration,
      track_number: trackNumber
    }).returning();

    // Generate AI analysis for track
    this.generateTrackAnalysis(insertResult[0].id).catch(error => {
      console.error(`Error generating analysis for track ${insertResult[0].id}:`, error);
    });

    return insertResult[0];
  }

  /**
   * Updates a track
   * 
   * @param trackId The ID of the track
   * @param updateData The track data to update
   * @param audioFile Optional audio file to replace
   * @returns The updated track
   */
  async updateTrack(
    trackId: number,
    updateData: Partial<Omit<Track, 'id' | 'release_id' | 'user_id' | 'created_at' | 'updated_at'>>,
    audioFile?: Express.Multer.File
  ): Promise<Track> {
    // Get track
    const track = await db.query.tracks.findFirst({
      where: eq(tracks.id, trackId),
      with: {
        release: true
      }
    });

    if (!track) {
      throw new Error(`Track with ID ${trackId} not found`);
    }

    // Check release is in editable state
    if (track.release.status !== 'draft' && track.release.status !== 'validation_failed') {
      throw new Error(`Cannot update tracks for a release in ${track.release.status} state`);
    }

    // Process audio file if provided
    let audioUrl = track.audio_url;
    let duration = track.duration;

    if (audioFile) {
      const audioProcessor = new AudioProcessor();
      const processingResult = await audioProcessor.processAudio(audioFile);

      audioUrl = processingResult.audioUrl;
      duration = processingResult.duration;
    }

    // Update track
    const updateResult = await db.update(tracks)
      .set({
        ...updateData,
        audio_url: audioFile ? audioUrl : track.audio_url,
        duration: audioFile ? duration : track.duration,
        updated_at: new Date()
      })
      .where(eq(tracks.id, trackId))
      .returning();

    // If significant changes, regenerate AI analysis
    if (audioFile || updateData.title || updateData.artist_name) {
      this.generateTrackAnalysis(trackId).catch(error => {
        console.error(`Error regenerating analysis for track ${trackId}:`, error);
      });
    }

    return updateResult[0];
  }

  /**
   * Removes a track from a release
   * 
   * @param trackId The ID of the track
   * @returns Whether the track was removed
   */
  async removeTrack(trackId: number): Promise<boolean> {
    // Get track
    const track = await db.query.tracks.findFirst({
      where: eq(tracks.id, trackId),
      with: {
        release: true
      }
    });

    if (!track) {
      throw new Error(`Track with ID ${trackId} not found`);
    }

    // Check release is in editable state
    if (track.release.status !== 'draft' && track.release.status !== 'validation_failed') {
      throw new Error(`Cannot remove tracks from a release in ${track.release.status} state`);
    }

    // Delete track
    await db.delete(tracks)
      .where(eq(tracks.id, trackId));

    // Reorder remaining tracks
    if (track.release_id) {
      await this.reorderTracksAfterRemoval(track.release_id, track.track_number);
    }

    return true;
  }

  /**
   * Reorders tracks after removal
   * 
   * @param releaseId The ID of the release
   * @param removedTrackNumber The track number that was removed
   */
  private async reorderTracksAfterRemoval(
    releaseId: number,
    removedTrackNumber: number
  ): Promise<void> {
    // Get tracks that need reordering
    const tracksToReorder = await db.query.tracks.findMany({
      where: and(
        eq(tracks.release_id, releaseId),
        gt(tracks.track_number, removedTrackNumber)
      ),
      orderBy: [asc(tracks.track_number)]
    });

    // Update track numbers
    for (const track of tracksToReorder) {
      await db.update(tracks)
        .set({
          track_number: track.track_number - 1
        })
        .where(eq(tracks.id, track.id));
    }
  }

  /**
   * Generates AI analysis for a track
   * 
   * @param trackId The ID of the track
   */
  private async generateTrackAnalysis(trackId: number): Promise<void> {
    // Get track
    const track = await db.query.tracks.findFirst({
      where: eq(tracks.id, trackId)
    });

    if (!track) {
      throw new Error(`Track with ID ${trackId} not found`);
    }

    // Initialize AI service
    const aiService = new AIService();

    // Generate analysis
    const analysis = await aiService.analyzeAudioContent(trackId);

    // Update track with analysis
    await db.update(tracks)
      .set({
        ai_analysis: analysis
      })
      .where(eq(tracks.id, trackId));
  }
}
```

#### Audio Processing

```typescript
/**
 * Audio processing service
 */
class AudioProcessor {
  /**
   * Processes an uploaded audio file
   * 
   * @param file The uploaded file
   * @returns Processing result with URL and metadata
   */
  async processAudio(file: Express.Multer.File): Promise<{
    audioUrl: string;
    duration: number;
    format: string;
    sampleRate: number;
    bitDepth: number;
    channels: number;
    metadata: AudioMetadata;
  }> {
    // File storage path
    const uploadDir = path.join(process.cwd(), 'uploads', 'audio');
    await fs.promises.mkdir(uploadDir, { recursive: true });

    // Generate unique filename
    const filename = `${Date.now()}_${path.basename(file.originalname)}`;
    const filePath = path.join(uploadDir, filename);

    // Save file
    await fs.promises.writeFile(filePath, file.buffer);

    // Extract audio metadata using third-party library
    // (Simplified for documentation)
    const metadata = {
      format: 'wav',
      sampleRate: 44100,
      bitDepth: 16,
      channels: 2,
      duration: 180, // in seconds
      bitrate: 1411,
      fileSize: file.size,
      codec: 'PCM',
      checksum: 'md5-hash-would-go-here'
    };

    // Return processing result
    return {
      audioUrl: `/uploads/audio/${filename}`,
      duration: metadata.duration,
      format: metadata.format,
      sampleRate: metadata.sampleRate,
      bitDepth: metadata.bitDepth,
      channels: metadata.channels,
      metadata
    };
  }

  /**
   * Generates alternative formats for a track
   * 
   * @param trackId The ID of the track
   * @returns Object with URLs to alternative formats
   */
  async generateAlternativeFormats(trackId: number): Promise<{
    mp3: string;
    aac: string;
    ogg: string;
  }> {
    // Get track
    const track = await db.query.tracks.findFirst({
      where: eq(tracks.id, trackId)
    });

    if (!track) {
      throw new Error(`Track with ID ${trackId} not found`);
    }

    // Get original file path
    const originalPath = path.join(process.cwd(), track.audio_url);

    // Destination directory
    const destDir = path.join(process.cwd(), 'uploads', 'audio', 'formats', `track_${trackId}`);
    await fs.promises.mkdir(destDir, { recursive: true });

    // Generate file paths
    const mp3Path = path.join(destDir, 'track.mp3');
    const aacPath = path.join(destDir, 'track.aac');
    const oggPath = path.join(destDir, 'track.ogg');

    // Convert to different formats
    // (In a real implementation, this would use something like ffmpeg)

    // Return URLs to alternative formats
    return {
      mp3: `/uploads/audio/formats/track_${trackId}/track.mp3`,
      aac: `/uploads/audio/formats/track_${trackId}/track.aac`,
      ogg: `/uploads/audio/formats/track_${trackId}/track.ogg`
    };
  }
}
```

### 4. Asset Management

The asset management system handles artwork and other assets associated with releases.

#### Artwork Management

```typescript
/**
 * Asset management service
 */
class AssetManager {
  /**
   * Uploads artwork for a release
   * 
   * @param releaseId The ID of the release
   * @param file The uploaded file
   * @returns Object with artwork URL and metadata
   */
  async uploadArtwork(
    releaseId: number,
    file: Express.Multer.File
  ): Promise<{
    artworkUrl: string;
    metadata: ArtworkMetadata;
  }> {
    // Get release
    const release = await db.query.releases.findFirst({
      where: eq(releases.id, releaseId)
    });

    if (!release) {
      throw new Error(`Release with ID ${releaseId} not found`);
    }

    // Check release is in editable state
    if (release.status !== 'draft' && release.status !== 'validation_failed') {
      throw new Error(`Cannot update artwork for a release in ${release.status} state`);
    }

    // Validate image file
    if (!file.mimetype.startsWith('image/')) {
      throw new Error('File must be an image');
    }

    // Process image
    const processor = new ImageProcessor();
    const result = await processor.processArtwork(file);

    // Update release with artwork URL
    await db.update(releases)
      .set({
        cover_art_url: result.artworkUrl,
        updated_at: new Date()
      })
      .where(eq(releases.id, releaseId));

    return result;
  }

  /**
   * Generates alternative artwork sizes
   * 
   * @param releaseId The ID of the release
   * @returns Object with URLs to alternative sizes
   */
  async generateArtworkVariants(releaseId: number): Promise<{
    original: string;
    thumbnails: {
      small: string;
      medium: string;
      large: string;
    };
  }> {
    // Get release
    const release = await db.query.releases.findFirst({
      where: eq(releases.id, releaseId)
    });

    if (!release || !release.cover_art_url) {
      throw new Error(`Release with ID ${releaseId} not found or has no artwork`);
    }

    // Process image variants
    const processor = new ImageProcessor();
    return processor.generateArtworkVariants(release.cover_art_url, releaseId);
  }
}

/**
 * Image processing service
 */
class ImageProcessor {
  /**
   * Processes uploaded artwork
   * 
   * @param file The uploaded file
   * @returns Processing result with URL and metadata
   */
  async processArtwork(file: Express.Multer.File): Promise<{
    artworkUrl: string;
    metadata: ArtworkMetadata;
  }> {
    // File storage path
    const uploadDir = path.join(process.cwd(), 'uploads', 'artwork');
    await fs.promises.mkdir(uploadDir, { recursive: true });

    // Generate unique filename
    const filename = `${Date.now()}_${path.basename(file.originalname)}`;
    const filePath = path.join(uploadDir, filename);

    // Save file
    await fs.promises.writeFile(filePath, file.buffer);

    // Extract image metadata
    // (Simplified for documentation)
    const dimensions = { width: 3000, height: 3000 };
    const resolution = 300; // DPI
    const format = 'jpeg';

    // Generate metadata
    const metadata: ArtworkMetadata = {
      dimensions,
      resolution,
      fileSize: file.size,
      format,
      colorSpace: 'RGB',
      primaryColors: ['#FFFFFF', '#000000'],
      hasParentalAdvisoryLabel: false,
      versions: [
        {
          url: `/uploads/artwork/${filename}`,
          purpose: 'cover',
          dimensions
        }
      ]
    };

    return {
      artworkUrl: `/uploads/artwork/${filename}`,
      metadata
    };
  }

  /**
   * Generates artwork variants
   * 
   * @param originalUrl URL to the original artwork
   * @param releaseId The ID of the release
   * @returns Object with URLs to variants
   */
  async generateArtworkVariants(
    originalUrl: string,
    releaseId: number
  ): Promise<{
    original: string;
    thumbnails: {
      small: string;
      medium: string;
      large: string;
    };
  }> {
    // Original file path
    const originalPath = path.join(process.cwd(), originalUrl);

    // Destination directory
    const destDir = path.join(process.cwd(), 'uploads', 'artwork', 'variants', `release_${releaseId}`);
    await fs.promises.mkdir(destDir, { recursive: true });

    // Generate file paths
    const smallPath = path.join(destDir, 'small.jpg');
    const mediumPath = path.join(destDir, 'medium.jpg');
    const largePath = path.join(destDir, 'large.jpg');

    // Generate variants
    // (In a real implementation, this would use something like sharp)

    // Return URLs to variants
    return {
      original: originalUrl,
      thumbnails: {
        small: `/uploads/artwork/variants/release_${releaseId}/small.jpg`,
        medium: `/uploads/artwork/variants/release_${releaseId}/medium.jpg`,
        large: `/uploads/artwork/variants/release_${releaseId}/large.jpg`
      }
    };
  }
}
```

### 5. Validation and Approval System

The validation system ensures releases meet quality and metadata requirements.

#### Release Validator

```typescript
/**
 * Release validation service
 */
class ReleaseValidator {
  /**
   * Validates a complete release
   * 
   * @param release The release to validate
   * @returns Validation result
   */
  async validateRelease(release: Release & { tracks: Track[] }): Promise<{
    valid: boolean;
    errors: ValidationError[];
    warnings: ValidationWarning[];
    trackResults: Record<number, {
      valid: boolean;
      errors: ValidationError[];
      warnings: ValidationWarning[];
    }>;
  }> {
    // Validate release metadata
    const metadataResult = await this.validateReleaseMetadata(release);

    // Validate artwork
    const artworkResult = await this.validateArtwork(release);

    // Validate tracks
    const trackResults: Record<number, any> = {};
    let allTracksValid = true;

    for (const track of release.tracks) {
      const trackResult = await this.validateTrack(track);
      trackResults[track.id] = trackResult;

      if (!trackResult.valid) {
        allTracksValid = false;
      }
    }

    // Validate track collection (cross-track validation)
    const collectionResult = this.validateTrackCollection(release.tracks);

    // Aggregate all errors and warnings
    const errors = [
      ...metadataResult.errors,
      ...artworkResult.errors,
      ...collectionResult.errors
    ];

    const warnings = [
      ...metadataResult.warnings,
      ...artworkResult.warnings,
      ...collectionResult.warnings
    ];

    // Determine overall validity
    const valid = errors.length === 0 && allTracksValid;

    return {
      valid,
      errors,
      warnings,
      trackResults
    };
  }

  /**
   * Validates release metadata
   * 
   * @param release The release to validate
   * @returns Validation result
   */
  private async validateReleaseMetadata(release: Release): Promise<{
    valid: boolean;
    errors: ValidationError[];
    warnings: ValidationWarning[];
  }> {
    const errors: ValidationError[] = [];
    const warnings: ValidationWarning[] = [];

    // Required fields
    if (!release.title || release.title.trim() === '') {
      errors.push({
        field: 'title',
        message: 'Title is required'
      });
    }

    if (!release.artist_name || release.artist_name.trim() === '') {
      errors.push({
        field: 'artist_name',
        message: 'Artist name is required'
      });
    }

    if (!release.release_date) {
      errors.push({
        field: 'release_date',
        message: 'Release date is required'
      });
    }

    // Future release date check
    if (release.release_date && new Date(release.release_date) < new Date()) {
      warnings.push({
        field: 'release_date',
        message: 'Release date is in the past'
      });
    }

    // UPC validation
    if (release.upc) {
      if (!isValidUPC(release.upc)) {
        errors.push({
          field: 'upc',
          message: 'UPC is not valid'
        });
      }
    } else {
      warnings.push({
        field: 'upc',
        message: 'UPC is recommended for optimal distribution'
      });
    }

    // Genre validation
    const genreValidator = new GenreValidator();
    if (!genreValidator.isValidGenre(release.genre)) {
      errors.push({
        field: 'genre',
        message: `"${release.genre}" is not a valid genre`
      });
    }

    // Extended validation for JSONB metadata
    if (release.metadata) {
      const metadataResult = this.validateExtendedMetadata(release.metadata);
      errors.push(...metadataResult.errors);
      warnings.push(...metadataResult.warnings);
    }

    return {
      valid: errors.length === 0,
      errors,
      warnings
    };
  }

  /**
   * Validates artwork
   * 
   * @param release The release to validate
   * @returns Validation result
   */
  private async validateArtwork(release: Release): Promise<{
    valid: boolean;
    errors: ValidationError[];
    warnings: ValidationWarning[];
  }> {
    const errors: ValidationError[] = [];
    const warnings: ValidationWarning[] = [];

    // Check artwork exists
    if (!release.cover_art_url) {
      errors.push({
        field: 'cover_art_url',
        message: 'Cover art is required'
      });

      return {
        valid: false,
        errors,
        warnings
      };
    }

    // Validate artwork file
    try {
      const filePath = path.join(process.cwd(), release.cover_art_url);

      // Check file exists
      const fileExists = await fs.promises.access(filePath)
        .then(() => true)
        .catch(() => false);

      if (!fileExists) {
        errors.push({
          field: 'cover_art_url',
          message: 'Cover art file not found'
        });

        return {
          valid: false,
          errors,
          warnings
        };
      }

      // In real implementation, would check:
      // - Image dimensions
      // - Resolution
      // - File format
      // - File size

      // Add warnings for non-optimal artwork
      if (release.metadata?.artwork?.dimensions?.width < 3000) {
        warnings.push({
          field: 'cover_art',
          message: 'Cover art resolution is below recommended 3000x3000 pixels'
        });
      }
    } catch (error) {
      errors.push({
        field: 'cover_art_url',
        message: 'Error validating cover art: ' + error.message
      });
    }

    return {
      valid: errors.length === 0,
      errors,
      warnings
    };
  }

  /**
   * Validates a track
   * 
   * @param track The track to validate
   * @returns Validation result
   */
  private async validateTrack(track: Track): Promise<{
    valid: boolean;
    errors: ValidationError[];
    warnings: ValidationWarning[];
  }> {
    const errors: ValidationError[] = [];
    const warnings: ValidationWarning[] = [];

    // Required fields
    if (!track.title || track.title.trim() === '') {
      errors.push({
        field: 'title',
        message: 'Title is required'
      });
    }

    if (!track.artist_name || track.artist_name.trim() === '') {
      errors.push({
        field: 'artist_name',
        message: 'Artist name is required'
      });
    }

    // ISRC validation
    if (track.isrc) {
      if (!isValidISRC(track.isrc)) {
        errors.push({
          field: 'isrc',
          message: 'ISRC is not valid'
        });
      }
    } else {
      warnings.push({
        field: 'isrc',
        message: 'ISRC is recommended for optimal distribution'
      });
    }

    // Audio file validation
    try {
      const filePath = path.join(process.cwd(), track.audio_url);

      // Check file exists
      const fileExists = await fs.promises.access(filePath)
        .then(() => true)
        .catch(() => false);

      if (!fileExists) {
        errors.push({
          field: 'audio_url',
          message: 'Audio file not found'
        });
      }

      // In real implementation, would check:
      // - Audio format
      // - Sample rate
      // - Bit depth
      // - Duration

      // Add warnings for non-optimal audio
      if (track.audio_format !== 'wav' && track.audio_format !== 'flac') {
        warnings.push({
          field: 'audio_format',
          message: 'Audio format is not lossless (WAV or FLAC)'
        });
      }
    } catch (error) {
      errors.push({
        field: 'audio_url',
        message: 'Error validating audio: ' + error.message
      });
    }

    // Extended validation for JSONB metadata
    if (track.metadata) {
      const metadataResult = this.validateTrackMetadata(track.metadata);
      errors.push(...metadataResult.errors);
      warnings.push(...metadataResult.warnings);
    }

    return {
      valid: errors.length === 0,
      errors,
      warnings
    };
  }

  /**
   * Validates a collection of tracks
   * 
   * @param tracks The tracks to validate
   * @returns Validation result
   */
  private validateTrackCollection(tracks: Track[]): Promise<{
    valid: boolean;
    errors: ValidationError[];
    warnings: ValidationWarning[];
  }> {
    const errors: ValidationError[] = [];
    const warnings: ValidationWarning[] = [];

    // Check track count
    if (tracks.length === 0) {
      errors.push({
        field: 'tracks',
        message: 'At least one track is required'
      });

      return {
        valid: false,
        errors,
        warnings
      };
    }

    // Check for duplicate track numbers
    const trackNumbers = tracks.map(track => track.track_number);
    const uniqueTrackNumbers = new Set(trackNumbers);

    if (uniqueTrackNumbers.size !== tracks.length) {
      errors.push({
        field: 'tracks',
        message: 'Duplicate track numbers detected'
      });
    }

    // Check for duplicate track titles
    const trackTitles = tracks.map(track => track.title);
    const titleCounts = trackTitles.reduce((acc, title) => {
      acc[title] = (acc[title] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    const duplicateTitles = Object.entries(titleCounts)
      .filter(([_, count]) => count > 1)
      .map(([title]) => title);

    if (duplicateTitles.length > 0) {
      warnings.push({
        field: 'tracks',
        message: `Duplicate track titles detected: ${duplicateTitles.join(', ')}`
      });
    }

    // Check for sequential track numbers
    const sortedTrackNumbers = [...trackNumbers].sort((a, b) => a - b);
    let isSequential = true;

    for (let i = 0; i < sortedTrackNumbers.length; i++) {
      if (sortedTrackNumbers[i] !== i + 1) {
        isSequential = false;
        break;
      }
    }

    if (!isSequential) {
      warnings.push({
        field: 'tracks',
        message: 'Track numbers are not sequential starting from 1'
      });
    }

    // Check for consistent audio formats
    const audioFormats = new Set(tracks.map(track => track.audio_format));

    if (audioFormats.size > 1) {
      warnings.push({
        field: 'tracks',
        message: 'Inconsistent audio formats across tracks'
      });
    }

    return {
      valid: errors.length === 0,
      errors,
      warnings
    };
  }

  /**
   * Validates extended metadata
   * 
   * @param metadata The metadata to validate
   * @returns Validation result
   */
  private validateExtendedMetadata(metadata: any): {
    valid: boolean;
    errors: ValidationError[];
    warnings: ValidationWarning[];
  } {
    const errors: ValidationError[] = [];
    const warnings: ValidationWarning[] = [];

    // Validate release metadata fields
    if (metadata.album_information) {
      // Label validation
      if (!metadata.album_information.label_name) {
        warnings.push({
          field: 'metadata.album_information.label_name',
          message: 'Label name is recommended for optimal distribution'
        });
      }

      // Original release date validation
      if (metadata.album_information.original_release_date) {
        const originalDate = new Date(metadata.album_information.original_release_date);
        if (isNaN(originalDate.getTime())) {
          errors.push({
            field: 'metadata.album_information.original_release_date',
            message: 'Invalid date format'
          });
        }
      }
    }

    // Rights validation
    if (metadata.rights) {
      // Copyright validation
      if (!metadata.rights.copyright_owner) {
        warnings.push({
          field: 'metadata.rights.copyright_owner',
          message: 'Copyright owner is recommended for optimal distribution'
        });
      }

      if (!metadata.rights.copyright_year) {
        warnings.push({
          field: 'metadata.rights.copyright_year',
          message: 'Copyright year is recommended for optimal distribution'
        });
      }

      // Territory validation
      if (metadata.rights.territorial_restrictions) {
        const validTerritories = new Set([
          'US', 'GB', 'CA', 'AU', 'DE', 'FR', 'JP', 'BR', 'MX', 'NL'
          // More territories would be included in a real implementation
        ]);

        for (const territory of metadata.rights.territorial_restrictions) {
          if (!validTerritories.has(territory)) {
            warnings.push({
              field: 'metadata.rights.territorial_restrictions',
              message: `Unknown territory code: ${territory}`
            });
          }
        }
      }
    }

    return {
      valid: errors.length === 0,
      errors,
      warnings
    };
  }

  /**
   * Validates track metadata
   * 
   * @param metadata The metadata to validate
   * @returns Validation result
   */
  private validateTrackMetadata(metadata: any): {
    valid: boolean;
    errors: ValidationError[];
    warnings: ValidationWarning[];
  } {
    const errors: ValidationError[] = [];
    const warnings: ValidationWarning[] = [];

    // Musical attributes validation
    if (metadata.musical_attributes) {
      // BPM validation
      if (metadata.musical_attributes.bpm) {
        const bpm = Number(metadata.musical_attributes.bpm);
        if (isNaN(bpm) || bpm <= 0 || bpm > 300) {
          errors.push({
            field: 'metadata.musical_attributes.bpm',
            message: 'BPM must be a number between 1 and 300'
          });
        }
      }

      // Key validation
      if (metadata.musical_attributes.key) {
        const validKeys = new Set([
          'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B',
          'Cm', 'C#m', 'Dm', 'D#m', 'Em', 'Fm', 'F#m', 'Gm', 'G#m', 'Am', 'A#m', 'Bm'
        ]);

        if (!validKeys.has(metadata.musical_attributes.key)) {
          warnings.push({
            field: 'metadata.musical_attributes.key',
            message: `Unknown musical key: ${metadata.musical_attributes.key}`
          });
        }
      }
    }

    // Credits validation
    if (metadata.credits) {
      // Composers validation
      if (!metadata.credits.composers || metadata.credits.composers.length === 0) {
        warnings.push({
          field: 'metadata.credits.composers',
          message: 'Composer information is recommended for optimal distribution'
        });
      }

      // Lyrics validation
      if (metadata.lyrics_composition?.full_lyrics) {
        if (metadata.lyrics_composition.full_lyrics.length < 10) {
          warnings.push({
            field: 'metadata.lyrics_composition.full_lyrics',
            message: 'Lyrics appear to be very short'
          });
        }
      } else if (!metadata.musical_attributes?.instrumental) {
        warnings.push({
          field: 'metadata.lyrics_composition.full_lyrics',
          message: 'Lyrics are recommended for non-instrumental tracks'
        });
      }
    }

    return {
      valid: errors.length === 0,
      errors,
      warnings
    };
  }
}
```

### 6. Integration with Distribution System

The release management system integrates with the distribution system for content delivery.

#### Distribution Integration

```typescript
/**
 * Distribution integration service
 */
class DistributionIntegration {
  /**
   * Prepares a release for distribution
   * 
   * @param releaseId The ID of the release
   * @returns Distribution preparation result
   */
  async prepareReleaseForDistribution(releaseId: number): Promise<{
    release: Release;
    tracks: Track[];
    assets: {
      artwork: string;
      audioFiles: string[];
    };
    metadata: any;
  }> {
    // Get release with tracks
    const release = await db.query.releases.findFirst({
      where: eq(releases.id, releaseId),
      with: {
        tracks: {
          orderBy: [asc(tracks.track_number)]
        }
      }
    });

    if (!release) {
      throw new Error(`Release with ID ${releaseId} not found`);
    }

    // Check release is ready for distribution
    if (release.status !== 'ready_for_distribution' && 
        release.status !== 'scheduled' &&
        release.status !== 'in_distribution') {
      throw new Error(`Release is not ready for distribution: ${release.status}`);
    }

    // Collect all assets
    const assets = {
      artwork: release.cover_art_url,
      audioFiles: release.tracks.map(track => track.audio_url)
    };

    // Prepare complete metadata package
    const metadata = this.prepareDistributionMetadata(release, release.tracks);

    return {
      release,
      tracks: release.tracks,
      assets,
      metadata
    };
  }

  /**
   * Prepares distribution metadata
   * 
   * @param release The release
   * @param tracks The tracks
   * @returns Prepared metadata
   */
  private prepareDistributionMetadata(
    release: Release,
    tracks: Track[]
  ): any {
    // Base metadata
    const metadata = {
      release: {
        title: release.title,
        artist: release.artist_name,
        releaseDate: release.release_date,
        type: release.type,
        upc: release.upc,
        genre: release.genre,
        language: release.language,
        territories: release.territories,
        artwork: release.cover_art_url
      },
      tracks: tracks.map(track => ({
        title: track.title,
        artist: track.artist_name,
        isrc: track.isrc,
        audioFile: track.audio_url,
        duration: track.duration,
        trackNumber: track.track_number,
        format: track.audio_format,
        explicit: track.explicit_content
      }))
    };

    // Add extended metadata
    if (release.metadata) {
      metadata.release.extended = release.metadata;
    }

    // Add track extended metadata
    for (let i = 0; i < tracks.length; i++) {
      if (tracks[i].metadata) {
        metadata.tracks[i].extended = tracks[i].metadata;
      }

      if (tracks[i].credits) {
        metadata.tracks[i].credits = tracks[i].credits;
      }
    }

    return metadata;
  }

  /**
   * Updates release status based on distribution status
   * 
   * @param releaseId The ID of the release
   * @returns Updated release status
   */
  async updateReleaseStatusFromDistribution(releaseId: number): Promise<string> {
    // Get all distribution records for the release
    const records = await db.query.distributionRecords.findMany({
      where: eq(distributionRecords.release_id, releaseId)
    });

    if (records.length === 0) {
      return 'unchanged';
    }

    // Calculate overall status
    const allDistributed = records.every(
      record => record.status === 'distributed'
    );

    const anyFailed = records.some(
      record => record.status === 'failed'
    );

    const allFailed = records.every(
      record => record.status === 'failed'
    );

    const someProcessing = records.some(
      record => ['pending', 'processing'].includes(record.status)
    );

    let newStatus: string;

    if (allDistributed) {
      newStatus = 'distributed';
    } else if (allFailed) {
      newStatus = 'distribution_failed';
    } else if (anyFailed && !someProcessing) {
      newStatus = 'distribution_partially_failed';
    } else if (someProcessing) {
      newStatus = 'in_distribution';
    } else {
      return 'unchanged';
    }

    // Update release status
    await db.update(releases)
      .set({
        status: newStatus,
        updated_at: new Date()
      })
      .where(eq(releases.id, releaseId));

    return newStatus;
  }
}
```

### 7. API Endpoints

#### Release Management API

```typescript
/**
 * Register release management API routes
 */
export function registerReleaseRoutes(app: Express): void {
  const workflowManager = new ReleaseWorkflowManager();
  const trackManager = new TrackManager();
  const assetManager = new AssetManager();
  const validator = new ReleaseValidator();

  // Multer setup for file uploads
  const storage = multer.memoryStorage();
  const upload = multer({ storage: storage });

  /**
   * Get all releases for the authenticated user
   */
  app.get('/api/releases', requireAuth, async (req: Request, res: Response) => {
    try {
      const userId = req.userId;
      const { status, page = '1', limit = '20' } = req.query;

      const pageNum = parseInt(page as string);
      const limitNum = parseInt(limit as string);
      const offset = (pageNum - 1) * limitNum;

      let query = db.select()
        .from(releases)
        .where(eq(releases.user_id, userId))
        .limit(limitNum)
        .offset(offset);

      if (status) {
        query = query.where(eq(releases.status, status as string));
      }

      const results = await query;

      // Get total count for pagination
      const countQuery = db.select({ count: sql<number>`count(*)` })
        .from(releases)
        .where(eq(releases.user_id, userId));

      if (status) {
        countQuery.where(eq(releases.status, status as string));
      }

      const countResult = await countQuery;
      const total = countResult[0].count;

      return res.status(200).json({
        success: true,
        data: results,
        pagination: {
          total,
          page: pageNum,
          limit: limitNum,
          pages: Math.ceil(total / limitNum)
        }
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to get releases'
      });
    }
  });

  /**
   * Get a specific release
   */
  app.get('/api/releases/:id', requireAuth, async (req: Request, res: Response) => {
    try {
      const releaseId = parseInt(req.params.id);
      const userId = req.userId;

      const release = await db.query.releases.findFirst({
        where: and(
          eq(releases.id, releaseId),
          eq(releases.user_id, userId)
        ),
        with: {
          tracks: {
            orderBy: [asc(tracks.track_number)]
          }
        }
      });

      if (!release) {
        return res.status(404).json({
          success: false,
          message: 'Release not found'
        });
      }

      return res.status(200).json({
        success: true,
        data: release
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to get release'
      });
    }
  });

  /**
   * Create a new release
   */
  app.post('/api/releases', requireAuth, async (req: Request, res: Response) => {
    try {
      const userId = req.userId;
      const releaseData = req.body;

      const newRelease = await workflowManager.createRelease(userId, releaseData);

      return res.status(201).json({
        success: true,
        data: newRelease
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to create release'
      });
    }
  });

  /**
   * Update a release
   */
  app.put('/api/releases/:id', requireAuth, async (req: Request, res: Response) => {
    try {
      const releaseId = parseInt(req.params.id);
      const userId = req.userId;
      const updateData = req.body;

      // Get release
      const release = await db.query.releases.findFirst({
        where: and(
          eq(releases.id, releaseId),
          eq(releases.user_id, userId)
        )
      });

      if (!release) {
        return res.status(404).json({
          success: false,
          message: 'Release not found'
        });
      }

      // Check release is in editable state
      if (release.status !== 'draft' && release.status !== 'validation_failed') {
        return res.status(400).json({
          success: false,
          message: `Cannot update a release in ${release.status} state`
        });
      }

      // Update release
      const updatedRelease = await db.update(releases)
        .set({
          ...updateData,
          updated_at: new Date()
        })
        .where(and(
          eq(releases.id, releaseId),
          eq(releases.user_id, userId)
        ))
        .returning();

      return res.status(200).json({
        success: true,
        data: updatedRelease[0]
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to update release'
      });
    }
  });

  /**
   * Submit a release for validation
   */
  app.post('/api/releases/:id/validate', requireAuth, async (req: Request, res: Response) => {
    try {
      const releaseId = parseInt(req.params.id);
      const userId = req.userId;

      const updatedRelease = await workflowManager.submitForValidation(releaseId, userId);

      return res.status(200).json({
        success: true,
        data: updatedRelease,
        message: 'Release submitted for validation'
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to submit release for validation'
      });
    }
  });

  /**
   * Upload release artwork
   */
  app.post('/api/releases/:id/artwork', requireAuth, upload.single('artwork'), async (req: Request, res: Response) => {
    try {
      const releaseId = parseInt(req.params.id);
      const file = req.file;

      if (!file) {
        return res.status(400).json({
          success: false,
          message: 'No file uploaded'
        });
      }

      const result = await assetManager.uploadArtwork(releaseId, file);

      return res.status(200).json({
        success: true,
        data: result
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to upload artwork'
      });
    }
  });

  /**
   * Add track to release
   */
  app.post('/api/releases/:id/tracks', requireAuth, upload.single('audio'), async (req: Request, res: Response) => {
    try {
      const releaseId = parseInt(req.params.id);
      const userId = req.userId;
      const trackData = JSON.parse(req.body.data);
      const file = req.file;

      if (!file) {
        return res.status(400).json({
          success: false,
          message: 'No audio file uploaded'
        });
      }

      const track = await trackManager.addTrack(releaseId, userId, trackData, file);

      return res.status(201).json({
        success: true,
        data: track
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to add track'
      });
    }
  });

  /**
   * Update track
   */
  app.put('/api/tracks/:id', requireAuth, upload.single('audio'), async (req: Request, res: Response) => {
    try {
      const trackId = parseInt(req.params.id);
      const updateData = JSON.parse(req.body.data);
      const file = req.file;

      const track = await trackManager.updateTrack(trackId, updateData, file);

      return res.status(200).json({
        success: true,
        data: track
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to update track'
      });
    }
  });

  /**
   * Remove track
   */
  app.delete('/api/tracks/:id', requireAuth, async (req: Request, res: Response) => {
    try {
      const trackId = parseInt(req.params.id);

      await trackManager.removeTrack(trackId);

      return res.status(200).json({
        success: true,
        message: 'Track removed successfully'
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to remove track'
      });
    }
  });

  /**
   * Schedule release distribution
   */
  app.post('/api/releases/:id/schedule', requireAuth, async (req: Request, res: Response) => {
    try {
      const releaseId = parseInt(req.params.id);
      const userId = req.userId;
      const { scheduledDate, platforms } = req.body;

      if (!scheduledDate || !platforms || !Array.isArray(platforms)) {
        return res.status(400).json({
          success: false,
          message: 'Scheduled date and platforms array are required'
        });
      }

      const result = await workflowManager.scheduleRelease(
        releaseId,
        userId,
        new Date(scheduledDate),
        platforms
      );

      return res.status(200).json({
        success: true,
        data: result,
        message: 'Release scheduled successfully'
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to schedule release'
      });
    }
  });

  /**
   * Initiate immediate distribution
   */
  app.post('/api/releases/:id/distribute', requireAuth, async (req: Request, res: Response) => {
    try {
      const releaseId = parseInt(req.params.id);
      const userId = req.userId;
      const { platforms } = req.body;

      if (!platforms || !Array.isArray(platforms)) {
        return res.status(400).json({
          success: false,
          message: 'Platforms array is required'
        });
      }

      const results = await workflowManager.distributeRelease(
        releaseId,
        userId,
        platforms
      );

      return res.status(200).json({
        success: true,
        data: results,
        message: 'Distribution process initiated'
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to distribute release'
      });
    }
  });

  /**
   * Request takedown
   */
  app.post('/api/releases/:id/takedown', requireAuth, async (req: Request, res: Response) => {
    try {
      const releaseId = parseInt(req.params.id);
      const userId = req.userId;
      const { reason } = req.body;

      if (!reason) {
        return res.status(400).json({
          success: false,
          message: 'Reason for takedown is required'
        });
      }

      const result = await workflowManager.requestTakedown(
        releaseId,
        userId,
        reason
      );

      return res.status(200).json({
        success: true,
        data: result,
        message: 'Takedown request submitted'
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to request takedown'
      });
    }
  });
}
```

### 8. Best Practices for Release Management

1. **Clear State Transitions**: Define clear rules for when releases can transition from one state to another.

2. **Comprehensive Validation**: Implement thorough validation to prevent distribution issues.

3. **Versioning**: Keep track of changes to releases and tracks.

4. **Asset Management**: Securely manage and validate all assets associated with releases.

5. **Error Handling**: Provide clear error messages for validation failures and other issues.

6. **Workflow Enforcement**: Enforce the correct workflow steps to prevent invalid operations.

7. **Audit Logging**: Keep detailed logs of all operations performed on releases.

8. **Background Processing**: Use background jobs for time-consuming operations like validation and distribution.

### 9. Testing and Quality Assurance

#### Release Testing

```typescript
/**
 * Tests a release for distribution
 * 
 * @param releaseId The ID of the release to test
 * @returns Test result with platform-specific information
 */
async function testReleaseDistribution(releaseId: number): Promise<{
  overallStatus: 'passed' | 'failed' | 'warnings';
  validationResult: any;
  platformSpecificResults: Record<string, {
    status: 'passed' | 'failed' | 'warnings';
    issues: any[];
  }>;
}> {
  // Get release with tracks
  const release = await db.query.releases.findFirst({
    where: eq(releases.id, releaseId),
    with: {
      tracks: {
        orderBy: [asc(tracks.track_number)]
      }
    }
  });

  if (!release) {
    throw new Error(`Release with ID ${releaseId} not found`);
  }

  // Validate release
  const validator = new ReleaseValidator();
  const validationResult = await validator.validateRelease(release);

  // Test each platform
  const platformSpecificResults: Record<string, any> = {};
  const platformsToTest = await db.query.distributionPlatforms.findMany({
    where: eq(distributionPlatforms.enabled, true)
  });

  for (const platform of platformsToTest) {
    const tester = new PlatformCompatibilityTester();
    const platformResult = await tester.testPlatformCompatibility(
      release,
      platform.code
    );

    platformSpecificResults[platform.code] = platformResult;
  }

  // Determine overall status
  let overallStatus: 'passed' | 'failed' | 'warnings' = 'passed';

  if (!validationResult.valid) {
    overallStatus = 'failed';
  } else if (validationResult.warnings.length > 0) {
    overallStatus = 'warnings';
  }

  for (const [_, result] of Object.entries(platformSpecificResults)) {
    if (result.status === 'failed') {
      overallStatus = 'failed';
      break;
    } else if (result.status === 'warnings' && overallStatus !== 'failed') {
      overallStatus = 'warnings';
    }
  }

  return {
    overallStatus,
    validationResult,
    platformSpecificResults
  };
}
```

### Conclusion

The Comprehensive Release Management System provides a robust solution for creating, validating, and distributing music releases across multiple platforms. By implementing clear workflows, thorough validation, and integration with other systems, it ensures high-quality releases with minimal errors.

The system is designed to be flexible and extensible, allowing for the addition of new platforms, validation rules, and distribution methods as requirements evolve. The clear separation of concerns between different components enables efficient development and maintenance.

### Next Steps

1. **Enhanced AI Analysis**: Expand AI capabilities for metadata generation and quality analysis.

2. **Advanced Scheduling**: Implement timezone-aware, coordinated global release scheduling.

3. **Bulk Operations**: Enable batch operations for managing multiple releases efficiently.

4. **Enhanced Reporting**: Implement comprehensive reporting on release status and distribution issues.

5. **Performance Optimization**: Optimize file processing for handling large audio files and artwork.

6. **Mobile Support**: Enhance APIs to support mobile app workflows for release management.

7. **Third-Party Integration**: Expand integration with third-party services for advanced features.

*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/technical/17032025-release-management.md*

---

## TuneMantra Admin Setup Guide

## TuneMantra Admin Setup Guide

This guide explains how to set up admin accounts and configure your TuneMantra installation.

### Setup Options

There are two ways to set up admin accounts and site configuration:

1. **Interactive Setup** - A guided, interactive process for setting up admin accounts and site configuration.
2. **Quick Setup** - A quick, non-interactive process using a configuration file.

### Prerequisites

- Node.js installed
- Access to the server running TuneMantra
- Database connection configured in `DATABASE_URL` environment variable

### 1. Interactive Setup

The interactive setup is a guided process that walks you through creating an admin account and configuring site settings.

#### Running the Interactive Setup

```bash
node setup-admin.js
```

Follow the prompts to create an admin account, configure site customization, and set up subscription plans.

### 2. Quick Setup

Quick setup allows you to configure the site in a single command using a JSON configuration file.

#### Running Quick Setup

```bash
node quick-setup.js --config=./your-config.json
```

#### Configuration File Format

Create a JSON file with the following structure:

```json
{
  "admin": {
    "username": "your-admin-username",
    "email": "admin@example.com",
    "password": "secure-password",
    "fullName": "System Administrator"
  },
  "site": {
    "name": "Your Site Name",
    "description": "Your site description",
    "primaryColor": "#6366F1",
    "logoUrl": "/path/to/logo.svg"
    // Additional site settings...
  }
}
```

A full example configuration file is available in `setup-config-example.json`.

### Security Considerations

- **Change default passwords** immediately after setup
- For production use, **delete these setup scripts** after you've completed your initial setup
- If you need to create additional admin accounts later, use the interactive setup script temporarily
- Store your configuration files securely and never commit them to version control

### After Setup

Once setup is complete:

1. Log in with your admin credentials at `/admin`
2. Complete any additional configuration through the admin interface
3. Set up API integrations and distribution platform settings
4. Customize the site appearance and branding as needed

### Troubleshooting

If you encounter any issues during setup:

- Check database connectivity
- Ensure proper permissions for file system operations
- Verify the format of your configuration file if using quick setup
- Check the server logs for detailed error messages

For additional support, contact system support.

*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/technical/3march1am-admin-setup.md*

---

## Catalog Management Guide

## Catalog Management Guide

**Last Updated:** March 23, 2025  
**Version:** 1.0

### Table of Contents

1. [Introduction](#1-introduction)
2. [Catalog Dashboard Overview](#2-catalog-dashboard-overview)
3. [Managing Releases](#3-managing-releases)
4. [Managing Tracks](#4-managing-tracks)
5. [Metadata Management](#5-metadata-management)
6. [Asset Management](#6-asset-management)
7. [Catalog Organization](#7-catalog-organization)
8. [Catalog Analysis](#8-catalog-analysis)
9. [Catalog Maintenance](#9-catalog-maintenance)
10. [Best Practices](#10-best-practices)
11. [Troubleshooting](#11-troubleshooting)

### 1. Introduction

This guide explains how to use TuneMantra's catalog management tools to organize, update, and maintain your music catalog. Effective catalog management ensures your music is properly presented to listeners, accurately tracked for royalties, and optimally positioned for discovery across streaming platforms.

#### 1.1 Why Catalog Management Matters

Effective catalog management:
- Ensures accurate metadata for discoverability
- Improves presentation of your music on streaming platforms
- Supports accurate royalty attribution and payments
- Maximizes catalog value through proper organization
- Facilitates easier administration of your music assets
- Creates a professional, consistent brand presentation

#### 1.2 Key Features of TuneMantra's Catalog Tools

TuneMantra offers comprehensive catalog management capabilities:
- **Centralized Dashboard**: All releases and tracks in one place
- **Metadata Editor**: Powerful tools for managing music metadata
- **Asset Management**: Organization of audio files and artwork
- **Bulk Operations**: Efficient tools for managing multiple releases
- **Catalog Analytics**: Insights into catalog performance
- **Quality Checks**: Automated validation of metadata and assets
- **Version Control**: Track changes to your catalog
- **Rights Management**: Track ownership and publishing information

### 2. Catalog Dashboard Overview

#### 2.1 Accessing Your Catalog

To access your catalog:

1. Log in to your TuneMantra account
2. Click on **Catalog** in the main navigation
3. View your catalog dashboard with summary metrics
4. Navigate to specific sections using the sidebar menu

#### 2.2 Dashboard Layout

The catalog dashboard is organized into key sections:

![Catalog Dashboard Layout](../assets/catalog-dashboard-layout.png)

1. **Catalog Summary**: Overview of your total releases and tracks
2. **Recent Additions**: Your most recent releases
3. **Status Overview**: Breakdown of releases by status
4. **Top Performers**: Your best-performing content
5. **Catalog Health**: Quality metrics for your catalog
6. **Quick Actions**: Common catalog management tasks

#### 2.3 Catalog Metrics

Key metrics displayed on your dashboard:

- **Total Releases**: Number of singles, EPs, albums, etc.
- **Total Tracks**: Total number of individual tracks
- **Catalog Hours**: Total duration of your catalog
- **Active Tracks**: Tracks currently available on platforms
- **Average Quality Score**: Metadata quality rating
- **Distribution Coverage**: Percentage of catalog distributed
- **Catalog Growth**: Rate of catalog expansion

#### 2.4 Catalog Search and Filtering

To find specific items in your catalog:

1. Use the search bar at the top of any catalog page
2. Search by title, artist, UPC, ISRC, or other identifiers
3. Use filters to narrow results:
   - Status (Active, Draft, Takedown, etc.)
   - Type (Single, EP, Album, etc.)
   - Date range
   - Distribution status
   - Genre
   - Platform availability

### 3. Managing Releases

#### 3.1 Viewing Your Releases

To view your releases:

1. Go to **Catalog** → **Releases**
2. View the list of all your releases
3. Sort by release date, title, status, etc.
4. Filter by type, status, or other criteria
5. Click on any release to view its details

#### 3.2 Creating a New Release

To create a new release:

1. Go to **Catalog** → **Releases**
2. Click **New Release**
3. Select release type (Single, EP, Album, etc.)
4. Fill out the basic release information:
   - Title
   - Primary Artist
   - Release Date
   - Genre
   - Language
5. Upload cover artwork
6. Add tracks (see [Adding Tracks](#43-adding-tracks-to-a-release))
7. Save as draft or submit for distribution

#### 3.3 Release Details Page

The release details page contains:

- **Overview Tab**: Basic release information and status
- **Tracks Tab**: List of all tracks in the release
- **Metadata Tab**: Detailed release metadata
- **Artwork Tab**: Cover artwork management
- **Distribution Tab**: Platform distribution status
- **Analytics Tab**: Performance metrics
- **Royalties Tab**: Revenue and royalty information
- **History Tab**: Activity log for the release

#### 3.4 Editing a Release

To edit an existing release:

1. Go to **Catalog** → **Releases**
2. Find and select the release
3. Click **Edit Release**
4. Make your changes
5. Click **Save Changes**
6. If already distributed, select **Update Platforms** to push changes

**Note**: Some changes to released music require platform approval or may not be possible without a takedown and re-release.

#### 3.5 Release Status Management

To change a release's status:

1. Select the release from your catalog
2. Click **Status** in the top-right corner
3. Choose the new status:
   - **Draft**: In preparation, not distributed
   - **Pending**: Submitted for distribution
   - **Active**: Live on platforms
   - **Scheduled**: Set for future release
   - **Takedown**: Removed from platforms
   - **Archived**: Hidden from active catalog

#### 3.6 Bulk Release Management

To manage multiple releases simultaneously:

1. Go to **Catalog** → **Releases**
2. Use checkboxes to select multiple releases
3. Click **Bulk Actions**
4. Choose an action:
   - Update status
   - Add/remove platforms
   - Apply metadata changes
   - Export data
   - Generate report

### 4. Managing Tracks

#### 4.1 Viewing Your Tracks

To view all tracks:

1. Go to **Catalog** → **Tracks**
2. View the complete list of all your tracks
3. Sort by title, release date, performance, etc.
4. Filter by status, genre, or other criteria
5. Click on any track to view its details

#### 4.2 Track Details Page

The track details page contains:

- **Overview Tab**: Basic track information
- **Audio Tab**: Audio file management
- **Metadata Tab**: Detailed track metadata
- **Credits Tab**: Songwriters, producers, and other credits
- **Lyrics Tab**: Lyrics management
- **Distribution Tab**: Platform availability
- **Analytics Tab**: Performance metrics
- **History Tab**: Activity log for the track

#### 4.3 Adding Tracks to a Release

To add tracks to a release:

1. From the release details page, click **Tracks** → **Add Track**
2. Choose one of the following options:
   - **Upload New Track**: Upload a new audio file
   - **Select Existing**: Choose from your track library
   - **Bulk Upload**: Add multiple tracks at once
3. For new tracks, upload the audio file
4. Enter track details:
   - Track title
   - Track artists
   - ISRC (or generate a new one)
   - Duration
   - Explicit content status
   - Genre
   - Language
5. Add songwriter and production credits
6. Add lyrics if available
7. Click **Save Track**

#### 4.4 Editing Track Information

To edit track information:

1. Navigate to the track in your catalog
2. Click **Edit Track**
3. Make your changes
4. Click **Save Changes**
5. If already distributed, select **Update Platforms** to push changes

#### 4.5 Managing Audio Files

To manage a track's audio:

1. Go to the track's details page
2. Click on the **Audio** tab
3. View the current audio file's details:
   - Format
   - Sample rate
   - Bit depth
   - Duration
   - File size
4. To replace the audio file:
   - Click **Replace Audio**
   - Upload the new file
   - Confirm the replacement
   - If distributed, you may need to request a takedown

#### 4.6 Track Version Management

To manage track versions:

1. From the track details page, click **Versions**
2. View all versions of the track:
   - Original
   - Radio edit
   - Explicit/clean versions
   - Remixes
   - Acoustic versions
3. Add a new version:
   - Click **Add Version**
   - Upload the audio file
   - Specify version type
   - Enter version-specific metadata
   - Save the new version

### 5. Metadata Management

#### 5.1 Metadata Standards

TuneMantra supports comprehensive metadata standards:

- **Basic Metadata**: Title, artist, release date, genre
- **Identifiers**: UPC, ISRC, catalog numbers
- **Credits**: Composers, lyricists, producers, performers
- **Technical Details**: Duration, BPM, key, audio format
- **Rights Information**: Copyright, publishing, licensing
- **Content Labeling**: Explicit flags, parental advisories
- **Platform-Specific Fields**: Special fields required by platforms

#### 5.2 Editing Release Metadata

To edit release metadata:

1. Go to the release details page
2. Click on the **Metadata** tab
3. Edit any of the available fields:
   - Primary information (title, artist, date)
   - Identifiers (UPC, catalog number)
   - Classification (genre, subgenre, mood)
   - Copyright information
   - Original release information
   - C-line and P-line information
   - Label information
4. Click **Save Metadata**

#### 5.3 Editing Track Metadata

To edit track metadata:

1. Go to the track details page
2. Click on the **Metadata** tab
3. Edit any of the available fields:
   - Primary information (title, artist)
   - Identifiers (ISRC)
   - Technical information (BPM, key, duration)
   - Classification (genre, subgenre, mood)
   - Parental advisory information
   - Language and lyrics information
4. Click **Save Metadata**

#### 5.4 Metadata Quality Check

To check metadata quality:

1. From any release or track page, click **Quality Check**
2. View the automated analysis of your metadata:
   - Completeness score
   - Accuracy indicators
   - Missing required fields
   - Platform-specific requirements
   - Enhancement recommendations
3. Click on any issue to jump directly to the field for correction
4. Run the check again after making changes to verify improvements

#### 5.5 Bulk Metadata Editing

To edit metadata for multiple items:

1. Go to **Catalog** → **Releases** or **Tracks**
2. Select multiple items using checkboxes
3. Click **Bulk Edit**
4. Choose which fields to edit
5. Enter new values or use search and replace
6. Preview changes before applying
7. Click **Apply Changes**

#### 5.6 Metadata Templates

To use metadata templates:

1. Go to **Catalog** → **Settings** → **Templates**
2. Create a new template or select an existing one
3. Configure default values for commonly used fields
4. Save the template
5. When creating new releases, select **Apply Template**
6. Choose your template to pre-fill fields

### 6. Asset Management

#### 6.1 Audio File Management

To manage audio files:

1. Go to **Catalog** → **Assets** → **Audio**
2. View all your audio files
3. Filter by format, quality, or status
4. Preview audio files
5. View file details and metadata
6. Replace files if needed
7. Download files for backup or editing

#### 6.2 Artwork Management

To manage artwork:

1. Go to **Catalog** → **Assets** → **Artwork**
2. View all your artwork files
3. Filter by size, format, or associated release
4. Preview images
5. Check artwork quality and compliance
6. Upload new versions if needed
7. Generate alternate sizes for different platforms

#### 6.3 Asset Quality Requirements

Standard quality requirements for assets:

| Asset Type | Minimum Requirements | Recommended |
|------------|----------------------|-------------|
| Audio | 16-bit/44.1kHz WAV or FLAC | 24-bit/48kHz WAV |
| Cover Art | 3000x3000px JPG/PNG, 300 DPI | 4000x4000px, PNG |
| Artist Photos | 1500x1500px, JPG/PNG | 2000x2000px, PNG |
| Promotional Images | 1200x628px, JPG/PNG | 1800x945px, PNG |

#### 6.4 Asset Version Control

To manage asset versions:

1. Go to the asset details page
2. Click on **Version History**
3. View all previous versions
4. Compare versions
5. Restore previous versions if needed
6. Add notes to document changes

#### 6.5 Batch Asset Processing

To process multiple assets:

1. Go to **Catalog** → **Assets**
2. Select multiple assets
3. Click **Batch Process**
4. Choose an operation:
   - Format conversion
   - Quality optimization
   - Resizing (for images)
   - Metadata embedding
   - Watermarking
5. Configure processing options
6. Click **Process Assets**

### 7. Catalog Organization

#### 7.1 Using Collections

To organize your catalog with collections:

1. Go to **Catalog** → **Collections**
2. Create a new collection:
   - Click **New Collection**
   - Name your collection
   - Add a description
   - Select a category (e.g., Genre, Era, Project)
3. Add releases to a collection:
   - Navigate to the collection
   - Click **Add Releases**
   - Select releases to include
   - Click **Add Selected**
4. Manage collections:
   - View collection contents
   - Remove items
   - Reorder items
   - Export collection data

#### 7.2 Using Tags

To organize with tags:

1. From any release or track page, click **Tags**
2. Add existing tags or create new ones
3. View all tagged items:
   - Go to **Catalog** → **Tags**
   - Select a tag to view all items with that tag
4. Use tags for filtering and batch operations

#### 7.3 Creating Series

To organize releases in a series:

1. Go to **Catalog** → **Series**
2. Click **Create Series**
3. Configure the series:
   - Name and description
   - Numbering format
   - Cover art style guide
   - Release schedule
4. Add releases to the series:
   - Select releases
   - Assign series volume/number
   - Set position in series
5. Manage the series:
   - View all releases in the series
   - Check for consistency
   - Plan future additions

#### 7.4 Catalog Views

To use different catalog views:

1. Go to **Catalog** → any section
2. Click the **View** dropdown
3. Select a view option:
   - **List View**: Compact list format
   - **Grid View**: Visual thumbnail grid
   - **Detailed View**: Expanded information
   - **Timeline View**: Chronological display
   - **Performance View**: Sorted by metrics
4. Save custom views:
   - Configure your preferred view
   - Click **Save View**
   - Name your custom view
   - Access saved views from the View dropdown

### 8. Catalog Analysis

#### 8.1 Catalog Overview Report

To view a comprehensive catalog report:

1. Go to **Catalog** → **Analysis** → **Overview**
2. View catalog metrics:
   - Total releases and tracks
   - Catalog composition by format
   - Genre distribution
   - Release frequency
   - Catalog age
   - Comprehensive vs. singles ratio
   - Distribution coverage

#### 8.2 Catalog Health Check

To assess catalog health:

1. Go to **Catalog** → **Analysis** → **Health**
2. View health metrics:
   - Metadata completeness
   - Asset quality
   - Distribution status
   - Identified issues
   - Improvement opportunities
3. Click on any section to see detailed information
4. Use the **Fix Issues** button for guided remediation

#### 8.3 Catalog Performance Analysis

To analyze catalog performance:

1. Go to **Catalog** → **Analysis** → **Performance**
2. View performance metrics:
   - Top-performing releases
   - Underperforming content
   - Performance by genre
   - Performance by release type
   - New vs. catalog performance
   - Seasonal trends
   - Platform-specific performance

#### 8.4 Catalog Gap Analysis

To identify catalog opportunities:

1. Go to **Catalog** → **Analysis** → **Gaps**
2. View suggested opportunities:
   - Underrepresented genres
   - Missing formats (instrumentals, acoustic versions)
   - Platform-specific content gaps
   - Seasonal content opportunities
   - Collaboration opportunities
   - Remix potential
   - Re-release candidates

### 9. Catalog Maintenance

#### 9.1 Regular Maintenance Tasks

Essential catalog maintenance tasks:

- **Weekly**: Check for distribution issues
- **Monthly**: Review metadata quality
- **Quarterly**: Perform full catalog audit
- **Annually**: Archive inactive content

#### 9.2 Catalog Cleanup

To clean up your catalog:

1. Go to **Catalog** → **Maintenance** → **Cleanup**
2. View cleanup suggestions:
   - Duplicate tracks
   - Inconsistent metadata
   - Missing assets
   - Low-quality assets
   - Incomplete releases
3. Select items to clean up
4. Choose cleanup actions
5. Execute cleanup operations

#### 9.3 Catalog Backup

To back up your catalog:

1. Go to **Catalog** → **Maintenance** → **Backup**
2. Configure backup settings:
   - Backup frequency
   - Content to include
   - Storage location
3. Manual backup:
   - Click **Backup Now**
   - Select backup content
   - Choose backup format
   - Download or store in cloud

#### 9.4 Catalog Recovery

To recover catalog items:

1. Go to **Catalog** → **Maintenance** → **Recovery**
2. View recently deleted items
3. Select items to recover
4. Choose recovery options:
   - Restore to original state
   - Restore as draft
   - Restore with new identifiers
5. Click **Recover Selected Items**

### 10. Best Practices

#### 10.1 Metadata Best Practices

For optimal metadata quality:

- **Consistency**: Use consistent naming conventions
- **Completeness**: Fill out all relevant fields, not just required ones
- **Accuracy**: Double-check all information before submission
- **Artist Names**: Use the exact same spelling across all releases
- **Featured Artists**: Format as "Primary Artist feat. Featured Artist"
- **Formatting**: Follow platform-specific guidelines for capitalization
- **Identifiers**: Always use unique UPC and ISRC codes
- **Genres**: Choose the most accurate primary genre and subgenres
- **Credits**: Include all contributing songwriters and producers
- **Dates**: Use consistent date formatting

#### 10.2 Release Organization

For effective catalog organization:

- **Release Grouping**: Keep related content together with collections
- **Consistent Branding**: Maintain visual consistency across related releases
- **Strategic Scheduling**: Plan release schedules for maximum impact
- **Content Variety**: Balance singles, EPs, albums, and compilations
- **Version Management**: Clearly label different versions of the same track
- **Series Labeling**: Use volume numbers for series of releases
- **Archiving Strategy**: Regularly archive outdated or underperforming content

#### 10.3 Asset Management

For effective asset management:

- **Master File Storage**: Keep high-quality master files in secure storage
- **Naming Convention**: Use consistent file naming (Artist - Title - Version)
- **Version Control**: Track all changes to audio and artwork
- **Quality First**: Always upload the highest quality assets available
- **Backup Protocol**: Maintain regular backups of all assets
- **Platform Optimization**: Prepare platform-specific assets when needed
- **Artwork Consistency**: Maintain visual identity across releases

#### 10.4 Catalog Growth Strategy

For strategic catalog expansion:

- **Release Schedule**: Maintain a consistent release cadence
- **Content Mix**: Balance new releases with catalog enhancements
- **Remaster Opportunities**: Identify older content for remastering
- **Remix Potential**: Consider remixes for successful tracks
- **Compilation Strategy**: Create themed compilations from existing content
- **Exclusive Content**: Develop platform-exclusive versions for key partners
- **Seasonal Planning**: Prepare seasonal content well in advance

### 11. Troubleshooting

#### 11.1 Common Catalog Issues

| Issue | Possible Cause | Solution |
|-------|----------------|----------|
| Missing Release | Filtering issue | Check filter settings or search terms |
| Duplicate Tracks | Multiple uploads | Use the duplicate detection tool |
| Metadata Rejection | Platform-specific requirements | Check platform guidelines and fix metadata |
| Asset Quality Issues | Low-resolution files | Replace with higher quality assets |
| Distribution Delays | Incomplete metadata | Complete all required fields |
| Synchronization Issues | Platform connection problems | Check integration status |

#### 11.2 Support Resources

If you need help with catalog management:

- **Knowledge Base**: Visit our help center for catalog articles
- **Video Tutorials**: Step-by-step catalog management guides
- **Live Chat**: Available for immediate assistance
- **Email Support**: catalog@tunemantra.com
- **Catalog Specialists**: Schedule a call with our catalog team

By following this guide, you'll be able to effectively manage your music catalog, ensuring your content is properly organized, accurately represented, and optimally positioned for success across all platforms.

*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/technical/organized-catalog-management.md*

---

## Artist Management Guide for Labels

## Artist Management Guide for Labels

### Overview

This guide covers the complete process for managing artists under your label on the TuneMantra platform.

### Artist Roster Management

1. **Adding New Artists**
   - Inviting artists to join your label
   - Creating artist profiles
   - Setting up access permissions
   - Establishing contract terms

2. **Artist Categorization**
   - Primary artists
   - Featured artists
   - Development roster
   - Legacy artists

3. **Artist Profile Management**
   - Updating artist information
   - Managing artist assets (photos, bio)
   - Social media integration
   - EPK (Electronic Press Kit) management

### Contract and Agreement Management

1. **Contract Setup**
   - Creating contract templates
   - Setting term lengths
   - Territory definitions
   - Exclusivity parameters

2. **Revenue Share Configuration**
   - Setting royalty percentages
   - Payment schedules
   - Advances and recoupments
   - Mechanical royalty handling

3. **Contract Renewals and Updates**
   - Managing contract expirations
   - Renegotiation processes
   - Contract amendments
   - Artist departure handling

### Artist Development

1. **Performance Tracking**
   - Setting growth metrics
   - Comparing to benchmarks
   - Identifying opportunities
   - Reporting to artists

2. **Release Strategy**
   - Creating artist release calendars
   - Managing release frequency
   - Cross-promotion opportunities
   - Content strategy development

3. **Marketing Support**
   - Campaign management
   - Budget allocation
   - Performance analytics
   - Promotional assets

### Best Practices

- Maintain clear communication channels with all artists
- Document all agreements and changes
- Regularly review artist performance
- Provide consistent feedback and support
- Ensure timely and accurate royalty reporting

*© 2025 TuneMantra. All rights reserved.*


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/technical/temp-3march-artist-management.md*

---

## Content Management System (2)

## Content Management System

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


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/technical/temp-3march-content-management.md*

---

## Deployment Guide (2)

## Deployment Guide

*Content coming soon. This guide will cover production deployment strategies.*


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/technical/temp-3march-deployment.md*

---

## Release Management Guide

## Release Management Guide

### Overview

This guide covers the complete process of managing music releases in TuneMantra, from creation through distribution, updates, and analytics tracking.

### Release Types

TuneMantra supports several release types, each with specific requirements:

#### Singles

- One primary track
- Cover artwork (3000x3000 pixels minimum)
- 1-2 additional tracks maximum (e.g., radio edit, instrumental)
- Best for quick releases and maintaining regular content schedule

#### EPs (Extended Play)

- 2-6 tracks
- Cover artwork (3000x3000 pixels minimum)
- 30 minutes or less total duration (typically)
- Good for thematic collections or showcasing variety

#### Albums

- 7+ tracks
- Cover artwork (3000x3000 pixels minimum)
- Typically 30+ minutes in duration
- Best for comprehensive artist statements or themed collections

#### Compilations

- Multiple tracks from various artists
- Special licensing considerations
- All artists must be registered in the system
- Requires clear ownership documentation

#### Remixes

- Modified versions of existing tracks
- Original artist must be properly credited
- Requires documented permission
- Can be distributed as single or EP

### Creating a New Release

#### Step 1: Initiate Release Creation

1. Navigate to "Releases" in the main menu
2. Click "Create New Release"
3. Select release type from dropdown
4. Enter primary release information:
   - Release title
   - Primary artist
   - Release date
   - Original release date (if applicable)
   - Label name

#### Step 2: Upload Cover Artwork

1. Click "Upload Artwork" button
2. Select file from your computer (JPG/PNG, minimum 3000x3000 pixels)
3. Use the cropping tool if needed
4. Save artwork

#### Step 3: Add Tracks

1. Click "Add Tracks" button
2. Upload audio files (WAV preferred)
3. For each track, enter:
   - Track title
   - Track number
   - Featured artists (if any)
   - ISRC code (optional, will be generated if not provided)
   - Explicit content flag
   - Composer/songwriter information
   - Producer credits
   - Lyrics (optional)

#### Step 4: Additional Metadata

1. Add genre information
   - Primary genre
   - Secondary genre(s)
   - Style tags
2. Add detailed credits
   - Producers
   - Engineers
   - Session musicians
3. Add copyright information
   - Recording copyright (℗)
   - Publishing copyright (©)
   - Year
   - Rights holder

#### Step 5: Review and Save

1. Review all information for accuracy
2. Click "Save as Draft" to continue editing later
3. Click "Finalize" to prepare for distribution

### Managing Existing Releases

#### Viewing Your Releases

1. Navigate to "Releases" in the main menu
2. Use filters to sort by:
   - Release date
   - Status
   - Type
   - Performance metrics
3. Click any release to view details

#### Editing Release Information

##### Before Distribution

Before a release is distributed, you can edit:
- All metadata
- Cover artwork
- Audio files
- Track sequence
- Release date
- Distribution platforms

##### After Distribution

After distribution, you can update:
- Some metadata (varies by platform)
- Cover artwork (requires redistribution)
- Distribution platforms (add only)
- Release status

> **Note**: Changes to distributed releases may take 7-14 days to propagate across all platforms.

#### Release Takedown

To remove a release from distribution:

1. Navigate to the release details
2. Click "Manage Distribution"
3. Select "Request Takedown"
4. Choose complete or partial takedown (specific platforms)
5. Provide reason for takedown
6. Confirm action

> **Important**: Takedowns typically process within 1-7 days depending on the platform.

### Release Analytics

Each release provides detailed performance analytics:

1. **Overview Dashboard**
   - Total streams
   - Revenue generated
   - Listener demographics
   - Performance trends

2. **Platform-Specific Data**
   - Performance by platform
   - Platform-specific trends
   - Playlist inclusions
   - Feature placements

3. **Track Performance**
   - Individual track metrics
   - Skip rates
   - Completion percentages
   - Save-to-playlist ratios

4. **Geographic Data**
   - Performance by territory
   - Regional trends
   - Growth markets
   - Targeting opportunities

### Release Promotion

TuneMantra offers several tools to promote your releases:

1. **Pre-Save Campaigns**
   - Generate pre-save links
   - Track pre-save analytics
   - Automatic delivery on release
   - Fan notification system

2. **Social Media Integration**
   - Automated posting tools
   - Customizable graphics
   - Release countdown widgets
   - Audience engagement tracking

3. **Playlist Pitching**
   - Editorial playlist submission
   - Independent curator connections
   - Pitch tracking
   - Success analytics

4. **Press Materials**
   - Digital press kit generation
   - Press release templates
   - Media contact management
   - Coverage tracking

### Release Calendar

Plan and visualize your release schedule:

1. **Calendar View**
   - View all scheduled releases
   - Color-coding by status
   - Filtering options
   - Marketing deadline integration

2. **Strategic Planning**
   - Identify optimal release dates
   - Avoid scheduling conflicts
   - Coordinate marketing efforts
   - Plan content strategy

### Best Practices

1. **Release Timing**
   - Schedule releases for Thursday night/Friday morning
   - Allow at least 3 weeks lead time for distribution
   - Consider major industry events and holidays
   - Plan consistent release schedule when possible

2. **Metadata Optimization**
   - Use accurate and descriptive titles
   - Include featured artists in title when appropriate
   - Select precise genres and subgenres
   - Use consistent artist naming

3. **Release Packaging**
   - Invest in professional cover artwork
   - Ensure audio is properly mastered
   - Include complete credits
   - Provide lyrics for improved discoverability

For more detailed information on the technical aspects of release management, see the [Technical Release Documentation](../03-technical/content-management.md).

*© 2025 TuneMantra. All rights reserved.*


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/technical/temp-3march-release-management.md*

---

## Metadata for payment-revenue-management-extended.md

## Metadata for payment-revenue-management-extended.md

**Original Path:** all_md_files/17032025/docs/developer/payment/payment-revenue-management-extended.md

**Title:** Payment & Revenue Management

**Category:** payment

**MD5 Hash:** 6e2588ac6adee112b597e52e0b47371e

**Source Branch:** 17032025

**Note:** This file has duplicate content in other branches.


*Source: /home/runner/workspace/.archive/archive_docs/documentation/metadata/17032025_payment-revenue-management-extended.md.md*

---

## Metadata for payment-revenue-management.md

## Metadata for payment-revenue-management.md

**Original Path:** all_md_files/17032025/docs/developer/payment/payment-revenue-management.md

**Title:** Payment and Revenue Management System

**Category:** payment

**MD5 Hash:** 3e3f5067d7d6e72a3ed40c81d6a48cf0

**Source Branch:** 17032025

**Note:** This file has duplicate content in other branches.


*Source: /home/runner/workspace/.archive/archive_docs/documentation/metadata/17032025_payment-revenue-management.md.md*

---

## Metadata for release-management.md (2)

## Metadata for release-management.md

**Original Path:** all_md_files/17032025/docs/developer/content-management/release-management.md

**Title:** Comprehensive Release Management System

**Category:** technical

**MD5 Hash:** dfddebdc6175a8b1913e92e20821e863

**Source Branch:** 17032025

**Note:** This file has duplicate content in other branches.


*Source: /home/runner/workspace/.archive/archive_docs/documentation/metadata/17032025_release-management.md.md*

---

## Metadata for ADMIN-SETUP.md

## Metadata for ADMIN-SETUP.md

**Original Path:** all_md_files/3march1am/ADMIN-SETUP.md

**Title:** TuneMantra Admin Setup Guide

**Category:** technical

**MD5 Hash:** a274b7b868d6c928321fc47e8e34f9a4

**Source Branch:** 3march1am

**Note:** This file has duplicate content in other branches.


*Source: /home/runner/workspace/.archive/archive_docs/documentation/metadata/3march1am_admin-setup.md.md*

---

## Content Management Service\n\nThis document details the content management service implemented in the TuneMantra platform.

## Content Management Service\n\nThis document details the content management service implemented in the TuneMantra platform.


*Source: /home/runner/workspace/.archive/archive_docs/documentation_backup_20250330/documentation/new_structure/technical/services/content-management.md*

---

## TuneMantra Project Management

## TuneMantra Project Management

*Version: 1.0.0 (March 27, 2025)*

### Table of Contents

- [Introduction](#introduction)
- [Project Overview](#project-overview)
- [Project Organization](#project-organization)
- [Project Milestones](#project-milestones)
- [Current Project Status](#current-project-status)
- [Challenges and Resolutions](#challenges-and-resolutions)
- [Risk Management](#risk-management)
- [Stakeholder Communication](#stakeholder-communication)
- [Resource Allocation](#resource-allocation)
- [Quality Assurance](#quality-assurance)
- [Budget and Cost Management](#budget-and-cost-management)
- [Future Roadmap](#future-roadmap)

### Introduction

This document provides a comprehensive overview of the TuneMantra project management approach, current status, and future plans. It serves as a reference for team members, stakeholders, and anyone interested in understanding the project's trajectory and management methodology.

### Project Overview

#### Project Purpose

TuneMantra was conceived to address the complex challenges faced by artists, labels, and distributors in the digital music ecosystem. The platform provides a unified solution for managing music rights, royalty calculations, content distribution, and performance analytics.

#### Project Goals

1. Create a comprehensive music distribution platform with sophisticated rights management
2. Streamline royalty calculations and payment processing
3. Provide robust analytics and reporting
4. Support multi-tenant architecture for labels and distributors
5. Deliver an intuitive and powerful user experience
6. Ensure scalability to handle millions of tracks and billions of streams

#### Project Scope

The TuneMantra platform includes:

- Content management system
- Rights management system
- Distribution system
- Royalty management system
- Analytics platform
- User management system
- Integration framework
- Administrative tools

#### Project Timeline

- **Project Initiation**: January 2023
- **Major Development Phases**: January 2023 - December 2024
- **Initial Release**: June 2023
- **Current Version**: 3.2.1 (March 2025)
- **Ongoing Development**: Continuous with quarterly major releases

### Project Organization

#### Team Structure

The TuneMantra project is organized into cross-functional teams with specialized focus areas:

1. **Core Platform Team**
   - Backend infrastructure
   - API development
   - Database design
   - Performance optimization

2. **Frontend Experience Team**
   - User interface development
   - Responsive design
   - User experience optimization
   - Frontend performance

3. **Content & Distribution Team**
   - Content management features
   - Distribution system
   - DSP integrations
   - Content delivery optimization

4. **Financial Systems Team**
   - Rights management
   - Royalty calculations
   - Payment processing
   - Financial reporting

5. **Analytics & Reporting Team**
   - Analytics infrastructure
   - Report generation
   - Data visualization
   - Business intelligence

6. **DevOps & Infrastructure Team**
   - CI/CD pipeline
   - Infrastructure management
   - Monitoring and alerts
   - Security implementation

7. **Quality Assurance Team**
   - Test automation
   - Manual testing
   - Performance testing
   - Accessibility testing

#### Roles and Responsibilities

- **Project Manager**: Overall project coordination, timeline management, stakeholder communication
- **Product Owner**: Feature prioritization, requirements definition, backlog management
- **Tech Lead**: Technical direction, architecture decisions, code quality
- **UX Designer**: User experience design, wireframing, usability testing
- **Frontend Developer**: UI implementation, responsive design, client-side logic
- **Backend Developer**: API development, business logic, database operations
- **QA Engineer**: Test planning, test automation, quality verification
- **DevOps Engineer**: CI/CD, infrastructure, monitoring, security
- **Business Analyst**: Requirements analysis, process mapping, documentation

### Project Milestones

#### Phase 1: Foundation (Q1-Q2 2023)

| Milestone | Description | Status | Completion Date |
|-----------|-------------|--------|-----------------|
| Project Initiation | Project planning, team assembly, initial requirements | Completed | January 15, 2023 |
| Architecture Design | Technical architecture, database schema, API design | Completed | February 28, 2023 |
| Core Infrastructure | Base platform setup, DevOps pipeline, development environment | Completed | March 30, 2023 |
| User Management | Authentication, authorization, user profiles, organization management | Completed | April 15, 2023 |
| Content Management Basic | Basic catalog management, metadata handling, media storage | Completed | May 20, 2023 |
| Alpha Release | Internal release for testing and feedback | Completed | June 15, 2023 |

#### Phase 2: Core Functionality (Q3-Q4 2023)

| Milestone | Description | Status | Completion Date |
|-----------|-------------|--------|-----------------|
| Rights Management | Rights definition, ownership tracking, conflict detection | Completed | July 30, 2023 |
| Distribution System | DSP connections, delivery management, status tracking | Completed | September 15, 2023 |
| Basic Royalty System | Revenue import, basic calculations, statement generation | Completed | October 20, 2023 |
| Analytics Foundation | Data collection, basic reporting, dashboard framework | Completed | November 30, 2023 |
| Beta Release | Limited customer release with core functionality | Completed | December 15, 2023 |

#### Phase 3: Enhancement and Expansion (Q1-Q2 2024)

| Milestone | Description | Status | Completion Date |
|-----------|-------------|--------|-----------------|
| Advanced Rights Management | Territorial rights, multiple right types, rights history | Completed | January 30, 2024 |
| Distribution Expansion | Additional DSPs, advanced delivery options, takedown management | Completed | March 15, 2024 |
| Advanced Royalty System | Complex rate structures, multiple currencies, detailed statements | Completed | April 20, 2024 |
| Enhanced Analytics | Performance insights, trend analysis, comparative reporting | Completed | May 30, 2024 |
| V2 Release | Full feature release to all customers | Completed | June 15, 2024 |

#### Phase 4: Optimization and Scale (Q3-Q4 2024)

| Milestone | Description | Status | Completion Date |
|-----------|-------------|--------|-----------------|
| Performance Optimization | System-wide performance improvements, caching strategy, query optimization | Completed | August 15, 2024 |
| Scalability Enhancements | Infrastructure scaling, load balancing, database sharding | Completed | September 30, 2024 |
| Integration Framework | API expansion, webhook system, third-party integration options | Completed | October 31, 2024 |
| Advanced Security | Enhanced security features, compliance improvements, audit system | Completed | November 30, 2024 |
| V3 Release | Optimized platform release | Completed | December 15, 2024 |

#### Phase 5: Innovation and Growth (Q1 2025 - Present)

| Milestone | Description | Status | Completion Date |
|-----------|-------------|--------|-----------------|
| AI-Assisted Features | Machine learning for metadata, content recommendations, anomaly detection | In Progress | 70% Complete |
| Mobile Experience | Progressive web app, responsive enhancements, mobile-specific features | In Progress | 60% Complete |
| Blockchain Integration | Rights verification, transparent royalty tracking, smart contracts | In Progress | 40% Complete |
| Advanced Business Intelligence | Predictive analytics, market insights, forecasting tools | Planned | Q3 2025 |
| V4 Release | Next-generation platform release | Planned | Q4 2025 |

### Current Project Status

#### Overall Status

The TuneMantra platform is currently in Version 3.2.1, a stable release with all core functionality implemented and optimized. The platform is serving 120+ labels and distributors, managing over 2 million tracks, and processing 50+ million streams daily.

#### Completion Percentage

| Component | Completion | Status |
|-----------|------------|--------|
| Core Platform | 100% | Complete |
| User Management | 100% | Complete |
| Content Management | 100% | Complete |
| Rights Management | 100% | Complete |
| Distribution System | 100% | Complete |
| Royalty Management | 100% | Complete |
| Basic Analytics | 100% | Complete |
| Advanced Analytics | 85% | In Progress |
| Integration Framework | 95% | Near Complete |
| Mobile Experience | 60% | In Progress |
| AI Features | 70% | In Progress |
| Blockchain Integration | 40% | In Progress |
| **Overall Project** | **92%** | **Near Complete** |

#### Recent Accomplishments

1. Released version 3.2.1 with enhanced analytics dashboard
2. Completed integration with 20 new DSPs, bringing total to 150+
3. Implemented advanced royalty reporting with customizable templates
4. Optimized database queries, resulting in 40% performance improvement
5. Launched beta version of AI-assisted metadata enhancement
6. Completed SOC 2 Type II certification

#### Current Sprint Focus

The current sprint (Sprint 52) is focused on:

1. Completing the mobile-responsive dashboard experience
2. Enhancing the AI metadata suggestion engine
3. Implementing the first phase of blockchain rights verification
4. Resolving 15 high-priority bugs identified in user feedback
5. Performance optimization for analytics queries

#### Key Metrics

- **System Uptime**: 99.98% in the last 30 days
- **Average Response Time**: 120ms (down from 200ms in previous version)
- **User Satisfaction**: 4.7/5 based on recent feedback survey
- **Bug Resolution Time**: Average 3.2 days for high-priority issues
- **Feature Delivery Rate**: 85% of planned features delivered on schedule

### Challenges and Resolutions

#### Technical Challenges

1. **Database Performance at Scale**
   - **Challenge**: Query performance degradation with large catalog data
   - **Resolution**: Implemented database sharding, query optimization, and caching strategy
   - **Outcome**: 40% improvement in query performance, stable under high load

2. **DSP Integration Complexity**
   - **Challenge**: Each DSP requires unique delivery specifications and protocols
   - **Resolution**: Developed adaptive integration framework with configuration-driven approach
   - **Outcome**: Reduced new DSP integration time from weeks to days

3. **Royalty Calculation Accuracy**
   - **Challenge**: Complex royalty calculations with multiple factors and edge cases
   - **Resolution**: Implemented comprehensive test suite with real-world scenarios
   - **Outcome**: Achieved 100% accuracy in royalty calculations verified by financial audit

4. **System Scalability**
   - **Challenge**: Supporting growth from thousands to millions of tracks
   - **Resolution**: Microservice architecture, load balancing, and auto-scaling
   - **Outcome**: System now handles 10x initial capacity with consistent performance

#### Process Challenges

1. **Development Velocity**
   - **Challenge**: Initial slow feature delivery due to complex dependencies
   - **Resolution**: Implemented modular architecture and cross-functional teams
   - **Outcome**: 30% increase in development velocity measured by story points

2. **Quality Assurance Bottlenecks**
   - **Challenge**: Manual testing created bottlenecks in release process
   - **Resolution**: Comprehensive test automation strategy with CI/CD integration
   - **Outcome**: Reduced testing time by 60% while increasing test coverage

3. **Technical Debt Management**
   - **Challenge**: Accumulation of technical debt in early development phases
   - **Resolution**: Dedicated sprints for debt reduction, code quality metrics
   - **Outcome**: Reduced technical debt by 40% as measured by SonarQube metrics

#### Business Challenges

1. **Competitive Differentiation**
   - **Challenge**: Distinguishing from established players in the market
   - **Resolution**: Focus on advanced analytics and integrated rights management
   - **Outcome**: Successfully positioned as premium solution with 85% customer retention

2. **User Adoption**
   - **Challenge**: Complex functionality creating steep learning curve
   - **Resolution**: Enhanced onboarding, contextual help, and user experience simplification
   - **Outcome**: Reduced time-to-value for new users from weeks to days

3. **Regulatory Compliance**
   - **Challenge**: Meeting varying international royalty and rights regulations
   - **Resolution**: Compliance framework with territory-specific rule engine
   - **Outcome**: Fully compliant operation in all target markets

### Risk Management

#### Current Risk Register

| Risk | Probability | Impact | Mitigation Strategy | Status |
|------|------------|--------|---------------------|--------|
| Infrastructure scaling limitations | Medium | High | Cloud architecture review, load testing, capacity planning | Monitored |
| Security vulnerabilities | Low | Critical | Regular security audits, penetration testing, security training | Managed |
| Regulatory changes | Medium | High | Compliance monitoring, legal advisory team, flexible rule engine | Monitored |
| Competitor feature parity | Medium | Medium | Innovation pipeline, market analysis, customer feedback loop | Managed |
| Technical debt accumulation | Low | Medium | Code quality metrics, refactoring strategy, architecture reviews | Managed |
| Key personnel dependencies | Medium | High | Knowledge sharing, documentation, cross-training | In Progress |
| Third-party service dependencies | Medium | High | Vendor assessment, failover options, service redundancy | Monitored |
| Data integrity issues | Low | Critical | Data validation, audit trails, backup strategy | Managed |

#### Risk Response Strategy

- **Avoid**: Eliminate the risk by removing the cause
- **Transfer**: Shift the risk impact to third party (insurance, outsourcing)
- **Mitigate**: Reduce probability or impact through preventive actions
- **Accept**: Acknowledge the risk and prepare contingency plans

#### Risk Monitoring

- Weekly risk review in team meetings
- Monthly comprehensive risk assessment
- Risk metrics tracked in project dashboard
- Escalation process for emerging risks

### Stakeholder Communication

#### Stakeholder Groups

1. **Executive Leadership**
   - CEO, CTO, CFO, COO
   - Strategic direction, budget approval, high-level status

2. **Investors**
   - Venture capital partners, angel investors
   - Investment return, growth metrics, market positioning

3. **Development Team**
   - Developers, designers, QA, DevOps
   - Technical details, task assignments, impediments

4. **Customers**
   - Labels, distributors, artists
   - Features, benefits, release timelines, support

5. **Partners**
   - DSPs, payment processors, industry organizations
   - Integration details, technical specifications, roadmap

#### Communication Plan

| Stakeholder Group | Communication Method | Frequency | Key Content | Owner |
|-------------------|----------------------|-----------|-------------|-------|
| Executive Leadership | Executive dashboard, status meeting | Weekly | KPIs, risks, major decisions | Project Manager |
| Investors | Investor report, board meeting | Monthly | Financial metrics, growth, strategic progress | CEO |
| Development Team | Stand-up, sprint review, team meeting | Daily/Weekly | Tasks, blockers, technical decisions | Tech Lead |
| Customers | Product update, newsletter, webinar | Monthly | New features, improvements, roadmap | Product Owner |
| Partners | Partner portal, technical documentation | As needed | Integration updates, API changes | Integration Manager |

#### Communication Templates

Standard templates have been created for:

1. **Sprint Report**: Status, velocity, completed features, issues
2. **Executive Summary**: KPIs, milestones, risks, decisions needed
3. **Release Notes**: Features, improvements, fixes, known issues
4. **Stakeholder Update**: Progress, upcoming changes, feedback request
5. **Technical Briefing**: Architecture changes, performance metrics, security updates

#### Meeting Cadence

- **Daily Stand-up**: 15 minutes, team focus
- **Sprint Planning**: Bi-weekly, 2 hours
- **Sprint Review**: Bi-weekly, 1 hour
- **Sprint Retrospective**: Bi-weekly, 1 hour
- **Technical Review**: Weekly, 1 hour
- **Executive Update**: Weekly, 30 minutes
- **All-hands Meeting**: Monthly, 1 hour

### Resource Allocation

#### Team Composition

The TuneMantra project currently has 45 team members allocated:

| Role | Headcount | Allocation |
|------|-----------|------------|
| Project Manager | 1 | 100% |
| Product Owner | 2 | 100% |
| Tech Lead | 3 | 100% |
| Frontend Developer | 8 | 100% |
| Backend Developer | 12 | 100% |
| DevOps Engineer | 3 | 100% |
| QA Engineer | 6 | 100% |
| UX Designer | 3 | 100% |
| UI Designer | 2 | 100% |
| Business Analyst | 2 | 100% |
| Data Scientist | 2 | 100% |
| Technical Writer | 1 | 100% |

#### Resource Allocation by Component

| Component | Resource Allocation | Status |
|-----------|---------------------|--------|
| Core Platform | 20% | Maintenance |
| User Management | 5% | Maintenance |
| Content Management | 10% | Enhancement |
| Rights Management | 10% | Enhancement |
| Distribution System | 10% | Enhancement |
| Royalty Management | 10% | Enhancement |
| Analytics Platform | 15% | Active Development |
| Mobile Experience | 15% | Active Development |
| AI Features | 20% | Active Development |
| Blockchain Integration | 15% | Active Development |

#### Resource Forecast

Based on the project roadmap, the following resource changes are anticipated:

- **Q3 2025**: Addition of 2 data scientists for advanced analytics
- **Q3 2025**: Addition of 3 blockchain developers for expanded integration
- **Q4 2025**: Reduction in core platform team as system stabilizes
- **Q1 2026**: Expansion of mobile development team for native app development

### Quality Assurance

#### Quality Metrics

The project maintains the following quality metrics:

| Metric | Target | Current | Trend |
|--------|--------|---------|-------|
| Code Coverage | >80% | 83% | ↑ |
| Defect Density | <2 per 1000 lines | 1.7 | ↓ |
| Escaped Defects | <5 per release | 3 | ↓ |
| Technical Debt | <10% | 8% | ↓ |
| Performance SLA | <200ms response | 120ms | ↓ |
| Uptime | >99.9% | 99.98% | ↔ |
| Customer Satisfaction | >4.5/5 | 4.7/5 | ↑ |

#### Quality Assurance Process

1. **Requirements Quality**
   - Clear acceptance criteria
   - Testability review
   - Requirement validation with stakeholders

2. **Code Quality**
   - Static code analysis
   - Peer code reviews
   - Coding standards enforcement

3. **Testing Quality**
   - Comprehensive test strategy
   - Automated test suites
   - Systematic manual testing
   - Performance and security testing

4. **Release Quality**
   - Release criteria verification
   - Staged rollout process
   - Post-release monitoring
   - Quick feedback loops

#### Quality Improvement Initiatives

1. **Continuous Integration Enhancement**:
   - Faster feedback on code quality
   - Automated code style enforcement
   - Pre-commit hooks for quality checks

2. **Test Automation Expansion**:
   - Increased end-to-end test coverage
   - Visual regression testing implementation
   - Performance test automation

3. **DevOps Maturity**:
   - Infrastructure as code implementation
   - Chaos engineering practices
   - Observability improvements

### Budget and Cost Management

#### Project Budget Summary

The TuneMantra project has an approved budget of $12.5 million over three years (2023-2025).

| Category | Allocated Budget | Spent to Date | Remaining | % Used |
|----------|------------------|---------------|-----------|--------|
| Personnel | $8,500,000 | $6,800,000 | $1,700,000 | 80% |
| Infrastructure | $1,500,000 | $1,200,000 | $300,000 | 80% |
| Software Licenses | $750,000 | $600,000 | $150,000 | 80% |
| Professional Services | $1,000,000 | $750,000 | $250,000 | 75% |
| Training | $250,000 | $175,000 | $75,000 | 70% |
| Contingency | $500,000 | $150,000 | $350,000 | 30% |
| **Total** | **$12,500,000** | **$9,675,000** | **$2,825,000** | **77%** |

#### Cost Performance

- **Budget Variance**: Currently 2% under budget
- **Cost Performance Index (CPI)**: 1.03 (spending less than planned)
- **Schedule Performance Index (SPI)**: 0.98 (slightly behind schedule)
- **Estimated Cost at Completion**: $12.2 million (projected savings of $300,000)

#### Cost Control Measures

1. **Regular Budget Reviews**:
   - Monthly budget vs. actual analysis
   - Quarterly forecast updates
   - Cost variance investigation

2. **Resource Optimization**:
   - Just-in-time resource allocation
   - Skill mix optimization
   - Contract resources for specialized needs

3. **Infrastructure Cost Management**:
   - Cloud resource optimization
   - Reserved instance purchases
   - Auto-scaling policies

4. **Procurement Efficiency**:
   - Vendor consolidation
   - Enterprise license agreements
   - Long-term partnership discounts

### Future Roadmap

#### Short-Term (Next 6 Months)

1. **Complete Mobile Experience**:
   - Fully responsive interface
   - Mobile-specific workflows
   - Progressive web app functionality

2. **Advanced Analytics Platform**:
   - Predictive analytics
   - Custom report builder
   - Enhanced visualization tools

3. **AI-Assisted Metadata**:
   - Automated genre classification
   - Content recommendation engine
   - Metadata quality scoring

4. **Phase 1 Blockchain Integration**:
   - Rights verification on blockchain
   - Transparent royalty tracking
   - Smart contract support for rights transfers

#### Medium-Term (6-18 Months)

1. **Native Mobile Applications**:
   - iOS and Android native apps
   - Offline functionality
   - Push notifications

2. **Expanded AI Capabilities**:
   - Royalty forecasting
   - Anomaly detection
   - Content performance prediction

3. **Advanced Blockchain Features**:
   - Smart contracts for royalty distribution
   - Tokenized rights management
   - Decentralized rights marketplace

4. **Business Intelligence Suite**:
   - Market analysis tools
   - Competitive intelligence
   - Trend forecasting

#### Long-Term (18+ Months)

1. **Global Expansion**:
   - Localization for key markets
   - Region-specific compliance features
   - International payment methods

2. **Ecosystem Development**:
   - Developer API platform
   - Partner integration marketplace
   - Custom application development

3. **Advanced Data Science**:
   - Deep learning for content analysis
   - Natural language processing for contracts
   - Automated rights conflict resolution

4. **Next-Generation Platform**:
   - Event-driven architecture
   - Quantum-resistant security
   - Edge computing capabilities

---

© 2023-2025 TuneMantra. All rights reserved.

*Source: /home/runner/workspace/.archive/archive_docs/documentation_backup_20250330/documentation/project/project_management.md*

---

## Metadata Management System

## Metadata Management System

This document details the metadata management system in TuneMantra, which handles the structured data associated with music assets.

### System Overview

The metadata management system is responsible for:

1. Capturing comprehensive metadata for tracks and releases
2. Ensuring metadata quality and standards compliance
3. Organizing metadata for efficient distribution
4. Enhancing metadata with AI-powered analysis
5. Managing specialized metadata for different distribution platforms

### Metadata Schema

TuneMantra uses an enhanced metadata schema to capture detailed information beyond basic track details.

#### Core Metadata Structure

##### Track Metadata

```typescript
interface Track {
  id: number;
  userId: number;
  title: string;
  artist: string;
  audioFile: string;
  duration: number;
  releaseDate: Date;
  isrc: string | null;
  genre: string;
  language: string;
  bpm: number | null;
  key: string | null;
  explicit: boolean;
  lyrics: string | null;
  tags: string[];
  metadata: {
    contentTags?: ContentTags;
    aiAnalysis?: AIAnalysis;
    credits?: Credits;
    audioMetadata?: AudioMetadata;
    sampleDetails?: SampleDetails[];
    visibilitySettings?: VisibilitySettings;
    stemDetails?: StemDetails;
  };
  // ... other basic fields
}
```

##### Release Metadata

```typescript
interface Release {
  id: number;
  userId: number;
  title: string;
  artist: string;
  type: 'single' | 'ep' | 'album' | 'compilation';
  coverArt: string;
  releaseDate: Date;
  upc: string | null;
  primaryGenre: string;
  secondaryGenres: string[];
  label: string | null;
  copyright: string;
  publishingRights: string;
  language: string;
  metadata: {
    contentTags?: ContentTags;
    aiAnalysis?: AIAnalysis;
    credits?: Credits;
    artworkMetadata?: ArtworkMetadata;
    visibilitySettings?: VisibilitySettings;
    contractTerms?: ContractTerms;
  };
  // ... other basic fields
}
```

#### Enhanced Metadata Types

The system uses specialized metadata types to capture detailed information:

##### Content Tags

```typescript
interface ContentTags {
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

##### AI Analysis

```typescript
interface AIAnalysis {
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

##### Credits

```typescript
interface Credits {
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
    role: string;
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

### Database Implementation

The metadata schema is implemented in the database using PostgreSQL JSON columns for flexible storage of complex metadata objects.

#### Schema Definition

The schema is defined using Drizzle ORM with TypeScript:

```typescript
export const tracks = pgTable("tracks", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  title: text("title").notNull(),
  artist: text("artist").notNull(),
  audioFile: text("audio_file").notNull(),
  duration: integer("duration").notNull(),
  releaseDate: timestamp("release_date").notNull(),
  isrc: text("isrc"),
  genre: text("genre").notNull(),
  language: text("language").notNull(),
  bpm: integer("bpm"),
  key: text("key"),
  explicit: boolean("explicit").notNull().default(false),
  lyrics: text("lyrics"),
  tags: text("tags").array(),
  metadata: jsonb("metadata"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const releases = pgTable("releases", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  title: text("title").notNull(),
  artist: text("artist").notNull(),
  type: text("type").notNull(),
  coverArt: text("cover_art").notNull(),
  releaseDate: timestamp("release_date").notNull(),
  upc: text("upc"),
  primaryGenre: text("primary_genre").notNull(),
  secondaryGenres: text("secondary_genres").array(),
  label: text("label"),
  copyright: text("copyright").notNull(),
  publishingRights: text("publishing_rights").notNull(),
  language: text("language").notNull(),
  metadata: jsonb("metadata"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});
```

### Metadata Processing

#### Ingestion Process

When metadata is submitted via the API, it undergoes the following process:

1. **Validation**: Zod schemas verify metadata structure and required fields
2. **Normalization**: Values are standardized (e.g., genre names, language codes)
3. **Enhancement**: AI processing adds additional metadata where appropriate
4. **Storage**: Validated and enhanced metadata is stored in the database

#### Metadata Validation

The system uses Zod for schema validation:

```typescript
export const insertTrackSchema = createInsertSchema(tracks)
  .extend({
    metadata: z.object({
      contentTags: contentTagsSchema.optional(),
      aiAnalysis: aiAnalysisSchema.optional(),
      credits: creditsSchema.optional(),
      audioMetadata: audioMetadataSchema.optional(),
      sampleDetails: z.array(sampleDetailsSchema).optional(),
      visibilitySettings: visibilitySettingsSchema.optional(),
      stemDetails: stemDetailsSchema.optional(),
    }).optional(),
  });
```

### Platform-Specific Formatting

The metadata system includes adapters for formatting metadata according to platform requirements:

```typescript
function formatMetadataForPlatform(trackMetadata, platform) {
  const platformFormatters = {
    spotify: formatForSpotify,
    appleMusic: formatForAppleMusic,
    amazonMusic: formatForAmazonMusic,
    // ... other platforms
  };

  const formatter = platformFormatters[platform] || formatForGeneric;
  return formatter(trackMetadata);
}
```

Each platform formatter handles special requirements like:
- Character limits
- Required vs. optional fields
- Format restrictions
- Platform-specific identifiers

### Metadata Enrichment

#### AI-Powered Metadata Analysis

The system can analyze audio content to extract additional metadata:

1. **Genre Detection**: Identifies musical genres based on audio characteristics
2. **Mood Analysis**: Determines emotional qualities of the track
3. **Content Analysis**: Identifies instruments, vocals, and production elements
4. **Quality Assessment**: Evaluates audio quality metrics
5. **Similar Artist Detection**: Suggests similar artists based on style

#### User-Driven Enrichment

Users can enhance metadata through:

1. **Tag Suggestions**: System suggests tags based on content analysis
2. **Collaborative Editing**: Multiple contributors can refine metadata
3. **Batch Editing**: Mass updates for consistent metadata across releases
4. **Templates**: Preset metadata configurations for efficiency

### Metadata API

The metadata system exposes these key endpoints:

#### Track Metadata

- `GET /api/tracks/:id/metadata` - Retrieve complete metadata
- `PATCH /api/tracks/:id/metadata` - Update metadata
- `POST /api/tracks/:id/analyze` - Trigger AI analysis

#### Release Metadata

- `GET /api/releases/:id/metadata` - Retrieve complete metadata
- `PATCH /api/releases/:id/metadata` - Update metadata
- `POST /api/releases/:id/analyze` - Trigger AI analysis

#### Metadata Validation

- `POST /api/metadata/validate` - Validate metadata without saving
- `GET /api/metadata/requirements/:platform` - Get platform requirements

### Metadata Services

#### MetadataValidationService

Handles validation of metadata across the system:

```typescript
class MetadataValidationService {
  static validateTrackMetadata(metadata, context = 'default') {
    // Validation logic
  }

  static validateReleaseMetadata(metadata, context = 'default') {
    // Validation logic
  }

  static getPlatformRequirements(platform) {
    // Return platform-specific requirements
  }
}
```

#### MetadataEnrichmentService

Processes and enhances metadata:

```typescript
class MetadataEnrichmentService {
  static async analyzeAudio(audioFile) {
    // Audio analysis logic
  }

  static async enhanceMetadata(basicMetadata) {
    // Enhancement logic
  }

  static generateSuggestions(metadata) {
    // Suggestion logic
  }
}
```

### Implementation Best Practices

1. **Consistency**: Use consistent naming conventions across all metadata
2. **Completeness**: Ensure all required fields are populated
3. **Accuracy**: Verify metadata accuracy, especially for rights information
4. **Standards Compliance**: Follow industry standards (DDEX, etc.)
5. **Internationalization**: Support multiple languages and regional variations
6. **Updates**: Maintain a change history for metadata updates
7. **Validation**: Always validate metadata before submission

### Future Enhancements

Planned enhancements to the metadata system include:

1. **Blockchain Verification**: Immutable recording of rights metadata
2. **AI Generation**: AI-assisted metadata generation from minimal input
3. **Semantic Enrichment**: Enhanced semantic understanding of content
4. **Cross-Platform Sync**: Bidirectional sync with platform metadata
5. **Voice Input**: Voice-driven metadata entry for efficiency

*Source: /home/runner/workspace/.archive/archive_docs/essential_docs/technical/metadata_management.md*

---

