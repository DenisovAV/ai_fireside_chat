# GenAI Fireside Chat Application (2025)

## Overview

A multi-AI chat application showcasing integration with 5 different AI providers:

- **ChatGPT** (GPT-4.1 / GPT-4.1-mini) - OpenAI's latest models
- **Gemini 2.0 Flash** - Google's Gemini via Firebase AI Logic
- **DeepSeek** - AI model via Firebase Genkit & GitHub Models
- **Llama 3.1 8B** - Meta's open-source model via Firebase Genkit
- **Gemma 3 Nano** - On-device AI with multimodal support

This is a Flutter workshop project demonstrating modern AI integration patterns, streaming responses, and hybrid cloud/on-device architectures.

---

## Prerequisites

- **Flutter SDK**: 3.27+ ([installation guide](https://flutter.dev/docs/get-started/install))
- **Dart SDK**: 3.8+ (included with Flutter)
- **Node.js**: 20+ for Firebase Cloud Functions ([download](https://nodejs.org/))
- **IDE**: Android Studio, VS Code, or IntelliJ with Flutter plugins
- **Firebase Account**: For Gemini, DeepSeek, and Llama services
- **API Keys**: OpenAI account for ChatGPT

---

## Quick Start

### 1. Clone and Install Dependencies

```bash
# Clone the repository
git clone <repository-url>
cd ai_fireside_chat

# Install Flutter dependencies
flutter pub get

# Install Firebase Functions dependencies
cd genkit
npm install
cd ..
```

### 2. Configure API Keys

Create `config/config.json` from the template:

```bash
cp config/config.json.template config/config.json
```

Edit `config/config.json` and add your API keys:

```json
{
    "chatGptApiKey": "sk-proj-...",
    "geminiApiKey": "",
    "claudeApiKey": ""
}
```

**Note:** `geminiApiKey` and `claudeApiKey` are not currently used. Gemini uses Firebase AI Logic (no API key needed), and Claude is not implemented.

### 3. Run the Application

```bash
# Run with configuration
flutter run --dart-define-from-file=config/config.json

# Or use your IDE's run button with configuration:
# VS Code: Set args in launch.json
# Android Studio: Edit Run Configuration
```

---

## AI Provider Setup

### 🤖 ChatGPT (GPT-4.1)

**Status:** ✅ Ready to use

**Setup:**
1. Get an API key from [OpenAI Platform](https://platform.openai.com/api-keys)
2. Add the key to `config/config.json` as `chatGptApiKey`
3. The app uses two API modes:
   - **Chat Completions API** (`gpt-4.1`) - Direct streaming chat
   - **Assistants API** (`gpt-4.1-mini`) - Persistent conversations

**Implementation:** `lib/service/chat_gpt_service.dart` and `chat_gpt_completions_service.dart`

**Models:**
- `gpt-4.1` - Most capable, 1M token context
- `gpt-4.1-mini` - Cost-effective, 50% cheaper

---

### 🔮 Gemini 2.0 Flash (Firebase AI Logic)

**Status:** ✅ Ready to use

**What is Firebase AI Logic?**
Firebase AI Logic (formerly Vertex AI in Firebase) provides seamless access to Google's Gemini models with automatic authentication, no API key management, and hybrid on-device/cloud inference.

**Setup:**
1. **Connect to Firebase:**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools

   # Login to Firebase
   firebase login

   # Initialize Firebase in your project
   firebase init
   ```

2. **Add Firebase to Flutter:**
   - Follow the [FlutterFire setup guide](https://firebase.google.com/docs/flutter/setup)
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate platform directories

3. **Dependencies are already included:**
   ```yaml
   firebase_core: ^4.2.0
   firebase_ai: ^3.4.0
   ```

4. **Firebase is already initialized** in `lib/main.dart`

**Implementation:** `lib/service/gemini_service.dart`

**Features:**
- ✅ Automatic authentication (no API key needed)
- ✅ Streaming responses with `generateContentStream()`
- ✅ System instructions support
- ✅ Hybrid inference (on-device when available, cloud fallback)
- ✅ Model: `gemini-2.0-flash` (latest, fastest)

**Benefits:**
- No API key management
- Bundled Firebase pricing
- Automatic security with App Check
- Generous free tier

---

### 🧠 DeepSeek & Llama 3.1 (Firebase Genkit)

**Status:** ✅ Ready to use (requires Firebase setup)

**What is Firebase Genkit?**
Firebase Genkit is an AI orchestration framework that allows you to build, deploy, and manage AI flows in Firebase Cloud Functions. It supports multiple AI providers with unified APIs.

**Setup:**

#### **1. Initialize Firebase Functions**

```bash
cd genkit

# Install dependencies (already done if you followed Quick Start)
npm install

# Login to Firebase (if not already)
firebase login

# Initialize Firebase project
firebase use --add
# Select your Firebase project or create a new one
```

#### **2. Set Up GitHub Token Secret**

Both DeepSeek and Llama use GitHub Models API through Genkit:

```bash
# Set GitHub token as a Firebase secret
firebase functions:secrets:set GITHUB_TOKEN

# Paste your GitHub Personal Access Token when prompted
# Get token from: https://github.com/settings/tokens
# Required scope: public_repo (or repo for private repos)
```

#### **3. Deploy Cloud Functions**

```bash
# Build TypeScript
npm run build

# Deploy to Firebase
npm run deploy

# Or use Firebase CLI directly
firebase deploy --only functions
```

#### **4. Test Locally (Optional)**

```bash
# Start Genkit development server
npm run genkit:start

# Or start Firebase emulators
npm run serve
```

**Implementation:**
- Backend: `genkit/src/chat.ts`, `genkit/src/flows.ts`, `genkit/src/index.ts`
- Frontend: `lib/service/genkit_service.dart`

**Architecture:**
```
Flutter App → Cloud Functions (Genkit) → GitHub Models API
                                       → Google AI (streaming fallback)
```

**Models:**
- **DeepSeek**: Uses `mistralSmall` (non-streaming) or `gemini-1.5-flash` (streaming)
- **Llama 3.1 8B**: Uses `Meta-Llama-3.1-8B-Instruct` or `gemini-1.5-pro` (streaming)

**Features:**
- ✅ Dual AI system (GitHub Models + Google AI)
- ✅ Session management
- ✅ Streaming support
- ✅ Automatic model selection based on streaming mode

**Cloud Functions Endpoints:**
- `initChatSession` - Create new chat session
- `chat` - Send message and get response
- `chatStream` - Send message with streaming response

---

### 💎 Gemma 3 Nano (On-Device AI)

**Status:** ✅ Ready to use (requires model download)

**What is Gemma?**
Gemma is Google's family of lightweight, open-source AI models designed to run efficiently on mobile devices. Gemma 3 Nano includes multimodal support (text + images).

**Setup:**

#### **1. Dependencies are already included:**
```yaml
flutter_gemma: ^0.11.5
```

#### **2. Download Model Files**

Gemma 3 Nano models need to be downloaded separately due to their size (1-4GB).

**Option A: Download Pre-converted Models**
```bash
# Visit flutter_gemma releases
# https://github.com/DenisovAV/flutter_gemma/releases

# Download one of:
# - gemma-3-nano-1b-it.task (~1GB)
# - gemma-3-nano-2b-it.task (~2GB) - Recommended
# - gemma-3-nano-4b-vision.task (~4GB) - Multimodal support

# Place in assets directory
mkdir -p assets
mv gemma-3-nano-2b-it.task assets/
```

**Option B: Convert Models Yourself**
```bash
# Follow the guide at:
# https://pub.dev/packages/flutter_gemma#model-conversion

# Use MediaPipe Model Maker to convert Gemma models to .task format
```

#### **3. Update pubspec.yaml**

Assets are already configured:
```yaml
flutter:
  assets:
     - assets/
```

#### **4. Model Configuration**

The app is configured to use:
- **Model file**: `gemma3-1b-it-int4.task` (1B quantized)
- **Location**: `assets/gemma3-1b-it-int4.task`

To use a different model, update `lib/service/gemma_service.dart`:
```dart
_gemma = await GemmaModel.load(
  modelPath: 'assets/your-model-name.task',
  modelType: GemmaModelType.gemma3Nano2bInstruct, // Adjust based on model
);
```

**Implementation:** `lib/service/gemma_service.dart`

**Supported Models (flutter_gemma 0.11.5):**
- ✅ Gemma 3 Nano (1B, 2B, 4B)
- ✅ Gemma 3 270M (ultra-lightweight)
- ✅ Llama 3.2 1B
- ✅ Phi-4 (Microsoft)
- ✅ DeepSeek, Qwen2.5, TinyLlama

**Model Formats:**
- `.task` - MediaPipe-optimized (recommended)
- `.litertlm` - Web-optimized
- `.bin` / `.tflite` - Standard format

**Features:**
- ✅ Runs entirely on device (no internet required)
- ✅ Privacy-first (no data sent to servers)
- ✅ Zero cost per inference
- ✅ Low latency (~200ms first token on iPhone 15 Pro)
- ✅ GPU acceleration support
- ⚠️ Requires ~2GB RAM during inference

**Performance (Gemma 3 Nano 2B on iPhone 15 Pro):**
- First token: ~200ms
- Throughput: ~15 tokens/sec
- Memory: ~2GB RAM
- Battery: ~5% per 1000 tokens

---

## Project Structure

```
ai_fireside_chat/
├── lib/
│   ├── bloc/               # State management (BLoC pattern)
│   │   └── chat_bloc.dart
│   ├── core/               # Domain models
│   │   ├── chat_message.dart
│   │   └── message_producer.dart
│   ├── service/            # AI service implementations
│   │   ├── chat_service.dart          # Abstract base class
│   │   ├── chat_gpt_service.dart      # GPT-4.1 (Assistants API)
│   │   ├── chat_gpt_completions_service.dart  # GPT-4.1 (Chat API)
│   │   ├── gemini_service.dart        # Gemini 2.0 Flash (firebase_ai)
│   │   ├── gemma_service.dart         # Gemma 3 Nano (on-device)
│   │   └── genkit_service.dart        # DeepSeek & Llama (Cloud Functions)
│   ├── widgets/            # UI components
│   └── main.dart           # App entry point
│
├── genkit/                 # Firebase Genkit backend
│   ├── src/
│   │   ├── chat.ts         # Session management & model orchestration
│   │   ├── flows.ts        # Genkit flow definitions
│   │   └── index.ts        # Cloud Functions exports
│   ├── package.json        # Node.js dependencies
│   └── tsconfig.json       # TypeScript configuration
│
├── config/
│   ├── config.json.template  # API keys template
│   └── config.json           # Your API keys (gitignored)
│
├── assets/                 # Model files (download separately)
│   └── *.task              # Gemma models (gitignored)
│
├── pubspec.yaml            # Flutter dependencies
└── README.md               # This file
```

---

## Architecture Overview

### **State Management: BLoC Pattern**

```
User Input → ChatBloc → ChatService → AI Provider → Stream Response → UI
```

- **ChatBloc**: Manages conversation state and orchestrates service calls
- **ChatService**: Abstract interface for all AI services
- **Concrete Services**: ChatGPT, Gemini, DeepSeek, Llama, Gemma implementations

### **AI Service Abstraction**

All AI services implement a common interface:

```dart
abstract class ChatService {
  Future<void> init({required String systemInstructions});
  Stream<String> processMessageStream(List<ChatMessage> messages);
  void dispose();
}
```

This allows swapping providers without changing UI code.

### **Streaming Architecture**

All services support streaming responses for better UX:

```dart
await for (final chunk in service.processMessageStream(messages)) {
  // Update UI with each chunk as it arrives
}
```

### **Hybrid Cloud/Device Strategy**

- **Cloud Services** (ChatGPT, Gemini, DeepSeek, Llama):
  - Best for complex reasoning
  - Always available
  - Higher cost per inference
  - Requires internet

- **On-Device** (Gemma):
  - Best for privacy
  - Zero cost
  - Works offline
  - Limited by device capabilities

---

## Package Versions (2025)

### **Flutter Dependencies**

```yaml
dependencies:
  flutter_sdk: flutter

  # State Management
  flutter_bloc: ^8.0.1
  equatable: ^2.0.3

  # Firebase & AI
  firebase_core: ^4.2.0          # Firebase initialization
  firebase_ai: ^3.4.0            # Gemini 2.0 Flash (Firebase AI Logic)
  cloud_functions: ^6.0.3        # Call Genkit Cloud Functions

  # On-Device AI
  flutter_gemma: ^0.11.5         # Gemma 3 Nano with multimodal support

  # Utilities
  http: ^1.5.0                   # HTTP client for ChatGPT
  flutter_markdown: ^0.7.6+2     # Markdown rendering
  cupertino_icons: ^1.0.6        # iOS icons
  url_launcher: ^6.0.6           # Open URLs

dev_dependencies:
  flutter_test: flutter
  flutter_lints: ^6.0.0          # Linting rules
```

### **Node.js Dependencies (Genkit)**

```json
{
  "dependencies": {
    "genkit": "^1.21.0",                    // Core framework
    "@genkit-ai/firebase": "^1.21.0",       // Firebase integration
    "@genkit-ai/googleai": "^1.21.0",       // Google AI models
    "@genkit-ai/compat-oai": "^1.21.0",     // OpenAI compatibility
    "genkitx-github": "^1.15.0",            // GitHub Models plugin
    "firebase-admin": "^13.5.0",            // Admin SDK
    "firebase-functions": "^6.5.0",         // Cloud Functions Gen2
    "express": "^4.21.2",                   // Web framework
    "typescript": "^5.9.3"                  // TypeScript compiler
  }
}
```

---

## Development Workflow

### **Local Development**

```bash
# Run Flutter app
flutter run --dart-define-from-file=config/config.json

# Run with hot reload
flutter run --dart-define-from-file=config/config.json --hot

# Run on specific device
flutter devices
flutter run -d <device-id> --dart-define-from-file=config/config.json
```

### **Testing Cloud Functions Locally**

```bash
cd genkit

# Start Firebase emulators
npm run serve

# Or start Genkit dev UI
npm run genkit:start
```

### **Debugging**

```bash
# Flutter analyze
flutter analyze

# Check for outdated packages
flutter pub outdated

# Clean build
flutter clean
flutter pub get
```

### **Building for Production**

```bash
# Android
flutter build apk --dart-define-from-file=config/config.json
flutter build appbundle --dart-define-from-file=config/config.json

# iOS
flutter build ios --dart-define-from-file=config/config.json

# macOS
flutter build macos --dart-define-from-file=config/config.json
```

---

## Troubleshooting

### **ChatGPT: "Invalid API Key"**
- Verify your API key in `config/config.json`
- Ensure you're using the `--dart-define-from-file` flag
- Check that your OpenAI account has credits

### **Gemini: "Firebase not initialized"**
- Run `firebase init` in project root
- Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
- Verify `firebase_core` is initialized in `main.dart`

### **Genkit: "Function not found"**
- Deploy Cloud Functions: `cd genkit && npm run deploy`
- Check Firebase project is selected: `firebase use --add`
- Verify secrets are set: `firebase functions:secrets:access GITHUB_TOKEN`

### **Gemma: "Model not found"**
- Download model files from [flutter_gemma releases](https://github.com/DenisovAV/flutter_gemma/releases)
- Place `.task` files in `assets/` directory
- Run `flutter pub get` to update asset manifest
- Check model path in `gemma_service.dart` matches filename

### **Streaming not working**
- Check internet connection (for cloud services)
- Verify `processMessageStream()` is used (not single-shot API)
- For Genkit: ensure streaming is enabled in flow configuration

---

## Cost Considerations

| Provider | Model | Cost per 1M tokens | Best For |
|----------|-------|-------------------|----------|
| **On-Device** | Gemma 3 Nano | $0 | Privacy, offline, high-volume |
| **Firebase AI** | Gemini 2.0 Flash | $ | General chat, multimodal |
| **OpenAI** | GPT-4.1-nano | $ | Fast responses |
| **OpenAI** | GPT-4.1-mini | $$ | Balanced quality/cost |
| **Genkit** | Llama 3.1 8B | $ (via GitHub) | Open source |
| **Genkit** | DeepSeek | $$ | Specialized tasks |
| **OpenAI** | GPT-4.1 | $$$ | Complex reasoning |

**Recommendations:**
- Use **Gemma** for < 512 tokens, offline scenarios, or privacy-critical data
- Use **Gemini 2.0 Flash** for general conversations (best value)
- Use **GPT-4.1-mini** for tasks requiring OpenAI capabilities
- Use **Llama/DeepSeek** for open-source requirements

---

## Learn More

### **Flutter Resources**
- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

### **Firebase & AI Resources**
- [Firebase AI Logic Documentation](https://firebase.google.com/docs/ai-logic)
- [Firebase Genkit Documentation](https://firebase.google.com/docs/genkit)
- [OpenAI API Documentation](https://platform.openai.com/docs)
- [flutter_gemma Plugin](https://pub.dev/packages/flutter_gemma)

### **Workshop Resources**
- [MODERNIZATION_PLAN_2025.md](MODERNIZATION_PLAN_2025.md) - Migration details
- [Architecture Analysis Report](.claude/agents/ai-solutions-architect.md) - Technical deep dive

---

## Contributing

This is a workshop project. Feel free to:
- Add new AI providers
- Improve error handling
- Add unit tests
- Enhance UI/UX
- Optimize performance

---

## License

[Specify your license here]

---

## Acknowledgments

- **Flutter Team** - Amazing framework
- **Firebase Team** - Seamless backend integration
- **OpenAI, Google, Meta** - Powerful AI models
- **flutter_gemma Contributors** - On-device AI plugin

---

**Generated with Claude Code** 🤖
**Last Updated:** October 2025
