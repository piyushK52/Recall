import 'package:flutter/material.dart';
import 'package:recall/values/custom_app_theme.dart';

class RevisionGap extends StatefulWidget {
  Function setRevisionGap;
  String initialValue;

  RevisionGap({this.setRevisionGap, this.initialValue});
  @override
  _RevisionGapState createState() => _RevisionGapState();
}

class _RevisionGapState extends State<RevisionGap> {
  TextEditingController _textEditingController;
  double _width;

  @override
  Widget build(BuildContext context) {
    _textEditingController = TextEditingController(text: widget.initialValue);
    _width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: _width / 2,
          child: TextField(
            controller: _textEditingController,
            onChanged: (text) {
              widget.setRevisionGap(text);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 10,
          ),
          child: Text(
            "Enter in the format '2-4-5-10' days gap",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
