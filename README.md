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
    flutter run --dart-define-from-file=config/config.json

    ```
- Alternatively, use your IDE's run button or shortcuts to launch the app.

## ChatGPT via REST API

**Add the Chat GPT API key**
 - Follow the link to [OpenAI developer](https://platform.openai.com/api-keys) platform and create new API key
 - Add this key value to `config/config.json` as **chatGptApiKey**
**Call the Chat GPT Completions API using REST API**
 - Uncomment `chat_gpt_completions_service.dart`
 - Replace DummyService by ChatGptService in `service_map.dart`
**Call the Chat GPT Assistant API using REST API**
- Uncomment `chat_gpt_service.dart`
- Replace DummyService by ChatGPTThreadsService in `service_map.dart`

## Gemini via plugin

**Add the Gemini AI API key**
- Follow the link to [Google AI Studio](https://aistudio.google.com/app/apikey) platform and create new API key
- Add this key value to `config/config.json` as **geminiApiKey**
**Add google_generative_ai dependency**
- Uncomment google_generative_ai in pubspec.yaml
- Execute `flutter pub get` using terminal
**Call the Gemini API using plugin**
- Uncomment `gemini_service.dart`
- Replace DummyService by GeminiService in `service_map.dart`

## Gemma locally

**Add flutter_gemma dependency**
- Uncomment flutter_gemma in `pubspec.yaml`
- Execute `flutter pub get` using terminal
**Upload model to device and setup**
- Follow plugin setup manual to upload Gemma to device from [here](https://pub.dev/packages/flutter_gemma)
**Call the Gemma API using plugin**
- Uncomment `gemma_service.dart`
- Replace DummyService by GemmaService in `service_map.dart`

## Gemini via Vertex AI Firebase API

**Connect Firebase project**
- Add the application to your Firebase project, the instruction is [here](https://firebase.google.com/docs/flutter/setup)
**Add firebase_vertexai dependency**
- Uncomment firebase_vertexai and firebase_core in `pubspec.yaml`
- Execute `flutter pub get` using terminal
**Call the Gemini API using Vertex AI Firebase API**
- Uncomment `firebase_service.dart`
- Uncomment Firebase initialization in main()
- Replace DummyService by FirebaseVertexService in `service_map.dart`

## Claude and Llama via Firebase Genkit
**Install Genkit**
- Follow the instruction to install Genkit from [here](https://firebase.google.com/docs/genkit/get-started)
- Use API ANTHROPIC_API_KEY and GITHUB_TOKEN instead of GEMINI_API_KEY
- Play with the Genkit flows using the Genkit Dev UI, launch using claude or llama, details are [here](https://firebase.google.com/docs/genkit/devtools)
**Deploy flows to Firebase as Cloud Functions**
- Change a pricing plan to start using Cloud Functions
- Follow the deployment instruction from [here](https://firebase.google.com/docs/genkit/firebase)
- Don't forget to make API credentials available to deployed flows (ANTHROPIC_API_KEY and GITHUB_TOKEN)
**Add cloud_functions dependency**
- Uncomment cloud_functions in `pubspec.yaml`
- Execute `flutter pub get` using terminal
**Call the Claude or Llama using Genkit**
- Uncomment `genkit_service.dart`
- Replace DummyService by GenkitService in `service_map.dart`

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
