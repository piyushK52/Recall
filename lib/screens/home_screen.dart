import 'package:flutter/material.dart';
import 'package:recall/screens/create_recall.dart';
import 'package:recall/screens/recall_list.dart';
import 'package:recall/screens/splash_screen.dart';
import 'package:recall/utils/google_drive.dart';
import 'package:recall/utils/helper_methods.dart';
import 'package:recall/utils/notifications_plugin.dart';
import 'package:recall/utils/preference_manager.dart';
import 'package:recall/values/app_constants.dart';
import 'package:recall/values/current_data.dart';
import 'package:recall/values/custom_app_theme.dart';
import 'package:recall/widgets/custom_tabs.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _height, _width;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final rebuildNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
  }

  _getDriveData() async {
    var drive = GoogleDrive();
    bool res = await drive.listGoogleDriveFiles();
    print("result found out ----- $res");
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        HelperMethods.fetchStoredLists();
      });
    });
  }

  _uploadDriveData() async {
    await _uploadCurData(type: RecallType.HABIT);
    await _uploadCurData(type: RecallType.REVISION);
  }

  _uploadCurData({type}) async {
    var drive = GoogleDrive();
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/' +
        (type == RecallType.HABIT
            ? '${AppConstants.HABIT_GOOGLE_DRIVE_FILE}'
            : '${AppConstants.REVISION_GOOGLE_DRIVE_FILE}');

    if (await File(filePath).exists()) {
      print("previous file deleted");
      File(filePath).delete();
    }

    File newFile = File(filePath);
    String data = await PreferenceManager()
            .getData(type == RecallType.HABIT ? 'habit' : 'revision') ??
        '';
    print("writing data $data");
    newFile.writeAsString(data.toString());

    await drive.deleteFile(
        filename: type == RecallType.HABIT
            ? AppConstants.HABIT_GOOGLE_DRIVE_FILE
            : AppConstants.REVISION_GOOGLE_DRIVE_FILE);
    var res = await drive.upload(newFile);
    print("******************");
    if (res) {
      HelperMethods.showSnackBar(
          key: scaffoldKey, str: "File uploaded successfully");
      return true;
    } else {
      HelperMethods.showSnackBar(key: scaffoldKey, str: "Operation Failed...");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    _width = MediaQuery.of(context).size.width;

    return AnnotatedRegion(
      value: CustomAppTheme.systemUiOverlayConstant,
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, CreateRecall.routeName)
                  .then((value) {
                if (value == 'reload') {
                  // rebuildNotifier.value += 1;
                  setState(() {});
                }
              });
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            backgroundColor: CustomAppTheme.primaryColor,
          ),
          body: Container(
            height: _height,
            padding: EdgeInsets.all(
              CustomAppTheme.globalPadding,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                        left: 15,
                        bottom: 10,
                      ),
                      child: Text(
                        "Recall",
                        style: CustomAppTheme.heading1,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            HelperMethods.showAlertDialog(
                                context: context,
                                str1: 'Cancel',
                                fun1: popPage,
                                str2: 'Continue',
                                fun2: clearAll,
                                title: "Clear All Data",
                                desc:
                                    "Are you sure you want to clear all data?");
                            // print("sending notification");
                            // await notificationPlugin.scheduleNotification();
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color:
                                  CustomAppTheme.primaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              "Clear All Data",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            // HelperMethods.showAlertDialog(
                            //     context: context,
                            //     str1: 'Cancel',
                            //     fun1: popPage,
                            //     str2: 'Continue',
                            //     fun2: clearAll,
                            //     title: "Clear All Data",
                            //     desc: "Are you sure you want to clear all data?");
                            print('uploading file');
                            _uploadDriveData();
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color:
                                  CustomAppTheme.primaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              "Upload",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            // HelperMethods.showAlertDialog(
                            //     context: context,
                            //     str1: 'Cancel',
                            //     fun1: popPage,
                            //     str2: 'Continue',
                            //     fun2: clearAll,
                            //     title: "Clear All Data",
                            //     desc: "Are you sure you want to clear all data?");
                            print('fetching files');
                            _getDriveData();
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color:
                                  CustomAppTheme.primaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              "Get",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 10,
                          ),
                          constraints: BoxConstraints.expand(height: 50),
                          child: CustomTabBar(
                            isScrollable: true,
                            unselectedLabelColor: CustomAppTheme.primaryColor,
                            //labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            labelColor: Colors.white,
                            indicatorSize: CustomTabBarIndicatorSize.label,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: CustomAppTheme.primaryColor,
                            ),
                            tabs: [
                              CustomTab(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 0, bottom: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: CustomAppTheme.primaryColor,
                                          width: 1)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("Habits"),
                                  ),
                                ),
                              ),
                              CustomTab(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 0, bottom: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(
                                          color: CustomAppTheme.primaryColor,
                                          width: 1)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("Revision"),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: CustomTabBarView(
                            children: [
                              RecallList(
                                type: RecallType.HABIT,
                              ),
                              RecallList(
                                type: RecallType.REVISION,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  popPage() {
    Navigator.of(context).pop();
  }

  clearAll() async {
    await PreferenceManager().clear();
    bool res = await PreferenceManager().clearAllData();
    print('result -> $res');
    if (res) {
      CurrentData.habitList = [];
      CurrentData.revisionList = [];
      Navigator.pop(context);
      setState(() {});
    }
  }
}
