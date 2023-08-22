import 'package:clinic_management_system/core/customs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/app_colors.dart';
import '../../data/models/patient_treatment_model.dart';
import 'package:clinic_management_system/features/treatments_feature/data/models/step_model.dart';
import '../../data/models/sessionInputModel.dart';
import 'package:dartz/dartz.dart';

class OnGoingTreatment extends ConsumerStatefulWidget {

  const OnGoingTreatment(this.ongoingTreatment, this.workDone, {Key? key,}) : super(key: key);

  final PatientTreatmentModel ongoingTreatment;
  final List<SessionInputModel> workDone;

  @override
  ConsumerState<OnGoingTreatment> createState() => _OnGoingTreatmentState();
}

class _OnGoingTreatmentState extends ConsumerState<OnGoingTreatment> {
  late List<Tuple2<int, bool>> stepsCheck = createStepsCheck();
  List<SessionInputModel> inputSteps = [];


  createStepsCheck(){
    List<Tuple2<int, bool>> temp = [];
    for(var step in widget.ongoingTreatment.treatment!.steps!){
      bool found = false;
      for(var stepDone in widget.ongoingTreatment.stepsDone!){
        if(step.id == stepDone.stepId){
          temp.add(Tuple2(step.id!, true));
          found = true;
          break;
        }
      }
      if(!found){
        inputSteps.add(SessionInputModel(stepId: step.id, treatmentId: widget.ongoingTreatment.id));
        temp.add(Tuple2(step.id!, false));
      }
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width * .83 * .8 * .75;
    final height = MediaQuery.of(context).size.height * .93 * .35;

    createText(String title) {
      return Text(
        title,
        overflow: TextOverflow.fade,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18,
          color: AppColors.black,
        ),
      );
    }

    createStepLabel(String label) {
      return SizedBox(
        width: width * .35,
        child: createText(label),
      );
    }

    createCheckLabel(String label) {
      return SizedBox(
        width: width * .15,
        child: createText(label),
      );
    }

    createNotesLabel(String place) {
      return SizedBox(
        width: width * .4,
        child: createText(place),
      );
    }

    createNotesBox(int stepId){
      bool enabled = stepsCheck.singleWhere((element) => element.value1 == stepId).value2;
      return SizedBox(
        width: width * .4,
        child: TextFormField(
          controller: inputSteps.singleWhere((element) => element.stepId == stepId).notes,
          enabled: enabled,
          decoration: createNotesDecoration(enabled),
          cursorColor: Colors.black,
          style: const TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      );
    }

    handleLogic(int stepId, bool value) {
      final inputModel = inputSteps.singleWhere((element) => element.stepId == stepId);
      if (value) {
        setState(() {
          widget.workDone.add(inputModel);
          stepsCheck.remove(Tuple2(stepId, false));
          stepsCheck.add(Tuple2(stepId, true));
        });
      } else {
        setState(() {
          widget.workDone.removeWhere((element) => element.stepId == stepId);
          inputSteps
              .singleWhere((element) => element.stepId == stepId)
              .notes
              .clear();
          stepsCheck.remove(Tuple2(stepId, true));
          stepsCheck.add(Tuple2(stepId, false));
        });
      }
    }

    createCheckBox(int stepId){
      bool alreadyExists = false;
      for (var element in widget.ongoingTreatment.stepsDone!) {
        if(element.stepId == stepId){
          alreadyExists = true;
          break;
        }
      }
      return Checkbox(
        activeColor: AppColors.black,
        value: stepsCheck.singleWhere((element) => element.value1 == stepId).value2,
        onChanged: alreadyExists ? null : (value) {
          handleLogic(stepId, value!);
        }
      );
    }

    createRow(StepModel step){
      return DataRow(
        cells: [
          DataCell(createStepLabel(step.name!)),
          DataCell(createCheckBox(step.id!)),
          DataCell(createNotesBox(step.id!)),
        ],
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.lightGreen,
      ),
      padding: EdgeInsets.only(
        right: width * .05,
        top: height * .05
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
            width: width * .9,
              child: Text(
                'العلاج: ${widget.ongoingTreatment.treatment!.name!}',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: height * .025),
            SizedBox(
              width: width * .9,
              child: Text(
                'مكان العلاج: ${widget.ongoingTreatment.place}',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: height * .025),
            DataTable(
              columnSpacing: 0,
              horizontalMargin: width * .005,
              columns: [
                DataColumn(label: createStepLabel('الخطوات')),
                DataColumn(label: createCheckLabel('الإنجاز')),
                DataColumn(label: createNotesLabel('ملاحظات')),
              ],
              rows: [
                ...widget.ongoingTreatment.treatment!.steps!.map((e) => createRow(e)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
