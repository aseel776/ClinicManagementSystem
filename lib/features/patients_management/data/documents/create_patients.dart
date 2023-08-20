class CreatePatientsDocsGql {
  static const createPatient = '''
mutation CreatePatient(\$input: CreatePatientInput!) { 
    createPatient(createPatientInput: \$input) {
        address
        birth_date
        gender
        id
        job
        main_complaint
        maintal_status
        name
        phone
    }
  }

''';
}


