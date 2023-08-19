class TreatmentMutation{
  static const createTreatment = '''
  mutation CreateTreatment (\$createTreatmentInput: CreateTreatmentInput!){
    createTreatment(
      createTreatmentInput: \$createTreatmentInput
    ){
        color
        id
        name
        treatment_type {
            id
            name
        }
    }
  }
  ''';

  static const updateTreatment = '''
  mutation UpdateTreatment (\$id: Int!, \$updateTreatmentInput: UpdateTreatmentInput!){
    updateTreatment(
      id: \$id, 
      updateTreatmentInput: \$updateTreatmentInput
    ) {
        color
        id
        name
        treatment_type {
            id
            name
        }
    }
  }
  ''';

  static const deleteTreatment = '''
  mutation RemoveTreatment (\$id: Int!){
    removeTreatment(id: \$id) {
        name       
    }
  }
  ''';
}