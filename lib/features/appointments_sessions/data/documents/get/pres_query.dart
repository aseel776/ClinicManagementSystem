class PresQuery{
  static const getConflicts = '''
  query CheckConflictsForPerscriptionMedicines (\$medicine_ids: [Int!]!, \$profile_id: Int!){
    checkConflictsForPerscriptionMedicines(medicine_ids: \$medicine_ids, profile_id: \$profile_id) {
        bool
        bad_habit_medicine {
            conflict_in_chemicals
            medicant_name
        }
        disease_medicine {
            conflict_in_chemicals
            medicant_name
        }
        prescription_medicines {
            message
            pair_of_medicine
        }
        prescription_patient_medicine {
            message
            pair_of_medicine
        }
    }
}

  ''';
}