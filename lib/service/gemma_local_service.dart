import 'package:chat/core/message.dart';
import 'package:chat/core/message_utils.dart';
import 'package:chat/service/chat_service.dart';
import 'package:flutter_gemma/flutter_gemma_platform_interface.dart';

class GemmaLocalService implements ChatService {
  final _gemma = Gemma.instance..init(maxTokens: 50);

  @override
  Future<String> processMessage(List<Message> messages) async {
    //TODO: Add implementation of Gemma Call
    await Future.delayed(const Duration(seconds: 1));
    return 'Here will be message by Gemma';
    /*final prompt = messages[0].text.prepareQuestion();
    final response = await _gemma.getResponse(prompt: prompt);
    final answer = (response ?? '').prepareAnswer();
    return answer;*/
  }
}
