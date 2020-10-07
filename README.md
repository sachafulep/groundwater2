## Introduction
This repository contains all the code for the backend and the frontend, but also the designs and some necessary documentation to keep you up-to-date with the features.

### Structure
```
Groundwater
├─.github
│ └─workflows
├─app
│ ├─android
│ ├─assets
│ ├─ios
│ ├─lib
│ │ ├─model
│ │ │ └─data
│ │ │   ├─decision_tree
│ │ │   ├─lectoraat
│ │ │   ├─note
│ │ │   ├─sensor
│ │ │   ├─setting
│ │ │   ├─user
│ │ │   └─weather
│ │ ├─network
│ │ ├─ui
│ │ │ ├─auth
│ │ │ ├─dashboard
│ │ │ ├─decision_tree
│ │ │ ├─details
│ │ │ ├─intro
│ │ │ └─settings
│ │ └─utils
│ └─test
├─backend
│ ├─gradle
│ └─src
│   ├─main
│   │ ├─kotlin
│   │ │ └─com
│   │ │   └─ground
│   │ │     └─water
│   │ │       ├─controllers
│   │ │       ├─model
│   │ │       │ ├─forms
│   │ │       │ ├─objects
│   │ │       │ ├─projections
│   │ │       │ └─repositories
│   │ │       ├─security
│   │ │       ├─service
│   │ │       └─utils
│   │ └─resources
│   └─test
├─design
└─docs
```

##### Continous Integration
For the continuous integration, we are using GitHub actions to automatically lint, test and build the app and backend. All the workflows are situated in .github/workflows.

##### Android App
For the app, we are using Flutter as a hybrid platform to create an app for iOS and Android. All code is situated in the `lib` folder, where the UI is separated from the network and the models. All data classes and the model are situated in the `model` folder, while all the API's are situated in the `network` folder and all UI related elements like activities and dialogs are in the `ui` folder.

##### Backend
We are using Spring Boot as a framework for the backend, which is written in Kotlin. Every call for the backend (except verify sensor) can only be done by passing the OAuth access token with the call, so everything is OAuth secured. We are currently using Auth0 for the easy integration with the app. For notifications in the app, we are using Firebase Cloud Messaging for easy integration.

##### Design
Of course we designed the app ourselves, and the corresponding Adobe XD file can be found in the design folder. All artboards of the design are also exported and can be viewed individually in design.zip, where they are numbered in a `flow` that makes sure that almost every ascending number originates from the previous number (E.g. from 1. intro to 2. authentication).

##### Documentation
Some documentation about the functionality of the app as well as the backend is in this folder, including class diagrams which make it easier to understand the structure that we use for our backend as well as the lectorate's backend.

## [Setup Frontend](app/README.md)
For information on how to get the app to work on your machine, go to [here](app/README.md)

## [Setup Backend](backend/README.md)
For information on how to get the backend to work on your machine, go to [here](backend/README.md)

## Migration (moving away from Auth0 and Firebase)
### Auth0 (Using the OAuth Authorization Code flow)
For ease of integrating Google and possibly Facebook later on, we decided that the best way is to use Auth0's SDK, as it allowed us to easily integrate multiple OAuth providers without having to manually implement each one. In the app, we are using the auth0 library that allows us to communicate to Auth0 without having to manually create network requests. In the backend, we are also using the auth0 library but it can be replaced by any library as it's only purpose is to decode the JWT token.

If you would like to stop using auth0, it is possible but requires some work. If you would like to, for example, switch to Google authentication, you need to implement the Google authentication in the app, as well as some changes to the backend JWT verification as it differs from auth0. Most of the verification and handling is done in the `utils/Utils.kt`, so that's probably the only place where you have to change something for the authentication in the backend. For the app however, I am not quite sure what to do, because we chose for auth0 so we don't have to manually implement it, so my best guess is that you'll either need to find a library that handles the OAuth for you, or edit the authentication function at `network/api.dart` to handle the OAuth flow yourself.

### Firebase
In order to send push notifications to all users, we decided that the best possible way to do this is by using Firebase Cloud Messaging, as it is very reliable and easy to use. We have two Firebase projects, called `Grondwater Development` for development and `Grondwater` for release, both of which are currently owned by the Google account for this project (groundwater.aad@gmail.com).

If you would like to replace Firebase Cloud Messaging with another Cloud Push Notification solution, you will need to change the `service/NotificationService.kt`, `service/FirebaseMessagingService.kt` and the `utils/FirebaseConfig.kt` to your desired provider. For the app, you only have to change the `main.dart` where the initialization happens, and the `model/model.dart` where it is centralized. You will also need to manually remove the google-services.json in /android/app, and modify the build.gradle files in /android and /android.app as it contains Firebase reliabilities like Google Play Services for example.

## Scalability
Based on the input of the client and the current usage of the system, the system will scale very well. There are currently about 10 sensors, of which we estimate that there are 3 people per sensor that use the app. This is a total of 30 people using the app, which will ofcourse expand in the future. Based on this amount of people, and possibly more people in the future, we foresee no problems of scalability with the backend / database or whatsoever. We have never talked about "thousands" of people using the app, and we therefore have not taken that too much into consideration, but we expect it to be at least scalable to serve 1000 people if the VPS that it is hosted on has a sufficient amount of memory (4 - 8 Gb RAM) and a multicore processor.
