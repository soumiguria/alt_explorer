import 'package:diversion/api_key.dart';
import 'package:diversion/components/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiEndpoints extends StatefulWidget {
  const ApiEndpoints({Key? key}) : super(key: key);

  @override
  _ApiEndpointsState createState() => _ApiEndpointsState();
}

class _ApiEndpointsState extends State<ApiEndpoints> {
  late Future<String> futureApiEndpoints;

  @override
  void initState() {
    super.initState();

    // Retrieve the user prompt from the ChatProvider
    String userPrompt = Provider.of<ChatProvider>(context, listen: false).userPrompt;

    // Initialize futureApiEndpoints lazily in the initState
    futureApiEndpoints = fetchApiEndpoints(userPrompt);
  }

  Future<String> fetchApiEndpoints(String userPrompt) async {
    // Run a background prompt to generate API endpoints based on the user input
    String backgroundPrompt =
        "for my idea try to provide me  link of APIS  available on the internet which help me in building my app and if you are not able to provide then provide me the link of those websites where I can find APIS of my requirement easily  I don't need any real-time data, also make the links of the apis clickable so that they redirect to the respective pages: $userPrompt";

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
        String apiEndpointsData = parsedResponse['choices'][0]['message']['content'];
        return apiEndpointsData;
      } else {
        throw Exception('Failed to fetch API endpoints. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error during API request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Endpoints'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: FutureBuilder<String>(
            future: futureApiEndpoints,
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
    );
  }
}
