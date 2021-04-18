import 'dart:convert';
import 'dart:developer' as dev;

class RecallModel {
  String title, description;
  int totalSteps, completedSteps;
  List<DateTime> sessions = [];
  DateTime notificationTime;
  List<String> files;

  RecallModel(
      {this.title,
      this.description,
      this.totalSteps,
      this.completedSteps,
      this.sessions,
      this.notificationTime,
      this.files});

  factory RecallModel.fromJson(Map<String, dynamic> json) {
    return RecallModel(
        title: json['title'],
        description: json['description'],
        totalSteps: json['totalSteps'],
        completedSteps: json['completedSteps'],
        sessions: RecallModel.getSessions(jsonDecode(json['sessions'])),
        notificationTime: DateTime(json['notificationTime']),
        files: json['files']);
  }

  static getSessions(list) {
    List<DateTime> res = [];
    list.forEach((dt) {
      res.add(DateTime(dt));
    });
    // dev.debugger();
    return res;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'totalSteps': totalSteps,
        'completedSteps': completedSteps,
        'sessions': jsonEncode(sessions.map((e) => e.toString()).toList()),
        'notificationTime': notificationTime.toString(),
        'files': files
      };
}
