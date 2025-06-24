import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/home.dart';

void main() {
  runApp(LiveStreamingApp());
}

class LiveStreamingApp extends StatelessWidget {
  const LiveStreamingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Streaming & Reward',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
      routes: {'/home': (context) => HomeScreen()},
    );
  }
}
