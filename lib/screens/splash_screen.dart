import 'package:flutter/material.dart';
import 'package:recall/models/recall_model.dart';
import 'package:recall/screens/home_screen.dart';
import 'package:recall/utils/preference_manager.dart';
import 'package:recall/values/app_constants.dart';
import 'package:recall/values/current_data.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = './splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    _fetchRecallLists();
    super.initState();
  }

  _fetchRecallLists() async {
    List<RecallModel> habitList =
        await PreferenceManager().getRecallList(RecallType.HABIT);
    List<RecallModel> revisionList =
        await PreferenceManager().getRecallList(RecallType.REVISION);

    CurrentData.habitList = habitList;
    CurrentData.revisionList = revisionList;

    Future.delayed(Duration(milliseconds: 300), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.routeName, (map) => false);
    });
  }

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
