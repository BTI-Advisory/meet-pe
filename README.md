# meet-pe

Meet People Mobile is a Flutter application built to demonstrate the use of modern development tools with best practices implementation like Modularization, BLoC, Dependency Injection, Dio, Hive, Freezed, Shimmer, Testing, Flavor, etc...

## Table Of Content

- [Getting Started](#getting-started)
    * [Requirement](#requirement)
    * [Setup](#setup)
- [Modularization Structure](#modularization-structure)
- [Clean Architecture Flow](#clean-architecture-flow)
- [Built With](#built-with)
- [Global Config](#global-config)
- [l10n](#l10n)
- [Signing](#signing)
- [Versionning](#versionning)
- [Build with flavors](#build-with-flavors)


---

## Getting Started

### Requirement

1. Flutter SDK Stable (3.29.3) [Install](https://flutter.dev/docs/get-started/install)
2. Android Studio [Install](https://developer.android.com/studio)
3. Visual Studio Code (Optional) [Install](https://code.visualstudio.com/)
4. Extension **Dart** dan **Flutter**:
    -  **Intellij Platform** ([Dart](https://plugins.jetbrains.com/plugin/6351-dart), [Flutter](https://plugins.jetbrains.com/plugin/9212-flutter))
    -  **Visual Studio Code** ([Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code), [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter))

### Setup

**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/BTI-Advisory/meet-pe.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies:

```
flutter pub get 
```

**Step 3:**

This project uses `inject` library that works with code generation, execute the following command to generate required files:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

or watch command in order to keep the source code synced automatically:

```
flutter packages pub run build_runner watch
```

### Modularization Structure


    # Root Project
    .
    ├── features               # Name of directory
    |   ├── feature A          # Feature module with a clean architecture inside it.
    |   ├── feature B
    |   └── feature etc
    |
    ├── lib                    # Name of module (default from Flutter)
    |
    └── shared                 # Name of directory
        ├── component          # Component module Custom widget which can be used repeatedly..
        ├── core               # Module that create classes, global and core functions(Dependency injection / Manager Local data / Remote data / Base UseCases ......)
        ├── dependencies       # Handle global dependency/library version updates.
        ├── preferences        # ThemeData global (Dark/light).
        └── l10n               # Data translation.
    
    
     # Template Module (Feature)
     Feature Module               # Name of directory.
        ├── name_module           # Name of module.
        ├── src                  
        │   ├── data              # Local, Remote, Repository: data handlers.
        │   ├── domain            # UserCases+Repository.
        │   ├── presentation      # Business logic component + UI.
        │   ├── module            # Dependency injection.
        │  



### Clean Architecture Flow

<h3 align="center">Clean Architecture Flow (Feature Module)</h3>

<br />

<img src="./architecture.png" style="display: block; margin-left: auto; margin-right: auto; width: 75%;"/>


### Built With

* [BLoC Pattern](https://bloclibrary.dev/) - Business logic component to separate the business logic with UI.
* [Dio](https://pub.dev/packages/dio/) - A type-safe HTTP client.
* [Json Serializable](https://pub.dev/packages/json_serializable) - Builders for handling JSON.
* [Freezed](https://pub.dev/packages/freezed/) - Code generator for unions/pattern-matching/copy.
* [Hive](https://pub.dev/packages/hive/) -  Lightweight and blazing fast key-value database written in pure Dart..
* [Get It](https://pub.dev/packages/get_it) - A Dependency Injection
* [intl](https://pub.dev/packages/intl/) - Provides internationalization and localization facilities .
* [auto_route](https://pub.dev/packages/auto_route/) - AutoRoute is a declarative routing solution, where everything needed for navigation is automatically generated for you.
* [Shimmer](https://pub.dev/packages/shimmer) - Loading handler.
* Handle State - (Loading, No Data, Has Data, No Internet Connection, Request Timeout, Error).
* [Extension Methods](https://dart.dev/guides/language/extension-methods)



### l10n

This project uses `l10n` to internationalize the application.
You can add your patterns in the intl_en.arb or intl_fr.arb as key value.
After every changes in this two files you must run this command to build the changes.

```
flutter pub run intl_utils:generate
```


### Signing

**Android :**
To sign the android app you can find the jks file under this path :
android/key/KeyStore.jks
Before building the release, you must add a file key.properties under the android folder and specify this values :

```
storePassword=<password>
keyPassword=<password>
keyAlias=<password>
storeFile=../key/KeyStore.jks
```

To recover the password you must ask permission from your superiors.

**Ios :**

To recover the provisionning profile you must ask permission from your superiors.



### Versioning

You can change the version of the app from pubspec.yaml by changing this line :
```
version: 1.0.0+1
```

It has two parts separated by a +, the first part is the build name (versionName Android / CFBundleShortVersionString iOS) and the second part is the build number (versionCode Android / CFBundleVersion iOS).

Also you can change the version of the app automatically at the build by running :
```
flutter build apk --build-name=1.0.3 --build-number=3
```
