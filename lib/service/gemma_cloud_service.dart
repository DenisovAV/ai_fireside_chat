import 'package:chat/core/message_const.dart';
import 'package:chat/core/message_utils.dart';
import 'package:chat/core/message.dart';
import 'package:chat/service/chat_service.dart';
//import 'package:cloud_functions/cloud_functions.dart';

class GemmaCloudService implements ChatService {
  GemmaCloudService();

  final utils = ContentUtils<Map<String, Object>>();

  @override
  Future<String> processMessage(List<Message> messages) async {
    //TODO: Add implementation of Gemma Call
    await Future.delayed(const Duration(seconds: 1));
    return 'Here will be message by Gemma';
    /*final prompt = messages[0].text.prepareQuestion();

    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'gemmaPredict',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      final HttpsCallableResult result = await callable.call({
        'contents': prompt,
        'stopSequences': stopSequences,
        'maxTokens': maxTokens,
        'temperature': temperature,
      });
      final String answer = result.data['result'];
      return answer.prepareAnswer(prompt: prompt);
    } catch (e, s) {
      throw Exception('Error: $e $s');
    }*/
  }
}
