import 'package:diversion/api_key.dart';
import 'package:diversion/components/provider.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class MarketTrendsPage extends StatefulWidget {
  const MarketTrendsPage({Key? key}) : super(key: key);

  @override
  _MarketTrendsPageState createState() => _MarketTrendsPageState();
}

class _MarketTrendsPageState extends State<MarketTrendsPage> {
  late Future<List<Trend>> futureTrends;
  late String userPrompt;

  @override
  void initState() {
    super.initState();

    // Retrieve the user prompt from the ChatProvider
    userPrompt = Provider.of<ChatProvider>(context, listen: false).userPrompt;

    // Initialize futureTrends lazily in the initState
    futureTrends = fetchTrends(userPrompt);
  }

  Future<List<Trend>> fetchTrends(String userPrompt) async {
    // Simulating a delay of 2 seconds
    await Future.delayed(Duration(seconds: 2));

    // Run a prompt in the background based on the userPrompt
    String backgroundPrompt = "give me the idea about the current market demand for my particular application and i want you to provide a  data using  which  i can make bar graph to show the market growth of past 5 years along with predicted model of upcoming 5 years: $userPrompt";

    Uri uri = Uri.parse("https://api.openai.com/v1/chat/completions");

    Map<String, dynamic> body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": backgroundPrompt},
        {"role": "user", "content": userPrompt}
      ],
      "max_tokens": 1000,
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

        // Process the response and extract market trends
        List<String> trendsList = parsedResponse['choices'][0]['message']['content'].split('\n');
        List<Trend> trends = trendsList.map((trend) => Trend(trend)).toList();

        return trends;
      } else {
        throw Exception('Failed to fetch market trends. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error during API request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market Trends and Potential'),
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
            child: FutureBuilder<List<Trend>>(
              future: futureTrends,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No trends available.'),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Market Trends',
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.0),
                      _buildTrendsList(snapshot.data!),
                      SizedBox(height: 24.0),
                      Text(
                        'Market Potential',
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.0),
                      _buildPotentialChart(),
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

  Widget _buildTrendsList(List<Trend> trends) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: trends.map((trend) => _buildTrendItem(trend)).toList(),
    );
  }

  Widget _buildTrendItem(Trend trend) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          trend.title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        Text(trend.description, style: TextStyle(fontSize: 16.0)),
      ],
    ),
  );
}

  Widget _buildPotentialChart() {
    // Example data for the bar chart
    var data = [
      SalesData('Product A', 50),
      SalesData('Product B', 80),
      SalesData('Product C', 30),
      SalesData('Product D', 100),
    ];

    var series = [
      charts.Series(
        id: 'Sales',
        data: data,
        domainFn: (SalesData sales, _) => sales.product,
        measureFn: (SalesData sales, _) => sales.sales,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (SalesData sales, _) => '${sales.product}: ${sales.sales}',
      ),
    ];

    return Container(
      height: 300,
      child: charts.BarChart(
        series,
        animate: true,
        barRendererDecorator: charts.BarLabelDecorator<String>(),
        domainAxis: charts.OrdinalAxisSpec(),
      ),
    );
  }
}

class Trend {
  final String title;
  final String description;

  Trend(String trend) :
    title = trend.split(':')[0],
    description = trend.split(':').length > 1 ? trend.split(':').sublist(1).join(':') : '';
}
class SalesData {
  final String product;
  final int sales;

  SalesData(this.product, this.sales);
}
