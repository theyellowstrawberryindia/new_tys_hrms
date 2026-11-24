# TYS HRMS

Employee HRMS Application developed using Flutter.

## GetX project structure

```text
lib/
  main.dart
  app/
    modules/
      attendance/
      auth/
      dashboard/
      home/
      leave/
      profile/
      splash/
      updates/
    core/        # Configuration, platform services, Firebase, and utilities
    data/        # Shared API client and employee model
    shared/      # Reusable widgets, themes, dialogs, and loaders
```

Each module keeps its GetX bindings, controllers, and views together. Add
repositories and models under the owning module's `data/` directory, and keep
widgets used by a single feature under that module's `widgets/` directory.

## Requirements

Flutter 3.44+
Dart 3.12+

## Setup

flutter pub get

## Android

flutter run

## iOS

pod install
flutter run

## Build APK

flutter build apk

## Build AAB

flutter build appbundle

## Build IPA

flutter build ipa

## Company

Yellow Strawberry LLP
