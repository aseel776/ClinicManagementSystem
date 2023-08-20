class Diseases {
  static const String diseasesQuery = r'''
  query Diseases($itemPerPage: Float!, $page: Float!) {
    diseases(item_per_page: $itemPerPage, page: $page) {
      item_per_page
      page
      totalPages
      items {
        id
        name
        diseaseChemicalMaterials {
          chemical_material_id
          disease_id
          id
          chemical_material {
            id
            name
          }
        }
      }
    }
  }
''';

  static const String diseasesSearchQuery = '''
  query Diseases(\$search: String!, \$itemPerPage: Float!, \$page: Float!) {
    diseases(search: \$search, item_per_page: \$itemPerPage, page: \$page) {
      item_per_page
      page
      totalPages
      items {
        id
        name
        diseaseChemicalMaterials {
          chemical_material_id
          disease_id
          id
          chemical_material {
            id
            name
          }
        }
      }
    }
  }
''';
}
