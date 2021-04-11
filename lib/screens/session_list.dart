import 'package:flutter/material.dart';
import 'package:recall/values/custom_app_theme.dart';
import 'package:recall/widgets/header.dart';
import 'package:intl/intl.dart';

class SessionList extends StatelessWidget {
  static const routeName = './main-screen/recall-details/session-list';

  final double cirleDia = 50;
  final activeColor = CustomAppTheme.primaryColor;
  final deactiveColor = Colors.grey;

  List<DateTime> sessions = [];
  int completed;

  SessionList({this.sessions, this.completed});

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: _height,
          child: Column(
            children: [
              Header(
                headerText: 'Some random text which is very long',
                onPop: () {
                  Navigator.of(context).pop("random");
                },
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (ctx, index) {
                    return _sessionItem(index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _sessionItem(index) {
    return Container(
      // height: 50,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      color: Colors.lightBlueAccent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Stack(
              children: [
                Container(
                  height: cirleDia,
                  width: cirleDia,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cirleDia / 2),
                    color: index + 1 > completed ? deactiveColor : activeColor,
                  ),
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                index != sessions.length - 1
                    ? Container(
                        height: 60,
                        width: 10,
                        margin: EdgeInsets.only(
                          top: 30,
                          left: 20,
                          bottom: 3,
                        ),
                        decoration: BoxDecoration(
                          color: index + 1 > completed
                              ? deactiveColor
                              : activeColor,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: cirleDia / 2 - 10,
              left: 20,
            ),
            child: Text(
              DateFormat('dd MMM yyyy   hh:mm a').format(sessions[index]),
            ),
          ),
        ],
      ),
    );
  }
}
