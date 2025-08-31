import 'package:chat/core/message_const.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/core/message.dart';
import 'package:chat/service/chat_service.dart';
import 'package:firebase_ai/firebase_ai.dart';

class GeminiService extends ChatService {
  GeminiService() : super(MessageProducer.gemini);

  GenerativeModel? _inferenceModel;
  ChatSession? _chat;

  @override
  Future<void> init({required String systemInstructions}) async {
    this.systemInstructions = systemInstructions;
    try {
      print('GeminiService: Starting initialization...');
      final config = GenerationConfig(
        maxOutputTokens: maxTokens,
        temperature: temperature,
      );
      print('GeminiService: Config created - maxTokens: $maxTokens, temperature: $temperature');
      
      _inferenceModel = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.0-flash',
        generationConfig: config,
        systemInstruction: Content.system(systemInstructions),
      );
      print('GeminiService: Model created successfully');
      
      _chat = _inferenceModel?.startChat();
      print('GeminiService: Chat session started');
    } catch (e) {
      print('GeminiService init error: $e');
      print('GeminiService init error type: ${e.runtimeType}');
      rethrow;
    }
  }

  @override
  Future<void> refresh() async {
    await init(systemInstructions: systemInstructions);
  }

  @override
  Future<String> processMessage(List<ChatMessage> messages) async {
    try {
      print('GeminiService: Processing ${messages.length} messages');
      final chatMessages = Content.multi([...messagesAfter(messages: messages).map((e) => TextPart(e.text))]);
      print('GeminiService: Sending message to Gemini...');
      final response = await _chat?.sendMessage(chatMessages);
      print('GeminiService: Received response from Gemini');
      final answer = response?.text ?? '';
      print('GeminiService: Response text length: ${answer.length}');
      return answer;
    } catch (e) {
      print('GeminiService processMessage error: $e');
      print('GeminiService processMessage error type: ${e.runtimeType}');
      throw Exception('Error: $e');
    }
  }

  @override
  Stream<String> processMessageStream(List<ChatMessage> messages) async* {
    try {
      print('GeminiService: Streaming ${messages.length} messages');
      final chatMessages = Content.multi([...messagesAfter(messages: messages).map((e) => TextPart(e.text))]);
      print('GeminiService: Sending streaming message to Gemini...');
      
      final stream = _chat?.sendMessageStream(chatMessages);
      if (stream != null) {
        await for (final response in stream) {
          final text = response.text;
          if (text != null && text.isNotEmpty) {
            print('GeminiService: Streaming chunk length: ${text.length}');
            yield text;
          }
        }
      }
      print('GeminiService: Streaming completed');
    } catch (e) {
      print('GeminiService processMessageStream error: $e');
      print('GeminiService processMessageStream error type: ${e.runtimeType}');
      throw Exception('Error: $e');
    }
  }
}
