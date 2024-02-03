// // import 'dart:convert';
// // import 'package:diversion/api_key.dart';
// // import 'package:http/http.dart' as http;

// // Future<List<String>> fetchCompetitors(String userMessage) async {
// //   // Replace 'YOUR_OPENAI_API_KEY' with your actual OpenAI API key
// //   // final String apiKey = 'YOUR_OPENAI_API_KEY';

// //   // Construct the prompt based on userMessage
// //   final String prompt = 'as if similar things present in market then just tell me name of any five ';

// //   // Prepare the request headers
// //   final Map<String, String> headers = {
// //     'Content-Type': 'application/json',
// //     'Authorization': "Bearer ${APIKey.apiKey}",
// //   };

// //   // Prepare the request body
// //   final Map<String, dynamic> requestBody = {
// //     'model': 'gpt-3.5-turbo', // Use the appropriate model
// //     'prompt': prompt,
// //     'max_tokens': 150, // Adjust max_tokens based on your requirements
// //   };

// //   try {
// //     // Perform the HTTP POST request to the OpenAI API
// //     final http.Response response = await http.post(
// //       Uri.parse('https://api.openai.com/v1/chat/completions'), // Adjust the endpoint accordingly
// //       headers: headers,
// //       body: json.encode(requestBody),
// //     );

// //     // Parse the response and extract the competitors
// //     if (response.statusCode == 200) {
// //       final Map<String, dynamic> responseBody = json.decode(response.body);
// //       final List<String> competitors = responseBody['choices'][0]['text'].toString().split('\n');
// //       return competitors;
// //     } else {
// //       // Handle the error scenario
// //       throw Exception('Failed to fetch competitors. Status code: ${response.statusCode}');
// //     }
// //   } catch (error) {
// //     // Handle exceptions
// //     throw Exception('Error during API request: $error');
// //   }
// // }





// import 'dart:convert';

// import 'package:diversion/api_key.dart';
// import 'package:http/http.dart' as http;

// Future<List<String>> fetchCompetitors(String userMessage) async {
//   final String prompt = 'If there are any similar products present in the market then tell me just 5 names of them.';

//   final Map<String, String> headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer ${APIKey.apiKey}',
//   };

//   final Map<String, dynamic> requestBody = {
//     'model': 'gpt-3.5-turbo',
//     'messages': [
//       {'role': 'system', 'content': $userMessage},
//       {'role': 'user', 'content': prompt},
//     ],
//     'max_tokens': 150,
//   };

//   try {
//     final http.Response response = await http.post(
//       Uri.parse('https://api.openai.com/v1/chat/completions'), // Update the endpoint if needed
//       headers: headers,
//       body: json.encode(requestBody),
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseBody = json.decode(response.body);
//       final List<String> competitors = responseBody['choices'][0]['message']['content'].toString().split('\n');
//       return competitors;
//     } else {
//       throw Exception('Failed to fetch competitors. Status code: ${response.statusCode}');
//     }
//   } catch (error) {
//     throw Exception('Error during API request: $error');
//   }
// }








import 'dart:convert';
import 'package:diversion/api_key.dart';
import 'package:http/http.dart' as http;

Future<List<String>> fetchCompetitors(String systemPrompt, String userMessage) async {
  final String prompt = 'If there are any similar products present in the market then tell me just 5 names of them.';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${APIKey.apiKey}',
  };

  final Map<String, dynamic> requestBody = {
    'model': 'gpt-3.5-turbo',
    'messages': [
      {'role': 'system', 'content': systemPrompt},
      {'role': 'user', 'content': userMessage},
      {'role': 'assistant', 'content': prompt},
    ],
    'max_tokens': 150,
  };

  try {
    final http.Response response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'), // Update the endpoint if needed
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final List<String> competitors = responseBody['choices'][0]['message']['content'].toString().split('\n');
      return competitors;
    } else {
      throw Exception('Failed to fetch competitors. Status code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error during API request: $error');
  }
}
