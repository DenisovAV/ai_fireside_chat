import 'package:chat/core/message_producer.dart';
import 'package:chat/core/message.dart';
import 'package:chat/service/chat_service.dart';
import 'package:cloud_functions/cloud_functions.dart';

class GeminiCloudService implements ChatService {
  const GeminiCloudService();

  @override
  Future<String> processMessage(List<Message> messages) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'geminiCall',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      final HttpsCallableResult result = await callable.call({
        'contents': [...mergeContent(messages.map(getEntry))],
      });
      return result.data['result'].replaceAll('*', '').replaceAll('\n', '.');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Map<String, Object> getEntry(Message message) {
    final result = {
      'role': message.ai == MessageProducer.gemini ? 'model' : 'user',
      'parts': [
        {'text': message.text}
      ]
    };
    return result;
  }

  Iterable<Map<String, Object>> mergeContent(Iterable<Map<String, Object>> contents) {
    if (contents.isEmpty || contents.length == 1) {
      return contents;
    }

    List<Map<String, Object>> merged = [];
    Map<String, Object>? previousContent;

    for (var content in contents) {
      if (previousContent != null && previousContent['role'] == content['role']) {
        previousContent = {
          'role': 'user',
          'parts': [
            {'text': (previousContent['parts'] as List<Map<String, String?>>)[0]['text']},
            {'text': (content['parts'] as List<Map<String, String?>>)[0]['text']},
          ]
        };
      } else {
        if (previousContent != null) {
          merged.add(previousContent);
        }
        previousContent = content;
      }
    }

    if (previousContent != null) {
      merged.add(previousContent);
    }

    return merged;
  }
}
