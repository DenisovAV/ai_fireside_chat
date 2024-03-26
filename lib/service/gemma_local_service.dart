import 'dart:convert';

import 'package:chat/core/message.dart';
import 'package:chat/service/chat_service.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class GemmaLocalService implements ChatService {
  const GemmaLocalService();

  static const MethodChannel _channel = MethodChannel('GEMMA');

  @override
  Future<String> processMessage(List<Message> messages) async {
    try {
      return await _channel.invokeMethod('GEMMA_ANSWER', {'input': messages[0].text});
    } on PlatformException catch (e) {
      return "Failed to process string: '${e.message}'.";
    }
  }
}
