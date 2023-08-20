import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/customs.dart';
import './/core/app_colors.dart';
import '../states/problem/problem_provider.dart';
import '../states/problems/problems_provider.dart';
import '../../data/models/problem_model.dart';
import '../../data/models/problem_type_model.dart';

Future<void> showUpsertProblemPopUp
    (BuildContext context, List<ProblemTypeModel> types, {ProblemModel? problem}) async {

  final screenWidth = MediaQuery.of(context).size.width;
  final containerWidth = screenWidth * .4;
  final screenHeight = MediaQuery.of(context).size.height;
  final containerHeight = screenHeight * .4;

  final formKey = GlobalKey<FormState>();
  bool createFlag = (problem == null);

  final titleController = TextEditingController();
  String titleError = '';
  bool validTitle = true;
  ProblemTypeModel selectedProblemType;
  final focusNode = FocusNode();

  if (problem != null) {
    titleController.text = problem.name!;
    selectedProblemType = problem.type!;
  } else {
    problem = ProblemModel();
    selectedProblemType = types[0];
  }

  await showDialog(
    context: context,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: AppColors.lightGreen,
                alignment: Alignment.center,
                child: Container(
                  width: containerWidth,
                  height: containerHeight,
                  padding: EdgeInsets.symmetric(
                    horizontal: containerWidth * .05,
                    vertical: containerHeight * .05,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: containerHeight * .2,
                        child: Text(
                          !createFlag ? 'تعديل' : 'مشكلة جديدة',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 20,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: containerHeight * .15,
                        width: containerWidth * .8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: containerWidth * .2,
                              child: const Text(
                                'اسم المشكلة',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: AppColors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(width: containerWidth * .05),
                            SizedBox(
                              width: containerWidth * .55,
                              child: Form(
                                key: formKey,
                                child: TextFormField(
                                  controller: titleController,
                                  decoration: decorateUpsertField(
                                    width: containerWidth * .6,
                                    height: containerHeight * .15,
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 16,
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
                                  cursorColor: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: containerHeight * .025),
                      SizedBox(
                        height: containerHeight * .075,
                        width: containerWidth * .8,
                        child: Row(
                          children: [
                            SizedBox(width: containerWidth * .25),
                            Visibility(
                              visible: !validTitle,
                              child: Text(
                                titleError,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: containerHeight * .025),
                      SizedBox(
                        height: containerHeight * .15,
                        width: containerWidth * .8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: containerWidth * .2,
                              child: const Text(
                                'نوع المشكلة',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: AppColors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(width: containerWidth * .05),
                            Expanded(
                              child: Stack(
                                children: [
                                  TextFormField(
                                    decoration: decorateUpsertField(
                                      width: containerWidth * .2,
                                      height: containerHeight * .15,
                                    ),
                                  ),
                                  //PROBLEM: after selecting a type, it changes color to grey
                                  DropdownButton<ProblemTypeModel>(
                                    isExpanded: true,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: containerWidth * .01,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    underline: const SizedBox(),
                                    onChanged: (newType) {
                                      setState(() {
                                        selectedProblemType = newType!;
                                        focusNode.unfocus();
                                      });
                                    },
                                    focusNode: focusNode,
                                    value: selectedProblemType,
                                    items: types.map(
                                      (type) {
                                        return DropdownMenuItem<ProblemTypeModel>(
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
                          ],
                        ),
                      ),
                      SizedBox(height: containerHeight * .1),
                      Consumer(
                        builder: (context, ref, child) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MaterialButton(
                                  height: containerHeight * .175,
                                  minWidth: containerWidth * .2,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onPressed: () async{
                                    if (formKey.currentState!.validate()) {
                                      problem!.name = titleController.text;
                                      problem.type = selectedProblemType;
                                      Navigator.of(context).pop();
                                      if(createFlag){
                                        await ref.read(problemsProvider.notifier).createProblem(problem);
                                      }else {
                                        await ref.read(problemProvider.notifier).updateProblem(problem);
                                        await ref.read(problemsProvider.notifier).getAllProblems();
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'حفظ',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(width: containerWidth * .05),
                                MaterialButton(
                                  height: containerHeight * .175,
                                  minWidth: containerWidth * .2,
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
          },
        ),
      );
    },
  );
}
