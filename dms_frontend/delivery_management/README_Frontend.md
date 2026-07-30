# Delivery Management System - Flutter App

A cross-platform Flutter application for delivery personnel to manage delivery orders, update delivery status, capture proof of delivery, and navigate using Google Maps.

## Features

- User Authentication
- Dashboard with Delivery Orders
- Search, Filter & Sort Orders
- View Order Details
- Update Delivery Status
- Add Delivery Remarks
- Google Maps Integration
- Current Location Tracking
- Navigation to Customer Location
- Upload Delivery Proof (Camera/Gallery)
- Firebase Push Notifications
- Local Notifications
- Light & Dark Theme
- Responsive UI
- MVVM Architecture
- Provider State Management

---

## Tech Stack

- Flutter
- Dart
- Provider
- Google Maps Flutter
- Firebase Cloud Messaging
- Firebase Core
- Geolocator
- Image Picker
- HTTP
- Flutter Local Notifications
- Shared Preferences

---

## Project Structure

```
lib/
│
├── core/
│   ├── api/
│   ├── constants/
│   ├── services/
│   ├── theme/
│   └── widgets/
│
├── models/
│
├── repositories/
│
├── viewmodels/
│
├── views/
│   ├── splash/
│   ├── login/
│   ├── dashboard/
│   ├── orders/
│   ├── profile/
│   └── map/
│
├── routes/
│
└── main.dart
```

---

## Prerequisites

- Flutter SDK (Latest Stable)
- Android Studio / VS Code
- Android SDK
- Google Maps API Key
- Firebase Project

---

## Installation

### Clone Repository

```bash
git clone https://github.com/yourusername/delivery_management_flutter.git
```

```bash
cd delivery_management_flutter
```

### Install Packages

```bash
flutter pub get
```

### Create Environment File

Create:

```
assets/.env
```

Example

```
BASE_URL=http://YOUR_SERVER_IP:5000/api/v1
```

### Configure Firebase

Add

```
google-services.json
```

inside

```
android/app/
```

### Configure Google Maps API Key

Edit

```
android/app/src/main/AndroidManifest.xml
```

Add

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

---

## Run Application

```bash
flutter run
```

---

## Build APK

```bash
flutter build apk --release
```

---

## Main Packages

```
provider
http
google_maps_flutter
firebase_core
firebase_messaging
flutter_local_notifications
geolocator
image_picker
shared_preferences
flutter_dotenv
```

---

## Screens

- Splash Screen
- Login
- Dashboard
- Delivery Orders
- Order Details
- Map Screen
- Delivery Proof
- Profile

---

## Architecture

```
UI
 ↓
ViewModel
 ↓
Repository
 ↓
REST API
 ↓
Node.js Backend
 ↓
MySQL Database
```

---

## Author

Maharanjitham S.
Flutter Developer