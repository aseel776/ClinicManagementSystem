class BadHabitsDocsGql {
  static const String badHabitsQuery = '''
  query BadHabits(\$itemPerPage: Float!, \$page: Float!) {
    badHabits(item_per_page: \$itemPerPage, page: \$page) {
      item_per_page
      page
      totalPages
      items {
        id
        name
        badHabitChemicalMaterials {
          bad_habit_id
          chemical_material_id
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
  static const String badHabitsSearchQuery = '''
  query BadHabits(\$itemPerPage: Float!, \$page: Float!, \$search: String) {
    badHabits(item_per_page: \$itemPerPage, page: \$page, search: \$search) {
      item_per_page
      page
      totalPages
      items {
        id
        name
        badHabitChemicalMaterials {
          bad_habit_id
          chemical_material_id
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
