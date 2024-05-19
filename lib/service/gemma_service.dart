import 'dart:convert';

import 'package:chat/core/message.dart';
import 'package:chat/core/message_const.dart';
import 'package:chat/core/message_utils.dart';
import 'package:chat/service/chat_service.dart';
import 'package:http/http.dart' as http;

class GemmaService implements ChatService {
  const GemmaService();

  static const _apiUrl = String.fromEnvironment('gemmaCloudApiUrl');
  static const _apiKey = String.fromEnvironment('googleCloudApiKey');

  @override
  Future<String> processMessage(List<ChatMessage> messages) async {
    //TODO: Uncomment implementation of Gemini Call
    await Future.delayed(const Duration(seconds: 1));
    return 'Here will be message by Gemma';
  /*final prompt = messages[0].text.prepareQuestion();
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'instances': [
            {
              'prompt': prompt,
              'max_tokens': maxTokens,
              'temperature': temperature,
            }
          ]
        }),
      );
      if (response.statusCode == 200) {
        final String data = json.decode(response.body)['predictions'][0];
        return data.latinToUtf().truncateOn(stopSequences).prepareAnswer(prompt: prompt);
      } else {
        throw Exception('Failed to process message');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }*/
  }
}
