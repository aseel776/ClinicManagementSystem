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
            id
            name
            subSteps {
                name
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