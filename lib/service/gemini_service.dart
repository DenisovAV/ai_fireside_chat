import 'package:chat/core/message_const.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/core/message.dart';
import 'package:chat/core/message_utils.dart';
import 'package:chat/service/chat_service.dart';
//import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart';

class GeminiService implements ChatService {
  GeminiService({
    this.client,
    this.apiKey = _apiKey,
  });

  final Client? client;
  final String apiKey;

  //final utils = ContentUtils<Content>();

  static const _apiKey = String.fromEnvironment('geminiApiKey');

  @override
  Future<String> processMessage(List<ChatMessage> messages) async {
    //TODO: Uncomment implementation of Gemini Call
    await Future.delayed(const Duration(seconds: 1));
    return 'Here will be message by Gemini';
  /*final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
      httpClient: client,
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
    }*/
  }

  /*bool check(Content previous, Content next) => previous.role == next.role;

  Content create(Content previous, Content next) =>
      Content.multi([...previous.parts, ...next.parts]);

  Content getEntry(ChatMessage message) {
    return message.ai == MessageProducer.gemini
        ? Content.model([TextPart(message.text)])
        : Content.multi([TextPart(message.text)]);
  }*/
}
