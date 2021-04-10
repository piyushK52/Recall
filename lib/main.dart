import 'package:flutter/material.dart';
import 'package:recall/screens/create_recall.dart';
import 'package:recall/screens/home_screen.dart';
import 'package:recall/screens/recall_details.dart';
import 'package:recall/screens/recall_list.dart';

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
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
        CreateRecall.routeName: (ctx) => CreateRecall(),
        RecallList.routeName: (ctx) => RecallList(),
        RecallDetails.routeName: (ctx) => RecallDetails(),
      },
    );
  }
}
