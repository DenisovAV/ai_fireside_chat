import 'dart:math';

import 'package:chat/core/message_producer.dart';
import 'package:chat/core/message.dart';
import 'package:chat/service/chat_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final Map<MessageProducer, ChatService> _serviceMap;

  ChatBloc(
    this._serviceMap,
  ) : super(const ChatInputState([])) {
    on<SendMessage>((event, emit) async {
      final loading = Message(text: '', ai: event.ai, isLoading: true);
      final messages = <Message>[...state.messages]..insert(0, loading);
      emit(ChatMessageProcessing(messages));
      try {
        final messages = <Message>[...state.messages]..remove(loading);
        late String response;
        if (event.ai != MessageProducer.human) {
          response = await _serviceMap[event.ai]?.processMessage(messages) ?? '';
        } else {
          response = event.text;
        }
        if (state.messages.contains(loading)) {
          messages
            ..remove(loading)
            ..insert(0, Message(text: response, ai: event.ai));
          emit(ChatMessagesLoaded(messages));
          _startNewMessage();
        }
      } catch (e) {
        emit(ChatMessageError(e.toString(), state.messages));
      }
    });

    on<HumanInterrupt>((event, emit) {
      final messages = <Message>[...state.messages]..removeWhere((e) => e.isLoading);
      emit(ChatInputState(messages));
    });

    on<ChatPause>((event, emit) {
      if (state is! ChatPauseState) {
        final messages = <Message>[...state.messages]..removeWhere((e) => e.isLoading);
        emit(ChatPauseState(messages));
      } else {
        _startNewMessage();
      }
    });

    on<ChatRestart>((event, emit) {
      emit(const ChatInputState([]));
    });
  }

  void _startNewMessage() {
    final list = MessageProducer.values
        .where((value) => value != state.messages.first.ai && value != MessageProducer.human)
        .toList();
    add(SendMessage(list[Random().nextInt(list.length)]));
  }
}
