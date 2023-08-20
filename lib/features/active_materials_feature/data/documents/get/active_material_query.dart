class ActiveMaterialsQuery{

  static const getActiveMaterials = '''
  query ChemicalMaterials (\$item_per_page: Float, \$page: Float){
    chemicalMaterials (
    item_per_page: \$item_per_page,
    page: \$page,
    ) {
        item_per_page   
        page
        totalPages
        items {
            id
            name
        }
    }
  }
  ''';

  static const getActiveMaterial = '''
  query ChemicalMaterial (\$id: Int!){
    chemicalMaterial(id: \$id) {
        id
        name
        conflicts {
            id
            name
        }
    }
  }
  ''';

  static const searchForActiveMaterials = '''
  query ChemicalMaterials (\$item_per_page: Float, \$page: Float, \$search: String){
    chemicalMaterials (
    item_per_page: \$item_per_page,
    page: \$page,
    search: \$search
    ) {
        item_per_page   
        page
        totalPages
        items {
            id
            name
        }
    }
  }
  ''';

}