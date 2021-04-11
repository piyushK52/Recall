import 'package:flutter/material.dart';
import 'package:recall/values/custom_app_theme.dart';
import 'package:recall/widgets/pill.dart';

class Header extends StatelessWidget {
  ActionPill actionPill;
  Function onPop;
  String headerText;

  Header({this.headerText, this.onPop, this.actionPill});
  @override
  Widget build(BuildContext context) {
    return Container(
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
              onTap: onPop,
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
              maxWidth: actionPill != null ? 220 : 300,
            ),
            child: Text(
              headerText,
              style: CustomAppTheme.heading1.copyWith(
                fontSize: 22,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spacer(),
          actionPill ?? Container(),
          Spacer(),
        ],
      ),
    );
  }
}
