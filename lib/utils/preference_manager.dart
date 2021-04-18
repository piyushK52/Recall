import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recall/models/recall_model.dart';
import 'package:recall/values/app_constants.dart';
import 'package:recall/values/current_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  SharedPreferences _sharedPreferences;

  PreferenceManager();

  saveRecall({RecallModel data, RecallType type}) async {
    List<RecallModel> recallList = await getRecallList(type = type);
    recallList.add(data);
    if (type == RecallType.REVISION) {
      CurrentData.revisionList = recallList;
    } else {
      CurrentData.habitList = recallList;
    }
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setString(
        type == RecallType.REVISION ? 'revision' : 'habit',
        jsonEncode(recallList.map((e) => e.toJson()).toList()));
    return true;
  }

  removeRecall({RecallModel data, RecallType type}) async {}

  Future<List<RecallModel>> getRecallList(RecallType type) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    var list = _sharedPreferences
        .getString(type == RecallType.REVISION ? 'revision' : 'habit');
    print("list found out --> $list");
    if (list == null) {
      list = '[]';
    }
    List<RecallModel> res = [];
    jsonDecode(list).forEach((item) {
      res.add(RecallModel.fromJson(item));
    });
    return res;
  }
}
