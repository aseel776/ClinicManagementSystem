import 'dart:ui';

import 'package:clinic_management_system/core/app_colors.dart';
import 'package:flutter/material.dart';

class AddDialog {
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

  showDialog1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Dialog(
              backgroundColor: Colors.transparent,
              // insetPadding: EdgeInsets.only(
              //     bottom: 150,
              //     top: 50,
              //     left: MediaQuery.of(context).size.width * 0.1,
              //     right: MediaQuery.of(context).size.width * 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                final double maxWidth = constraints.maxWidth;
                final double maxHeight = constraints.maxHeight;
                // print(maxWidth);
                // print(MediaQuery.of(context).size.width);
                // print(maxHeight);
                // print(MediaQuery.of(context).size.height);
                return Container(
                  color: Colors.white,
                  height: maxHeight * 0.7,
                  width: maxWidth * 0.45,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: maxWidth * .009,
                      left: 0,
                      right: maxWidth * .01,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //pop up header
                        Padding(
                          padding: EdgeInsets.only(
                              left: maxWidth * .001, right: maxWidth * .001),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: maxWidth * .001,
                                      right: maxWidth * .001),
                                  child: Text(
                                    "إضافة عادة جديد",
                                    style:
                                        TextStyle(fontSize: maxWidth * 0.018),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: maxWidth * 0.06,
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
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 1.0,
                            right: 40,
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 18.0, right: 20),
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(20),
                        //     child: Column(
                        //         children: medicineTypes
                        //             .map((e) => CustomNavigationButton(
                        //                   text: e,
                        //                   fun: () {},
                        //                 ))
                        //             .toList()),
                        //   ),
                        // ),

                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, left: 30),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColors.lightGreen.withOpacity(1))),
                                child: const Text("حفظ"),
                              ),
                              SizedBox(
                                width: maxWidth * .01,
                              ),
                              TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.white)),
                                child: const Text(
                                  "إلغاء",
                                  style: TextStyle(color: Colors.black26),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })),
        );
      },
    );
  }
}
