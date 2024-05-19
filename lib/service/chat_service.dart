import 'package:chat/core/message.dart';

abstract class ChatService {
  Future<String> processMessage(List<ChatMessage> messages);
}
