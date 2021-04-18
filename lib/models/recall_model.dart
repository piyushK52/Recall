import 'dart:convert';
import 'dart:developer' as dev;

class RecallModel {
  String title, description, uuid;
  int totalSteps, completedSteps;
  List<DateTime> sessions = [];
  DateTime notificationTime;
  List<dynamic> files;
  List<bool> days;

  RecallModel(
      {this.title,
      this.uuid,
      this.description,
      this.totalSteps,
      this.completedSteps,
      this.sessions,
      this.notificationTime,
      this.files,
      this.days});

  factory RecallModel.fromJson(Map<String, dynamic> json) {
    return RecallModel(
        uuid: json['uuid'],
        title: json['title'],
        description: json['description'],
        totalSteps: json['totalSteps'],
        completedSteps: json['completedSteps'],
        sessions: RecallModel.getSessions(jsonDecode(json['sessions'])),
        notificationTime: DateTime.parse(json['notificationTime']),
        days: RecallModel.getDays(jsonDecode(json['days'])),
        files: json['files'].map((e) => e.toString()).toList());
  }

  static List<bool> getDays(list) {
    print("list for parsing $list");
    List<bool> res = [];
    list.forEach((item) {
      if (item.toString().toLowerCase() == 'true') {
        res.add(true);
      } else {
        res.add(false);
      }
    });
    print("final result $res");
    return res;
  }

  static getSessions(list) {
    List<DateTime> res = [];
    list.forEach((dt) {
      res.add(DateTime.parse(dt));
    });
    // dev.debugger();
    return res;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'uuid': uuid,
        'description': description,
        'totalSteps': totalSteps,
        'completedSteps': completedSteps,
        'sessions': jsonEncode(sessions.map((e) => e.toString()).toList()),
        'notificationTime': notificationTime.toString(),
        'days': jsonEncode(days),
        'files': files
      };
}
