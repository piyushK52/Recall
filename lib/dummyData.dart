import 'package:recall/models/recall_model.dart';

class DummyData {
  static List<RecallModel> list = [
    RecallModel(
        title: 'New',
        description: 'random recall',
        totalSteps: 4,
        completedSteps: 2,
        sessions: [],
        notificationTime: DateTime.now()),
  ];

  static RecallModel obj = RecallModel(
      title: 'New',
      description: 'random recall',
      totalSteps: 4,
      completedSteps: 2,
      sessions: [],
      notificationTime: DateTime.now());
}
