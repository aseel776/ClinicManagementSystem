import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';

class SearchField extends StatelessWidget {
  const SearchField(
      {super.key,
      required this.sectionWidth,
      required this.sectionHeight,
      required this.onTextChanged});

  final double sectionWidth;
  final double sectionHeight;
  final Function(String) onTextChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sectionWidth * 0.4,
      height: sectionHeight * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.grey, width: 3),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //search icon
          SizedBox(
            width: sectionWidth * .02,
            height: sectionHeight * .04,
            child: Icon(
              Icons.search,
              textDirection: TextDirection.rtl,
              color: AppColors.black.withOpacity(0.5),
              size: sectionWidth * .018,
            ),
          ),
          SizedBox(width: sectionWidth * .01),

          //text field
          SizedBox(
            width: sectionWidth * .3,
            child: TextField(
              scrollPadding: const EdgeInsets.all(0),
              onChanged: onTextChanged,
              textAlign: TextAlign.right,
              cursorColor: AppColors.black,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                color: AppColors.black.withOpacity(.8),
              ),
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: 'بحث',
                hintStyle: TextStyle(
                  fontFamily: 'Cairo',
                  height: 1.6,
                  fontSize: 18,
                  color: AppColors.black.withOpacity(.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
