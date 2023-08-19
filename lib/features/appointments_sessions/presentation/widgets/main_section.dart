import 'package:flutter/material.dart';
import './/core/app_colors.dart';

class AppointmentsMainSection extends StatelessWidget {
  final double sectionWidth;

  const AppointmentsMainSection({
    Key? key,
    required this.sectionWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Row(
        children: [
          //to be removed
          Container(
            width: screenWidth - sectionWidth,
            color: AppColors.black,
          ),
          //return starts here
          Container(
            width: sectionWidth,
          )
        ],
      ),
    );
  }
}
