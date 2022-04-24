# diginote

This app uses a companion app [Diginote Screen](https://github.com/kelvin589/diginotescreen) to display messages. A documentation page for the public libraries can be found [here](https://kelvin589.github.io/diginote/).

## Table of Contents
* [Overview](#overview)
* [Features](#features)
* [Possible Improvements](#possible-improvements)
* [Setup](#setup)

## Overview
The aim of this project was to develop a prototype of an electronic Post-It note system which a member of staff (specifically, university lecturers) can display via a mobile device placed on the door to their office. 

Using a remote mobile dashboard, it allows a staff member to leave notices as to his/her office presence and associated availability, to post real-time messages for people who are expected at their office, etc. 

Its core purpose was to ensure that availability is communicated clearly and easily under different contexts of use to planned and prospective visitors to the individuals’ office.

[![Diginote Demo](https://img.youtube.com/vi/rFyTfdWfLe4/0.jpg)](https://www.youtube.com/watch?v=rFyTfdWfLe4 "Diginote Demo")

## Features
* User authentication
* Easy screen pairing
* Screen 'preview' to add messages or insert templates, and position them
* Various message customisation options
* Message scheduling
* Message templates
* Screen presence notifications
* Low battery notifications

## Possible Improvements
* Add more customisation options.
* Design and usbility improvements.
* Make the pairing process simpler. For example, using a QR code.
* Add MFA to prevent malicious usage.
* Additional login and registration providers.
* Integrate with ID scanners to know who is present at the screen.
* Integrate with other applications, such as a calendar app and weather app.
* More complex message scheduling.
* Analytics with various metrics.
* Two-way communication (e.g., text chat).
* GeoFencing to display messages based on the location of the remote.
* Automatic analysis and creation of templates for frequently created messages.
* Make the preview view easier to use.
* Speech to text.
* Favourites option for templates.
* Help section or tutorial for new users.

## Setup
1. Setup your development environment by following the official Flutter guide
    * https://docs.flutter.dev/get-started/install
    * Follow the first two steps (1. Install and 2. Set up an editor)
2. Setup an emulator (iOS, Android, Chrome, etc.)
3. Follow the Firebase guide to install and setup Firebase CLI
    * https://firebase.google.com/docs/cli
4. Run ```dart pub global activate flutterfire_cli``` to install FlutterFire CLI
5. Register for a firebase account (note: the project must be on the Blaze plan for notifications and the QR code to work properly)
6. Open Firebase console
7. Set up Authentication
    * Enable the email/password provider
9. Set up Firestore Database
    * Set up the security rules to allow for read and write
11. Set up Realtime Database
    * Set up the security rules to allow for read and write
13. Set up Firebase Cloud Functions (see the [diginote_cloud_functions](https://github.com/kelvin589/diginote_cloud_functions) repository)
15. Clone the project to get a local copy
``` bash
git clone https://github.com/kelvin589/diginote
```
16. Change your directory to the project folder
``` bash
cd diginote
```
17. Install dependencies
``` bash
flutter pub get
```
18. Initialise FlutterFire from the project's root
``` bash
flutterfire configure
```
20. Open main.dart and run the project on an emulator
