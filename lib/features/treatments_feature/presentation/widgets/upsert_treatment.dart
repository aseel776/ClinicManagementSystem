import 'package:clinic_management_system/features/treatments_feature/data/models/step_model.dart';
import 'package:flutter/material.dart';
import './/core/customs.dart';
import './/core/app_colors.dart';
import '../../dummy_data.dart';
import '../../data/models/treatment_model.dart';
import '../../data/models/treatment_type_model.dart';

void showUpsertPopUp(BuildContext context, {TreatmentModel? treatment}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double containerWidth = screenWidth * .75;
  double screenHeight = MediaQuery.of(context).size.height;
  double containerHeight = screenHeight * .8;

  final formKey = GlobalKey<FormState>();
  TreatmentTypeModel? selectedType = types[0];
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final colorController = TextEditingController();

  if (treatment != null) {
    titleController.text = treatment.name!;
    priceController.text = treatment.price.toString();
    colorController.text =
        '#${treatment.color!.value.toRadixString(16).substring(2)}';
    selectedType = treatment.type;
  }

  bool validTitle = true;
  String titleError = '';

  bool validPrice = true;
  String priceError = '';

  bool validColor = true;
  String colorError = '';

  bool addingStep = false;

  showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: StatefulBuilder(
        builder: (context, setState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: containerWidth,
            height: containerHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.lightGreen,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  treatment != null ? 'تعديل' : 'معالجة جديدة',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 26,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: containerHeight * .05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          //title
                          SizedBox(
                            height: containerHeight * .125,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: containerWidth * .3,
                                  height: containerHeight * .075,
                                  child: TextFormField(
                                    controller: titleController,
                                    decoration: decorateUpsertField(
                                      width: containerWidth * .3,
                                      height: containerHeight * .125,
                                      label: 'اسم المعالجة',
                                    ),
                                    cursorColor: Colors.black.withOpacity(.6),
                                    cursorWidth: 1.5,
                                    cursorHeight: (containerHeight * .075) * .6,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        setState(() {
                                          validTitle = false;
                                          titleError = 'هذا الحقل مطلوب!';
                                        });
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: containerHeight * .05,
                                  width: containerWidth * .3,
                                  child: Visibility(
                                    visible: !validTitle,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: containerWidth * .01),
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
                                ),
                              ],
                            ),
                          ),
                          //separator
                          SizedBox(height: containerHeight * .025),
                          //type
                          SizedBox(
                            height: containerHeight * .125,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: containerWidth * .3,
                                  height: containerHeight * .075,
                                  child: Stack(
                                    children: [
                                      TextFormField(
                                        decoration: decorateUpsertField(
                                          width: containerWidth * .3,
                                          height: containerHeight * .125,
                                          label: 'نوع المعالجة',
                                        ),
                                      ),
                                      DropdownButton<TreatmentTypeModel>(
                                        isExpanded: true,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: containerWidth * .01,
                                        ),
                                        onChanged: (newType) {
                                          setState(() {
                                            selectedType = newType!;
                                          });
                                        },
                                        value: selectedType,
                                        items: types.map(
                                          (type) {
                                            return DropdownMenuItem<
                                                TreatmentTypeModel>(
                                              alignment: Alignment.centerRight,
                                              value: type,
                                              child: Text(
                                                type.name!,
                                                style: const TextStyle(
                                                  fontFamily: 'Cairo',
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: containerHeight * .05),
                              ],
                            ),
                          ),
                          //separator
                          SizedBox(height: containerHeight * .025),
                          //price
                          SizedBox(
                            width: containerWidth * .3,
                            height: containerHeight * .125,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: containerWidth * .3,
                                  height: containerHeight * .075,
                                  child: TextFormField(
                                    controller: priceController,
                                    decoration: decorateUpsertField(
                                      width: containerWidth * .3,
                                      height: containerHeight * .125,
                                      label: 'سعر المعالجة',
                                    ),
                                    cursorColor: Colors.black.withOpacity(.6),
                                    textDirection: TextDirection.ltr,
                                    cursorWidth: 1.5,
                                    cursorHeight: (containerHeight * .075) * .6,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        setState(() {
                                          validPrice = false;
                                          priceError = 'هذا الحقل مطلوب!';
                                        });
                                        return null;
                                      }
                                      var price = num.tryParse(value);
                                      if (price == null) {
                                        setState(() {
                                          validPrice = false;
                                          priceError =
                                              'سعر المعالجة يجب أن يكون رقم!';
                                        });
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: containerHeight * .05,
                                  width: containerWidth * .3,
                                  child: Visibility(
                                    visible: !validPrice,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: containerWidth * .01),
                                      child: Text(
                                        priceError,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          color: Colors.red[600]!,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //separator
                          SizedBox(height: containerHeight * .025),
                          //color
                          SizedBox(
                            height: containerHeight * .125,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: containerWidth * .3,
                                  height: containerHeight * .075,
                                  child: Stack(
                                    children: [
                                      TextFormField(
                                        controller: colorController,
                                        decoration: decorateUpsertField(
                                          width: containerWidth * .3,
                                          height: containerHeight * .125,
                                          label: 'لون المعالجة',
                                        ),
                                        cursorColor:
                                            Colors.black.withOpacity(.6),
                                        cursorWidth: 1.5,
                                        cursorHeight:
                                            (containerHeight * .075) * .6,
                                        textDirection: TextDirection.ltr,
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            setState(() {
                                              validColor = false;
                                              colorError = 'هذا الحقل مطلوب!';
                                            });
                                            return null;
                                          }
                                          if (!RegExp(
                                                  r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$')
                                              .hasMatch(value)) {
                                            setState(() {
                                              validColor = false;
                                              colorError = 'اللون غير صالح!';
                                            });
                                          }
                                          return null;
                                        },
                                      ),
                                      Positioned(
                                        right: containerWidth * .005,
                                        top: containerHeight * .075 * .25,
                                        child: InkWell(
                                          onTap: () {
                                            //opens a color picker
                                          },
                                          child: Container(
                                            width: containerWidth * .05,
                                            height: containerHeight * .075 * .5,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: treatment != null
                                                  ? treatment.color
                                                  : Colors.red,
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                            ),
                                            child: const Text(''),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: containerHeight * .05,
                                  width: containerWidth * .3,
                                  child: Visibility(
                                    visible: !validColor,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: containerWidth * .01),
                                      child: Text(
                                        colorError,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          color: Colors.red[600]!,
                                          fontSize: 14,
                                        ),
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
                    SizedBox(width: containerWidth * .2),
                    Column(
                      children: [
                        SizedBox(
                          width: containerWidth * .3,
                          child: const Text(
                            'الخطوات',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: containerHeight * .025),
                        if (treatment != null || addingStep)
                          Column(
                            children: [
                              if (treatment != null)
                                Container(
                                  height: containerHeight * .25,
                                  width: containerWidth * .3,
                                  decoration: BoxDecoration(
                                    color: Colors.white38,
                                    borderRadius: addingStep
                                        ? const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ) : BorderRadius.circular(5)
                                  ),
                                  child: ReorderableListView(
                                    onReorder: (oldIndex, newIndex) {
                                      setState(() {
                                        if (newIndex > oldIndex) {
                                          newIndex -= 1;
                                        }
                                        final item =
                                            treatment.steps!.removeAt(oldIndex);
                                        treatment.steps!.insert(newIndex, item);
                                      });
                                    },
                                    proxyDecorator: (child, index, animation) {
                                      return Card(
                                        color: Colors.white70,
                                        elevation: 0,
                                        child: child,
                                      );
                                    },
                                    children: [
                                      ...treatment.steps!
                                          .map(
                                            (step) => ListTile(
                                              key: ValueKey(step.name),
                                              title: Text(
                                                step.name!,
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: const TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontSize: 16,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ],
                                  ),
                                ),
                              if(addingStep)
                                Container(
                                    height: containerHeight * .075,
                                    width: containerWidth * .3,
                                    padding: EdgeInsets.only(
                                      left: (containerWidth * .3) * .05,
                                      right: (containerWidth * .3) * .05,
                                      bottom: (containerHeight * 0.075) * 0.2,
                                      // top: (containerHeight * 0.05) * 0.1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white38,
                                      borderRadius: addingStep
                                          ? const BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5),
                                      ) : BorderRadius.circular(5),
                                    ),
                                  child: TextField(
                                    onTapOutside: (event) {
                                      setState((){
                                        addingStep = false;
                                      });
                                    },
                                    onSubmitted: (value) {
                                      setState((){
                                        addingStep = false;
                                        if(treatment != null){
                                          StepModel newStep = StepModel(id: treatment.steps!.length, name: value);
                                          treatment.steps!.add(newStep);
                                        }
                                      });
                                    },
                                  )
                                ),
                              SizedBox(height: containerHeight * .025),
                            ],
                          ),
                        //add step button
                        MaterialButton(
                          minWidth: containerWidth * .3,
                          height: containerHeight * .05,
                          elevation: 0,
                          color: Colors.white38,
                          hoverElevation: 0,
                          hoverColor: Colors.white,
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            setState(() {
                              addingStep = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add,
                                color: AppColors.black,
                              ),
                              SizedBox(width: containerWidth * .001),
                              const Text(
                                'إضافة',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: containerHeight * .075),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      height: containerHeight * .1,
                      minWidth: containerWidth * .15,
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          print('valid');
                        } else {
                          print('invalid');
                        }
                      },
                      child: const Text(
                        'حفظ',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: containerWidth * .01),
                    MaterialButton(
                      height: containerHeight * .1,
                      minWidth: containerWidth * .15,
                      color: Colors.white,
                      elevation: 0,
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
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
