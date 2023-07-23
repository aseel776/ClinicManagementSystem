import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/customs.dart';
import './/core/app_colors.dart';
import '../type_tile.dart';
import '../../../dummy_data.dart';
import '../../states/control_states.dart';

class TreatmentTypesSection extends StatelessWidget {
  final double sectionHeight;
  final double sectionWidth;
  final focusNode = FocusNode();

  TreatmentTypesSection(
      {Key? key, required this.sectionHeight, required this.sectionWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: sectionHeight,
        width: sectionWidth,
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
                'أنواع المعالجات',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.black,
                  fontSize: 24,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: sectionHeight * .75,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ...types.map(
                            (type) => TypeTile(
                              tileHeight: sectionHeight * .075,
                              tileWidth: sectionWidth * .75,
                              type: type,
                            ),
                          ),
                          createAddingField(),
                        ],
                      ),
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) => MaterialButton(
                      color: AppColors.lightGreen,
                      // color: AppColors.black,
                      height: sectionHeight * .085,
                      minWidth: sectionHeight * .2,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(
                          color: AppColors.lightGreen,
                          // color: AppColors.black,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                      splashColor: AppColors.lightBlue,
                      onPressed: () {
                        focusNode.requestFocus();
                        ref.read(addingType.notifier).state = true;
                      },
                      child: const Text(
                        'إضافة نوع',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.black,
                          // color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  createAddingField() {
    double tileHeight = sectionHeight * .075;
    double tileWidth = sectionWidth * .75;
    return Consumer(builder: (context, ref, child) {
      final isAdding = ref.watch(addingType);
      if (isAdding) {
        return SizedBox(
          height: tileHeight,
          width: tileWidth,
          child: TextFormField(
            focusNode: focusNode,
            cursorColor: AppColors.black,
            cursorHeight: tileHeight * .6,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              color: AppColors.black,
            ),
            decoration: InputDecoration(
              border: typeFieldBorder,
              focusedBorder: typeFieldBorder,
              contentPadding: EdgeInsets.only(bottom: -tileHeight * .2),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الحقل مطلوب';
              } else {
                return null;
              }
            },
            onFieldSubmitted: (value) {
              ref.read(addingType.notifier).state = false;
              if (value.isEmpty) {
                // _controller.text = type.name!;
              } else {
                //call add function
              }
            },
            onTapOutside: (event) {
              ref.read(addingType.notifier).state = false;
            },
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
