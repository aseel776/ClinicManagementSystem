class MedicineDocsGql {
  static const String medicinesQuery = '''
  query Medicines(\$itemPerPage: Float!, \$page: Float!) {
    medicines(item_per_page: \$itemPerPage, page: \$page) {
      item_per_page
      page
      totalPages
      items {
        category_id
        concentration
        id
        name
        category {
          id
          name
        }
        medicineChemicalMaterials {
          chemical_material_id
          id
          medicine_id
          chemical_material {
            id
            name
          }
        }
      }
    }
  }
''';
  static const String medicinesSearchQuery = """
  query Medicines(\$itemPerPage: Float!, \$page: Float!, \$search: String!) {
    medicines(item_per_page: \$itemPerPage, page: \$page, search: \$search) {
        item_per_page
        page
        totalPages
        items {
            category_id
            concentration
            id
            name
            category {
                id
                name
            }
              medicineChemicalMaterials {
                chemical_material_id
                id
                medicine_id
                chemical_material {
                    id
                    name
                }
            }
        }
    }
  }
""";
  // variables: {
  //         'itemPerPage': 1,
  //         'page': 1,
  //         'search': 'aaa',
  //       },

  static const String categories = '''
    query Categories {
      categories {
        id
        name
      }
    }
  ''';
}
