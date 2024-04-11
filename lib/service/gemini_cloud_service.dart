import 'package:chat/core/message_const.dart';
import 'package:chat/core/message_utils.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/core/message.dart';
import 'package:chat/service/chat_service.dart';
import 'package:cloud_functions/cloud_functions.dart';

class GeminiCloudService implements ChatService {
  GeminiCloudService();

  final utils = ContentUtils<Map<String, Object>>();

  @override
  Future<String> processMessage(List<Message> messages) async {
    //TODO: Uncomment implementation of Gemini Call
    await Future.delayed(const Duration(seconds: 1));
    return 'Here will be message by Gemini';
    /*try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'geminiCall',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      final HttpsCallableResult result = await callable.call({
        'contents': [
          ...utils.mergeContent(
            contents: messages.map(getEntry),
            check: check,
            create: create,
          )
        ],
        'stopSequences': stopSequences,
        'maxTokens': maxTokens,
        'temperature': temperature,
        //Add parameters
      });
      final String answer = result.data['result'];
      return answer.prepareAnswer();
    } catch (e) {
      throw Exception('Error: $e');
    }*/
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

  bool check(Map<String, Object> previous, Map<String, Object> next) =>
      previous['role'] == next['role'];

  Map<String, Object> create(Map<String, Object> previous, Map<String, Object> next) => {
        'role': 'user',
        'parts': [
          {'text': (previous['parts'] as List<Map<String, String?>>)[0]['text']},
          {'text': (next['parts'] as List<Map<String, String?>>)[0]['text']},
        ]
      };
}
