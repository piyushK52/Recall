import 'package:flutter/material.dart';
import 'package:recall/values/app_constants.dart';

class RecallList extends StatefulWidget {
  static const routeName = '/recall-list';
  RecallType type;

  RecallList({this.type});

  @override
  _RecallListState createState() => _RecallListState();
}

class _RecallListState extends State<RecallList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, _) {
        return _buildItem();
      },
    );
  }

  _buildItem() {
    return Container(
      height: 70,
      margin: EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
    );
  }
}
