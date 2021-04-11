import 'package:flutter/material.dart';
import 'package:recall/values/custom_app_theme.dart';

class ActionPill extends StatelessWidget {
  String text;
  Function action;
  ActionPill({this.text, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: CustomAppTheme.darkPrimaryColor,
        ),
      ),
    );
  }
}
