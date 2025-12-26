# Mock Server Setup Guide

This guide explains how to use the mock JSON server for testing the Apna Dukan Flutter app.

## Quick Start

### 1. Install Mock Server Dependencies

```bash
cd mock_server
dart pub get
cd ..
```

### 2. Start the Mock Server

**Windows:**
```bash
cd mock_server
dart run mock_server.dart
```

**Linux/Mac:**
```bash
cd mock_server
dart run mock_server.dart
```

Or use the convenience scripts:
- Windows: Double-click `mock_server/start_server.bat`
- Linux/Mac: Run `bash mock_server/start_server.sh`

The server will start on `http://localhost:8080`

### 3. Configure Flutter App

The app is already configured to use the mock server by default. The configuration automatically detects the platform:
- **Android Emulator**: Uses `http://10.0.2.2:8080` (automatically)
- **iOS Simulator**: Uses `http://localhost:8080` (automatically)
- **Web/Desktop**: Uses `http://localhost:8080` (automatically)

Check `lib/core/config/env.dart`:
```dart
static const bool useMockServer = true;  // Set to false for production API
```

### 4. Run Flutter App

In a separate terminal:
```bash
flutter run
```

## Switching Between Mock and Real API

Edit `lib/core/config/env.dart`:

```dart
// For mock server (development)
static const bool useMockServer = true;
// URL is automatically set based on platform (Android/iOS/Web)

// For production API
static const bool useMockServer = false;
static const String productionApiUrl = 'http://your-api-url.com';
```

**Note**: The mock server URL is automatically configured:
- Android emulator → `http://10.0.2.2:8080`
- iOS simulator → `http://localhost:8080`
- Web/Desktop → `http://localhost:8080`

## Available Mock Endpoints

All endpoints return data in the format:
```json
{
  "success": true,
  "message": "Success message",
  "data": { ... }
}
```

### Product APIs

1. **GET** `/api/v1/products?page=0&size=20&sort=createdAt,desc`
   - Returns: Paginated product list
   - Mock file: `mock_server/data/products_list.json`

2. **GET** `/api/v1/products/{id}`
   - Returns: Product details
   - Mock files: `mock_server/data/product_detail_{id}.json`

3. **GET** `/api/v1/products/category/{categoryId}?page=0&size=20`
   - Returns: Products by category
   - Mock file: `mock_server/data/products_category_{id}.json`

4. **GET** `/api/v1/products/search?keyword=wireless`
   - Returns: Search results
   - Mock file: `mock_server/data/products_search.json`

5. **GET** `/api/v1/products/filter?minPrice=500&maxPrice=2000&minRating=4.0`
   - Returns: Filtered products
   - Mock file: `mock_server/data/products_filter.json`

6. **POST** `/api/v1/products`
   - Body: ProductCreateRequestDto
   - Returns: Created product info
   - Mock file: `mock_server/data/product_create_success.json`

7. **PUT** `/api/v1/products/{id}`
   - Body: ProductUpdateRequestDto
   - Returns: Success message
   - Mock file: `mock_server/data/product_update_success.json`

8. **DELETE** `/api/v1/products/{id}`
   - Returns: Success message
   - Mock file: `mock_server/data/product_delete_success.json`

## Customizing Mock Data

Edit the JSON files in `mock_server/data/` directory to customize the responses. The server will serve the updated data immediately.

## Troubleshooting

### Port Already in Use

If port 8080 is already in use, change it:
```bash
PORT=3000 dart run mock_server/mock_server.dart
```

Then update `lib/core/config/env.dart`:
```dart
static const String mockServerUrl = 'http://localhost:3000';
```

### Connection Refused

The app automatically handles platform differences:
- **Android Emulator**: Uses `http://10.0.2.2:8080` (automatically configured)
- **iOS Simulator**: Uses `http://localhost:8080` (automatically configured)
- **Physical Device**: You may need to use your computer's IP address

If you still get connection refused:
1. Make sure the mock server is running
2. Check that the port (8080) matches in both server and app
3. For physical devices, find your computer's IP:
   - Windows: `ipconfig` (look for IPv4 Address)
   - Mac/Linux: `ifconfig` or `ip addr`
   - Then update `mockServerUrl` in `env.dart` to use your IP: `http://YOUR_IP:8080`
4. Make sure your firewall allows connections on port 8080

### CORS Issues

The mock server includes CORS headers, so this shouldn't be an issue. If you encounter CORS errors, check the server logs.

## Testing

Test the server with curl:
```bash
curl http://localhost:8080/api/v1/products
curl http://localhost:8080/api/v1/products/1
curl http://localhost:8080/health
```

## Production

Before deploying to production:
1. Set `useMockServer = false` in `env.dart`
2. Update `productionApiUrl` with your actual backend URL
3. Remove or ignore the `mock_server` directory

