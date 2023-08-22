import 'dart:io';

import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/core/primaryText.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_medical_images.dart';
import 'package:clinic_management_system/features/patients_management/presentation/riverpod/create_patient_provider.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:image_picker/image_picker.dart';

import '../../../../core/textField.dart';
import '../../data/models/patient.dart';
import '../pages/patient_profile.dart';
import '../riverpod/patients_provider.dart';
import '../riverpod/patients_state.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:graphql/client.dart';
import 'package:path/path.dart';
// import 'package:file_picker/file_picker.dart'; // Import the file_picker package

StateProvider selectedImage = StateProvider<File?>((ref) => null);
StateProvider imageName = StateProvider((ref) => TextEditingController());
StateProvider resultProvider = StateProvider((ref) => null);

class MedicalImagesScreen extends ConsumerStatefulWidget {
  PageController pageController;
  Patient patient;
  MedicalImagesScreen(
      {super.key, required this.pageController, required this.patient});

  @override
  ConsumerState<MedicalImagesScreen> createState() =>
      _MedicalImagesScreenState();
}

class _MedicalImagesScreenState extends ConsumerState<MedicalImagesScreen> {
  File? _pickedFile; // Change PlatformFile to File

  // Future<void> pickAndUploadFile() async {
  //   ref.watch(resultProvider.notifier).state =
  //       await FilePicker.platform.pickFiles();
  //   // FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   // result!.files.single.path;
  //
  //   if (ref.watch(resultProvider.notifier).state != null) {
  //     PlatformFile file = ref.watch(resultProvider.notifier).state.files.first;
  //     String filePath = file.path!;
  //
  //     // uploadFile(filePath);
  //   } else {
  //     // User canceled the file picker
  //     print('File selection canceled.');
  //   }
  // }

  // late PageController pagecontroller;
  var currentPage = "صور شعاعية";
  List navBarItems = [
    "صور شعاعية",
    "صور شمسية",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.patient.id != null) {
        await ref
            .watch(patientsProvider.notifier)
            .getPatientImages(1, widget.patient.id!);

        final state = ref.watch(patientsProvider.notifier).state;
        if (state is LoadedPatientsState) {
          int patientIndex = state.patients
              .indexWhere((patient) => patient.id == widget.patient.id);
          widget.patient = state.patients[patientIndex];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sectionWidth = MediaQuery.of(context).size.width;
    final sectionHeight = MediaQuery.of(context).size.height;
    ref.watch(selectedImage);

    return Stack(
      children: [
        Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height * 0.52,
            width: MediaQuery.of(context).size.width,
            child: pageView(
                ref.watch(currentPageViewProvider.notifier).state, ref)),
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.44),
          child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(AppColors.black)),
              onPressed: () {
                _showImagePickerDialog(context);
                // _displayPickImageDialog(context, (i, i, i) {});
              },
              child: const PrimaryText(
                text: "إضافة صورة",
              )),
        ),
      ],
    );
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: textfield(
                    "عنوان الصورة", ref.watch(imageName.notifier).state, "", 1),
              ),
              if (_pickedFile != null)
                Image.file(
                  File(_pickedFile!.path),
                  height: 200,
                  width: 200,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                // onPressed: pickAndUploadFile,
                onPressed: (){},
                child: const Text('اختر صورة'),
              ),
              ElevatedButton(
                onPressed: () async {
                  int id;
                  if (currentPage == "صور شعاعية") {
                    id = 1;
                  } else {
                    id = 2;
                  }
                  PatientMedicalImage image = PatientMedicalImage(
                      medicalImageTypeId: id,
                      patientId: widget.patient.id,
                      title: ref.watch(imageName.notifier).state.text);
                  ref
                      .watch(patientsCrudProvider.notifier)
                      .addNewImage(
                          image,
                          File(ref
                              .watch(resultProvider.notifier)
                              .state
                              .files
                              .single
                              .path))
                      .then((value) {
                    Navigator.pop(context);
                  });
                },
                child: const Text("إضافة الصورة"),
              ),
              //         Mutation(
              //   options: MutationOptions(
              //     document: gql(uploadImageMutation),
              //   ),
              //   builder: (RunMutation runMutation, QueryResult result) {
              //     return Center(
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           ElevatedButton(
              //             onPressed: () async {
              //               // Replace with your image file logic
              //               var file = ...; // Replace with your File object

              //               final Map<String, dynamic> variables = {
              //                 'file': file,
              //               };

              //               runMutation(variables);
              //             },
              //             child: Text('Upload Image'),
              //           ),
              //           if (result.loading)
              //             CircularProgressIndicator()
              //           else if (result.hasException)
              //             Text('Error: ${result.exception.toString()}')
              //           else if (result.data != null)
              //             Text('Image Uploaded: ${result.data.toString()}'),
              //         ],
              //       ),
              //     );
              //   },
              //   onCompleted: (dynamic data) {
              //     // Called when the mutation is completed
              //   },
              //   update: (GraphQLDataProxy cache, QueryResult result) {
              //     // Update cache if needed
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget pageView(int currentPage, WidgetRef ref) {
    switch (currentPage) {
      case 0:
        {
          return PageView.custom(
            scrollDirection: Axis.horizontal,
            controller: widget.pageController,
            childrenDelegate: SliverChildBuilderDelegate(
              ((context, index) {
                return Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, top: 15, right: 10),
                    child: Container(
                      color: Colors.green,
                      child: const Text("sh3a3ehhh"),
                    ));
              }),
              childCount: 1,
            ),
          );
        }
      case 1:
        {
          return PageView.custom(
            scrollDirection: Axis.horizontal,
            controller: widget.pageController,
            childrenDelegate: SliverChildBuilderDelegate(
              ((context, index) {
                return Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, top: 15, right: 10),
                    child: Container(
                      color: Colors.red,
                      child: const Text("shamsieeeh"),
                    ));
              }),
              childCount: 1,
            ),
          );
        }
      default:
        {
          return Container();
        }
    }
  }
}

class CustomNavigationButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool selected;
  final double screenHeight;
  final double screenWidth;

  CustomNavigationButton({
    required this.text,
    required this.onTap,
    required this.selected,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: const BoxDecoration(
          color: Colors.black45,
        ),
        height: screenHeight * 0.065,
        width: screenWidth * 0.18,
        child: Center(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                  ),
                ),
              ),
              if (text == "accepted request") const SizedBox(width: 5),
              if (selected)
                const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.check,
                    color: Colors.white54,
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
