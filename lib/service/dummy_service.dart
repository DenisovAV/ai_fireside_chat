import 'package:chat/core/message_producer.dart';
import 'package:chat/core/message.dart';
import 'package:chat/service/chat_service.dart';

class DummyService extends ChatService {
  DummyService({required MessageProducer ai}
  ) : super(ai);



  @override
  Future<void> init() async {
  }

  @override
  Future<void> refresh() async {
    await init();
  }

  @override
  Future<String> processMessage(List<ChatMessage> messages) async {
    await Future.delayed(Duration(seconds: 1));
    return 'Hhm... I am not sure what you mean';
  }
}
