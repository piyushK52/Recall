import 'package:flutter/material.dart';
import 'package:recall/utils/helper_methods.dart';
import 'package:recall/values/custom_app_theme.dart';
import 'package:recall/widgets/header.dart';
import 'package:recall/widgets/revision_gaps.dart';
import 'package:recall/widgets/weekday_selector.dart';
import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

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
  ValueNotifier<int> _sessionType = ValueNotifier<int>(1);
  String sessionValue = '';
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String selectedTimeString = 'Select a Time', descriptionText = '';
  List<String> filePaths = [];

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        // _hour = selectedTime.hour.toString();
        // _minute = selectedTime.minute.toString();
        // _time = _hour + ' : ' + _minute;
        // _timeController.text = _time;
        selectedTimeString = formatDate(
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            // height: _height,
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
                      SizedBox(
                        height: 20,
                      ),
                      _timeSelection(),
                      SizedBox(
                        height: 20,
                      ),
                      _description(),
                      SizedBox(
                        height: 20,
                      ),
                      _fileLinks(),
                      SizedBox(
                        height: 50,
                      ),
                      _submitBtn(),
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

  showError({str}) {}

  bool _isFormCorrect() {
    if (_value == 1) {
      final regex = RegExp(r'^\d+\-(\d+\-)+\d+$');
      if (!regex.hasMatch(sessionValue)) {
        showError(str: 'session string is not correct');
        return false;
      }
    } else if (!_daysSelected.contains(true)) {
      showError(str: "no days selected for habit track");
      return false;
    }

    if (selectedTimeString == 'Select a Time') {
      showError(str: "no time selected");
      return false;
    }
  }

  _saveForm() {
    // create recall object
    // save the object in preferences
  }

  Widget _submitBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (_isFormCorrect()) {
              _saveForm();
            }
          },
          child: Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
              color: CustomAppTheme.primaryColor.withOpacity(0.6),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ),
      ],
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
                  _sessionType.value = value;
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
          ValueListenableBuilder(
            valueListenable: _sessionType,
            builder: (_, session, child) {
              return session == 2
                  ? WeekDaySelector(
                      onChanged: (int day) {
                        setState(() {
                          final index = day % 7;
                          print("index found out $index");
                          _daysSelected[index] = !_daysSelected[index];
                        });
                      },
                      selectedDays: _daysSelected,
                    )
                  : RevisionGap(
                      initialValue: sessionValue,
                      setRevisionGap: (text) {
                        sessionValue = text;
                      },
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _timeSelection() {
    return Container(
      width: _width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fieldTitle("Notification Time"),
          GestureDetector(
            onTap: () {
              _selectTime(context);
            },
            child: Container(
              width: _width / 2,
              height: 30,
              margin: EdgeInsets.only(
                top: 10,
              ),
              // color: Colors.lightBlue,
              child: Text(
                selectedTimeString,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _description() {
    return Container(
      width: _width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fieldTitle("Description"),
          Container(
            // width: _width / 2,
            // height: 30,
            margin: EdgeInsets.only(
              top: 10,
            ),
            // color: Colors.lightBlue,
            child: TextFormField(
              initialValue: descriptionText,
              decoration: InputDecoration(hintText: "Enter a description"),
              onChanged: (text) {
                descriptionText = text;
              },
              minLines: 4,
              maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fileLinks() {
    List<Widget> files = [];
    files.add(_addFileBtn());

    filePaths.forEach((path) {
      files.add(_fileTile(path: path));
    });
    return Container(
      width: _width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fieldTitle("Files"),
          Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
            child: Wrap(
              children: files,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fileTile({path}) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
      ),
      child: GestureDetector(
        onTap: () async {
          OpenFile.open(path);
        },
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: CustomAppTheme.primaryColor.withOpacity(0.3),
          ),
          child: Center(
            child: Text(HelperMethods.getType(path)),
          ),
        ),
      ),
    );
  }

  Widget _addFileBtn() {
    return GestureDetector(
      onTap: () async {
        FilePickerResult result =
            await FilePicker.platform.pickFiles(allowMultiple: false);
        if (result != null) {
          PlatformFile file = result.files.first;
          filePaths.add(file.path);
          setState(() {});
        }

        // else {
        //   print("file path stored is $filePath");
        //   OpenFile.open(filePath);
        // }
      },
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: CustomAppTheme.primaryColor.withOpacity(0.3),
        ),
        child: Icon(
          Icons.add,
          size: 35,
          color: Colors.white,
        ),
      ),
    );
  }
}
