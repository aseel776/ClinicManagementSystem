import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/features/treatments_feature/data/models/treatment_model.dart';
import 'package:clinic_management_system/features/treatments_feature/presentation/states/is_expanded.dart';
import 'package:clinic_management_system/features/treatments_feature/presentation/states/selected_treatment.dart';
import 'package:flutter/material.dart';

class TreatmentInfo extends StatelessWidget {
  const TreatmentInfo(
      {Key? key,
      required this.containerWidth,
      required this.containerHeight})
      : super(key: key);

  final double containerWidth;
  final double containerHeight;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TreatmentModel>(
      valueListenable: selectedTreatment!,
      builder: (context, treatment, child) => Container(
        width: containerWidth,
        height: containerHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          // color: treatment.color!.withOpacity(.2),
          // border: Border.all(
          //   color: treatment.color!.withOpacity(.25),
          // ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: containerWidth * .001,
                ),
                IconButton(
                  onPressed: () {
                    isExpanded.value = true;
                  },
                  icon: Icon(
                    Icons.close,
                    size: 24,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit,
                    size: 24,
                  ),
                ),
              ],
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'اسم المعالجة: ${treatment.name!}',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        color: AppColors.black
                      ),
                    )
                  ],
                ),
                Column(
                  children: [

                  ],
                ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
}
