# diginote

This app uses a companion app [Diginote Screen](https://github.com/kelvin589/diginotescreen) to display messages. 

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
* Add MFA to prevent malicious messages.
* Integrate with ID scanners to know who is present at the screen.
* More complex message scheduling.
* Analytics with various metrics.
* Two-way communication.
* Display alternative content by integrating with other apps, such as a calendar app.

## Setup
To run this project:
1. Clone the project to get a local copy
``` bash
git clone https://github.com/kelvin589/diginote
```
2. cd into the project folder
``` bash
cd diginote
```
3. Install dependencies
``` bash
flutter pub get
```
4. Setup Firebase
5. Update ```firebase_options_example.dart``` with your Firebase configuration
6. Run the application in an emulator.
