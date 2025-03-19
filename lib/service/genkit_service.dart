/*import 'package:chat/core/message.dart';
import 'package:chat/core/message_const.dart';
import 'package:chat/service/chat_service.dart';
import 'package:cloud_functions/cloud_functions.dart';

class GenkitService extends ChatService {
  String? sessionId;

  GenkitService(super.producer);

  @override
  Future<void> init() async {
    final callable = FirebaseFunctions.instance.httpsCallable('initChatSession');
    final result = await callable.call({
      'modelType': producer.name,
      'systemInstructions': systemInstruction,
      'maxTokens':maxTokens,
      'temperature': temperature,
    });
    sessionId = result.data['sessionId'];
  }

  @override
  Future<void> refresh() async {
    if (sessionId != null) {
      final deleteCallable = FirebaseFunctions.instance.httpsCallable('deleteChatSession');
      await deleteCallable.call({
        'sessionId': sessionId,
      });
      sessionId = null;
    }
    await init();
  }

  @override
  Future<String> processMessage(List<ChatMessage> messages) async {
    if (sessionId == null) {
      throw Exception('Chat session not initialized');
    }

    final callable = FirebaseFunctions.instance.httpsCallable('sendMessagesToChat');
    final result = await callable.call({
      'sessionId': sessionId,
      'modelType': producer.name,
      'systemInstructions': systemInstruction,
      'maxTokens':maxTokens,
      'temperature': temperature,
      'messages': messagesAfter(messages: messages).map((m) => m.text).toList(),
    });

    return result.data['response'];
  }
}*/
