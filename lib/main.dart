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
    String backgroundPrompt = "See you will be a model that will give answers to only a prompt when it is regarding any particular project idea which the user wants to build, assist that user with this product idea  and anything in relevance to the particular project else say \"I don't know the thing what you are asking for, but would surely love to learn about it\".the first line that should be displayed on generating the prompt should always contain an encouraging statement also tells that given idea is unique or not or already similar things are available in market and show but we are here to help you proceed give this in 100 words. Remember not to answer any thing apart from proect idea related things. Don't answer any coding question, nothing irrevent to project ideas, or startups, if that is the case I am going to behave harshly with you";

    Uri uri = Uri.parse("https://api.openai.com/v1/chat/completions");

    Map<String, dynamic> body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": backgroundPrompt},
        {"role": "user", "content": userMessage}
      ],
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

    String reply = parsedResponse['choices'][0]['message']['content'];

    return reply;
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
            colors: [Colors.green, Colors.yellow],
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
        title: Text('Alt Explorer'),
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