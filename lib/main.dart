import 'package:flutter/material.dart';
import 'screens/screen_1.dart';

void main() {
  runApp(GPACalculatorApp());
}

class GPACalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPA Calculator',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Screen1(),
    );
  }
}
