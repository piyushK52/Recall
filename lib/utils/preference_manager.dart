import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth.dart';
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

  updateRecall(RecallType type, RecallModel recall) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    var list = _sharedPreferences
        .getString(type == RecallType.REVISION ? 'revision' : 'habit');
    if (list == null) {
      list = '[]';
    }
    List<RecallModel> res = [];
    jsonDecode(list).forEach((item) {
      res.add(RecallModel.fromJson(item));
    });
    res.removeWhere((item) => item.uuid == recall.uuid);
    res.add(recall);
    return await _sharedPreferences.setString(
        type == RecallType.REVISION ? 'revision' : 'habit',
        jsonEncode(res.map((e) => e.toJson()).toList()));
  }

  clearAllData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    var auth = _sharedPreferences.getString("auth");
    await _sharedPreferences.clear();
    return await _sharedPreferences.setString("auth", auth);
  }

  getData(key) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString(key);
  }

  // google driver methods
  //Save Credentials
  Future saveCredentials(AccessToken token, String refreshToken) async {
    print(token.expiry.toIso8601String());
    Map<String, dynamic> auth = {
      "type": token.type,
      "data": token.data,
      "expiry": token.expiry.toString(),
      "refreshToken": refreshToken
    };
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('auth', jsonEncode(auth));
  }

  //Get Saved Credentials
  Future<Map<String, dynamic>> getCredentials() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    var result = _sharedPreferences.getString("auth");
    if (result == null || result.length == 0) return null;
    return jsonDecode(result);
  }

  //Clear Saved Credentials
  Future clear() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setString('auth', '');
  }
}
