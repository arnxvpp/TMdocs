# Multi-tenant Sub-label Management System

<div align="center">
  <img src="../../diagrams/multi-tenant-header.svg" alt="TuneMantra Multi-tenant Management" width="800"/>
</div>

## Introduction

The TuneMantra Multi-tenant Sub-label Management System provides a comprehensive hierarchical structure for music labels to create, manage, and oversee sub-labels within their organization. This feature enables major labels to delegate authority, manage catalog segmentation, and enforce fine-grained access control across their entire music business operation while maintaining centralized oversight and reporting.

## Table of Contents

- [System Overview](#system-overview)
- [Architecture](#architecture)
- [Hierarchy Management](#hierarchy-management)
- [Permission System](#permission-system)
- [Revenue Management](#revenue-management)
- [Analytics & Reporting](#analytics--reporting)
- [Security Model](#security-model)
- [Audit & Compliance](#audit--compliance)
- [User Experience](#user-experience)
- [Integration Points](#integration-points)
- [Implementation Guidelines](#implementation-guidelines)
- [API Reference](#api-reference)

## System Overview

### Core Capabilities

The Multi-tenant Sub-label Management System offers the following key capabilities:

1. **Hierarchical Label Structure**
   - Unlimited hierarchy depth for label organization
   - Customizable sub-label configuration
   - Independent branding and identity for each sub-label
   - Inheritance of parent label policies and settings
   - Unified catalog management across all levels

2. **Role-Based Access Control**
   - Fine-grained permission management
   - Role templates for quick user setup
   - Permission inheritance through label hierarchy
   - Temporary access delegation
   - Emergency access protocols

3. **Financial Management**
   - Multi-level revenue sharing configuration
   - Automated royalty calculations across hierarchy
   - Custom payment schedules per label level
   - Financial reporting at any hierarchy node
   - Consolidated billing and statements

4. **Catalog Segmentation**
   - Genre-based label divisions
   - Artist roster management by sub-label
   - Release catalog organization
   - Territorial rights management
   - Content ownership tracking

### Business Value

The multi-tenant structure delivers significant business value to music labels:

1. **Operational Efficiency**
   - Delegated administration reduces bottlenecks
   - Specialized teams for different catalog segments
   - Streamlined approval workflows
   - Resource allocation optimization
   - Reduced administrative overhead

2. **Strategic Growth**
   - Easy expansion into new music genres
   - Acquisition integration framework
   - Brand diversification support
   - Market-specific label creation
   - Artist development programs

3. **Enhanced Control**
   - Centralized policy enforcement
   - Comprehensive audit trails
   - Real-time activity monitoring
   - Financial oversight at all levels
   - Compliance management across organization

4. **Improved Analytics**
   - Cross-label performance comparison
   - Aggregated reporting capabilities
   - Market segment analysis
   - Resource utilization metrics
   - ROI tracking by label division

## Architecture

### System Design

<div align="center">
  <img src="../../diagrams/multi-tenant-architecture.svg" alt="Multi-tenant Architecture" width="700"/>
</div>

The Multi-tenant Sub-label Management System uses a sophisticated architecture:

1. **Core Components**
   - Tenant Manager - Central authority management
   - Hierarchy Engine - Relationship management
   - Permission Service - Access control enforcement
   - Inheritance Resolver - Policy propagation
   - Tenant Isolation Service - Data separation

2. **Data Architecture**
   - Multi-tenant database schema
   - Hierarchical data structure
   - Cross-tenant reference management
   - Tenant-aware query execution
   - Isolated data storage with shared schema

3. **Integration Layer**
   - Identity management integration
   - Financial system connectors
   - Analytics data pipeline
   - Catalog management interface
   - Distribution platform integration

4. **Service Interface**
   - RESTful API for tenant management
   - GraphQL for hierarchy queries
   - WebSocket for real-time updates
   - Event-driven notification system
   - Batch processing for high-volume operations

### Tenant Isolation

The system ensures proper tenant isolation:

1. **Data Segregation**
   - Row-level security implementation
   - Tenant-specific encryption keys
   - Query filtering by tenant context
   - Access pattern monitoring
   - Cross-tenant access controls

2. **Application Isolation**
   - Multi-tenant aware authentication
   - Tenant context propagation
   - Session management
   - Request routing
   - Resource allocation by tenant

3. **Security Boundaries**
   - Hierarchical permission inheritance
   - Strict cross-tenant access policies
   - Audit logging for boundary crossings
   - Sensitive data isolation
   - Configurable isolation policies

4. **Shared Infrastructure**
   - Resource pools with tenant quotas
   - Shared service layer with tenant context
   - Common codebase with tenant-specific configuration
   - Centralized monitoring
   - Consolidated maintenance

### Tenant Hierarchy Model

The system implements a flexible hierarchy model:

1. **Entity Relationships**
   - Parent-child label relationships
   - Many-to-one hierarchical structure
   - Inheritance paths for policies
   - Cross-hierarchy references
   - Logical and organizational groupings

2. **Hierarchy Rules**
   - Maximum depth configuration
   - Circular reference prevention
   - Mandatory parent-child validation
   - Hierarchy constraints enforcement
   - Path traversal optimization

3. **Identification System**
   - Globally unique identifiers
   - Hierarchical path encoding
   - Friendly name mapping
   - Namespace management
   - ID resolution services

4. **Transition Management**
   - Hierarchy restructuring
   - Tenant migration
   - Parent reassignment
   - Orphan prevention
   - Historical relationship tracking

## Hierarchy Management

### Sub-label Creation

The process for creating new sub-labels:

1. **Creation Flow**
   - Sub-label template selection
   - Configuration wizard
   - Parent label approval workflow
   - Initial administrator assignment
   - Resource allocation

2. **Initial Setup**
   - Branding configuration
   - Default user roles creation
   - System integration configuration
   - Financial account setup
   - Communication settings

3. **Validation Process**
   - Name uniqueness verification
   - Hierarchy position validation
   - Permission assignment check
   - Resource availability confirmation
   - Compliance verification

4. **Post-Creation**
   - Notification to stakeholders
   - Onboarding workflow initiation
   - Dashboard provisioning
   - Access credential generation
   - Documentation provision

### Management Operations

Key operations for maintaining the label hierarchy:

1. **Sub-label Configuration**
   - Label profile management
   - Contact information
   - Visual identity settings
   - Default distribution platforms
   - Default revenue splits

2. **Structural Changes**
   - Sub-label transfer
   - Hierarchy reorganization
   - Merger of sub-labels
   - Sub-label archiving
   - Catalog reassignment

3. **Policy Management**
   - Default permission templates
   - Content approval workflows
   - Financial thresholds
   - Distribution requirements
   - Reporting schedules

4. **Administration**
   - Administrator assignment
   - Bulk user management
   - System notification configuration
   - Quota adjustment
   - Feature enablement

### Template System

Using templates for efficient sub-label setup:

1. **Template Types**
   - Genre-specific sub-label templates
   - Regional sub-label templates
   - Artist development label templates
   - Acquisition integration templates
   - Specialty distribution templates

2. **Template Components**
   - Role configuration
   - Default permission sets
   - Financial setup
   - Workflow definitions
   - Branding guidelines

3. **Customization Options**
   - Template parameter overrides
   - Selective component application
   - Custom extension points
   - Parent label overrides
   - Mandatory vs. optional settings

4. **Template Management**
   - Template version control
   - Template sharing
   - Usage analytics
   - Template effectiveness metrics
   - Template library

## Permission System

### Role-Based Access Control

Sophisticated permissions model:

1. **Role Definition**
   - Predefined system roles
   - Custom role creation
   - Role hierarchy
   - Role composition (role inheritance)
   - Time-limited roles

2. **Permission Assignment**
   - Direct permission assignment
   - Role-based permission bundles
   - Context-specific permissions
   - Temporary permission elevation
   - Emergency access protocols

3. **Access Scope**
   - Label-specific access
   - Catalog segment access
   - Artist roster access
   - Financial data access
   - Analytic data access

4. **Permission Inheritance**
   - Downward permission propagation
   - Override mechanisms
   - Inheritance blocking
   - Explicit vs. implicit permissions
   - Permission resolution rules

### Common Permission Sets

Standard permission configurations:

1. **Label Administrator**
   - Full control of label settings
   - User management
   - Financial overview access
   - Approval authority
   - System configuration

2. **Catalog Manager**
   - Release management
   - Metadata editing
   - Distribution control
   - Content upload
   - Basic analytics access

3. **Financial Manager**
   - Revenue data access
   - Payment processing
   - Statement generation
   - Financial reporting
   - Split configuration

4. **Marketing Role**
   - Promotional content management
   - Basic catalog access
   - Analytics viewing
   - Playlist management
   - Marketing performance data

5. **Artist Manager**
   - Artist profile management
   - Release scheduling
   - Performance tracking
   - Communication management
   - Limited financial access

### Cross-Label Access

Managing access across label boundaries:

1. **Global Roles**
   - Super-admin access
   - Cross-label analysts
   - Financial controllers
   - System administrators
   - Compliance officers

2. **Delegation Mechanisms**
   - Temporary access grants
   - Project-based collaboration
   - Shared roster management
   - Cross-label release collaboration
   - Joint venture handling

3. **Access Request Workflow**
   - Request submission
   - Approval routing
   - Justification requirements
   - Time-limited access grants
   - Usage tracking

4. **Boundary Controls**
   - Data export limitations
   - Sensitive information masking
   - Activity monitoring
   - Rate limiting
   - Access revocation triggers

## Revenue Management

### Financial Hierarchy

Managing finances across the label structure:

1. **Account Structure**
   - Parent-child account relationships
   - Revenue collection accounts
   - Distribution accounts
   - Reserve accounts
   - Operating expense accounts

2. **Revenue Flow**
   - Upstream revenue collection
   - Hierarchical distribution
   - Split calculations
   - Fee deductions
   - Payment disbursement

3. **Financial Controls**
   - Approval thresholds
   - Spending limits
   - Payment authorization
   - Financial reporting requirements
   - Compliance checks

4. **Balance Management**
   - Minimum balance requirements
   - Overdraft protection
   - Automatic transfers
   - Balance alerts
   - Interest allocation

### Revenue Sharing Configuration

Configuring revenue division across labels:

1. **Split Hierarchy**
   - Parent label percentage
   - Sub-label percentage
   - Artist share configuration
   - Service fee structure
   - Platform fee handling

2. **Split Types**
   - Fixed percentage splits
   - Tiered revenue splits
   - Time-based split adjustments
   - Performance-based splits
   - Overhead contribution models

3. **Special Arrangements**
   - Joint venture accounting
   - Acquisition earn-out models
   - Development funding recoupment
   - Advance repayment tracking
   - Marketing contribution accounting

4. **Split Management**
   - Split template creation
   - Bulk update capabilities
   - Historical split tracking
   - Split auditing
   - Split modeling and simulation

### Financial Reporting

Comprehensive financial visibility:

1. **Report Types**
   - Label revenue summary
   - Hierarchical revenue breakdown
   - Profitability analysis
   - Platform performance comparison
   - Period-over-period comparison

2. **Consolidation Levels**
   - Individual label reporting
   - Sub-label rollup
   - Complete hierarchy view
   - Custom grouping
   - Division-level reporting

3. **Report Access**
   - Role-based report availability
   - Custom report creation
   - Scheduled report delivery
   - Interactive dashboards
   - Export capabilities

4. **Financial Analytics**
   - Trend analysis
   - Revenue forecasting
   - Expense tracking
   - ROI calculation
   - Business unit comparison

## Analytics & Reporting

### Multi-level Analytics

Analyzing performance across the hierarchy:

1. **Aggregation Levels**
   - Individual track performance
   - Release performance
   - Artist performance
   - Label performance
   - Parent label consolidated view

2. **Cross-label Analysis**
   - Label comparison
   - Genre performance
   - Territory analysis
   - Platform effectiveness
   - Marketing campaign impact

3. **Performance Metrics**
   - Stream counts
   - Revenue generation
   - Audience growth
   - Market share
   - Artist development indicators

4. **Time-based Analysis**
   - Trend identification
   - Seasonal patterns
   - Year-over-year comparison
   - Release cycle analysis
   - Long-term catalog performance

### Dashboard System

Custom visualization for different roles:

1. **Executive Dashboard**
   - High-level performance indicators
   - Critical alerts
   - Strategic overview
   - Comparative analysis
   - Goal tracking

2. **Label Manager Dashboard**
   - Label-specific performance
   - Catalog management
   - Team productivity
   - Release planning
   - Financial snapshot

3. **Sub-label Dashboard**
   - Sub-label KPIs
   - Artist roster performance
   - Release timeline
   - Marketing effectiveness
   - Revenue breakdown

4. **Operational Dashboards**
   - Day-to-day activity tracking
   - Task management
   - Workflow status
   - Pending approvals
   - Resource utilization

### Reporting Capabilities

Comprehensive reporting system:

1. **Standard Reports**
   - Catalog performance reports
   - Financial statements
   - User activity reports
   - Distribution status reports
   - Rights management reports

2. **Custom Reporting**
   - Report builder interface
   - Custom metric definition
   - Advanced filtering
   - Personalized layouts
   - Scheduling options

3. **Delivery Options**
   - In-app reporting
   - Email delivery
   - Scheduled exports
   - API access
   - Integration with external analytics

4. **Compliance Reporting**
   - Audit trail reports
   - Policy compliance
   - Financial control adherence
   - Usage monitoring
   - Access pattern analysis

## Security Model

### User Management

Secure user handling across the tenant hierarchy:

1. **User Provisioning**
   - Centralized user creation
   - Self-service registration
   - Bulk user import
   - Role assignment
   - Sub-label user allocation

2. **Authentication**
   - Multi-factor authentication
   - Single sign-on integration
   - Password policies
   - Session management
   - Login monitoring

3. **User Lifecycle**
   - Onboarding workflow
   - Status management (active, suspended, archived)
   - Role transitions
   - Label transfers
   - Offboarding process

4. **Identity Management**
   - User profile maintenance
   - Contact information verification
   - Group membership
   - Access certification
   - Privilege review

### Tenant Security

Protecting tenant boundaries:

1. **Tenant Isolation**
   - Data access control
   - Service separation
   - Resource allocation
   - Monitoring boundaries
   - Cross-tenant controls

2. **Security Policies**
   - Customizable by tenant level
   - Policy inheritance
   - Mandatory vs. discretionary controls
   - Exception management
   - Policy enforcement

3. **Access Monitoring**
   - Real-time monitoring
   - Suspicious activity detection
   - Cross-tenant access logging
   - Usage pattern analysis
   - Alert generation

4. **Incident Response**
   - Security incident management
   - Tenant-level response procedures
   - Isolation capabilities
   - Forensic tools
   - Recovery processes

### Compliance Controls

Ensuring regulatory compliance:

1. **Regulatory Framework**
   - Global compliance capabilities
   - Regional requirement adaptation
   - Industry standard adherence
   - Contract enforcement
   - Licensing compliance

2. **Audit Controls**
   - Comprehensive audit logging
   - Change tracking
   - Access recording
   - Financial transaction logging
   - Configuration change history

3. **Compliance Reporting**
   - Compliance dashboard
   - Violation tracking
   - Remediation management
   - Certification documentation
   - Evidence collection

4. **Data Governance**
   - Data classification
   - Retention policies
   - Privacy controls
   - Data sharing agreements
   - Right to be forgotten support

## Audit & Compliance

### Activity Tracking

Comprehensive audit capabilities:

1. **Audit Scope**
   - System configuration changes
   - User management actions
   - Permission changes
   - Financial transactions
   - Content modifications

2. **Audit Detail**
   - Actor identification
   - Timestamp
   - Action details
   - Before/after state
   - Context information

3. **Storage & Retention**
   - Tamper-proof storage
   - Configurable retention periods
   - Archiving capabilities
   - Search and retrieval
   - Export functionality

4. **Audit Analysis**
   - Pattern detection
   - Anomaly identification
   - Compliance reporting
   - Investigation support
   - Historical comparison

### Change Management

Controlled system evolution:

1. **Change Control**
   - Change request workflow
   - Impact assessment
   - Approval routing
   - Implementation planning
   - Rollback capability

2. **Version Control**
   - Configuration versioning
   - Permission set versioning
   - Policy versioning
   - Template versioning
   - Differential comparison

3. **Release Management**
   - Feature rollout control
   - Tenant-specific deployments
   - Testing environments
   - Progressive activation
   - Feature flagging

4. **Change Communication**
   - Change notification
   - Documentation updates
   - Training materials
   - Support readiness
   - User acceptance testing

### Compliance Framework

Meeting regulatory requirements:

1. **Compliance Management**
   - Compliance requirement tracking
   - Control mapping
   - Evidence collection
   - Gap analysis
   - Remediation planning

2. **Industry Standards**
   - Music industry compliance
   - Financial controls (SOX, etc.)
   - Data protection (GDPR, CCPA)
   - Security standards (ISO 27001, SOC 2)
   - Contractual obligation tracking

3. **Audit Support**
   - External audit preparation
   - Audit evidence collection
   - Finding remediation
   - Continuous monitoring
   - Certification maintenance

4. **Legal Requirements**
   - Rights management compliance
   - Royalty calculation accuracy
   - Tax reporting
   - Contract fulfillment
   - Intellectual property protection

## User Experience

### Label Management Interfaces

User interfaces for hierarchy management:

1. **Label Dashboard**
   - Performance overview
   - Sub-label summary
   - Recent activity
   - Quick actions
   - Alert notifications

2. **Hierarchy Visualization**
   - Interactive organization chart
   - Hierarchical tree view
   - Relationship mapping
   - Drill-down navigation
   - Context-sensitive actions

3. **Configuration Interfaces**
   - Label settings management
   - Permission configuration
   - Integration setup
   - Template management
   - Workflow design

4. **Bulk Operations**
   - Multi-label updates
   - User batch management
   - Content bulk processing
   - Mass communication
   - Reporting across labels

### Mobile Experience

Mobile access to multi-tenant features:

1. **Mobile Dashboard**
   - Performance snapshots
   - Approval workflows
   - Notification management
   - Quick actions
   - Status monitoring

2. **On-the-go Management**
   - User permission adjustments
   - Basic configuration changes
   - Performance monitoring
   - Release approval
   - Financial review

3. **Responsive Design**
   - Device-optimized interfaces
   - Touch-friendly controls
   - Simplified hierarchy navigation
   - Essential feature access
   - Offline capability

4. **Mobile Notifications**
   - Push notification integration
   - Priority-based alerting
   - Action-enabled notifications
   - Status updates
   - Escalation management

### Customization Options

Tailoring the experience for each label:

1. **Visual Customization**
   - Label-specific branding
   - Custom color schemes
   - Logo integration
   - Layout preferences
   - Typography options

2. **Functional Customization**
   - Dashboard widget selection
   - Feature enablement
   - Workflow customization
   - Report personalization
   - Notification preferences

3. **Integration Preferences**
   - Third-party service connections
   - Data import/export configuration
   - External tool integration
   - API usage settings
   - Authentication preferences

4. **Language & Localization**
   - Multi-language support
   - Regional formatting
   - Time zone preferences
   - Currency display options
   - Cultural adaptations

## Integration Points

### External Systems

Connecting to broader ecosystems:

1. **Financial Integrations**
   - Accounting systems
   - Payment processors
   - Banking platforms
   - Tax reporting systems
   - Royalty processors

2. **Distribution Platforms**
   - Streaming services
   - Download stores
   - Physical distribution
   - Synchronization platforms
   - Social media services

3. **Enterprise Systems**
   - CRM integration
   - ERP connectivity
   - Business intelligence platforms
   - Data warehouses
   - Document management systems

4. **Industry Connections**
   - Rights societies
   - Publishing administrators
   - Licensing platforms
   - Industry databases
   - Chart reporting services

### API Ecosystem

Programmatic access to multi-tenant functionality:

1. **Core APIs**
   - Tenant management API
   - User and permission API
   - Catalog management API
   - Financial API
   - Analytics API

2. **Integration Patterns**
   - RESTful endpoints
   - GraphQL for complex queries
   - Webhook notifications
   - Batch processing APIs
   - Real-time streaming

3. **Developer Resources**
   - API documentation
   - SDK availability
   - Code examples
   - Testing environment
   - Rate limit information

4. **Authentication & Security**
   - OAuth 2.0 implementation
   - API key management
   - Scoped access tokens
   - CORS configuration
   - Request signing

### Data Exchange

Moving data between systems:

1. **Import Capabilities**
   - User bulk import
   - Catalog data import
   - Financial data ingestion
   - Rights data import
   - Historical data migration

2. **Export Functionality**
   - Reporting exports
   - Catalog extracts
   - Financial data exports
   - User data extraction
   - System configuration backup

3. **Synchronization**
   - Real-time data synchronization
   - Scheduled synchronization
   - Conflict resolution
   - Delta synchronization
   - Validation and error handling

4. **Exchange Formats**
   - Standard format support (CSV, XML, JSON)
   - Industry-specific formats
   - Custom format mapping
   - Schema validation
   - Transformation capabilities

## Implementation Guidelines

### Setup Process

Steps for implementing the multi-tenant system:

1. **Planning Phase**
   - Hierarchy design
   - Tenant structure planning
   - Permission strategy development
   - Integration requirements
   - Migration approach

2. **Initial Configuration**
   - Root tenant setup
   - Master administrator provisioning
   - System parameter configuration
   - Base templates creation
   - Security policy establishment

3. **Tenant Hierarchy Creation**
   - Parent label setup
   - Sub-label creation
   - Relationship definition
   - Policy inheritance configuration
   - Resource allocation

4. **User Onboarding**
   - Administrator training
   - User import and setup
   - Role assignment
   - Initial permission configuration
   - Access testing

### Best Practices

Recommended approaches for multi-tenant management:

1. **Hierarchy Design**
   - Keep hierarchy depth manageable (3-5 levels recommended)
   - Define clear organizational boundaries
   - Establish consistent naming conventions
   - Document hierarchy purpose and relationships
   - Plan for future expansion

2. **Permission Management**
   - Use role templates for consistency
   - Implement least-privilege principle
   - Regularly review access rights
   - Establish permission request workflow
   - Document role definitions

3. **Financial Setup**
   - Define clear revenue sharing rules
   - Document special financial arrangements
   - Implement approval workflows for financial changes
   - Establish financial reporting cadence
   - Set up financial alerts

4. **Performance Optimization**
   - Implement caching strategies
   - Optimize database queries for hierarchy
   - Use eager loading for related data
   - Apply pagination for large datasets
   - Schedule resource-intensive operations

### Migration Strategies

Approaches for moving to the multi-tenant system:

1. **Phased Migration**
   - Begin with core parent label
   - Gradually migrate sub-labels
   - Phase functionality adoption
   - Incremental user onboarding
   - Progressive feature activation

2. **Data Migration**
   - User mapping strategy
   - Historical data import
   - Catalog association planning
   - Financial data reconciliation
   - Rights and ownership transfer

3. **Integration Approach**
   - Legacy system coexistence
   - API-first integration
   - Data synchronization strategy
   - Authentication bridging
   - Reporting consolidation

4. **Verification & Validation**
   - Hierarchy validation
   - Permission testing
   - Financial calculation verification
   - Report accuracy confirmation
   - User acceptance testing

## API Reference

### Tenant Management API

Core API endpoints for tenant operations:

1. **Sub-label Management**
   ```
   POST /api/tenants/sub-labels - Create new sub-label
   GET /api/tenants/sub-labels - List sub-labels
   GET /api/tenants/sub-labels/{id} - Get sub-label details
   PUT /api/tenants/sub-labels/{id} - Update sub-label
   DELETE /api/tenants/sub-labels/{id} - Archive sub-label
   ```

2. **Hierarchy Operations**
   ```
   GET /api/tenants/hierarchy - Get full hierarchy
   GET /api/tenants/hierarchy/{id}/children - Get child labels
   GET /api/tenants/hierarchy/{id}/parent - Get parent label
   PUT /api/tenants/hierarchy/{id}/parent - Change parent label
   GET /api/tenants/hierarchy/{id}/path - Get full path to root
   ```

3. **Template Management**
   ```
   POST /api/tenants/templates - Create template
   GET /api/tenants/templates - List templates
   GET /api/tenants/templates/{id} - Get template details
   PUT /api/tenants/templates/{id} - Update template
   POST /api/tenants/sub-labels/{id}/apply-template - Apply template
   ```

4. **Bulk Operations**
   ```
   POST /api/tenants/bulk/import - Bulk import sub-labels
   POST /api/tenants/bulk/update - Bulk update sub-labels
   POST /api/tenants/bulk/move - Bulk move sub-labels
   GET /api/tenants/bulk/status/{jobId} - Check bulk operation status
   ```

### Permission API

Endpoints for managing access control:

1. **Role Management**
   ```
   POST /api/permissions/roles - Create role
   GET /api/permissions/roles - List roles
   GET /api/permissions/roles/{id} - Get role details
   PUT /api/permissions/roles/{id} - Update role
   DELETE /api/permissions/roles/{id} - Delete role
   ```

2. **Permission Assignment**
   ```
   POST /api/permissions/users/{userId}/roles - Assign role to user
   DELETE /api/permissions/users/{userId}/roles/{roleId} - Remove role
   GET /api/permissions/users/{userId}/permissions - Get effective permissions
   POST /api/permissions/users/{userId}/permissions - Grant direct permission
   DELETE /api/permissions/users/{userId}/permissions/{permId} - Remove permission
   ```

3. **Access Control**
   ```
   GET /api/permissions/check - Check permission
   POST /api/permissions/request - Request additional access
   GET /api/permissions/requests - List access requests
   PUT /api/permissions/requests/{id} - Update request status
   GET /api/permissions/audit - Get permission audit log
   ```

4. **Cross-Label Access**
   ```
   POST /api/permissions/cross-label - Create cross-label access
   GET /api/permissions/cross-label - List cross-label access
   PUT /api/permissions/cross-label/{id} - Update cross-label access
   DELETE /api/permissions/cross-label/{id} - Remove cross-label access
   GET /api/permissions/cross-label/audit - Get cross-label audit log
   ```

### Analytics API

Endpoints for multi-level analytics:

1. **Performance Data**
   ```
   GET /api/analytics/tenants/{id}/performance - Get tenant performance
   GET /api/analytics/tenants/{id}/catalog - Get catalog performance
   GET /api/analytics/tenants/{id}/artists - Get artist performance
   GET /api/analytics/tenants/{id}/releases - Get release performance
   GET /api/analytics/tenants/{id}/tracks - Get track performance
   ```

2. **Comparison Analytics**
   ```
   GET /api/analytics/compare/tenants - Compare tenants
   GET /api/analytics/compare/periods - Compare time periods
   GET /api/analytics/benchmarks - Get benchmarks
   GET /api/analytics/trends - Get trend analysis
   GET /api/analytics/forecasts - Get performance forecasts
   ```

3. **Financial Analytics**
   ```
   GET /api/analytics/tenants/{id}/revenue - Get revenue analysis
   GET /api/analytics/tenants/{id}/expenses - Get expense analysis
   GET /api/analytics/tenants/{id}/profitability - Get profitability analysis
   GET /api/analytics/tenants/{id}/splits - Get split analysis
   GET /api/analytics/tenants/{id}/forecasts - Get financial forecasts
   ```

4. **Custom Reporting**
   ```
   POST /api/analytics/reports - Create custom report
   GET /api/analytics/reports - List reports
   GET /api/analytics/reports/{id} - Get report data
   PUT /api/analytics/reports/{id} - Update report
   POST /api/analytics/reports/{id}/schedule - Schedule report
   ```

---

**Document Information:**
- Version: 1.0
- Last Updated: March 26, 2025
- Contact: product-team@tunemantra.com