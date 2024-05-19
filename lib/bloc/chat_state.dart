import 'package:chat/core/message.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  const ChatState(this.messages);

  final List<ChatMessage> messages;

  @override
  List<Object> get props => [messages];
}

class ChatInputState extends ChatState {
  const ChatInputState(super.messages);
}

class ChatPauseState extends ChatState {
  const ChatPauseState(super.messages);
}

class ChatMessagesLoaded extends ChatState {
  const ChatMessagesLoaded(super.messages);

  @override
  List<Object> get props => [messages];
}

class ChatMessageProcessing extends ChatState {
  const ChatMessageProcessing(super.messages);
}

class ChatMessageError extends ChatState {
  final String error;
  final String stackTrace;

  const ChatMessageError(this.error, this.stackTrace, super.messages);

  @override
  List<Object> get props => [error];
}
