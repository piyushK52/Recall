import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:recall/utils/helper_methods.dart';
import 'package:recall/values/custom_app_theme.dart';

class RecallFiles extends StatefulWidget {
  static const routeName = './main-screen/recall-details/recall-list';
  List<String> files = [];
  Function delete;

  RecallFiles({this.files, this.delete});
  @override
  _RecallFilesState createState() => _RecallFilesState();
}

class _RecallFilesState extends State<RecallFiles> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.files.length,
        itemBuilder: (ctx, index) {
          return _fileItem(index);
        },
      ),
    );
  }

  Widget _fileItem(i) {
    return Container(
      height: 60,
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: CustomAppTheme.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              print("open file item");
              OpenFile.open(widget.files[i]);
            },
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: CustomAppTheme.primaryColor.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.file_copy,
                    color: CustomAppTheme.primaryColor.withOpacity(0.8),
                  ),
                ),
                Container(
                  width: 200,
                  margin: EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text(
                    widget.files[i].split('/').last,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              print("deleting the file");
              HelperMethods.showAlertDialog(
                  context: context,
                  str1: 'Cancel',
                  fun1: popPage,
                  str2: 'Continue',
                  fun2: () => widget.delete(i),
                  title: "Delete File",
                  desc: "Are you sure you want delete this file?");
            },
            child: Row(
              children: [
                Container(
                  child: Icon(
                    Icons.delete,
                    color: CustomAppTheme.primaryColor.withOpacity(0.8),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          // Container(
          //   child: Icon(
          //     Icons.edit,
          //     color: CustomAppTheme.primaryColor.withOpacity(0.8),
          //   ),
          // ),
          // SizedBox(
          //   width: 10,
          // ),
        ],
      ),
    );
  }

  popPage() {
    Navigator.of(context).pop();
  }
}
