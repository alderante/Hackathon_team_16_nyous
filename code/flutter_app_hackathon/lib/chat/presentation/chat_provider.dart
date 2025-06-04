// import 'package:hackatron_1/chat/data/claude_api_service.dart';
import 'package:hackatron_2/chat/data/gpt_api_service.dart';
import 'package:hackatron_2/chat/model/message.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  // Claude api service
  // final _apiService = ClaudeApiService(apiKey: "YOUR_API_KEY");

  // Gpt api service
  final _apiService = GptApiService(apiKey: "YOUR_API_KEY"); // <- Sostituire con la propria chiave

  // Messages & Loading..
  final List<Message> _messages = [];
  bool _isLoading = false;

  // Getters
  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;

  //* Add user message and get a response from AI
  Future<void> sendMessage(String content, {String? requestMessage}) async {
    // Prevent empty sends
    if (content.trim().isEmpty) return;

    // User message
    final userMessage = Message(
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Add user message to chat
    _messages.add(userMessage);

    // Update UI
    notifyListeners();

    // Start loading..
    _isLoading = true;

    // Update UI
    notifyListeners();

    // Send message & Receive response
    try {
      final response = await _apiService.sendMessage(content, requestMessage: requestMessage);

      // Response message from AI
      final responseMessage = Message(
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      // Add to chat
      messages.add(responseMessage);
    }

    // Error..
    catch (e) {
      // Error message
      final errorMessage = Message(
        content: "Sorry, I encountered an issue.. $e",
        isUser: false,
        timestamp: DateTime.now(),
      );

      // Add to chat
      messages.add(errorMessage);
    }

    // Finished loading..
    // scrollListToEND();
    _isLoading = false;

    // Update UI
    notifyListeners();
  }

  void addMessage(String content, {bool isUser = false, DateTime? timestamp}) {
    messages.add(
      Message(
        content: content,
        isUser: isUser,
        timestamp: timestamp ?? DateTime.now(),
      )
    );
  }

  void clearMessages() {
    messages.clear();

    // Update UI
    notifyListeners();
  }
}