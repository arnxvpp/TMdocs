# TuneMantra - Project Dependencies Documentation

This document provides a comprehensive overview of all dependencies used in the TuneMantra project. Dependencies are categorized by their purpose to make it easier to understand the project's technical stack.

## Table of Contents
- [Core Dependencies](#core-dependencies)
- [UI and Component Libraries](#ui-and-component-libraries)
- [State Management](#state-management)
- [Data Handling and Validation](#data-handling-and-validation)
- [Authentication and Security](#authentication-and-security)
- [Database and ORM](#database-and-orm)
- [File Processing](#file-processing)
- [API and Network](#api-and-network)
- [Blockchain Integration](#blockchain-integration)
- [Date and Time](#date-and-time)
- [Build Tools and Development](#build-tools-and-development)
- [TypeScript Types](#typescript-types)

## Core Dependencies

### Runtime and Framework
- **express**: ^4.21.2 - Web server framework for Node.js
- **react**: ^18.3.1 - JavaScript library for building user interfaces
- **react-dom**: ^18.3.1 - React package for working with the DOM
- **node-fetch**: ^3.3.2 - Lightweight module that brings the Fetch API to Node.js

### JavaScript Utilities
- **uuid**: ^11.1.0 - For generating unique identifiers
- **dotenv**: ^16.4.7 - Loads environment variables from .env file
- **glob**: ^11.0.1 - File pattern matching utility
- **colors**: ^1.4.0 - For styling terminal text
- **@babel/helpers**: ^7.27.0 - Babel's helper functions
- **@babel/runtime**: ^7.27.0 - Babel runtime support
- **@esbuild-kit/core-utils**: ^3.3.2 - Core utilities for esbuild
- **@esbuild-kit/esm-loader**: ^2.6.5 - ESM loader for esbuild
- **@jridgewell/trace-mapping**: ^0.3.25 - Source map tracing utility

## UI and Component Libraries

### Component Libraries
- **@radix-ui/react-*****: Various versions - Unstyled, accessible UI components
- **primereact**: ^10.9.2 - UI component library for React
- **primeicons**: ^7.0.0 - Icon pack for PrimeReact

### UI Styling and Animation
- **tailwindcss**: ^3.4.14 - Utility-first CSS framework
- **tailwind-merge**: ^2.6.0 - Utility for merging Tailwind CSS classes
- **tailwindcss-animate**: ^1.0.7 - Animation utilities for Tailwind
- **class-variance-authority**: ^0.7.0 - For creating variant styles
- **clsx**: ^2.1.1 - Utility for constructing className strings
- **lucide-react**: ^0.453.0 - Icon set for React
- **react-icons**: ^5.4.0 - Popular icons for React projects
- **framer-motion**: ^11.18.2 - Animation library for React
- **cmdk**: ^1.0.0 - Command menu component
- **input-otp**: ^1.2.4 - One-time password input
- **vaul**: ^1.1.0 - React drawer component

### UI Patterns and Layouts
- **react-resizable-panels**: ^2.1.4 - Resizable panel layouts
- **embla-carousel-react**: ^8.3.0 - Carousel/slider component

### Routing and Navigation
- **wouter**: ^3.3.5 - Tiny router for React and Preact
- **react-router-dom**: ^7.2.0 - Declarative routing for React

## State Management

- **react-hook-form**: ^7.53.1 - Forms state management for React
- **@hookform/resolvers**: ^3.9.1 - Resolvers for react-hook-form
- **@tanstack/react-query**: ^5.60.5 - Data fetching and caching library

## Data Handling and Validation

### Validation and Type Checking
- **zod**: ^3.23.8 - TypeScript-first schema validation with static type inference
- **zod-validation-error**: ^3.4.0 - Better validation errors for Zod

### Data Visualization
- **chart.js**: ^4.4.8 - JavaScript charting library
- **react-chartjs-2**: ^5.3.0 - React wrapper for Chart.js
- **recharts**: ^2.15.1 - Redefined chart library built with React

### Date and Formatting
- **date-fns**: ^3.6.0 - Modern JavaScript date utility library
- **react-day-picker**: ^8.10.1 - Flexible date picker for React

### Content Processing
- **react-markdown**: ^10.1.0 - Markdown component for React
- **xss**: ^1.0.15 - Sanitize untrusted HTML to prevent XSS attacks

## Authentication and Security

- **bcrypt**: ^5.1.1 - Library to help hash passwords
- **jsonwebtoken**: ^9.0.2 - JSON Web Token implementation
- **passport**: ^0.7.0 - Authentication middleware for Node.js
- **passport-local**: ^1.0.0 - Username and password authentication for Passport
- **helmet**: ^8.1.0 - Helps secure Express apps with various HTTP headers
- **express-rate-limit**: ^7.5.0 - Rate limiting middleware for Express
- **express-session**: ^1.18.1 - Session middleware for Express
- **cookie-parser**: ^1.4.7 - Parse Cookie header and populate req.cookies
- **connect-pg-simple**: ^10.0.0 - PostgreSQL session store for Express
- **memorystore**: ^1.6.7 - Memory session store for Express

## Database and ORM

- **drizzle-orm**: ^0.39.1 - TypeScript ORM for SQL databases
- **drizzle-zod**: ^0.7.0 - Zod schemas for Drizzle ORM
- **@neondatabase/serverless**: ^0.10.4 - Serverless PostgreSQL client
- **pg**: ^8.14.1 - PostgreSQL client for Node.js

## File Processing

### Excel and CSV Handling
- **exceljs**: ^4.4.0 - Excel workbook manager
- **csv-parser**: ^3.2.0 - CSV parser
- **papaparse**: ^5.5.2 - Fast CSV parser for the browser and Node.js

### File Upload and Processing
- **multer**: ^1.4.5-lts.1 - Middleware for handling multipart/form-data
- **xml2js**: ^0.6.2 - XML to JavaScript object converter

## API and Network

- **axios**: ^1.8.4 - Promise-based HTTP client
- **ws**: ^8.18.0 - WebSockets implementation
- **@fastify/swagger**: ^9.4.2 - Swagger documentation generator
- **@fastify/swagger-ui**: ^5.2.2 - Swagger UI integration
- **openai**: ^4.85.3 - Official OpenAI API client

## Blockchain Integration

- **ethers**: ^6.13.5 - Ethereum wallet implementation and utilities
- **razorpay**: ^2.9.6 - Payment gateway integration

## Build Tools and Development

### Build and Bundling
- **vite**: ^6.2.4 - Next-generation frontend build tool
- **esbuild**: ^0.25.2 - JavaScript bundler and minifier
- **postcss**: ^8.4.47 - Tool for transforming CSS with JavaScript
- **autoprefixer**: ^10.4.20 - PostCSS plugin to parse CSS and add vendor prefixes
- **@vitejs/plugin-react**: ^4.3.4 - React plugin for Vite

### TypeScript Execution
- **typescript**: 5.6.3 - TypeScript language
- **tsx**: ^4.19.3 - TypeScript execution environment

### Development Tools
- **drizzle-kit**: ^0.19.13 - CLI for Drizzle ORM
- **@replit/vite-plugin-cartographer**: ^0.0.2 - Replit's source map plugin for Vite
- **@replit/vite-plugin-runtime-error-modal**: ^0.0.3 - Error modal plugin for Vite
- **@replit/vite-plugin-shadcn-theme-json**: ^0.0.4 - Theme support for shadcn/ui
- **@tailwindcss/typography**: ^0.5.15 - Typography plugin for Tailwind CSS

## TypeScript Types

- **@types/node**: 20.16.11 - TypeScript definitions for Node.js
- **@types/react**: ^18.3.11 - TypeScript definitions for React
- **@types/react-dom**: ^18.3.1 - TypeScript definitions for React DOM
- **@types/express**: 4.17.21 - TypeScript definitions for Express
- **@types/bcrypt**: ^5.0.2 - TypeScript definitions for bcrypt
- **@types/cookie-parser**: ^1.4.8 - TypeScript definitions for cookie-parser
- **@types/jsonwebtoken**: ^9.0.9 - TypeScript definitions for jsonwebtoken
- **@types/multer**: ^1.4.12 - TypeScript definitions for multer
- **@types/passport**: ^1.0.16 - TypeScript definitions for Passport
- **@types/passport-local**: ^1.0.38 - TypeScript definitions for passport-local
- **@types/express-session**: ^1.18.0 - TypeScript definitions for express-session
- **@types/connect-pg-simple**: ^7.0.3 - TypeScript definitions for connect-pg-simple
- **@types/ws**: ^8.5.13 - TypeScript definitions for ws
- **@types/papaparse**: ^5.3.15 - TypeScript definitions for papaparse
- **@types/xml2js**: ^0.4.14 - TypeScript definitions for xml2js

## Optional Dependencies

- **bufferutil**: ^4.0.8 - WebSocket data handling optimization