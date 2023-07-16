import 'package:clinic_management_system/features/treatments_feature/data/models/treatment_model.dart';
import 'package:clinic_management_system/features/treatments_feature/data/models/treatment_type_model.dart';
import 'package:clinic_management_system/features/treatments_feature/data/models/step_model.dart';
import 'package:flutter/material.dart';

  List<TreatmentModel> treatments = [
    TreatmentModel(
      id: 1,
      color: Colors.red,
      name: 'قلع عادي',
      price: 20000,
      type: types[0],
      steps: <StepModel> [
        StepModel(
          id: 1,
          name: 'قلع',
        ),
      ],
      channels: <String>[
        'لسانية',
        'وحشية',
      ],
    ),
    TreatmentModel(
      id: 2,
      color: Colors.blueGrey,
      name: 'قلع نصف جراحي',
      price: 30000,
      type: types[0],
      steps: <StepModel>[
        StepModel(
          id: 1,
          name: 'قلع',
        ),
        StepModel(
          id: 2,
          name: 'خياطة',
        ),
        StepModel(
          id: 3,
          name: 'فك خيوط',
        )
      ],
      channels: <String>[
        'لسانية',
        'وحشية',
      ],
    ),
    TreatmentModel(
      id: 3,
      color: Colors.lightGreen,
      name: 'املغم',
      price: 25000,
      type: types[2],
      steps: <StepModel>[
        StepModel(
          id: 1,
          name: 'قلع',
        ),
        StepModel(
          id: 2,
          name: 'خياطة',
        ),
        StepModel(
          id: 3,
          name: 'فك خيوط',
        )
      ],
      channels: <String>[],
    ),
    TreatmentModel(
      id: 4,
      color: Colors.amberAccent,
      name: 'قلع عادي',
      price: 20000,
      type: types[0],
      steps: <StepModel>[
        StepModel(
          id: 1,
          name: 'قلع',
        ),
      ],
      channels: <String>[
        'لسانية',
        'وحشية',
      ],
    ),
    TreatmentModel(
      id: 5,
      color: Colors.cyan,
      name: 'قلع نصف جراحي',
      price: 30000,
      type: types[0],
      steps: <StepModel>[
        StepModel(
          id: 1,
          name: 'قلع',
        ),
        StepModel(
          id: 2,
          name: 'خياطة',
        ),
        StepModel(
          id: 3,
          name: 'فك خيوط',
        )
      ],
      channels: <String>[
        'لسانية',
      ],
    ),
    TreatmentModel(
      id: 6,
      color: Colors.deepPurple,
      name: 'املغم',
      price: 25000,
      type: types[2],
      steps: <StepModel>[
        StepModel(
          id: 1,
          name: 'قلع',
        ),
        StepModel(
          id: 2,
          name: 'خياطة',
        ),
        StepModel(
          id: 3,
          name: 'فك خيوط',
        )
      ],
      channels: <String>[
        'لسانية',
        'وحشية',
      ],
    ),
    TreatmentModel(
      id: 7,
      color: Colors.pinkAccent,
      name: 'حشوة',
      price: 20000,
      type: types[0],
      steps: <StepModel>[
        StepModel(
          id: 1,
          name: 'قلع',
        ),
      ],
      channels: <String>[],
    ),
    TreatmentModel(
      id: 8,
      color: Colors.greenAccent,
      name: 'تقويم',
      price: 30000,
      type: types[0],
      steps: <StepModel>[
        StepModel(
          id: 1,
          name: 'قلع',
        ),
        StepModel(
          id: 2,
          name: 'خياطة',
        ),
        StepModel(
          id: 3,
          name: 'فك خيوط',
        )
      ],
      channels: <String>[
        'وحشية',
      ],
    ),
    TreatmentModel(
      id: 9,
      color: Colors.lightBlueAccent,
      name: 'حشوة فضية',
      price: 25000,
      type: types[2],
      steps: <StepModel>[
        StepModel(
          id: 1,
          name: 'قلع',
        ),
        StepModel(
          id: 2,
          name: 'خياطة',
        ),
        StepModel(
          id: 3,
          name: 'فك خيوط',
        )
      ],
      channels: <String>[],
    ),
    TreatmentModel(
      id: 10,
      color: Colors.amberAccent,
      name: 'قلع عادي',
      price: 20000,
      type: types[0],
      steps: <StepModel>[
        StepModel(
          id: 1,
          name: 'قلع',
        ),
      ],
      channels: <String>[
        'لسانية',
        'وحشية',
      ],
    ),
    TreatmentModel(
      id: 11,
      color: Colors.cyan,
      name: 'قلع نصف جراحي',
      price: 30000,
      type: types[0],
      steps: <StepModel>[
        StepModel(
          id: 1,
          name: 'قلع',
        ),
        StepModel(
          id: 2,
          name: 'خياطة',
        ),
        StepModel(
          id: 3,
          name: 'فك خيوط',
        )
      ],
      channels: <String>[
        'وحشية',
      ],
    ),
    TreatmentModel(
      id: 12,
      color: Colors.deepPurple,
      name: 'املغم',
      price: 25000,
      type: types[2],
      steps: <StepModel>[
        StepModel(
          id: 1,
          name: 'قلع',
        ),
        StepModel(
          id: 2,
          name: 'خياطة',
        ),
        StepModel(
          id: 3,
          name: 'فك خيوط',
        )
      ],
      channels: <String>[
        'لسانية',
        'وحشية',
      ],
    ),
    TreatmentModel(
      id: 13,
      color: Colors.black,
      name: 'جراحة',
      price: 25000,
      type: types[2],
      steps: <StepModel>[
        StepModel(
          id: 1,
          name: 'قلع',
        ),
        StepModel(
          id: 2,
          name: 'خياطة',
        ),
        StepModel(
          id: 3,
          name: 'فك خيوط',
        )
      ],
      channels: <String>[
        'لسانية',
        'وحشية',
      ],
    ),
  ];

  List<TreatmentTypeModel> types = [
    TreatmentTypeModel(
      id: 1,
      name: 'جراحة',
    ),
    TreatmentTypeModel(
      id: 2,
      name: 'مداواة لبية',
    ),
    TreatmentTypeModel(
      id: 3,
      name: 'مداواة ترميمية',
    ),
    TreatmentTypeModel(
      id: 4,
      name: 'أطفال',
    ),
    TreatmentTypeModel(
      id: 5,
      name: 'لثة',
    ),
    TreatmentTypeModel(
      id: 6,
      name: 'تعويضات ثابتة',
    ),
    TreatmentTypeModel(
      id: 7,
      name: 'تعويضات متحركة',
    ),
    TreatmentTypeModel(
      id: 8,
      name: 'تقويم',
    ),
  ];
