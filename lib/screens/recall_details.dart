import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recall/models/recall_model.dart';
import 'package:recall/screens/session_list.dart';
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
                      text: "Mark Complete",
                      action: () {},
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
                          sessions: item.sessions,
                          completed: item.completedSteps,
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
                                  "random",
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
                  files: item.files,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
