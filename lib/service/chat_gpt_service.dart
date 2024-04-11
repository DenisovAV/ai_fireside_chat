import 'dart:convert';

import 'package:chat/core/message.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/core/message_utils.dart';
import 'package:chat/service/chat_service.dart';
import 'package:http/http.dart' as http;

import '../core/message_const.dart';

class ChatGPTService implements ChatService {
  const ChatGPTService();

  static const _apiKey = String.fromEnvironment('chatGptApiKey');

  @override
  @override
  Future<String> processMessage(List<Message> messages) async {
    //TODO: Uncomment implementation of ChatGPT Call
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
          'max_tokens': maxTokens,
          'temperature': temperature,
          'stop': stopSequences,
          'messages': messages.reversed.map((e) => getEntry(e, e == messages.first)).toList(),
        }),
      );
      if (response.statusCode == 200) {
        final String content = json.decode(response.body)['choices'][0]['message']['content'];
        return content.latinToUtf().prepareAnswer();
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
