# Audio Fingerprinting Technical Documentation

## Overview

The audio fingerprinting system in TuneMantra uses acoustic fingerprinting technology to analyze and identify audio content. This system helps protect intellectual property rights, detect copyright infringement, and ensure content originality during the upload process.

## Architecture

The audio fingerprinting feature consists of several components:

1. **Client-Side Components**:
   - `AudioFingerprintValidator`: React component for upload validation
   - Audio processing and submission utilities

2. **Server-Side Components**:
   - ACR Cloud service integration
   - Fingerprinting API endpoints
   - Result processing and analysis

3. **External Services**:
   - ACR Cloud API (primary fingerprinting service)

## Technical Implementation

### Server-Side Implementation

#### ACR Cloud Service Integration

The platform integrates with ACR Cloud through the `acr-cloud-service.ts` module, which provides:

```typescript
// Core identification function
async function identifyAudio(audioBuffer: Buffer): Promise<IdentificationResult> {
  // Generate signature from audio
  const signature = acrCloud.createSignature({
    method: 'POST',
    uri: '/v1/identify',
    accessKey: process.env.ACR_CLOUD_ACCESS_KEY,
    secretKey: process.env.ACR_CLOUD_SECRET_KEY,
    dataType: 'audio',
    signatureVersion: '1'
  });

  // Send audio data to ACR Cloud for identification
  const response = await fetch('https://identify-eu-west-1.acrcloud.com/v1/identify', {
    method: 'POST',
    headers: {
      'Content-Type': 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW',
      'Accept': 'application/json',
      'Authorization': signature
    },
    body: createIdentifyFormData(audioBuffer)
  });

  // Process and return results
  const result = await response.json();
  return processIdentificationResult(result);
}

// Process and categorize results
function processIdentificationResult(result: any): IdentificationResult {
  const processed: IdentificationResult = {
    status: { code: result.status.code, message: result.status.msg },
    matches: [],
    metadata: {
      timestamp: new Date().toISOString(),
      processingTimeMs: result.cost_time || 0
    }
  };

  // Extract and process matched tracks
  if (result.metadata && result.metadata.music) {
    processed.matches = result.metadata.music.map(match => ({
      id: match.acrid,
      title: match.title,
      artist: match.artists.map(a => a.name).join(', '),
      album: match.album?.name || '',
      releaseDate: match.release_date || '',
      score: match.score,
      confidenceScore: calculateConfidenceScore(match),
      durationMs: match.duration_ms || 0,
      matchTimeMs: match.play_offset_ms,
      externalIds: extractExternalIds(match)
    }));
  }

  return processed;
}
```

#### API Endpoints

The platform exposes the following endpoints for fingerprinting operations:

1. **Identification Endpoint**:
   
```typescript
// POST /api/fingerprint/identify
router.post('/identify', upload.single('audio'), async (req, res) => {
  try {
    // Validate request
    if (!req.file) {
      return res.status(400).json({ 
        error: 'Missing audio file' 
      });
    }
    
    // Process audio file
    const result = await acrCloudService.identifyAudio(req.file.buffer);
    
    // Return identification results
    return res.json(result);
  } catch (error) {
    logger.error('Error in audio identification:', error);
    return res.status(500).json({ 
      error: 'Failed to process audio identification request' 
    });
  }
});
```

2. **Copyright Check Endpoint**:

```typescript
// POST /api/fingerprint/copyright-check
router.post('/copyright-check', upload.single('audio'), async (req, res) => {
  try {
    // Validate request
    if (!req.file) {
      return res.status(400).json({ 
        error: 'Missing audio file' 
      });
    }
    
    // Get metadata from request body
    const { title, artist } = req.body;
    
    // Process audio for copyright check
    const result = await acrCloudService.checkCopyright(
      req.file.buffer,
      { title, artist }
    );
    
    // Return copyright check results
    return res.json(result);
  } catch (error) {
    logger.error('Error in copyright check:', error);
    return res.status(500).json({ 
      error: 'Failed to process copyright check request' 
    });
  }
});
```

3. **Metadata Validation Endpoint**:

```typescript
// POST /api/fingerprint/validate-metadata
router.post('/validate-metadata', upload.single('audio'), async (req, res) => {
  try {
    // Validate request
    if (!req.file) {
      return res.status(400).json({ 
        error: 'Missing audio file' 
      });
    }
    
    // Get provided metadata
    const metadata = req.body;
    
    // Validate metadata against audio content
    const result = await acrCloudService.validateMetadata(
      req.file.buffer,
      metadata
    );
    
    // Return validation results
    return res.json(result);
  } catch (error) {
    logger.error('Error in metadata validation:', error);
    return res.status(500).json({ 
      error: 'Failed to process metadata validation request' 
    });
  }
});
```

### Client-Side Implementation

#### Audio Fingerprint Validator Component

The `AudioFingerprintValidator` component integrates with the upload form to validate audio files for copyright issues:

```tsx
// Client-side fingerprinting component
const AudioFingerprintValidator: React.FC<AudioFingerprintValidatorProps> = ({
  audioFile,
  metadata,
  onValidationComplete
}) => {
  const [isValidating, setIsValidating] = useState(false);
  const [results, setResults] = useState<ValidationResults | null>(null);
  const [error, setError] = useState<string | null>(null);

  // Function to start validation process
  const startValidation = async () => {
    if (!audioFile) {
      setError('No audio file provided');
      return;
    }

    setIsValidating(true);
    setError(null);

    try {
      // Create form data with audio file and metadata
      const formData = new FormData();
      formData.append('audio', audioFile);
      
      if (metadata.title) formData.append('title', metadata.title);
      if (metadata.artist) formData.append('artist', metadata.artist);

      // Send to server for processing
      const response = await fetch('/api/fingerprint/copyright-check', {
        method: 'POST',
        body: formData
      });

      if (!response.ok) {
        throw new Error(`Server returned ${response.status}`);
      }

      // Process results
      const validationResults = await response.json();
      setResults(validationResults);
      
      // Notify parent component
      if (onValidationComplete) {
        onValidationComplete(validationResults);
      }
    } catch (err) {
      setError(err.message || 'Failed to validate audio');
    } finally {
      setIsValidating(false);
    }
  };

  // Render component UI
  return (
    <div className="audio-fingerprint-validator">
      <h3>Copyright Validation</h3>
      
      {!isValidating && !results && (
        <Button onClick={startValidation} disabled={!audioFile}>
          Start Fingerprinting Validation
        </Button>
      )}
      
      {isValidating && (
        <div className="validation-in-progress">
          <Spinner />
          <p>Analyzing audio fingerprint...</p>
        </div>
      )}
      
      {results && (
        <ValidationResultsDisplay results={results} />
      )}
      
      {error && (
        <div className="validation-error">
          <AlertTriangle className="icon" />
          <p>Error: {error}</p>
        </div>
      )}
    </div>
  );
};
```

#### Integration with Upload Flow

The audio fingerprinting component is integrated into the upload flow in the metadata tab:

```tsx
// Integration in upload form
function UploadForm() {
  // Form state
  const [activeTab, setActiveTab] = useState('files');
  const [uploadedFiles, setUploadedFiles] = useState<File[]>([]);
  const [metadata, setMetadata] = useState<TrackMetadata>({
    title: '',
    artist: '',
    // Other metadata fields
  });
  const [fingerprintResults, setFingerprintResults] = useState(null);

  // Handle fingerprinting validation completion
  const handleValidationComplete = (results) => {
    setFingerprintResults(results);
    
    // Automatically update metadata if high confidence matches found
    if (results.matches && results.matches.length > 0) {
      const bestMatch = results.matches[0];
      if (bestMatch.confidenceScore > 90) {
        // Alert user about high-confidence match
        showConfirmationDialog({
          title: 'Potential Copyright Match',
          message: `We've detected a high-confidence match with "${bestMatch.title}" by ${bestMatch.artist}. Please ensure you have the rights to use this content.`,
          confirmLabel: 'Acknowledge',
          onConfirm: () => {}
        });
      }
    }
  };

  // Render form
  return (
    <div className="upload-form">
      <Tabs value={activeTab} onValueChange={setActiveTab}>
        <TabsList>
          <TabsTrigger value="files">Files</TabsTrigger>
          <TabsTrigger value="metadata">Metadata</TabsTrigger>
          <TabsTrigger value="rights">Rights</TabsTrigger>
          <TabsTrigger value="distribution">Distribution</TabsTrigger>
        </TabsList>
        
        <TabsContent value="files">
          {/* File upload UI */}
        </TabsContent>
        
        <TabsContent value="metadata">
          {/* Metadata form */}
          <div className="metadata-form">
            {/* Metadata fields */}
          </div>
          
          {/* Fingerprinting component */}
          {uploadedFiles.length > 0 && (
            <Card>
              <CardHeader>
                <CardTitle>Content Validation</CardTitle>
                <CardDescription>
                  Verify your content for copyright and quality issues
                </CardDescription>
              </CardHeader>
              <CardContent>
                <AudioFingerprintValidator 
                  audioFile={uploadedFiles[0]}
                  metadata={metadata}
                  onValidationComplete={handleValidationComplete}
                />
              </CardContent>
            </Card>
          )}
        </TabsContent>
        
        {/* Other tabs */}
      </Tabs>
    </div>
  );
}
```

## API Response Format

### Identification Response

```json
{
  "status": {
    "code": 0,
    "message": "Success"
  },
  "matches": [
    {
      "id": "acr_id_123456789",
      "title": "Song Title",
      "artist": "Artist Name",
      "album": "Album Name",
      "releaseDate": "2023-01-01",
      "score": 95,
      "confidenceScore": 92,
      "durationMs": 240000,
      "matchTimeMs": 15000,
      "externalIds": {
        "isrc": "ABC123456789",
        "upc": "123456789012"
      }
    }
  ],
  "metadata": {
    "timestamp": "2023-04-15T12:34:56Z",
    "processingTimeMs": 1250
  }
}
```

### Copyright Check Response

```json
{
  "status": {
    "code": 0,
    "message": "Success"
  },
  "copyrightIssues": {
    "hasIssues": true,
    "confidence": 95,
    "matches": [
      {
        "title": "Original Song",
        "artist": "Original Artist",
        "confidenceScore": 92,
        "matchType": "full_match",
        "potentialIssue": "This appears to be a copy of an existing track"
      }
    ]
  },
  "metadataIssues": {
    "hasIssues": true,
    "issues": [
      {
        "field": "title",
        "provided": "My Song",
        "detected": "Original Song",
        "confidence": 90,
        "issue": "Title does not match detected content"
      }
    ]
  },
  "sampleDetection": {
    "hasSamples": true,
    "samples": [
      {
        "title": "Sampled Track",
        "artist": "Sampled Artist",
        "confidence": 85,
        "startTimeMs": 45000,
        "durationMs": 3000
      }
    ]
  }
}
```

## Performance Considerations

1. **Optimization**:
   - Audio files are analyzed in chunks to improve processing speed
   - Background processing for large audio files
   - Results caching for previously analyzed content

2. **Rate Limiting**:
   - Service access is rate-limited to prevent overuse
   - Rate limits: 60 requests per minute, 1000 requests per day

3. **Error Handling**:
   - Robust error handling for network issues
   - Graceful degradation when service is unavailable
   - Clear error messages for troubleshooting

## Security Considerations

1. **Data Privacy**:
   - Audio data is only stored temporarily during processing
   - No permanent storage of uploaded audio for fingerprinting
   - Results are stored with appropriate access controls

2. **API Security**:
   - ACR Cloud API keys are stored securely in environment variables
   - All API requests use HTTPS encryption
   - Server-side signature generation for secure API access

## Environment Configuration

The following environment variables must be configured:

```
ACR_CLOUD_ACCESS_KEY=your_access_key
ACR_CLOUD_SECRET_KEY=your_secret_key
ACR_CLOUD_HOST=identify-eu-west-1.acrcloud.com
ACR_CLOUD_ENDPOINT=/v1/identify
```

## Troubleshooting

Common issues and solutions:

1. **Connection Issues**:
   - Verify network connectivity
   - Check ACR Cloud service status
   - Ensure correct API endpoint configuration

2. **Authentication Errors**:
   - Verify ACR Cloud keys are correctly configured
   - Ensure API keys have appropriate permissions

3. **Processing Errors**:
   - Validate audio file format (supported formats: MP3, WAV, AAC)
   - Check file size (maximum: 50MB)
   - Ensure minimum audio duration (10 seconds)