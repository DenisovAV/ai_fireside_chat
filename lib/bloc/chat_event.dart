import 'package:chat/core/message_producer.dart';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessage extends ChatEvent {
  final String text;
  final MessageProducer ai;

  const SendMessage(this.ai, {this.text = ''});

  @override
  List<Object> get props => [text, ai];
}

class HumanInterrupt extends ChatEvent {
  const HumanInterrupt();

  @override
  List<Object> get props => [];
}

class ChatInit extends ChatEvent {
  const ChatInit();

  @override
  List<Object> get props => [];
}

class ChatPause extends ChatEvent {
  const ChatPause();

  @override
  List<Object> get props => [];
}

class ChatRestart extends ChatEvent {
  const ChatRestart();

  @override
  List<Object> get props => [];
}
