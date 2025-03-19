/*import 'dart:convert';

import 'package:chat/core/message.dart';
import 'package:chat/core/message_const.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/service/chat_service.dart';
import 'package:http/http.dart' as http;

class ChatGPTService extends ChatService {
  ChatGPTService() : super(MessageProducer.chatgpt);

  static const _apiKey = String.fromEnvironment('chatGptApiKey');
  static const _baseUrl = 'https://api.openai.com/v1';

  Map<String, String> _headers() => {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      };

  @override
  Future<void> init() async {}

  @override
  Future<void> refresh() async {}

  @override
  Future<String> processMessage(List<ChatMessage> messages) async {
    try {
      final chatMessages = <Map<String, String>>[];

      if (systemInstruction.isNotEmpty) {
        chatMessages.add({"role": "system", "content": systemInstruction});
      }

      for (final message in messages.toList()) {
        chatMessages.add({"role": message.ai == MessageProducer.chatgpt ? "assistant" : "user", "content": message.text});
      }

      final body = json.encode({
        "model": "gpt-4o",
        "messages": chatMessages,
        "temperature": temperature,
        "max_tokens": maxTokens,
      });

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: _headers(),
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final completion = jsonResponse['choices'][0]['message']['content'];
        return completion.trim();
      } else {
        throw Exception('OpenAI API error: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error processing message: $e');
    }
  }
}*/
