import 'dart:convert';
import 'package:diversion/api_key.dart';
import 'package:http/http.dart' as http;

Future<String> fetchRevenueModel(String userPrompt) async {
  // Simulating a delay of 2 seconds
  await Future.delayed(Duration(seconds: 2));

  // Dummy revenue model (replace with actual data)
  String revenueModel = 'Generated revenue model based on user input: $userPrompt';

  // Run another prompt in the background based on the previous userPrompt
  String backgroundPrompt = "explain me how i can generate revenue for my app by different methods and explain how these methods work on my app. I want you to explain each model in 500 words pointwise where the first point explains how it works, the second point explains its implementation pointwise.";

  Uri uri = Uri.parse("https://api.openai.com/v1/chat/completions");

  Map<String, dynamic> body = {
    "model": "gpt-3.5-turbo",
    "messages": [
      {"role": "system", "content": backgroundPrompt},
      {"role": "user", "content": userPrompt}
    ],
    "max_tokens": 2000,
  };

  try {
    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${APIKey.apiKey}", // Replace with your OpenAI API key
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> parsedResponse = json.decode(response.body);

      String additionalResponse = parsedResponse['choices'][0]['message']['content'];

      // Process the additionalResponse as needed

      // Combine the fetched revenue model and additional response
      String combinedResults = '$revenueModel\n\nAdditional details: $additionalResponse';

      return combinedResults;
    } else {
      throw Exception('Failed to fetch revenue model. Status code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error during API request: $error');
  }
}
