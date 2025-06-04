import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:hackatron_2/chat/model/models.dart';

class GptApiService {
  // API Constants
  static const String _baseUrl = 'https://api.openai.com/v1';
  static const String _model = 'gpt-3.5-turbo';
  // static const int _maxTokens = 10;
  static const int _temperature = 0;

  // Store the API key securely
  final String _apiKey;

  // Require API key
  GptApiService({required String apiKey}) : _apiKey = apiKey;

  // Get models
  Future<List<ModelsModel>> getModels() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/models"),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );

      Map jsonResponse = jsonDecode(response.body);

      // Handle unsuccessful response
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);
      }
      // print("jsonResponse $jsonResponse");

      // Get the data
      List temp = [];
      for (var value in jsonResponse['data']) {
        temp.add(value);
        // log("temp ${value['id']}");
      }

      // Return the models
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (e) {
      log("GPT Error $e");
      rethrow;
    }
  }

  /*
  
  Send a message to ChatGPT API & return the response
  
  */
  Future<String> sendMessage(String message, {String? requestMessage}) async {
    try {
      // Make POST request to ChatGPT API
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: _getHeaders(),
        body: _getRequestBody(message, requestMessage: requestMessage),
      );

      final data = jsonDecode(response.body); // Parse json response

      // Check if request was successful
      if (data['choices'].length > 0) {
        return data['choices'][0]['message']['content']; // Extract ChatGPT's response text
      }

      // Handle unsuccessful response
      else {
        // log('GPT API error: ${jsonDecode(response.body)['error']['message']}');
        throw Exception(
          'Failed to get response from ChatGPT: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during api call
      throw Exception('API Error $e');
    }
  }

  // Create required headers for ChatGPT API
  Map<String, String> _getHeaders() => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_apiKey',
  };

  // Format request body according to ChatGPT API specs
  String _getRequestBody(String message, {String? requestMessage}) {
    final List<Map<String, String>> messages = [];

    //* Setup the API
    if (requestMessage != null) {
      messages.add({
        "role": "system",
        "content": "Sei un assistente che risponde alle domande basandosi al seguente testo:\n\n\"$requestMessage\""
      });
    }
    else {
      messages.add({"role": "system", "content": "Sei un assistente utile."});
    }

    //* Add user message
    messages.add({"role": "user", "content": message});

    return jsonEncode({
      'model': _model,
      // 'prompt': message,
      'messages': messages,
      // 'max_tokens': _maxTokens,
      'temperature': _temperature,
    });
  }
}
