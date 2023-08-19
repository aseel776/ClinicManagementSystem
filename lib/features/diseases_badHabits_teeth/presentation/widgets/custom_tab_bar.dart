import 'package:clinic_management_system/core/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  CustomTabBar({@required this.controller, @required this.tabs});

  final TabController? controller;
  final List<Widget>? tabs;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double tabBarScaling = screenWidth > 1400
        ? 0.17
        : screenWidth > 1100
            ? 0.3
            : 0.4;
    return Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.0),
      child: SizedBox(
        width: screenWidth * tabBarScaling,
        child: Theme(
          data: ThemeData(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent),
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            controller: controller,
            indicatorColor: AppColors.black,
            tabs: tabs!,
          ),
        ),
      ),
    );
  }
}
