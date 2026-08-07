# Firebase Push Notifications — Setup (Customer App)

The app code is already wired for FCM (see `lib/data/services/push_service.dart`).
It degrades gracefully: **without the config below, the app builds and runs
normally — push is simply disabled.**

## 1. Android (required)

1. Go to [Firebase Console](https://console.firebase.google.com) → create (or open) the GharKaMali project.
2. **Add app → Android** with this package name (must match exactly):

   ```
   in.gobt.gharkamali
   ```

   (This is the `applicationId` in `android/app/build.gradle.kts`.)
3. Download **`google-services.json`** and place it at:

   ```
   GKMcustomer/android/app/google-services.json
   ```

4. Rebuild the app. The google-services Gradle plugin is applied automatically
   once that file exists (see the conditional block at the bottom of
   `android/app/build.gradle.kts`) — no Gradle edits needed.

Notes:
- Android 13+ asks the user for notification permission on first launch (already handled in code).
- Do NOT commit `google-services.json` if the repo is public — it is app config, not a secret, but keeping it out of git is common practice.

## 2. Backend (required for sending)

The Node backend (`GharKaMali_Backend/src/services/push.service.js`) needs a
Firebase **service account** to send pushes:

1. Firebase Console → Project Settings → **Service Accounts** → *Generate New Private Key*.
2. Save it as `GharKaMali_Backend/firebase-service-account.json` (git-ignored),
   **or** set the `FIREBASE_SERVICE_ACCOUNT` env var to the JSON string on the server.

The backend stores the token sent by the app on `POST /auth/verify-otp`
(`fcm_token` field) and via `POST /auth/update-fcm-token`.

## 3. iOS (later)

When an iOS build is needed:

1. Firebase Console → Add app → iOS with the app's bundle id.
2. Download `GoogleService-Info.plist` → add to `ios/Runner/` via Xcode.
3. Enable **Push Notifications** + **Background Modes → Remote notifications**
   capabilities in Xcode.
4. Upload the APNs auth key (Apple Developer → Keys) in Firebase Console →
   Project Settings → Cloud Messaging.

## Notification behaviour in the app

- Foreground: shown as a local notification on channel `gkm_customer` ("Booking Updates").
- Tap routing by `data.type`: booking events (`booking_assigned`, `en_route`, `arrived`, `completed`) → Bookings screen; `complaint_resolved` → Complaints screen; anything else → Notifications screen.
- FCM token is sent to the backend at login, on app launch (when logged in), and whenever Firebase rotates it.
