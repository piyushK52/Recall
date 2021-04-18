import 'package:flutter/material.dart';
import 'package:recall/models/recall_model.dart';
import 'package:recall/values/app_constants.dart';
import 'package:recall/values/custom_app_theme.dart';
import 'package:recall/widgets/header.dart';
import 'package:intl/intl.dart';
import 'package:recall/widgets/weekday_selector.dart';

class SessionList extends StatelessWidget {
  static const routeName = './main-screen/recall-details/session-list';

  final double cirleDia = 50;
  final activeColor = CustomAppTheme.primaryColor;
  final deactiveColor = Colors.grey;

  RecallModel item;
  RecallType type;

  SessionList({this.item, this.type});

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: _height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Header(
                headerText: item.title + ' - timeline',
                onPop: () {
                  Navigator.of(context).pop("random");
                },
              ),
              SizedBox(
                height: 20,
              ),
              type == RecallType.REVISION
                  ? Expanded(
                      child: ListView.builder(
                      itemCount: item.sessions.length,
                      itemBuilder: (ctx, index) {
                        return _sessionItem(index);
                      },
                    ))
                  : Center(
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(
                          left: 20,
                        ),
                        child: WeekDaySelector(
                          onChanged: (int day) {},
                          selectedDays: item.days,
                          context: context,
                        ),
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
      // color: Colors.lightBlueAccent,
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
                    color: index + 1 > item.completedSteps
                        ? deactiveColor
                        : activeColor,
                  ),
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                index != item.sessions.length - 1
                    ? Container(
                        height: 60,
                        width: 10,
                        margin: EdgeInsets.only(
                          top: 40,
                          left: 20,
                          bottom: 3,
                        ),
                        decoration: BoxDecoration(
                          color: index + 1 > item.completedSteps
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
              DateFormat('dd MMM yyyy   hh:mm a').format(item.sessions[index]) +
                  (index != 0 ? '  ( ${getPendingDays(index)} Days )' : ''),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getPendingDays(int idx) {
    if (idx == 0) return idx.toString();
    return (item.sessions[idx].difference(item.sessions[idx - 1]).inDays)
        .toString();
  }
}
