import 'package:chat/core/message_producer.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  const Message({required this.text, required this.ai, this.isLoading = false});

  final String text;
  final MessageProducer ai;
  final bool isLoading;

  @override
  List<Object> get props => [text, ai, isLoading];
}
