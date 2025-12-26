# Troubleshooting Guide

## Issue: No Network Calls Visible in Chrome DevTools

### Step 1: Verify Mock Server is Running

1. Open a terminal and check if the mock server is running:
   ```bash
   cd mock_server
   dart run mock_server.dart
   ```

2. You should see:
   ```
   🚀 Mock Server running on http://0.0.0.0:8080
   ```

3. Test the server directly in your browser:
   - Open: `http://localhost:8080/api/v1/products`
   - You should see JSON data

### Step 2: Check Flutter App Console

1. Open Chrome DevTools (F12)
2. Go to the **Console** tab
3. Look for these messages:
   - `🌐 API Client initialized with baseUrl: http://localhost:8080`
   - `📦 ProductProvider: Loading products...`
   - `✅ ProductProvider: Received X products`

### Step 3: Check Network Tab

1. Open Chrome DevTools (F12)
2. Go to the **Network** tab
3. Filter by "XHR" or "Fetch"
4. Look for requests to `http://localhost:8080/api/v1/products`
5. If you see requests but they're failing:
   - Check the status code (should be 200)
   - Check for CORS errors (red text in console)

### Step 4: Common Issues

#### Issue: "Connection refused" or "Failed to fetch"
**Solution**: Make sure the mock server is running on port 8080

#### Issue: CORS Error
**Solution**: The mock server already has CORS headers. If you still see CORS errors:
1. Make sure the mock server is running
2. Check that the server is binding to `0.0.0.0` (not just `localhost`)
3. Try restarting both the server and the Flutter app

#### Issue: No requests in Network tab
**Solution**: 
1. Check the Flutter console for errors
2. Verify `useMockServer = true` in `lib/core/config/env.dart`
3. Hot restart the app (not just hot reload)

#### Issue: Requests show but return errors
**Solution**:
1. Check the server terminal for errors
2. Verify the JSON files exist in `mock_server/data/`
3. Check the response in Network tab → Response tab

### Step 5: Debug Steps

1. **Verify Configuration**:
   ```dart
   // In lib/core/config/env.dart
   static const bool useMockServer = true;  // Should be true
   ```

2. **Check Base URL**:
   - Look for the console log: `🌐 API Client initialized with baseUrl: ...`
   - For web, it should be: `http://localhost:8080`

3. **Test Server Directly**:
   ```bash
   curl http://localhost:8080/api/v1/products
   ```
   Or open in browser: `http://localhost:8080/api/v1/products`

4. **Check Flutter Logs**:
   - Look for Dio request logs in the console
   - Check for any error messages

### Step 6: Manual Test

1. Open Chrome DevTools → Console
2. Type this to test the API:
   ```javascript
   fetch('http://localhost:8080/api/v1/products')
     .then(r => r.json())
     .then(console.log)
     .catch(console.error)
   ```
   This should return the product list JSON

### Still Not Working?

1. **Restart Everything**:
   - Stop the mock server (Ctrl+C)
   - Stop the Flutter app
   - Start mock server again
   - Start Flutter app again

2. **Check Port Conflicts**:
   - Make sure nothing else is using port 8080
   - Change port in `env.dart` and `mock_server.dart` if needed

3. **Clear Browser Cache**:
   - Hard refresh: Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)

4. **Check Firewall**:
   - Make sure your firewall isn't blocking port 8080

