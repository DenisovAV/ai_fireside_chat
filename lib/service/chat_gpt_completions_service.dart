import 'dart:convert';

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
  Future<void> init({required String systemInstructions}) async {
    this.systemInstructions = systemInstructions;
  }

  @override
  Future<void> refresh() async {}

  @override
  Future<String> processMessage(List<ChatMessage> messages) async {
    try {
      final chatMessages = <Map<String, String>>[];

      if (systemInstructions.isNotEmpty) {
        chatMessages.add({"role": "system", "content": systemInstructions});
      }

      for (final message in messages.toList()) {
        chatMessages.add({"role": message.ai == MessageProducer.chatgpt ? "assistant" : "user", "content": message.text});
      }

      final body = json.encode({
        "model": "gpt-4.1",
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

  @override
  Stream<String> processMessageStream(List<ChatMessage> messages) async* {
    try {
      final chatMessages = <Map<String, String>>[];

      if (systemInstructions.isNotEmpty) {
        chatMessages.add({"role": "system", "content": systemInstructions});
      }

      for (final message in messages.toList()) {
        chatMessages.add({"role": message.ai == MessageProducer.chatgpt ? "assistant" : "user", "content": message.text});
      }

      final body = json.encode({
        "model": "gpt-4.1",
        "messages": chatMessages,
        "temperature": temperature,
        "max_tokens": maxTokens,
        "stream": true,
      });

      final request = http.Request('POST', Uri.parse('$_baseUrl/chat/completions'));
      request.headers.addAll(_headers());
      request.body = body;

      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
          final lines = chunk.split('\n');
          for (final line in lines) {
            if (line.startsWith('data: ') && !line.contains('[DONE]')) {
              try {
                final jsonStr = line.substring(6);
                final jsonResponse = json.decode(jsonStr);
                final delta = jsonResponse['choices'][0]['delta'];
                if (delta['content'] != null) {
                  yield delta['content'];
                }
              } catch (e) {
                // Skip invalid JSON chunks
              }
            }
          }
        }
      } else {
        throw Exception('OpenAI API streaming error: ${streamedResponse.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error processing stream message: $e');
    }
  }
}
