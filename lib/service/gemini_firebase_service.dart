import 'package:chat/core/message_const.dart';
import 'package:chat/core/message_utils.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/core/message.dart';
import 'package:chat/service/chat_service.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';

class GeminiFirebaseService implements ChatService {
  GeminiFirebaseService();

  final utils = ContentUtils<Content>();

  @override
  Future<String> processMessage(List<ChatMessage> messages) async {
    final model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-1.5-pro-preview-0409',
    );
    try {
      final config = GenerationConfig(
        maxOutputTokens: maxTokens,
        stopSequences: stopSequences,
        temperature: temperature,
      );
      final response = await model.generateContent(
          utils.mergeContent(
            contents: messages.reversed.map(getEntry),
            check: check,
            create: create,
          ),
          generationConfig: config);
      final answer = response.text ?? '';
      return answer;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  bool check(Content previous, Content next) => previous.role == next.role;

  Content create(Content previous, Content next) =>
      Content.multi([...previous.parts, ...next.parts]);

  Content getEntry(ChatMessage message) {
    return message.ai == MessageProducer.gemini
        ? Content.model([TextPart(message.text)])
        : Content.multi([TextPart(message.text)]);
  }
}
