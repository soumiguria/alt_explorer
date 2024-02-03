import 'package:diversion/api_key.dart';
import 'package:diversion/components/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class EnhancingOpportunityPage extends StatefulWidget {
  const EnhancingOpportunityPage({Key? key}) : super(key: key);

  @override
  _EnhancingOpportunityPageState createState() => _EnhancingOpportunityPageState();
}

class _EnhancingOpportunityPageState extends State<EnhancingOpportunityPage> {
  late Future<String> futureEnhancements;

  @override
  void initState() {
    super.initState();

    String userPrompt = Provider.of<ChatProvider>(context, listen: false).userPrompt;

    futureEnhancements = fetchEnhancements(userPrompt);
  }

  Future<String> fetchEnhancements(String userPrompt) async {
    await Future.delayed(Duration(seconds: 2));

    String backgroundPrompt = "Suggest enhancements for the application based on user feedback: $userPrompt";

    Uri uri = Uri.parse("https://api.openai.com/v1/chat/completions");

    Map<String, dynamic> body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": backgroundPrompt},
        {"role": "user", "content": userPrompt}
      ],
      "max_tokens": 500,
    };

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${APIKey.apiKey}", 
      },
      body: json.encode(body),
    );

    Map<String, dynamic> parsedResponse = json.decode(response.body);

    String enhancements = parsedResponse['choices'][0]['message']['content'];

    return enhancements;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enhancing Opportunities'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color.fromARGB(255, 214, 116, 231), Color.fromARGB(255, 230, 230, 142)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<String>(
              future: futureEnhancements,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enhancing Opportunities',
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      _buildEnhancementItem('Generated Suggestions', snapshot.data!),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancementItem(String title, String description) {
    return Card(
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
          Colors.green,
          Colors.yellow,
        ], // Adjust these colors as needed
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            description,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    ),
  ),
);

  }
}
