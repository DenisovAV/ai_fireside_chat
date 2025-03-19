import 'package:chat/core/message.dart';
import 'package:chat/core/message_producer.dart';

typedef CheckCallback = bool Function(ChatMessage value);

abstract class ChatService {
  final MessageProducer producer;

  Future<void> init();
  Future<void> refresh();
  Future<String> processMessage(List<ChatMessage> messages);

  ChatService(this.producer);

  bool check(ChatMessage check) => check.ai == producer;

  Iterable<ChatMessage> messagesAfter({required List<ChatMessage> messages}) {
    final reversedMessages = messages.reversed.toList();
    final int lastOneIndex = reversedMessages.toList().lastIndexWhere(check);

    if (lastOneIndex == -1) {
      return reversedMessages;
    } else {
      return reversedMessages.sublist(lastOneIndex + 1);
    }
  }
}
