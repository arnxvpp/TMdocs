# TuneMantra Data Models

<div align="center">
  <img src="../../diagrams/data-models-header.svg" alt="TuneMantra Data Models" width="800"/>
</div>

## Introduction

This document provides a comprehensive overview of TuneMantra's data models, their relationships, and implementation details. The data architecture is designed around domain-driven principles, with clear boundaries between different functional areas while maintaining the necessary relationships for cross-domain operations.

The database uses PostgreSQL with Drizzle ORM for type-safe access and schema management. The schema is organized by domain contexts with careful consideration for performance, integrity, and scalability.

## Table of Contents

- [Schema Overview](#schema-overview)
- [Core Data Models](#core-data-models)
- [User Management Domain](#user-management-domain)
- [Content Management Domain](#content-management-domain)
- [Distribution Domain](#distribution-domain)
- [Rights Management Domain](#rights-management-domain)
- [Financial Domain](#financial-domain)
- [Analytics Domain](#analytics-domain)
- [Data Relationships](#data-relationships)
- [Schema Evolution](#schema-evolution)

## Schema Overview

TuneMantra's database schema is divided into distinct domains, each representing a core business capability:

<div align="center">
  <img src="../../diagrams/schema-domains.svg" alt="Schema Domains" width="700"/>
</div>

Each domain has its own set of tables with clear responsibilities:

1. **User Management Domain**
   - Handles user accounts, teams, and permissions
   - Manages authentication and authorization data
   - Stores profile and preference information

2. **Content Management Domain**
   - Manages tracks, releases, and artists
   - Handles metadata and assets
   - Tracks content relationships and versions

3. **Distribution Domain**
   - Manages platform connections and delivery
   - Tracks distribution status and availability
   - Stores platform-specific requirements and metadata

4. **Rights Management Domain**
   - Tracks ownership and rights claims
   - Manages splits and shares
   - Stores contracts and agreements

5. **Financial Domain**
   - Processes royalty calculations
   - Manages payment information
   - Tracks transactions and statements

6. **Analytics Domain**
   - Stores performance metrics
   - Manages report data and configurations
   - Tracks user engagement and platform statistics

## Core Data Models

The primary entities that form the foundation of TuneMantra's data model:

### User

The `users` table represents platform users and their core attributes:

```typescript
export const users = pgTable("users", {
  id: serial("id").primaryKey(),
  username: text("username").notNull().unique(),
  email: text("email").notNull().unique(),
  passwordHash: text("password_hash").notNull(),
  firstName: text("first_name"),
  lastName: text("last_name"),
  role: userRoleEnum("role").default("artist").notNull(),
  status: userStatusEnum("status").default("pending").notNull(),
  parentId: integer("parent_id").references(() => users.id),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  lastLoginAt: timestamp("last_login_at"),
  profileImageUrl: text("profile_image_url"),
  timezone: text("timezone").default("UTC"),
  accountSettings: jsonb("account_settings"),
  notificationPreferences: jsonb("notification_preferences"),
  verificationStatus: approvalStatusEnum("verification_status").default("pending"),
  labelSettings: jsonb("label_settings"),
  marketingConsent: boolean("marketing_consent").default(false),
  taxId: text("tax_id"),
  dateOfBirth: date("date_of_birth"),
  country: text("country"),
  city: text("city"),
  address: text("address"),
  postalCode: text("postal_code"),
  phone: text("phone"),
  website: text("website"),
  biography: text("biography"),
  businessName: text("business_name"),
  businessType: text("business_type"),
  isAdmin: boolean("is_admin").default(false),
  isVerified: boolean("is_verified").default(false),
  isBanned: boolean("is_banned").default(false),
});
```

Key aspects:
- Support for hierarchical relationships (parent labels with sub-users)
- Role-based access control
- Account status tracking
- Rich profile data
- Flexible JSON settings for preferences and configurations
- Verification and compliance tracking

### Track

The `tracks` table represents individual audio recordings and their metadata:

```typescript
export const tracks = pgTable("tracks", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  title: text("title").notNull(),
  isrc: text("isrc").unique(),
  duration: integer("duration"),
  releaseDate: date("release_date"),
  recordingDate: date("recording_date"),
  language: text("language"),
  explicit: boolean("explicit").default(false),
  primaryGenre: text("primary_genre"),
  secondaryGenres: text("secondary_genres").array(),
  bpm: integer("bpm"),
  key: text("key"),
  moods: text("moods").array(),
  tags: text("tags").array(),
  lyrics: text("lyrics"),
  description: text("description"),
  audioFileUrl: text("audio_file_url"),
  waveformUrl: text("waveform_url"),
  coverArtUrl: text("cover_art_url"),
  status: text("status").default("draft").notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  primaryArtist: text("primary_artist").notNull(),
  featuredArtists: text("featured_artists").array(),
  composers: text("composers").array(),
  lyricists: text("lyricists").array(),
  producers: text("producers").array(),
  metadata: jsonb("metadata"),
  aiTags: jsonb("ai_tags"),
  royaltyEligible: boolean("royalty_eligible").default(true),
  originalReleaseDate: date("original_release_date"),
  recordLabel: text("record_label"),
  publisher: text("publisher"),
  copyrightText: text("copyright_text"),
  publicationYear: integer("publication_year"),
  contentTags: jsonb("content_tags"),
  aiAnalysis: jsonb("ai_analysis"),
  credits: jsonb("credits"),
  audioMetadata: jsonb("audio_metadata"),
  sampleDetails: jsonb("sample_details"),
  stemFiles: jsonb("stem_files"),
});
```

Key aspects:
- Comprehensive music metadata
- Support for multiple contributors (artists, composers, producers)
- Advanced music attributes (BPM, key, moods)
- Audio file references
- AI-enhanced metadata for discovery
- Detailed rights information
- Technical audio information

### Release

The `releases` table represents collections of tracks for distribution:

```typescript
export const releases = pgTable("releases", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  title: text("title").notNull(),
  upc: text("upc").unique(),
  releaseDate: date("release_date"),
  originalReleaseDate: date("original_release_date"),
  recordLabel: text("record_label"),
  catalogNumber: text("catalog_number"),
  primaryGenre: text("primary_genre"),
  secondaryGenres: text("secondary_genres").array(),
  language: text("language"),
  explicit: boolean("explicit").default(false),
  type: text("type").default("single").notNull(),
  status: text("status").default("draft").notNull(),
  coverArtUrl: text("cover_art_url"),
  description: text("description"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  preOrderDate: date("pre_order_date"),
  primaryArtist: text("primary_artist").notNull(),
  featuredArtists: text("featured_artists").array(),
  compilationArtists: text("compilation_artists").array(),
  metadata: jsonb("metadata"),
  contentWarnings: text("content_warnings").array(),
  copyrightText: text("copyright_text"),
  publishingRights: text("publishing_rights"),
  territoriesExcluded: text("territories_excluded").array(),
  notes: text("notes"),
  visibilitySettings: jsonb("visibility_settings"),
  artwork: jsonb("artwork"),
  distributionStatus: distributionStatusEnum("distribution_status").default("pending"),
  distributionDate: timestamp("distribution_date"),
  contentType: contentTypeEnum("content_type").default("single"),
  contentTags: jsonb("content_tags"),
  aiAnalysis: jsonb("ai_analysis"),
  credits: jsonb("credits"),
  artworkMetadata: jsonb("artwork_metadata"),
});
```

Key aspects:
- Complete release metadata for distribution
- Support for various release types (singles, albums, EPs)
- Territory restrictions and visibility settings
- Distribution status tracking
- Enhanced artwork information
- AI-powered content analysis
- Detailed credits information

### Distribution Records

The `distributionRecords` table tracks the delivery of releases to platforms:

```typescript
export const distributionRecords = pgTable("distribution_records", {
  id: serial("id").primaryKey(),
  releaseId: integer("release_id").notNull().references(() => releases.id),
  platformId: integer("platform_id").notNull().references(() => distributionPlatforms.id),
  status: distributionStatusEnum("status").default("pending").notNull(),
  distributedAt: timestamp("distributed_at"),
  lastStatusUpdate: timestamp("last_status_update").defaultNow().notNull(),
  platformReleaseId: text("platform_release_id"),
  platformUrl: text("platform_url"),
  errors: jsonb("errors"),
  takedownRequested: boolean("takedown_requested").default(false),
  takedownReason: text("takedown_reason"),
  takedownRequestedAt: timestamp("takedown_requested_at"),
  takedownCompletedAt: timestamp("takedown_completed_at"),
  metadata: jsonb("metadata"),
  scheduledAt: timestamp("scheduled_at"),
  attemptCount: integer("attempt_count").default(0),
  deliveryMethod: text("delivery_method").default("api"),
  platformFeedback: jsonb("platform_feedback"),
  territories: text("territories").array(),
  analyticsSource: text("analytics_source"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  processingDetails: jsonb("processing_details"),
  deliveryPackageUrl: text("delivery_package_url"),
  platformSpecificMetadata: jsonb("platform_specific_metadata"),
  errorCategory: text("error_category"),
  errorDetails: text("error_details"),
  errorResolution: text("error_resolution"),
  distributionBatchId: integer("distribution_batch_id"),
});
```

Key aspects:
- Platform-specific distribution tracking
- Detailed status and error information
- Takedown request handling
- Platform identifiers and URLs
- Territory-specific distribution
- Delivery method and package details
- Error categorization and resolution tracking

### Rights Claims

The `rightsManagement` table tracks ownership claims on content:

```typescript
export const rightsManagement = pgTable("rights_management", {
  id: serial("id").primaryKey(),
  entityType: text("entity_type").notNull(), // "track" or "release"
  entityId: integer("entity_id").notNull(),
  rightType: roleTypeEnum("right_type").notNull(),
  rightHolder: text("right_holder").notNull(),
  rightHolderType: text("right_holder_type").notNull(), // "user", "label", "publisher", "organization"
  rightHolderId: integer("right_holder_id"),
  percentage: numeric("percentage").notNull(),
  startDate: date("start_date").notNull(),
  endDate: date("end_date"),
  territory: text("territory").array(),
  documentUrl: text("document_url"),
  verificationStatus: approvalStatusEnum("verification_status").default("pending"),
  verifiedBy: integer("verified_by").references(() => users.id),
  verifiedAt: timestamp("verified_at"),
  createdBy: integer("created_by").notNull().references(() => users.id),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  notes: text("notes"),
  metadata: jsonb("metadata"),
  ownershipType: ownershipTypeEnum("ownership_type").default("original"),
  isExclusive: boolean("is_exclusive").default(true),
  agreementType: text("agreement_type"),
  agreementId: text("agreement_id"),
  rightsConflict: boolean("rights_conflict").default(false),
  conflictDetails: jsonb("conflict_details"),
  chainOfTitle: jsonb("chain_of_title"),
});
```

Key aspects:
- Flexible rights tracking for different entity types
- Percentage-based ownership
- Time-bound rights (start/end dates)
- Territory-specific rights
- Verification workflow
- Documentation references
- Conflict detection and resolution
- Chain of title tracking

### Royalty Calculations

The `royaltyCalculations` table tracks financial earning computations:

```typescript
export const royaltyCalculations = pgTable("royalty_calculations", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  entityType: text("entity_type").notNull(), // "track" or "release"
  entityId: integer("entity_id").notNull(),
  platformId: integer("platform_id").references(() => distributionPlatforms.id),
  period: text("period").notNull(), // e.g., "2023-03"
  streams: integer("streams"),
  downloads: integer("downloads"),
  amount: numeric("amount").notNull(),
  currency: text("currency").default("USD").notNull(),
  exchangeRate: numeric("exchange_rate").default("1"),
  status: text("status").default("pending").notNull(),
  paidAt: timestamp("paid_at"),
  statementId: integer("statement_id"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  calculationDetails: jsonb("calculation_details"),
  paymentBatchId: integer("payment_batch_id"),
  adjustments: jsonb("adjustments"),
  splitPayments: jsonb("split_payments"),
  royaltySource: text("royalty_source").default("streaming"),
  royaltyType: royaltyTypeEnum("royalty_type").default("performance"),
  territoryCode: text("territory_code"),
  taxWithheld: numeric("tax_withheld").default("0"),
  grossAmount: numeric("gross_amount"),
  processingFee: numeric("processing_fee").default("0"),
  distributionFee: numeric("distribution_fee").default("0"),
  netAmount: numeric("net_amount"),
  recoupmentApplied: numeric("recoupment_applied").default("0"),
  advanceBalance: numeric("advance_balance"),
  paymentMethod: text("payment_method"),
  transactionId: text("transaction_id"),
  sourceData: jsonb("source_data"),
});
```

Key aspects:
- Track and release earnings
- Platform and territory-specific calculations
- Period-based tracking
- Currency and exchange rate handling
- Detailed calculation components
- Split payment tracking
- Tax withholding
- Fee and deduction transparency
- Advance recoupment tracking
- Comprehensive financial details

## User Management Domain

The user management domain handles all aspects of user accounts, authentication, teams, and permissions:

### User Profiles

Extended user information beyond the core user table:

```typescript
export const userProfiles = pgTable("user_profiles", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id).unique(),
  displayName: text("display_name"),
  bio: text("bio"),
  location: text("location"),
  website: text("website"),
  socialLinks: jsonb("social_links"),
  profileCompleteness: integer("profile_completeness").default(0),
  coverImageUrl: text("cover_image_url"),
  genres: text("genres").array(),
  influences: text("influences").array(),
  skills: text("skills").array(),
  yearsActive: integer("years_active"),
  careerLevel: text("career_level"),
  verifiedArtist: boolean("verified_artist").default(false),
  publicProfile: boolean("public_profile").default(true),
  featuredWork: jsonb("featured_work"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
});
```

### Teams

Team management for multi-user accounts:

```typescript
export const teams = pgTable("teams", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  ownerId: integer("owner_id").notNull().references(() => users.id),
  description: text("description"),
  avatarUrl: text("avatar_url"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  type: text("type").default("default"),
  inviteCode: text("invite_code"),
  settings: jsonb("settings"),
  status: text("status").default("active"),
});
```

### Team Members

Connects users to teams with specific roles:

```typescript
export const teamMembers = pgTable("team_members", {
  id: serial("id").primaryKey(),
  teamId: integer("team_id").notNull().references(() => teams.id),
  userId: integer("user_id").notNull().references(() => users.id),
  role: text("role").default("member").notNull(),
  permissions: jsonb("permissions"),
  joinedAt: timestamp("joined_at").defaultNow().notNull(),
  invitedBy: integer("invited_by").references(() => users.id),
  status: text("status").default("active").notNull(),
  lastActiveAt: timestamp("last_active_at"),
});
```

### API Keys

For programmatic access to the platform:

```typescript
export const apiKeys = pgTable("api_keys", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  name: text("name").notNull(),
  key: text("key").notNull().unique(),
  scopes: text("scopes").array(),
  expiresAt: timestamp("expires_at"),
  lastUsedAt: timestamp("last_used_at"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  isActive: boolean("is_active").default(true),
  ipRestrictions: text("ip_restrictions").array(),
  rateLimit: integer("rate_limit"),
});
```

### Sessions

Manages user login sessions:

```typescript
export const sessions = pgTable("sessions", {
  id: text("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  userAgent: text("user_agent"),
  ipAddress: text("ip_address"),
  expiresAt: timestamp("expires_at").notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  lastActiveAt: timestamp("last_active_at").defaultNow().notNull(),
  data: jsonb("data"),
  isAdmin: boolean("is_admin").default(false),
});
```

### Audit Logs

Tracks important system and user actions:

```typescript
export const auditLogs = pgTable("audit_logs", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").references(() => users.id),
  action: text("action").notNull(),
  entityType: text("entity_type"),
  entityId: text("entity_id"),
  details: jsonb("details"),
  ipAddress: text("ip_address"),
  userAgent: text("user_agent"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  severity: text("severity").default("info"),
  status: text("status").default("success"),
});
```

## Content Management Domain

The content management domain handles tracks, releases, artists, and their metadata:

### Artists

Detailed artist information:

```typescript
export const artists = pgTable("artists", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").references(() => users.id),
  name: text("name").notNull(),
  sortName: text("sort_name"),
  type: text("type").default("person").notNull(), // "person", "group", "orchestra", etc.
  biography: text("biography"),
  formedYear: integer("formed_year"),
  dissolvedYear: integer("dissolved_year"),
  country: text("country"),
  website: text("website"),
  socialLinks: jsonb("social_links"),
  imageUrl: text("image_url"),
  genres: text("genres").array(),
  tags: text("tags").array(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  isVerified: boolean("is_verified").default(false),
  spotifyId: text("spotify_id"),
  appleId: text("apple_id"),
  isni: text("isni"),
  memberArtists: jsonb("member_artists"),
  aliases: jsonb("aliases"),
  primaryLabel: text("primary_label"),
  managementContact: text("management_contact"),
  bookingContact: text("booking_contact"),
  pressContact: text("press_contact"),
});
```

### Track-Release Junction

Connects tracks to releases with ordering information:

```typescript
export const trackReleases = pgTable("track_releases", {
  id: serial("id").primaryKey(),
  trackId: integer("track_id").notNull().references(() => tracks.id),
  releaseId: integer("release_id").notNull().references(() => releases.id),
  trackNumber: integer("track_number").notNull(),
  discNumber: integer("disc_number").default(1).notNull(),
  isBonus: boolean("is_bonus").default(false),
  isInstant: boolean("is_instant").default(false),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
});
```

### Assets

Manages digital files associated with content:

```typescript
export const assets = pgTable("assets", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  entityType: text("entity_type").notNull(), // "track", "release", "artist", etc.
  entityId: integer("entity_id").notNull(),
  type: text("type").notNull(), // "audio", "image", "document", "video"
  subType: text("sub_type"), // "master", "artwork", "contract", "stems", etc.
  fileUrl: text("file_url").notNull(),
  fileName: text("file_name").notNull(),
  fileSize: integer("file_size"),
  fileType: text("file_type"),
  duration: integer("duration"), // for audio/video
  width: integer("width"), // for images
  height: integer("height"), // for images
  isPublic: boolean("is_public").default(false),
  status: text("status").default("active"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  metadata: jsonb("metadata"),
  checksum: text("checksum"),
  thumbnailUrl: text("thumbnail_url"),
  storageProvider: text("storage_provider").default("s3"),
  processingStatus: text("processing_status").default("complete"),
  processingError: text("processing_error"),
  replacedById: integer("replaced_by_id").references(() => assets.id),
  originalFileName: text("original_file_name"),
});
```

### Content Tags

Structured tagging system for enhanced discoverability:

```typescript
export const contentTags = pgTable("content_tags", {
  id: serial("id").primaryKey(),
  entityType: text("entity_type").notNull(), // "track", "release", "artist"
  entityId: integer("entity_id").notNull(),
  category: text("category").notNull(), // "genre", "mood", "instrument", "theme"
  tag: text("tag").notNull(),
  source: text("source").default("user"), // "user", "system", "ai"
  confidence: numeric("confidence"), // For AI-generated tags
  createdAt: timestamp("created_at").defaultNow().notNull(),
  createdBy: integer("created_by").references(() => users.id),
  isVerified: boolean("is_verified").default(false),
  verifiedBy: integer("verified_by").references(() => users.id),
  verifiedAt: timestamp("verified_at"),
});
```

### Version History

Tracks changes to content over time:

```typescript
export const versionHistory = pgTable("version_history", {
  id: serial("id").primaryKey(),
  entityType: text("entity_type").notNull(), // "track", "release", etc.
  entityId: integer("entity_id").notNull(),
  versionNumber: integer("version_number").notNull(),
  changes: jsonb("changes").notNull(),
  changedBy: integer("changed_by").references(() => users.id),
  changedAt: timestamp("changed_at").defaultNow().notNull(),
  comment: text("comment"),
  status: text("status").default("active"),
  isAutomated: boolean("is_automated").default(false),
  previousVersionId: integer("previous_version_id").references(() => versionHistory.id),
});
```

## Distribution Domain

The distribution domain manages the delivery of music to streaming platforms:

### Distribution Platforms

Information about connected streaming services:

```typescript
export const distributionPlatforms = pgTable("distribution_platforms", {
  id: serial("id").primaryKey(),
  name: text("name").notNull().unique(),
  logoUrl: text("logo_url"),
  apiEndpoint: text("api_endpoint"),
  apiDocumentation: text("api_documentation"),
  deliveryMethod: text("delivery_method").default("api"), // "api", "sftp", "manual"
  isActive: boolean("is_active").default(true),
  processingTime: text("processing_time"), // Estimated processing time
  territories: text("territories").array(),
  requirements: jsonb("requirements"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  supportedFormats: text("supported_formats").array(),
  minAudioQuality: text("min_audio_quality"),
  minImageQuality: text("min_image_quality"),
  supportsPreOrders: boolean("supports_pre_orders").default(false),
  supportsTakedowns: boolean("supports_takedowns").default(true),
  supportsMetadataUpdates: boolean("supports_metadata_updates").default(false),
  fees: jsonb("fees"),
  integrationDetails: jsonb("integration_details"),
  rateLimits: jsonb("rate_limits"),
  category: text("category").default("dsp"), // "dsp", "video", "social"
  tier: text("tier").default("standard"), // "premium", "standard", "basic"
});
```

### Platform Credentials

Securely stores connection credentials for platforms:

```typescript
export const platformCredentials = pgTable("platform_credentials", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  platformId: integer("platform_id").notNull().references(() => distributionPlatforms.id),
  credentials: jsonb("credentials").notNull(),
  status: text("status").default("active"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  verificationStatus: text("verification_status").default("pending"),
  verifiedAt: timestamp("verified_at"),
  expiresAt: timestamp("expires_at"),
  isDefault: boolean("is_default").default(false),
  labels: text("labels").array(),
  scope: text("scope").default("all"),
  integrationLevel: text("integration_level").default("basic"),
  connectionType: text("connection_type").default("oauth"),
});
```

### Scheduled Distributions

Manages future-dated content deliveries:

```typescript
export const scheduledDistributions = pgTable("scheduled_distributions", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  releaseId: integer("release_id").notNull().references(() => releases.id),
  scheduledAt: timestamp("scheduled_at").notNull(),
  platformIds: integer("platform_ids").array().notNull(),
  status: text("status").default("pending").notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  executedAt: timestamp("executed_at"),
  territoryRestrictions: text("territory_restrictions").array(),
  exclusivePlatforms: integer("exclusive_platforms").array(),
  distributionStrategy: text("distribution_strategy").default("simultaneous"),
  distributionPriority: text("distribution_priority").default("standard"),
  callbackUrl: text("callback_url"),
  deliveryNotificationEmail: text("delivery_notification_email"),
  distributionJobId: text("distribution_job_id"),
  metadata: jsonb("metadata"),
  retryBehavior: jsonb("retry_behavior"),
  failureNotification: boolean("failure_notification").default(true),
});
```

### Distribution Batches

Groups related distribution activities:

```typescript
export const distributionBatches = pgTable("distribution_batches", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  name: text("name"),
  description: text("description"),
  status: text("status").default("in_progress").notNull(),
  startedAt: timestamp("started_at").defaultNow().notNull(),
  completedAt: timestamp("completed_at"),
  totalItems: integer("total_items").notNull(),
  processedItems: integer("processed_items").default(0).notNull(),
  successItems: integer("success_items").default(0),
  failedItems: integer("failed_items").default(0),
  batchType: text("batch_type").default("release").notNull(), // "release", "takedown", "update"
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  metadata: jsonb("metadata"),
  priority: text("priority").default("normal"),
  callbackUrl: text("callback_url"),
  notificationEmail: text("notification_email"),
  batchSource: text("batch_source").default("user"), // "user", "scheduled", "automated"
});
```

## Rights Management Domain

The rights management domain handles ownership, splits, and rights administration:

### Agreements

Tracks contracts and legal documents:

```typescript
export const agreements = pgTable("agreements", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  title: text("title").notNull(),
  type: text("type").notNull(), // "recording", "publishing", "distribution", etc.
  status: text("status").default("draft").notNull(),
  startDate: date("start_date"),
  endDate: date("end_date"),
  documentUrl: text("document_url"),
  parties: jsonb("parties").notNull(),
  territoryScope: text("territory_scope").array(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  signedAt: timestamp("signed_at"),
  metadata: jsonb("metadata"),
  terms: jsonb("terms"),
  rightsGranted: jsonb("rights_granted"),
  royaltyTerms: jsonb("royalty_terms"),
  exclusivity: boolean("exclusivity").default(false),
  confidentiality: boolean("confidentiality").default(true),
  autoRenew: boolean("auto_renew").default(false),
  renewalTerms: jsonb("renewal_terms"),
  terminationClauses: jsonb("termination_clauses"),
  governingLaw: text("governing_law"),
  disputeResolution: text("dispute_resolution"),
  amendmentsHistory: jsonb("amendments_history"),
  relatedAgreements: integer("related_agreements").array(),
});
```

### Royalty Splits

Manages revenue sharing between rights holders:

```typescript
export const royaltySplits = pgTable("royalty_splits", {
  id: serial("id").primaryKey(),
  entityType: text("entity_type").notNull(), // "track", "release"
  entityId: integer("entity_id").notNull(),
  rightType: royaltyTypeEnum("right_type").notNull(),
  recipientType: text("recipient_type").notNull(), // "user", "artist", "organization"
  recipientId: integer("recipient_id"),
  recipientName: text("recipient_name").notNull(),
  percentage: numeric("percentage").notNull(),
  isApproved: boolean("is_approved").default(false),
  approvedBy: integer("approved_by").references(() => users.id),
  approvedAt: timestamp("approved_at"),
  createdBy: integer("created_by").notNull().references(() => users.id),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  agreementId: integer("agreement_id").references(() => agreements.id),
  effectiveFrom: date("effective_from"),
  effectiveTo: date("effective_to"),
  notes: text("notes"),
  status: text("status").default("active"),
  paymentDetails: jsonb("payment_details"),
  territory: text("territory").array(),
  splitGroupId: integer("split_group_id"),
  version: integer("version").default(1),
});
```

### Split Templates

Reusable split configurations:

```typescript
export const splitTemplates = pgTable("split_templates", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  name: text("name").notNull(),
  description: text("description"),
  rightType: royaltyTypeEnum("right_type").notNull(),
  splits: jsonb("splits").notNull(),
  isDefault: boolean("is_default").default(false),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  applicableTo: text("applicable_to").array(), // "tracks", "releases", etc.
  status: text("status").default("active"),
  templateType: text("template_type").default("standard"), // "standard", "project", "label"
  visibility: text("visibility").default("private"), // "private", "team", "public"
  usageCount: integer("usage_count").default(0),
  tags: text("tags").array(),
});
```

### Rights Conflicts

Tracks and manages ownership disputes:

```typescript
export const rightsConflicts = pgTable("rights_conflicts", {
  id: serial("id").primaryKey(),
  entityType: text("entity_type").notNull(), // "track", "release"
  entityId: integer("entity_id").notNull(),
  rightType: royaltyTypeEnum("right_type").notNull(),
  conflictingClaimIds: integer("conflicting_claim_ids").array().notNull(),
  status: text("status").default("open").notNull(),
  detectedAt: timestamp("detected_at").defaultNow().notNull(),
  resolvedAt: timestamp("resolved_at"),
  resolvedBy: integer("resolved_by").references(() => users.id),
  resolutionNotes: text("resolution_notes"),
  resolutionType: text("resolution_type"), // "accepted_claim", "split_adjusted", "disputed"
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  severity: text("severity").default("medium"),
  impactedRevenue: numeric("impacted_revenue"),
  disputeDocuments: jsonb("dispute_documents"),
  resolutionDocuments: jsonb("resolution_documents"),
  notifiedParties: jsonb("notified_parties"),
  assignedTo: integer("assigned_to").references(() => users.id),
  escalationLevel: integer("escalation_level").default(0),
  systemActions: jsonb("system_actions"),
});
```

## Financial Domain

The financial domain handles payments, royalties, and financial transactions:

### Payment Methods

Stores user payment information:

```typescript
export const paymentMethods = pgTable("payment_methods", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  type: text("type").notNull(), // "bank_account", "paypal", "stripe", etc.
  name: text("name").notNull(),
  details: jsonb("details").notNull(),
  isDefault: boolean("is_default").default(false),
  status: text("status").default("active").notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  verificationStatus: text("verification_status").default("pending"),
  verifiedAt: timestamp("verified_at"),
  lastFourDigits: text("last_four_digits"),
  expiryDate: text("expiry_date"),
  country: text("country"),
  currency: text("currency"),
  metadata: jsonb("metadata"),
  billingAddress: jsonb("billing_address"),
  verification_attempts: integer("verification_attempts").default(0),
  last_verification_attempt: timestamp("last_verification_attempt"),
  verification_notes: text("verification_notes"),
});
```

### Withdrawals

Tracks payment requests from users:

```typescript
export const withdrawals = pgTable("withdrawals", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  amount: numeric("amount").notNull(),
  currency: text("currency").default("USD").notNull(),
  status: text("status").default("pending").notNull(),
  paymentMethodId: integer("payment_method_id").notNull().references(() => paymentMethods.id),
  processedAt: timestamp("processed_at"),
  requestedAt: timestamp("requested_at").defaultNow().notNull(),
  reference: text("reference"),
  notes: text("notes"),
  fee: numeric("fee").default("0"),
  taxWithheld: numeric("tax_withheld").default("0"),
  netAmount: numeric("net_amount"),
  exchangeRate: numeric("exchange_rate").default("1"),
  paymentBatchId: integer("payment_batch_id"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  estimatedArrivalDate: date("estimated_arrival_date"),
  actualArrivalDate: date("actual_arrival_date"),
  paymentDetails: jsonb("payment_details"),
  failureReason: text("failure_reason"),
  retryCount: integer("retry_count").default(0),
  lastRetryAt: timestamp("last_retry_at"),
  adminNotes: text("admin_notes"),
  internalReference: text("internal_reference"),
});
```

### Statements

Provides formal records of earnings:

```typescript
export const statements = pgTable("statements", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  period: text("period").notNull(), // e.g., "2023-Q1"
  startDate: date("start_date").notNull(),
  endDate: date("end_date").notNull(),
  totalAmount: numeric("total_amount").notNull(),
  currency: text("currency").default("USD").notNull(),
  status: text("status").default("generated").notNull(),
  generatedAt: timestamp("generated_at").defaultNow().notNull(),
  viewedAt: timestamp("viewed_at"),
  documentUrl: text("document_url"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  statementType: text("statement_type").default("royalty"),
  summary: jsonb("summary"),
  platformBreakdown: jsonb("platform_breakdown"),
  releaseBreakdown: jsonb("release_breakdown"),
  trackBreakdown: jsonb("track_breakdown"),
  territoryBreakdown: jsonb("territory_breakdown"),
  taxSummary: jsonb("tax_summary"),
  deductionsSummary: jsonb("deductions_summary"),
  paymentStatus: text("payment_status").default("unpaid"),
  paidAmount: numeric("paid_amount"),
  paidAt: timestamp("paid_at"),
  paymentReference: text("payment_reference"),
  statementFormat: text("statement_format").default("standard"),
});
```

### Payment Batches

Manages grouped payment processing:

```typescript
export const paymentBatches = pgTable("payment_batches", {
  id: serial("id").primaryKey(),
  name: text("name"),
  description: text("description"),
  status: text("status").default("pending").notNull(),
  processingStartedAt: timestamp("processing_started_at"),
  processingCompletedAt: timestamp("processing_completed_at"),
  totalAmount: numeric("total_amount").notNull(),
  currency: text("currency").default("USD").notNull(),
  totalPayments: integer("total_payments").notNull(),
  successfulPayments: integer("successful_payments").default(0),
  failedPayments: integer("failed_payments").default(0),
  createdBy: integer("created_by").references(() => users.id),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  paymentType: text("payment_type").default("royalty"), // "royalty", "advance", "bonus"
  scheduledFor: timestamp("scheduled_for"),
  executionStrategy: text("execution_strategy").default("immediate"),
  paymentMethod: text("payment_method").default("bank_transfer"),
  processedBy: integer("processed_by").references(() => users.id),
  notes: text("notes"),
  batchSettings: jsonb("batch_settings"),
  batchErrors: jsonb("batch_errors"),
  batchWarnings: jsonb("batch_warnings"),
  notificationSent: boolean("notification_sent").default(false),
  externalReference: text("external_reference"),
});
```

### Advances

Tracks prepayments against future earnings:

```typescript
export const advances = pgTable("advances", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  amount: numeric("amount").notNull(),
  currency: text("currency").default("USD").notNull(),
  issuedAt: timestamp("issued_at").defaultNow().notNull(),
  status: text("status").default("active").notNull(),
  recoupmentRate: numeric("recoupment_rate").default("1").notNull(), // 1 = 100% recoupment
  recoupedAmount: numeric("recouped_amount").default("0"),
  remainingAmount: numeric("remaining_amount"),
  agreementId: integer("agreement_id").references(() => agreements.id),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  issuedBy: integer("issued_by").references(() => users.id),
  recoupmentType: text("recoupment_type").default("all_income"), // "all_income", "specific_releases", etc.
  recoupmentSources: jsonb("recoupment_sources"),
  recoupmentPeriod: jsonb("recoupment_period"), // Duration or ending date
  interestRate: numeric("interest_rate").default("0"),
  paymentPlan: jsonb("payment_plan"),
  recoupmentHistory: jsonb("recoupment_history"),
  notes: text("notes"),
  advanceType: text("advance_type").default("standard"),
  approvedBy: integer("approved_by").references(() => users.id),
  paymentStatus: text("payment_status").default("pending"),
  paymentDate: date("payment_date"),
  paymentReference: text("payment_reference"),
});
```

## Analytics Domain

The analytics domain handles performance metrics, reporting, and business intelligence:

### Platform Analytics

Stores performance data from streaming platforms:

```typescript
export const platformAnalytics = pgTable("platform_analytics", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  entityType: text("entity_type").notNull(), // "track", "release", "artist"
  entityId: integer("entity_id").notNull(),
  platformId: integer("platform_id").references(() => distributionPlatforms.id),
  date: date("date").notNull(),
  streams: integer("streams").default(0),
  downloads: integer("downloads").default(0),
  revenue: numeric("revenue").default("0"),
  currency: text("currency").default("USD"),
  listeners: integer("listeners"),
  saves: integer("saves"),
  completionRate: numeric("completion_rate"),
  skipRate: numeric("skip_rate"),
  playlists: integer("playlists"),
  shares: integer("shares"),
  comments: integer("comments"),
  likes: integer("likes"),
  followsGained: integer("follows_gained"),
  territoryCode: text("territory_code"),
  deviceType: text("device_type"),
  listeningMethod: text("listening_method"), // "user_collection", "playlist", "radio", etc.
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  sourceData: jsonb("source_data"),
  isEstimated: boolean("is_estimated").default(false),
  batchId: integer("batch_id"),
  demographicData: jsonb("demographic_data"),
  playbackSource: text("playback_source"), // "user_library", "search", "playlist", etc.
  avgPlaybackDuration: integer("avg_playback_duration"),
  uniqueListeners: integer("unique_listeners"),
  newListeners: integer("new_listeners"),
  returningListeners: integer("returning_listeners"),
});
```

### Audience Demographics

Stores listener demographic information:

```typescript
export const audienceDemographics = pgTable("audience_demographics", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  entityType: text("entity_type").notNull(), // "artist", "track", "release"
  entityId: integer("entity_id").notNull(),
  period: text("period").notNull(), // e.g., "2023-03"
  ageRanges: jsonb("age_ranges"), // e.g., {"18-24": 0.35, "25-34": 0.4, ...}
  genders: jsonb("genders"), // e.g., {"male": 0.6, "female": 0.35, "other": 0.05}
  countries: jsonb("countries"), // e.g., {"US": 0.4, "UK": 0.2, ...}
  cities: jsonb("cities"), // Top cities
  platforms: jsonb("platforms"), // e.g., {"spotify": 0.7, "apple": 0.2, ...}
  devices: jsonb("devices"), // e.g., {"mobile": 0.6, "desktop": 0.3, "other": 0.1}
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  sourceId: integer("source_id"), // Reference to data source
  confidence: numeric("confidence").default("1"),
  dataQuality: text("data_quality").default("high"),
  listeningPreferences: jsonb("listening_preferences"),
  genreAffinities: jsonb("genre_affinities"),
  engagementMetrics: jsonb("engagement_metrics"),
  growthTrends: jsonb("growth_trends"),
  audienceSegments: jsonb("audience_segments"),
  relatedArtists: jsonb("related_artists"),
});
```

### Saved Reports

Stores user-generated reports:

```typescript
export const savedReports = pgTable("saved_reports", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  name: text("name").notNull(),
  description: text("description"),
  type: text("type").notNull(), // "performance", "financial", "audience", "custom"
  parameters: jsonb("parameters").notNull(),
  schedule: jsonb("schedule"), // For recurring reports
  lastRunAt: timestamp("last_run_at"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
  format: text("format").default("web"), // "web", "pdf", "excel", "csv"
  isPublic: boolean("is_public").default(false),
  isTemplate: boolean("is_template").default(false),
  category: text("category"),
  tags: text("tags").array(),
  thumbnailUrl: text("thumbnail_url"),
  lastResultUrl: text("last_result_url"),
  queryData: jsonb("query_data"),
  visualizations: jsonb("visualizations"),
  sharing: jsonb("sharing"),
  version: integer("version").default(1),
  parentReportId: integer("parent_report_id").references(() => savedReports.id),
  executionStats: jsonb("execution_stats"),
});
```

### Report Exports

Tracks exported report documents:

```typescript
export const reportExports = pgTable("report_exports", {
  id: serial("id").primaryKey(),
  reportId: integer("report_id").references(() => savedReports.id),
  userId: integer("user_id").notNull().references(() => users.id),
  format: text("format").notNull(), // "pdf", "excel", "csv", "json"
  url: text("url").notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  expiresAt: timestamp("expires_at"),
  size: integer("size"),
  downloadCount: integer("download_count").default(0),
  parameters: jsonb("parameters"),
  status: text("status").default("completed"),
  processingTime: integer("processing_time"),
  errorDetails: text("error_details"),
  notificationSent: boolean("notification_sent").default(false),
  recipientEmail: text("recipient_email"),
  jobId: text("job_id"),
  name: text("name"),
  pages: integer("pages"),
  thumbnailUrl: text("thumbnail_url"),
  isPasswordProtected: boolean("is_password_protected").default(false),
  watermarked: boolean("watermarked").default(false),
});
```

## Data Relationships

Key relationships between entities in the data model:

### One-to-Many Relationships

1. **User to Tracks**
   - A user can own many tracks
   - Each track is owned by one user

2. **User to Releases**
   - A user can own many releases
   - Each release is owned by one user

3. **User to PaymentMethods**
   - A user can have multiple payment methods
   - Each payment method belongs to one user

4. **Team to TeamMembers**
   - A team can have many members
   - Each team membership is associated with one team

### Many-to-Many Relationships

1. **Tracks to Releases**
   - A track can be part of multiple releases
   - A release can contain multiple tracks
   - Implemented via the `trackReleases` junction table

2. **Releases to DistributionPlatforms**
   - A release can be distributed to multiple platforms
   - A platform can host many releases
   - Implemented via the `distributionRecords` table

3. **Users to Teams**
   - A user can be a member of multiple teams
   - A team can have multiple user members
   - Implemented via the `teamMembers` table

### Complex Relationships

1. **Polymorphic Associations**
   - Tables like `assets`, `contentTags`, and `rightsManagement` relate to different entity types
   - They use the pattern of `entityType` + `entityId` fields to create flexible relationships

2. **Hierarchical Relationships**
   - Users can have parent-child relationships (label to sub-labels)
   - Implemented via self-referential `parentId` in the users table

3. **Temporal Relationships**
   - Rights claims have effective dates
   - Contracts have start and end dates
   - Ensures proper historical tracking and time-bound relationships

## Schema Evolution

TuneMantra's database schema evolves through controlled migration processes:

### Migration Strategy

1. **Schema Versioning**
   - Every schema change is versioned
   - Migrations are applied sequentially
   - Version history is maintained in the database

2. **Backward Compatibility**
   - Schema changes preserve existing data
   - Breaking changes are avoided when possible
   - Deprecation periods for obsolete fields

3. **Migration Tools**
   - Drizzle Kit for schema migrations
   - Version control for migration scripts
   - Automated testing of migrations

### Schema Changes

Types of schema changes and their handling:

1. **Additive Changes**
   - Adding new tables
   - Adding new columns (with defaults for existing rows)
   - Adding new relationships

2. **Modificative Changes**
   - Renaming columns (with temporary views for backward compatibility)
   - Changing column types (with data conversion)
   - Modifying constraints (with validation)

3. **Removing Fields**
   - Marking as deprecated first
   - Setting up transitional periods
   - Eventually removing after ensuring no dependencies

### Data Migration

Approaches for migrating data during schema changes:

1. **In-Place Migration**
   - Transforming data within the same table
   - Updating values to match new schemas
   - Running data cleanup operations

2. **Copy Migration**
   - Creating new structures
   - Copying and transforming data to new tables
   - Switching over once migration is complete

3. **Background Migration**
   - Running migrations in the background
   - Implementing dual-write patterns during transition
   - Gradually moving to new structures without downtime

---

**Document Information:**
- Version: 2.0
- Last Updated: March 25, 2025
- Contact: database@tunemantra.com