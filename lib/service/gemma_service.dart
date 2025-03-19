/*import 'package:chat/core/message.dart';
import 'package:chat/core/message_const.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/service/chat_service.dart';
import 'package:flutter_gemma/core/chat.dart';
import 'package:flutter_gemma/core/model.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma/pigeon.g.dart';

class GemmaService extends ChatService {
  GemmaService() : super(MessageProducer.gemma);

  InferenceModel? _inferenceModel;
  InferenceChat? _chat;

  final _gemma = FlutterGemmaPlugin.instance;

  @override
  Future<void> init() async {
    await _gemma.modelManager.installModelFromAsset('model.task');
    _inferenceModel = await _gemma.createModel(
      modelType: ModelType.gemmaIt,
      preferredBackend: PreferredBackend.cpu,
      maxTokens: 512,
    );
    await initSession();
  }

  Future<void> initSession() async {
    _chat = await _inferenceModel?.createChat(
      temperature: 1.0,
      randomSeed: 1,
      topK: 1,
      topP: 0.9,
      tokenBuffer: 128,
    );
  }

  @override
  Future<String> processMessage(List<ChatMessage> messages) async {
    for (final m in messagesAfter(messages: messages)) {
      await _chat?.addQueryChunk(Message(text: m.text, isUser: true));
    }
    return await _chat?.generateChatResponse() ?? '';
  }

  @override
  Future<void> refresh() async {
    await _chat?.clearHistory();
  }
}*/
