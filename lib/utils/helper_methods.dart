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
}
