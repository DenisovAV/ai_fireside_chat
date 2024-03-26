# GenAI Fireside Chat application

## Workshop

This project is a starting point for a Flutter application.

## Prerequisites

- Ensure you have Flutter installed on your development machine. If not, visit the [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- An IDE that supports Flutter (e.g., Android Studio, VS Code) is recommended.
- A Google account for Firebase and Google Cloud setup.

## Run a Flutter Project Teplate
- Execute the current app using terminal:
     ```
     flutter pub get
     flutter run
     ```
- Alternatively, use your IDE's run button or shortcuts to launch the app.

## Create a New Project in Firebase
## Enable Vertex API for this project
- To access the Vertex AI service, you need enable it in the GCP console. The instructions can be found here: https://cloud.google.com/vertex-ai/docs/featurestore/setup.
## Get the Google Cloud API key and URL
- Get your apiUrl here: https://cloud.google.com/vertex-ai/generative-ai/docs/model-reference/gemini
- Vertex AI uses tokens for authentication. Instead of generating the key in the Google AI Studio, we have to generate the token using the gcloud CLI.
    1. Install Google Cloud SDK Google Cloud SDK : https://cloud.google.com/sdk/docs/install-sdk
    2. Log in
     ```
     gcloud auth login
     ```
    3. Print token
     ```
     gcloud auth print-access-token
     ```
## Call the Vertex API
- Uncomment google_generative_ai in pubspec.yaml
- Add apiKey and your apiUrl to config.json
- Uncomment code in gemini_service.dart
- Execute the current app using terminal:
     ```
     flutter pub get
     flutter run --dart-define-from-file=config/config.json
     ```

## Get the Chat GPT API key

## Call the Chat GPT API

## Connect Firebase to your app
- Install the required command line tools
   1. If you haven't already, install the Firebase CLI. 
   2. Log into Firebase using your Google account by running the following command:
     ```
     firebase login
     ```
  3. Install the FlutterFire CLI by running the following command from any directory:
     ```
     dart pub global activate flutterfire_cli
     ```
- Configure your apps to use Firebase
  1. Use the FlutterFire CLI to configure your Flutter apps to connect to Firebase.
  2. From your Flutter project directory, run the following command to start the app configuration workflow:
     ```
     flutterfire configure
     ```
     
## Call Gemma from Google CLoud
- Deploy Gemma to your Cloud from Models Garden: https://console.cloud.google.com/vertex-ai/publishers/google/model-garden
- Get apiUrl from Endpoints: https://console.cloud.google.com/vertex-ai/online-prediction
- Add apiUrl to config.json
- Uncomment code in gemma_service.dart
- Execute the current app using terminal:
     ```
     flutter run --dart-define-from-file=config/config.json
     ```


For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
