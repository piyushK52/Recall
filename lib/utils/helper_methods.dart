import 'package:flutter/material.dart';

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
}
