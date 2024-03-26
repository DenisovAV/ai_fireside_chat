import 'package:chat/core/message_producer.dart';
import 'package:chat/core/message.dart';
import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({super.key, required this.message, required this.alignment});

  final Message message;
  final bool alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: alignment ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          alignment ? const SizedBox() : _buildAvatar(),
          const SizedBox(
            width: 10,
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: const Color(0x80757575),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: message.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Text(
                    message.text,
                    style: const TextStyle(fontSize: 16.0),
                  ),
          ),
          const SizedBox(
            width: 10,
          ),
          alignment ? _buildAvatar() : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return switch (message.ai) {
      MessageProducer.chatgpt => _circled('assets/chatgpt.png'),
      MessageProducer.gemini => _circled('assets/gemini.png'),
      MessageProducer.gemma => _circled('assets/gemma.png'),
      MessageProducer.human => const Icon(Icons.person),
    };
  }

  Widget _circled(String image) =>
      CircleAvatar(backgroundColor: Colors.transparent, foregroundImage: AssetImage(image));
}
