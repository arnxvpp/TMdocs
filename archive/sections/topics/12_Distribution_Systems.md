# 12. Distribution Systems

## Distribution Service Documentation

## Distribution Service Documentation

<div align="center">
  <img src="../../diagrams/distribution-service-header.svg" alt="TuneMantra Distribution Service" width="800"/>
</div>

### Overview

The Distribution Service is a critical core component of the TuneMantra platform that handles the end-to-end process of delivering music content to various streaming platforms, stores, and services. This document provides comprehensive technical documentation of the Distribution Service architecture, components, workflows, and integration points.

### Table of Contents

- [System Architecture](#system-architecture)
- [Core Components](#core-components)
- [Distribution Workflow](#distribution-workflow)
- [Error Handling](#error-handling)
- [Platform Integrations](#platform-integrations)
- [Status Tracking](#status-tracking)
- [Analytics Integration](#analytics-integration)
- [Performance Optimization](#performance-optimization)
- [API Reference](#api-reference)
- [Best Practices](#best-practices)

### System Architecture

The Distribution Service follows a modular, microservices-based architecture designed for reliability, scalability, and maintainability.

<div align="center">
  <img src="../../diagrams/distribution-architecture.svg" alt="Distribution Service Architecture" width="700"/>
</div>

#### Key Design Principles

1. **Separation of Concerns** - Clear boundaries between distribution components (packaging, delivery, tracking)
2. **Resilience** - Robust error handling and recovery mechanisms
3. **Scalability** - Horizontal scaling for high-volume distribution periods
4. **Observability** - Comprehensive monitoring and logging throughout the distribution pipeline
5. **Platform Agnosticism** - Unified interface for all distribution platforms

#### Technology Stack

The Distribution Service is implemented using the following technologies:

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Core Service** | TypeScript/Node.js | Primary service implementation |
| **Job Queue** | Redis/Bull | Distribution job queuing and processing |
| **State Management** | PostgreSQL | Tracking distribution state and history |
| **File Storage** | Cloud Object Storage | Content staging and delivery |
| **API Layer** | Express.js | RESTful API for distribution management |
| **Monitoring** | Prometheus/Grafana | Performance metrics and alerting |

### Core Components

The Distribution Service consists of several specialized components that work together to ensure reliable content delivery:

#### Distribution Manager (`server/services/distribution.ts`)

The central orchestration component that coordinates the distribution process. It:
- Manages distribution jobs
- Tracks status across platforms
- Ensures content delivery compliance
- Handles failure recovery
- Exposes the distribution API

```typescript
/**
 * Distribute a release to multiple platforms
 */
static async distributeRelease(releaseId: number, platformIds: number[]) {
  try {
    // Validate release is ready for distribution
    const release = await storage.getReleaseById(releaseId);
    if (!release) {
      throw new Error(`Release with ID ${releaseId} not found`);
    }

    // Get associated tracks
    const tracks = await storage.getTracksByReleaseId(releaseId);

    // Create distribution records for each platform
    const distributionResults = [];
    for (const platformId of platformIds) {
      const platform = await storage.getDistributionPlatformById(platformId);
      if (!platform) {
        throw new Error(`Platform with ID ${platformId} not found`);
      }

      const result = await this.distributeToPlatform(releaseId, platformId);
      distributionResults.push(result);
    }

    return distributionResults;
  } catch (error) {
    logger.error(`Error distributing release ${releaseId}: ${error.message}`);
    throw error;
  }
}
```

#### Job Processor (`server/services/distribution-job-processor.ts`)

Handles the actual execution of distribution jobs, including:
- Job queuing with priorities
- Rate limiting
- Concurrency management
- Automatic retries
- Long-running job tracking

```typescript
/**
 * Process distribution jobs in background
 * 
 * @param job The distribution job to process
 * @returns Status of the distribution processing
 */
async function processDistributionJob(job: Job): Promise<DistributionResult> {
  const { releaseId, platformId, options } = job.data;
  const jobId = job.id;

  try {
    // Update job status to processing
    await updateJobStatus(jobId, 'processing');

    // Fetch required data
    const platform = await storage.getDistributionPlatformById(platformId);
    const release = await storage.getReleaseById(releaseId);
    const tracks = await storage.getTracksByReleaseId(releaseId);

    // Validate content meets platform requirements
    const validationResult = await validateContentForPlatform(
      platform, release, tracks
    );
    if (!validationResult.valid) {
      throw new Error(`Validation failed: ${validationResult.errors.join(', ')}`);
    }

    // Prepare content package for delivery
    const contentPackage = await prepareContentPackage(platform, release, tracks);

    // Deliver to platform using appropriate API or delivery method
    const deliveryResult = await deliverToPlatform(platform, contentPackage);

    // Record successful distribution
    const distributionRecord = await storage.createDistributionRecord({
      releaseId,
      platformId,
      status: 'distributed',
      platformReleaseId: deliveryResult.platformReleaseId,
      platformUrl: deliveryResult.platformUrl,
      distributedAt: new Date()
    });

    // Update job status to completed
    await updateJobStatus(jobId, 'completed', distributionRecord);

    return {
      success: true,
      distributionId: distributionRecord.id,
      platformReleaseId: deliveryResult.platformReleaseId
    };
  } catch (error) {
    // Handle error based on type
    const errorCategory = categorizeError(error);
    const shouldRetry = isRetryableError(errorCategory);

    // Update job status to failed
    await updateJobStatus(jobId, 'failed', { 
      error: error.message,
      errorCategory,
      shouldRetry
    });

    return {
      success: false,
      error: error.message,
      errorCategory,
      shouldRetry
    };
  }
}
```

#### Error Handler (`server/services/distribution-error-handler.ts`)

Specialized component for categorizing, handling, and recovering from distribution errors:
- Error classification
- Platform-specific error handling
- Retry strategies
- Error reporting and analytics

```typescript
/**
 * Categorize distribution errors for appropriate handling
 * 
 * @param error The error to categorize
 * @returns The error category
 */
export function categorizeError(error: any): DistributionErrorCategory {
  const message = error.message.toLowerCase();

  // Content validation errors
  if (message.includes('format') || message.includes('unsupported file')) {
    return DistributionErrorCategory.CONTENT_FORMAT;
  }
  if (message.includes('quality') || message.includes('bitrate')) {
    return DistributionErrorCategory.CONTENT_QUALITY;
  }
  if (message.includes('metadata') || message.includes('missing field')) {
    return DistributionErrorCategory.METADATA_INVALID;
  }

  // Authentication errors
  if (message.includes('token expired') || message.includes('credentials expired')) {
    return DistributionErrorCategory.AUTH_EXPIRED;
  }
  if (message.includes('invalid credentials') || message.includes('unauthorized')) {
    return DistributionErrorCategory.AUTH_INVALID;
  }

  // Platform API errors
  if (message.includes('rate limit') || message.includes('too many requests')) {
    return DistributionErrorCategory.API_RATE_LIMIT;
  }
  if (message.includes('platform unavailable') || message.includes('service down')) {
    return DistributionErrorCategory.API_UNAVAILABLE;
  }

  // Network errors
  if (message.includes('timeout') || message.includes('connection timed out')) {
    return DistributionErrorCategory.NETWORK_TIMEOUT;
  }
  if (message.includes('network') || message.includes('connection')) {
    return DistributionErrorCategory.NETWORK_CONNECTIVITY;
  }

  return DistributionErrorCategory.UNKNOWN;
}
```

#### Status Tracker (`server/services/distribution-status-tracker.ts`)

Monitors and reports on the status of distributions:
- Real-time status updates
- Platform status mapping
- Historical status tracking
- Status notifications
- Aggregated status reporting

```typescript
/**
 * Update distribution status with detailed tracking
 * 
 * @param distributionId The distribution record ID
 * @param status The new status
 * @param details Additional status details
 * @returns Updated distribution record
 */
export async function updateDistributionStatus(
  distributionId: number,
  status: DetailedDistributionStatus | string,
  details?: any
): Promise<DistributionRecord> {
  try {
    // Validate status transition
    const currentRecord = await storage.getDistributionRecordById(distributionId);
    if (!currentRecord) {
      throw new Error(`Distribution record ${distributionId} not found`);
    }

    const isValidTransition = validateStatusTransition(
      currentRecord.status as DetailedDistributionStatus,
      status as DetailedDistributionStatus
    );

    if (!isValidTransition) {
      throw new Error(
        `Invalid status transition from ${currentRecord.status} to ${status}`
      );
    }

    // Create status history entry
    await storage.createDistributionStatusHistory({
      distributionId,
      previousStatus: currentRecord.status,
      newStatus: status,
      changedAt: new Date(),
      details: details || {}
    });

    // Update distribution record
    const updatedRecord = await storage.updateDistributionRecord(
      distributionId,
      {
        status,
        statusDetails: details || {},
        updatedAt: new Date()
      }
    );

    // Trigger notifications for status change if needed
    if (shouldNotifyOnStatus(status)) {
      await notifyOnStatusChange(updatedRecord);
    }

    return updatedRecord;
  } catch (error) {
    logger.error(
      `Failed to update distribution status for ${distributionId}: ${error.message}`
    );
    throw error;
  }
}
```

#### Analytics Integration (`server/services/distribution-analytics.ts`)

Provides performance metrics and analytics for distributions:
- Success rate tracking
- Platform-specific performance
- Error pattern analysis
- Processing time analysis
- Geographic distribution mapping

### Distribution Workflow

The Distribution Service implements a comprehensive workflow for content delivery:

<div align="center">
  <img src="../../diagrams/distribution-workflow.svg" alt="Distribution Workflow" width="700"/>
</div>

#### 1. Preparation Phase

**Validation**
- Content quality verification
- Metadata completeness check
- Platform-specific requirements validation
- Rights and ownership verification

**Packaging**
- Content transcoding for platform requirements
- Metadata formatting
- Artwork preparation
- Bundle creation

#### 2. Delivery Phase

**Distribution Job Creation**
- Job scheduling with priorities
- Platform-specific parameters
- Delivery timing configuration
- Notification settings

**Platform Delivery**
- API-based delivery for supported platforms
- FTP/SFTP uploads for legacy platforms
- Batch processing for high-volume platforms
- Delivery confirmation

#### 3. Tracking Phase

**Status Monitoring**
- Real-time status updates
- Platform status polling
- Webhook processing for status notifications
- Status normalization across platforms

**Error Recovery**
- Automatic retry for transient errors
- Manual intervention for critical errors
- Platform-specific error handling
- Communication with platform support when needed

#### 4. Completion Phase

**Verification**
- Confirmation of successful delivery
- Content availability checking
- Metadata accuracy verification
- Link and asset validation

**Reporting**
- Distribution completion notifications
- Status reports generation
- Analytics data collection
- Distribution history recording

### Error Handling

The Distribution Service implements a sophisticated error handling system to ensure reliability and recovery from failures.

#### Error Categories

Errors are categorized to enable appropriate handling strategies:

| Category | Description | Example | Recovery Strategy |
|----------|-------------|---------|------------------|
| **Content Format** | Issues with file formats | Unsupported audio format | Transform content to supported format |
| **Content Quality** | Quality issues | Bitrate too low | Re-encode at higher quality |
| **Metadata Invalid** | Missing or invalid metadata | Missing required field | Prompt user for missing information |
| **Auth Expired** | Authentication expired | API token expired | Refresh authentication |
| **Auth Invalid** | Invalid credentials | Wrong API key | Notify admin for credential update |
| **API Rate Limit** | Platform rate limiting | Too many requests | Implement exponential backoff |
| **API Unavailable** | Platform API down | Service unavailable | Queue for retry after delay |
| **Network Timeout** | Connection timeout | Request timed out | Retry with longer timeout |
| **Network Connectivity** | Network issues | Connection failed | Retry after network check |

#### Retry Strategies

The service implements multiple retry strategies based on error type:

**Immediate Retry**
- For transient errors like network timeouts
- Maximum of 3 immediate retries

**Exponential Backoff**
- For rate limiting and temporary platform issues
- Initial delay of 30 seconds
- Exponential increase with each attempt
- Maximum delay of 1 hour
- Maximum of 10 retries

**Scheduled Retry**
- For platform maintenance or downtime
- Retry after specified delay from platform

**Manual Intervention**
- For critical errors requiring human action
- Notification to administrators
- UI for manual retry after correction

#### Error Reporting

Comprehensive error reporting enables efficient troubleshooting:

- Detailed logs with context information
- Error categorization and aggregation
- Trend analysis for recurring errors
- Platform-specific error mapping
- User notifications for actionable errors

### Platform Integrations

The Distribution Service supports integration with major music distribution platforms through a unified interface.

#### Supported Platforms

| Platform | Integration Type | Features | Implementation |
|----------|------------------|----------|----------------|
| **Spotify** | Direct API | Content delivery, metadata management, status tracking | `adapters/spotify-adapter.ts` |
| **Apple Music** | Direct API | Content delivery, metadata management, scheduling | `adapters/apple-adapter.ts` |
| **Amazon Music** | Direct API | Content delivery, metadata management | `adapters/amazon-adapter.ts` |
| **YouTube Music** | Direct API | Content delivery, metadata, video linking | `adapters/youtube-adapter.ts` |
| **Deezer** | Direct API | Content delivery, metadata, playlist submission | `adapters/deezer-adapter.ts` |
| **Tidal** | FTP + API | Content via FTP, metadata via API | `adapters/tidal-adapter.ts` |
| **Pandora** | FTP + API | Content via FTP, metadata via API | `adapters/pandora-adapter.ts` |
| **SoundCloud** | Direct API | Content delivery, metadata, social features | `adapters/soundcloud-adapter.ts` |

#### Platform Adapter Pattern

Each platform integration is implemented using a consistent adapter pattern:

```typescript
/**
 * Platform adapter interface
 * Defines the standard methods each platform adapter must implement
 */
export interface PlatformAdapter {
  // Core distribution methods
  validateContent(release: Release, tracks: Track[]): Promise<ValidationResult>;
  prepareContent(release: Release, tracks: Track[]): Promise<ContentPackage>;
  deliverContent(contentPackage: ContentPackage): Promise<DeliveryResult>;

  // Status tracking methods
  checkStatus(distributionId: string): Promise<PlatformStatus>;
  updateMetadata(distributionId: string, updates: any): Promise<boolean>;
  takedown(distributionId: string): Promise<boolean>;

  // Platform-specific methods
  getPlatformMetadata(): PlatformMetadata;
  getContentRequirements(): ContentRequirements;

  // Authentication methods
  refreshAuthentication(): Promise<boolean>;
  validateAuthentication(): Promise<boolean>;
}
```

#### Common Implementation Pattern

Each adapter follows a standard implementation:

1. **Connection Management**
   - Authenticated API client initialization
   - Token refresh handling
   - Connection pooling

2. **Content Transformation**
   - Platform-specific format conversion
   - Metadata mapping to platform schema
   - Content packaging

3. **Delivery Mechanisms**
   - API-based content submission
   - Chunked file uploads
   - Batch processing
   - Delivery verification

4. **Status Synchronization**
   - Status mapping from platform-specific to standard statuses
   - Polling or webhook integration for status updates
   - Status history tracking

### Status Tracking

The Distribution Service maintains detailed status tracking throughout the distribution lifecycle.

#### Detailed Status Model

The service uses an extended status model beyond basic states:

```typescript
/**
 * Detailed distribution status types
 */
export enum DetailedDistributionStatus {
  // Initial States
  CREATED = 'created',                 // Distribution record created but not yet queued
  VALIDATING = 'validating',           // Validating content and metadata

  // Queue States
  QUEUED = 'queued',                   // In distribution queue
  SCHEDULED = 'scheduled',             // Scheduled for future distribution

  // Processing States
  PREPARING = 'preparing',             // Preparing files and metadata for delivery
  UPLOADING = 'uploading',             // Uploading to platform
  PROCESSING_BY_PLATFORM = 'processing_by_platform', // Being processed by platform

  // Outcome States
  DISTRIBUTED = 'distributed',         // Successfully distributed
  LIVE = 'live',                       // Confirmed live on platform
  FAILED = 'failed',                   // Distribution failed

  // Action States
  RETRYING = 'retrying',               // Retrying after failure
  NEEDS_ATTENTION = 'needs_attention', // Requires manual intervention

  // Modification States
  UPDATING = 'updating',               // Metadata being updated
  UPDATED = 'updated',                 // Metadata update complete

  // Removal States
  TAKEDOWN_REQUESTED = 'takedown_requested', // Takedown requested
  REMOVED = 'removed'                        // Content removed from platform
}
```

#### Status Transition Validation

The service enforces valid status transitions to maintain data integrity:

```typescript
/**
 * Validate that a status transition is allowed
 * 
 * @param fromStatus Current status
 * @param toStatus Target status
 * @returns Whether the transition is valid
 */
export function validateStatusTransition(
  fromStatus: DetailedDistributionStatus,
  toStatus: DetailedDistributionStatus
): boolean {
  // Define valid transitions for each status
  const validTransitions: Record<DetailedDistributionStatus, DetailedDistributionStatus[]> = {
    [DetailedDistributionStatus.CREATED]: [
      DetailedDistributionStatus.VALIDATING,
      DetailedDistributionStatus.QUEUED,
      DetailedDistributionStatus.FAILED
    ],
    [DetailedDistributionStatus.VALIDATING]: [
      DetailedDistributionStatus.QUEUED,
      DetailedDistributionStatus.NEEDS_ATTENTION,
      DetailedDistributionStatus.FAILED
    ],
    [DetailedDistributionStatus.QUEUED]: [
      DetailedDistributionStatus.PREPARING,
      DetailedDistributionStatus.SCHEDULED,
      DetailedDistributionStatus.FAILED
    ],
    // Additional transitions defined for all states...
  };

  // Check if transition is valid
  return validTransitions[fromStatus]?.includes(toStatus) || false;
}
```

#### Status History Tracking

Complete status history is maintained for auditing and analytics:

```typescript
/**
 * Create status history entry
 * 
 * @param distributionId Distribution record ID
 * @param fromStatus Previous status
 * @param toStatus New status
 * @param details Additional context
 * @returns Created history record
 */
async function recordStatusHistory(
  distributionId: number,
  fromStatus: string,
  toStatus: string,
  details?: any
): Promise<DistributionStatusHistory> {
  return storage.createDistributionStatusHistory({
    distributionId,
    previousStatus: fromStatus,
    newStatus: toStatus,
    changedAt: new Date(),
    changedBy: details?.userId || null,
    details: details || {}
  });
}
```

#### Status Aggregation

Aggregated status views are provided for releases distributed to multiple platforms:

```typescript
/**
 * Get aggregated distribution status for a release
 * 
 * @param releaseId Release ID
 * @returns Aggregated status summary
 */
export async function getAggregatedDistributionStatus(
  releaseId: number
): Promise<{
  overallStatus: string,
  platformStatuses: Array<{
    platformId: number,
    platformName: string,
    status: string,
    updatedAt: Date,
    details?: any
  }>,
  statistics: {
    total: number,
    completed: number,
    failed: number,
    inProgress: number,
    needsAttention: number
  }
}> {
  // Fetch all distribution records for this release
  const distributions = await storage.getDistributionRecordsByReleaseId(releaseId);

  // Calculate statistics
  const statistics = {
    total: distributions.length,
    completed: distributions.filter(d => 
      d.status === 'distributed' || d.status === 'live').length,
    failed: distributions.filter(d => 
      d.status === 'failed').length,
    inProgress: distributions.filter(d => 
      ['queued', 'preparing', 'uploading', 'processing_by_platform'].includes(d.status)).length,
    needsAttention: distributions.filter(d => 
      d.status === 'needs_attention').length
  };

  // Determine overall status based on statistics
  let overallStatus = 'not_started';
  if (statistics.total === 0) {
    overallStatus = 'not_started';
  } else if (statistics.completed === statistics.total) {
    overallStatus = 'completed';
  } else if (statistics.failed === statistics.total) {
    overallStatus = 'failed';
  } else if (statistics.needsAttention > 0) {
    overallStatus = 'needs_attention';
  } else if (statistics.inProgress > 0) {
    overallStatus = 'in_progress';
  } else {
    overallStatus = 'partial';
  }

  // Get platform details for each distribution
  const platformStatuses = await Promise.all(
    distributions.map(async dist => {
      const platform = await storage.getDistributionPlatformById(dist.platformId);
      return {
        platformId: dist.platformId,
        platformName: platform?.name || `Platform ID ${dist.platformId}`,
        status: dist.status,
        updatedAt: dist.updatedAt,
        details: dist.statusDetails
      };
    })
  );

  return {
    overallStatus,
    platformStatuses,
    statistics
  };
}
```

### Analytics Integration

The Distribution Service integrates with the Analytics Service to provide comprehensive insights into distribution performance.

#### Distribution Analytics

The service tracks key distribution metrics:

| Metric | Description | Use Case |
|--------|-------------|----------|
| **Success Rate** | Percentage of successful distributions | Platform reliability assessment |
| **Processing Time** | Time from submission to live on platform | Performance benchmarking |
| **Error Frequency** | Frequency of specific error types | Identifying systemic issues |
| **Platform Coverage** | Distribution across different platforms | Market reach analysis |
| **Distribution Volume** | Number of tracks/releases distributed | Capacity planning |
| **Geographic Coverage** | Territories where content is distributed | Market penetration |

#### Analytics Integration Points

```typescript
/**
 * Record distribution analytics event
 * 
 * @param eventType Type of distribution event
 * @param data Event data
 * @returns Created analytics record
 */
async function recordDistributionAnalytics(
  eventType: 'submission' | 'status_change' | 'completion' | 'error',
  data: any
): Promise<void> {
  try {
    const analyticsEvent = {
      type: `distribution.${eventType}`,
      timestamp: new Date(),
      userId: data.userId,
      releaseId: data.releaseId,
      trackId: data.trackId,
      platformId: data.platformId,
      metadata: {
        ...data,
        processingTimeMs: data.processingTimeMs || null,
        status: data.status || null,
        errorType: data.errorType || null
      }
    };

    await analyticsService.trackEvent(analyticsEvent);
  } catch (error) {
    // Log but don't fail the main operation
    logger.error(`Failed to record distribution analytics: ${error.message}`);
  }
}
```

#### Performance Dashboards

The analytics data powers several distribution dashboards:

- **Distribution Overview Dashboard** - High-level metrics
- **Platform Performance Dashboard** - Platform-specific metrics
- **Error Analysis Dashboard** - Error patterns and resolutions
- **Geographic Performance Dashboard** - Territory-based distribution metrics
- **Trend Analysis Dashboard** - Distribution metrics over time

### Performance Optimization

The Distribution Service implements several optimization strategies for high performance:

#### Batch Processing

For high-volume distributions:

```typescript
/**
 * Process a batch of distributions
 * 
 * @param releaseIds Array of release IDs to distribute
 * @param platformIds Array of platform IDs
 * @param options Batch processing options
 * @returns Batch processing results
 */
export async function processBatchDistribution(
  releaseIds: number[],
  platformIds: number[],
  options?: {
    concurrency?: number,
    priority?: 'high' | 'normal' | 'low',
    batchSize?: number
  }
): Promise<{
  jobId: string,
  totalJobs: number
}> {
  // Create batch job
  const batchId = uuidv4();
  const concurrency = options?.concurrency || 5;
  const batchSize = options?.batchSize || 50;

  // Process in chunks to avoid memory issues
  const allJobs = [];
  for (const releaseId of releaseIds) {
    for (const platformId of platformIds) {
      allJobs.push({ releaseId, platformId });
    }
  }

  const batches = [];
  for (let i = 0; i < allJobs.length; i += batchSize) {
    batches.push(allJobs.slice(i, i + batchSize));
  }

  // Process each batch
  let processedJobs = 0;
  for (const batch of batches) {
    await Promise.all(
      batch.map(async (job, index) => {
        // Stagger job creation to avoid platform rate limits
        await new Promise(resolve => 
          setTimeout(resolve, index * 100)
        );

        await distributionQueue.add(
          `distribute:${job.releaseId}:${job.platformId}`,
          {
            ...job,
            batchId,
            createdAt: new Date()
          },
          {
            priority: getPriorityValue(options?.priority),
            attempts: 3,
            backoff: {
              type: 'exponential',
              delay: 30000
            }
          }
        );

        processedJobs++;
      })
    );
  }

  return {
    jobId: batchId,
    totalJobs: processedJobs
  };
}
```

#### Concurrent Processing

Controlled concurrency for optimal throughput:

```typescript
// In distribution-job-processor.ts

// Create worker with concurrency limit
const worker = new Worker(
  'distribution-queue',
  async job => {
    return processDistributionJob(job);
  },
  { 
    concurrency: 10,
    connection: redisConnection
  }
);

// Handle processor events
worker.on('completed', (job, result) => {
  logger.info(`Job ${job.id} completed with result: ${JSON.stringify(result)}`);
});

worker.on('failed', (job, error) => {
  logger.error(`Job ${job.id} failed with error: ${error.message}`);
});
```

#### Caching Strategies

Caching for resource efficiency:

```typescript
// Platform configuration caching
const platformConfigCache = new Map<number, PlatformConfig>();
const CACHE_TTL = 3600000; // 1 hour

/**
 * Get platform configuration with caching
 * 
 * @param platformId Platform ID
 * @returns Platform configuration
 */
async function getPlatformConfig(platformId: number): Promise<PlatformConfig> {
  const now = Date.now();
  const cachedConfig = platformConfigCache.get(platformId);

  // Return from cache if valid
  if (cachedConfig && now - cachedConfig.fetchedAt < CACHE_TTL) {
    return cachedConfig.config;
  }

  // Fetch fresh configuration
  const platform = await storage.getDistributionPlatformById(platformId);
  if (!platform) {
    throw new Error(`Platform with ID ${platformId} not found`);
  }

  const config = {
    id: platform.id,
    name: platform.name,
    apiEndpoint: platform.apiEndpoint,
    deliveryMethod: platform.deliveryMethod,
    contentRequirements: platform.contentRequirements,
    metadataRequirements: platform.metadataRequirements,
    rateLimit: platform.rateLimit
  };

  // Update cache
  platformConfigCache.set(platformId, {
    config,
    fetchedAt: now
  });

  return config;
}
```

#### Database Optimizations

Efficient query patterns for distribution data:

```typescript
/**
 * Get distribution records with efficient querying
 * 
 * @param releaseId Release ID
 * @returns Optimized distribution query result
 */
async function getDistributionRecordsOptimized(
  releaseId: number
): Promise<DistributionRecord[]> {
  // Use indexed query with appropriate joins
  const query = db
    .select()
    .from(distributionRecords)
    .where(eq(distributionRecords.releaseId, releaseId))
    .leftJoin(
      distributionPlatforms,
      eq(distributionRecords.platformId, distributionPlatforms.id)
    )
    .orderBy(desc(distributionRecords.updatedAt));

  return await query;
}
```

### API Reference

#### Core Distribution APIs

```typescript
/**
 * Distribute a release to platforms
 * 
 * @param releaseId Release ID
 * @param platformIds Array of platform IDs
 * @param options Distribution options
 * @returns Distribution jobs created
 */
interface DistributeRelease {
  (releaseId: number, 
   platformIds: number[], 
   options?: {
     scheduleDate?: Date,
     priority?: 'high' | 'normal' | 'low',
     notifyOnCompletion?: boolean
   }): Promise<Array<{
     distributionId: number,
     platformId: number,
     jobId: string,
     status: string
   }>>;
}

/**
 * Check distribution status
 * 
 * @param distributionId Distribution record ID
 * @returns Current status with details
 */
interface CheckDistributionStatus {
  (distributionId: number): Promise<{
    distributionId: number,
    releaseId: number,
    platformId: number,
    platformName: string,
    status: string,
    statusDetails?: any,
    updatedAt: Date,
    history?: Array<{
      status: string,
      timestamp: Date,
      details?: any
    }>
  }>;
}

/**
 * Update distribution metadata
 * 
 * @param distributionId Distribution record ID
 * @param updates Metadata updates
 * @returns Success indicator
 */
interface UpdateDistributionMetadata {
  (distributionId: number, 
   updates: {
     title?: string,
     artistName?: string,
     releaseDate?: Date,
     // Additional metadata fields
   }): Promise<{
     success: boolean,
     jobId?: string,
     error?: string
   }>;
}

/**
 * Request content takedown
 * 
 * @param distributionId Distribution record ID
 * @param reason Takedown reason
 * @returns Success indicator
 */
interface RequestTakedown {
  (distributionId: number, 
   reason: string): Promise<{
     success: boolean,
     jobId?: string,
     error?: string
   }>;
}
```

#### Bulk Operations APIs

```typescript
/**
 * Bulk distribute releases
 * 
 * @param distributions Array of distribution requests
 * @returns Batch job details
 */
interface BulkDistribute {
  (distributions: Array<{
     releaseId: number,
     platformIds: number[],
     options?: {
       scheduleDate?: Date,
       priority?: 'high' | 'normal' | 'low'
     }
   }>): Promise<{
     batchId: string,
     totalJobs: number,
     estimatedCompletion: Date
   }>;
}

/**
 * Get bulk distribution job status
 * 
 * @param batchId Batch job ID
 * @returns Batch job status
 */
interface GetBulkDistributionStatus {
  (batchId: string): Promise<{
     batchId: string,
     status: 'pending' | 'processing' | 'completed' | 'failed' | 'partial',
     progress: {
       total: number,
       completed: number,
       failed: number,
       inProgress: number
     },
     startedAt: Date,
     updatedAt: Date,
     completedAt?: Date
   }>;
}
```

#### Administrative APIs

```typescript
/**
 * Platform management API
 */
interface ManagePlatform {
  /**
   * Add distribution platform
   */
  addPlatform(platform: {
    name: string,
    apiEndpoint: string,
    deliveryMethod: 'api' | 'ftp' | 'hybrid',
    contentRequirements: any,
    metadataRequirements: any,
    credentials?: any
  }): Promise<{
    id: number,
    name: string
  }>;

  /**
   * Update platform configuration
   */
  updatePlatform(platformId: number, updates: any): Promise<boolean>;

  /**
   * Test platform connection
   */
  testPlatformConnection(platformId: number): Promise<{
    connected: boolean,
    details?: string
  }>;
}

/**
 * Distribution monitoring API
 */
interface MonitorDistribution {
  /**
   * Get platform health status
   */
  getPlatformHealthStatus(): Promise<Array<{
    platformId: number,
    platformName: string,
    status: 'healthy' | 'degraded' | 'down',
    successRate: number,
    avgProcessingTimeMs: number,
    lastChecked: Date
  }>>;

  /**
   * Get failed distributions
   */
  getFailedDistributions(options?: {
    timeframe?: 'day' | 'week' | 'month',
    platformId?: number,
    errorCategory?: string
  }): Promise<Array<{
    distributionId: number,
    releaseId: number,
    platformId: number,
    errorCategory: string,
    errorDetails: string,
    failedAt: Date
  }>>;
}
```

### Best Practices

The following best practices should be followed when working with the Distribution Service:

#### Distribution Preparation

1. **Complete Metadata** - Ensure all required metadata is complete and accurate
2. **Quality Validation** - Validate audio quality exceeds platform minimums
3. **Asset Preparation** - Prepare artwork in all required formats and resolutions
4. **Rights Verification** - Verify all rights and clearances are properly documented
5. **Content ID Integration** - Ensure content ID registration when applicable

#### Platform Selection

1. **Target Audience** - Select platforms matching the content's target audience
2. **Territory Coverage** - Choose platforms covering all target territories
3. **Genre Relevance** - Prioritize platforms with strong presence in the content genre
4. **Feature Utilization** - Select platforms where content can utilize special features
5. **Analytics Support** - Consider platforms with robust analytics capabilities

#### Scheduling Strategy

1. **Release Windowing** - Consider strategic delays between platforms
2. **Optimal Timing** - Schedule for optimal days/times for the genre and audience
3. **Avoid Peak Congestion** - Avoid industry-wide peak release times
4. **Marketing Alignment** - Coordinate with marketing campaigns
5. **Consider Holidays** - Account for holidays and major cultural events

#### Error Recovery

1. **Validation First** - Validate content before submitting to reduce errors
2. **Monitor Constantly** - Monitor distribution status regularly
3. **Fast Response** - Address errors promptly to maintain momentum
4. **Document Patterns** - Document recurring issues and their solutions
5. **Platform Coordination** - Establish relationships with platform support for escalation

#### Performance Optimization

1. **Batch Processing** - Group similar distributions for efficiency
2. **Schedule Off-Peak** - Schedule bulk distributions during off-peak hours
3. **Prioritize Critical Content** - Use priority settings for important releases
4. **Cache Platform Data** - Cache platform requirements and configurations
5. **Progressive Loading** - Implement progressive loading for distribution status monitoring

---

**Document Information:**
- Version: 1.0
- Last Updated: March 25, 2025
- Contact: distribution-team@tunemantra.com

*Source: /home/runner/workspace/.archive/archive_docs/doc_backup/distribution-service.md*

---

## Reference to Duplicate Content (149)

## Reference to Duplicate Content

**Original Path:** all_md_files/PPv1/docs/tutorials/distribution-walkthrough.md

**Title:** TuneMantra Distribution Walkthrough

**MD5 Hash:** 1f282bf08608914fbc4db0714ada32b6

**Duplicate of:** unified_documentation/distribution/organized-distribution-walkthrough.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/PPv1_distribution-walkthrough.md.md*

---

## Reference to Duplicate Content (150)

## Reference to Duplicate Content

**Original Path:** all_md_files/PPv1/docs/user-guides/distribution.md

**Title:** Music Distribution Guide

**MD5 Hash:** 061504c95c503f146ba85807ec3fa2a6

**Duplicate of:** unified_documentation/distribution/organized-distribution.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/PPv1_distribution.md.md*

---

## Metadata for distribution-walkthrough.md

## Metadata for distribution-walkthrough.md

**Original Path:** all_md_files/organized/technical/distribution-walkthrough.md

**Title:** TuneMantra Distribution Walkthrough

**Category:** distribution

**MD5 Hash:** 1f282bf08608914fbc4db0714ada32b6

**Source Branch:** organized

**Note:** This file has duplicate content in other branches.


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/organized_distribution-walkthrough.md.md*

---

## Metadata for distribution.md

## Metadata for distribution.md

**Original Path:** all_md_files/organized/tutorials/distribution.md

**Title:** Music Distribution Guide

**Category:** distribution

**MD5 Hash:** 061504c95c503f146ba85807ec3fa2a6

**Source Branch:** organized

**Note:** This file has duplicate content in other branches.


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/organized_distribution.md.md*

---

## Reference to Duplicate Content (151)

## Reference to Duplicate Content

**Original Path:** all_md_files/replit-agent/docs/tutorials/distribution-walkthrough.md

**Title:** TuneMantra Distribution Walkthrough

**MD5 Hash:** 1f282bf08608914fbc4db0714ada32b6

**Duplicate of:** unified_documentation/distribution/organized-distribution-walkthrough.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/replit-agent_distribution-walkthrough.md.md*

---

## Reference to Duplicate Content (152)

## Reference to Duplicate Content

**Original Path:** all_md_files/replit-agent/docs/user-guides/distribution.md

**Title:** Music Distribution Guide

**MD5 Hash:** 061504c95c503f146ba85807ec3fa2a6

**Duplicate of:** unified_documentation/distribution/organized-distribution.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/replit-agent_distribution.md.md*

---

## Reference to Duplicate Content (153)

## Reference to Duplicate Content

**Original Path:** all_md_files/temp-extraction/docs/developer/architecture/distribution-service.md

**Title:** Distribution Service Architecture

**MD5 Hash:** bd974b1f08acb657db0a8a5519e554d0

**Duplicate of:** unified_documentation/distribution/temp-extraction-distribution-service.md


*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/metadata/temp-extraction_distribution-service.md.md*

---

## TuneMantra Distribution Walkthrough

## TuneMantra Distribution Walkthrough

This step-by-step tutorial guides you through the complete process of distributing your music using TuneMantra, from preparation to monitoring your release across platforms.

### Before You Begin

Before starting the distribution process, ensure you have:

1. **High-quality audio files**:
   - WAV format (16-bit, 44.1kHz or higher)
   - No clipping or audio artifacts
   - Properly mastered for streaming

2. **Professional cover artwork**:
   - Square image (minimum 3000×3000 pixels)
   - JPG or PNG format
   - No blurry images or text near edges
   - No unauthorized logos, watermarks, or URLs

3. **Complete metadata**:
   - Accurate artist name(s) and track titles
   - Composer/songwriter information
   - ISRC codes (if you have them)
   - Release date (plan at least 2 weeks ahead)

### Step 1: Prepare Your Audio Files

1. **Format Check**:
   - Open your audio files in an audio editor to verify they meet our requirements
   - Check duration (streaming platforms may reject tracks under 30 seconds)
   - Ensure there's no silence at the beginning/end (2-3 seconds max)

2. **File Naming**:
   - Name your files with track numbers and titles (e.g., "01 - Track Title.wav")
   - Use consistent naming across all files
   - Avoid special characters in filenames

3. **Final Listening Pass**:
   - Listen to your tracks one last time to ensure quality
   - Check for any issues that may have been missed in mastering
   - Verify that all tracks have consistent volume levels

### Step 2: Create a New Release

1. **Access the Distribution Section**:
   - Log in to your TuneMantra account
   - Navigate to "Distribution" → "New Release"

2. **Select Release Type**:
   - **Single**: 1-3 tracks
   - **EP**: 4-6 tracks
   - **Album**: 7+ tracks
   - **Compilation**: Multiple artists
   - **Remix**: Remix of existing tracks

3. **Enter Basic Release Information**:
   - Title: Your release title
   - Primary Artist: Your artist name
   - Release Date: When you want your music available (minimum 7 days from submission)
   - Genre: Primary genre of your release
   - Language: Primary language of your lyrics
   - Explicit Content: Yes/No (mark "Yes" if any tracks contain explicit content)

4. **Upload Cover Artwork**:
   - Click "Upload Cover Art"
   - Select your prepared artwork file
   - The system will verify that it meets requirements
   - Use the cropping tool if needed to adjust the image

### Step 3: Add Tracks to Your Release

1. **Upload Audio Files**:
   - Click "Add Tracks"
   - Select all your audio files
   - Wait for them to upload and process
   - The system will automatically detect track length and audio quality

2. **Complete Track Metadata**:
   - For each track, complete:
     - Track Title
     - Track Number
     - Featured Artists (if any)
     - Composers/Songwriters
     - Producers (optional)
     - ISRC Code (leave blank if you don't have one; TuneMantra will generate it)
     - Explicit Content flag (if applicable)
     - Lyrics (optional, but recommended)

3. **AI-Enhanced Metadata** (Optional):
   - Click "Enhance with AI" to use our content analysis
   - The system will suggest:
     - Genre and subgenre
     - Mood tags
     - Content warnings
     - Similar artists
     - BPM and key detection
   - Review and approve AI suggestions

### Step 4: Configure Distribution Details

1. **Select Distribution Platforms**:
   - By default, all 150+ platforms are selected
   - Use the filter to select/deselect platforms by category:
     - Streaming Services
     - Download Stores
     - Social Media Platforms
     - Video Platforms
   - Select or deselect individual platforms as needed

2. **Set Territory Restrictions** (Optional):
   - By default, your release will be distributed worldwide
   - Click "Customize Territories" to restrict distribution:
     - Include specific territories only
     - Exclude specific territories
     - Set platform-specific territory rules

3. **Configure Pre-save Campaign** (Optional):
   - Enable pre-save campaign
   - Customize pre-save landing page:
     - Add custom message
     - Include social media links
     - Upload promotional images
   - Set notification preferences for pre-save updates

### Step 5: Set Royalty Splits

1. **Configure Royalty Sharing**:
   - Click "Manage Royalty Splits"
   - By default, 100% goes to the primary artist
   - To add collaborators:
     - Click "Add Collaborator"
     - Enter email address
     - Specify role (featured artist, producer, etc.)
     - Assign percentage share
     - Repeat for all collaborators
   - Verify that percentages total 100%

2. **Send Invitations to Collaborators**:
   - Review split information
   - Click "Send Invitations"
   - Collaborators will receive emails to confirm their splits
   - Track acceptance status in your dashboard

### Step 6: Review and Submit

1. **Final Review**:
   - Click "Review Release" to see a complete summary
   - Verify all information is accurate:
     - Release information
     - Track details
     - Cover art
     - Platform selection
     - Royalty splits

2. **Terms Acceptance**:
   - Read the distribution agreement
   - Check the box to confirm you have rights to distribute this content
   - Check the box to agree to platform-specific terms

3. **Submit for Distribution**:
   - Click "Submit for Distribution"
   - Receive a confirmation screen with your release ID
   - You'll also receive a confirmation email with release details

### Step 7: Track the Distribution Process

1. **View Distribution Status**:
   - Navigate to "Distribution" → "My Releases"
   - Find your release in the list
   - The status indicator shows current stage:
     - **Pending Review**: Awaiting initial checks
     - **Processing**: Being prepared for delivery
     - **Distributing**: Being delivered to platforms
     - **Distributed**: Successfully delivered to all platforms
     - **Live**: Available on platforms

2. **Platform-Specific Status**:
   - Click on your release to view detailed status
   - See platform-by-platform status:
     - **Pending**: Not yet delivered
     - **Delivered**: Sent to platform
     - **Processing**: Being processed by platform
     - **Live**: Available on platform
     - **Rejected**: Rejected by platform (with reason)

3. **Handle Rejections** (If Any):
   - If a platform rejects your release, you'll see the reason
   - Common reasons include:
     - Cover art issues
     - Metadata problems
     - Audio quality concerns
   - Click "Fix Issues" to update rejected elements
   - Resubmit to rejected platforms only

### Step 8: Connect Streaming Links

Once your release is live on platforms:

1. **Collect Store Links**:
   - TuneMantra automatically collects links as they become available
   - Navigate to "Distribution" → "My Releases" → [Your Release]
   - View the "Store Links" tab to see all platforms

2. **Create Smart Link**:
   - Click "Create Smart Link"
   - Customize your smart link landing page:
     - Select layout template
     - Add custom text
     - Upload additional promotional images
     - Configure social sharing options
   - Save and get your shareable link

3. **Share Your Release**:
   - Use the smart link in all your promotion
   - The link will direct fans to their preferred platform
   - Track click statistics in your dashboard

### Step 9: Monitor Performance

1. **View Analytics Dashboard**:
   - Navigate to "Analytics" → "Overview"
   - Select your release from the dropdown
   - View key performance metrics:
     - Total streams and downloads
     - Revenue generated
     - Geographic distribution
     - Platform breakdown

2. **Track Platform Performance**:
   - Navigate to "Analytics" → "Platforms"
   - Compare performance across different services
   - Identify which platforms work best for your music
   - Use insights to guide future promotion

3. **Geographic Analysis**:
   - Navigate to "Analytics" → "Geography"
   - See where your listeners are located
   - Identify strong markets for targeted promotion
   - Discover emerging markets for your music

### Step 10: Post-Release Optimization

1. **Identify Promotion Opportunities**:
   - Review performance data to find:
     - Platforms with strong performance
     - Territories with high engagement
     - Underperforming areas with potential

2. **Update Store Presence**:
   - Add playlist placements to your release profile
   - Update artist bio across platforms
   - Add links to music videos or related content

3. **Plan Future Releases**:
   - Use performance data to guide your strategy
   - Schedule regular releases to maintain momentum
   - Consider platform-exclusive content for strong platforms

### Troubleshooting Common Issues

#### Distribution Delays

If your release is taking longer than expected:

1. Check the status in your dashboard for platform-specific issues
2. Verify that all collaborators have approved royalty splits
3. Contact support if status hasn't changed for more than 7 days

#### Platform Rejections

If a platform rejects your release:

1. Check the rejection reason in your dashboard
2. Make the required changes to your release
3. Resubmit to the rejected platform
4. Monitor for approval

#### Missing Store Links

If store links aren't appearing:

1. Verify that the platform status shows "Live"
2. Allow 24-48 hours for links to be collected
3. Use the "Report Missing Link" feature if links don't appear
4. Support can manually add missing links

### Next Steps

Congratulations on distributing your music! To maximize your release's potential:

- Explore our [Analytics Guide](./analytics-usage.md) to understand your performance data
- Learn about [Royalty Management](./royalty-management.md) to track and withdraw your earnings
- Check out our [Marketing Tools](../guides/marketing-tools.md) to promote your music effectively

For personalized guidance, consider booking a consultation with our A&R experts through the "Services" tab in your dashboard.

*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/tutorials/distribution-walkthrough.md*

---

## Music Distribution Guide (2)

## Music Distribution Guide

**Last Updated:** March 23, 2025  
**Version:** 1.0

### Table of Contents

1. [Introduction](#1-introduction)
2. [Distribution Overview](#2-distribution-overview)
3. [Preparing Your Release](#3-preparing-your-release)
4. [Distribution Process](#4-distribution-process)
5. [Platform Requirements](#5-platform-requirements)
6. [Managing Releases](#6-managing-releases)
7. [Distribution Analytics](#7-distribution-analytics)
8. [Troubleshooting](#8-troubleshooting)
9. [Best Practices](#9-best-practices)

### 1. Introduction

This guide explains how to use TuneMantra's music distribution features to deliver your music to major streaming platforms. TuneMantra simplifies the distribution process, allowing you to reach global audiences while maintaining complete control over your catalog.

#### 1.1 Supported Platforms

TuneMantra distributes to all major streaming and download platforms, including:

- Spotify
- Apple Music
- Amazon Music
- YouTube Music
- TikTok
- Deezer
- Tidal
- SoundCloud
- Pandora
- Resso
- And many more

#### 1.2 Distribution Benefits

With TuneMantra's distribution system, you'll enjoy:

- **Worldwide Reach**: Distribute to 150+ global platforms
- **Centralized Management**: Manage all your releases from one dashboard
- **Detailed Analytics**: Track performance across all platforms
- **Royalty Tracking**: Automated royalty collection and reporting
- **Control**: Schedule releases, set pricing, and manage metadata
- **Quick Turnaround**: Fast processing and delivery to platforms

### 2. Distribution Overview

#### 2.1 Distribution Workflow

The distribution process in TuneMantra follows these steps:

1. **Create a Release**: Upload tracks, artwork, and metadata
2. **Select Platforms**: Choose which platforms to distribute to
3. **Review & Submit**: Check for errors and submit for distribution
4. **Distribution Processing**: Your release is processed and delivered to platforms
5. **Platform Review**: Platforms review your content (typically 1-7 days)
6. **Live on Platforms**: Your music becomes available to listeners
7. **Analytics & Royalties**: Track performance and earnings

#### 2.2 Distribution Timeline

The typical timeline for distribution:

| Stage | Timeline |
|-------|----------|
| TuneMantra Processing | 1-2 business days |
| Platform Review | 3-7 business days (varies by platform) |
| Total Time to Go Live | 4-10 business days (average) |

**Note**: Schedule your releases at least 2-3 weeks in advance to account for potential delays and to ensure proper promotion.

#### 2.3 Distribution Costs

Distribution costs depend on your TuneMantra subscription tier:

| Tier | Distribution Fee | Annual Maintenance |
|------|------------------|-------------------|
| Basic | $9.99 per single | $19.99 per year |
| Pro | Unlimited releases | Included |
| Label | Unlimited releases | Included |

### 3. Preparing Your Release

#### 3.1 Audio Requirements

For the best results, ensure your audio meets these specifications:

- **File Format**: WAV (preferred) or FLAC
- **Sample Rate**: 44.1 kHz or higher
- **Bit Depth**: 16-bit or 24-bit
- **Channels**: Stereo
- **Quality**: No clipping, distortion, or unwanted noise
- **Maximum Length**: 10 minutes per track (for standard distribution)

#### 3.2 Artwork Requirements

Your cover artwork must meet these requirements:

- **File Format**: JPG or PNG
- **Dimensions**: Minimum 3000 x 3000 pixels (square aspect ratio)
- **Resolution**: 300 DPI minimum
- **Color Space**: RGB
- **File Size**: Maximum 10MB

#### 3.3 Metadata Requirements

Essential metadata for your release:

- **Release Title**: Title of your album, EP, or single
- **Artist Name**: Primary artist name(s)
- **UPC Code**: Universal Product Code (TuneMantra can generate this for you)
- **Release Type**: Album, EP, Single, Compilation, etc.
- **Genre**: Primary and secondary genres
- **Release Date**: When you want your music to go live
- **Explicit Content**: Yes/No for each track
- **Copyright Information**: Year and copyright holder
- **Language**: Primary language of lyrics

#### 3.4 Track Metadata

For each track, you'll need:

- **Track Title**: Title of the track
- **Track Artists**: Primary and featuring artists
- **ISRC**: International Standard Recording Code (TuneMantra can generate this)
- **Songwriter/Composer Credits**: All songwriters and composers
- **Producer Credits**: Production credits
- **Lyrics**: Optional but recommended
- **Track Number & Position**: Order in the release

### 4. Distribution Process

#### 4.1 Creating a New Release

To create a new release:

1. From your dashboard, click **Catalog** → **New Release**
2. Select the release type (Single, EP, Album, etc.)
3. Enter the release title and primary artist name
4. Upload your cover artwork
5. Enter release details (genre, language, release date, etc.)
6. Click **Save and Continue**

#### 4.2 Adding Tracks

To add tracks to your release:

1. On the release page, click **Add Track**
2. Upload the audio file
3. Enter track metadata (title, artists, lyrics, etc.)
4. Specify whether the track contains explicit content
5. Add songwriter and production credits
6. Click **Save Track**
7. Repeat for all tracks in the release

#### 4.3 Selecting Distribution Platforms

To select platforms for distribution:

1. Navigate to the **Distribution** tab of your release
2. Check the platforms you want to distribute to
3. For each platform, review any platform-specific requirements
4. Adjust pricing and availability settings if needed
5. Click **Save Platforms**

#### 4.4 Scheduling a Release

To schedule your release:

1. On the Distribution tab, set your **Release Date**
2. Choose between **Immediate Processing** or **Scheduled Processing**
3. For scheduled processing, select the processing date
4. Review platform-specific delivery times
5. Click **Schedule Distribution**

#### 4.5 Submitting for Distribution

To submit your release for distribution:

1. Review all release information for accuracy
2. Run the **Pre-Distribution Check** to identify potential issues
3. Correct any flagged issues
4. Accept the distribution agreement
5. Click **Submit for Distribution**

#### 4.6 Tracking Distribution Status

To track your distribution progress:

1. Go to **Catalog** → **Releases**
2. Select your release
3. Navigate to the **Distribution** tab
4. Check the status for each platform:
   - **Pending**: Awaiting processing
   - **Processing**: Being prepared for delivery
   - **Delivered**: Sent to the platform
   - **Live**: Available on the platform
   - **Failed**: Distribution encountered an error

### 5. Platform Requirements

#### 5.1 Platform-Specific Guidelines

Each platform has unique requirements. Here are important guidelines for major platforms:

##### 5.1.1 Spotify

- Allows pre-saves before release date
- Requires minimum 72 hours for delivery
- Supports Canvas videos (short looping visuals)
- Artist profile requires separate verification process

##### 5.1.2 Apple Music

- Requires high-quality metadata
- Additional fields for composer and lyricist credits
- Supports lossless and Dolby Atmos formats
- Digital Booklet support for albums

##### 5.1.3 YouTube Music

- Title/artwork must match across platforms
- Supports Art Track creation
- Content ID system to protect against infringement
- Auto-syncs with YouTube channels when linked

##### 5.1.4 TikTok

- Specific delivery format for short-form content
- Track previews optimized for TikTok
- Special licensing for TikTok commercial usage
- Enhanced visibility for trending tracks

#### 5.2 Content Restrictions

Ensure your content follows these guidelines:

- **Copyright**: You must own or have licensed all content
- **Samples**: All samples must be legally cleared
- **Covers**: Mechanical licenses required for cover songs
- **Explicit Content**: Must be properly labeled
- **Prohibited Content**: No hate speech, illegal content, or excessive profanity
- **Sound Quality**: No excessive noise, distortion, or errors

### 6. Managing Releases

#### 6.1 Viewing Your Catalog

To view your released catalog:

1. Go to **Catalog** → **Releases**
2. Use filters to sort by status, date, or platform
3. Click on any release to view details

#### 6.2 Updating Release Information

To update release information:

1. Select the release from your catalog
2. Click **Edit Release**
3. Make your changes
4. Click **Save Changes**
5. If necessary, click **Redelivery** to send updates to platforms

**Note**: Some metadata cannot be changed after distribution. Major changes may require takedown and redistribution.

#### 6.3 Takedowns

To remove a release from platforms:

1. Select the release from your catalog
2. Click **Distribution** → **Manage Platforms**
3. Select platforms for takedown
4. Click **Request Takedown**
5. Provide a reason for the takedown
6. Click **Confirm Takedown**

**Note**: Takedowns typically process within 1-7 days depending on the platform.

#### 6.4 Redelivery

To redeliver an updated release:

1. Update your release information
2. Click **Distribution** → **Redelivery**
3. Select the platforms to receive updates
4. Click **Submit Redelivery**

**Note**: Redelivery is for minor metadata changes only. For audio changes, a takedown and new release is required.

### 7. Distribution Analytics

#### 7.1 Distribution Performance

To view distribution performance:

1. Go to **Analytics** → **Distribution**
2. Select the release to analyze
3. View the distribution timeline and status across platforms
4. Analyze platform-specific delivery times
5. Identify any distribution issues

#### 7.2 Platform Coverage

To check your platform coverage:

1. Go to **Analytics** → **Platform Coverage**
2. View the percentage of available platforms your music is on
3. Identify platforms where your music is missing
4. Use the **Expand Coverage** option to distribute to additional platforms

#### 7.3 Geographic Distribution

To analyze geographic distribution:

1. Go to **Analytics** → **Geography**
2. View a map showing where your music is available
3. Identify regions with distribution gaps
4. Check for region-specific restrictions

### 8. Troubleshooting

#### 8.1 Common Distribution Issues

| Issue | Possible Cause | Solution |
|-------|----------------|----------|
| Rejected by Platform | Metadata doesn't meet requirements | Review platform guidelines and correct metadata |
| Failed Processing | Audio quality issues | Upload higher quality audio files |
| Delayed Appearance | Platform backlog | Wait for platform processing (up to 7 days) |
| Missing from Platform | Distribution still in progress | Check distribution status in dashboard |
| Wrong Artist Profile | Artist name matches existing artist | Add a unique identifier to artist name |

#### 8.2 Error Resolution

If you encounter distribution errors:

1. Go to **Catalog** → **Releases** → Your Release
2. Check the **Distribution** tab for specific error messages
3. Click on the error message for recommended solutions
4. Make necessary corrections
5. Click **Retry Distribution** for failed platforms

#### 8.3 Support Resources

If you need additional help:

- **Knowledge Base**: Visit our help center for articles
- **Video Tutorials**: Step-by-step distribution guidance
- **Live Chat**: Available 24/7 for immediate assistance
- **Email Support**: support@tunemantra.com
- **Distribution Specialists**: Schedule a call with our team

### 9. Best Practices

#### 9.1 Distribution Strategy

For maximum impact:

- **Release Schedule**: Maintain a consistent release schedule
- **Lead Time**: Submit 2-3 weeks before intended release date
- **Release Day**: Friday releases often perform best (align with Spotify's New Music Friday)
- **Platform Focus**: Consider platform-exclusive content for major releases
- **Seasonal Timing**: Align releases with relevant seasons or holidays

#### 9.2 Pre-Save Campaigns

To maximize pre-release engagement:

1. Distribute your release 3-4 weeks before release date
2. Enable pre-save functionality in the distribution settings
3. Use the generated pre-save link in your marketing
4. Track pre-save analytics in your dashboard
5. Send notifications to fans when the release goes live

#### 9.3 Metadata Optimization

For better discovery:

- **Consistent Artist Name**: Use the same spelling across all releases
- **Descriptive Titles**: Clear, searchable titles without special characters
- **Genre Selection**: Choose the most accurate primary and secondary genres
- **Detailed Credits**: Complete all credits fields for proper attribution
- **Mood Tags**: Add appropriate mood tags to improve playlist placement

#### 9.4 Distribution Checklist

Before submitting, verify:

- [ ] Audio files meet quality standards
- [ ] Artwork meets resolution requirements
- [ ] All required metadata is complete and accurate
- [ ] UPC and ISRC codes are assigned
- [ ] Release date gives sufficient lead time
- [ ] All artists and collaborators are credited
- [ ] Rights and licensing are properly secured
- [ ] Platform-specific requirements are met

By following this guide, you'll be able to efficiently distribute your music to global audiences, maximize your reach, and effectively manage your catalog through the TuneMantra platform.

*Source: /home/runner/workspace/.archive/archive_docs/documentation/backup/user-guides/distribution.md*

---

## Distribution Service Architecture (2)

## Distribution Service Architecture

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

*Source: /home/runner/workspace/.archive/archive_docs/documentation/distribution/temp-extraction-distribution-service.md*

---

## Distribution Service\n\nThis document details the distribution service implemented in the TuneMantra platform.

## Distribution Service\n\nThis document details the distribution service implemented in the TuneMantra platform.


*Source: /home/runner/workspace/.archive/archive_docs/documentation_backup_20250330/documentation/new_structure/technical/services/distribution-service.md*

---

