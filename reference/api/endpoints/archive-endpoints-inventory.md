# TuneMantra Historical API Endpoints Inventory

This document catalogs the API endpoints that were implemented in various branches of TuneMantra. This inventory has been preserved from the original archive and serves as a historical reference.

## Branch-Based Endpoint Inventory

The endpoints are organized by branch and source file, providing a comprehensive view of the API surface area across different development paths.

### Branch: 12march547

#### Source: `.archive/branch_backups/12march547/server/routes/admin-asset-bundles.ts`

| Method | Path | Description |
|--------|------|-------------|

#### Source: `.archive/branch_backups/12march547/server/routes/admin-white-label.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | /config | Retrieves white label configuration |
| GET | /theme | Retrieves theme configuration |
| POST | /backup | Creates a backup of configuration |
| POST | /config | Updates white label configuration |
| POST | /domain | Updates domain configuration |
| POST | /restore/:version | Restores configuration from backup |

#### Source: `.archive/branch_backups/12march547/server/routes/admin-export.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | /releases | Lists releases for export |
| GET | /releases/:id/complete | Checks if export is complete |
| POST | /export/bulk | Initiates bulk export |

#### Source: `.archive/branch_backups/12march547/server/routes/admin-import.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | /templates/:template | Retrieves import template |
| POST | /metadata | Imports metadata |

#### Source: `.archive/branch_backups/12march547/server/routes/api-access.ts`

| Method | Path | Description |
|--------|------|-------------|
| DELETE | /api-keys/:id | Deletes an API key |
| GET | /api-keys | Lists API keys |
| POST | /api-keys | Creates a new API key |

#### Source: `.archive/branch_backups/12march547/server/routes/mobile-api.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | /analytics/overview | Retrieves analytics overview |
| GET | /analytics/platform-stats | Retrieves platform statistics |
| GET | /analytics/revenue | Retrieves revenue data |
| GET | /analytics/trending | Retrieves trending data |
| GET | /catalog/releases | Lists releases in catalog |
| GET | /label-services | Lists label services |
| GET | /team | Lists team members |
| POST | /auth/login | Authenticates user |
| POST | /distribution/schedule | Schedules distribution |

#### Source: `.archive/branch_backups/12march547/server/routes/admin-subscription.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | /subscription-tiers | Lists subscription tiers |
| POST | /subscription-tiers | Creates/updates subscription tiers |
| POST | /subscription-tiers/reset | Resets subscription tiers to defaults |

#### Source: `.archive/branch_backups/12march547/server/routes/admin-user-limits.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | /:userId | Gets user limits |
| PUT | / | Updates user limits |

#### Source: `.archive/branch_backups/12march547/server/routes/admin/platforms.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | / | Lists platforms |
| GET | /:id | Gets platform details |
| POST | /:code/credentials | Updates platform credentials |
| PUT | /:id | Updates platform |

#### Source: `.archive/branch_backups/12march547/server/routes/admin/distribution.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | /analytics | Retrieves distribution analytics |
| GET | /failed | Lists failed distributions |
| GET | /queue | Views distribution queue |
| POST | /check-statuses | Checks distribution statuses |
| POST | /export/:releaseId/:platformId | Exports release to platform |
| POST | /process-queue | Processes distribution queue |
| POST | /process-scheduled | Processes scheduled distributions |
| POST | /retry-failed | Retries failed distributions |
| POST | /update-status/:distributionId | Updates distribution status |

#### Source: `.archive/branch_backups/12march547/server/routes/admin/security-settings.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | / | Gets security settings |
| POST | / | Updates security settings |
| POST | /reset | Resets security settings to defaults |

#### Source: `.archive/branch_backups/12march547/server/routes/analytics.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | /audience | Retrieves audience data |
| GET | /geography | Retrieves geographic data |
| GET | /releases/:releaseId | Retrieves release analytics |
| GET | /revenue/overview | Retrieves revenue overview |
| GET | /trends/:artistId | Retrieves artist trends |
| POST | /report | Generates analytics report |

#### Source: `.archive/branch_backups/12march547/server/routes/payment.ts`

| Method | Path | Description |
|--------|------|-------------|
| DELETE | /methods/:id | Deletes payment method |
| GET | /methods | Lists payment methods |
| GET | /revenue-splits | Lists revenue splits |
| GET | /subscription-status | Gets subscription status |
| GET | /withdrawals | Lists withdrawals |
| POST | /cancel-subscription | Cancels subscription |
| POST | /create-subscription | Creates subscription |
| POST | /methods | Adds payment method |
| POST | /verify-payment | Verifies payment |
| POST | /webhook | Payment webhook endpoint |
| POST | /withdrawals | Requests withdrawal |

#### Source: `.archive/branch_backups/12march547/server/routes/admin-approvals.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | /pending | Lists pending approvals |
| GET | /:userId | Gets user approval status |
| POST | /:userId/:action | Takes approval action |

#### Source: `.archive/branch_backups/12march547/server/routes/admin-distribution.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | /manual/stats | Gets manual distribution stats |
| GET | /pending | Lists pending distributions |
| GET | /recent-activity | Gets recent distribution activity |
| GET | /releases | Lists releases for distribution |
| GET | /stats | Gets distribution stats |
| POST | /approve | Approves distribution |
| POST | /status-update | Updates distribution status |

#### Source: `.archive/branch_backups/12march547/server/routes/admin-manual-distribution.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | /exports | Lists exports |
| GET | /exports/:id | Gets export details |
| GET | /exports/:id/download | Downloads export |
| GET | /imports | Lists imports |
| POST | /exports/bulk | Bulk export operation |
| POST | /exports/generate | Generates export |
| POST | /imports | Creates import |
| PUT | /exports/:id/status | Updates export status |

#### Source: `.archive/branch_backups/12march547/server/routes/admin-site-customization.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | / | Gets all customization settings |
| GET | /backups | Lists configuration backups |
| GET | /config | Gets configuration |
| POST | / | Updates all customization settings |
| POST | /backup | Creates configuration backup |
| POST | /restore/:filename | Restores from backup |
| POST | /upload | Uploads customization assets |

#### Source: `.archive/branch_backups/12march547/server/routes/admin.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | /check-session | Verifies admin session |
| GET | /isrc-tracks | Lists tracks with ISRC codes |
| GET | /stats | Gets admin dashboard stats |
| GET | /users | Lists users |
| GET | /users/:id | Gets user details |
| POST | /import-revenue | Imports revenue data |
| POST | /login | Admin login |
| POST | /logout | Admin logout |
| POST | /match-tracks | Matches tracks to ISRCs |
| POST | /update-isrc | Updates ISRC code |
| POST | /users/batch-approve | Batch approves users |
| POST | /users/:id/status | Updates user status |

## Additional Branches

Multiple other branches contain similar endpoints with variations. The complete inventory is available in the [original archive file](.archive/archived_misc_files/api_endpoints.md).

## Integration with Current API Reference

This historical inventory provides valuable context when used alongside the [current API reference](../api-reference.md). 

The current API reference documents the standardized, consolidated API that evolved from these historical endpoints, while this inventory showcases the development path and design evolution.