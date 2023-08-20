import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/app_colors.dart';
import 'package:clinic_management_system/core/primaryText.dart';
import 'bad_habits_table.dart';

SnackBar DeleteSnackBar(Function onDelete) {
  return SnackBar(
    content: Container(
      child: Consumer(
          builder: (context, ref, child) => Row(
                // mainAxisSize: ,

                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20),
                            right: Radius.circular(20))),

                    // padding: EdgeInsets.symmetric(horizontal: 100),
                    margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.3,
                    ),
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          PrimaryText(
                            text: "هل أنت متأكد من حذف هذا العنصر ؟",
                            size: 15,
                          ),
                          Spacer(),
                          MouseRegion(
                            onEnter: (event) {
                              ref.read(hovered.notifier).state = true;
                            },
                            onExit: (event) {
                              ref.read(hovered.notifier).state = false;
                            },
                            child: SizedBox(
                              height: 38,
                              width: 80,
                              child: ElevatedButton(
                                  onPressed: () {
                                    onDelete();
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    backgroundColor: MaterialStatePropertyAll(
                                      ref.watch(hovered) as bool
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                  ),
                                  child: PrimaryText(
                                    text: "حذف",
                                    color: ref.watch(hovered) as bool
                                        ? Colors.white
                                        : AppColors.lightGreen,
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            height: 38,
                            width: 80,
                            child: ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                },
                                style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                ),
                                child: PrimaryText(
                                  text: "إلغاء",
                                  color: AppColors.lightGreen,
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
    ),
    backgroundColor: Colors.transparent,

    duration: Duration(seconds: 4),
    // shape:
    // showCloseIcon: true,
    elevation: 0,
  );
}
