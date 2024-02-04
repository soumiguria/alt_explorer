import 'dart:convert';
import 'package:diversion/APIEndpoints.dart';
import 'package:diversion/FutureAnalysis.dart';
import 'package:diversion/SetupDetails.dart';
import 'package:diversion/SplashScreen.dart';
import 'package:diversion/Technologies.dart';
import 'package:diversion/WinningStrategies.dart';
import 'package:diversion/api_key.dart';
import 'package:diversion/components/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project Ideation',
      home: SplashScreen(),

       routes: {
    '/Technologies Information': (context) => Technologies(),
    '/API Endpoints Information': (context) => ApiEndpoints(),
    '/Setup Details Information': (context) => SetupDetails(),
    '/Winning Strategies Information': (context) => WinningStrategies(),
  },

    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Message> _messages = [];
  final TextEditingController _textEditingController = TextEditingController();
  bool generatedResponse = false;
  String responseFromGPT = '';

  void onSendMessage(BuildContext context) async {
    Message userMessage = Message(
      text: _textEditingController.text,
      isMe: true,
    );
    _textEditingController.clear();

    setState(() {
      _messages.insert(0, userMessage);
    });

    String response = await sendMessageToChatGpt(userMessage.text);

    Message chatGpt = Message(text: response, isMe: false);

    setState(() {
      _messages.insert(0, chatGpt);
      generatedResponse = true;
      responseFromGPT = response;
    });

    ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.setUserPrompt(userMessage.text);

  }

    Future<String> sendMessageToChatGpt(String userMessage) async {
  Uri uri = Uri.parse("https://hello-world-summer-recipe-c306.guriasoumi29.workers.dev/sendMessageToChatGpt");

  Map<String, dynamic> body = {
    "userMessage": userMessage,
  };

  try {
    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      String reply = response.body;
      return reply;
    } else {
      // Handle non-200 status code
      print("Error: ${response.statusCode}");
      return "Error: ${response.statusCode}";
    }
  } catch (e) {
    // Handle other exceptions
    print("Error: $e");
    return "Error: $e";
  }
}


  void onProceed() {
    if (generatedResponse) {
      // Navigate to the future analysis page and pass the response
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FutureAnalysisPage(response: responseFromGPT),
        ),
      );
    }
  }

  Widget _buildMessage(Message message) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade300, Colors.yellow.shade300],
          ),
        ),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment:
              message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message.isMe ? 'You' : 'Alt Explorer',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(message.text),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Row(
    children: <Widget>[
      // Wrap the Image.asset with CircleAvatar to make it circular
      CircleAvatar(
        radius: 15,  // Adjust the radius to set the size of the circular avatar
        backgroundColor: Colors.transparent,  // Set background color to transparent
        child: ClipOval(
          child: Image.asset(
            'assets/images/splash_screen.jpeg',  // Replace with the actual path to your image
            height: 30,  // Adjust the height as needed
            width: 30,   // Adjust the width as needed
          ),
        ),
      ),
      
      // Add some space between the logo and title
      SizedBox(width: 10),

      // Add the title text
      Text('Alt Explorer'),
    ],
  ),
  backgroundColor: Colors.blue.shade300,
),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildMessage(_messages[index]);
                },
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          hintText: 'Enter your project idea prompt here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      
                      // onPressed: generatedResponse ? onProceed : onSendMessage as void Function(),

                      // onPressed: generatedResponse ? onProceed : onSendMessage,

                      onPressed: generatedResponse ? () => onProceed() : () => onSendMessage(context),

                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue.shade800,
                        side: BorderSide(color: Colors.white, width: 2.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          generatedResponse ? 'Proceed' : 'Generate',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMe;

  Message({required this.text, required this.isMe});
}