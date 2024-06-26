import 'package:chat/core/message_producer.dart';
import 'package:chat/service/chat_gpt_service.dart';
import 'package:chat/service/chat_service.dart';
import 'package:chat/service/gemini_cloud_service.dart';
import 'package:chat/service/gemini_firebase_service.dart';
import 'package:chat/service/gemini_service.dart';
import 'package:chat/service/gemini_vertex_service.dart';
import 'package:chat/service/gemma_local_service.dart';
import 'package:chat/service/gemma_service.dart';

final serviceMap = <MessageProducer, ChatService>{
  MessageProducer.chatgpt: const ChatGPTService(), //ChatGPT
  MessageProducer.gemini: GeminiService(),  //Gemini, GeminiVertex, GeminiFirebase, GeminiCloud
  MessageProducer.gemma: GemmaLocalService(), //Gemma, GemmaLocal
};
