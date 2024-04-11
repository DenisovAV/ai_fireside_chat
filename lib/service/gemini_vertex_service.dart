import 'package:chat/service/gemini_service.dart';
import 'package:chat/service/vertex_client.dart';

class GeminiVertexService extends GeminiService {
  GeminiVertexService()
      : super(
          client: VertexHttpClient(_apiUrl),
          apiKey: _apiKey,
        );

  static const _apiUrl = String.fromEnvironment('googleCloudApiUrl');
  static const _apiKey = String.fromEnvironment('googleCloudApiKey');
}
