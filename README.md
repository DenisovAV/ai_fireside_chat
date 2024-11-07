# GenAI Fireside Chat application

## Workshop

This project is a starting point for a Flutter application.

## Prerequisites

- Ensure you have Flutter installed on your development machine. If not, visit the [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- An IDE that supports Flutter (e.g., Android Studio, VS Code) is recommended.
- A Google account for Firebase and Google Cloud setup.

## Run a Flutter Project Template
- Execute the current app using terminal:
     ```
     flutter pub get
     flutter run
     ```
- Alternatively, use your IDE's run button or shortcuts to launch the app.

## ChatGPT

**Add the Chat GPT API key**
 - Follow the link to [OpenAI developer](https://platform.openai.com/api-keys) platform and create new API key
 - Add this key value to `config/config.json` as **chatGptApiKey**
**Call the Chat GPT API using REST API**
 - Remove placeholder code from `chat_gpt_service.dart`
 - Uncomment REST API call

## Gemini

**Add the Gemini AI API key**
- Follow the link to [Google AI Studio](https://aistudio.google.com/app/apikey) platform and create new API key
- Add this key value to `config/config.json` as **geminiApiKey**
**Add google_generative_ai dependency**
- Uncomment google_generative_ai in pubspec.yaml
- Execute `flutter pub get` using terminal
**Call the Gemini API using plugin**
- Remove placeholder code from `gemini_service.dart`
- Uncomment generative AI SDK call

## Gemma locally

**Add flutter_gemma dependency**
- Uncomment flutter_gemma in `pubspec.yaml`
- Execute `flutter pub get` using terminal
**Upload model to device and setup**
- Follow plugin setup manual to upload Gemma to device from [here](https://pub.dev/packages/flutter_gemma)
**Call the Gemma API using plugin**
- Remove placeholder code from `gemma_local_service.dart`
- Uncomment flutter_gemma SDK call

## Execute

- Execute the current app using terminal:
     ```
     flutter run --dart-define-from-file=config/config.json
     ```
- Alternatively, use your IDE's run button or shortcuts to launch the app with environment parameters from `config/config.json`

## Gemini with Vertex AI Firebase API
**Connect Firebase project**
- Add the application to your Firebase project, the instruction is [here](https://firebase.google.com/docs/flutter/setup)
**Call the Gemini API using Vertex AI Firebase API**
- Remove placeholder code from `gemini_fireabase_service.dart`
- Uncomment firebase_core and firebase_vertexai in `pubspec.yaml`
- Execute `flutter pub get` using terminal
- Uncomment Firebase initialization in main()
- Replace GeminiVertexService by GeminiFirebaseService in `service_map.dart`
**Call the Gemini API using plugin**
- Replace GeminiService by GeminiVertexService in `message_producer.dart`

## Gemini with Vertex AI API and Firebase Cloud Functions (as Server Proxy)
**Create a New Project in Firebase** (you also can use already existing account)
- Follow the instruction (Steps 1 and 2) [here](https://firebase.google.com/docs/functions/get-started?gen=2nd#set-up-your-environment-and-the-firebase-cli)
  **Enable Vertex API for this project**
- To access the Vertex AI service, you need enable it in the GCP console. The instructions can be found [here](https://cloud.google.com/vertex-ai/docs/featurestore/setup)
**Deploy Cloud Functions**
- Take a look to code in `functions/src/index.ts`, there is the cloud function
- Deploy the cloud function to your firebase account, there are instructions
**Call the Gemini API using Cloud Functions**
- Remove placeholder code from `gemini_cloud_service.dart`
- Uncomment cloud_functions in `pubspec.yaml`
- Execute `flutter pub get` using terminal
- Uncomment Firebase initialization in main()
- Replace GeminiFirebaseService by GeminiCloudService in `message_producer.dart`

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
