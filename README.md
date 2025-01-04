# CoffeeTrack

CoffeeTrack is a mobile and web-based application designed for coffee enthusiasts to explore, review, and keep track of their coffee experiences. The platform combines local discovery with personal record-keeping and community-driven recommendations.

## Features

- **Local Coffee Shop Finder**
  - Interactive map view of nearby coffee shops
  - List view with detailed information
  - Search and filter options

- **Coffee Experience Tracker**
  - Log and rate coffee experiences
  - Track favorite coffee shops and drinks
  - Add photos and detailed reviews

- **User Profiles**
  - Personal coffee journey timeline
  - Statistics and preferences
  - Review history

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Firebase account and project setup
- Google Maps API key
- Android Studio / Xcode for mobile development

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/coffee_app.git
   cd coffee_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Create a `.env` file in the root directory with your API keys:
   ```
   GOOGLE_MAPS_API_KEY=your_google_maps_api_key
   ```

4. Set up Firebase:
   - Create a new Firebase project
   - Add Android and iOS apps to your Firebase project
   - Download and add the configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS

5. Run the app:
   ```bash
   flutter run
   ```

### Firebase Setup

1. Enable Authentication with Email/Password sign-in method
2. Create the following Firestore collections:
   - `users`
   - `coffee_shops`
   - `reviews`

## Project Structure

```
lib/
├── main.dart
├── screens/
│   ├── auth_screen.dart
│   ├── home_screen.dart
│   └── profile_screen.dart
├── providers/
│   ├── auth_provider.dart
│   ├── coffee_shops_provider.dart
│   └── user_reviews_provider.dart
├── models/
├── widgets/
├── services/
└── utils/
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Google Maps for location services
