import 'package:flutter/material.dart';
import 'package:recall/widgets/header.dart';

class SessionList extends StatelessWidget {
  static const routeName = './main-screen/recall-details/session-list';

  List<DateTime> sessions = [];
  int completed;

  SessionList({this.sessions, this.completed});

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: _height,
          child: Column(
            children: [
              Header(
                headerText: 'Some random text which is very long',
                onPop: () {
                  Navigator.of(context).pop("random");
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (ctx, index) {
                    return _sessionItem(index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _sessionItem(index) {
    return Container(
      height: 50,
      color: Colors.lightBlueAccent,
    );
  }
}
