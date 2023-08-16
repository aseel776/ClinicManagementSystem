import 'package:flutter/material.dart';
import '../dummy_data.dart';
import './/core/customs.dart';
import './/core/app_colors.dart';
import '../../data/models/active_material_model.dart';

void showInsertPopUp(BuildContext context) {

  double screenWidth = MediaQuery.of(context).size.width;
  double containerWidth = screenWidth * .35;
  double screenHeight = MediaQuery.of(context).size.height;
  double containerHeight = screenHeight * .6;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  bool validTitle = true;
  String titleError = '';

  final newMaterial = ActiveMaterialModel();

  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: containerWidth,
              height: containerHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.lightGreen,
              ),
              padding: EdgeInsets.symmetric(vertical: containerHeight * .05),
              child: Column(
                children: [
                  SizedBox(
                    height: containerHeight * .08,
                    child: const Text(
                      'مادة جديدة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 22,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: containerHeight * .05),
                  SizedBox(
                    width: containerWidth * .8,
                    height: containerHeight * .075,
                    child: Row(
                      children: [
                        Container(
                          width: containerWidth * .2,
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'اسم المادة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Form(
                            key: formKey,
                            child: TextFormField(
                              controller: titleController,
                              decoration: decorateInsertMaterialField(
                                horizontalPadding: (containerWidth * .8) * .05,
                                verticalPadding: (containerHeight * .075) * .01,
                              ),
                              cursorColor: Colors.black.withOpacity(.6),
                              cursorWidth: 1.5,
                              cursorHeight: (containerHeight * .075) * .9,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    validTitle = false;
                                    titleError = 'هذا الحقل مطلوب!';
                                  });
                                } else{
                                  setState(() {
                                    validTitle = true;
                                    titleError = '';
                                  });
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: containerHeight * .01),
                  SizedBox(
                    width: containerWidth * .8,
                    height: containerHeight * .05,
                    child: Row(
                      children: [
                        SizedBox(width: containerWidth * .2),
                        Expanded(
                          child: Visibility(
                            visible: !validTitle,
                            child: Text(
                              titleError,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: Colors.red[600]!,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: containerHeight * .035),
                  MaterialButton(
                    minWidth: containerWidth * .4,
                    height: containerHeight * .125,
                    color: AppColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    onPressed: () {
                      antiMaterialsSelect(context, newMaterial);
                    },
                    child: const Text(
                      'التعارضات الدوائية',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: containerHeight * .04),
                  MaterialButton(
                    minWidth: containerWidth * .4,
                    height: containerHeight * .125,
                    color: AppColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    onPressed: () {
                      // antiDiseasesSelect(context, newMaterial);
                    },
                    child: const Text(
                      'التعارضات المرضية',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: containerHeight * .04),
                  MaterialButton(
                    minWidth: containerWidth * .4,
                    height: containerHeight * .125,
                    color: AppColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    onPressed: () {
                      // antiHabitsSelect(context, newMaterial);
                    },
                    child: const Text(
                      'تعارضات أخرى',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: containerHeight * .075),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        minWidth: containerWidth * .25,
                        height: containerHeight * .1,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate() && validTitle) {
                            print('sssssssssss');
                          }
                        },
                        child: const Text(
                          'حفظ',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: containerHeight * .1,
                        width: containerWidth * .1,
                      ),
                      MaterialButton(
                        minWidth: containerWidth * .25,
                        height: containerHeight * .1,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}

void antiMaterialsSelect(BuildContext context, ActiveMaterialModel material) {

  material.antiMaterials ??= [];
  List<String?> originalOne = material.antiMaterials!.map((e) => e.name).toList();

  double screenWidth = MediaQuery.of(context).size.width;
  double containerWidth = screenWidth * .25;
  double screenHeight = MediaQuery.of(context).size.height;
  double containerHeight = screenHeight * .5;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: containerWidth,
              height: containerHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              padding: EdgeInsets.only(
                top: containerHeight * .035,
                bottom: containerHeight * .025,
                left: containerWidth * .05,
                right: containerWidth * .05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: containerHeight * .1,
                    child: const Text(
                      'التعارضات الدوائية',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 20,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: containerHeight * .025,
                    child: Divider(
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(height: containerHeight * .02),
                  SizedBox(
                    height: containerHeight * .655,
                    child: ListView.builder(
                      itemCount: materials.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          // value: material.antiMaterials!.contains(materials[index].name),
                          value: true,
                          onChanged: (value) {
                            // setState(
                            //   () {
                            //     if (value!) {
                            //       material.antiMaterials!.add(
                            //           materials[index].name!);
                            //     } else {
                            //       material.antiMaterials!.remove(
                            //           materials[index].name!);
                            //     }
                            //   },
                            // );
                          },
                          title: Text(
                            materials[index].name!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Cairo',
                              color: AppColors.black,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: AppColors.black,
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: containerHeight * .04),
                  SizedBox(
                    height: containerHeight * .1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          minWidth: containerWidth * .3,
                          color: Colors.white,
                          elevation: 0,
                          hoverElevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'تأكيد',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(width: containerWidth * .05),
                        MaterialButton(
                          minWidth: containerWidth * .3,
                          color: Colors.white,
                          elevation: 0,
                          hoverElevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          onPressed: () {
                            // material.antiMaterials = originalOne;
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'إلغاء',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}
//
// void antiDiseasesSelect(BuildContext context, ActiveMaterialModel material) {
//   material.antiDiseases ??= [];
//   List<String>? originalOne = material.antiDiseases!.toList();
//
//   double screenWidth = MediaQuery.of(context).size.width;
//   double containerWidth = screenWidth * .25;
//   double screenHeight = MediaQuery.of(context).size.height;
//   double containerHeight = screenHeight * .5;
//
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) =>
//         Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: Directionality(
//             textDirection: TextDirection.rtl,
//             child: StatefulBuilder(
//               builder: (context, setState) {
//                 return Container(
//                   width: containerWidth,
//                   height: containerHeight,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: Colors.white,
//                   ),
//                   padding: EdgeInsets.only(
//                     top: containerHeight * .035,
//                     bottom: containerHeight * .025,
//                     left: containerWidth * .05,
//                     right: containerWidth * .05,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: containerHeight * .1,
//                         child: const Text(
//                           'التعارضات المرضية',
//                           style: TextStyle(
//                             fontFamily: 'Cairo',
//                             fontSize: 20,
//                             color: AppColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: containerHeight * .025,
//                         child: Divider(
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       SizedBox(height: containerHeight * .02),
//                       SizedBox(
//                         height: containerHeight * .655,
//                         child: ListView.builder(
//                           itemCount: materials.length,
//                           itemBuilder: (context, index) {
//                             return CheckboxListTile(
//                               value: material.antiDiseases!.contains(materials[index].name),
//                               onChanged: (value) {
//                                 setState(
//                                       () {
//                                     if (value!) {
//                                       material.antiDiseases!.add(
//                                           materials[index].name!);
//                                     } else {
//                                       material.antiDiseases!.remove(
//                                           materials[index].name!);
//                                     }
//                                   },
//                                 );
//                               },
//                               title: Text(
//                                 materials[index].name!,
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontFamily: 'Cairo',
//                                   color: AppColors.black,
//                                 ),
//                               ),
//                               controlAffinity: ListTileControlAffinity.leading,
//                               activeColor: AppColors.black,
//                               checkboxShape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(height: containerHeight * .04),
//                       SizedBox(
//                         height: containerHeight * .1,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             MaterialButton(
//                               minWidth: containerWidth * .3,
//                               color: Colors.white,
//                               elevation: 0,
//                               hoverElevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3),
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: const Text(
//                                 'تأكيد',
//                                 style: TextStyle(
//                                   fontFamily: 'Cairo',
//                                   fontSize: 16,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: containerWidth * .05),
//                             MaterialButton(
//                               minWidth: containerWidth * .3,
//                               color: Colors.white,
//                               elevation: 0,
//                               hoverElevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3),
//                               ),
//                               onPressed: () {
//                                 material.antiDiseases = originalOne;
//                                 Navigator.of(context).pop();
//                               },
//                               child: const Text(
//                                 'إلغاء',
//                                 style: TextStyle(
//                                   fontFamily: 'Cairo',
//                                   fontSize: 16,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//   );
// }
//
// void antiHabitsSelect(BuildContext context, ActiveMaterialModel material) {
//   material.antiHabits ??= [];
//   List<String>? originalOne = material.antiHabits!.toList();
//
//   double screenWidth = MediaQuery.of(context).size.width;
//   double containerWidth = screenWidth * .25;
//   double screenHeight = MediaQuery.of(context).size.height;
//   double containerHeight = screenHeight * .5;
//
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) =>
//         Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: Directionality(
//             textDirection: TextDirection.rtl,
//             child: StatefulBuilder(
//               builder: (context, setState) {
//                 return Container(
//                   width: containerWidth,
//                   height: containerHeight,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: Colors.white,
//                   ),
//                   padding: EdgeInsets.only(
//                     top: containerHeight * .035,
//                     bottom: containerHeight * .025,
//                     left: containerWidth * .05,
//                     right: containerWidth * .05,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: containerHeight * .1,
//                         child: const Text(
//                           'تعارضات أخرى',
//                           style: TextStyle(
//                             fontFamily: 'Cairo',
//                             fontSize: 20,
//                             color: AppColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: containerHeight * .025,
//                         child: Divider(
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       SizedBox(height: containerHeight * .02),
//                       SizedBox(
//                         height: containerHeight * .655,
//                         child: ListView.builder(
//                           itemCount: materials.length,
//                           itemBuilder: (context, index) {
//                             return CheckboxListTile(
//                               value: material.antiHabits!.contains(materials[index].name),
//                               onChanged: (value) {
//                                 setState(
//                                       () {
//                                     if (value!) {
//                                       material.antiHabits!.add(
//                                           materials[index].name!);
//                                     } else {
//                                       material.antiHabits!.remove(
//                                           materials[index].name!);
//                                     }
//                                   },
//                                 );
//                               },
//                               title: Text(
//                                 materials[index].name!,
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontFamily: 'Cairo',
//                                   color: AppColors.black,
//                                 ),
//                               ),
//                               controlAffinity: ListTileControlAffinity.leading,
//                               activeColor: AppColors.black,
//                               checkboxShape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(height: containerHeight * .04),
//                       SizedBox(
//                         height: containerHeight * .1,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             MaterialButton(
//                               minWidth: containerWidth * .3,
//                               color: Colors.white,
//                               elevation: 0,
//                               hoverElevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3),
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: const Text(
//                                 'تأكيد',
//                                 style: TextStyle(
//                                   fontFamily: 'Cairo',
//                                   fontSize: 16,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: containerWidth * .05),
//                             MaterialButton(
//                               minWidth: containerWidth * .3,
//                               color: Colors.white,
//                               elevation: 0,
//                               hoverElevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3),
//                               ),
//                               onPressed: () {
//                                 material.antiHabits = originalOne;
//                                 Navigator.of(context).pop();
//                               },
//                               child: const Text(
//                                 'إلغاء',
//                                 style: TextStyle(
//                                   fontFamily: 'Cairo',
//                                   fontSize: 16,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//   );
// }