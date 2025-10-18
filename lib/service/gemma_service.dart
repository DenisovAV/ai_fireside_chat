import 'package:chat/core/message.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/service/chat_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_gemma/flutter_gemma.dart';

class GemmaService extends ChatService {
  GemmaService() : super(MessageProducer.gemma);

  InferenceModel? _inferenceModel;
  InferenceChat? _chat;

  @override
  Future<void> init({required String systemInstructions}) async {
    this.systemInstructions = systemInstructions;

    // ✅ MODERN API (0.11.5): FlutterGemma.installModel() Fluent API
    final modelFile = kIsWeb
      ? 'gemma3-1b-it-int4-web.task'
      : 'gemma-3n-E2B-it-int4.task';

    await FlutterGemma.installModel(
      modelType: ModelType.gemmaIt,
      fileType: ModelFileType.task,
    )
      .fromAsset(modelFile)
      .install();

    _inferenceModel = await FlutterGemma.getActiveModel(
      maxTokens: 1024,
      preferredBackend: PreferredBackend.gpu, // Web requires GPU
    );
    await initSession();
  }

  Future<void> initSession() async {
    _chat = await _inferenceModel?.createChat(
      temperature: 1.0,
      randomSeed: 1,
      topK: 1,
      topP: 0.9,
      tokenBuffer: 256,
    );
    
    // Add system instructions as initial context
    if (systemInstructions.isNotEmpty) {
      await _chat?.addQueryChunk(Message.systemInfo(
        text: systemInstructions
      ));
    }
  }

  @override
  Future<String> processMessage(List<ChatMessage> messages) async {
    for (final m in messagesAfter(messages: messages)) {
      await _chat?.addQuery(Message(text: m.text, isUser: true));
    }
    final response = await _chat?.generateChatResponse();
    if (response is TextResponse) {
      return response.token;
    }
    return response?.toString() ?? '';
  }

  @override
  Stream<String> processMessageStream(List<ChatMessage> messages) async* {
    for (final m in messagesAfter(messages: messages)) {
      await _chat?.addQuery(Message(text: m.text, isUser: true));
    }

    final stream = _chat?.generateChatResponseAsync();
    if (stream != null) {
      await for (final response in stream) {
        if (response is TextResponse) {
          yield response.token;
        }
      }
    }
  }

  @override
  Future<void> refresh() async {
    await _chat?.clearHistory();
  }
}