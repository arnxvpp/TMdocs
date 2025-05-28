# Frontend Architecture Documentation

## Overview

TuneMantra's frontend is built using React with TypeScript, providing a responsive and intuitive user interface for artists, labels, and administrators. The architecture follows modern best practices with a focus on component reusability, state management, and user experience.

## Technology Stack

### Core Technologies

- **React**: Library for building user interfaces
- **TypeScript**: Typed superset of JavaScript for better developer experience
- **Vite**: Build tool for faster development and optimized production builds
- **TanStack Query**: Data fetching, caching, and state management
- **React Router DOM**: Routing and navigation
- **Wouter**: Lightweight routing alternative

### UI Framework

- **Tailwind CSS**: Utility-first CSS framework
- **Shadcn/UI**: Component library built on Radix UI primitives
- **Radix UI**: Unstyled, accessible UI components
- **Lucide React**: Icon library
- **Framer Motion**: Animation library

### Form Management

- **React Hook Form**: Form state management and validation
- **Zod**: Schema validation library
- **@hookform/resolvers**: Integration between React Hook Form and Zod

### Data Visualization

- **Recharts**: Composable charting library
- **React ChartJS**: ChartJS wrapper for React
- **D3.js**: Low-level data visualization library (for complex visualizations)

## Architecture Principles

The frontend follows these core principles:

1. **Component-Based Architecture**: Encapsulated, reusable components
2. **Typed Interfaces**: TypeScript for type safety across the application
3. **Separation of Concerns**: Clear boundaries between presentation, state, and logic
4. **Responsive Design**: Mobile-first approach to support all device sizes
5. **Accessibility**: WCAG compliance throughout the interface
6. **Performance Optimization**: Efficient rendering and loading strategies

## Application Structure

The frontend code is organized into the following structure:

```
client/
├── public/          # Static assets
├── src/
│   ├── components/  # React components
│   │   ├── ui/      # Base UI components
│   │   ├── layouts/ # Layout components
│   │   ├── forms/   # Form components
│   │   ├── charts/  # Data visualization components
│   │   └── feature/ # Feature-specific components
│   ├── hooks/       # Custom React hooks
│   ├── lib/         # Utility functions and constants
│   ├── pages/       # Page components
│   ├── schemas/     # Validation schemas
│   ├── services/    # API service functions
│   ├── styles/      # Global styles and Tailwind configuration
│   ├── types/       # TypeScript types and interfaces
│   ├── App.tsx      # Main application component
│   └── main.tsx     # Application entry point
├── index.html       # HTML template
└── vite.config.ts   # Vite configuration
```

## Component Architecture

### Component Hierarchy

The component hierarchy is structured for reusability and clarity:

1. **UI Components**: Base components like Button, Input, Card
2. **Layout Components**: Page layouts, navigation, headers
3. **Feature Components**: Domain-specific components for music, analytics, etc.
4. **Page Components**: Full page compositions combining other components

### Component Types

Components are categorized by responsibility:

- **Presentation Components**: Focus on UI rendering with minimal logic
- **Container Components**: Manage state and data fetching for child components
- **Layout Components**: Handle positioning and structure
- **Provider Components**: Supply context or state to component trees

### Component Pattern

Most components follow this pattern:

```tsx
// Example Component Pattern
import { useState, useEffect } from 'react';
import { useQuery } from '@tanstack/react-query';
import { Button } from '@/components/ui/button';
import { apiRequest } from '@/lib/queryClient';

// TypeScript interface for props
interface TrackListProps {
  userId: number;
  onTrackSelect?: (trackId: number) => void;
  limit?: number;
}

// Component implementation
export function TrackList({ userId, onTrackSelect, limit = 10 }: TrackListProps) {
  // Data fetching with TanStack Query
  const { data, isLoading, error } = useQuery({
    queryKey: ['/api/users', userId, 'tracks'],
    queryFn: () => apiRequest(`/api/users/${userId}/tracks?limit=${limit}`),
  });

  // Handle loading state
  if (isLoading) {
    return <div className="loading-spinner" />;
  }

  // Handle error state
  if (error) {
    return <div className="error-message">Failed to load tracks</div>;
  }

  // Render component
  return (
    <div className="track-list">
      <h2 className="text-xl font-bold mb-4">Your Tracks</h2>
      <ul className="space-y-2">
        {data.map((track) => (
          <li key={track.id} className="p-2 hover:bg-slate-100 rounded">
            <div className="flex justify-between items-center">
              <span>{track.title}</span>
              <Button 
                variant="ghost" 
                onClick={() => onTrackSelect?.(track.id)}
              >
                View Details
              </Button>
            </div>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

## State Management

### Local Component State

For component-specific state:

```tsx
function Counter() {
  const [count, setCount] = useState(0);
  
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}
```

### Form State

Form state managed with React Hook Form:

```tsx
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

// Define schema with Zod
const schema = z.object({
  title: z.string().min(1, 'Title is required'),
  artist: z.string().min(1, 'Artist is required'),
  genre: z.string().min(1, 'Genre is required'),
});

// Infer TypeScript type from schema
type FormValues = z.infer<typeof schema>;

function TrackForm() {
  // Initialize form with schema validation
  const form = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: {
      title: '',
      artist: '',
      genre: '',
    },
  });
  
  const onSubmit = (data: FormValues) => {
    console.log(data);
    // Submit data to API
  };
  
  return (
    <form onSubmit={form.handleSubmit(onSubmit)}>
      <div>
        <label>Title</label>
        <input {...form.register('title')} />
        {form.formState.errors.title && (
          <p>{form.formState.errors.title.message}</p>
        )}
      </div>
      
      <div>
        <label>Artist</label>
        <input {...form.register('artist')} />
        {form.formState.errors.artist && (
          <p>{form.formState.errors.artist.message}</p>
        )}
      </div>
      
      <div>
        <label>Genre</label>
        <input {...form.register('genre')} />
        {form.formState.errors.genre && (
          <p>{form.formState.errors.genre.message}</p>
        )}
      </div>
      
      <button type="submit">Submit</button>
    </form>
  );
}
```

### Server State

Server state managed with TanStack Query:

```tsx
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { apiRequest } from '@/lib/queryClient';

// Data fetching hook
function useUserTracks(userId: number) {
  return useQuery({
    queryKey: ['/api/users', userId, 'tracks'],
    queryFn: () => apiRequest(`/api/users/${userId}/tracks`),
  });
}

// Data mutation hook
function useCreateTrack() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (trackData) => 
      apiRequest('/api/tracks', { method: 'POST', data: trackData }),
    onSuccess: (data, variables, context) => {
      // Invalidate related queries to trigger refetch
      queryClient.invalidateQueries({ queryKey: ['/api/users', variables.userId, 'tracks'] });
    },
  });
}

// Usage in component
function TracksManager({ userId }) {
  const { data, isLoading } = useUserTracks(userId);
  const createTrack = useCreateTrack();
  
  const handleAddTrack = (trackData) => {
    createTrack.mutate({ ...trackData, userId });
  };
  
  // Component JSX
}
```

### Context API

For shared state across components:

```tsx
import { createContext, useContext, useState } from 'react';

// Create context with type
interface ThemeContextType {
  darkMode: boolean;
  toggleDarkMode: () => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

// Provider component
export function ThemeProvider({ children }) {
  const [darkMode, setDarkMode] = useState(false);
  
  const toggleDarkMode = () => setDarkMode(!darkMode);
  
  return (
    <ThemeContext.Provider value={{ darkMode, toggleDarkMode }}>
      {children}
    </ThemeContext.Provider>
  );
}

// Custom hook for consuming context
export function useTheme() {
  const context = useContext(ThemeContext);
  
  if (context === undefined) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  
  return context;
}
```

## Routing and Navigation

### Route Configuration

Using React Router DOM or Wouter for routing:

```tsx
import { Route, Switch } from 'wouter';
import Dashboard from '@/pages/Dashboard';
import Tracks from '@/pages/Tracks';
import Releases from '@/pages/Releases';
import Analytics from '@/pages/Analytics';
import Settings from '@/pages/Settings';
import NotFound from '@/pages/NotFound';

function AppRoutes() {
  return (
    <Switch>
      <Route path="/" component={Dashboard} />
      <Route path="/tracks" component={Tracks} />
      <Route path="/tracks/:id" component={TrackDetail} />
      <Route path="/releases" component={Releases} />
      <Route path="/releases/:id" component={ReleaseDetail} />
      <Route path="/analytics" component={Analytics} />
      <Route path="/settings" component={Settings} />
      <Route component={NotFound} />
    </Switch>
  );
}
```

### Protected Routes

Restricting access to authenticated users:

```tsx
import { Route, Redirect } from 'wouter';
import { useAuth } from '@/hooks/useAuth';

interface ProtectedRouteProps {
  component: React.ComponentType<any>;
  path: string;
  requiredRole?: string;
}

function ProtectedRoute({ component: Component, requiredRole, ...rest }: ProtectedRouteProps) {
  const { isAuthenticated, user } = useAuth();
  
  return (
    <Route
      {...rest}
      render={(props) => {
        // Check authentication
        if (!isAuthenticated) {
          return <Redirect to="/login" />;
        }
        
        // Check role if required
        if (requiredRole && user.role !== requiredRole) {
          return <Redirect to="/unauthorized" />;
        }
        
        // Render component if authorized
        return <Component {...props} />;
      }}
    />
  );
}
```

### Navigation Components

Consistent navigation pattern:

```tsx
import { Link, useLocation } from 'wouter';
import { useAuth } from '@/hooks/useAuth';

function Navigation() {
  const [location] = useLocation();
  const { isAuthenticated, user } = useAuth();
  
  return (
    <nav className="w-64 bg-slate-800 text-white h-screen p-4">
      <div className="logo mb-8">TuneMantra</div>
      
      <ul className="space-y-2">
        <li>
          <Link href="/">
            <a className={location === '/' ? 'active-link' : 'nav-link'}>
              Dashboard
            </a>
          </Link>
        </li>
        
        <li>
          <Link href="/tracks">
            <a className={location.startsWith('/tracks') ? 'active-link' : 'nav-link'}>
              Tracks
            </a>
          </Link>
        </li>
        
        <li>
          <Link href="/releases">
            <a className={location.startsWith('/releases') ? 'active-link' : 'nav-link'}>
              Releases
            </a>
          </Link>
        </li>
        
        <li>
          <Link href="/analytics">
            <a className={location.startsWith('/analytics') ? 'active-link' : 'nav-link'}>
              Analytics
            </a>
          </Link>
        </li>
        
        {/* Show admin section only for admin users */}
        {isAuthenticated && user.role === 'admin' && (
          <li>
            <Link href="/admin">
              <a className={location.startsWith('/admin') ? 'active-link' : 'nav-link'}>
                Admin
              </a>
            </Link>
          </li>
        )}
      </ul>
    </nav>
  );
}
```

## Data Fetching

### API Client

Centralized API client for consistent data fetching:

```tsx
// lib/queryClient.ts
import { QueryClient } from '@tanstack/react-query';
import axios from 'axios';

// Create axios instance
const axiosInstance = axios.create({
  baseURL: '/api',
  headers: {
    'Content-Type': 'application/json',
  },
  withCredentials: true, // Include cookies for authentication
});

// Create query client
export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnWindowFocus: false,
      retry: 1,
      staleTime: 5 * 60 * 1000, // 5 minutes
    },
  },
});

// API request function
export async function apiRequest(url: string, options = {}) {
  try {
    const response = await axiosInstance(url, options);
    return response.data.data;
  } catch (error) {
    // Extract error message from response
    const message = error.response?.data?.error?.message || 'An error occurred';
    throw new Error(message);
  }
}
```

### Custom Hooks for API Calls

Domain-specific hooks for data operations:

```tsx
// hooks/useTracks.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { apiRequest } from '@/lib/queryClient';
import { Track, InsertTrack } from '@shared/schema';

// Get all tracks for a user
export function useUserTracks(userId: number) {
  return useQuery<Track[]>({
    queryKey: ['/api/users', userId, 'tracks'],
    queryFn: () => apiRequest(`/api/users/${userId}/tracks`),
  });
}

// Get a single track by ID
export function useTrack(trackId: number) {
  return useQuery<Track>({
    queryKey: ['/api/tracks', trackId],
    queryFn: () => apiRequest(`/api/tracks/${trackId}`),
    enabled: !!trackId, // Only run if trackId is provided
  });
}

// Create a new track
export function useCreateTrack() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (track: InsertTrack) => 
      apiRequest('/api/tracks', { method: 'POST', data: track }),
    onSuccess: (data, variables) => {
      // Invalidate users tracks query to trigger refetch
      queryClient.invalidateQueries({ 
        queryKey: ['/api/users', variables.userId, 'tracks'] 
      });
    },
  });
}

// Update a track
export function useUpdateTrack() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ id, ...data }: { id: number, [key: string]: any }) => 
      apiRequest(`/api/tracks/${id}`, { method: 'PATCH', data }),
    onSuccess: (data) => {
      // Invalidate specific track query
      queryClient.invalidateQueries({ 
        queryKey: ['/api/tracks', data.id] 
      });
      // Invalidate user tracks query
      queryClient.invalidateQueries({ 
        queryKey: ['/api/users', data.userId, 'tracks'] 
      });
    },
  });
}
```

## Form Handling

### Form Components with Shadcn UI

Consistent form implementation using Shadcn UI components:

```tsx
import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import * as z from 'zod';
import { Button } from '@/components/ui/button';
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { useCreateTrack } from '@/hooks/useTracks';

// Define form schema
const formSchema = z.object({
  title: z.string().min(1, 'Title is required'),
  artist: z.string().min(1, 'Artist is required'),
  genre: z.string().min(1, 'Genre is required'),
  releaseDate: z.string().refine(date => !isNaN(Date.parse(date)), {
    message: 'Invalid date format',
  }),
});

function TrackForm({ userId }) {
  const createTrack = useCreateTrack();
  
  // Initialize form
  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      title: '',
      artist: '',
      genre: '',
      releaseDate: new Date().toISOString().split('T')[0],
    },
  });
  
  // Form submission handler
  function onSubmit(values: z.infer<typeof formSchema>) {
    createTrack.mutate({
      ...values,
      userId,
      status: 'draft',
    });
  }
  
  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
        <FormField
          control={form.control}
          name="title"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Track Title</FormLabel>
              <FormControl>
                <Input {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        
        <FormField
          control={form.control}
          name="artist"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Artist Name</FormLabel>
              <FormControl>
                <Input {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        
        <FormField
          control={form.control}
          name="genre"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Genre</FormLabel>
              <Select onValueChange={field.onChange} defaultValue={field.value}>
                <FormControl>
                  <SelectTrigger>
                    <SelectValue placeholder="Select a genre" />
                  </SelectTrigger>
                </FormControl>
                <SelectContent>
                  <SelectItem value="pop">Pop</SelectItem>
                  <SelectItem value="rock">Rock</SelectItem>
                  <SelectItem value="hip_hop">Hip Hop</SelectItem>
                  <SelectItem value="electronic">Electronic</SelectItem>
                  <SelectItem value="classical">Classical</SelectItem>
                </SelectContent>
              </Select>
              <FormMessage />
            </FormItem>
          )}
        />
        
        <FormField
          control={form.control}
          name="releaseDate"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Release Date</FormLabel>
              <FormControl>
                <Input type="date" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        
        <Button type="submit" disabled={createTrack.isPending}>
          {createTrack.isPending ? 'Saving...' : 'Save Track'}
        </Button>
      </form>
    </Form>
  );
}
```

### File Upload Components

Handling file uploads with progress tracking:

```tsx
import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Progress } from '@/components/ui/progress';

interface FileUploadProps {
  accept: string;
  onUpload: (file: File) => Promise<void>;
  label: string;
}

function FileUpload({ accept, onUpload, label }: FileUploadProps) {
  const [file, setFile] = useState<File | null>(null);
  const [progress, setProgress] = useState(0);
  const [isUploading, setIsUploading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  
  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      setFile(e.target.files[0]);
      setError(null);
    }
  };
  
  const handleUpload = async () => {
    if (!file) {
      setError('Please select a file');
      return;
    }
    
    setIsUploading(true);
    setProgress(0);
    
    try {
      // Simulate progress updates
      const progressInterval = setInterval(() => {
        setProgress((prev) => {
          if (prev >= 95) {
            clearInterval(progressInterval);
            return 95;
          }
          return prev + 5;
        });
      }, 300);
      
      // Perform actual upload
      await onUpload(file);
      
      // Complete progress and clear state
      clearInterval(progressInterval);
      setProgress(100);
      setFile(null);
      setError(null);
      
      // Reset form after delay
      setTimeout(() => {
        setProgress(0);
        setIsUploading(false);
      }, 1000);
    } catch (err) {
      setError(err.message || 'Upload failed');
      setIsUploading(false);
      setProgress(0);
    }
  };
  
  return (
    <div className="space-y-4">
      <div className="flex items-center space-x-4">
        <input
          type="file"
          accept={accept}
          onChange={handleFileChange}
          disabled={isUploading}
          className="hidden"
          id="file-upload"
        />
        <label
          htmlFor="file-upload"
          className="px-4 py-2 bg-slate-200 hover:bg-slate-300 rounded cursor-pointer"
        >
          {label}
        </label>
        <span className="text-sm text-gray-500">
          {file ? file.name : 'No file selected'}
        </span>
      </div>
      
      {file && (
        <Button 
          onClick={handleUpload} 
          disabled={isUploading}
          variant="default"
        >
          {isUploading ? 'Uploading...' : 'Upload File'}
        </Button>
      )}
      
      {isUploading && (
        <Progress value={progress} className="w-full" />
      )}
      
      {error && (
        <p className="text-red-500 text-sm">{error}</p>
      )}
    </div>
  );
}
```

## Authentication

### Authentication Context

Centralized authentication management:

```tsx
import { createContext, useContext, useState, useEffect } from 'react';
import { apiRequest } from '@/lib/queryClient';

// Type definitions
interface User {
  id: number;
  username: string;
  email: string;
  fullName: string;
  role: string;
  status: string;
}

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  login: (username: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
  register: (userData: any) => Promise<void>;
}

// Create context
const AuthContext = createContext<AuthContextType | undefined>(undefined);

// Provider component
export function AuthProvider({ children }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  
  // Check authentication status on mount
  useEffect(() => {
    const checkAuth = async () => {
      try {
        const userData = await apiRequest('/api/auth/status');
        setUser(userData);
      } catch (error) {
        setUser(null);
      } finally {
        setIsLoading(false);
      }
    };
    
    checkAuth();
  }, []);
  
  // Login function
  const login = async (username: string, password: string) => {
    setIsLoading(true);
    try {
      const userData = await apiRequest('/api/auth/login', {
        method: 'POST',
        data: { username, password },
      });
      setUser(userData);
    } finally {
      setIsLoading(false);
    }
  };
  
  // Logout function
  const logout = async () => {
    setIsLoading(true);
    try {
      await apiRequest('/api/auth/logout', { method: 'POST' });
      setUser(null);
    } finally {
      setIsLoading(false);
    }
  };
  
  // Register function
  const register = async (userData: any) => {
    setIsLoading(true);
    try {
      const newUser = await apiRequest('/api/auth/register', {
        method: 'POST',
        data: userData,
      });
      setUser(newUser);
    } finally {
      setIsLoading(false);
    }
  };
  
  return (
    <AuthContext.Provider
      value={{
        user,
        isAuthenticated: !!user,
        isLoading,
        login,
        logout,
        register,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

// Custom hook for using auth context
export function useAuth() {
  const context = useContext(AuthContext);
  
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  
  return context;
}
```

## Data Visualization

### Chart Components

Reusable chart components for analytics:

```tsx
import { 
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer 
} from 'recharts';

interface TimeSeriesChartProps {
  data: Array<{ date: string; [key: string]: any }>;
  dataKeys: Array<{ key: string; name: string; color: string }>;
  title: string;
  xAxisLabel?: string;
  yAxisLabel?: string;
}

export function TimeSeriesChart({
  data,
  dataKeys,
  title,
  xAxisLabel = 'Date',
  yAxisLabel,
}: TimeSeriesChartProps) {
  return (
    <div className="bg-white p-4 rounded-lg shadow">
      <h3 className="text-lg font-medium mb-4">{title}</h3>
      
      <div className="h-64 w-full">
        <ResponsiveContainer width="100%" height="100%">
          <LineChart
            data={data}
            margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
          >
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis 
              dataKey="date" 
              label={{ 
                value: xAxisLabel, 
                position: 'insideBottomRight', 
                offset: -10 
              }} 
            />
            <YAxis 
              label={
                yAxisLabel 
                  ? { 
                      value: yAxisLabel, 
                      angle: -90, 
                      position: 'insideLeft' 
                    } 
                  : undefined
              } 
            />
            <Tooltip />
            <Legend />
            
            {dataKeys.map((dataKey) => (
              <Line
                key={dataKey.key}
                type="monotone"
                dataKey={dataKey.key}
                name={dataKey.name}
                stroke={dataKey.color}
                activeDot={{ r: 8 }}
              />
            ))}
          </LineChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
```

### Dashboard Components

Comprehensive dashboard layouts:

```tsx
import { useQuery } from '@tanstack/react-query';
import { apiRequest } from '@/lib/queryClient';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { TimeSeriesChart } from '@/components/charts/TimeSeriesChart';
import { PieChart } from '@/components/charts/PieChart';
import { StatCard } from '@/components/ui/stat-card';

function Dashboard() {
  const { data: dashboardData, isLoading } = useQuery({
    queryKey: ['/api/analytics/dashboard'],
    queryFn: () => apiRequest('/api/analytics/dashboard'),
  });
  
  if (isLoading) {
    return <div className="dashboard-loading">Loading dashboard data...</div>;
  }
  
  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold">Dashboard</h1>
      
      {/* Summary stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          title="Total Streams"
          value={dashboardData.summary.totalStreams.toLocaleString()}
          change={dashboardData.summary.streamChange}
          changeLabel="vs last period"
        />
        
        <StatCard
          title="Total Revenue"
          value={`$${dashboardData.summary.totalRevenue.toFixed(2)}`}
          change={dashboardData.summary.revenueChange}
          changeLabel="vs last period"
        />
        
        <StatCard
          title="Active Releases"
          value={dashboardData.summary.activeReleases}
        />
        
        <StatCard
          title="Top Country"
          value={dashboardData.summary.topCountry}
        />
      </div>
      
      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <TimeSeriesChart
          title="Streams Over Time"
          data={dashboardData.streamTimeSeries}
          dataKeys={[
            { key: 'streams', name: 'Streams', color: '#3b82f6' }
          ]}
          yAxisLabel="Streams"
        />
        
        <TimeSeriesChart
          title="Revenue Over Time"
          data={dashboardData.revenueTimeSeries}
          dataKeys={[
            { key: 'revenue', name: 'Revenue ($)', color: '#10b981' }
          ]}
          yAxisLabel="Revenue ($)"
        />
      </div>
      
      {/* More detailed charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Platform Breakdown</CardTitle>
          </CardHeader>
          <CardContent>
            <PieChart
              data={dashboardData.platformBreakdown}
              dataKey="streams"
              nameKey="platform"
              colors={['#3b82f6', '#ef4444', '#f59e0b', '#10b981', '#8b5cf6']}
            />
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader>
            <CardTitle>Country Breakdown</CardTitle>
          </CardHeader>
          <CardContent>
            <PieChart
              data={dashboardData.countryBreakdown}
              dataKey="streams"
              nameKey="country"
              colors={['#3b82f6', '#ef4444', '#f59e0b', '#10b981', '#8b5cf6']}
            />
          </CardContent>
        </Card>
      </div>
      
      {/* Top performing content */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Top Tracks</CardTitle>
          </CardHeader>
          <CardContent>
            <ul className="space-y-2">
              {dashboardData.topTracks.map((track) => (
                <li key={track.id} className="flex justify-between items-center p-2 border-b">
                  <span>{track.title}</span>
                  <span>{track.streams.toLocaleString()} streams</span>
                </li>
              ))}
            </ul>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader>
            <CardTitle>Top Releases</CardTitle>
          </CardHeader>
          <CardContent>
            <ul className="space-y-2">
              {dashboardData.topReleases.map((release) => (
                <li key={release.id} className="flex justify-between items-center p-2 border-b">
                  <span>{release.title}</span>
                  <span>{release.streams.toLocaleString()} streams</span>
                </li>
              ))}
            </ul>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
```

## Responsive Design

### Responsive Layout Components

Layout components with responsive behavior:

```tsx
// components/layouts/AppLayout.tsx
import { useState } from 'react';
import { Sidebar } from '@/components/layouts/Sidebar';
import { Header } from '@/components/layouts/Header';

interface AppLayoutProps {
  children: React.ReactNode;
}

export function AppLayout({ children }: AppLayoutProps) {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  
  return (
    <div className="min-h-screen bg-slate-50">
      {/* Mobile sidebar */}
      <div className={`md:hidden fixed inset-0 z-50 bg-black bg-opacity-50 transition-opacity ${
        sidebarOpen ? 'opacity-100' : 'opacity-0 pointer-events-none'
      }`}>
        <div className="absolute inset-0" onClick={() => setSidebarOpen(false)} />
        <div className={`fixed inset-y-0 left-0 w-64 bg-white shadow-lg transform transition-transform ${
          sidebarOpen ? 'translate-x-0' : '-translate-x-full'
        }`}>
          <Sidebar onNavItemClick={() => setSidebarOpen(false)} />
        </div>
      </div>
      
      {/* Desktop sidebar */}
      <div className="hidden md:block fixed inset-y-0 left-0 w-64 bg-white shadow-lg">
        <Sidebar />
      </div>
      
      {/* Main content */}
      <div className="md:pl-64 flex flex-col flex-1">
        <Header onMenuClick={() => setSidebarOpen(true)} />
        
        <main className="flex-1 p-6">
          <div className="max-w-7xl mx-auto">
            {children}
          </div>
        </main>
      </div>
    </div>
  );
}
```

### Responsive UI Components

UI components that adapt to different screen sizes:

```tsx
// components/ui/responsive-grid.tsx
import { ReactNode } from 'react';

interface ResponsiveGridProps {
  children: ReactNode;
  columns?: {
    sm?: number;
    md?: number;
    lg?: number;
    xl?: number;
  };
  gap?: string;
}

export function ResponsiveGrid({ 
  children, 
  columns = { sm: 1, md: 2, lg: 3, xl: 4 },
  gap = 'gap-6',
}: ResponsiveGridProps) {
  // Build class string based on column configuration
  const columnClasses = [
    `grid-cols-${columns.sm || 1}`,
    `md:grid-cols-${columns.md || 2}`,
    `lg:grid-cols-${columns.lg || 3}`,
    `xl:grid-cols-${columns.xl || 4}`,
  ].join(' ');
  
  return (
    <div className={`grid ${columnClasses} ${gap}`}>
      {children}
    </div>
  );
}
```

## Error Handling

### Error Boundary Component

Catch and display React component errors:

```tsx
import { Component, ErrorInfo, ReactNode } from 'react';

interface ErrorBoundaryProps {
  children: ReactNode;
  fallback?: ReactNode;
}

interface ErrorBoundaryState {
  hasError: boolean;
  error?: Error;
}

export class ErrorBoundary extends Component<ErrorBoundaryProps, ErrorBoundaryState> {
  constructor(props: ErrorBoundaryProps) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo): void {
    // Log error to monitoring service
    console.error('Component error:', error, errorInfo);
  }

  render(): ReactNode {
    if (this.state.hasError) {
      if (this.props.fallback) {
        return this.props.fallback;
      }
      
      return (
        <div className="p-6 bg-red-50 border border-red-200 rounded-lg">
          <h2 className="text-xl font-bold text-red-700 mb-2">Something went wrong</h2>
          <p className="text-red-600 mb-4">
            An error occurred while rendering this component.
          </p>
          {this.state.error && (
            <pre className="bg-white p-4 rounded text-sm overflow-auto">
              {this.state.error.toString()}
            </pre>
          )}
          <button
            className="mt-4 px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700"
            onClick={() => this.setState({ hasError: false, error: undefined })}
          >
            Try again
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}
```

### Error State Components

Standardized error display components:

```tsx
// components/ui/error-display.tsx
import { AlertCircle } from 'lucide-react';
import { Button } from '@/components/ui/button';

interface ErrorDisplayProps {
  title?: string;
  message: string;
  error?: Error;
  showDetails?: boolean;
  onRetry?: () => void;
}

export function ErrorDisplay({
  title = 'Error',
  message,
  error,
  showDetails = false,
  onRetry,
}: ErrorDisplayProps) {
  return (
    <div className="rounded-md bg-red-50 p-4 border border-red-200">
      <div className="flex">
        <div className="flex-shrink-0">
          <AlertCircle className="h-5 w-5 text-red-400" />
        </div>
        <div className="ml-3">
          <h3 className="text-sm font-medium text-red-800">{title}</h3>
          <div className="mt-2 text-sm text-red-700">
            <p>{message}</p>
          </div>
          
          {showDetails && error && (
            <div className="mt-2">
              <details className="text-xs">
                <summary className="cursor-pointer text-red-800 hover:text-red-900">
                  Show technical details
                </summary>
                <pre className="mt-2 whitespace-pre-wrap bg-white p-2 rounded border border-red-200">
                  {error.toString()}
                </pre>
              </details>
            </div>
          )}
          
          {onRetry && (
            <div className="mt-4">
              <Button
                variant="destructive"
                size="sm"
                onClick={onRetry}
              >
                Try Again
              </Button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
```

## Notifications

### Toast Notifications

Toast notification system for user feedback:

```tsx
// components/ui/toast.tsx
import * as React from 'react';
import { cn } from '@/lib/utils';
import { Check, X, AlertCircle, Info } from 'lucide-react';

// Toast context
interface ToastContextType {
  toasts: Toast[];
  addToast: (toast: Omit<Toast, 'id'>) => void;
  removeToast: (id: string) => void;
}

interface Toast {
  id: string;
  type: 'success' | 'error' | 'info' | 'warning';
  title: string;
  message?: string;
  duration?: number; // milliseconds
}

const ToastContext = React.createContext<ToastContextType | undefined>(undefined);

// Toast provider
export function ToastProvider({ children }: { children: React.ReactNode }) {
  const [toasts, setToasts] = React.useState<Toast[]>([]);
  
  const addToast = React.useCallback((toast: Omit<Toast, 'id'>) => {
    const id = Date.now().toString();
    const newToast = { ...toast, id };
    
    setToasts((prevToasts) => [...prevToasts, newToast]);
    
    if (toast.duration !== 0) {
      const duration = toast.duration || 5000; // Default 5 seconds
      setTimeout(() => {
        removeToast(id);
      }, duration);
    }
  }, []);
  
  const removeToast = React.useCallback((id: string) => {
    setToasts((prevToasts) => prevToasts.filter((toast) => toast.id !== id));
  }, []);
  
  return (
    <ToastContext.Provider value={{ toasts, addToast, removeToast }}>
      {children}
      <ToastContainer />
    </ToastContext.Provider>
  );
}

// Custom hook for using toasts
export function useToast() {
  const context = React.useContext(ToastContext);
  
  if (context === undefined) {
    throw new Error('useToast must be used within a ToastProvider');
  }
  
  return context;
}

// Toast component
function ToastComponent({ toast, onClose }: { toast: Toast; onClose: () => void }) {
  const { type, title, message } = toast;
  
  const icons = {
    success: <Check className="h-5 w-5 text-green-500" />,
    error: <AlertCircle className="h-5 w-5 text-red-500" />,
    warning: <AlertCircle className="h-5 w-5 text-yellow-500" />,
    info: <Info className="h-5 w-5 text-blue-500" />,
  };
  
  const colorClasses = {
    success: 'border-green-200 bg-green-50',
    error: 'border-red-200 bg-red-50',
    warning: 'border-yellow-200 bg-yellow-50',
    info: 'border-blue-200 bg-blue-50',
  };
  
  return (
    <div
      className={cn(
        'flex w-full max-w-sm overflow-hidden rounded-lg border shadow-lg',
        colorClasses[type]
      )}
    >
      <div className="flex items-center p-4">
        <div className="flex-shrink-0">{icons[type]}</div>
        <div className="ml-3 flex-1">
          <p className="text-sm font-medium">{title}</p>
          {message && <p className="mt-1 text-sm opacity-90">{message}</p>}
        </div>
        <button
          type="button"
          className="ml-4 flex-shrink-0 rounded text-gray-400 hover:text-gray-700 focus:outline-none"
          onClick={onClose}
        >
          <X className="h-5 w-5" />
        </button>
      </div>
    </div>
  );
}

// Toast container (renders all active toasts)
function ToastContainer() {
  const { toasts, removeToast } = useToast();
  
  return (
    <div className="fixed bottom-0 right-0 z-50 p-4 sm:p-6 md:max-w-md space-y-4">
      {toasts.map((toast) => (
        <div
          key={toast.id}
          className="transform transition-all duration-300 ease-in-out"
        >
          <ToastComponent toast={toast} onClose={() => removeToast(toast.id)} />
        </div>
      ))}
    </div>
  );
}
```

## Performance Optimization

### Memoization

Using memo and callback for performance:

```tsx
import { memo, useCallback } from 'react';

interface TrackItemProps {
  id: number;
  title: string;
  artist: string;
  streams: number;
  onSelect: (id: number) => void;
}

const TrackItem = memo(({ id, title, artist, streams, onSelect }: TrackItemProps) => {
  const handleClick = useCallback(() => {
    onSelect(id);
  }, [id, onSelect]);
  
  return (
    <div 
      className="p-4 border rounded-lg hover:bg-slate-50 cursor-pointer"
      onClick={handleClick}
    >
      <h3 className="font-medium">{title}</h3>
      <p className="text-sm text-gray-500">{artist}</p>
      <p className="text-sm mt-2">{streams.toLocaleString()} streams</p>
    </div>
  );
});
TrackItem.displayName = 'TrackItem';

export default TrackItem;
```

### Virtualized Lists

Efficiently rendering large lists:

```tsx
import { useVirtualizer } from '@tanstack/react-virtual';
import { useRef } from 'react';

interface VirtualListProps<T> {
  items: T[];
  renderItem: (item: T, index: number) => React.ReactNode;
  itemHeight: number;
  height: number;
  width: '100%' | number;
}

export function VirtualList<T>({
  items,
  renderItem,
  itemHeight,
  height,
  width = '100%',
}: VirtualListProps<T>) {
  const parentRef = useRef<HTMLDivElement>(null);
  
  const virtualizer = useVirtualizer({
    count: items.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => itemHeight,
  });
  
  return (
    <div
      ref={parentRef}
      style={{
        height,
        width,
        overflow: 'auto',
      }}
    >
      <div
        style={{
          height: `${virtualizer.getTotalSize()}px`,
          position: 'relative',
        }}
      >
        {virtualizer.getVirtualItems().map((virtualItem) => (
          <div
            key={virtualItem.key}
            style={{
              position: 'absolute',
              top: 0,
              left: 0,
              width: '100%',
              height: `${itemHeight}px`,
              transform: `translateY(${virtualItem.start}px)`,
            }}
          >
            {renderItem(items[virtualItem.index], virtualItem.index)}
          </div>
        ))}
      </div>
    </div>
  );
}

// Usage
function TrackListVirtualized({ tracks }) {
  return (
    <VirtualList
      items={tracks}
      height={500}
      itemHeight={80}
      renderItem={(track) => (
        <div className="p-4 border-b">
          <h3>{track.title}</h3>
          <p>{track.artist}</p>
        </div>
      )}
    />
  );
}
```

### Lazy Loading

Lazy loading components for better initial load time:

```tsx
import { lazy, Suspense } from 'react';
import { Route, Switch } from 'wouter';
import { LoadingSpinner } from '@/components/ui/loading-spinner';

// Lazy load pages
const Dashboard = lazy(() => import('@/pages/Dashboard'));
const Tracks = lazy(() => import('@/pages/Tracks'));
const TrackDetail = lazy(() => import('@/pages/TrackDetail'));
const Releases = lazy(() => import('@/pages/Releases'));
const ReleaseDetail = lazy(() => import('@/pages/ReleaseDetail'));
const Analytics = lazy(() => import('@/pages/Analytics'));
const Settings = lazy(() => import('@/pages/Settings'));

function AppRoutes() {
  return (
    <Suspense fallback={<LoadingSpinner />}>
      <Switch>
        <Route path="/" component={Dashboard} />
        <Route path="/tracks" component={Tracks} />
        <Route path="/tracks/:id" component={TrackDetail} />
        <Route path="/releases" component={Releases} />
        <Route path="/releases/:id" component={ReleaseDetail} />
        <Route path="/analytics" component={Analytics} />
        <Route path="/settings" component={Settings} />
        <Route component={NotFound} />
      </Switch>
    </Suspense>
  );
}
```

## Accessibility

### Focus Management

Proper focus management for accessibility:

```tsx
import { useEffect, useRef } from 'react';

interface FocusTrapProps {
  children: React.ReactNode;
  isActive: boolean;
  onEscape?: () => void;
}

export function FocusTrap({ children, isActive, onEscape }: FocusTrapProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const previousFocusRef = useRef<HTMLElement | null>(null);
  
  // Save previous focus when trap activates
  useEffect(() => {
    if (isActive) {
      previousFocusRef.current = document.activeElement as HTMLElement;
    }
  }, [isActive]);
  
  // Restore focus when trap deactivates
  useEffect(() => {
    if (!isActive && previousFocusRef.current) {
      previousFocusRef.current.focus();
    }
    
    return () => {
      if (previousFocusRef.current) {
        previousFocusRef.current.focus();
      }
    };
  }, [isActive]);
  
  // Focus first focusable element when trap activates
  useEffect(() => {
    if (isActive && containerRef.current) {
      const focusableElements = containerRef.current.querySelectorAll(
        'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
      );
      
      if (focusableElements.length > 0) {
        (focusableElements[0] as HTMLElement).focus();
      }
    }
  }, [isActive]);
  
  // Handle key events (escape and tab trap)
  useEffect(() => {
    if (!isActive) return;
    
    const handleKeyDown = (event: KeyboardEvent) => {
      // Handle escape
      if (event.key === 'Escape' && onEscape) {
        onEscape();
        return;
      }
      
      // Handle tab trap
      if (event.key === 'Tab' && containerRef.current) {
        const focusableElements = Array.from(
          containerRef.current.querySelectorAll(
            'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
          )
        ) as HTMLElement[];
        
        if (focusableElements.length === 0) return;
        
        const firstElement = focusableElements[0];
        const lastElement = focusableElements[focusableElements.length - 1];
        
        // If shift+tab on first element, move to last element
        if (event.shiftKey && document.activeElement === firstElement) {
          lastElement.focus();
          event.preventDefault();
        } 
        // If tab on last element, move to first element
        else if (!event.shiftKey && document.activeElement === lastElement) {
          firstElement.focus();
          event.preventDefault();
        }
      }
    };
    
    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [isActive, onEscape]);
  
  return <div ref={containerRef}>{children}</div>;
}
```

### ARIA Support

Components with proper ARIA attributes:

```tsx
import { useState, useId } from 'react';

interface ExpandableSectionProps {
  title: string;
  children: React.ReactNode;
  defaultExpanded?: boolean;
}

export function ExpandableSection({
  title,
  children,
  defaultExpanded = false,
}: ExpandableSectionProps) {
  const [expanded, setExpanded] = useState(defaultExpanded);
  const id = useId();
  const contentId = `content-${id}`;
  const headerId = `header-${id}`;
  
  return (
    <div className="border rounded-lg overflow-hidden">
      <h3>
        <button
          id={headerId}
          aria-expanded={expanded}
          aria-controls={contentId}
          className="flex justify-between items-center w-full px-4 py-3 bg-slate-50 hover:bg-slate-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          onClick={() => setExpanded(!expanded)}
        >
          <span className="font-medium">{title}</span>
          <svg
            className={`w-5 h-5 transform transition-transform ${
              expanded ? 'rotate-180' : ''
            }`}
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={2}
              d="M19 9l-7 7-7-7"
            />
          </svg>
        </button>
      </h3>
      <div
        id={contentId}
        role="region"
        aria-labelledby={headerId}
        className={`transition-all duration-300 ease-in-out overflow-hidden ${
          expanded ? 'max-h-96' : 'max-h-0'
        }`}
      >
        <div className="p-4">{children}</div>
      </div>
    </div>
  );
}
```

## Testing

### Component Testing

Testing components with React Testing Library:

```tsx
// TrackList.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { TrackList } from './TrackList';

// Mock API responses
jest.mock('@/lib/queryClient', () => ({
  apiRequest: jest.fn().mockImplementation(() => {
    return Promise.resolve([
      { id: 1, title: 'Track 1', artist: 'Artist 1', streams: 1000 },
      { id: 2, title: 'Track 2', artist: 'Artist 2', streams: 2000 },
    ]);
  }),
  queryClient: new QueryClient(),
}));

describe('TrackList', () => {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: {
        retry: false,
      },
    },
  });
  
  const renderComponent = (props = {}) => {
    return render(
      <QueryClientProvider client={queryClient}>
        <TrackList userId={1} {...props} />
      </QueryClientProvider>
    );
  };
  
  beforeEach(() => {
    queryClient.clear();
  });
  
  it('renders loading state initially', () => {
    renderComponent();
    expect(screen.getByText(/loading/i)).toBeInTheDocument();
  });
  
  it('renders track list when data is loaded', async () => {
    renderComponent();
    
    // Wait for data to load
    const track1 = await screen.findByText('Track 1');
    const track2 = await screen.findByText('Track 2');
    
    expect(track1).toBeInTheDocument();
    expect(track2).toBeInTheDocument();
  });
  
  it('calls onTrackSelect when a track is clicked', async () => {
    const onTrackSelect = jest.fn();
    renderComponent({ onTrackSelect });
    
    // Wait for data to load
    const viewButtons = await screen.findAllByText('View Details');
    expect(viewButtons).toHaveLength(2);
    
    // Click the first view button
    fireEvent.click(viewButtons[0]);
    
    // Check if the callback was called with the correct ID
    expect(onTrackSelect).toHaveBeenCalledWith(1);
  });
});
```

### Hook Testing

Testing custom hooks:

```tsx
// useUserTracks.test.ts
import { renderHook, waitFor } from '@testing-library/react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useUserTracks } from './useUserTracks';

// Mock API responses
jest.mock('@/lib/queryClient', () => ({
  apiRequest: jest.fn().mockImplementation(() => {
    return Promise.resolve([
      { id: 1, title: 'Track 1', artist: 'Artist 1' },
      { id: 2, title: 'Track 2', artist: 'Artist 2' },
    ]);
  }),
}));

describe('useUserTracks', () => {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: {
        retry: false,
      },
    },
  });
  
  const wrapper = ({ children }) => (
    <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
  );
  
  beforeEach(() => {
    queryClient.clear();
  });
  
  it('returns user tracks data when successful', async () => {
    const { result } = renderHook(() => useUserTracks(1), { wrapper });
    
    // Initial state should be loading
    expect(result.current.isLoading).toBe(true);
    expect(result.current.data).toBeUndefined();
    
    // Wait for data to be loaded
    await waitFor(() => expect(result.current.isLoading).toBe(false));
    
    // Check loaded data
    expect(result.current.data).toHaveLength(2);
    expect(result.current.data[0].title).toBe('Track 1');
    expect(result.current.data[1].title).toBe('Track 2');
  });
});
```

## Deployment

### Bundle Optimization

Optimizing the application bundle:

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
      '@shared': path.resolve(__dirname, '../shared'),
    },
  },
  build: {
    target: 'es2015',
    minify: 'terser',
    cssMinify: true,
    rollupOptions: {
      output: {
        manualChunks: {
          react: ['react', 'react-dom'],
          tanstack: ['@tanstack/react-query'],
          charts: ['recharts', 'react-chartjs-2'],
        },
      },
    },
    chunkSizeWarningLimit: 1000,
  },
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:5000',
        changeOrigin: true,
      },
    },
  },
});
```

### Environment Configuration

Managing environment-specific configuration:

```typescript
// lib/config.ts
interface AppConfig {
  apiUrl: string;
  environment: 'development' | 'production' | 'test';
  features: {
    analytics: boolean;
    distributionService: boolean;
    aiTagging: boolean;
  };
}

export const config: AppConfig = {
  apiUrl: import.meta.env.VITE_API_URL || '',
  environment: (import.meta.env.MODE as 'development' | 'production' | 'test') || 'development',
  features: {
    analytics: import.meta.env.VITE_FEATURE_ANALYTICS === 'true',
    distributionService: import.meta.env.VITE_FEATURE_DISTRIBUTION === 'true',
    aiTagging: import.meta.env.VITE_FEATURE_AI_TAGGING === 'true',
  },
};
```

## Conclusion

TuneMantra's frontend architecture provides a powerful, flexible foundation for a complex music rights management platform. By leveraging modern React patterns, TypeScript, and a component-based approach, the frontend delivers a responsive, accessible, and maintainable user interface.

The architecture emphasizes:

1. **Type Safety**: TypeScript throughout the codebase ensures robust type checking
2. **Component Reusability**: Well-designed components that can be composed for complex interfaces
3. **State Management**: Efficient state management with React Query for server state
4. **Performance**: Optimizations like virtualization, memoization, and lazy loading
5. **Accessibility**: ARIA compliance and keyboard navigation support
6. **Responsiveness**: Mobile-first design that works on all device sizes

This architecture enables developers to efficiently build and maintain the TuneMantra platform while providing users with a robust, intuitive interface for managing their music rights and royalties.