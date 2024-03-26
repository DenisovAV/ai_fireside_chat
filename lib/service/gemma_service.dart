import 'dart:convert';

import 'package:chat/core/message.dart';
import 'package:chat/service/chat_service.dart';
import 'package:http/http.dart' as http;

class GemmaService implements ChatService {
  const GemmaService();

  static const _apiUrl = String.fromEnvironment('gemmaCloudApiUrl');
  static const _apiKey = String.fromEnvironment('googleCloudApiKey');

  @override
  Future<String> processMessage(List<Message> messages) async {
    //TODO: Add implementation of Gemma Call
    await Future.delayed(const Duration(seconds: 1));
    return 'Here will be message by Gemma';
    /*try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'instances': [
            {
              'prompt': '${messages[0].text}.',
              'max_tokens': 50,
              'temperature': 1,
              'top_p': 1,
              'top_k': 10,
            }
          ]
        }),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<int> bytes = latin1.encode(data['predictions'][0]);
        return utf8
            .decode(bytes)
            .replaceAll('Prompt:\n${messages[0].text}.\nOutput:\n', '')
            .replaceAll('\n', '.')
            .replaceAll('*', '.');
      } else {
        throw Exception('Failed to process message');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }*/
  }
}
