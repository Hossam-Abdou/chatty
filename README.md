# Chatty - Flutter Chat Application

A modern, feature-rich chat application built with Flutter and Firebase.

## Features

- 🔐 Secure Authentication
- 💬 Real-time Messaging
- 🔔 Push Notifications
- 🎨 Modern UI/UX
- 🔄 State Management with Cubit  v
- 🔒 Secure Storage
- 📱 Cross-platform Support

## Project Structure

```
lib/
├── core/                 # Core utilities and services
├── features/            # Feature-based modules
│   ├── auth/           # Authentication feature
│   │   ├── view/       # UI components
│   │   ├── view_model/ # Business logic
│   │   └── widgets/    # Reusable widgets
│   └── home/           # Home/Chat feature
│       ├── view/       # UI components
│       ├── view_model/ # Business logic
│       ├── widgets/    # Reusable widgets
│       └── models/     # Data models
├── src/                # Source files
└── generated/          # Generated files
```

## Key Components

### Authentication
- Secure user authentication
- Token-based session management
- Secure storage for sensitive data

### Chat Features
- Real-time messaging
- Message history
- User presence
- Typing indicators

### Notifications
- Firebase Cloud Messaging (FCM)
- Local notifications
- Background message handling
- Notification permissions management

### State Management
- BLoC pattern implementation
- Custom BlocObserver for debugging
- Clean architecture principles

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure Firebase:
   - Add your `google-services.json` (Android)
   - Add your `GoogleService-Info.plist` (iOS)
4. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- `firebase_core`: Firebase core functionality
- `firebase_messaging`: Push notifications
- `flutter_bloc`: State management
- `flutter_local_notifications`: Local notifications
- `flutter_secure_storage`: Secure storage

## Architecture

The project follows a clean architecture approach with:
- Feature-based organization
- Separation of concerns
- Dependency injection
- BLoC pattern for state management

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request 