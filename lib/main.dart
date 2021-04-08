import 'package:flutter/material.dart';
import 'package:recall/screens/create_recall.dart';
import 'package:recall/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recall',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
        CreateRecall.routeName: (ctx) => CreateRecall(),
      },
    );
  }
}
