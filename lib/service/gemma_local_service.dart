import 'package:chat/core/message.dart';
import 'package:chat/core/message_const.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/core/message_utils.dart';
import 'package:chat/service/chat_service.dart';
//import 'package:flutter_gemma/flutter_gemma.dart';

class GemmaLocalService implements ChatService {
  //final _gemma = FlutterGemmaPlugin.instance..init(maxTokens: 50);

  @override
  Future<String> processMessage(List<ChatMessage> messages) async {
    //TODO: Uncomment implementation of Gemma Call
    await Future.delayed(const Duration(seconds: 1));
    return 'Here will be message by Gemma';
    /*if (await _gemma.isInitialized) {
      final response = await _gemma.getChatResponse(messages: messages.take(1).map(getEntry));
      final answer = (response ?? '').truncateOn(stopSequences);
      return answer;
    } else {
      return 'Gemma is not initialized yet';
    }*/
  }

  /*Message getEntry(ChatMessage message) {
    return message.ai == MessageProducer.gemma
        ? Message(text: message.text)
        : Message(text: message.text, isUser: true);
  }*/
}
