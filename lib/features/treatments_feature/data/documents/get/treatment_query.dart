class TreatmentsQuery{
  static const getTreatments = '''
  query Treatments (\$item_per_page: Float, \$page: Float){
    treatments(
    item_per_page: \$item_per_page, 
    page: \$page
    ) {
        totalPages
        page
        items {
            color
            id
            name
            treatment_type {
                id
                name
            }
        }
    }
  }
  ''';

  static const getTreatment = '''
  query Treatment (\$id: Int!){
    treatment(id: \$id) {
        color
        id
        name
        price
        steps {
            name
            subSteps {
                name
                step_id
            }
        }
        treatment_type {
            id
            name
        }
    }
  }
  ''';
}