class LabOrderDocsGql {
  static const String getLabOrders = '''
      query LabOrders(\$itemPerPage: Float!, \$page: Float!) {
        labOrders(item_per_page: \$itemPerPage, page: \$page) {
          item_per_page
          page
          totalPages
          items {
            id
            lab_id
            name
            LabOrderStep {
              id
              name
            }
            lab {
              id
              name
              phone
              address
              email
            }
          }
        }
      }
    ''';

  //  variables: {'itemPerPage': itemPerPage, 'page': page},

  static const String getSearchLabsOrders = '''
      query LabOrders(\$itemPerPage: Float!, \$page: Float!, \$search: String!) {
        labOrders(item_per_page: \$itemPerPage, page: \$page, search: \$search) {
          item_per_page
          page
          totalPages
          items {
            id
            lab_id
            name
            LabOrderStep {
              id
              name
            }
            lab {
              id
              name
              phone
              address
              email
            }
          }
        }
      }
    ''';

  //   variables: {
  //   'itemPerPage': itemPerPage,
  //   'page': page,
  //   'search': search,
  // },

  static const String createLabOrder = '''
      mutation CreateLabOrder(\$labId: Int!, \$orderName: String!, \$stepNames: [String!]!) {
        createLabOrder(createLabOrderInput: {lab_id: \$labId, name: \$orderName, steps_names: \$stepNames}) {
          id
          lab_id
          name
          LabOrderStep {
            id
            name
          }
        }
      }
    ''';
  //     variables: {
  //   'labId': labId,
  //   'orderName': orderName,
  //   'stepNames': stepNames,
  // },

  static const String deleteLabOrder = '''
      mutation RemoveLabOrder(\$orderId: Int!) {
        removeLabOrder(id: \$orderId) {
          id
          lab_id
          name
        }
      }
    ''';
  static const String editLabOrder = '''
      mutation UpdateLabOrder(\$orderId: Int!, \$labId: Int!, \$updatedName: String!, \$stepsNames: [String!]!) {
        updateLabOrder(
          id: \$orderId
          updateLabOrderInput: {
            lab_id: \$labId
            name: \$updatedName
            steps_names: \$stepsNames
          }
        ) {
          name
          lab_id
        }
      }
    ''';
  //  variables: {
  //   'orderId': orderId,
  //   'labId': labId,
  //   'updatedName': updatedName,
  //   'stepsNames': stepsNames,
  // },
}
