import 'package:chat/service/chat_gpt_completions_service.dart';
import 'package:chat/service/chat_service.dart';
import 'package:chat/service/gemini_service.dart';
import 'package:chat/service/genkit_service.dart';
import 'package:chat/service/gemma_service.dart';

enum MessageProducer {
  chatgpt,
  deepseek,
  llama,
  gemini,
  gemma,
  human;

  static final _chatGPTService = ChatGPTService();
  static final _geminiService = GeminiService();
  static final _deepseekService = GenkitService(MessageProducer.deepseek);
  static final _llamaService = GenkitService(MessageProducer.llama);
  static final _gemmaService = GemmaService();

  ChatService? get service => switch (this) {
        MessageProducer.chatgpt => _chatGPTService,
        MessageProducer.gemini => _geminiService,
        MessageProducer.deepseek => _deepseekService,
        MessageProducer.llama => _llamaService,
        MessageProducer.gemma => _gemmaService,
        _ => null
      };
}
