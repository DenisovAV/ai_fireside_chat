import 'package:chat/core/message_const.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/core/message.dart';
import 'package:chat/service/chat_service.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';

class FirebaseVertexService extends ChatService {
  FirebaseVertexService() : super(MessageProducer.firebase);

  GenerativeModel? _inferenceModel;
  ChatSession? _chat;

  @override
  Future<void> init() async {
    final config = GenerationConfig(
      maxOutputTokens: maxTokens,
      temperature: temperature,
    );
    _inferenceModel = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash',
      generationConfig: config,
      systemInstruction: Content.system(systemInstruction),
    );
    _chat = _inferenceModel?.startChat();
  }

  @override
  Future<void> refresh() async {
    await init();
  }

  @override
  Future<String> processMessage(List<ChatMessage> messages) async {
    try {
      final chatMessages = Content.multi([...messagesAfter(messages: messages).map((e) => TextPart(e.text))]);
      final response = await _chat?.sendMessage(chatMessages);
      final answer = response?.text ?? '';
      return answer;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
