import 'package:flutter/material.dart';
import 'package:recall/values/app_constants.dart';
import 'package:recall/values/custom_app_theme.dart';
import 'package:recall/widgets/pill.dart';
import 'package:recall/widgets/recall_files.dart';

class RecallDetails extends StatefulWidget {
  static const routeName = './home-screen/recall-details';
  RecallType type;

  RecallDetails({this.type});

  @override
  _RecallDetailsState createState() => _RecallDetailsState();
}

class _RecallDetailsState extends State<RecallDetails> {
  double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    _width = MediaQuery.of(context).size.width;
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
                Container(
                  height: 50,
                  margin: EdgeInsets.only(
                    top: 5,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop("random");
                          },
                          highlightColor: Colors.transparent,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 220,
                        ),
                        child: Text(
                          'Some random text that is too long',
                          style: CustomAppTheme.heading1.copyWith(
                            fontSize: 22,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Spacer(),
                      ActionPill(
                        text: "Mark Complete",
                        action: () {},
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
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
                                  "28 July 2020 at 3:00 PM",
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
                              "Some random event text which should be of maximum 50 characters or something like that, will try to keep this short",
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
                  files: [
                    'a',
                    'b',
                    'c',
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
