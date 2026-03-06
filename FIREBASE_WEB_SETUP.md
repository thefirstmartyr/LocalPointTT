# Firebase Web Configuration Guide

> ✅ **STATUS: COMPLETED** - Firebase SDK scripts have been added to web/index.html
> 
> **For Testing**: See [test/README.md](test/README.md) for comprehensive testing guide

## Quick Setup for Web

~~Your app is configured for Android, but needs additional setup for web.~~ **DONE**

## Steps to Configure Firebase for Web

### 1. Get Your Firebase Web Configuration

1. Go to **[Firebase Console](https://console.firebase.google.com)**
2. Click on your **Local Point TT** project
3. Click the **gear icon** (⚙️) → **Project Settings**
4. Scroll down to **"Your apps"** section
5. If you see a web app already:
   - Click on the web app
   - Copy the configuration
6. If you DON'T see a web app:
   - Click **"Add app"** 
   - Select **Web** (`</>` icon)
   - App nickname: `Local Point TT Web`
   - Check **"Also set up Firebase Hosting"** (optional)
   - Click **"Register app"**
   - Copy the `firebaseConfig` object

### 2. Update web/index.html

The config looks like this:
```javascript
const firebaseConfig = {
  apiKey: "AIzaSyC...",
  authDomain: "local-point-tt.firebaseapp.com",
  projectId: "local-point-tt",
  storageBucket: "local-point-tt.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef123456"
};
```

**Replace the placeholders in `web/index.html`** (lines 36-42) with your actual values:
- Replace `YOUR_API_KEY` with your `apiKey`
- Replace `YOUR_PROJECT_ID` with your `projectId`
- Replace `YOUR_MESSAGING_SENDER_ID` with your `messagingSenderId`
- Replace `YOUR_APP_ID` with your `appId`

### 3. Launch on Web

After updating the config:

```bash
flutter run -d chrome
```

## Alternative: Test on Android Instead

If you want to skip web setup for now, you can test on Android emulator or device:

```bash
# List available devices
flutter devices

# Run on Android
flutter run -d <android-device-id>
```

## Example Configuration

Here's what your `web/index.html` should look like after updating (example values):

```html
<script>
  const firebaseConfig = {
    apiKey: "AIzaSyC_example123456789",
    authDomain: "local-point-tt.firebaseapp.com",
    projectId: "local-point-tt",
    storageBucket: "local-point-tt.appspot.com",
    messagingSenderId: "987654321012",
    appId: "1:987654321012:web:abc123def456"
  };

  firebase.initializeApp(firebaseConfig);
</script>
```

## Troubleshooting

### Error: "FirebaseOptions cannot be null"
- Make sure you replaced ALL placeholder values in `web/index.html`
- Check that quotes and commas are correct in the config object

### Error: "Firebase project not found"
- Verify your `projectId` matches your Firebase Console project
- Make sure the web app is registered in Firebase Console

### Error: "Invalid API key"
- Double-check you copied the full API key
- Make sure there are no extra spaces

## Current File Location

Edit this file: **`web/index.html`** (lines 36-42)

## Need Help?

If you see your `google-services.json` file in `android/app/`, I can help extract some values to make this easier. Let me know your Firebase project ID!
