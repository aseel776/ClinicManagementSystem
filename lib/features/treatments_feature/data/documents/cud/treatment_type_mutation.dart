class TreatmentTypeMutation{
  static const createTreatmentType = '''
    mutation CreateTreatmentType (\$createTreatmentTypeInput: CreateTreatmentTypeInput!){
    createTreatmentType(createTreatmentTypeInput: \$createTreatmentTypeInput) {
        id
        name
    }
  }
  ''';

  static const updateTreatmentType = '''
  mutation UpdateTreatmentType (\$id: Int!, \$updateTreatmentTypeInput: UpdateTreatmentTypeInput!){
    updateTreatmentType(
    id: \$id, 
    updateTreatmentTypeInput: \$updateTreatmentTypeInput) {
        id
        name
    }
  }
  ''';

  static const deleteTreatmentType = '''
  mutation RemoveTreatmentType (\$id: Int!){
    removeTreatmentType(id: \$id) {
        id
        name
    }
  }
  ''';
}