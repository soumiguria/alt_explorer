import 'dart:convert';
import 'package:diversion/CompetitorsPage.dart';
import 'package:diversion/EnhancingOpportunityPage.dart';
import 'package:diversion/GuidancePage.dart';
import 'package:diversion/RevenuePage.dart';
import 'package:diversion/MarketTrendsPage.dart';
import 'package:diversion/api_key.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FutureAnalysisPage extends StatelessWidget {
  final String response;

  FutureAnalysisPage({required this.response});

  Future<List<String>> fetchCompetitors(String userPrompt) async {

    await Future.delayed(Duration(seconds: 2));

    List<String> competitors = ['Competitor A', 'Competitor B', 'Competitor C'];

    String backgroundPrompt =
        "If similar products are present in the market, provide names of any five.";

    Uri uri = Uri.parse("https://api.openai.com/v1/chat/completions");

    Map<String, dynamic> body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": backgroundPrompt},
        {"role": "user", "content": userPrompt}
      ],
      "max_tokens": 50,
    };

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer ${APIKey.apiKey}", 
      },
      body: json.encode(body),
    );

    Map<String, dynamic> parsedResponse = json.decode(response.body);

    String additionalResponse =
        parsedResponse['choices'][0]['message']['content'];


    List<String> combinedResults = [...competitors, additionalResponse];

    return combinedResults;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alt Explorer'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Card(
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
                              Colors.green
                            ], 
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            response,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors
                                    .black), 
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: CategoryContainer(
                        label: 'Competitors',
                        imageAsset:
                            'assets/images/competitors_image.jpeg', 
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompetitorsPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: CategoryContainer(
                        label: 'Market Trends and Potential',
                        imageAsset: 'assets/images/market_potential_image.jpeg',
                        onPressed: () async {
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketTrendsPage(),
                            ),
                          );

                          print(result);
                        },
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: CategoryContainer(
                        label: 'Revenue Model',
                        imageAsset:
                            'assets/images/revenue_model.jpeg', 
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RevenueModelPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: CategoryContainer(
                        label: 'Enhancing Opportunity',
                        imageAsset:
                            'assets/images/enhancing_opportunity.jpeg', 
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EnhancingOpportunityPage()),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: CategoryContainer(
                        label: 'Guidance',
                        imageAsset:
                            'assets/images/guidance.jpeg', 
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GuidancePage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryContainer extends StatelessWidget {
  final String label;
  final String imageAsset;
  final VoidCallback onPressed;

  CategoryContainer(
      {required this.label, required this.imageAsset, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(imageAsset),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.black.withOpacity(0.6),
                ),
                padding: EdgeInsets.all(8.0),
                child: Text(
                  label,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
