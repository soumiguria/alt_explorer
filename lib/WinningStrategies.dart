import 'dart:convert';

import 'package:diversion/api_key.dart';
import 'package:diversion/components/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class WinningStrategies extends StatefulWidget {
  const WinningStrategies({Key? key}) : super(key: key);

  @override
  _WinningStrategiesState createState() => _WinningStrategiesState();
}

class _WinningStrategiesState extends State<WinningStrategies> {
  late Future<String> futureWinningStrategies;

  @override
  void initState() {
    super.initState();

    // Retrieve the user prompt from the ChatProvider
    String userPrompt = Provider.of<ChatProvider>(context, listen: false).userPrompt;

    // Initialize futureWinningStrategies lazily in the initState
    futureWinningStrategies = fetchWinningStrategies(userPrompt);
  }

  Future<String> fetchWinningStrategies(String userPrompt) async {
    // Run a background prompt to generate winning strategies based on the user input
    String backgroundPrompt =
        "Provide winning strategies for making the idea stand out in the market and its unique selling points: $userPrompt";

    Uri uri = Uri.parse("https://api.openai.com/v1/chat/completions");

    Map<String, dynamic> body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": backgroundPrompt},
        {"role": "user", "content": userPrompt}
      ],
      "max_tokens": 200,
    };

    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${APIKey.apiKey}",
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> parsedResponse = json.decode(response.body);
        String strategiesData = parsedResponse['choices'][0]['message']['content'];
        return strategiesData;
      } else {
        throw Exception('Failed to fetch winning strategies. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error during API request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 214, 116, 231),
              Color.fromARGB(255, 230, 230, 142)
            ],
          ),
        ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Card(
              elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
              child: Container(
                decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.yellow,
                              Colors.green.shade200,
                              Colors.yellow
                            ], // Adjust these colors as needed
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                padding: EdgeInsets.all(16.0),
                child: FutureBuilder<String>(
                  future: futureWinningStrategies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return Text(
                        snapshot.data ?? 'No data available',
                        style: TextStyle(fontSize: 16.0),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
