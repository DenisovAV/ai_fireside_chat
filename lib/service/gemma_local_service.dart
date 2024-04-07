import 'package:chat/core/message.dart';
import 'package:chat/service/chat_service.dart';
//import 'package:flutter_gemma/flutter_gemma_platform_interface.dart';

class GemmaLocalService implements ChatService {
  //final _gemma = Gemma.instance..init(maxTokens: 50);

  @override
  Future<String> processMessage(List<Message> messages) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Here will be message by Gemma';
    /*final prompt = ['.', '?', '!'].contains(messages[0].text[messages[0].text.length - 1])
        ? messages[0].text
        : '${messages[0].text}?';
    final response = await _gemma.getResponse(prompt: prompt);
    final cleanedResult = (response ?? '').replaceAll('*', '').replaceAll('\n', '');
    return cleanedResult;*/
  }
}
