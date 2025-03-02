import 'package:flutter/material.dart';
import 'screens/screen_1.dart';

/// The main entry point of the GPA Calculator application.
void main() {
  runApp(GPACalculatorApp());
}

/// The root widget of the GPA Calculator application.
///
/// This class defines the main structure of the app, including the theme
/// and initial screen.
class GPACalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPA Calculator',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Screen1(), // Loads the first screen of the application.
    );
  }
}
