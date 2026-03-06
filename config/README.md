# Configuration Directory

This directory contains application configuration files and API key management.

## Structure

```
config/
├── secrets/              ⚠️ GIT-IGNORED - Store real API keys here
│   ├── README.md        📖 Instructions for using secrets
│   ├── .env             ❌ Not committed - Your environment variables
│   ├── api_keys.dart    ❌ Not committed - Your API keys
│   └── secrets.json     ❌ Not committed - Your JSON config
│
└── secrets.example/      ✅ COMMITTED - Template files
    ├── api_keys.dart    📄 Template Dart file
    ├── .env.example     📄 Template environment file
    └── secrets.json     📄 Template JSON file
```

## Quick Start

### 1. Create Your Secrets File

Choose your preferred format:

**Option A: Dart File (Recommended for Flutter)**
```bash
cp config/secrets.example/api_keys.dart config/secrets/api_keys.dart
# Edit config/secrets/api_keys.dart with your real API keys
```

**Option B: Environment Variables**
```bash
cp config/secrets.example/.env.example config/secrets/.env
# Edit config/secrets/.env with your real values
```

**Option C: JSON Configuration**
```bash
cp config/secrets.example/secrets.json config/secrets/secrets.json
# Edit config/secrets/secrets.json with your real values
```

### 2. Add Your API Keys

Edit the file you created and replace all `YOUR_*` placeholders with actual values.

### 3. Use in Your App

**For Dart file:**
```dart
import 'package:local_point_tt/config/secrets/api_keys.dart';

final apiKey = ApiKeys.googleMapsApiKey;
```

**For .env file:**
Use a package like `flutter_dotenv`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
```

**For JSON file:**
Load and parse the JSON file at runtime.

## Security Features

✅ **Automatic Git Ignore**
- All files in `config/secrets/` are automatically ignored
- Your API keys will never be committed

✅ **Template Files**
- `config/secrets.example/` contains safe template files
- These ARE committed to help team members set up their own keys

✅ **Multiple Format Support**
- Dart constants (compile-time)
- Environment variables (runtime)
- JSON configuration (runtime)

## Best Practices

1. **Never commit real API keys** - They belong in `config/secrets/`
2. **Update templates** - Keep `secrets.example/` files updated when adding new keys
3. **Document requirements** - List required API keys in project README
4. **Use different keys per environment** - Development vs Production
5. **Rotate keys regularly** - Change API keys periodically

## Team Collaboration

When a new developer joins:

1. They clone the repository (secrets/ folder is empty)
2. They copy template files from `secrets.example/` to `secrets/`
3. They add their own API keys
4. They can start developing immediately

No sensitive information is ever shared through git!

---

**Need Help?** See `config/secrets/README.md` for detailed instructions.
