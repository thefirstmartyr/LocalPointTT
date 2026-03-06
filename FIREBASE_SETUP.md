# Firebase Setup Guide - Local Point TT

> 📚 **Related Documentation**
> - **Testing Guide**: [test/README.md](test/README.md) - Comprehensive testing documentation
> - **Integration Guide**: [FIREBASE_INTEGRATION_GUIDE.md](FIREBASE_INTEGRATION_GUIDE.md) - How to use Firebase in code
> - **Web Setup**: [FIREBASE_WEB_SETUP.md](FIREBASE_WEB_SETUP.md) - Web-specific configuration (completed)

## Step 1: Create Firebase Project (Web Browser)

### 1.1 Go to Firebase Console
- Visit: https://console.firebase.google.com
- Sign in with your Google account

### 1.2 Create New Project
1. Click **"Add project"** or **"Create a project"**
2. **Project name:** `Local Point TT`
3. Click **Continue**
4. **Google Analytics:** Enable (recommended) or disable
5. Click **Create project**
6. Wait for project creation (30-60 seconds)
7. Click **Continue**

---

## Step 2: Add Android App to Firebase

### 2.1 Register Your App
1. In Firebase Console, click the **Android icon** (⚙️ Settings → Project settings)
2. Scroll down and click **"Add app"** → Select **Android**
3. Fill in the form:
   - **Android package name:** `com.localpointtt.app` ⚠️ MUST MATCH EXACTLY
   - **App nickname (optional):** `Local Point TT Android`
   - **Debug signing certificate SHA-1 (optional):** Leave blank for now
4. Click **Register app**

### 2.2 Download google-services.json
1. Click **Download google-services.json**
2. **IMPORTANT:** Save this file to:
   ```
   C:\Users\Christian.Felix\Desktop\trying flutter\Local Point TT\local_point_tt\android\app\google-services.json
   ```
3. Click **Next** (skip the Gradle steps, we've already configured them)
4. Click **Continue to console**

---

## Step 3: Enable Firestore Database

### 3.1 Create Firestore Database
1. In Firebase Console, click **"Build"** in left sidebar
2. Click **"Firestore Database"**
3. Click **"Create database"**

### 3.2 Security Rules
1. Select **"Start in test mode"** (for development)
   - ⚠️ WARNING: This allows read/write access for 30 days
   - We'll secure it properly later
2. Click **Next**

### 3.3 Cloud Firestore Location
1. Select a location close to Trinidad:
   - Recommended: **`us-central1`** (Iowa) - closest to Caribbean
   - Alternative: **`us-east1`** (South Carolina)
2. Click **Enable**
3. Wait for database creation

### 3.4 Create Collections Structure
Once database is ready, create these collections (click **"Start collection"**):

#### Collection: `users`
- **Document ID:** Auto-ID
- **Fields (example document):**
  ```
  email: string
  firstName: string
  lastName: string
  phone: string (optional)
  profileImageUrl: string (optional)
  createdAt: timestamp
  ```

#### Collection: `businesses`
- **Document ID:** Auto-ID
- **Fields:**
  ```
  name: string
  description: string
  category: string
  address: string
  phone: string
  logo: string (URL)
  ownerId: string
  isActive: boolean
  createdAt: timestamp
  ```

#### Collection: `loyalty_programs`
- **Document ID:** Auto-ID
- **Fields:**
  ```
  businessId: string
  name: string
  description: string
  pointsPerVisit: number
  pointsPerDollar: number
  isActive: boolean
  createdAt: timestamp
  ```

#### Collection: `user_programs`
- **Document ID:** Auto-ID
- **Fields:**
  ```
  userId: string
  programId: string
  businessId: string
  currentPoints: number
  totalPointsEarned: number
  enrolledAt: timestamp
  lastActivity: timestamp
  ```

#### Collection: `transactions`
- **Document ID:** Auto-ID
- **Fields:**
  ```
  userId: string
  businessId: string
  programId: string
  type: string (earn/redeem)
  points: number
  description: string
  timestamp: timestamp
  ```

#### Collection: `rewards`
- **Document ID:** Auto-ID
- **Fields:**
  ```
  programId: string
  name: string
  description: string
  pointsRequired: number
  isActive: boolean
  createdAt: timestamp
  ```

---

## Step 4: Enable Authentication

### 4.1 Enable Email/Password Authentication
1. In Firebase Console, click **"Build"** → **"Authentication"**
2. Click **"Get started"**
3. Click **"Sign-in method"** tab
4. Click **"Email/Password"**
5. Toggle **Enable** (first option only, not Email link)
6. Click **Save**

### 4.2 (Optional) Enable Google Sign-In
1. Click **"Google"** provider
2. Toggle **Enable**
3. Enter **Project support email** (your email)
4. Click **Save**

---

## Step 5: Enable Cloud Messaging (Notifications)

### 5.1 Enable Firebase Cloud Messaging
1. In Firebase Console, click **"Build"** → **"Cloud Messaging"**
2. Cloud Messaging is automatically enabled
3. Note: You'll need to configure notification channels later

---

## Step 6: Verify Your Setup

### Check these items:
- ✅ `google-services.json` is in `android/app/` folder
- ✅ Firestore Database is created with collections
- ✅ Email/Password authentication is enabled
- ✅ Test mode security rules are active

---

## Step 7: Test Sample Data (Optional)

### Add Test Business
Go to Firestore Database and manually add a test document:

**Collection:** `businesses`
**Document ID:** Auto-ID
**Fields:**
```
name: "Joe's Coffee Shop"
description: "Best coffee in Port of Spain"
category: "Food & Beverage"
address: "123 Main Street, Port of Spain"
phone: "+1868-555-0100"
logo: "https://via.placeholder.com/150"
ownerId: "test_owner_123"
isActive: true
createdAt: [Click "Set to current time"]
```

### Add Test Loyalty Program
**Collection:** `loyalty_programs`
**Document ID:** Auto-ID
**Fields:**
```
businessId: [Copy the ID of the business you just created]
name: "Coffee Rewards"
description: "Earn 1 point per visit, get free coffee at 10 points"
pointsPerVisit: 1
pointsPerDollar: 0
isActive: true
createdAt: [Click "Set to current time"]
```

---

## Step 8: Firebase Project IDs

After setup, note these important IDs:

- **Project ID:** Found in Project Settings → General
- **Web API Key:** Found in Project Settings → General
- **App ID:** Found in Project Settings → Your apps → Android app

You'll see these in your `google-services.json` file.

---

## Step 9: Security Rules (Production-Ready) - FOR LATER

Once testing is complete, update Firestore Security Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Anyone can read businesses
    match /businesses/{businessId} {
      allow read: if true;
      allow write: if request.auth != null; // Only authenticated users
    }
    
    // Anyone can read active loyalty programs
    match /loyalty_programs/{programId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Users can only read/write their own program enrollments
    match /user_programs/{userProgramId} {
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      allow write: if request.auth != null && 
                      request.resource.data.userId == request.auth.uid;
    }
    
    // Users can only read their own transactions
    match /transactions/{transactionId} {
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      allow create: if request.auth != null;
    }
    
    // Anyone can read active rewards
    match /rewards/{rewardId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

---

## ✅ Setup Complete!

Once you've completed all steps above, come back to VS Code and I'll help you:
1. Enable Firebase packages in your app
2. Update the code to use Firebase
3. Test authentication
4. Test data reading/writing

**Ready to proceed?** Let me know when `google-services.json` is in place!

---

## 🚨 Troubleshooting

### Error: "google-services.json not found"
- Make sure file is in: `android/app/google-services.json`
- File name must be exact (lowercase, with hyphens)

### Error: "Default FirebaseApp is not initialized"
- Check that `google-services.json` is correct
- Make sure package name matches: `com.localpointtt.app`
- Run `flutter clean` and rebuild

### Error: "FirebaseException: Permission denied"
- Check Firestore Security Rules
- Make sure "Test mode" is enabled for development
- Verify authentication is working

---

## 📱 Testing on Device

After setup, test with:
```bash
flutter clean
flutter pub get
flutter run
```

Create an account and verify:
- Authentication works
- Data saves to Firestore
- Data loads from Firestore
