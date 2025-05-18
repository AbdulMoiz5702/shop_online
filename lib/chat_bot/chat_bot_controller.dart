
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'chat_bot_model.dart';



class ChatController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;

  final _apiKey = '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';
  final _apiUrl = 'https://api.groq.com/openai/v1/chat/completions';

  void sendMessage(String text) {
    if (text.isEmpty) return;

    messages.add(ChatMessage(role: 'user', content: text));
    _sendToAI();
  }

  Future<void> _sendToAI() async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {"role": "system", "content": "You are a helpful, conversational AI assistant."},
            ...messages.map((m) => {
              "role": m.role,
              "content": m.content,
            }).toList()
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'].trim();
        messages.add(ChatMessage(role: 'assistant', content: reply));
      } else {
        print(response.body);
        messages.add(ChatMessage(role: 'assistant', content: "❗️Failed to generate response."));
      }
    } catch (e) {
      messages.add(ChatMessage(role: 'assistant', content: "❗️Error: ${e.toString()}"));
    } finally {
      isLoading.value = false;
    }
  }
}
