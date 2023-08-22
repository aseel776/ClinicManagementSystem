class LabOrderDocsGql {
  static const String getLabOrders = '''
      query LabOrders(\$id :Float!, \$itemPerPage: Float!, \$page: Float!) {
        labOrders(lab_id:\$id,item_per_page: \$itemPerPage, page: \$page) {
          item_per_page
          page
          totalPages
          items {
            id
            lab_id
            name
            price
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
      query LabOrders(\$id :Int!,\$itemPerPage: Float!, \$page: Float!, \$search: String!) {
        labOrders(lab_id:\$id,item_per_page: \$itemPerPage, page: \$page, search: \$search) {
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
      mutation CreateLabOrder(\$labId: Int!, \$orderName: String!,,\$price1: String!, \$stepNames: [String!]!) {
        createLabOrder(createLabOrderInput: {lab_id: \$labId, name: \$orderName, price: \$price1, steps_names: \$stepNames}) {
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
  static const String updateLabOrderMutation = '''
  mutation UpdateLabOrder(\$id: Int!, \$updateLabOrderInput: UpdateLabOrderInput!) {
    updateLabOrder(id: \$id, updateLabOrderInput: \$updateLabOrderInput) {
      id
      lab_id
      name
      price
    }
  }
''';

  //  variables: {
  //         'id': labOrderId,
  //         'updateLabOrderInput': {
  //           'lab_id': 1,
  //           'name': updatedName,
  //           'price': updatedPrice,
  //           'steps_names': updatedStepsNames,
  //         },
  //       },
}
