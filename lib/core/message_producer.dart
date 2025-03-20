import 'package:chat/service/chat_gpt_completions_service.dart';
import 'package:chat/service/chat_gpt_service.dart';
import 'package:chat/service/chat_service.dart';
import 'package:chat/service/firebase_service.dart';
import 'package:chat/service/gemini_service.dart';
import 'package:chat/service/gemma_service.dart';
import 'package:chat/service/genkit_service.dart';

enum MessageProducer {
  chatgpt,
  claude,
  llama,
  gemini,
  firebase,
  gemma,
  human;

  static final _chatGPTService = ChatGPTService();
  static final _geminiService = GeminiService();
  static final _firebaseService = FirebaseVertexService();

  static final _gemmaService = GemmaService();
  static final _llamaService = GenkitService(MessageProducer.llama);
  static final _claudeService = GenkitService(MessageProducer.claude);

  ChatService? get service => switch (this) {
        MessageProducer.chatgpt => _chatGPTService,
        MessageProducer.gemini => _geminiService,
        MessageProducer.gemma => _gemmaService,
        MessageProducer.firebase => _firebaseService,
        MessageProducer.claude => _claudeService,
        MessageProducer.llama => _llamaService,
        _ => null
      };
}
