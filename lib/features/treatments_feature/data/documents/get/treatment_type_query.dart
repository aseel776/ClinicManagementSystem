class TreatmentTypesQuery{
  static const getTreatmentTypes = '''
  query TreatmentTypes {
    treatmentTypes {
        id
        name
    }
  }
  ''';

  static const getTreatmentType = '''
  query TreatmentType (\$id: Int!){
    treatmentType(id: \$id) {
        id
        name
    }
  }
  ''';
}