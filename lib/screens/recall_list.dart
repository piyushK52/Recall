import 'package:flutter/material.dart';
import 'package:recall/values/app_constants.dart';
import 'package:recall/values/custom_app_theme.dart';

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        highlightColor: Colors.transparent,
        child: Container(
          // height: 80,
          margin: EdgeInsets.only(
            top: 5,
            bottom: 5,
          ),
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            color: CustomAppTheme.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 5,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 20,
                  ),
                  width: 200,
                  // color: Colors.lightBlue,
                  child: Text(
                    "Some random text that is too long",
                    style: CustomAppTheme.heading2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  height: 70,
                  padding: EdgeInsets.only(
                    top: 5.0,
                    bottom: 5.0,
                    left: 10.0,
                    right: 10.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: CustomAppTheme.primaryColor.withOpacity(0.9),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 5,
                        ),
                        child: Text(
                          widget.type == RecallType.HABIT ? "350" : "100%",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 5.0,
                        ),
                        child: Text(
                          widget.type == RecallType.HABIT
                              ? "Days Streak"
                              : "Done",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: CustomAppTheme.primaryColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
