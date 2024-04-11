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

## Gemini (If you are in Europe and AI Studio is not available for you, skip this step, and follow to Vertex AI step)

**Add the Gemini AI API key**
- Follow the link to [Google AI Studio](https://aistudio.google.com/app/apikey) platform and create new API key
- Add this key value to `config/config.json` as **geminiApiKey**
**Add google_generative_ai dependency**
- Uncomment google_generative_ai in pubspec.yaml
- Execute `flutter pub get` using terminal
**Call the Gemini API using plugin**
- Remove placeholder code from `gemini_service.dart`
- Uncomment generative AI SDK call

## Gemma locally (for iOS and Android only, if you would like to launch Gemma in Web, follow to Gamma and Vertex AI step)

**Add flutter_gemma dependency**
- Uncomment google_generative_ai in `pubspec.yaml`
- Execute `flutter pub get` using terminal
**Upload model to device**
- Follow plugin setup manual to upload Gemma to device
**Call the Gemma API using plugin**
- Remove placeholder code from `gemma_service.dart`
- Uncomment flutter_gemma SDK call

## Execute

- Execute the current app using terminal:
     ```
     flutter run --dart-define-from-file=config/config.json
     ```
- Alternatively, use your IDE's run button or shortcuts to launch the app with environment parameters from `config/config.json`

## Gemini with Vertex AI API
**Create a New Project in Firebase** (you also can use already existing account)
- Follow the instruction (Steps 1 and 2) [here](https://firebase.google.com/docs/functions/get-started?gen=2nd#set-up-your-environment-and-the-firebase-cli)
**Enable Vertex API for this project**
- To access the Vertex AI service, you need enable it in the GCP console. The instructions can be found [here](https://cloud.google.com/vertex-ai/docs/featurestore/setup)
**Get the Google Cloud API key and URL**
- Install [Google Cloud Command Line Interface](https://cloud.google.com/sdk/docs/install-sdk)
- Log in to Google Cloud using CLI
    ```
    gcloud auth login
    ```
- Get access token
    ```
    gcloud auth print-access-token
    ```
- Construct your api Url using template from [here](https://cloud.google.com/vertex-ai/generative-ai/docs/model-reference/gemini)
- Add these token and url values to `config/config.json` as **googleCloudApiUrl** and **googleCloudApiKey**

**IMPORTANT NOTICE: The token is valid during one hour, then you have to request it again**

**Call the Gemini API using plugin**
- Replace GeminiService by GeminiVertexService in `service_map.dart`

## Gemini with Vertex AI API and Firebase Cloud Functions (in order not to request new token every hour)
**Deploy Cloud Functions**
- Add the application to your Firebase project, the instruction is [here](https://firebase.google.com/docs/flutter/setup)
- Take a look to code in `functions/src/index.ts`, there is the cloud function
- Deploy the cloud function to your firebase account, there are instructions
**Call the Gemini API using Cloud Functions**
- Remove placeholder code from `gemini_cloud_service.dart`
- Uncomment firebase_core and cloud_functions in `pubspec.yaml`
- Execute `flutter pub get` using terminal
- Uncomment cloud function call
- Uncomment Firebase initialization in main()
- Replace GeminiService by GeminiCloudService in `service_map.dart`
     
## Call Gemma from Google CLoud using REST API
**Deploy Gemma to your Google Cloud project**
- Deploy Gemma to your Cloud from [Models Garden](https://console.cloud.google.com/vertex-ai/model-garden)
**Get deployed Gemma URL**
- Get apiUrl from [Endpoints](https://console.cloud.google.com/vertex-ai/online-prediction)
- Add this URL to `config/config.json` as **gemmaCloudApiUrl** and **googleCloudApiKey**
**Call the Gemma using REST API**
- Uncomment code in gemma_service.dart
- Replace GemmaLocalService by GemmaService in `service_map.dart`

## Call Gemma with Vertex AI and Firebase Cloud Functions

**Call the Gemma model using Cloud Functions**
- Remove placeholder code from `gemma_cloud_service.dart`
- Uncomment cloud function call
- Replace GemmaService by GemmaCloudService in `service_map.dart`

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
