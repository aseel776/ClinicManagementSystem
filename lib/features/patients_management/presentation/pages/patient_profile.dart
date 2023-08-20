import 'dart:ui';

import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/features/medicine/presentation/widgets/primaryText.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/medical_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../data/models/patient.dart';
import '../riverpod/patients_provider.dart';
import '../riverpod/patients_state.dart';
import '../widgets/medical_record.dart';

StateProvider height = StateProvider((ref) => 0);
StateProvider isPlaying = StateProvider((ref) => false);
StateProvider currentPageViewProvider = StateProvider((ref) => 0);

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
  PageController? pageController;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    super.initState();
    // ref.watch(patientsProvider).getPaginatedBadHabits(10, 1);

    controller = ScrollController();
    _tabController = TabController(length: 3, vsync: this);
    pageController = PageController(initialPage: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(patientsProvider.notifier).getPatientPayments(
          100000000.toDouble(), 1.toDouble(), 1, "amount", "asc");
      await ref.watch(patientsProvider.notifier).getPatientCosts(
          1000000.toDouble(), 1.toDouble(), 1, "amount", "asc");
      final state = ref.watch(patientsProvider.notifier).state;
      if (state is LoadedPatientsState) {
        int patientIndex = state.patients
            .indexWhere((patient) => patient.id == widget.patient.id);
        widget.patient = state.patients[patientIndex];
        // print(widget.patient.patientPayments![1].date);
      }
    });
  }

  List<Map<String, dynamic>> payments = [
    {'date': '2023-08-01', 'amount': 100.0},
    {'date': '2023-08-15', 'amount': 150.0},
    {'date': '2023-08-30', 'amount': 200.0},
    {'date': '2023-08-30', 'amount': 200.0},
    {'date': '2023-08-30', 'amount': 200.0},
    {'date': '2023-08-30', 'amount': 200.0},
    {'date': '2023-08-30', 'amount': 200.0},
    {'date': '2023-08-30', 'amount': 200.0},
  ];
  List<Map<String, dynamic>> costs = [
    {
      'treatment': 'علاج أول',
      'date': '2023-08-01',
      'cost': 150.0,
    },
    {
      'treatment': 'علاج ثاني',
      'date': '2023-08-05',
      'cost': 200.0,
    },
    {
      'treatment': 'علاج ثالث',
      'date': '2023-08-10',
      'cost': 180.0,
    },
  ];
  double calculateTotalCost(List<Map<String, dynamic>> costs) {
    double totalCost = 0.0;
    for (var cost in costs) {
      totalCost += cost['cost'];
    }
    return totalCost;
  }

  var currentPage = "صور شعاعية";
  List navBarItems = [
    "صور شعاعية",
    "صور شمسية",
  ];

  @override
  Widget build(BuildContext context) {
    final sectionWidth = MediaQuery.of(context).size.width;
    final sectionHeight = MediaQuery.of(context).size.height;
    ref.watch(patientsProvider);
    double totalAmount = payments
        .map((payment) => (payment['amount']) ?? 0)
        .fold(0, (sum, amount) => sum + amount);
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
                  PrimaryText(
                    text: widget.patient.name,
                    size: 18,
                    height: 2.3,
                    color: AppColors.black.withOpacity(0.7),
                  ),
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
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
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
                                      'Gender: ${widget.patient.gender ?? "not Found"}',
                                ),
                                const SizedBox(height: 4),
                                PrimaryText(
                                  text:
                                      'Birth Date: ${widget.patient.birthDate ?? "not Found"}',
                                ),
                                const SizedBox(height: 4),
                                PrimaryText(
                                  text:
                                      'Address: ${widget.patient.address ?? "not Found"}',
                                ),
                                const SizedBox(height: 4),
                                PrimaryText(
                                  text:
                                      'Job: ${widget.patient.job ?? "not Found"}',
                                ),
                                const SizedBox(height: 4),
                                PrimaryText(
                                  text:
                                      'Marital Status: ${widget.patient.maritalStatus ?? "not Found"}',
                                ),
                                const SizedBox(height: 4),
                                PrimaryText(
                                  text:
                                      'Main Complaint: ${widget.patient.mainComplaint ?? "not Found"}',
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
                                style: TextStyle(
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
                    ),
                  ),
                ),
                SizedBox(
                  width: sectionWidth * 0.015,
                ),
                Container(
                  width: sectionWidth * 0.315,
                  height: sectionHeight * 0.35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: PrimaryText(
                          text: 'المدفوعات',
                          size: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      // (state)
                      Expanded(
                        child: ListView.builder(
                          itemCount: payments.length,
                          itemBuilder: (context, index) {
                            final payment = payments[index];
                            return ListTile(
                              title: Row(
                                // Create a Row for horizontal alignment
                                children: [
                                  Text(payment['date']),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Icon(Icons.arrow_forward),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text('${payment['amount']} ريال'),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PrimaryText(
                          text:
                              'إجمالي المدفوعات: ${totalAmount.toString()} ريال',
                          size: 16,
                          fontWeight: FontWeight.w300,
                          color: AppColors.black,
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
                  height: sectionHeight * 0.35,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Expanded(
                          child: ListView.builder(
                        itemCount:
                            widget.patient.patientPayments!.payments!.length,
                        itemBuilder: (context, index) {
                          final payment =
                              widget.patient.patientPayments!.payments![index];
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle the row click event here
                                  // Navigate to another page
                                  // You can use Navigator.push or any other navigation method
                                },
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
                                        PrimaryText(
                                            text:
                                                "علاج أول"), // Treatment as header
                                        PrimaryText(
                                            text: payment.date.toString(),
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
                                    PrimaryText(text: '${payment.amount} ألف'),
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
                        child: PrimaryText(
                          text:
                              'إجمالي التكلفة:    ${calculateTotalCost(costs).toStringAsFixed(2)} ألف',
                          size: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black54,
                        ),
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
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            MedicalRecord(
                              patient: widget.patient,
                            ),
                            Stack(
                              children: [
                                MedicalImagesScreen(
                                  pageController: pageController!,
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
                                                                ? currentPage
                                                                : currentPage,
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
                                                          navBarItems.map((e) {
                                                        return CustomNavigationButton(
                                                            text: e,
                                                            screenHeight:
                                                                sectionHeight,
                                                            screenWidth:
                                                                sectionWidth,
                                                            onTap: () {
                                                              setState(() {
                                                                ref
                                                                        .watch(currentPageViewProvider
                                                                            .notifier)
                                                                        .state =
                                                                    navBarItems
                                                                        .indexOf(
                                                                            e);

                                                                currentPage = e;

                                                                pageController!.animateToPage(
                                                                    ref
                                                                        .watch(currentPageViewProvider
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
                                                                (currentPage ==
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
                            Container(
                              color: Colors.deepPurple,
                              // Placeholder content for "التشخيص"
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
                      const PrimaryText(
                        text: 'المدفوعات',
                        size: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
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
                      (widget.patient.patientPayments!.payments != null)
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: widget
                                    .patient.patientPayments!.payments!.length,
                                itemBuilder: (context, index) {
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
                                              text: payment.date.toString()),
                                          SizedBox(width: sectionWidth * 0.01),
                                          const Icon(
                                            Icons.arrow_forward,
                                            size: 14,
                                            color: AppColors.black,
                                          ),
                                          SizedBox(width: sectionWidth * 0.01),
                                          PrimaryText(
                                              text: '${payment.amount} ألف'),
                                        ],
                                      ),
                                      const SizedBox(height: 7),
                                      Divider(
                                        color: AppColors.black.withOpacity(0.3),
                                        height: 1,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          : LoadingAnimationWidget.inkDrop(
                              color: AppColors.black, size: 25),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PrimaryText(
                          text:
                              'إجمالي المدفوعات:       ${totalAmount.toString()} ألف',
                          size: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black54,
                        ),
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
}
