import 'package:flutter/material.dart';
import 'package:recall/widgets/header.dart';
import 'package:recall/widgets/weekday_selector.dart';

class CreateRecall extends StatefulWidget {
  static const routeName = '/home-screen/create-recall';

  @override
  _CreateRecallState createState() => _CreateRecallState();
}

class _CreateRecallState extends State<CreateRecall> {
  double _height, _width;
  int _value = 1;
  List<DropdownMenuItem> _recallTypeList = [
    DropdownMenuItem(
      child: Text("Revision"),
      value: 1,
    ),
    DropdownMenuItem(
      child: Text("Habit"),
      value: 2,
    ),
  ];
  List<bool> _daysSelected = [false, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: _height,
          width: _width,
          child: Column(
            children: [
              Header(
                headerText: 'Create Recall',
                onPop: () {
                  Navigator.of(context).pop("refresh");
                },
              ),
              Container(
                width: _width,
                // color: Colors.lightBlueAccent,
                margin: EdgeInsets.only(
                  top: 20,
                ),
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: [
                    _typeSelection(),
                    SizedBox(
                      height: 20,
                    ),
                    _sessionSelection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldTitle(text) {
    return Container(
      width: _width,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _typeSelection() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fieldTitle("Type"),
          DropdownButton(
              value: _value,
              items: _recallTypeList,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              }),
        ],
      ),
    );
  }

  Widget _sessionSelection() {
    return Container(
      width: _width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fieldTitle("Session"),
          WeekDaySelector(
            onChanged: (int day) {
              setState(() {
                final index = day % 7;
                print("index found out $index");
                _daysSelected[index] = !_daysSelected[index];
              });
            },
            selectedDays: _daysSelected,
          ),
        ],
      ),
    );
  }
}
