import 'dart:math';

import 'package:chat/core/message_const.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/core/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatLoadingState([])) {
    on<SendMessage>((event, emit) async {
      final loading = ChatMessage(text: '', ai: event.ai, isLoading: true);
      final msg = <ChatMessage>[...state.messages]..insert(0, loading);
      emit(ChatMessageProcessing(msg));
 //     try {
        final messages = <ChatMessage>[...state.messages]..remove(loading);
        late String response;
        if (event.ai != MessageProducer.human) {
          response = await event.ai.service?.processMessage(messages) ?? '';
        } else {
          response = event.text;
        }
        if (state.messages.contains(loading)) {
          messages
            ..remove(loading)
            ..insert(0, ChatMessage(text: response, ai: event.ai));
          emit(ChatMessagesLoaded(messages));
          _startNewMessage();
        }
  //    } catch (e, s) {
  //      emit(ChatMessageError(e.toString(), s.toString(), state.messages));
  //    }
    });

    on<ChatInit>((event, emit) async {
      await Future.wait([
        for (final element in MessageProducer.values) element.service?.init() ?? Future.value(),
      ]);
      emit(const ChatInputState([]));
    });

    on<HumanInterrupt>((event, emit) {
      final messages = <ChatMessage>[...state.messages]..removeWhere((e) => e.isLoading);
      emit(ChatInputState(messages));
    });

    on<ChatPause>((event, emit) {
      if (state is! ChatPauseState) {
        final messages = <ChatMessage>[...state.messages]..removeWhere((e) => e.isLoading);
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
    final list = MessageProducer.values.where((value) => (value != state.messages.first.ai) && value != MessageProducer.human).toList();
    if (MessageProducer.values.length > 2) {
      add(SendMessage(list[Random().nextInt(list.length)]));
    } else {
      add(SendMessage(list[0]));
    }
  }
}
