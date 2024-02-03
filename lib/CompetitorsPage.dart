import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:diversion/components/provider.dart';
import 'package:diversion/components/fetchCompetitors.dart';
import 'package:provider/provider.dart';

class CompetitorsPage extends StatelessWidget {
  const CompetitorsPage({Key? key}) : super(key: key);

@override
  Widget build(BuildContext context) {
    String userPrompt = Provider.of<ChatProvider>(context).userPrompt;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: SelectableText('Competitors Page'),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 214, 116, 231),
                Color.fromARGB(255, 230, 230, 142),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  'Top Competitors',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: FutureBuilder<List<String>>(
                    future: fetchCompetitors(
                      'If there is any similar product or applications existing in the market that supports the same functionality then give me the names of the top 5 of such companies. Just show me the names of the top 5 of such companies. No need to show the line like "The top 5 companies are". Just show me the names of the top 5 of such companies.',
                      userPrompt,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: SelectableText('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return Center(child: SelectableText('No competitors found.'));
                      } else {
                        List<String> results = snapshot.data!;
                        return Column(
                          children: [
                            Expanded(child: _buildResultsList(results)),
                            SizedBox(height: 24.0),
                            SelectableText(
                              'Market Share Distribution',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            _buildMarketShareChart(results),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

    Widget _buildResultsList(List<String> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: SelectableText(results[index]),
        );
      },
    );
  }

 Widget _buildMarketShareChart(List<String> competitors) {
    Map<String, double> dataMap = {};
    double totalShare = 100.0;
    double sharePerCompetitor = totalShare / competitors.length;

    for (int i = 0; i < competitors.length; i++) {
      dataMap[competitors[i]] = sharePerCompetitor;
    }

    return PieChart(
      dataMap: dataMap,
      colorList: [
        Colors.purple,
        Colors.pink,
        Colors.orange,
        Colors.red,
        Colors.yellow,
        Colors.indigo,
      ],
      chartRadius: 200,
      chartType: ChartType.ring,
    );
  }
}

