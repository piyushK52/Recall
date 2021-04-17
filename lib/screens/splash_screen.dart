import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = './splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(child: Text("loading...")),
        ),
      ),
    );
  }
}
