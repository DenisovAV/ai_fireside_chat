import 'package:chat/service/chat_gpt_service.dart';
import 'package:chat/service/chat_service.dart';
import 'package:chat/service/gemini_service.dart';
import 'package:chat/service/gemma_local_service.dart';

enum MessageProducer {
  chatgpt,
  gemini,
  gemma,
  human;

  ChatService? get service => switch (this) {
        MessageProducer.chatgpt => const ChatGPTService(),
        MessageProducer.gemini => GeminiService(),
        MessageProducer.gemma => GemmaLocalService(),
        _ => null
      };
}
