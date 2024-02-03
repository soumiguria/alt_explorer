import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  late String userPrompt;

  void setUserPrompt(String prompt) {
    userPrompt = prompt;
    notifyListeners();
  }
}
