import 'package:clinic_management_system/core/app_colors.dart';
import 'package:flutter/material.dart';

class LabOrderStepsPanel extends StatelessWidget {
  final List<String> steps;

  LabOrderStepsPanel({required this.steps});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Steps:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            itemCount: steps.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.lightGreen,
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(color: AppColors.black),
                  ),
                ),
                title: Text(steps[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}
