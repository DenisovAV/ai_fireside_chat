import 'package:chat/service/chat_gpt_completions_service.dart';
import 'package:chat/service/chat_gpt_service.dart';
import 'package:chat/service/chat_service.dart';
import 'package:chat/service/dummy_service.dart';
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

  static final _chatGPTService = DummyService(ai: MessageProducer.chatgpt);
  static final _geminiService =  DummyService(ai: MessageProducer.gemini);
  static final _firebaseService =DummyService(ai: MessageProducer.firebase);

  static final _gemmaService = DummyService(ai: MessageProducer.gemma);
  static final _llamaService = DummyService(ai: MessageProducer.llama);
  static final _claudeService = DummyService(ai: MessageProducer.claude);

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
