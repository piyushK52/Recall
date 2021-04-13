import 'package:flutter/material.dart';
import 'package:recall/values/custom_app_theme.dart';

class WeekDaySelector extends StatefulWidget {
  List<bool> selectedDays;
  Function onChanged;

  WeekDaySelector({this.selectedDays, this.onChanged});

  @override
  _WeekDaySelectorState createState() => _WeekDaySelectorState();
}

class _WeekDaySelectorState extends State<WeekDaySelector> {
  double _width;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Container(
      width: _width,
      height: 40,
      margin: EdgeInsets.only(
        top: 10,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (ctx, idx) {
          return _daySelector(idx);
        },
      ),
    );
  }

  Widget _daySelector(idx) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(idx);
      },
      child: Container(
        height: 10,
        width: 40,
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          left: 3,
          right: 3,
        ),
        decoration: BoxDecoration(
            border: Border.all(
              color: CustomAppTheme.primaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20.0),
            color: widget.selectedDays[idx]
                ? CustomAppTheme.primaryColor
                : Colors.white),
        child: Text(
          (idx + 1).toString(),
          style: TextStyle(
            color: widget.selectedDays[idx] ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
