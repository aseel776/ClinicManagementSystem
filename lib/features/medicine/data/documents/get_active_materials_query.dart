class ActiveMaterialDocsGql {
  static const getActiveMaterials = '''
            query ChemicalMaterials {
                chemicalMaterials {
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