import 'package:flutter/material.dart';
import './/core/app_colors.dart';
import '../../data/models/treatment_type_model.dart';

class TypeTile extends StatelessWidget {
  final double tileHeight;
  final double tileWidth;
  final TreatmentTypeModel type;
  const TypeTile({Key? key, required this.tileHeight, required this.tileWidth, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: tileHeight,
      width: tileWidth,
      padding: EdgeInsets.symmetric(horizontal: tileWidth * .01),
      margin: EdgeInsets.symmetric(vertical: tileHeight * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: tileWidth * .1,
            child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.transparent,
            elevation: 0,
            hoverElevation: 0,
            highlightElevation: 0,
            splashColor: AppColors.lightGreen,
            child: const Icon(
              Icons.edit,
              color: AppColors.black,
            ),
          ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  type.name!,
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 20,
                      color: AppColors.black
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_left, color: AppColors.black,),
              ],
            ),
          ),
        ],
      )
    );
  }
}
