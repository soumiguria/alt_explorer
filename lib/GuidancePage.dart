import 'package:flutter/material.dart';

class GuidancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guidance Page'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.purple, Colors.blue],
            ),
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildClickableContainer(
                'Technologies',
                'Explore the technologies that can be used for building the project.',
                'assets/images/technologies.jpg',
                () => _navigateToInformation(context, 'Technologies Information'),
                gradientColors: [Colors.yellow, Colors.green],
              ),
              SizedBox(height: 16.0),
              _buildClickableContainer(
                'API Endpoints',
                'Discover necessary API endpoints to refer to for building the project.',
                'assets/images/api-endpoints.jpg',
                () => _navigateToInformation(context, 'API Endpoints Information'),
                gradientColors: [Colors.yellow, Colors.green],
              ),
              SizedBox(height: 16.0),
              _buildClickableContainer(
                'Setup Details',
                'Learn how to get started with setting up the application.',
                'assets/images/setup_details.jpg',
                () => _navigateToInformation(context, 'Setup Details Information'),
                gradientColors: [Colors.yellow, Colors.green],
              ),
              SizedBox(height: 16.0),
              _buildClickableContainer(
                'Winning Strategies',
                'Strategies for making the idea stand out in the market and its unique selling points.',
                'assets/images/winning_strategies.png',
                () => _navigateToInformation(context, 'Winning Strategies Information'),
                gradientColors: [Colors.yellow, Colors.green],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClickableContainer(String title, String description, String imagePath, VoidCallback onTap, {List<Color>? gradientColors}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors ?? [Colors.white, Colors.white], // Default gradient colors
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(fontSize: 14.0, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToInformation(BuildContext context, String information) {
    Navigator.of(context).pushNamed('/$information');
  }
}
