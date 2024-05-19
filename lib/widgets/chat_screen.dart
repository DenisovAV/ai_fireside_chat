import 'package:chat/bloc/chat_bloc.dart';
import 'package:chat/bloc/chat_event.dart';
import 'package:chat/bloc/chat_state.dart';
import 'package:chat/core/message_producer.dart';
import 'package:chat/service/service_map.dart';
import 'package:chat/widgets/chat_input_field.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(serviceMap),
      child: SafeArea(
        child: _ChatMessagesList(),
      ),
    );
  }
}

void _showTransparentPopup(BuildContext context, String text, VoidCallback okPress) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black45,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        content: Text(text),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              okPress();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _ChatMessagesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'GenAI Fireside Chat',
          style: TextStyle(fontSize: 20),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        actions: [
          _floatingButton(context, Icons.person, const HumanInterrupt()),
          const SizedBox(
            width: 10,
          ),
          _floatingButton(context, Icons.restart_alt, const ChatRestart()),
          const SizedBox(
            width: 10,
          ),
          _floatingButton(
              context,
              context.watch<ChatBloc>().state is ChatPauseState ? Icons.play_arrow : Icons.pause,
              const ChatPause()),
        ],
      ),
      body: Stack(children: [
        Center(
          child: Image.asset('assets/fireside.gif'),
        ),
        BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatMessageError) {
              _showTransparentPopup(context, state.error, () => context.read<ChatBloc>().add(const HumanInterrupt()),);
            }
          },
          builder: (context, state) {
            final widget = ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                return ChatMessageWidget(
                  message: message,
                  alignment: ((state.messages.length - index) & 1) == 0,
                );
              },
            );
            return Column(
              children: <Widget>[
                Flexible(child: widget),
                const Divider(height: 1.0),
                if (state is ChatInputState)
                  ChatInputField(
                    handleSubmitted: (text) => BlocProvider.of<ChatBloc>(context)
                        .add(SendMessage(MessageProducer.human, text: text)),
                  ),
              ],
            );
          },
        ),
      ]),
    );
  }

  Widget _floatingButton(BuildContext context, IconData icon, ChatEvent event) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      backgroundColor: const Color(0x80757575),
      onPressed: () => context.read<ChatBloc>().add(event),
      child: Icon(icon),
    );
  }
}
