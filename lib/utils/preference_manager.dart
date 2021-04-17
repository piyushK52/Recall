import 'package:recall/models/recall_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  SharedPreferences _sharedPreferences;

  PreferenceManager();

  saveRecall(RecallModel data, String type) async {}

  removeRecall(RecallModel data, String type) async {}

  Future<List<RecallModel>> getRecallList(String type) async {
    return Future.delayed(Duration(milliseconds: 100), () {
      return [];
    });
  }
}
