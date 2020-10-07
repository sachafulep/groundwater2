# Installation Guide
### Install Android Studio
Make sure you have Android Studio installed. If you don't have Android Studio you can download it through the Jetbrains Toolbox or at the following page:
[https://developer.android.com/studio/](https://developer.android.com/studio/)

### Install Android Studio plugin
Add the Flutter plugin to your android studio (Go to File > Settings > Plugins > Flutter) and restart android studio.

### Install Flutter SDK
Install the Flutter SDK, which can be found [here](https://flutter.dev/docs/get-started/install). Make sure to follow the steps that are given there, otherwise it won't work.

## Run the app with the backend
If you want the app to connect to the backend, you will need to reverse a port (otherwise the emulator can't reach the host machine's port.

To make sure your emulator or phone can connect to the backend, run the following command:
```
adb reverse tcp:8080 tcp:8080
```

## Run tests
To run the tests either run them via Android Studio itself or run the following command:
```
flutter test
```