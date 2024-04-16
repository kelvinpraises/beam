# Beam Project Documentation

## Overview

This is a Flutter project aimed at providing a seamless web experience of the Beam website within a mobile application. It leverages the power of Flutter for cross-platform development, ensuring a consistent user interface and user experience across iOS and Android platforms.

## Features

- **Custom WebView**: Integrates a custom web view for displaying web content within the app. This includes handling video playback, theme changes, and reloading web content dynamically.
- **Theme Management**: Supports dark and light themes, with the ability to detect and apply the user's preferred theme automatically.
- **Welcome Sheet**: Displays a welcome sheet on the first launch, enhancing the user experience for new users.

## Key Components

### WebView Customization

The [BeamWebview](/lib/screens/beam_webview.dart) widget, is central to the project. It encapsulates the functionality for displaying web content, handling theme changes, and managing video playback within the app.

- **Video Playback Customization**: Removes the default video play icon and sets a transparent poster or a black background for video tags.
- **Theme Change Polling**: Periodically checks for theme changes and communicates with the Flutter app to apply the new theme.
- **Welcome Sheet**: Determines if the welcome sheet has been shown to the user and displays it accordingly.

### Theme Management

The [ThemeProvider](lib/provider/theme_provider.dart) class, manages the theme for the application. It initializes the theme based on the user's website settings and dynamically changes as the sites theme changes.

### Platform-Specific Configurations

- **iOS**: The iOS platform configuration is found in the [Podfile](/ios/Podfile) and the permissions in [info.plist](/ios/Runner/Info.plist)
- **Android**: Android-specific settings, including the application ID and API keys, are defined in [android/app/google-services.json](/android/app/google-services.json).

### Code Organization

- **Main Entry Point**: [lib/main.dart](/lib/main.dart) serves as the entry point of the application, where the Flutter app is initialized and run.
- **Screens**: The `lib/screens` directory contains the UI components of the app, including the custom web view and welcome sheet.
- **Widgets**: Reusable widgets are located in `lib/widgets`, allowing for a modular and maintainable codebase.
- **Keystore**: There will be a file `key.properties` under `android` and it should contain details to the keystore used to sign the app

```
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

## Development Setup

1. **Flutter Environment**: Ensure you have Flutter installed and set up on your development machine.
2. **Dependencies**: Install the project dependencies by running `flutter pub get` in the project root directory.
3. **iOS Setup**: Navigate to the `ios` directory and run `pod install` to set up the iOS project.
4. **Android Setup**: Ensure the `google-services.json` file is correctly placed in the `android/app` directory for Firebase services.

## Running the App

- **iOS**: Open the `ios/Runner.xcworkspace` in Xcode and run the project on a simulator or physical device.
- **Android**: Open the project in Android Studio and run the app on an emulator or physical device.


## License

Yet to be decided