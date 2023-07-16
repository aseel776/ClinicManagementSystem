import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/features/treatments_feature/presentation/widgets/treatment_info.dart';
import 'package:flutter/material.dart';
import '../treatment_tile.dart';
import '../../../dummy_data.dart';
import '../../states/is_expanded.dart';

class TreatmentsSection extends StatelessWidget {
  final double sectionWidth;
  final double sectionHeight;

  const TreatmentsSection(
      {Key? key, required this.sectionWidth, required this.sectionHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isExpanded,
      builder: (context, isExpandedValue, child) => SizedBox(
        height: sectionHeight,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 750),
                curve: Curves.linear,
                width: sectionWidth,
                height: isExpandedValue ? sectionHeight : sectionHeight * .495,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: sectionHeight * .025,
                      ),
                      height: sectionHeight * .1,
                      child: const Text(
                        'المعالجات',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.black,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        child: buildTreatmentsGridView(),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isExpandedValue)
                SizedBox(
                  height: sectionHeight * .505,
                  child: Column(
                    children: [
                      SizedBox(
                        height: sectionHeight * .01,
                      ),
                      TreatmentInfo(
                        containerHeight: sectionHeight * .495,
                        containerWidth: sectionWidth,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  buildTreatmentsGridView() {
    int rowsCount = (treatments.length / 2).ceil();
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int r = 0, i = 0;
              r < rowsCount && i < treatments.length;
              r++, i += 2)
            Row(
              children: [
                Expanded(
                  child: TreatmentTile(
                    sectionWidth: sectionWidth,
                    sectionHeight: sectionHeight,
                    treatment: treatments[i],
                    key: Key(treatments[i].id.toString()),
                  ),
                ),
                if (i + 1 < treatments.length)
                  Expanded(
                    child: TreatmentTile(
                      sectionWidth: sectionWidth,
                      sectionHeight: sectionHeight,
                      treatment: treatments[i + 1],
                      key: Key(treatments[i + 1].id.toString()),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
