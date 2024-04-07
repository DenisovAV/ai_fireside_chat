import 'dart:convert';

import 'package:chat/core/message.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/service/chat_service.dart';
import 'package:http/http.dart' as http;

class ChatGPTService implements ChatService {
  const ChatGPTService();

  static const _apiKey = String.fromEnvironment('chatGptApiKey');

  @override
  @override
  Future<String> processMessage(List<Message> messages) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Here will be message by ChatGPT';
    /*try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'gpt-4-turbo-preview',
          'max_tokens': 50,
          'temperature': 1,
          'stop': ['.', '?', '!'],
          'messages': messages.reversed.map((e) => getEntry(e, e == messages.first)).toList(),
        }),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<int> bytes = latin1.encode(data['choices'][0]['message']['content']);
        final cleanedResult = (utf8.decode(bytes) ?? '').replaceAll('*', '').replaceAll('\n', '');
        return cleanedResult;
      } else {
        throw Exception('Failed to process message');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }*/
  }

  Map<String, String> getEntry(Message message, bool isLast) {
    return {
      'role': message.ai == MessageProducer.chatgpt ? 'assistant' : 'user',
      'content': message.text
    };
  }
}
