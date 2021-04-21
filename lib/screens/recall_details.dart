import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recall/models/recall_model.dart';
import 'package:recall/screens/session_list.dart';
import 'package:recall/utils/helper_methods.dart';
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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  double _height, _width;
  RecallModel item;

  String _getUpcomingSession() {
    DateTime upcomingDate;
    if (widget.type == RecallType.REVISION) {
      int idx = widget.recall.completedSteps >= widget.recall.sessions.length
          ? widget.recall.sessions.length - 1
          : widget.recall.completedSteps;
      upcomingDate = widget.recall.sessions[idx];
    } else {
      int curDay = DateTime.now().weekday - 1;
      int addDays = -1, count = 0;
      print("current days selected ${widget.recall.days}");
      // for (int i = curDay; i < 7; i++) {
      //   if (widget.recall.days[i] && count++ == widget.recall.completedSteps) {
      //     addDays = i - curDay;
      //     break;
      //   }
      // }

      // if (addDays == -1) {
      //   for (int i = 0; i < 7; i++) {
      //     if (widget.recall.days[i]) {
      //       addDays = i;
      //       break;
      //     }
      //   }

      //   addDays += (6 - curDay);
      //   print("next day is $addDays");
      // }
      //

      //       DateTime present = DateTime.now();
      // upcomingDate = DateTime(present.year, present.month, present.day)
      //     .add(Duration(days: addDays + 1));

      int addCount = 0;
      for (int i = 0;; i++) {
        DateTime newDate =
            widget.recall.notificationTime.add(Duration(days: i));
        print("weekday is .... ${newDate.weekday}");
        if (widget.recall.days[newDate.weekday - 1] &&
            addCount++ == widget.recall.completedSteps) {
          upcomingDate = newDate;
          break;
        }
      }
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
    _updateRecall();
  }

  _addFiles() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      PlatformFile file = result.files.first;
      widget.recall.files.add(file.path);

      _updateRecall();
    }
  }

  deleteFile(int i) {
    widget.recall.files.removeAt(i);
    Navigator.of(context).pop();
    _updateRecall();
  }

  _updateRecall() async {
    bool res =
        await PreferenceManager().updateRecall(widget.type, widget.recall);
    if (res) {
      setState(() {});
    }
  }

  _getValue() {
    return widget.type == RecallType.HABIT
        ? item.completedSteps.toString() + ' Days streak'
        : (item.completedSteps / item.totalSteps * 100).toString() +
            '%' +
            ' Done';
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
            key: scaffoldKey,
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
                                    "Upcoming Session (" + _getValue() + ")",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 150,
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                        ),
                        child: _btn(
                            action: () {
                              print("marking as complete");
                              int nextStep = widget.recall.completedSteps + 1;
                              widget.recall.completedSteps =
                                  nextStep > widget.recall.sessions.length &&
                                          widget.type == RecallType.REVISION
                                      ? widget.recall.sessions.length
                                      : nextStep;
                              HelperMethods.showSnackBar(
                                  key: scaffoldKey,
                                  str: 'Session completed!!!');
                              _updateRecall();
                            },
                            text: 'Mark session as complete'),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 150,
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                        ),
                        child: _btn(
                            action: () {
                              print("marking as complete");
                              int nextStep = widget.recall.completedSteps - 1;
                              if (nextStep < 0) nextStep = 0;
                              widget.recall.completedSteps = nextStep;
                              HelperMethods.showSnackBar(
                                  key: scaffoldKey,
                                  str: 'Session marked incomplete!!!');
                              _updateRecall();
                            },
                            text: 'Un-mark session as complete'),
                      ),
                    ],
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
                          action: _addFiles,
                        ),
                      ],
                    ),
                  ),
                  RecallFiles(
                      files: item.files.map((e) => e.toString()).toList(),
                      delete: deleteFile),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _btn({action, text}) {
    return GestureDetector(
      onTap: () {
        action();
      },
      child: Container(
        alignment: Alignment.center,
        // height: 25,
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          top: 8,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: CustomAppTheme.primaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: CustomAppTheme.darkPrimaryColor,
          ),
        ),
      ),
    );
  }
}
