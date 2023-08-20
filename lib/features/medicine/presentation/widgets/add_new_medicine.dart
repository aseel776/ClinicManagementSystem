import 'dart:ui';

import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/features/medicine/presentation/widgets/text_field.dart';
import 'package:clinic_management_system/features/medicine/presentation/widgets/type_drop_down.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/step1_form.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddMedicineDialog {
  List<String> medicineTypes = [
    'نوع 1',
    'نوع 2',
    'نوع 3',
    'نوع 4',
  ];
  String selectedType = "نووع 1";

  Map<String, IconData> typeIcons = {
    'نوع 1': Icons.medical_services,
    'نوع 2': Icons.local_pharmacy,
    'نوع 3': Icons.healing,
    'نوع 4': Icons.personal_injury_outlined,
  };
  StateProvider medicineName =
      StateProvider<TextEditingController>((ref) => TextEditingController());
  StateProvider medicineConcentration =
      StateProvider<TextEditingController>((ref) => TextEditingController());

  showDialog1(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Dialog(
              backgroundColor: AppColors.lightGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                final double maxWidth = constraints.maxWidth;
                final double maxHeight = constraints.maxHeight;

                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    color: AppColors.lightGrey,
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: maxWidth * 0.45,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: maxWidth * .009,
                        left: 0,
                        right: maxWidth * .01,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //pop up header
                          Padding(
                            padding: EdgeInsets.only(
                                left: maxWidth * .001, right: maxWidth * .001),
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: maxWidth * .001,
                                      right: maxWidth * .001),
                                  child: Text(
                                    "إضافة دواء جديد",
                                    style:
                                        TextStyle(fontSize: maxWidth * 0.018),
                                  ),
                                ),
                                SizedBox(
                                  width: maxWidth * 0.26,
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.close_rounded))
                              ],
                            ),
                          ),
                          //divider
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(
                              color: Colors.black38,
                            ),
                          ),
                          //all the text fields
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 1.0,
                              right: 40,
                            ),
                            child: SizedBox(
                              // width: maxWidth * 0.3,
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4.0, top: 5),
                                        child: Text(
                                          "الاسم ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: maxWidth * 0.04,
                                      ),
                                      SizedBox(
                                        width: maxWidth * 0.2,
                                        child: Container(
                                          child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: textfield(
                                                  "اسم الدواء",
                                                  ref
                                                      .watch(
                                                          medicineName.notifier)
                                                      .state,
                                                  "",
                                                  1)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: maxHeight * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4.0, top: 5),
                                        child: Text(
                                          "التركيز",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: maxWidth * 0.04,
                                      ),
                                      SizedBox(
                                        width: maxWidth * 0.2,
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: textfield(
                                              "مثلاً : 10",
                                              ref
                                                  .watch(medicineConcentration
                                                      .notifier)
                                                  .state,
                                              "",
                                              1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: maxHeight * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4.0, top: 5),
                                        child: Text(
                                          "الفئة ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: maxWidth * 0.044,
                                      ),
                                      SizedBox(
                                        width: maxWidth * 0.2,
                                        child: TypeDropDown(
                                          hintText: "الشكل الدوائي",
                                          items: [
                                            {
                                              'text': 'Option 1',
                                              'icon': Icons.check_circle,
                                            },
                                            {
                                              'text': 'Option 2',
                                              'icon': Icons.star,
                                            },
                                            {
                                              'text': 'Option 3',
                                              'icon': Icons.access_alarm,
                                            },
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: maxHeight * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4.0, top: 5),
                                        child: Text(
                                          "المواد الفعالة  ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: maxWidth * 0,
                                      ),
                                      Container(
                                        width: maxWidth * 0.2,
                                        child: TypeDropDown(
                                          hintText: "المواد الفعالة ",
                                          items: [
                                            {
                                              'text': 'Option 1',
                                              'icon': Icons.check_circle,
                                            },
                                            {
                                              'text': 'Option 2',
                                              'icon': Icons.star,
                                            },
                                            {
                                              'text': 'Option 3',
                                              'icon': Icons.access_alarm,
                                            },
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 12.0, left: 30),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white)),
                                  child: const Text(
                                    "حفظ",
                                    style: TextStyle(color: AppColors.black),
                                  ),
                                ),
                                SizedBox(
                                  width: maxWidth * .01,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white)),
                                  child: const Text(
                                    "إلغاء",
                                    style: TextStyle(color: AppColors.black),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })),
        );
      },
    );
  }
}
