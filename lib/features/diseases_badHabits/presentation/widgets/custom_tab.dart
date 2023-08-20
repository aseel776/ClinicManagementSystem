import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/core/primaryText.dart';
import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  CustomTab({@required this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Tab(
        child:
            PrimaryText(text: this.title!, size: 16, color: AppColors.black));
  }
}
