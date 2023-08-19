import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/features/diseases_badHabits_teeth/presentation/pages/diseases.dart';
import 'package:flutter/material.dart';

import '../widgets/content_view.dart';
import '../widgets/custom_tab.dart';
import '../widgets/custom_tab_bar.dart';
import '../widgets/tab_controller_handler.dart';
import 'badHabits.dart';

class General extends StatefulWidget {
  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> with SingleTickerProviderStateMixin {
  TabController? tabController;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  double? screenHeight;
  double? screenWidth;
  double? topPadding;
  double? bottomPadding;
  double? sidePadding;

  List<ContentView> contentViews = [
    ContentView(
      tab: CustomTab(title: 'الأمراض'),
      content: DiseaseListPage(),
    ),
    ContentView(
      tab: CustomTab(title: 'العادات السيئة '),
      content: BadHabits(),
    ),
    ContentView(
      tab: CustomTab(title: 'مشاكل الأسنان'),
      content: Container(),
    )
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: contentViews.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    topPadding = screenHeight! * 0.025;
    bottomPadding = screenHeight! * 0.01;
    sidePadding = screenWidth! * 0.05;
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      key: scaffoldKey,
      body: Padding(
          padding: EdgeInsets.only(top: topPadding!, bottom: bottomPadding!),
          child: desktopView()),
    );
  }

  Widget desktopView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Tab Bar
        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Container(
            width: 470,
            height: screenHeight! * 0.08,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(10), right: Radius.circular(10))),
            child: CustomTabBar(
                controller: tabController,
                tabs: contentViews.map((e) => e.tab!).toList()),
          ),
        ),

        /// Tab Bar View
        SingleChildScrollView(
          child: SizedBox(
            height: screenHeight! * 0.77,
            child: TabControllerHandler(
              tabController: tabController!,
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: contentViews.map((e) => e.content!).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
