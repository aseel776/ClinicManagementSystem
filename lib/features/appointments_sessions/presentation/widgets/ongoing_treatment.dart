import 'package:flutter/material.dart';
import './/core/app_colors.dart';
import '../../data/models/patient_treatment_model.dart';
import 'package:clinic_management_system/features/treatments_feature/data/models/step_model.dart';

class OnGoingTreatment extends StatelessWidget {
  final PatientTreatmentModel ongoingTreatment;
  const OnGoingTreatment(this.ongoingTreatment, {Key? key,}) : super(key: key);

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
        width: width * .3,
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
        width: width * .5,
        child: createText(place),
      );
    }

    createCheckBox(int stepId){
      bool checkValue = false;
      for (var element in ongoingTreatment.stepsDone!) {
        if(element.stepId == stepId){
          checkValue = true;
          break;
        }
      }
      return Checkbox(
        value: checkValue,
        onChanged: checkValue ? null : (value) => print(value)
      );
    }

    createRow(StepModel step){
      return DataRow(
        cells: [
          DataCell(createStepLabel(step.name!)),
          DataCell(createCheckBox(step.id!)),
          DataCell(createNotesLabel('')),
        ],
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.black
        ),
      ),
      padding: EdgeInsets.only(
        right: width * .05,
        top: height * .05
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'العلاج: ${ongoingTreatment.treatment!.name!}',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
              ),
            ),
            SizedBox(height: height * .025),
            Text(
              'مكان العلاج: ${ongoingTreatment.place}',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
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
                ...ongoingTreatment.treatment!.steps!.map((e) => createRow(e)),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
