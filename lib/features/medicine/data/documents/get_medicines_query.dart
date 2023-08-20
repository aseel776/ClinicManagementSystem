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
  static const String categories = '''
    query Categories {
      categories {
        id
        name
      }
    }
  ''';
}
