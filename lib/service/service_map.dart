import 'package:chat/core/message_producer.dart';
import 'package:chat/service/chat_gpt_service.dart';
import 'package:chat/service/chat_service.dart';
import 'package:chat/service/gemini_service.dart';
import 'package:chat/service/gemma_service.dart';

const serviceMap = <MessageProducer, ChatService>{
  MessageProducer.chatgpt: ChatGPTService(),
  MessageProducer.gemini: GeminiService(),
  MessageProducer.gemma: GemmaService(),
};
