import 'package:clinic_management_system/core/app_colors.dart';
import 'package:flutter/material.dart';

import '../../data/models/diseases_patient.dart';

class DiseasesPatientCard extends StatelessWidget {
  final PatientDiseases diseasesPatient;

  DiseasesPatientCard({required this.diseasesPatient});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1, color: Colors.grey.shade600),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Chip(
              backgroundColor: Colors.grey.withOpacity(0.3),
              label: Text(
                diseasesPatient.disease?.name ?? '',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 8),
            Chip(
              backgroundColor: Colors.blue.withOpacity(0.3),
              label: Text(
                diseasesPatient.date ?? '',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
