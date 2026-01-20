# 📰 Eminent News - Full Stack News Platform

<div align="center">

![Eminent News Logo](flutter_app/assets/images/logo.png)

**A modern, full-stack news platform with role-based access control, featuring news articles, short-form videos (reels), and a comprehensive admin dashboard.**

[![Flutter](https://img.shields.io/badge/Flutter-3.2+-02569B?logo=flutter)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node. js-18+-339933?logo=node.js)](https://nodejs.org)
[![MongoDB](https://img.shields.io/badge/MongoDB-5.0+-47A248?logo=mongodb)](https://www.mongodb.com)
[![Express.js](https://img.shields.io/badge/Express.js-4.21+-000000?logo=express)](https://expressjs.com)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

[Features](#-features) • [Tech Stack](#-tech-stack) • [Architecture](#-architecture) • [Getting Started](#-getting-started) • [API Documentation](#-api-documentation)

</div>

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Environment Variables](#-environment-variables)
- [API Documentation](#-api-documentation)
- [Screenshots](#-screenshots)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌟 Overview

**Eminent News** is a comprehensive news platform that provides users with access to news articles, short-form video content (similar to Instagram Reels/TikTok), and interactive features like comments, likes, and editor following. The platform implements role-based access control with three distinct user types: **Users**, **Editors**, and **Admins**.

### Key Highlights

- 🎯 **Multi-platform Support**: Flutter mobile app (Android, iOS, Web, Desktop)
- 🔐 **Role-Based Authentication**: User, Editor, and Admin roles with specific permissions
- 📱 **Modern UI/UX**: Material Design 3 with a signature red theme (#F40607)
- 🎥 **Short-Form Videos**: TikTok/Reels-style vertical video player
- ☁️ **Cloud Storage**: Cloudinary integration for media management
- 🚀 **Scalable Backend**: RESTful API with Express.js and MongoDB
- 📊 **Admin Dashboard**: Comprehensive content and user management
- 🔔 **Real-time Updates**: Live news feed with pull-to-refresh

---

## ✨ Features

### 👤 User Features
- ✅ **Authentication**:  Secure login/signup with JWT tokens
- 📰 **News Browsing**: Browse news by categories (National, World, Sports, Entertainment, Trending, Exam Updates)
- ❤️ **Engagement**: Like articles, add comments, and follow editors
- 🎥 **Shorts/Reels**: Watch vertical short-form video content
- 👤 **Profile Management**: View and update personal profile
- 🔔 **Hero Carousel**: Featured news and promotional banners

### ✍️ Editor Features
- 📝 **Content Creation**: Create and manage news articles and shorts
- 📊 **Dashboard**: View content statistics and engagement metrics
- 🖼️ **Media Upload**: Upload images and videos via Cloudinary
- 👥 **Follower Tracking**: See who follows you
- ✏️ **Content Editing**: Update or delete your own content

### 🎛️ Admin Features
- 🔧 **Full Control**: Manage all content, users, editors, and ads
- 📈 **Analytics**: View platform-wide statistics
- 🗑️ **Content Moderation**: Delete inappropriate content
- 👥 **User Management**: View and manage all users and editors
- 🎯 **Ad Management**: Create and manage banner/highlight ads
- 🔍 **Monitoring**: Track platform health and user activity

---

## 🛠️ Tech Stack

### **Mobile Application (Flutter)**

| Technology | Purpose | Version |
|-----------|---------|---------|
| ![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white) | Cross-platform framework | 3.2+ |
| ![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white) | Programming language | 3.0+ |
| ![Riverpod](https://img.shields.io/badge/Riverpod-0175C2?logo=flutter) | State management | 2.4+ |
| ![GoRouter](https://img.shields.io/badge/GoRouter-02569B?logo=flutter) | Navigation & routing | 13.0+ |
| ![Dio](https://img.shields.io/badge/Dio-02569B?logo=dart) | HTTP client | 5.4+ |
| ![Chewie](https://img.shields.io/badge/Chewie-02569B?logo=flutter) | Video player | 1.8+ |
| ![Cached Network Image](https://img.shields.io/badge/Cached_Network_Image-02569B? logo=flutter) | Image caching | 3.4+ |
| ![SharedPreferences](https://img.shields.io/badge/SharedPreferences-02569B?logo=flutter) | Local storage | Latest |

### **Backend (Node.js)**

| Technology | Purpose | Version |
|-----------|---------|---------|
| ![Node.js](https://img.shields.io/badge/Node.js-339933?logo=node.js&logoColor=white) | Runtime environment | 18+ |
| ![Express.js](https://img.shields.io/badge/Express.js-000000?logo=express&logoColor=white) | Web framework | 4.21+ |
| ![MongoDB](https://img.shields.io/badge/MongoDB-47A248?logo=mongodb&logoColor=white) | NoSQL database | 5.0+ |
| ![Mongoose](https://img.shields.io/badge/Mongoose-880000?logo=mongoose) | ODM for MongoDB | 8.12+ |
| ![JWT](https://img.shields.io/badge/JWT-000000?logo=jsonwebtokens) | Authentication | 9.0+ |
| ![Bcrypt. js](https://img.shields.io/badge/Bcrypt. js-338833) | Password hashing | 3.0+ |
| ![Cloudinary](https://img.shields.io/badge/Cloudinary-3448C5?logo=cloudinary&logoColor=white) | Media storage | 1.41+ |
| ![Multer](https://img.shields.io/badge/Multer-FF6600) | File upload middleware | 1.4+ |
| ![Nodemailer](https://img.shields.io/badge/Nodemailer-0077B5) | Email service | 6.10+ |
| ![Express Rate Limit](https://img.shields.io/badge/Rate_Limit-FF6B6B) | API rate limiting | 7.5+ |

### **DevOps & Deployment**

| Technology | Purpose |
|-----------|---------|
| ![Vercel](https://img.shields.io/badge/Vercel-000000?logo=vercel&logoColor=white) | Backend deployment |
| ![MongoDB Atlas](https://img.shields.io/badge/MongoDB_Atlas-47A248?logo=mongodb&logoColor=white) | Database hosting |
| ![Cloudinary](https://img.shields.io/badge/Cloudinary-3448C5?logo=cloudinary&logoColor=white) | Media CDN |
| ![Git](https://img.shields.io/badge/Git-F05032?logo=git&logoColor=white) | Version control |

---

## 🏗️ Architecture

### **System Architecture Diagram**

```
┌─────────────────────────────────────────────────────────────────────┐
│                         CLIENT LAYER                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐ │
│  │   Android App    │  │     iOS App      │  │    Web App       │ │
│  │   (Flutter)      │  │   (Flutter)      │  │   (Flutter)      │ │
│  └────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘ │
│           │                     │                      │            │
│           └─────────────────────┴──────────────────────┘            │
│                                 │                                    │
└─────────────────────────────────┼────────────────────────────────────┘
                                  │
                                  │ HTTPS/REST API
                                  │
┌─────────────────────────────────┼────────────────────────────────────┐
│                         API GATEWAY LAYER                            │
├─────────────────────────────────┼────────────────────────────────────┤
│                                 │                                    │
│                    ┌────────────▼──────────────┐                    │
│                    │   Express.js Server       │                    │
│                    │   (Node.js Runtime)       │                    │
│                    └────────────┬──────────────┘                    │
│                                 │                                    │
│         ┌───────────────────────┼───────────────────────┐           │
│         │                       │                       │           │
│    ┌────▼────┐         ┌────────▼─────┐         ┌──────▼──────┐   │
│    │  CORS   │         │ Rate Limiter │         │  JWT Auth   │   │
│    │Middleware│        │  Middleware  │         │ Middleware  │   │
│    └────┬────┘         └──────┬───────┘         └──────┬──────┘   │
│         └───────────────────────┼───────────────────────┘           │
└─────────────────────────────────┼────────────────────────────────────┘
                                  │
┌─────────────────────────────────┼────────────────────────────────────┐
│                         BUSINESS LOGIC LAYER                         │
├─────────────────────────────────┼────────────────────────────────────┤
│                                 │                                    │
│     ┌────────────┬──────────────┼──────────────┬────────────┐      │
│     │            │              │              │            │      │
│ ┌───▼────┐  ┌────▼───┐    ┌────▼───┐    ┌────▼───┐  ┌────▼───┐  │
│ │ User   │  │ News   │    │Shorts  │    │  Ads   │  │ Auth   │  │
│ │Controller│ │Controller│ │Controller│ │Controller│ │Controller│ │
│ └───┬────┘  └────┬───┘    └────┬───┘    └────┬───┘  └────┬───┘  │
│     │            │              │              │            │      │
│ ┌───▼────┐  ┌────▼───┐    ┌────▼───┐    ┌────▼───┐  ┌────▼───┐  │
│ │ User   │  │ News   │    │Shorts  │    │  Ads   │  │ Auth   │  │
│ │Service │  │Service │    │Service │    │Service │  │Service │  │
│ └───┬────┘  └────┬───┘    └────┬───┘    └────┬───┘  └────┬───┘  │
│     │            │              │              │            │      │
└─────┼────────────┼──────────────┼──────────────┼────────────┼──────┘
      │            │              │              │            │
      └────────────┴──────────────┴──────────────┴────────────┘
                                  │
┌─────────────────────────────────┼────────────────────────────────────┐
│                         DATA LAYER                                   │
├─────────────────────────────────┼────────────────────────────────────┤
│                                 │                                    │
│     ┌────────────┬──────────────┼──────────────┬────────────┐      │
│     │            │              │              │            │      │
│ ┌───▼────┐  ┌────▼───┐    ┌────▼───┐    ┌────▼───┐  ┌────▼───┐  │
│ │ User   │  │ News   │    │Shorts  │    │  Ads   │  │Comment │  │
│ │ Model  │  │ Model  │    │ Model  │    │ Model  │  │ Schema │  │
│ │(Mongoose)│ │(Mongoose)│ │(Mongoose)│ │(Mongoose)│ │(Mongoose)│ │
│ └───┬────┘  └────┬───┘    └────┬───┘    └────┬───┘  └────┬───┘  │
│     │            │              │              │            │      │
│     └────────────┴──────────────┴──────────────┴────────────┘      │
│                                 │                                    │
│                    ┌────────────▼──────────────┐                    │
│                    │    MongoDB Atlas          │                    │
│                    │    (Cloud Database)       │                    │
│                    └───────────────────────────┘                    │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                         EXTERNAL SERVICES                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│    ┌────────────────────────┐         ┌────────────────────────┐   │
│    │   Cloudinary CDN       │         │   Nodemailer SMTP      │   │
│    │  (Image/Video Storage) │         │   (Email Service)      │   │
│    └────────────────────────┘         └────────────────────────┘   │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘
```

### **Flutter App Architecture (Clean Architecture)**

```
┌─────────────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ┌────────────────────┐    ┌────────────────────┐                  │
│  │   Screens/Pages    │◄───│   Widgets          │                  │
│  │  - HomeScreen      │    │  - NewsCard        │                  │
│  │  - LoginScreen     │    │  - VideoPlayer     │                  │
│  │  - NewsDetail      │    │  - CommentWidget   │                  │
│  │  - ShortsReel      │    │  - HeroCarousel    │                  │
│  └─────────┬──────────┘    └────────────────────┘                  │
│            │                                                         │
│            │ Reads/Writes State                                     │
│            │                                                         │
│  ┌─────────▼──────────────────────────────────────┐                │
│  │         Riverpod Providers                     │                │
│  │  - AuthProvider (StateNotifier)                │                │
│  │  - NewsProvider (StateNotifier)                │                │
│  │  - ShortsProvider (StateNotifier)              │                │
│  │  - AdsProvider (StateNotifier)                 │                │
│  └─────────┬──────────────────────────────────────┘                │
│            │                                                         │
└────────────┼─────────────────────────────────────────────────────────┘
             │
             │ Calls Services
             │
┌────────────▼─────────────────────────────────────────────────────────┐
│                    DATA LAYER                                        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ┌─────────────────────────────────────────────────────┐            │
│  │                Services                              │            │
│  │  - AuthService (Login, Signup, Logout)              │            │
│  │  - NewsService (Fetch, Like, Comment, Delete)       │            │
│  │  - ShortsService (Fetch, Like, Delete)              │            │
│  │  - AdsService (Fetch, Delete)                       │            │
│  │  - ApiService (Dio HTTP Client)                     │            │
│  └─────────┬───────────────────────────────────────────┘            │
│            │                                                         │
│            │ Returns Models                                          │
│            │                                                         │
│  ┌─────────▼───────────────────────────────────────────┐            │
│  │                Models                                │            │
│  │  - UserModel. fromJson()                             │            │
│  │  - NewsModel.fromJson()                             │            │
│  │  - ShortModel.fromJson()                            │            │
│  │  - AdsModel.fromJson()                              │            │
│  └─────────┬───────────────────────────────────────────┘            │
│            │                                                         │
└────────────┼─────────────────────────────────────────────────────────┘
             │
             │ HTTP Requests (Dio)
             │
┌────────────▼─────────────────────────────────────────────────────────┐
│                    BACKEND API                                       │
│                 (Express.js REST API)                                │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                    CORE LAYER                                        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ┌─────────────────┐  ┌──────────────────┐  ┌──────────────────┐  │
│  │   Constants     │  │   Utils          │  │   Config         │  │
│  │ - API_URL       │  │ - DateFormatter  │  │ - Environment    │  │
│  │ - Categories    │  │ - SharedPrefs    │  │ - Theme          │  │
│  │ - Roles         │  │ - Validators     │  │ - Routes         │  │
│  └─────────────────┘  └──────────────────┘  └──────────────────┘  │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘
```

### **Authentication Flow**

```
┌──────────────┐                                    ┌──────────────┐
│   Flutter    │                                    │   Backend    │
│     App      │                                    │  (Express)   │
└──────┬───────┘                                    └──────┬───────┘
       │                                                   │
       │  1. POST /api/v1/login                           │
       │     { email, password }                          │
       ├─────────────────────────────────────────────────►│
       │                                                   │
       │                           2. Validate Credentials│
       │                              Check bcrypt hash   │
       │                                                   │
       │  3. Response:                                      │
       │     { success:  true,                              │
       │       token:  "jwt_token",                         │
       │       user: { _id, name, email, role } }          │
       │◄─────────────────────────────────────────────────┤
       │                                                   │
       │  4. Store token in SharedPreferences              │
       │     Store user data in AuthProvider               │
       ├──┐                                                │
       │  │                                                │
       │◄─┘                                                │
       │                                                   │
       │  5. All subsequent requests include header:      │
       │     Authorization: Bearer <jwt_token>             │
       ├─────────────────────────────────────────────────►│
       │                                                   │
       │                           6. Verify JWT Middleware│
       │                              Decode & validate    │
       │                              Attach user to req   │
       │                                                   │
       │  7. Protected resource response                   │
       │◄─────────────────────────────────────────────────┤
       │                                                   │
```

### **Data Flow Diagram**

```
User Interaction → UI Widget → Riverpod Provider → Service → API Call
                                       ▲                          │
                                       │                          │
                                       │                          ▼
                                  StateNotifier            HTTP Response
                                       ▲                          │
                                       │                          │
                                       │                          ▼
                                  Update State ◄──────── Parse to Model
                                       │
                                       │
                                       ▼
                              Rebuild UI Widgets
```

---

## 📁 Project Structure

```
eminent_news/
│
├── backend/                          # Node.js + Express Backend
│   ├── src/
│   │   ├── controllers/              # Route controllers
│   │   │   ├── newsController.js
│   │   │   ├── userController.js
│   │   │   ├── shortController.js
│   │   │   └── adsController.js
│   │   ├── middleware/               # Custom middleware
│   │   │   ├── auth.js               # JWT authentication
│   │   │   ├── error.js              # Error handling
│   │   │   └── multer.js             # File upload
│   │   ├── models/                   # Mongoose schemas
│   │   │   ├── newsModel.js
│   │   │   ├── usersModel.js
│   │   │   ├── shortsModel.js
│   │   │   └── adsModel.js
│   │   ├── routes/                   # API routes
│   │   │   ├── newsRoute.js
│   │   │   ├── userRoute.js
│   │   │   ├── shortRoute.js
│   │   │   └── adsRoute.js
│   │   ├── utils/                    # Utility functions
│   │   │   ├── jwtToken.js
│   │   │   ├── sendEmail.js
│   │   │   └── cloudinary.js
│   │   ├── app.js                    # Express app setup
│   │   └── server.js                 # Server entry point
│   ├── package.json
│   ├── vercel.json                   # Vercel deployment config
│   └── . env. example
│
├── flutter_app/                      # Flutter Mobile Application
│   ├── lib/
│   │   ├── main.dart                 # App entry point
│   │   ├── app.dart                  # Root widget
│   │   ├── config/                   # App configuration
│   │   │   ├── env.dart              # Environment variables
│   │   │   └── theme.dart            # Material theme
│   │   ├── core/                     # Core utilities
│   │   │   ├── constants/
│   │   │   │   ├── api_constants.dart
│   │   │   │   └── app_constants.dart
│   │   │   └── utils/
│   │   │       ├── shared_prefs_helper.dart
│   │   │       └── date_formatter.dart
│   │   ├── data/                     # Data layer
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   ├── news_model.dart
│   │   │   │   ├── short_model.dart
│   │   │   │   └── ads_model.dart
│   │   │   └── services/
│   │   │       ├── api_service.dart
│   │   │       ├── auth_service.dart
│   │   │       ├── news_service.dart
│   │   │       ├── shorts_service.dart
│   │   │       └── ads_service.dart
│   │   ├── presentation/             # UI layer
│   │   │   ├── providers/
│   │   │   │   ├── auth_provider.dart
│   │   │   │   ├── news_provider.dart
│   │   │   │   ├── shorts_provider.dart
│   │   │   │   └── ads_provider.dart
│   │   │   └── screens/
│   │   │       ├── auth/
│   │   │       │   ├── splash_screen.dart
│   │   │       │   ├── landing_screen.dart
│   │   │       │   ├── login_screen.dart
│   │   │       │   └── signup_screen.dart
│   │   │       ├── home/
│   │   │       │   └── home_screen.dart
│   │   │       ├── news/
│   │   │       │   ├── news_list_screen.dart
│   │   │       │   └── news_detail_screen.dart
│   │   │       ├── shorts/
│   │   │       │   └── shorts_reel_screen.dart
│   │   │       ├── profile/
│   │   │       │   └── profile_screen.dart
│   │   │       ├── editor/
│   │   │       │   └── editor_dashboard_screen.dart
│   │   │       └── admin/
│   │   │           └── admin_dashboard_screen. dart
│   │   └── routes/                   # Navigation
│   │       └── app_router.dart       # GoRouter config
│   ├── assets/
│   │   └── images/
│   │       ├── logo.png
│   │       ├── profile.png
│   │       └── login.png
│   ├── pubspec.yaml
│   ├── README.md
│   └── IMPLEMENTATION_STATUS.md
│
├── . gitignore
├── LICENSE
└── README.md                         # This file
```

---

## 🚀 Getting Started

### **Prerequisites**

Before you begin, ensure you have the following installed:

- **Node.js** (v18 or higher) - [Download](https://nodejs.org/)
- **Flutter SDK** (v3.2 or higher) - [Install Guide](https://flutter.dev/docs/get-started/install)
- **MongoDB** (local or Atlas account) - [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
- **Cloudinary Account** - [Sign Up](https://cloudinary.com/)
- **Git** - [Download](https://git-scm.com/)

### **Installation**

#### 1️⃣ **Clone the Repository**

```bash
git clone https://github.com/Gouravlamba/eminent_news.git
cd eminent_news
```

#### 2️⃣ **Backend Setup**

```bash
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# Create .env file
cp .env. example .env

# Edit .env with your credentials
nano .env
```

**Required Environment Variables** (`.env`):

```env
# Server
PORT=5000
NODE_ENV=development

# Database
MONGODB_URL=mongodb+srv://username:password@cluster.mongodb.net/eminent_news

# JWT
JWT_SECRET=your_super_secret_jwt_key_here
JWT_EXPIRE=7d

# Cloudinary
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

# Email (Nodemailer)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_app_password
SMTP_FROM=noreply@eminentnews.com
```

```bash
# Start development server
npm run dev

# Or start production server
npm start
```

Backend will run on `http://localhost:5000` 🎉

#### 3️⃣ **Flutter App Setup**

```bash
# Navigate to flutter_app directory
cd ../flutter_app

# Install dependencies
flutter pub get

# Check Flutter setup
flutter doctor

# Run the app (with backend URL)
flutter run --dart-define=BASE_URL=http://localhost:5000/api/v1

# Or for production
flutter run --dart-define=BASE_URL=https://your-backend-url.com/api/v1 --release
```

**Platform-Specific Commands:**

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome

# Desktop (macOS)
flutter run -d macos

# Desktop (Windows)
flutter run -d windows

# Desktop (Linux)
flutter run -d linux
```

---

## 🔐 Environment Variables

### **Backend Environment Variables**

Create a `.env` file in the `backend/` directory:

| Variable | Description | Example |
|----------|-------------|---------|
| `PORT` | Server port | `5000` |
| `MONGODB_URL` | MongoDB connection string | `mongodb+srv://...` |
| `JWT_SECRET` | Secret key for JWT tokens | `my_secret_key_123` |
| `JWT_EXPIRE` | JWT expiration time | `7d` |
| `CLOUDINARY_CLOUD_NAME` | Cloudinary cloud name | `your_cloud_name` |
| `CLOUDINARY_API_KEY` | Cloudinary API key | `123456789012345` |
| `CLOUDINARY_API_SECRET` | Cloudinary API secret | `your_secret_key` |
| `SMTP_HOST` | Email SMTP host | `smtp.gmail.com` |
| `SMTP_PORT` | Email SMTP port | `587` |
| `SMTP_USER` | Email address | `your@email.com` |
| `SMTP_PASSWORD` | Email app password | `your_app_password` |

### **Flutter Environment Variables**

Set the backend URL when running the app:

```bash
flutter run --dart-define=BASE_URL=http://your-backend-url.com/api/v1
```

Or modify `lib/config/env.dart`:

```dart
class Environment {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:5000/api/v1', // Your default URL
  );
}
```

---

## 📡 API Documentation

### **Base URL**
```
http://localhost:5000/api/v1
```

### **Authentication Endpoints**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| `POST` | `/register` | Register new user | ✅ |
| `POST` | `/login` | Login user | ✅ |
| `POST` | `/logout` | Logout user | ✅ |
| `GET` | `/me` | Get current user details | ✅ |
| `PUT` | `/me/update` | Update user profile | ✅ |
| `POST` | `/password/forgot` | Forgot password | ✅ |
| `PUT` | `/password/reset/:token` | Reset password | ✅ |

### **News Endpoints**

| Method | Endpoint | Description | Auth Required | Role |
|--------|----------|-------------|---------------|------|
| `GET` | `/news` | Get all news (with filters) | ✅ | All |
| `GET` | `/news/:id` | Get news by ID | ✅ | All |
| `POST` | `/news/new` | Create news | ✅ | Editor/Admin |
| `PUT` | `/news/:id` | Update news | ✅ | Editor/Admin |
| `DELETE` | `/news/:id` | Delete news | ✅ | Editor/Admin |
| `PUT` | `/news/:id/like` | Like/Unlike news | ✅ | All |
| `POST` | `/news/:id/comment` | Add comment | ✅ | All |

### **Shorts Endpoints**

| Method | Endpoint | Description | Auth Required | Role |
|--------|----------|-------------|---------------|------|
| `GET` | `/shorts` | Get all shorts | ✅ | All |
| `GET` | `/shorts/my` | Get my shorts | ✅ | Editor/Admin |
| `POST` | `/shorts/new` | Create short | ✅ | Editor/Admin |
| `DELETE` | `/shorts/:id` | Delete short | ✅ | Editor/Admin |
| `PUT` | `/shorts/:id/like` | Like/Unlike short | ✅ | All |

### **Ads Endpoints**

| Method | Endpoint | Description | Auth Required | Role |
|--------|----------|-------------|---------------|------|
| `GET` | `/ads` | Get all ads | ✅ | All |
| `POST` | `/ads/new` | Create ad | ✅ | Admin |
| `DELETE` | `/ads/:id` | Delete ad | ✅ | Admin |

### **User Management Endpoints**

| Method | Endpoint | Description | Auth Required | Role |
|--------|----------|-------------|---------------|------|
| `GET` | `/admin/users` | Get all users | ✅ | Admin |
| `GET` | `/admin/user/:id` | Get user by ID | ✅ | Admin |
| `PUT` | `/admin/user/:id` | Update user role | ✅ | Admin |
| `DELETE` | `/admin/user/:id` | Delete user | ✅ | Admin |
| `PUT` | `/user/:id/follow` | Follow/Unfollow user | ✅ | All |

### **Request Examples**

#### **Login Request**

```bash
curl -X POST http://localhost:5000/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

**Response:**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.. .",
  "user": {
    "_id": "65abc123def456789",
    "name": "John Doe",
    "username": "johndoe",
    "email":  "user@example.com",
    "role": "user",
    "avatar": "https://res.cloudinary.com/..."
  }
}
```

#### **Create News Request**

```bash
curl -X POST http://localhost:5000/api/v1/news/new \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "title": "Breaking News Title",
    "description": "Full article content here.. .",
    "category": "National",
    "subCategories": ["Politics", "Breaking"],
    "images": ["https://cloudinary.com/image1.jpg"]
  }'
```

---

## 🎨 Screenshots

> **Note**:  Add your app screenshots here

```
┌─────────────────────────────────────────────────────────────────┐
│                      App Screenshots                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  [Splash Screen]  [Landing]  [Login]  [Signup]                  │
│                                                                   │
│  [Home Feed]      [News Detail]   [Shorts Reel]                 │
│                                                                   │
│  [Profile]        [Editor Dashboard]  [Admin Dashboard]         │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🧪 Testing

### **Backend Testing**

```bash
cd backend
npm test
```

### **Flutter Testing**

```bash
cd flutter_app

# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Widget tests
flutter test test/widget_test.dart

# Integration tests
flutter drive --target=test_driver/app. dart
```

---

## 🐳 Docker Deployment (Optional)

### **Backend Dockerfile**

Create `backend/Dockerfile`:

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . . 

EXPOSE 5000

CMD ["node", "src/server.js"]
```

### **Docker Compose**

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  backend:
    build: ./backend
    ports:
      - "5000:5000"
    environment:
      - MONGODB_URL=mongodb://mongo:27017/eminent_news
      - JWT_SECRET=your_secret_key
    depends_on:
      - mongo

  mongo:
    image: mongo:5.0
    ports:
      - "27017:27017"
    volumes:
      - mongo-data:/data/db

volumes: 
  mongo-data:
```

**Run:**
```bash
docker-compose up -d
```

---

## 📊 Database Schema

### **User Schema**

```javascript
{
  name: String (required, 4-30 chars),
  username: String (required, unique),
  email: String (required, unique),
  password: String (required, hashed),
  avatar: String (Cloudinary URL),
  role: String (enum: user/editor/admin),
  address: String,
  phone: String,
  verified: Boolean (default: false),
  followers: [{ user: ObjectId, followedAt: Date }],
  following: [{ user: ObjectId, followedAt: Date }],
  createdAt: Date,
  updatedAt: Date
}
```

### **News Schema**

```javascript
{
  title: String (required),
  description: String (required),
  images: [String] (Cloudinary URLs),
  category: String,
  subCategories: [String],
  videoUrl: String,
  likes: [{ user: ObjectId }],
  comments: [{
    user: ObjectId,
    comment: String,
    createdAt: Date
  }],
  editor: ObjectId (required),
  createdAt: Date,
  updatedAt: Date
}
```

### **Short Schema**

```javascript
{
  title: String (required),
  description: String,
  videoUrl: String (required),
  publicId: String (Cloudinary ID),
  thumbnail: String,
  duration: Number,
  videoMimeType: String,
  likes: [{ user: ObjectId }],
  editor: ObjectId (required),
  createdAt: Date,
  updatedAt: Date
}
```

### **Ads Schema**

```javascript
{
  title: String,
  description: String,
  category: String (required:  Banner/Highlights),
  images: [String],
  url: String,
  createdAt: Date,
  updatedAt: Date
}
```

---

## 🤝 Contributing

We welcome contributions!  Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit your changes** (`git commit -m 'Add some AmazingFeature'`)
4. **Push to the branch** (`git push origin feature/AmazingFeature`)
5. **Open a Pull Request**

### **Coding Standards**

- **Backend**: Follow [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- **Flutter**: Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Write meaningful commit messages
- Add comments for complex logic
- Update documentation for new features

---

## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Gourav Lamba**

- GitHub: [@Gouravlamba](https://github.com/Gouravlamba)
- Email: gouraclambha007@gmail.com

---

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev) for the amazing framework
- [Express.js](https://expressjs.com) for the robust backend framework
- [MongoDB](https://www.mongodb.com) for the scalable database
- [Cloudinary](https://cloudinary.com) for media management
- All contributors and supporters

---

## 📞 Support

If you have any questions or need help, feel free to:

- 📧 Email: support@eminentnews.com
- 💬 Open an issue on GitHub
- 🌟 Star this repository if you found it helpful! 

---

<div align="center">

**Made with ❤️ by Gourav Kumar Lamba**

⭐ **Star this repository if you found it helpful!** ⭐

</div>
