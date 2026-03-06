# API Keys Setup - Quick Reference

## ✅ What Was Created

### 1. Secure Folder Structure
```
config/
├── secrets/              ⚠️ GIT-IGNORED (your real API keys)
│   └── README.md         Instructions
└── secrets.example/      ✅ Version controlled (templates)
    ├── api_keys.dart     Template for Dart constants
    ├── .env.example      Template for environment variables
    └── secrets.json      Template for JSON config
```

### 2. Git Ignore Rules

Added to `.gitignore`:
```
# API Keys and Secrets (DO NOT COMMIT)
config/secrets/
*.env
.env
.env.*
!.env.example
api_keys.dart
secrets.dart
firebase_config.json
serviceAccountKey.json
```

## 🚀 Quick Start (3 Steps)

### Step 1: Copy Template
```bash
# Choose one format:

# Option A: Dart file (recommended)
cp config/secrets.example/api_keys.dart config/secrets/api_keys.dart

# Option B: Environment variables
cp config/secrets.example/.env.example config/secrets/.env

# Option C: JSON configuration
cp config/secrets.example/secrets.json config/secrets/secrets.json
```

### Step 2: Add Your Keys

Open the file and replace placeholders:
- `YOUR_GOOGLE_MAPS_API_KEY` → Your actual Google Maps key
- `YOUR_FIREBASE_API_KEY` → Your actual Firebase key
- etc.

### Step 3: Use in Your App

**For Dart file:**
```dart
import 'package:local_point_tt/config/secrets/api_keys.dart';

final apiKey = ApiKeys.googleMapsApiKey;
```

**For .env file:**
```dart
// Add to pubspec.yaml:
// flutter_dotenv: ^5.1.0

import 'package:flutter_dotenv/flutter_dotenv.dart';

await dotenv.load(fileName: "config/secrets/.env");
final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
```

## 📋 Common API Keys You Might Need

- **Google Maps** - For location services
- **Firebase** - Authentication, database, storage
- **Stripe** - Payment processing
- **Twilio** - SMS services
- **Firebase Cloud Messaging** - Push notifications
- **Analytics** - Mixpanel, Google Analytics
- **Social OAuth** - Facebook, Google sign-in

## 🔒 Security Checklist

- ✅ `config/secrets/` folder is git-ignored
- ✅ Real API keys never committed
- ✅ Template files are version controlled
- ✅ Team members can easily set up their own keys
- ✅ Different keys for dev/staging/production

## 📚 Documentation

- **Main Guide**: [config/README.md](config/README.md)
- **Detailed Instructions**: [config/secrets/README.md](config/secrets/README.md)
- **Project README**: [README.md](README.md#api-keys--secrets-management)

## 🆘 Troubleshooting

**"Can't find api_keys.dart"**
- Make sure you copied the template to `config/secrets/`
- Check that the file has a `.dart` extension

**"API key not working"**
- Verify you replaced ALL `YOUR_*` placeholders
- Check for extra spaces or quotes
- Ensure the correct environment (dev/prod)

**"Accidentally committed API keys"**
If you committed keys by mistake:
1. Immediately rotate (change) all exposed keys
2. Remove from git history: `git filter-branch` or `git filter-repo`
3. Force push: `git push --force`

---

**Remember**: Never commit real API keys! They belong in `config/secrets/` only.
