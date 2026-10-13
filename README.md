<div align="center">
  <img src="assets/images/logo.png" alt="FitCPX logo" width="220" />

  # FitCPX — Student App

  **Flutter mobile companion app for students using the FitCPX fitness management platform.**

  [Português](README.pt-BR.md) · [FitCPX Web](https://github.com/Allyyssoonnn/fitcpx-web) · [FitCPX Backend](https://github.com/Allyyssoonnn/fitcpx-backend) · [FitCPX Website](https://fitcpx.com)
</div>

---

## Overview

**FitCPX – Aluno** is the student-facing mobile application in the FitCPX ecosystem. It connects students to workouts, physical assessments, scheduled activities, messages, and contracts managed through the main FitCPX platform.

The app is developed with Flutter and Dart for Android and iOS. Its navigation uses five primary areas: **Home, Assessments, Workouts, Chat, and Account**.

## Features

- **Workouts and sessions:** access assigned workouts, view exercise details, follow sessions, and record training progress.
- **Workout history:** review previous sessions and share workout summaries.
- **Physical assessments:** view measurements, follow changes, attach progress images, and submit assessments.
- **Scheduling:** review available events and request attendance through the calendar flow.
- **Student chat:** exchange messages through the FitCPX backend.
- **Contracts:** access student contracts and related payment information.
- **Timers and notifications:** workout timers, local alerts, and Firebase Cloud Messaging push notifications.
- **Authentication:** student sign-in, account management, and password recovery.

Features and access depend on the student account and the services enabled by their FitCPX professional or organization.

## Technology

| Area | Technology |
| --- | --- |
| Application | Flutter, Dart |
| State management | `flutter_bloc` |
| Navigation | `go_router`, Cupertino UI |
| Networking | Dio, interceptors |
| Messaging and notifications | Firebase Cloud Messaging, Flutter Local Notifications |
| Local persistence | Shared Preferences, SQLite |
| Reporting and sharing | PDF/printing, `share_plus` |
| Media and visuals | Cached Network Image, charts, video playback |

## Project structure

```text
lib/
├── main.dart               # App startup, Firebase initialization and providers
└── src/
    ├── blocs/             # Application state and events
    ├── core/              # HTTP client and interceptors
    ├── models/            # Data models
    ├── routes/            # Navigation
    ├── screens/           # Feature detail screens
    ├── services/          # FitCPX API requests
    ├── utils/             # Environment and utility helpers
    ├── views/             # Main tabs and authentication
    └── widgets/           # Reusable components
android/                   # Android application
ios/                       # iOS application
assets/                    # Images, audio and templates
```

## Configuration and local development

This application is **part of the FitCPX platform**, not a standalone service. A compatible FitCPX backend and appropriate student account are required to exercise authenticated features.

1. Install a compatible Flutter SDK (the project declares Dart SDK `^3.8.1`).
2. Run `flutter pub get` in the repository root.
3. Configure the Firebase client for the Android/iOS application you intend to run. The native `google-services.json` and `GoogleService-Info.plist` are Firebase **client configuration**, not server-side service-account credentials. Use your own Firebase project for a separate deployment and restrict its API keys appropriately.
4. Review `lib/src/utils/variables.dart` **before launching**. The checked-in default is the FitCPX production API. For development, configure an isolated backend/environment and test account; do not run experiments against production data.
5. After selecting a safe environment, run `flutter run` on a configured Android or iOS device.

### Android release signing

The project reads `android/key.properties` to configure its Android release signing key. Signing passwords, `key.properties`, keystores, and certificates are private and must never be committed. `android/key[example].properties` documents the expected property names; fill out a private local copy when needed.

## Connected repositories

- **[fitcpx-web](https://github.com/Allyyssoonnn/fitcpx-web)** — web platform.
- **[fitcpx-backend](https://github.com/Allyyssoonnn/fitcpx-backend)** — backend services and APIs consumed by the mobile app.

The independently developed exercise-library application is a different FitCPX ecosystem project, not part of this repository.

## Development history

This repository retains the original application development history, beginning in **July 2025**. It reflects the evolution of a commercial application, rather than an isolated demonstration project.

## License

No open-source license is currently provided. Public source availability does not, by itself, authorize redistribution or commercial reuse.
