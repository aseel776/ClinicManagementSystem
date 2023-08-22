class LabDocsGql {
  static const createLab = '''
    mutation CreateLab(\$address: String!, \$email: String!, \$name: String!, \$phone: String!) {
      createLab(
        createLabInput: {
          address: \$address
          email: \$email
          name: \$name
          phone: \$phone
        }
      ) {
        address
        email
        id
        name
        phone
      }
    }
  ''';

  //  variables: {
  //     'address': 'rrrrr',
  //     'email': 'asjfajf',
  //     'name': 'ueqwiryeewq',
  //     'phone': '4324124',
  //   },

  static const getLabs = '''
    query Labs(\$itemPerPage: Float!, \$page: Float!) {
      labs(item_per_page: \$itemPerPage, page: \$page) {
        item_per_page
        page
        totalPages
        items {
          address
          email
          id
          name
          phone
        }
      }
    }
  ''';
  //  variables: {
  //     'itemPerPage': 100,
  //     'page': 1,
  //   },

  static const String getSearchLabs = """
    query Labs(\$itemPerPage: Int!, \$page: Int!, \$search: String!) {
      labs(item_per_page: \$itemPerPage, page: \$page, search: \$search) {
        item_per_page
        page
        totalPages
        items {
          address
          email
          id
          name
          phone
        }
      }
    }
  """;

  //  variables: {
  //     'itemPerPage': 100,
  //     'page': 1,
  //     'search': "bdajfkd",
  //   },

  static const String deleteLab = """
    mutation RemoveLab(\$id: Int!) {
      removeLab(id: \$id) {
        address
        email
        id
        name
        phone
      }
    }
  """;

  //  variables: {'id': 1},

  static const String updateLab = """
    mutation UpdateLab(\$id: Int!, \$updateLabInput: LabInput!) {
      updateLab(id: \$id, updateLabInput: \$updateLabInput) {
        address
        email
        id
        name
        phone
      }
    }
  """;
  static const updateLab1 = '''
    mutation UpdateLab(\$id: Int!,\$address: String!, \$email: String!, \$name: String!, \$phone: String!) {
      updateLab(
          id: \$id
        updateLabInput: {
          address: \$address
          email: \$email
          name: \$name
          phone: \$phone
        }
      ) {
        address
        email
        id
        name
        phone
      }
    }
  ''';

  //  variables: {
  //   'id': 1, // Replace with the actual lab ID
  //   'updateLabInput': {
  //     'address': 'ewrq',
  //     'email': 'fsa',
  //     'name': 'ewr',
  //     'phone': 'afsda',
  //   },
  // },
}
