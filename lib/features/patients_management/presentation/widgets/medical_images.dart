import 'dart:io';

import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/core/primaryText.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_medical_images.dart';
import 'package:clinic_management_system/features/patients_management/presentation/riverpod/create_patient_provider.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
// import 'package:image_picker/image_picker.dart';

import '../../../../core/textField.dart';
import '../../data/models/patient.dart';
import '../pages/patient_profile.dart';
import '../riverpod/patients_provider.dart';
import '../riverpod/patients_state.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
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

  Future<void> pickAndUploadFile() async {
    ref.watch(resultProvider.notifier).state =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (ref.watch(resultProvider.notifier).state != null) {
      PlatformFile file = ref.watch(resultProvider.notifier).state.files.first;
      List<int> fileBytes = File(file.path!).readAsBytesSync();

      MultipartFile imageFile = MultipartFile.fromBytes(
        'image',
        fileBytes,
        filename: file.name,
      );
      String filePath = file.path!;

      // uploadFile(filePath);
    } else {
      // User canceled the file picker
      print('File selection canceled.');
    }
  }

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
        int id;
        if (currentPage == "صور شعاعية") {
          id = 1;
        } else {
          id = 2;
        }
        ref
            .watch(patientsProvider.notifier)
            .getPatientImages(id, widget.patient.id!);
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
    ref.watch(resultProvider);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                ElevatedButton(
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)))),
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.black)),

                  onPressed: pickAndUploadFile,
                  // onPressed: () {},
                  child: const Text('اختر صورة'),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: textfield("عنوان الصورة",
                      ref.watch(imageName.notifier).state, "", 1),
                ),
                if (_pickedFile != null)
                  Image.file(
                    File(_pickedFile!.path),
                    height: 200,
                    width: 200,
                  ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)))),
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.black)),
                  onPressed: () async {
                    if (ref.watch(resultProvider.notifier).state != null) {
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
                              image, ref.watch(resultProvider.notifier).state)
                          .then((value) {
                        if (widget.patient.id != null) {
                          int id;
                          if (currentPage == "صور شعاعية") {
                            id = 1;
                          } else {
                            id = 2;
                          }
                          ref
                              .watch(patientsProvider.notifier)
                              .getPatientImages(id, widget.patient.id!);
                        }

                        Navigator.pop(context);
                      });

                      // uploadFile(filePath);
                    } else {
                      // User canceled the file picker
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("choose image first")));
                      print('File selection canceled.');
                    }
                  },
                  child: const Text("إضافة الصورة"),
                ),
              ],
            ),
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
                return (widget.patient.patientImages != null)
                    ? GridView.builder(
                        itemCount: widget.patient.patientImages!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final imageUrl = widget.patient.patientImages![index];

                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Container(
                                      width: double.infinity,
                                      child: Image.network(
                                        "http://" + imageUrl.src!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                },
                              );
                              // _openFullScreenDialog(imageUrl
                              //     .src!); // Function to open full-screen dialog
                            },
                            child: MouseRegion(
                              onEnter: (_) {
                                // Handle hover event (show icon)
                                // Set a flag or use a state variable to control the visibility of the icon
                              },
                              onExit: (_) {
                                // Handle hover exit event (hide icon)
                                // Reset the flag or state variable
                              },
                              child: Stack(
                                children: [
                                  Image.network("http://" + imageUrl.src!),
                                  const Visibility(
                                    visible:
                                        true, // Set this based on hover flag
                                    child: Icon(Icons.zoom_in),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Container();
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
                return (widget.patient.patientImages != null)
                    ? GridView.builder(
                        itemCount: widget.patient.patientImages!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final imageUrl = widget.patient.patientImages![index];

                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Container(
                                      width: double.infinity,
                                      child: Image.network(
                                        "http://" + imageUrl.src!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                },
                              );
                              // _openFullScreenDialog(imageUrl
                              //     .src!); // Function to open full-screen dialog
                            },
                            child: MouseRegion(
                              onEnter: (_) {
                                // Handle hover event (show icon)
                                // Set a flag or use a state variable to control the visibility of the icon
                              },
                              onExit: (_) {
                                // Handle hover exit event (hide icon)
                                // Reset the flag or state variable
                              },
                              child: Stack(
                                children: [
                                  Image.network("http://" + imageUrl.src!),
                                  const Visibility(
                                    visible:
                                        true, // Set this based on hover flag
                                    child: Icon(Icons.zoom_in),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Container();
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

  // void _openFullScreenDialog(String imageUrl) {

  // }
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
        width: screenWidth * 0.17,
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
