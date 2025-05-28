# TuneMantra Implementation Plan

This document outlines the step-by-step process for implementing the recommended approach of combining the best features from multiple branches.

## Implementation Strategy

### Step 1: Start with Current Branch as Foundation

- Clone or copy the current branch as the base
- Preserve the optimized naming conventions (e.g., `splitPercentage`)
- Keep the enhanced error handling and performance optimizations
- Maintain event tracking analytics and default values

### Step 2: Schema Integration

#### From 190320250630

Import these tables from `shared/schema.ts`:

1. **Royalty Tables**:
   - `royaltyCalculations`
   - Associated schemas and relationships
   
2. **Rights Management Tables**:
   - Territorial rights support
   - Time-based expiration logic

```typescript
// Example integration of royalty tables from 190320250630
export const royaltyCalculations = pgTable("royalty_calculations", {
  id: serial("id").primaryKey(),
  // Foreign keys for related data
  distributionRecordId: integer("distribution_record_id").notNull(),
  releaseId: integer("release_id").notNull(),
  trackId: integer("track_id").notNull(),
  userId: integer("user_id").notNull(),
  
  // Calculation financial data
  amount: numeric("amount").notNull(), // calculated royalty amount
  streamCount: integer("stream_count").notNull().default(0),
  ratePerStream: numeric("rate_per_stream"),
  
  // Other fields from 190320250630...
});

// Ensure validation schema is also added
export const insertRoyaltyCalculationSchema = createInsertSchema(royaltyCalculations)
  .omit({
    id: true,
    createdAt: true,
    updatedAt: true,
    // Other generated fields...
  })
  .extend({
    amount: z.number().min(0, "Amount must be a positive number"),
    // Other validations...
  });

export type RoyaltyCalculation = typeof royaltyCalculations.$inferSelect;
export type InsertRoyaltyCalculation = z.infer<typeof insertRoyaltyCalculationSchema>;
```

#### Update Relations

Ensure all relations between tables are properly updated:

```typescript
// Example of updating relations for royalty tables
export const royaltyCalculationsRelations = relations(royaltyCalculations, ({ one }) => ({
  release: one(releases, {
    fields: [royaltyCalculations.releaseId],
    references: [releases.id],
  }),
  track: one(tracks, {
    fields: [royaltyCalculations.trackId],
    references: [tracks.id],
  }),
  user: one(users, {
    fields: [royaltyCalculations.userId],
    references: [users.id],
  }),
  // Other relations...
}));
```

### Step 3: Authentication System Integration

1. **Keep Current Branch Password Validation**:

```typescript
// Current branch enhanced password validation
function validatePassword(password: string): boolean {
  if (password.length < 10) return false;
  if (!/[A-Z]/.test(password)) return false;
  if (!/[a-z]/.test(password)) return false;
  if (!/[0-9]/.test(password)) return false;
  if (!/[^A-Za-z0-9]/.test(password)) return false;
  return true;
}
```

2. **Incorporate 190320250630 Role-Based Access Control**:

```typescript
// From 190320250630
function hasPermission(userRole: string, requiredPermission: string): boolean {
  const permissions = {
    admin: ['all'],
    label: [
      'manage_label', 
      'manage_artists', 
      'upload_content', 
      'view_analytics', 
      'manage_releases',
      'manage_distributions',
      'view_royalties'
    ],
    artist_manager: [
      'manage_artists', 
      'upload_content', 
      'view_analytics',
      'manage_releases',
      'view_artist_royalties'
    ],
    artist: [
      'upload_content', 
      'view_own_analytics',
      'manage_own_releases'
    ]
  };
  
  const userPermissions = permissions[userRole] || [];
  return userPermissions.includes('all') || userPermissions.includes(requiredPermission);
}

// Middleware to check permission
function requirePermission(permission: string) {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ error: 'Authentication required' });
    }
    
    if (!hasPermission(req.user.role, permission)) {
      return res.status(403).json({ error: 'Permission denied' });
    }
    
    next();
  };
}
```

3. **Add Current Branch Security Monitoring**:

```typescript
// Current branch security monitoring
function detectSuspiciousActivity(req): boolean {
  if (!req.session.userId) return false;
  
  // Check for IP changes
  if (req.session.ipAddress && req.session.ipAddress !== req.ip) {
    logSecurityEvent('ip_changed', {
      userId: req.session.userId,
      oldIp: req.session.ipAddress,
      newIp: req.ip
    });
    return true;
  }
  
  // Other security checks...
  
  return false;
}
```

### Step 4: Blockchain Integration

1. **Import Multi-Network Configuration from 17032025**:

```typescript
// From 17032025
const blockchainNetworks = {
  ethereum: {
    name: 'Ethereum Mainnet',
    chainId: 1,
    currency: 'ETH',
    provider: new ethers.providers.JsonRpcProvider(process.env.ETHEREUM_RPC_URL),
    contractAddress: process.env.ETHEREUM_CONTRACT_ADDRESS,
    contractABI: JSON.parse(fs.readFileSync('./contracts/RightsManager.json', 'utf8')).abi,
  },
  polygon: {
    name: 'Polygon Mainnet',
    chainId: 137,
    currency: 'MATIC',
    provider: new ethers.providers.JsonRpcProvider(process.env.POLYGON_RPC_URL),
    contractAddress: process.env.POLYGON_CONTRACT_ADDRESS,
    contractABI: JSON.parse(fs.readFileSync('./contracts/RightsManager.json', 'utf8')).abi,
  },
  // Add more networks as needed
};
```

2. **Add Gas Optimization from Current Branch**:

```typescript
// From Current branch
async function optimizeGasFee(networkId = 'ethereum') {
  try {
    const network = blockchainNetworks[networkId];
    const provider = network.provider;
    
    // Get current gas prices and network conditions
    const feeData = await provider.getFeeData();
    const block = await provider.getBlock('latest');
    const networkCongestion = block.gasUsed.mul(100).div(block.gasLimit).toNumber();
    
    // Adjust based on network congestion
    let maxFeeMultiplier;
    if (networkCongestion > 80) {
      // High congestion, pay premium for faster inclusion
      maxFeeMultiplier = 150; // 50% premium
    } else if (networkCongestion > 50) {
      // Medium congestion
      maxFeeMultiplier = 120; // 20% premium
    } else {
      // Low congestion
      maxFeeMultiplier = 110; // 10% premium
    }
    
    // Calculate optimal fees
    const maxFeePerGas = feeData.maxFeePerGas.mul(maxFeeMultiplier).div(100);
    const maxPriorityFeePerGas = feeData.maxPriorityFeePerGas.mul(maxFeeMultiplier).div(100);
    
    return {
      maxFeePerGas,
      maxPriorityFeePerGas,
      estimatedBaseFee: feeData.lastBaseFeePerGas,
      networkCongestion
    };
  } catch (error) {
    console.error(`Failed to optimize gas fee for ${networkId}:`, error);
    
    // Return reasonable defaults in case of error
    return {
      maxFeePerGas: ethers.utils.parseUnits('50', 'gwei'),
      maxPriorityFeePerGas: ethers.utils.parseUnits('2', 'gwei'),
      networkCongestion: 50,
      isEstimate: true
    };
  }
}
```

3. **Combine with Rights Registration from 190320250630**:

```typescript
// Combine 190320250630 rights registration with Current branch optimization
async function registerRightsWithBlockchain({
  assetId,
  assetType,
  rightsType,
  ownerId,
  percentage,
  territory,
  startDate,
  endDate,
  networkId = 'ethereum'
}) {
  try {
    // Validate inputs from Current branch
    validateRightsInput({assetId, assetType, rightsType, ownerId, percentage});
    
    // Get user's blockchain address
    const user = await db.users.findFirst({
      where: { id: ownerId },
      select: { blockchainAddress: true }
    });
    
    if (!user?.blockchainAddress) {
      throw new Error(`User ${ownerId} does not have a blockchain address`);
    }
    
    // Get gas optimization from Current branch
    const gasSettings = await optimizeGasFee(networkId);
    
    // Get blockchain connection from 17032025
    const { contract, network } = await initBlockchain(networkId);
    
    // Register rights (from 190320250630 with Current optimization)
    const tx = await contract.registerRights(
      assetId.toString(),
      assetType,
      rightsType,
      user.blockchainAddress,
      percentage.toString(),
      territory || 'GLOBAL',
      Math.floor(startDate.getTime() / 1000),
      endDate ? Math.floor(endDate.getTime() / 1000) : 0,
      { 
        maxFeePerGas: gasSettings.maxFeePerGas,
        maxPriorityFeePerGas: gasSettings.maxPriorityFeePerGas
      }
    );
    
    // Wait for confirmation from Current branch
    const receipt = await tx.wait(network.confirmations || 1);
    
    // Enhanced result with additional metadata from Current
    return {
      transactionHash: tx.hash,
      blockNumber: receipt.blockNumber,
      status: receipt.status === 1 ? 'success' : 'failed',
      gasUsed: receipt.gasUsed.toString(),
      effectiveGasPrice: receipt.effectiveGasPrice.toString(),
    };
  } catch (error) {
    // Enhanced error handling from Current
    handleBlockchainError(error, 'rights_registration');
    throw new Error(`Rights registration failed: ${error.message}`);
  }
}
```

### Step 5: AI Integration

1. **Combine 190320250630 Features with Current Fallbacks**:

```typescript
// Combine 190320250630 AI features with Current fallbacks
export async function generateContentTags(
  title: string,
  artistName: string,
  type: "audio" | "video"
): Promise<{ tags: ContentTags; analysis: AIAnalysis }> {
  // Current branch fallback mechanism
  if (!process.env.OPENAI_API_KEY) {
    console.log("OpenAI API key not configured, returning default analysis data");
    return getDefaultAnalysis(title, artistName, type);
  }

  try {
    // Check AI service status from cache (Current branch)
    const serviceStatus = await getAIServiceStatus();
    if (!serviceStatus.available) {
      console.log("AI service unavailable, using cached or generated results");
      return getCachedOrFallbackAnalysis(title, artistName, type);
    }
    
    // Initialize OpenAI client
    const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
    
    // 190320250630 comprehensive prompt structure with Current's model upgrade
    const response = await openai.chat.completions.create({
      model: "gpt-4o",  // Current branch model
      messages: [
        // System prompt from 190320250630
        {
          role: "system",
          content: `You are an expert music and media content analyzer with deep knowledge of genres, 
           styles, moods, cultural contexts, and commercial potential. Analyze the given ${type} 
           content information and provide detailed tags and analysis. Your response should be 
           formatted as valid JSON with these fields:
           - genres: array of genre tags
           - moods: array of mood tags
           - themes: array of thematic tags
           - explicit: boolean indicating if content likely contains explicit material
           - languages: array of likely languages used
           - similarArtists: array of similar artists
           - commercialPotential: object with numeric score (0-100) and analysis text
           - qualityAssessment: object with numeric score (0-100) and analysis text
           - contentWarnings: array of potential content warnings
           - suggestedPlaylists: array of playlist concepts this would fit in
           - summary: text summarizing the content
           - suggestedImprovements: array of potential improvements`,
        },
        // User prompt
        {
          role: "user",
          content: `Please analyze this ${type} content:\nTitle: ${title}\nArtist: ${artistName}`,
        },
      ],
      response_format: { type: "json_object" }, // 190320250630 structure
    });

    // Current branch enhanced parsing
    const content = response.choices[0].message.content || "{}";
    const result = JSON.parse(content);
    
    // Store result in cache for future fallback (Current branch)
    await cacheAnalysisResult(title, artistName, type, result);
    
    // Update service status in cache (Current branch)
    await updateAIServiceStatus(true);
    
    // Return validated and structured result from 190320250630
    return {
      tags: {
        genres: validateAndNormalizeTags(result.genres || []),
        moods: validateAndNormalizeTags(result.moods || []),
        themes: validateAndNormalizeTags(result.themes || []),
        explicit: Boolean(result.explicit),
        languages: validateAndNormalizeTags(result.languages || []),
      },
      analysis: {
        summary: result.summary || "",
        commercialPotential: {
          score: validateQualityScore(result.commercialPotential?.score),
          analysis: result.commercialPotential?.analysis || "",
        },
        qualityAssessment: {
          score: validateQualityScore(result.qualityAssessment?.score),
          analysis: result.qualityAssessment?.analysis || "",
        },
        contentWarnings: validateAndNormalizeTags(result.contentWarnings || []),
        suggestedPlaylists: result.suggestedPlaylists || [],
        similarArtists: result.similarArtists || [],
        suggestedImprovements: result.suggestedImprovements || [],
        confidence: 0.95, // Current branch addition
      },
    };
  } catch (error) {
    // Current branch enhanced error handling
    if (error.status === 429 || error.status === 500 || error.status === 503) {
      // Mark service as unavailable in cache
      await updateAIServiceStatus(false, error.message);
      console.log("AI service temporarily unavailable:", error.message);
    } else {
      console.error("AI Analysis failed:", error);
    }
    
    // Current branch fallback approach
    return getCachedOrFallbackAnalysis(title, artistName, type);
  }
}

// Current branch validation helpers
function validateAndNormalizeTags(tags) {
  return tags.map(tag => tag.toLowerCase().trim())
    .filter(tag => tag.length > 0)
    .slice(0, 10); // Limit number of tags
}

function validateQualityScore(score) {
  const numScore = Number(score);
  if (isNaN(numScore)) return 0;
  return Math.max(0, Math.min(100, numScore));
}
```

### Step 6: Audio Processing Integration

1. **Combine 190320250630 Pipeline with Current Batch Processing**:

```typescript
// Main entry point for batch processing (Current branch)
async function processBatch(files, options = {}) {
  // Validate input
  if (!Array.isArray(files) || files.length === 0) {
    throw new Error('No files provided for batch processing');
  }
  
  // Create batch record
  const batchId = crypto.randomUUID();
  const batch = {
    id: batchId,
    totalFiles: files.length,
    processedFiles: 0,
    successfulFiles: 0,
    failedFiles: 0,
    status: 'processing',
    startTime: Date.now(),
    results: [],
    errors: []
  };
  
  // Store batch info in database
  await db.processingBatches.create({
    data: {
      id: batchId,
      type: 'audio',
      totalFiles: files.length,
      status: 'processing',
      options: JSON.stringify(options),
      startTime: new Date()
    }
  });
  
  // Determine concurrency from Current branch
  const concurrency = options.concurrency || Math.min(
    Math.max(1, Math.floor(os.cpus().length / 2)),
    10, // Maximum concurrency
    files.length
  );
  
  // Create queue with concurrency limit
  const queue = new PQueue({ concurrency });
  
  // Process all files in parallel with queue
  const promises = files.map((file, index) => {
    return queue.add(async () => {
      try {
        // Update batch with current file
        await updateBatchProgress(batchId, index, file);
        
        // Process individual file using 190320250630 pipeline
        const result = await processAudio(file.path || file, options);
        
        // Update batch counters
        batch.processedFiles++;
        batch.successfulFiles++;
        batch.results.push(result);
        
        // Update progress
        await updateBatchProgress(batchId, batch);
        
        return result;
      } catch (error) {
        // Current branch error handling
        console.error(`Error processing file ${file.path || file}:`, error);
        
        // Update batch counters
        batch.processedFiles++;
        batch.failedFiles++;
        batch.errors.push({
          file: file.path || file,
          error: error.message
        });
        
        // Update progress
        await updateBatchProgress(batchId, batch);
        
        // Handle errors
        if (options.stopOnError) {
          throw error;
        }
        
        return {
          file: file.path || file,
          success: false,
          error: error.message
        };
      }
    });
  });
  
  // Wait for all files to be processed
  try {
    await Promise.all(promises);
    
    // Update final status
    batch.status = batch.failedFiles > 0 ? 'completed_with_errors' : 'completed';
    batch.endTime = Date.now();
    batch.processingTime = batch.endTime - batch.startTime;
    
    // Update in database
    await finalizeBatch(batchId, batch);
    
    return batch;
  } catch (error) {
    // Handle batch failure
    console.error(`Batch ${batchId} failed:`, error);
    
    // Update with failure
    await markBatchFailed(batchId, batch, error);
    
    throw error;
  }
}

// Audio processing pipeline from 190320250630
async function processAudio(filePath, options = {}) {
  // 190320250630 comprehensive audio processing...

  // Extract metadata
  const metadata = await extractAudioMetadata(filePath);
  
  // Generate fingerprints
  const fingerprints = await generateMultipleFingerprints(filePath);
  
  // Check for duplicates
  const duplicateCheck = await checkForDuplicates(fingerprints);
  
  // Generate waveform
  const waveform = await generateWaveformData(filePath);
  
  // Quality analysis from 190320250630
  const qualityAnalysis = await analyzeAudioQuality(filePath);
  
  // Format conversion
  const formats = await generateOptimizedFormats(filePath, options.formats);
  
  // Return complete result
  return {
    metadata,
    fingerprints,
    duplicateCheck,
    waveform,
    qualityAnalysis,
    formats,
    processingTime: Date.now() - startTime
  };
}
```

### Step 7: Rights Management Integration

1. **Combine 190320250630 Rights System with Current Dispute Resolution**:

```typescript
// 190320250630 rights registration with Current optimization
async function registerRights(rightData) {
  // Rights registration code from 190320250630
}

// Current branch dispute resolution
async function createDispute({
  assetId,
  assetType,
  rightId,
  claimantId,
  respondentId,
  reason,
  evidence,
}) {
  // Validate dispute data
  if (!assetId || !assetType || !rightId || !claimantId || !respondentId || !reason) {
    throw new Error('Missing required dispute information');
  }
  
  // Create dispute workflow
  const workflow = {
    steps: [
      {
        name: 'dispute_opened',
        status: 'completed',
        completedAt: new Date().toISOString(),
        completedBy: claimantId,
      },
      {
        name: 'respondent_notification',
        status: 'pending',
      },
      {
        name: 'evidence_collection',
        status: 'in_progress',
        startedAt: new Date().toISOString(),
      },
      {
        name: 'admin_review',
        status: 'pending',
      },
      {
        name: 'resolution',
        status: 'pending',
      }
    ],
    currentStep: 'evidence_collection',
  };
  
  // Create dispute record
  const dispute = await db.rightsDisputes.create({
    data: {
      assetId,
      assetType,
      rightId,
      claimantId,
      respondentId,
      reason,
      evidence: evidence || [],
      status: 'open',
      workflow: JSON.stringify(workflow),
      createdAt: new Date(),
      updatedAt: new Date(),
    }
  });
  
  // Notification and return logic...
  
  return dispute;
}
```

### Step 8: Documentation Integration

1. **Apply PPv1/190320250630 Documentation Style to All Components**:

```typescript
/**
 * Generate content tags and analysis using AI
 * 
 * This function takes basic information about a piece of content (title, artist, type)
 * and generates detailed metadata and analysis using OpenAI's API.
 * 
 * If the OpenAI API is unavailable or not configured, the function falls back to:
 * 1. Cached results if available
 * 2. Basic pattern-based analysis as a last resort
 * 
 * @param title - The title of the content
 * @param artistName - The name of the artist or creator
 * @param type - The type of content ("audio" or "video")
 * @returns An object containing structured tags and analysis information
 */
export async function generateContentTags(
  title: string,
  artistName: string,
  type: "audio" | "video"
): Promise<{ tags: ContentTags; analysis: AIAnalysis }> {
  // Function implementation...
}
```

## Testing Strategy

After implementing these changes, test each component thoroughly:

1. **Database Schema**:
   - Verify all tables are created correctly
   - Test relationships between tables
   - Ensure validation works as expected

2. **Authentication**:
   - Test password validation
   - Verify role-based access control
   - Test session security monitoring

3. **Blockchain Integration**:
   - Verify multi-network support
   - Test gas optimization
   - Test rights registration

4. **AI Integration**:
   - Test with valid API key
   - Test fallback when API key is missing
   - Test fallback when service is unavailable

5. **Audio Processing**:
   - Test individual file processing
   - Test batch processing
   - Verify quality analysis

6. **Rights Management**:
   - Test rights registration
   - Test dispute creation and resolution
   - Verify workflow progression

## Final Steps

1. Update all imports and dependencies
2. Resolve any conflicts between implementations
3. Run comprehensive tests
4. Document the changes and implementation decisions