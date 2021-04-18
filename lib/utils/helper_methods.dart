import 'package:flutter/material.dart';
import 'package:recall/utils/preference_manager.dart';
import 'package:recall/values/current_data.dart';

class HelperMethods {
  static String getType(String path) {
    path = path != null ? path.toLowerCase() : path;
    if (path == null || path == '') {
      return 'document';
    } else if (path.contains('.pdf')) {
      return 'pdf';
    } else if (path.contains('.doc') || path.contains('.docx')) {
      return 'doc';
    } else if (path.contains('.jpg') ||
        path.contains('.jpeg') ||
        path.contains('.png')) {
      return 'image';
    }

    return 'pdf';
  }

  static showSnackBar({key, String str}) {
    key.currentState.showSnackBar(SnackBar(
      content: Text(
        str,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black87,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static showAlertDialog(
      {BuildContext context,
      String str1,
      Function fun1,
      String str2,
      Function fun2,
      String title,
      String desc}) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(str1),
      onPressed: fun1,
    );
    Widget continueButton = FlatButton(
      child: Text(str2),
      onPressed: fun2,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(desc),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
