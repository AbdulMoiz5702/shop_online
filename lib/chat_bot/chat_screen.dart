import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_bot_controller.dart';



class ChatBotScreen extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());
  final TextEditingController inputController = TextEditingController();

  ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Chat Assistant')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final msg = controller.messages[index];
                final isUser = msg.role == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg.content),
                  ),
                );
              },
            )),
          ),

          /// 🔄 Thinking Animation Instead of CircularProgressIndicator
          Obx(() => controller.isLoading.value
              ? Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("🤖 Thinking", style: TextStyle(fontWeight: FontWeight.bold)),
                AnimatedDots(),
              ],
            ),
          )
              : const SizedBox.shrink()),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: const InputDecoration(hintText: 'Ask me anything...'),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = inputController.text.trim();
    if (text.isNotEmpty) {
      controller.sendMessage(text);
      inputController.clear();
    }
  }
}

/// Simple animated dots widget
class AnimatedDots extends StatefulWidget {
  const AnimatedDots({super.key});
  @override
  State<AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<AnimatedDots> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<int> _dots;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();
    _dots = IntTween(begin: 1, end: 3).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dots,
      builder: (context, child) {
        return Text("." * (_dots.value), style: const TextStyle(fontSize: 18));
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
