import 'package:chat/core/message.dart';
import 'package:chat/core/message_const.dart';
import 'package:chat/core/message_utils.dart';
import 'package:chat/service/chat_service.dart';
//import 'package:flutter_gemma/flutter_gemma.dart';

class GemmaLocalService implements ChatService {
  //final _gemma = FlutterGemmaPlugin.instance..init(maxTokens: 50);

  @override
  Future<String> processMessage(List<Message> messages) async {
    //TODO: Add implementation of Gemma Call
    await Future.delayed(const Duration(seconds: 1));
    return 'Here will be message by Gemma';
    /*final prompt = messages[0].text.prepareQuestion();
    if(await _gemma.isInitialized) {
      final response = await _gemma.getResponse(prompt: prompt);
      final answer = (response ?? '').truncateOn(stopSequences);
      return answer;
    } else {
      return 'Gemma is not initialized yet';
    };*/
  }
}
