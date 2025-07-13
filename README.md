# Maya Test App

A Flutter application demonstrating wallet and money transfer functionality with authentication.

## Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / Xcode for running on devices/emulators

## Getting Started

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

3. Generate necessary files:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Running the App

```bash
flutter run
```

or

F5 and select dev.json environment

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/presentation/auth/domain/repositories/auth_repository_test.dart

# Run tests with coverage
flutter test --coverage
```

## Project Structure

```
lib/
├── core/          # Core functionality (DIO, logging, etc.)
├── di/            # Dependency injection
├── presentation/  # UI and business logic
│   ├── auth/      # Authentication feature
│   ├── wallet/    # Wallet feature
│   └── send_money/# Money transfer feature
└── shared/        # Shared utilities and constants
```

## Testing Strategy

The project follows a comprehensive testing strategy:

1. **Unit Tests**: Testing individual components
   - Repository tests
   - API contract tests
   - Entity tests

2. **Widget Tests**: Testing UI components
   - Page tests
   - Component tests

3. **Integration Tests**: Testing feature workflows
   - Authentication flow
   - Wallet operations
   - Money transfer process

## Development Notes

- Uses BLoC pattern for state management
- Implements clean architecture principles
- Uses dependency injection for better testability
- Follows Flutter best practices and conventions
