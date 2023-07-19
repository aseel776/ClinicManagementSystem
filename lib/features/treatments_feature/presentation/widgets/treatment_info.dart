import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './/core/app_colors.dart';
import '../states/control_states.dart';
import '../../data/models/treatment_model.dart';

class TreatmentInfo extends StatelessWidget {
  const TreatmentInfo(
      {Key? key, required this.containerWidth, required this.containerHeight})
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: containerHeight * .15,
              decoration: BoxDecoration(
                color: treatment.color!,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      isExpanded.value = true;
                    },
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                      ),
                    ),
                    elevation: 0,
                    hoverElevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    backgroundColor: treatment.color!,
                    child: const Icon(
                      Icons.close,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero
                    ),
                    elevation: 0,
                    hoverElevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    backgroundColor: treatment.color!,
                    child: const Icon(
                      Icons.edit,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: containerHeight * .05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المعالجة: ${treatment.name!}',
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          color: AppColors.black),
                    ),
                    SizedBox(height: containerHeight * .01),
                    Text(
                      'السعر: ${treatment.price!} ل.س',
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          color: AppColors.black),
                    ),
                    SizedBox(height: containerHeight * .01),
                    const Text(
                      'الخطوات:',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          color: AppColors.black),
                    ),
                    SizedBox(height: containerHeight * .01),
                    ...treatment.steps!
                        .map((step) => Text(
                              '- ${step.name!}',
                              style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 18,
                                  color: AppColors.black),
                            ))
                        .toList()
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'النوع: ${treatment.type!.name!}',
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          color: AppColors.black),
                    ),
                    SizedBox(height: containerHeight * .01),
                    Row(
                      children: [
                        const Text(
                          'اللون: ',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18,
                              color: AppColors.black),
                        ),
                        InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              String colorCode =
                                  '#${treatment.color!.value.toRadixString(16).substring(2).toUpperCase()}';
                              Clipboard.setData(ClipboardData(text: colorCode));
                            },
                            child: Tooltip(
                              message: 'Copy',
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  '#${treatment.color!.value.toRadixString(16).substring(2).toUpperCase()}',
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 18,
                                      fontFamily: 'Cairo'),
                                ),
                              ),
                            ))
                      ],
                    ),
                    SizedBox(height: containerHeight * .01),
                    const Text(
                      'القنوات:',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          color: AppColors.black),
                    ),
                    SizedBox(height: containerHeight * .01),
                    if (treatment.channels!.isNotEmpty)
                      ...treatment.channels!
                          .map((channel) => Text(
                                '- $channel',
                                style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 18,
                                    color: AppColors.black),
                              ))
                          .toList(),
                    if (treatment.channels!.isEmpty)
                      const Text(
                        'لا يوجد',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          color: AppColors.black,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
