Technologies
============

Flutter
-------

The target audience of this app is the general population that suffers from problems stemming from high and rising groundwater levels. We cannot expect these users to have a specific type of mobile device, either iPhone or Android. In order to write an application that supports both of these platforms we have a number of choices:

-   Two native applications

-   A hybrid application

-   A web application

### Android developers

Our team consists solely of developers that have experience with Android. Besides the lack of experience with developing for iOS, we also lack the required hardware: Apple computers. Apple requires a computer running macOS with XCode to develop for their platform.

### Single codebase

If we were to develop an application for both operating systems we would have to maintain two codebases. Due to the relatively short timeframe for development, this is not advisable. A hybrid framework allows us to write a single codebase for both mobile platforms. 

### Performance and Reliability

The advantage that web applications have of being supported by all platforms that have a modern browser is at the same time a large disadvantage. Since it runs in the browser it is most likely going to be less performant than a native application. Web applications are also limited in their access to native hardware such as Bluetooth, which we require.

### Time

Due to their limitations when it comes to native hardware and the likelihood of being less performant we have decided against using a web application to ensure only having to develop a single codebase.

Because of the time constraint and the complete lack of experience or hardware required for developing a native iOS application the approach of developing two native applications is also off the table.

### Hybrid application

This project requires the following of us to develop an application:

-   In a limited time frame,

-   While maintaining a high degree of code quality,

-   While testing all the different aspects of the system,

-   While documenting everything to ensure easy onboarding and informing of future developers

Therefore we have decided that a hybrid framework would fit our use case better than writing two native apps.

There are a number of hybrid frameworks to choose from. Before this project, we have gained some experience with a number of them. For most of us, this experience has been less than optimal. These frameworks were:

-   Ionic

-   Nativescript 

-   React native

### Ionic / React Native / Nativescript

One of the reasons we have decided against using Ionic is the large file base needed for a single application which makes development less streamlined. When it comes to NativeScript the documentation is highly lacking. Lastly, React Native requires developers to do a lot of manual styling in order to create a native look and feel.

One framework we have not had the chance to work with was the Flutter framework.

Flutter alongside the programming language Dart is maintained by Google the owners and maintainers of the Android operating system which runs on most phones nowadays. Flutter is generally seen as a more reliable and robust framework compared to others that may use techniques such as using webviews and web components, Flutter compiles to native code, which is often more performant and stable. More advantages of Flutter are nice to have things for the developers such as live reloading and the fact that the web will likely be supported in the future as well.

### Graph

In order to display a graph in our application we went looking for a suitable flutter plugin. We decided on a plugin called "charts". It is an unofficial google product. We decided to use this plugin over another that we tried because it has the required features that the other lacked such as: drawing custom tags above selected data points and allowing almost complete freedom in customizing the look of the graph. It also has a fairly large amount of example code to draw inspiration from and an acceptable ease of use.

The other plugin that we tried to use for a while is called fl_chart. Unlike charts, it is still actively being developed by a small number of contributors on github. However, while trying to implement the graph we ran into multiple problems like not being able to change the size of the graph, and taps on screen not being registered correctly. Therefore we decided that it would probably be more time efficient to find an alternative instead of potentially wasting more time on trying to get this one working.

Architecture 
-------------

<img alt="Architecture" src="../images/architecture.png">

1.  The Flutter app 

For this project, we are going to develop a hybrid app using Flutter. This app will give users insight into measurements made by groundwater sensors and historical weather data from a weather API as well as predicted groundwater levels.

A group of civil engineering students have previously done a project regarding the problems surrounding the rising groundwater levels. We have implemented a part of their research in our app which is called a decision tree. This decision tree allows users to make an educated decision on a course of action to try and find a solution for their problems.

Users will be able to users register their own sensor in the application, which allows it to broadcast its findings over the things network. The app backend is used to login and register new users as well as registering the sensor.

2.  Sensor backend

The Smart Cities lectoraat has created a backend which makes the sensor data available to us. One of the requirements of the project is to be able to add personal notes to specific data points. This "note" model does not yet exist, however, we will provide a specification which after being accepted will be implemented.

The API will mostly be used to request sensor data to be displayed in the app. If the note specification is implemented it will be used to create notes as well. In the Flutter app on the advanced statistics page, users can select which sensor's data they want to display. A sensor's location is stored in the sensor backend. The sensor backend obtains the measurements made by the groundwater sensors through the things network

3.  App backend 

The sensor backend developed by the Smart Cities lectoraat does not store user accounts. Because we want users to have to login in order to view sensor data and register new groundwater sensors, a separate backend will have to be developed. This backend will handle user logins and user registrations.

4.  Weather API

We are going to display weather data from an external API in the Flutter application. This data will come in the form of historical, current, and future weather data. Users will be able to see a correlation between the weather and the groundwater levels in graphs. Besides this, the weather data will also be used to send notifications that might warn users in time for rising groundwater levels.

5.  The Things Network

Provides a global open LoRa network. It receives the data that is sent from the groundwater sensors, which can then be requested through the sensor backend. New sensors will also have to be registered in The Things Network.

6.  LoRaWan

LoRaWan stands for Long Range Wide Area Network. Groundwater sensors will send their data through this network to The Things Network.

7.  Groundwater sensor

The groundwater sensor is housed in a four-meter long tube. The sensor uses ultrasonic frequencies to measure the groundwater level underneath it. It is also able to measure the temperature and the time at which the measurement is made. Measurements are done regularly, and their results are then transferred through LoRaWan to the things network.