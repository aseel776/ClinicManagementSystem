import 'dart:ui';

import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/features/appointments_sessions/data/models/patient_treatment_model.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/patient_treatments/patient_treatments_state.dart';
import 'package:clinic_management_system/features/medicine/presentation/widgets/primaryText.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_cost.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_payments.dart';
import 'package:clinic_management_system/features/patients_management/data/models/problem_types.dart';
import 'package:clinic_management_system/features/patients_management/presentation/pages/patients_index.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/medical_images.dart';
import 'package:clinic_management_system/features/teeth_model/teeth_model.dart';
import 'package:clinic_management_system/features/treatments_feature/data/models/treatment_model.dart';
import 'package:clinic_management_system/features/treatments_feature/presentation/states/treatment/treatment_provider.dart';
import 'package:clinic_management_system/features/treatments_feature/presentation/states/treatment/treatment_state.dart';
import 'package:clinic_management_system/features/treatments_feature/presentation/states/treatments/treatments_provider.dart';
import 'package:clinic_management_system/features/treatments_feature/presentation/states/treatments/treatments_state.dart';
import 'package:clinic_management_system/sidebar/presentation/pages/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:searchfield/searchfield.dart';

import '../../../../core/textField.dart';
import '../../../appointments_sessions/presentation/states/patient_treatments/patient_treatments_provider.dart';
import '../../data/models/patient.dart';
import '../riverpod/create_patient_provider.dart';
import '../riverpod/patients_provider.dart';
import '../riverpod/patients_state.dart';
import '../widgets/medical_diagnosis.dart';
import '../widgets/medical_record.dart';
import '../widgets/step3_form.dart';

StateProvider height = StateProvider((ref) => 0);
StateProvider isPlaying = StateProvider((ref) => false);
StateProvider currentPageViewProvider = StateProvider((ref) => 0);
StateProvider currentPageViewDiagnosisProvider = StateProvider((ref) => 0);

StateProvider amountPayments = StateProvider((ref) => TextEditingController());
StateProvider paymentsDate = StateProvider<DateTime>((ref) => DateTime(2000));
StateProvider paymentsDateString = StateProvider((ref) => "");

class PatientProfile extends ConsumerStatefulWidget {
  Patient patient;
  PatientProfile({required this.patient});

  @override
  ConsumerState<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends ConsumerState<PatientProfile>
    with TickerProviderStateMixin {
  String? PatientName;
  ScrollController? controller;
  TabController? _tabController;
  AnimationController? animationController;
  PageController? pageControllerImages;
  PageController? pageControllerDiagnosis;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    super.initState();

    controller = ScrollController();
    _tabController = TabController(length: 3, vsync: this);
    pageControllerImages = PageController(initialPage: 0);
    pageControllerDiagnosis = PageController(initialPage: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(patientsProvider.notifier).getPatientPayments(
          100000000.toDouble(), 1.toDouble(), 1, "amount", "asc");
      await ref.watch(patientsProvider.notifier).getPatientCosts(
          1000000.toDouble(), 1.toDouble(), 1, "amount", "asc");
      print("starrrrrrrrrrrt");
      navBarDiagnosis =
          await ref.watch(patientsProvider.notifier).getProblemTypes();
      print("starrrrrrrrrrrt");
      currentPageDiagnosis = navBarDiagnosis[0].name!;

      final state = ref.watch(patientsProvider.notifier).state;
      if (state is LoadedPatientsState) {
        int patientIndex = state.patients
            .indexWhere((patient) => patient.id == widget.patient.id);
        widget.patient = state.patients[patientIndex];
        // print(widget.patient.patientPayments![1].date);
      }
    });
  }

  var currentPageImages = "صور شعاعية";
  List navBarImages = [
    "صور شعاعية",
    "صور شمسية",
  ];
  var currentPageDiagnosis = "";
  List<ProblemTypes> navBarDiagnosis = [];

  @override
  Widget build(BuildContext context) {
    final sectionWidth = MediaQuery.of(context).size.width;
    final sectionHeight = MediaQuery.of(context).size.height;
    ref.watch(patientsProvider);
    ref.watch(patientTreatmentsProvider);
    // double totalAmount = payments
    //     .map((payment) => (payment['amount']) ?? 0)
    //     .fold(0, (sum, amount) => sum + amount);
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: CustomScrollView(
        controller: controller,
        clipBehavior: Clip.none,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: sectionHeight * 0.02),
              child: Row(
                children: [
                  const PrimaryText(
                    text: "المرضى",
                    size: 22,
                    height: 2,
                  ),
                  SizedBox(
                    width: sectionWidth * 0.004,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 6.0),
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 18,
                    ),
                  ),
                  SizedBox(
                    width: sectionWidth * 0.004,
                  ),
                  TextButton(
                    onPressed: () {
                      ref.watch(pageProvider.notifier).state = PatientIndex();
                    },
                    child: PrimaryText(
                      text: widget.patient.name,
                      size: 18,
                      height: 2.3,
                      color: AppColors.black.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(AppColors.black)),
                      onPressed: () {
                        showTeethModel(context, ref);
                      },
                      child: const PrimaryText(
                        text: "نموذج الاسنان ",
                      ))
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Container(
                    width: sectionWidth * 0.25,
                    height: sectionHeight * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.lightGrey,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PrimaryText(
                                  text:
                                      'الجنس: ${(widget.patient.gender == "male") ? "ذكر" ?? "غير موجود" : "إنثى"}',
                                ),
                                const SizedBox(height: 4),
                                PrimaryText(
                                  text:
                                      'تاريخ الميلاد: ${widget.patient.birthDate ?? "غير موجود"}',
                                ),
                                const SizedBox(height: 4),
                                PrimaryText(
                                  text:
                                      'العنوان: ${widget.patient.address ?? "غير موجود"}',
                                ),
                                const SizedBox(height: 4),
                                PrimaryText(
                                  text:
                                      'الوظيفة: ${widget.patient.job ?? "غير موجود"}',
                                ),
                                const SizedBox(height: 4),
                                PrimaryText(
                                  text:
                                      'الحالة الزوجية: ${widget.patient.maritalStatus ?? "غير موجود"}',
                                ),
                                const SizedBox(height: 4),
                                PrimaryText(
                                  text:
                                      'الشكوى الرئيسية: ${widget.patient.mainComplaint ?? "غير موجود"}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const VerticalDivider(),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                  "assets/images/patient.png",
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.patient.name!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: sectionHeight * 0.1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  width: sectionWidth * 0.015,
                ),
                // Container(
                //   width: sectionWidth * 0.315,
                //   height: sectionHeight * 0.35,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const Padding(
                //         padding: EdgeInsets.all(8.0),
                //         child: PrimaryText(
                //           text: 'المدفوعات',
                //           size: 14,
                //           fontWeight: FontWeight.bold,
                //           color: AppColors.black,
                //         ),
                //       ),
                //       // (state)
                //       Expanded(
                //         child: ListView.builder(
                //           itemCount: payments.length,
                //           itemBuilder: (context, index) {
                //             final payment = payments[index];
                //             return ListTile(
                //               title: Row(
                //                 // Create a Row for horizontal alignment
                //                 children: [
                //                   Text(payment['date']),
                //                   const SizedBox(
                //                     width: 20,
                //                   ),
                //                   const Icon(Icons.arrow_forward),
                //                   const SizedBox(
                //                     width: 20,
                //                   ),
                //                   Text('${payment['amount']} ريال'),
                //                 ],
                //               ),
                //             );
                //           },
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: PrimaryText(
                //           text:
                //               'إجمالي المدفوعات: ${widget.patient.patientCosts.toString()} ريال',
                //           size: 16,
                //           fontWeight: FontWeight.w300,
                //           color: AppColors.black,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  width: sectionWidth * 0.03,
                ),
                Container(
                  width: sectionWidth * 0.2,
                  height: sectionHeight * 0.35,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: PrimaryText(
                              text: 'التكاليف',
                              size: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 70,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      AppColors.black)),
                              onPressed: () async {
                                await ref
                                    .watch(treatmentsProvider.notifier)
                                    .getAllTreatments();
                                add_costs_popup(context, ref);
                              },
                              child: const Icon(Icons.add)),
                        ],
                      ),
                      Expanded(
                          child: ListView.builder(
                        itemCount: (widget.patient.patientCosts != null)
                            ? widget.patient.patientCosts!.costs!.length
                            : 0,
                        itemBuilder: (context, index) {
                          // final payment =
                          //     widget.patient.patientPayments!.payments![index];
                          final cost = widget.patient.patientCosts!;
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.teal,
                                      ),
                                    ),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const PrimaryText(
                                            text:
                                                "علاج أول"), // Treatment as header
                                        PrimaryText(
                                            text: cost.costs![index].date
                                                .toString(),
                                            size: 14), // Date as subtitle
                                      ],
                                    ),
                                    // const Spacer(), // Spacer to push the arrow and amount to the right
                                    const Icon(
                                      Icons.arrow_forward,
                                      size: 14,
                                      color: AppColors.black,
                                    ),
                                    SizedBox(width: sectionWidth * 0.01),
                                    PrimaryText(
                                        text: '${cost.costs![index].amount} '),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 7),
                              Divider(
                                color: AppColors.black.withOpacity(0.3),
                                height: 1,
                              ),
                            ],
                          );
                        },
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (widget.patient.patientCosts != null)
                            ? (widget.patient.patientCosts!.totalAmounts !=
                                    null)
                                ? PrimaryText(
                                    text:
                                        "إجمالي التكلفة:    ${widget.patient.patientCosts!.totalAmounts! ?? ""} ",
                                    size: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black54,
                                  )
                                : Container()
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: sectionHeight * 0.02),
          ),
          SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: sectionWidth * 0.58,
                  height: sectionHeight * 0.68,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: sectionHeight * 0.06,
                          width: sectionWidth * 0.3,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8)),
                          child: TabBar(
                            controller: _tabController,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            tabs: const [
                              Tab(
                                child: PrimaryText(
                                  text: "سجل صحي",
                                  color: AppColors.black,
                                ),
                              ),
                              Tab(
                                child: PrimaryText(
                                  text: "الصور",
                                  color: AppColors.black,
                                ),
                              ),
                              Tab(
                                child: PrimaryText(
                                  text: "التشخيص",
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sectionHeight * 0.01,
                      ), // Space between TabBar and TabBarView
                      Expanded(
                        // TabBarView with flexible height
                        child: TabBarView(
                          controller: _tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            MedicalRecord(
                              patient: widget.patient,
                            ),
                            Stack(
                              children: [
                                MedicalImagesScreen(
                                  pageController: pageControllerImages!,
                                  patient: widget.patient,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: ref.watch(height.notifier).state == 0
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                            .watch(
                                                                height.notifier)
                                                            .state ==
                                                        0
                                                    ? ref
                                                        .watch(height.notifier)
                                                        .state = 100
                                                    : ref
                                                        .watch(height.notifier)
                                                        .state = 0;
                                                ref
                                                        .read(isPlaying.notifier)
                                                        .state =
                                                    !ref
                                                        .watch(
                                                            isPlaying.notifier)
                                                        .state;
                                                ref
                                                        .watch(
                                                            isPlaying.notifier)
                                                        .state
                                                    ? animationController!
                                                        .forward()
                                                    : animationController!
                                                        .reverse();
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: sectionWidth * 0.285,
                                                  bottom: sectionHeight * 0,
                                                  top: sectionHeight * 0.4),
                                              child: ClipRRect(
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 5, sigmaY: 5),
                                                  child: Container(
                                                    height: 50,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black45,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Row(
                                                      children: [
                                                        AnimatedContainer(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      150),
                                                          width: ref
                                                                      .watch(height
                                                                          .notifier)
                                                                      .state ==
                                                                  130
                                                              ? 105
                                                              : 0,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 15.0),
                                                          child: Text(
                                                            ref
                                                                        .watch(height
                                                                            .notifier)
                                                                        .state ==
                                                                    130
                                                                ? currentPageImages
                                                                : currentPageImages,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12.0),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Icon(
                                                            Icons
                                                                .keyboard_arrow_down_outlined,
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                top: sectionHeight * 0.35,
                                                left: sectionWidth * 0.28,
                                                bottom: sectionHeight * 0),
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              //curve: Curves.easeInOut,
                                              height: (ref
                                                          .watch(
                                                              height.notifier)
                                                          .state -
                                                      10)
                                                  .toDouble(),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.black45),
                                              width: 160,
                                              child: SingleChildScrollView(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 5, sigmaY: 5),
                                                    child: Column(
                                                      children:
                                                          navBarImages.map((e) {
                                                        return CustomNavigationButton(
                                                            text: e,
                                                            screenHeight:
                                                                sectionHeight,
                                                            screenWidth:
                                                                sectionWidth,
                                                            onTap: () async {
                                                              setState(() {
                                                                ref
                                                                        .watch(currentPageViewProvider
                                                                            .notifier)
                                                                        .state =
                                                                    navBarImages
                                                                        .indexOf(
                                                                            e);

                                                                currentPageImages =
                                                                    e;

                                                                pageControllerImages!.animateToPage(
                                                                    ref
                                                                        .watch(currentPageViewProvider
                                                                            .notifier)
                                                                        .state,
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            3000),
                                                                    curve: Curves
                                                                        .easeInOut);
                                                                // ref
                                                                //     .watch(patientsProvider
                                                                //         .notifier)
                                                                //     .getPatientImages(
                                                                //         ref
                                                                //             .watch(currentPageViewProvider
                                                                //                 .notifier)
                                                                //             .state,
                                                                //         widget
                                                                //             .patient
                                                                //             .id!);
                                                                ref.watch(height.notifier).state ==
                                                                        0
                                                                    ? ref
                                                                            .watch(height
                                                                                .notifier)
                                                                            .state =
                                                                        130
                                                                    : ref
                                                                        .watch(height
                                                                            .notifier)
                                                                        .state = 0;
                                                                ref
                                                                        .read(isPlaying
                                                                            .notifier)
                                                                        .state =
                                                                    !ref
                                                                        .watch(isPlaying
                                                                            .notifier)
                                                                        .state;
                                                                ref
                                                                        .watch(isPlaying
                                                                            .notifier)
                                                                        .state
                                                                    ? animationController!
                                                                        .forward()
                                                                    : animationController!
                                                                        .reverse();
                                                              });
                                                            },
                                                            selected:
                                                                (currentPageImages ==
                                                                        e)
                                                                    ? true
                                                                    : false);
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                )
                              ],
                            ),
                            Stack(
                              children: [
                                MedicalDiagnosisScreen(
                                  pageController: pageControllerDiagnosis!,
                                  patient: widget.patient,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: ref.watch(height.notifier).state == 0
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ref
                                                            .watch(
                                                                height.notifier)
                                                            .state ==
                                                        0
                                                    ? ref
                                                        .watch(height.notifier)
                                                        .state = 170
                                                    : ref
                                                        .watch(height.notifier)
                                                        .state = 0;
                                                ref
                                                        .read(isPlaying.notifier)
                                                        .state =
                                                    !ref
                                                        .watch(
                                                            isPlaying.notifier)
                                                        .state;
                                                ref
                                                        .watch(
                                                            isPlaying.notifier)
                                                        .state
                                                    ? animationController!
                                                        .forward()
                                                    : animationController!
                                                        .reverse();
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: sectionWidth * 0.285,
                                                  bottom: sectionHeight * 0,
                                                  top: sectionHeight * 0.4),
                                              child: ClipRRect(
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 5, sigmaY: 5),
                                                  child: Container(
                                                    height: 50,
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black45,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Row(
                                                      children: [
                                                        AnimatedContainer(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      150),
                                                          width: ref
                                                                      .watch(height
                                                                          .notifier)
                                                                      .state ==
                                                                  170
                                                              ? 125
                                                              : 0,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 15.0),
                                                          child: Text(
                                                            ref
                                                                        .watch(height
                                                                            .notifier)
                                                                        .state ==
                                                                    170
                                                                ? currentPageDiagnosis
                                                                : currentPageDiagnosis,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12.0),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Icon(
                                                            Icons
                                                                .keyboard_arrow_down_outlined,
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                top: sectionHeight * 0.35,
                                                left: sectionWidth * 0.28,
                                                bottom: sectionHeight * 0),
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              //curve: Curves.easeInOut,
                                              height: (ref
                                                          .watch(
                                                              height.notifier)
                                                          .state -
                                                      10)
                                                  .toDouble(),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.black45),
                                              width: 200,
                                              child: SingleChildScrollView(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 5, sigmaY: 5),
                                                    child: Column(
                                                      children: navBarDiagnosis
                                                          .map((e) {
                                                        return CustomNavigationButton(
                                                            text: e.name!,
                                                            screenHeight:
                                                                sectionHeight,
                                                            screenWidth:
                                                                sectionWidth,
                                                            onTap: () async {
                                                              setState(() {
                                                                final index = navBarDiagnosis.indexWhere(
                                                                    (element) =>
                                                                        element
                                                                            .name ==
                                                                        e.name);

                                                                if (index !=
                                                                    -1) {
                                                                  ref
                                                                      .watch(currentPageViewDiagnosisProvider
                                                                          .notifier)
                                                                      .state = index;
                                                                }

                                                                // ref
                                                                //         .watch(currentPageViewDiagnosisProvider
                                                                //             .notifier)
                                                                //         .state =
                                                                //     navBarDiagnosis.indexWhere(
                                                                //         currentPageDiagnosis ==
                                                                //             e.name);
                                                                setState(() {
                                                                  currentPageDiagnosis =
                                                                      e.name!;
                                                                });
                                                                ref
                                                                    .watch(patientsProvider
                                                                        .notifier)
                                                                    .getPatientDiagnosis(
                                                                      6,
                                                                      1,
                                                                      widget
                                                                          .patient
                                                                          .id!,
                                                                      ref.watch(currentPageViewDiagnosisProvider.notifier).state +
                                                                          1,
                                                                    );

                                                                pageControllerDiagnosis!.animateToPage(
                                                                    ref
                                                                        .watch(currentPageViewDiagnosisProvider
                                                                            .notifier)
                                                                        .state,
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            3000),
                                                                    curve: Curves
                                                                        .easeInOut);
                                                                ref.watch(height.notifier).state ==
                                                                        0
                                                                    ? ref
                                                                            .watch(height
                                                                                .notifier)
                                                                            .state =
                                                                        150
                                                                    : ref
                                                                        .watch(height
                                                                            .notifier)
                                                                        .state = 0;
                                                                ref
                                                                        .read(isPlaying
                                                                            .notifier)
                                                                        .state =
                                                                    !ref
                                                                        .watch(isPlaying
                                                                            .notifier)
                                                                        .state;
                                                                ref
                                                                        .watch(isPlaying
                                                                            .notifier)
                                                                        .state
                                                                    ? animationController!
                                                                        .forward()
                                                                    : animationController!
                                                                        .reverse();
                                                              });
                                                            },
                                                            selected:
                                                                (currentPageDiagnosis ==
                                                                        e.name)
                                                                    ? true
                                                                    : false);
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: sectionWidth * 0.03,
                ),
                Container(
                  width: sectionWidth * 0.2,
                  height: sectionHeight * 0.48,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const PrimaryText(
                            text: 'المدفوعات',
                            size: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          const SizedBox(
                            width: 70,
                          ),
                          TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      AppColors.black)),
                              onPressed: () {
                                add_payments_popup(context, ref);
                              },
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          PrimaryText(
                            text: "تاريخ الدفعة",
                            color: Colors.black54,
                          ),
                          PrimaryText(
                            text: " المبلغ",
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      (widget.patient.patientPayments != null)
                          ? (widget.patient.patientPayments!.payments != null)
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: widget.patient.patientPayments!
                                        .payments!.length,
                                    itemBuilder: (context, index) {
                                      print("aaaaaaaaaaaaaa");
                                      print(widget.patient.patientPayments!
                                          .payments!.length);
                                      final payment = widget.patient
                                          .patientPayments!.payments![index];
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.teal,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              PrimaryText(
                                                  text:
                                                      payment.date.toString()),
                                              SizedBox(
                                                  width: sectionWidth * 0.01),
                                              const Icon(
                                                Icons.arrow_forward,
                                                size: 14,
                                                color: AppColors.black,
                                              ),
                                              SizedBox(
                                                  width: sectionWidth * 0.01),
                                              PrimaryText(
                                                  text: '${payment.amount} '),
                                            ],
                                          ),
                                          const SizedBox(height: 7),
                                          Divider(
                                            color: AppColors.black
                                                .withOpacity(0.3),
                                            height: 1,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                )
                              : LoadingAnimationWidget.inkDrop(
                                  color: AppColors.black, size: 25)
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (widget.patient.patientPayments != null)
                            ? (widget.patient.patientPayments!.totalAmounts !=
                                    null)
                                ? PrimaryText(
                                    text:
                                        'إجمالي المدفوعات:       ${widget.patient.patientPayments!.totalAmounts!.toString()} ',
                                    size: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black54,
                                  )
                                : Container()
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 50,
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showTeethModel(
    BuildContext context,
    WidgetRef ref,
  ) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    await ref
        .watch(patientTreatmentsProvider.notifier)
        .getOngoingTreatments(widget.patient.id!);
    ref.watch(patientTreatmentsProvider);
    final state = ref.watch(patientTreatmentsProvider);
    if (state is LoadedPatientTreatmentsState) {
      for (var i in state.treatments) {
        for (var j in teeth) {
          if (i.place == j.name) {
            print("hereee");
            var updatedTreatments = List.from(j.treatments ?? [])
              ..add(i); // Create a new list with added element
            j.treatments = updatedTreatments.cast<PatientTreatmentModel>();
          }
        }
      }
    }

    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Dialog(
                backgroundColor: AppColors.lightGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.6,
                      child: MotionControl(teeth: teeth));
                }),
              ),
            ));
  }

  Future<dynamic> add_payments_popup(
    BuildContext context,
    WidgetRef ref,
  ) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Dialog(
                backgroundColor: AppColors.lightGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: PrimaryText(
                            text: "إضافة دفعة جديدة ",
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: screenWidth * 0.2,
                          child: textfield("المبلغ ",
                              ref.watch(amountPayments.notifier).state, "", 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.075,
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                    child: const Row(children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.black26,
                                      ),
                                      PrimaryText(
                                        text: "تاريخ الدفعة",
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ]),
                                    onTap: () async {
                                      final datePick = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime(2000),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100));
                                      if (datePick != null &&
                                          datePick != badHabitDate) {
                                        ref.read(badHabitDate.notifier).state =
                                            datePick;

                                        ref
                                            .read(paymentsDateString.notifier)
                                            .state = DateFormat(
                                                "yyyy-MM-dd")
                                            .format(ref
                                                .watch(paymentsDate.notifier)
                                                .state!);

                                        print(ref.watch(paymentsDateString));
                                      }
                                    }),
                                const SizedBox(
                                  width: 10,
                                ),
                                ref.watch(badHabitDateString) == null
                                    ? const Text("DD/MM/YYYY")
                                    : Text("${ref.watch(badHabitDateString)}")
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        SizedBox(
                          width: screenWidth * 0.08,
                          child: ElevatedButton(
                              onPressed: () async {
                                // ref.watch(productsProvider.notifier)

                                PatientPayment payment = PatientPayment(
                                    amount: int.tryParse(ref
                                        .watch(amountPayments.notifier)
                                        .state
                                        .text)!,
                                    date: ref
                                        .watch(paymentsDateString.notifier)
                                        .state);
                                await ref
                                    .watch(patientsCrudProvider.notifier)
                                    .createPatientPayments(
                                        payment, widget.patient.id!)
                                    .then((value) {
                                  ref
                                      .watch(patientsProvider.notifier)
                                      .getPatientPayments(
                                          10000,
                                          1,
                                          widget.patient.id!.toDouble(),
                                          "amount",
                                          "asc");
                                });

                                Navigator.pop(context);
                              },
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    AppColors.lightGreen),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.elliptical(50, 70)))),
                              ),
                              child: const PrimaryText(
                                text: "إضافة",
                                height: 1.7,
                                color: AppColors.black,
                              )),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ));
  }

  Future<dynamic> add_costs_popup(
    BuildContext context,
    WidgetRef ref,
  ) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final state = ref.watch(treatmentsProvider.notifier).state;
    TreatmentModel currentTreatment = TreatmentModel();
    TextEditingController treatmentController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Dialog(
                backgroundColor: AppColors.lightGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: PrimaryText(
                            text: "إضافة دفعة جديدة ",
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: SearchField(
                              hint: 'Search',
                              controller: treatmentController,
                              onSuggestionTap: (p0) {
                                currentTreatment = p0.item as TreatmentModel;
                              },
                              searchInputDecoration: InputDecoration(
                                fillColor: Colors.transparent,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              maxSuggestionsInViewPort: 6,
                              itemHeight: 50,
                              suggestionsDecoration: SuggestionDecoration(
                                  color: AppColors.lightGreen,
                                  borderRadius: BorderRadius.circular(10),
                                  padding: const EdgeInsets.all(10)),
                              marginColor: Colors.transparent,
                              suggestions: (state is LoadedTreatmentsState)
                                  ? List.generate(
                                      state.page.treatments!.length,
                                      (index) => SearchFieldListItem(
                                          state.page.treatments![index].name!,
                                          item: state.page.treatments![index]))
                                  : []),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: screenWidth * 0.2,
                          child: textfield("المبلغ ",
                              ref.watch(amountPayments.notifier).state, "", 1),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.075,
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                    child: const Row(children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.black26,
                                      ),
                                      PrimaryText(
                                        text: "تاريخ الدفعة",
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ]),
                                    onTap: () async {
                                      final datePick = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime(2000),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100));
                                      if (datePick != null &&
                                          datePick != badHabitDate) {
                                        ref.read(badHabitDate.notifier).state =
                                            datePick;

                                        ref
                                            .read(paymentsDateString.notifier)
                                            .state = DateFormat(
                                                "yyyy-MM-dd")
                                            .format(ref
                                                .watch(paymentsDate.notifier)
                                                .state!);

                                        print(ref.watch(paymentsDateString));
                                      }
                                    }),
                                const SizedBox(
                                  width: 10,
                                ),
                                ref.watch(badHabitDateString) == null
                                    ? const Text("DD/MM/YYYY")
                                    : Text("${ref.watch(badHabitDateString)}")
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        SizedBox(
                          width: screenWidth * 0.08,
                          child: ElevatedButton(
                              onPressed: () async {
                                // ref.watch(productsProvider.notifier)

                                PatientCost cost = PatientCost(
                                    amount: int.tryParse(ref
                                        .watch(amountPayments.notifier)
                                        .state
                                        .text)!,
                                    treatmentId: currentTreatment.id,
                                    treatment: currentTreatment.name,
                                    date: ref
                                        .watch(paymentsDateString.notifier)
                                        .state);
                                await ref
                                    .watch(patientsCrudProvider.notifier)
                                    .createPatientCosts(
                                        cost, widget.patient.id!)
                                    .then((value) {
                                  ref
                                      .watch(patientsProvider.notifier)
                                      .getPatientCosts(
                                          10000,
                                          1,
                                          widget.patient.id!.toDouble(),
                                          "amount",
                                          "asc");
                                });

                                Navigator.pop(context);
                              },
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    AppColors.lightGreen),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.elliptical(50, 70)))),
                              ),
                              child: const PrimaryText(
                                text: "إضافة",
                                height: 1.7,
                                color: AppColors.black,
                              )),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ));
  }
}
