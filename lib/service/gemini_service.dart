import 'package:chat/core/message_producer.dart';
import 'package:chat/core/message.dart';
import 'package:chat/service/chat_service.dart';
import 'package:chat/service/vertex_client.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService implements ChatService {
  const GeminiService();

  static const _apiUrl = String.fromEnvironment('geminiApiUrl');
  static const _apiKey = String.fromEnvironment('googleCloudApiKey');

  @override
  Future<String> processMessage(List<Message> messages) async {
    //TODO: Uncomment implementation of Gemini Call
    await Future.delayed(const Duration(seconds: 1));
    return 'Here will be message by Gemini';
   /* final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
      httpClient: VertexHttpClient(_apiUrl),
    );
    try {
      final config = GenerationConfig(
        maxOutputTokens: 50,
        stopSequences: ['.', '?', '!'],
        temperature: 1,
      );
      final response = await model.generateContent(mergeContent(messages.reversed.map(getEntry)),
          generationConfig: config);
      final cleanedResult = (response.text ?? '').replaceAll('*', '').replaceAll('\n', '.');
      return cleanedResult;
    } catch (e) {
      throw Exception('Error: $e');
    }*/
  }

  Iterable<Content> mergeContent(Iterable<Content> contents) {
    if (contents.isEmpty || contents.length == 1) {
      return contents;
    }

    List<Content> merged = [];
    Content? previousContent;

    for (var content in contents) {
      if (previousContent != null && previousContent.role == content.role) {
        previousContent = Content.multi([...previousContent.parts, ...content.parts]);
      } else {
        if (previousContent != null) {
          merged.add(previousContent);
        }
        previousContent = content;
      }
    }

    if (previousContent != null) {
      merged.add(previousContent);
    }

    return merged;
  }

  Content getEntry(Message message) {
    return message.ai == MessageProducer.gemini
        ? Content.model([TextPart(message.text)])
        : Content.multi([TextPart(message.text)]);
  }
}
