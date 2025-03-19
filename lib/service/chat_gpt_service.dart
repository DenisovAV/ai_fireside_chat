/*import 'dart:convert';

import 'package:chat/core/message.dart';
import 'package:chat/core/message_const.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/service/chat_service.dart';
import 'package:http/http.dart' as http;

class ChatGPTThreadsService extends ChatService {
  ChatGPTThreadsService() : super(MessageProducer.chatgpt);

  static const _apiKey = String.fromEnvironment('chatGptApiKey');
  static const _baseUrl = 'https://api.openai.com/v1';
  String? _threadId;
  String? _assistantId;

  Map<String, String> _headers() => {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
        'OpenAI-Beta': 'assistants=v2',
      };

  @override
  Future<void> init() async {
    try {
      _assistantId = await _getOrCreateAssistant();

      final response = await http.post(
        Uri.parse('$_baseUrl/threads'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        _threadId = json.decode(response.body)['id'];
      } else {
        throw Exception('Failed to initialize chat thread');
      }
    } catch (e) {
      throw Exception('Error initializing thread: $e');
    }
  }

  @override
  Future<void> refresh() async {
    await init();
  }

  Future<void> _addMessagesToThread(List<ChatMessage> messages) async {
    for (final message in messagesAfter(messages: messages)) {
      final response = await http.post(
        Uri.parse('$_baseUrl/threads/$_threadId/messages'),
        headers: _headers(),
        body: json.encode({"role": "user", "content": message.text}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add message to thread');
      }
    }
  }

  Future<String> _startRun() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/threads/$_threadId/runs'),
      headers: _headers(),
      body: json.encode({
        "assistant_id": _assistantId,
        "temperature": temperature,
        "max_completion_tokens": maxTokens,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['id'];
    } else {
      throw Exception('Failed to start AI processing');
    }
  }

  Future<void> _waitForRunCompletion(String runId) async {
    while (true) {
      final response = await http.get(
        Uri.parse('$_baseUrl/threads/$_threadId/runs/$runId'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final status = json.decode(response.body)['status'];
        if (status == 'completed') {
          return;
        }
      } else {
        throw Exception('Failed to check run status');
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<String> _getOrCreateAssistant() async {
    try {
      const String targetName = "AI Chat Assistant";

      final assistantsResponse = await http.get(
        Uri.parse('$_baseUrl/assistants'),
        headers: _headers(),
      );

      if (assistantsResponse.statusCode == 200) {
        final data = json.decode(assistantsResponse.body)['data'] as List;

        for (var assistant in data) {
          if (assistant['name'] == targetName) {
            final assistantId = assistant['id'];
            return assistantId;
          }
        }
      }

      final createResponse = await http.post(
        Uri.parse('$_baseUrl/assistants'),
        headers: _headers(),
        body: json.encode({
          "name": targetName,
          "model": "gpt-4o-mini",
          "instructions": systemInstruction,
        }),
      );

      if (createResponse.statusCode == 200) {
        return json.decode(createResponse.body)['id'];
      } else {
        throw Exception('Failed to create assistant: ${createResponse.body}');
      }
    } catch (e) {
      throw Exception('Error creating assistant: $e');
    }
  }

  Future<String> _getLastAssistantMessage() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/threads/$_threadId/messages'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final messages = json.decode(response.body)['data'] as List;

      final aiMessage = messages.firstWhere(
        (msg) => msg['role'] == 'assistant',
        orElse: () => null,
      );

      if (aiMessage != null) {
        final contentList = aiMessage['content'] as List;
        if (contentList.isNotEmpty && contentList[0]['type'] == 'text') {
          return contentList[0]['text']['value'].toString();
        }
      }

      throw Exception('No AI response found');
    } else {
      throw Exception('Failed to fetch messages: ${response.body}');
    }
  }

  @override
  Future<String> processMessage(List<ChatMessage> messages) async {
    try {
      await _addMessagesToThread(messages);

      final runId = await _startRun();

      await _waitForRunCompletion(runId);

      return await _getLastAssistantMessage();
    } catch (e) {
      throw Exception('Error processing message: $e');
    }
  }
}*/
