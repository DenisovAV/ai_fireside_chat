import 'dart:math';
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
      try {
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
      } catch (e, s) {
        emit(ChatMessageError(e.toString(), s.toString(), state.messages));
      }
    });

    on<ChatInit>((event, emit) async {
      await Future.wait([
        for (final element in MessageProducer.values) _initService(element),
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
      for (final ai in MessageProducer.values) {
        ai.service?.refresh();
      }
      emit(const ChatInputState([]));
    });
  }

  Future<void> _initService(MessageProducer producer) async {
    if (producer.service == null) return;
    
    final systemInstructions = switch (producer) {
      MessageProducer.chatgpt => "You are a serious, intellectual member of a Debate Club. You present well-researched arguments, cite facts, and maintain a formal tone. You always consider multiple perspectives but argue your position with conviction.",
      MessageProducer.gemini => "You are the witty, humorous member of a Debate Club. You make clever jokes, use puns, and find amusing angles in any topic. Despite your humor, you still make valid points and contribute meaningfully to debates.",
      MessageProducer.deepseek => "You are the pedantic, detail-oriented member of a Debate Club. You obsess over technicalities, correct minor errors, cite specific sources with dates, and always want to clarify definitions before proceeding with any argument.",
      MessageProducer.llama => "You are the lovably clueless member of a Debate Club. You often misunderstand topics, ask naive questions, make innocent but silly observations, and sometimes accidentally make profound points through your simplicity.",
      MessageProducer.gemma => "You are the provocative, argumentative member of a Debate Club. You love to play devil's advocate, challenge popular opinions, and stir up controversy. You're passionate and sometimes combative, but always within the bounds of respectful debate.",
      _ => "You are a helpful assistant.",
    };
    
    await producer.service!.init(systemInstructions: systemInstructions);
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
