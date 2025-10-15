/*
  # TuneMantra Initial Database Schema

  ## Overview
  Complete database schema for TuneMantra music distribution platform.
  Supports artist management, releases, tracks, rights management, DDEX delivery,
  and royalty reporting.

  ## Tables Created

  ### User & Profile Management
  - `user_profiles` - Extended user profile data linked to Supabase Auth

  ### Content Management
  - `releases` - Albums, EPs, singles with metadata
  - `tracks` - Individual songs with audio files and metadata
  - `track_splits` - Rights holders and revenue splits for collaborations

  ### Distribution
  - `ddex_deliveries` - DDEX package delivery tracking to aggregators
  - `delivery_errors` - Error logs for failed deliveries

  ### Royalties & Payments
  - `royalty_reports` - Monthly reports from distribution partners
  - `royalty_transactions` - Individual streaming/download transactions
  - `artist_payments` - Calculated payments to artists

  ## Security
  - Row Level Security (RLS) enabled on all user-facing tables
  - Policies restrict access to user's own data
  - Authentication required for all operations
*/

-- User Profiles (extends Supabase Auth users)
CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Basic Info
  artist_name VARCHAR(200),
  label_name VARCHAR(200),
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(50),

  -- Address
  country VARCHAR(2), -- ISO 3166-1 alpha-2
  state VARCHAR(100),
  city VARCHAR(100),
  postal_code VARCHAR(20),
  address_line1 VARCHAR(200),
  address_line2 VARCHAR(200),

  -- Business Info
  tax_id VARCHAR(50), -- EIN, PAN, VAT, etc.
  business_type VARCHAR(50) DEFAULT 'individual', -- individual, company, label

  -- Payment Info (encrypted)
  payment_method VARCHAR(50), -- paypal, bank_transfer, stripe
  payment_details JSONB, -- Encrypted payment information

  -- Profile
  bio TEXT,
  profile_image_url TEXT,
  website_url VARCHAR(500),
  social_links JSONB, -- {instagram, twitter, spotify, etc}

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Releases (Albums, EPs, Singles)
CREATE TABLE IF NOT EXISTS releases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,

  -- Basic Info
  title VARCHAR(500) NOT NULL,
  artist_name VARCHAR(500) NOT NULL,
  label_name VARCHAR(200),

  -- Identifiers
  upc VARCHAR(13) UNIQUE, -- Universal Product Code (barcode)
  catalog_number VARCHAR(100),

  -- Metadata
  release_type VARCHAR(50) DEFAULT 'album', -- album, single, ep, compilation
  release_date DATE,
  original_release_date DATE,
  genre VARCHAR(100),
  subgenre VARCHAR(100),
  language VARCHAR(3), -- ISO 639-2 code

  -- Artwork
  cover_art_url TEXT,
  cover_art_storage_path TEXT,

  -- Copyright
  p_line VARCHAR(200), -- ℗ 2025 Label Name
  c_line VARCHAR(200), -- © 2025 Publisher Name

  -- Distribution
  territories TEXT[] DEFAULT '{Worldwide}', -- ISO country codes or 'Worldwide'
  excluded_territories TEXT[] DEFAULT '{}',
  distribution_partner VARCHAR(100), -- 'Believe', 'Warner', 'INgrooves', etc.

  -- Status
  status VARCHAR(50) DEFAULT 'draft', -- draft, submitted, processing, live, rejected, takedown
  submission_date TIMESTAMPTZ,
  live_date TIMESTAMPTZ,
  rejection_reason TEXT,

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tracks (individual songs)
CREATE TABLE IF NOT EXISTS tracks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  release_id UUID NOT NULL REFERENCES releases(id) ON DELETE CASCADE,

  -- Basic Info
  title VARCHAR(500) NOT NULL,
  version VARCHAR(100), -- 'Radio Edit', 'Acoustic', 'Remix', etc.
  artist_name VARCHAR(500) NOT NULL,
  featured_artists TEXT[] DEFAULT '{}',

  -- Identifiers
  isrc VARCHAR(12) UNIQUE, -- International Standard Recording Code
  track_number INTEGER NOT NULL,
  disc_number INTEGER DEFAULT 1,

  -- Audio File
  audio_url TEXT NOT NULL,
  audio_storage_path TEXT NOT NULL,
  duration_seconds INTEGER NOT NULL,
  file_format VARCHAR(10) NOT NULL, -- 'wav', 'flac', 'mp3'
  bit_rate INTEGER, -- kbps
  sample_rate INTEGER, -- Hz (44100, 48000, etc.)
  file_size_bytes BIGINT,

  -- Metadata
  explicit_content BOOLEAN DEFAULT FALSE,
  genre VARCHAR(100),
  subgenre VARCHAR(100),
  language VARCHAR(3), -- ISO 639-2
  lyrics TEXT,
  preview_start_time INTEGER DEFAULT 30, -- seconds into track for preview

  -- Copyright
  p_line VARCHAR(200),
  c_line VARCHAR(200),

  -- Publishing (for royalty splits)
  composers TEXT[],
  lyricists TEXT[],
  publishers TEXT[],

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  CONSTRAINT valid_track_number CHECK (track_number > 0),
  CONSTRAINT valid_duration CHECK (duration_seconds > 0)
);

-- Track Splits (for collaborators and rights holders)
CREATE TABLE IF NOT EXISTS track_splits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  track_id UUID NOT NULL REFERENCES tracks(id) ON DELETE CASCADE,

  -- Rights Holder
  user_id UUID REFERENCES user_profiles(id) ON DELETE SET NULL, -- If registered user
  collaborator_name VARCHAR(200) NOT NULL,
  collaborator_email VARCHAR(255),

  -- Split Details
  role VARCHAR(50) NOT NULL, -- 'artist', 'producer', 'songwriter', 'publisher', 'featured_artist'
  split_percentage DECIMAL(5,2) NOT NULL, -- 0.00 to 100.00

  -- Status
  status VARCHAR(50) DEFAULT 'pending', -- pending, accepted, rejected
  accepted_at TIMESTAMPTZ,

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  CONSTRAINT valid_split_percentage CHECK (split_percentage > 0 AND split_percentage <= 100)
);

-- DDEX Deliveries (batch uploads to aggregators)
CREATE TABLE IF NOT EXISTS ddex_deliveries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Batch Info
  batch_id VARCHAR(100) UNIQUE NOT NULL,
  release_ids UUID[] NOT NULL, -- Array of release IDs in this batch
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,

  -- Partner Info
  distribution_partner VARCHAR(100) NOT NULL,
  delivery_method VARCHAR(50) NOT NULL, -- 'ftp', 'sftp', 'api', 'manual'

  -- Files
  ddex_xml_url TEXT,
  ddex_xml_storage_path TEXT,
  package_url TEXT, -- ZIP file with all assets
  package_storage_path TEXT,

  -- Status
  status VARCHAR(50) DEFAULT 'pending', -- pending, uploading, uploaded, processing, completed, failed
  delivery_date TIMESTAMPTZ,
  confirmation_date TIMESTAMPTZ,
  completion_date TIMESTAMPTZ,

  -- Error Handling
  error_code VARCHAR(50),
  error_message TEXT,
  retry_count INTEGER DEFAULT 0,

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Delivery Errors (detailed error logs)
CREATE TABLE IF NOT EXISTS delivery_errors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  delivery_id UUID NOT NULL REFERENCES ddex_deliveries(id) ON DELETE CASCADE,

  -- Error Details
  error_type VARCHAR(100) NOT NULL, -- 'validation', 'upload', 'processing', 'dsp_rejection'
  error_code VARCHAR(50),
  error_message TEXT NOT NULL,
  error_details JSONB,

  -- Resolution
  resolved BOOLEAN DEFAULT FALSE,
  resolved_at TIMESTAMPTZ,
  resolution_notes TEXT,

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Royalty Reports (from distribution partners)
CREATE TABLE IF NOT EXISTS royalty_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Partner & Period
  partner_name VARCHAR(100) NOT NULL,
  report_period_start DATE NOT NULL,
  report_period_end DATE NOT NULL,

  -- File
  report_file_url TEXT,
  report_file_storage_path TEXT,
  file_format VARCHAR(20), -- 'csv', 'xml', 'xlsx'

  -- Import Status
  import_status VARCHAR(50) DEFAULT 'pending', -- pending, processing, completed, failed
  imported_at TIMESTAMPTZ,
  import_error TEXT,

  -- Summary
  total_streams BIGINT DEFAULT 0,
  total_downloads INTEGER DEFAULT 0,
  total_revenue DECIMAL(12,2) DEFAULT 0,
  currency VARCHAR(3) DEFAULT 'USD',

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  CONSTRAINT unique_partner_period UNIQUE (partner_name, report_period_start, report_period_end)
);

-- Royalty Transactions (individual line items from reports)
CREATE TABLE IF NOT EXISTS royalty_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id UUID NOT NULL REFERENCES royalty_reports(id) ON DELETE CASCADE,

  -- Track Identification
  isrc VARCHAR(12),
  track_id UUID REFERENCES tracks(id) ON DELETE SET NULL,
  upc VARCHAR(13),
  release_id UUID REFERENCES releases(id) ON DELETE SET NULL,
  user_id UUID REFERENCES user_profiles(id) ON DELETE SET NULL,

  -- DSP & Territory
  dsp_name VARCHAR(100) NOT NULL, -- 'Spotify', 'Apple Music', 'YouTube Music', etc.
  dsp_product_type VARCHAR(50), -- 'streaming', 'download', 'radio'
  territory VARCHAR(2), -- ISO country code

  -- Metrics
  streams INTEGER DEFAULT 0,
  downloads INTEGER DEFAULT 0,
  revenue_amount DECIMAL(10,4) NOT NULL,
  currency VARCHAR(3) DEFAULT 'USD',

  -- Period
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),

  CONSTRAINT valid_revenue CHECK (revenue_amount >= 0)
);

-- Artist Payments (calculated payments to artists)
CREATE TABLE IF NOT EXISTS artist_payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,

  -- Period
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,

  -- Revenue Breakdown
  gross_revenue DECIMAL(10,2) NOT NULL DEFAULT 0,
  aggregator_fee_amount DECIMAL(10,2) DEFAULT 0,
  platform_fee_percentage DECIMAL(5,2) DEFAULT 15.00, -- TuneMantra's fee
  platform_fee_amount DECIMAL(10,2) DEFAULT 0,
  net_payment DECIMAL(10,2) NOT NULL DEFAULT 0,

  -- Status
  payment_status VARCHAR(50) DEFAULT 'pending', -- pending, processing, paid, failed, cancelled
  payment_method VARCHAR(50), -- 'paypal', 'bank_transfer', 'stripe'
  payment_date DATE,
  payment_reference VARCHAR(200), -- Transaction ID from payment processor
  payment_error TEXT,

  -- Statement
  statement_url TEXT,
  statement_storage_path TEXT,

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  CONSTRAINT unique_user_period UNIQUE (user_id, period_start, period_end),
  CONSTRAINT valid_gross_revenue CHECK (gross_revenue >= 0),
  CONSTRAINT valid_net_payment CHECK (net_payment >= 0)
);

-- Indexes for Performance
CREATE INDEX IF NOT EXISTS idx_releases_user_id ON releases(user_id);
CREATE INDEX IF NOT EXISTS idx_releases_status ON releases(status);
CREATE INDEX IF NOT EXISTS idx_releases_upc ON releases(upc);
CREATE INDEX IF NOT EXISTS idx_tracks_release_id ON tracks(release_id);
CREATE INDEX IF NOT EXISTS idx_tracks_isrc ON tracks(isrc);
CREATE INDEX IF NOT EXISTS idx_track_splits_track_id ON track_splits(track_id);
CREATE INDEX IF NOT EXISTS idx_track_splits_user_id ON track_splits(user_id);
CREATE INDEX IF NOT EXISTS idx_ddex_deliveries_user_id ON ddex_deliveries(user_id);
CREATE INDEX IF NOT EXISTS idx_ddex_deliveries_status ON ddex_deliveries(status);
CREATE INDEX IF NOT EXISTS idx_royalty_transactions_isrc ON royalty_transactions(isrc);
CREATE INDEX IF NOT EXISTS idx_royalty_transactions_track_id ON royalty_transactions(track_id);
CREATE INDEX IF NOT EXISTS idx_royalty_transactions_user_id ON royalty_transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_royalty_transactions_dsp ON royalty_transactions(dsp_name);
CREATE INDEX IF NOT EXISTS idx_artist_payments_user_id ON artist_payments(user_id);
CREATE INDEX IF NOT EXISTS idx_artist_payments_status ON artist_payments(payment_status);

-- Row Level Security (RLS) Policies

-- Enable RLS on all tables
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE releases ENABLE ROW LEVEL SECURITY;
ALTER TABLE tracks ENABLE ROW LEVEL SECURITY;
ALTER TABLE track_splits ENABLE ROW LEVEL SECURITY;
ALTER TABLE ddex_deliveries ENABLE ROW LEVEL SECURITY;
ALTER TABLE delivery_errors ENABLE ROW LEVEL SECURITY;
ALTER TABLE royalty_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE artist_payments ENABLE ROW LEVEL SECURITY;

-- User Profiles Policies
CREATE POLICY "Users can view own profile"
  ON user_profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON user_profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON user_profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Releases Policies
CREATE POLICY "Users can view own releases"
  ON releases FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own releases"
  ON releases FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own releases"
  ON releases FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own releases"
  ON releases FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Tracks Policies
CREATE POLICY "Users can view own tracks"
  ON tracks FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM releases
      WHERE releases.id = tracks.release_id
      AND releases.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own tracks"
  ON tracks FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM releases
      WHERE releases.id = tracks.release_id
      AND releases.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own tracks"
  ON tracks FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM releases
      WHERE releases.id = tracks.release_id
      AND releases.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM releases
      WHERE releases.id = tracks.release_id
      AND releases.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own tracks"
  ON tracks FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM releases
      WHERE releases.id = tracks.release_id
      AND releases.user_id = auth.uid()
    )
  );

-- Track Splits Policies
CREATE POLICY "Users can view tracks they own or collaborate on"
  ON track_splits FOR SELECT
  TO authenticated
  USING (
    auth.uid() = user_id OR
    EXISTS (
      SELECT 1 FROM tracks
      JOIN releases ON releases.id = tracks.release_id
      WHERE tracks.id = track_splits.track_id
      AND releases.user_id = auth.uid()
    )
  );

CREATE POLICY "Track owners can manage splits"
  ON track_splits FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM tracks
      JOIN releases ON releases.id = tracks.release_id
      WHERE tracks.id = track_splits.track_id
      AND releases.user_id = auth.uid()
    )
  );

-- DDEX Deliveries Policies
CREATE POLICY "Users can view own deliveries"
  ON ddex_deliveries FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- Delivery Errors Policies
CREATE POLICY "Users can view own delivery errors"
  ON delivery_errors FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM ddex_deliveries
      WHERE ddex_deliveries.id = delivery_errors.delivery_id
      AND ddex_deliveries.user_id = auth.uid()
    )
  );

-- Royalty Transactions Policies
CREATE POLICY "Users can view own transactions"
  ON royalty_transactions FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- Artist Payments Policies
CREATE POLICY "Users can view own payments"
  ON artist_payments FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- Updated_at Trigger Function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at triggers
CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON user_profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_releases_updated_at BEFORE UPDATE ON releases
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tracks_updated_at BEFORE UPDATE ON tracks
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_track_splits_updated_at BEFORE UPDATE ON track_splits
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_ddex_deliveries_updated_at BEFORE UPDATE ON ddex_deliveries
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_royalty_reports_updated_at BEFORE UPDATE ON royalty_reports
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_artist_payments_updated_at BEFORE UPDATE ON artist_payments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
