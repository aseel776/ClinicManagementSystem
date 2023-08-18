import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/customs.dart';
import './/core/app_colors.dart';
import '../../data/models/active_material_model.dart';
import '../states/active_materials/active_materials_state.dart';
import '../states/active_materials/active_materials_provider.dart';

Future<ActiveMaterialModel?> showInsertPopUp(BuildContext context) async{

  double screenWidth = MediaQuery.of(context).size.width;
  double containerWidth = screenWidth * .35;
  double screenHeight = MediaQuery.of(context).size.height;
  double containerHeight = screenHeight * .45;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  bool validTitle = true;
  String titleError = '';

  final newMaterial = ActiveMaterialModel();
  bool returnMaterial = false;

  await showDialog(
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
                    height: containerHeight * .15,
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
                    height: containerHeight * .1,
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
                              onChanged: (value) {
                                newMaterial.name = titleController.text;
                              },
                              decoration: decorateInsertMaterialField(
                                horizontalPadding: (containerWidth * .8) * .05,
                                verticalPadding: (containerHeight * .1) * .01,
                              ),
                              cursorColor: Colors.black.withOpacity(.6),
                              cursorWidth: 1.5,
                              cursorHeight: (containerHeight * .1) * .9,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    validTitle = false;
                                    titleError = 'هذا الحقل مطلوب!';
                                  });
                                } else {
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
                    height: containerHeight * .08,
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
                    height: containerHeight * .16,
                    color: AppColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    onPressed: () {
                      final containerProvider = ProviderContainer();
                      containerProvider
                          .read(activeMaterialsProvider.notifier)
                          .getAllMaterials(1, items: 1000)
                          .then(
                            (state) async {
                          newMaterial.antiMaterials ??= [];
                          newMaterial.antiMaterials = await antiMaterialsSelect(
                            context,
                            newMaterial.antiMaterials!,
                            containerProvider.read(activeMaterialsProvider),
                          );
                        },
                      );
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
                  SizedBox(height: containerHeight * .15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        minWidth: containerWidth * .25,
                        height: containerHeight * .15,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate() && validTitle) {
                            returnMaterial = true;
                            Navigator.of(context).pop();
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
                        height: containerHeight * .15,
                        width: containerWidth * .1,
                      ),
                      MaterialButton(
                        minWidth: containerWidth * .25,
                        height: containerHeight * .15,
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
  if(returnMaterial){
    newMaterial.antiMaterials??= [];
    return newMaterial;
  } else{
    return null;
  }
}

Future<List<ActiveMaterialModel>> antiMaterialsSelect(BuildContext context,
    List<ActiveMaterialModel> antiMaterials, ActiveMaterialsState state) async {
  List<ActiveMaterialModel> originalOne = antiMaterials.map((e) => e).toList();
  late List<ActiveMaterialModel> materials;
  if (state is LoadedActiveMaterialsState) {
    materials = state.page.materials!.toList();
  } else {
    materials = [];
  }

  double screenWidth = MediaQuery.of(context).size.width;
  double containerWidth = screenWidth * .25;
  double screenHeight = MediaQuery.of(context).size.height;
  double containerHeight = screenHeight * .5;

  await showDialog(
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
                    child: materials.isNotEmpty
                        ? ListView.builder(
                            itemCount: materials.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                value: antiMaterials.contains(materials[index]),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      if (value!) {
                                        antiMaterials.add(materials[index]);
                                      } else {
                                        antiMaterials.remove(materials[index]);
                                      }
                                    },
                                  );
                                },
                                title: Text(
                                  materials[index].name!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Cairo',
                                    color: AppColors.black,
                                  ),
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: AppColors.black,
                                checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              );
                            },
                          )
                        : const SizedBox(),
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
                            antiMaterials = originalOne.toList();
                            Navigator.of(context).pop(originalOne);
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
  return antiMaterials;
}
