import 'package:flutter/material.dart';
import 'package:recall/values/app_constants.dart';
import 'package:recall/values/custom_app_theme.dart';

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
                          maxWidth: 250,
                        ),
                        child: Text(
                          'Some random text that is too long',
                          style: CustomAppTheme.heading1.copyWith(
                            fontSize: 25,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 25,
                        padding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        decoration: BoxDecoration(
                          color: CustomAppTheme.primaryColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "Mark Complete",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: CustomAppTheme.darkPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
