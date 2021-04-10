import 'package:flutter/material.dart';
import 'package:recall/screens/create_recall.dart';
import 'package:recall/screens/recall_list.dart';
import 'package:recall/values/app_constants.dart';
import 'package:recall/values/custom_app_theme.dart';
import 'package:recall/widgets/custom_tabs.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _height, _width;
  final rebuildNotifier = ValueNotifier<int>(0);

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
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, CreateRecall.routeName)
                  .then((value) {
                if (value == 'reload') {
                  rebuildNotifier.value += 1;
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
}
