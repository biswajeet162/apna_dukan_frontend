# Physical Device Setup Guide

When testing on a **physical Android device** (not emulator), you need to configure the IP address manually.

## Quick Setup

### Step 1: Find Your Computer's IP Address

**Windows:**
```bash
ipconfig
```
Look for "IPv4 Address" under your WiFi or Ethernet adapter (usually `192.168.x.x`)

**Mac/Linux:**
```bash
ifconfig
# or
ip addr
```
Look for `inet` address under `en0` or `wlan0` (usually `192.168.x.x`)

### Step 2: Update the Configuration

Edit `lib/core/config/env.dart`:

```dart
static const String? manualDeviceIp = '192.168.100.50'; // Replace with YOUR IP
```

**Important:** 
- Use only the IP address (no `http://`)
- Make sure your phone and computer are on the same WiFi network
- Use the IP from your WiFi adapter, not virtual adapters

### Step 3: Start the Mock Server

```bash
cd mock_server
dart run mock_server.dart
```

The server should show:
```
🚀 Mock Server running on http://0.0.0.0:8080
```

### Step 4: Test Connection

1. Make sure your phone and computer are on the **same WiFi network**
2. On your phone's browser, try: `http://YOUR_IP:8080/api/v1/products`
   - Example: `http://192.168.100.50:8080/api/v1/products`
   - You should see JSON data
3. If this works, the Flutter app will work too

### Step 5: Run Flutter App

```bash
flutter run
```

## Troubleshooting

### Issue: Still can't connect

1. **Check Firewall:**
   - Windows: Allow port 8080 in Windows Firewall
   - Mac: System Preferences → Security → Firewall → Allow incoming connections

2. **Verify Same Network:**
   - Phone and computer must be on the same WiFi
   - Check phone's WiFi settings

3. **Test from Phone Browser:**
   - Open Chrome on your phone
   - Go to: `http://YOUR_IP:8080/api/v1/products`
   - If this doesn't work, the Flutter app won't work either

4. **Check IP Address:**
   - Make sure you're using the WiFi adapter IP, not virtual adapter
   - Virtual adapters (like `192.168.56.1`) won't work

### Common IP Addresses

- WiFi adapter: Usually `192.168.1.x` or `192.168.0.x` or `192.168.100.x`
- Ethernet: Usually `192.168.1.x` or `10.0.0.x`
- **Avoid:** `127.0.0.1`, `localhost`, `192.168.56.x` (virtual adapters)

## Example Configuration

```dart
// In lib/core/config/env.dart
static const String? manualDeviceIp = '192.168.100.50'; // Your actual IP
```

After setting this, hot restart your Flutter app (not just hot reload).

