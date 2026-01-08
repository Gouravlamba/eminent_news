# Eminent News - Flutter Mobile Application

A Flutter mobile application that consumes the Eminent News backend REST APIs. This app provides a complete news reading experience with features like authentication, news browsing, shorts/reels, and role-based admin/editor dashboards.

## Features

### User Features
- 🔐 **Authentication**: Login and signup with role-based access
- 📰 **News Browsing**: Browse news by categories (National, World, Trending, Sports, Entertainment, Exam Update)
- ❤️ **Engagement**: Like news, add comments, follow editors
- 🎥 **Shorts/Reels**: Vertical video player similar to TikTok/Instagram Reels
- 👤 **Profile Management**: View and update user profile
- 🔔 **Hero Carousel**: Featured news and banner ads on home screen

### Editor Features
- ✍️ **Content Management**: Manage your news articles and shorts
- 📊 **Dashboard**: View your content statistics
- 📝 **Create/Edit**: Create and edit news articles and shorts

### Admin Features
- 🎛️ **Full Dashboard**: Manage all news, shorts, ads, editors, and users
- 👥 **User Management**: View and manage all users and editors
- 📈 **Analytics**: View platform statistics
- 🗑️ **Content Moderation**: Delete inappropriate content

## Architecture

This Flutter app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── config/          # App configuration (theme, routes, environment)
├── core/            # Core utilities and constants
├── data/            # Data layer (models, services, repositories)
├── presentation/    # UI layer (screens, widgets, providers)
└── routes/          # Navigation and route guards
```

### State Management
- **Riverpod**: Used for state management (replacing Redux from React)
- **StateNotifier**: For complex state logic
- **Provider**: For dependency injection

### Routing
- **GoRouter**: Declarative routing with path parameters
- **Route Guards**: Role-based authentication checks

### HTTP Client
- **Dio**: For making REST API calls (replacing Axios)
- **Pretty Dio Logger**: For debugging API calls

## Prerequisites

- Flutter SDK: `>=3.2.0 <4.0.0`
- Dart SDK: Included with Flutter
- Android Studio / Xcode for running emulators
- Valid backend API URL

## Installation

1. **Clone the repository**:
   ```bash
   cd flutter_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure environment**:
   
   Create a `.env` file or use `--dart-define` to set the backend URL:
   ```bash
   flutter run --dart-define=BASE_URL=https://your-backend-url.com/api/v1
   ```

   Or modify `lib/config/env.dart` to set a default URL.

4. **Run the app**:
   ```bash
   # For debug mode
   flutter run

   # For release mode
   flutter run --release
   ```

## Configuration

### API Base URL

The app uses environment variables for configuration. You can set the base URL in three ways:

1. **Using --dart-define** (Recommended):
   ```bash
   flutter run --dart-define=BASE_URL=https://api.example.com/api/v1
   ```

2. **Modify env.dart**:
   Edit `lib/config/env.dart` and change the `defaultValue`:
   ```dart
   static const String baseUrl = String.fromEnvironment(
     'BASE_URL',
     defaultValue: 'https://your-api-url.com/api/v1',
   );
   ```

3. **Build with define**:
   ```bash
   flutter build apk --dart-define=BASE_URL=https://api.example.com/api/v1
   ```

## Project Structure

### Core Directories

#### `/lib/config`
- `theme.dart`: App theme with Material Design 3
- `env.dart`: Environment configuration
- `routes.dart`: Route definitions

#### `/lib/core`
- `constants/`: API endpoints and app constants
- `utils/`: Utility functions (SharedPreferences, date formatting)

#### `/lib/data`
- `models/`: Data models (User, News, Short, Ads)
- `services/`: API service classes
- `repositories/`: Repository pattern implementation

#### `/lib/presentation`
- `providers/`: Riverpod state providers
- `screens/`: App screens organized by feature
- `widgets/`: Reusable UI components

#### `/lib/routes`
- `app_router.dart`: GoRouter configuration
- `route_guards.dart`: Authentication and authorization logic

## API Endpoints

The app consumes the following backend endpoints:

### Authentication
- `POST /login` - User login
- `POST /register` - User registration
- `GET /logout` - User logout
- `GET /me` - Get current user details

### News
- `GET /news` - Get all news
- `GET /news/:id` - Get news by ID
- `PUT /news/:id/like` - Like/unlike news
- `POST /news/:id/comment` - Add comment to news
- `DELETE /news/:id` - Delete news (admin/editor)

### Shorts
- `GET /shorts` - Get all shorts
- `GET /my-shorts` - Get my shorts (editor)
- `POST /shorts/:id/like` - Like short
- `DELETE /shorts/:id` - Delete short (admin/editor)

### Ads
- `GET /ads` - Get all ads
- `DELETE /ads/:id` - Delete ad (admin)

### Admin
- `GET /admin/users` - Get all users
- `GET /admin/editors` - Get all editors
- `GET /admin/user/:id` - Get user by ID
- `PUT /admin/user/:id` - Update user role
- `DELETE /admin/user/:id` - Delete user

### User/Editor
- `PUT /user/:id/follow` - Follow/unfollow user

## Key Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.4.9      # State management
  dio: ^5.4.0                   # HTTP client
  go_router: ^13.0.0            # Routing
  shared_preferences: ^2.2.2    # Local storage
  cached_network_image: ^3.3.1  # Image caching
  video_player: ^2.8.2          # Video playback
  chewie: ^1.7.5                # Video player UI
  carousel_slider: ^4.2.1       # Carousel widget
  shimmer: ^3.0.0               # Loading shimmer effect
```

## Building for Production

### Android APK
```bash
flutter build apk --release --dart-define=BASE_URL=https://your-api.com/api/v1
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release --dart-define=BASE_URL=https://your-api.com/api/v1
```

### iOS (requires macOS)
```bash
flutter build ios --release --dart-define=BASE_URL=https://your-api.com/api/v1
```

## Testing

Run the test suite:
```bash
flutter test
```

## Theme Customization

The app uses a custom theme matching the original React app:

- **Primary Color**: #F40607 (Red)
- **Dark Gray**: #2D2D2D
- **Light Gray**: #F5F5F5

Modify `lib/config/theme.dart` to customize colors and styles.

## Troubleshooting

### Common Issues

1. **API Connection Failed**:
   - Verify the `BASE_URL` is correct
   - Check if the backend server is running
   - Ensure your device/emulator can reach the API (use `10.0.2.2` for Android emulator localhost)

2. **Assets Not Loading**:
   - Run `flutter pub get` again
   - Clean and rebuild: `flutter clean && flutter pub get`

3. **Video Player Issues**:
   - Ensure video URLs are valid and accessible
   - Check internet permissions in `AndroidManifest.xml`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write/update tests
5. Submit a pull request

## License

This project is part of the Eminent News application.

## Support

For issues and questions, please open an issue in the repository.
