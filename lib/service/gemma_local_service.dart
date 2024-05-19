import 'package:chat/core/message.dart';
import 'package:chat/core/message_const.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/core/message_utils.dart';
import 'package:chat/service/chat_service.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

class GemmaLocalService implements ChatService {
  final _gemma = FlutterGemmaPlugin.instance..init(maxTokens: 50);
  
  int countTokens(String text) {
    if (text.isEmpty) {
      return 0;
    }
    RegExp regExp = RegExp(r'\w+');
    Iterable<RegExpMatch> matches = regExp.allMatches(text);

    return matches.length;
  }

  @override
  Future<String> processMessage(List<ChatMessage> messages) async {
    if (await _gemma.isInitialized) {
      final response = await _gemma.getChatResponse(messages: messages.take(1).map(getEntry));
      final answer = (response ?? '').truncateOn(stopSequences);
      return answer;
    } else {
      return 'Gemma is not initialized yet';
    }
  }

  Message getEntry(ChatMessage message) {
    return message.ai == MessageProducer.gemma
        ? Message(text: message.text)
        : Message(text: message.text, isUser: true);
  }
}
