import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recall/models/recall_model.dart';
import 'package:recall/screens/session_list.dart';
import 'package:recall/utils/preference_manager.dart';
import 'package:recall/values/app_constants.dart';
import 'package:recall/values/custom_app_theme.dart';
import 'package:recall/widgets/header.dart';
import 'package:recall/widgets/pill.dart';
import 'package:recall/widgets/recall_files.dart';

class RecallDetails extends StatefulWidget {
  static const routeName = './home-screen/recall-details';
  RecallType type;
  RecallModel recall;

  RecallDetails({this.type, this.recall});

  @override
  _RecallDetailsState createState() => _RecallDetailsState();
}

class _RecallDetailsState extends State<RecallDetails> {
  double _height, _width;
  RecallModel item;

  String _getUpcomingSession() {
    DateTime upcomingDate;
    if (widget.type == RecallType.REVISION) {
      upcomingDate = widget.recall.sessions[widget.recall.completedSteps];
    } else {
      int curDay = DateTime.now().weekday - 1;
      int addDays = -1;
      print("current days selected ${widget.recall.days}");
      for (int i = curDay + 1; i < 7; i++) {
        if (widget.recall.days[i]) {
          addDays = i - curDay;
          break;
        }
      }

      if (addDays == -1) {
        for (int i = 0; i < 7; i++) {
          if (widget.recall.days[i]) {
            addDays = i;
            break;
          }
        }

        addDays += (6 - curDay);
        print("next day is $addDays");
      }

      DateTime present = DateTime.now();
      upcomingDate = DateTime(present.year, present.month, present.day)
          .add(Duration(days: addDays + 1));
    }

    print(
        "notification time ${widget.recall.notificationTime} ${widget.recall.notificationTime.hour} ${widget.recall.notificationTime.minute}");

    upcomingDate = DateTime(
        upcomingDate.year,
        upcomingDate.month,
        upcomingDate.day,
        widget.recall.notificationTime.hour,
        widget.recall.notificationTime.minute);

    return DateFormat("dd MMM yyyy hh:mm a").format(upcomingDate).toString();
  }

  String _getActionPillText() {
    if (widget.type == RecallType.REVISION) {
      if (widget.recall.active) return 'Mark Complete';
      return 'Repeat';
    } else {
      if (widget.recall.active) return 'Pause';
      return 'Start';
    }
  }

  // add notification turn off on deactivation
  _actionPillFun() async {
    if (widget.type == RecallType.REVISION) {
      if (widget.recall.active) {
        widget.recall.active = false;
      } else {
        widget.recall.active = true;
        int diff =
            DateTime.now().difference(widget.recall.sessions[0]).inDays + 1;
        widget.recall.sessions = widget.recall.sessions
            .map((session) => session.add(Duration(days: diff)))
            .toList();
      }
    } else {
      if (widget.recall.active) {
        widget.recall.active = false;
      } else {
        widget.recall.active = true;
      }
    }
    bool res =
        await PreferenceManager().updateRecall(widget.type, widget.recall);
    if (res) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    _width = MediaQuery.of(context).size.width;
    item = widget.recall;
    print(widget.type == RecallType.HABIT ? 'habit' : 'revision');

    return AnnotatedRegion(
      value: CustomAppTheme.systemUiOverlayConstant,
      child: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop('reload');
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              height: _height,
              width: _width,
              child: Column(
                children: [
                  Header(
                    headerText: item.title,
                    onPop: () {
                      Navigator.of(context).pop("random");
                    },
                    actionPill: Container(
                      margin: EdgeInsets.only(
                        right: 20,
                      ),
                      child: ActionPill(
                        text: _getActionPillText(),
                        action: _actionPillFun,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return SessionList(
                            type: widget.type,
                            item: item,
                          );
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 30,
                          right: 30,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Text(
                                    "Upcoming Session",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Text(
                                    // DateFormat('dd MMM yyyy at HH:MM a')
                                    //     .format(
                                    //         item.sessions[item.completedSteps])
                                    //     .toString(),
                                    _getUpcomingSession(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: CustomAppTheme.primaryColor
                                        .withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 30,
                          right: 30,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Text(
                                    "Description",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 10,
                              ),
                              child: Text(
                                item.description,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      right: 20,
                      bottom: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 30,
                            right: 30,
                            bottom: 10,
                          ),
                          child: Text(
                            "Files",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ActionPill(
                          text: "Add Files",
                          action: () {},
                        ),
                      ],
                    ),
                  ),
                  RecallFiles(
                    files: item.files.map((e) => e.toString()).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
