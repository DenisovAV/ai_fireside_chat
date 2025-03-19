/*import 'package:chat/core/message_const.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/core/message.dart';
import 'package:chat/service/chat_service.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService extends ChatService {
  GeminiService({
    this.apiKey = _apiKey,
  }) : super(MessageProducer.gemini);

  final String apiKey;

  static const _apiKey = String.fromEnvironment('geminiApiKey');
  GenerativeModel? _inferenceModel;
  ChatSession? _chat;

  @override
  Future<void> init() async {
    final config = GenerationConfig(
      maxOutputTokens: maxTokens,
      temperature: temperature,
    );
    _inferenceModel = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
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
}*/
