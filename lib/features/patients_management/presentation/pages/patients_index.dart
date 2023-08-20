import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/features/medicine/presentation/widgets/primaryText.dart';
import 'package:clinic_management_system/features/patients_management/presentation/pages/patient_profile.dart';
import 'package:clinic_management_system/features/patients_management/presentation/pages/patients.dart';
import 'package:clinic_management_system/features/patients_management/presentation/riverpod/patients_provider.dart';
import 'package:clinic_management_system/features/patients_management/presentation/riverpod/patients_state.dart';
import 'package:clinic_management_system/sidebar/presentation/pages/sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../data/models/patient.dart';

StateProvider totalPagesPatientsTable = StateProvider((ref) => 1);
StateProvider currentPagePatientsTable = StateProvider((ref) => 1);

class PatientIndex extends ConsumerStatefulWidget {
  const PatientIndex({Key? key}) : super(key: key);

  @override
  ConsumerState<PatientIndex> createState() => PatientIndexState();
}

class PatientIndexState extends ConsumerState<PatientIndex> {
  @override
  void initState() {
    super.initState();
    // ref.watch(patientsProvider).getPaginatedBadHabits(10, 1);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(patientsProvider.notifier).getPaginatedPatients(5, 1);
      final state = ref.watch(patientsProvider.notifier).state;
      if (state is LoadedPatientsState) {
        ref.watch(totalPagesPatientsTable.notifier).state = state.totalPages;
        print("blablabal");
        print(ref.watch(totalPagesPatientsTable.notifier).state);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(patientsProvider);
    final state = ref.watch(patientsProvider.notifier).state;
    final totalPages = ref.watch(totalPagesPatientsTable);
    final currentPage = ref.watch(currentPagePatientsTable);
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 30.0, right: 20),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: "قسم المرضى",
                  size: 23,
                  fontWeight: FontWeight.bold,
                ),
                PrimaryText(
                  text: "جميع المرضى المسجلين في العيادة",
                  size: 14,
                  fontWeight: FontWeight.w200,
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(defaultSpace),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(defaultSpace / 2)),
              color: Colors.white,
              shape: BoxShape.rectangle,
            ),
            margin: const EdgeInsets.only(
              top: defaultSpace * 2,
              left: defaultSpace,
              right: defaultSpace * 2,
              bottom: defaultSpace * 0,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: defaultSpace * 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 400,
                          height: 40,
                          decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(.5),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.grey.withOpacity(.4),
                              width: .7,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(defaultSpace / 2),
                                child: Icon(
                                  CupertinoIcons.search,
                                  color: Colors.grey.withOpacity(.8),
                                ),
                              ),
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: defaultSpace,
                                  ),
                                  child: TextField(
                                    // onChanged: _onSearchTextChanged,
                                    style: TextStyle(fontSize: 12),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              ButtonWidgetWithIcon(
                                icon: Icons.keyboard_arrow_down_outlined,
                                label: 'Filter',
                                onTap: () {
                                  print("filter clicked");
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: defaultSpace / 2,
                        ),
                        Row(
                          children: [
                            // ButtonWidgetWithIcon(
                            //   borderColor: primaryColor,
                            //   borderRadius: 4,
                            //   labelAndIconColor: primaryColor,
                            //   icon: Icons.keyboard_arrow_down_outlined,
                            //   label: 'Export',
                            //   onTap: () {
                            //     print("export clicked");
                            //   },
                            // ),
                            const SizedBox(
                              width: defaultSpace / 2,
                            ),
                            GestureDetector(
                              onTap: () {
                                ref.watch(pageProvider.notifier).state = CreatePatients();
                              },
                              child: Container(
                                width: 120,
                                height: 45,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: AppColors.black,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: PrimaryText(
                                      text: "إضافة مريض ",
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  (state is LoadingPatientsState)
                      ? LoadingAnimationWidget.inkDrop(
                          color: AppColors.black, size: 25)
                      : (state is ErrorPatientsState)
                          ? Center(
                              child: PrimaryText(
                                text: state.message,
                              ),
                            )
                          : (state is LoadedPatientsState)
                              ? DataTable(
                                  columnSpacing: 80,

                                  columns: _buildProductColumns(),
                                  rows: (state is LoadedPatientsState)
                                      ? state.patients
                                          .map((e) => _buildProductRow(e))
                                          .toList()
                                      : <DataRow>[], // Pass an empty list as List<DataRow>
                                )
                              : Container(),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PaginationWidget(
              totalPages: totalPages,
              currentPage: currentPage,
              onPageSelected: (i) async {
                print("iiiii");
                print(i);
                await ref
                    .watch(patientsProvider.notifier)
                    .getPaginatedPatients(5, (i + 1).toDouble());
                ref.watch(currentPagePatientsTable.notifier).state = i + 1;
              },
            )
          ],
        ),
      ],
    );
  }

  // void _onSearchTextChanged(String searchTerm) {
  //   if (searchTerm.length >= 2) {
  //     filteredProductList = productList
  //         .where((product) =>
  //             product.productName.contains(searchTerm) ||
  //             product.productPrice.toString().contains(searchTerm) ||
  //             product.category.name.contains(searchTerm))
  //         .toList();
  //     setState(() {
  //       productList = filteredProductList!;
  //     });
  //   } else if (searchTerm.isEmpty) {
  //     setState(() {
  //       productList = List.from(productInventoryList);
  //     });
  //   }
  // }

  List<DataColumn> _buildProductColumns() {
    return [
      const DataColumn(label: PrimaryText(text: 'الرقم')),
      const DataColumn(label: PrimaryText(text: ' اسم المريض')),
      const DataColumn(label: PrimaryText(text: ' رقم التواصل')),
      const DataColumn(label: PrimaryText(text: ' جنس المريض')),
      const DataColumn(label: PrimaryText(text: "تاريخ أول حجز")),
      const DataColumn(label: PrimaryText(text: ' العمليات')),
    ];
  }

  DataRow _buildProductRow(Patient patient) {
    print(patient.toString());
    return DataRow(cells: [
      // DataCell(Checkbox(
      //   side: const BorderSide(color: Colors.grey, width: 1),
      //   focusColor: Colors.black45,
      //   value: false,
      //   onChanged: (value) {},
      // )),
      // DataCell(
      //   Image.network(
      //     product.productPhoto,
      //     width: 40,
      //     errorBuilder: (context, err, _) {
      //       return Container(
      //         width: 40,
      //         height: 40,
      //         decoration: const BoxDecoration(
      //           color: Colors.blueGrey,
      //           shape: BoxShape.rectangle,
      //         ),
      //       );
      //     },
      //   ),
      // ),
      DataCell(
        onTap: () {
          ref.watch(pageProvider.notifier).state = PatientProfile(
            patient: patient,
          );
        },
        Padding(
          padding: const EdgeInsets.all(0),
          child: Text(
            patient.id!.toString(),
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.black87.withOpacity(.7)),
          ),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(
            patient.name!,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.black87.withOpacity(.7)),
          ),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(
            patient.name!,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.black87.withOpacity(.7)),
          ),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                patient.gender!,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: Colors.black87.withOpacity(.7)),
              ),
            ],
          ),
        ),
      ),

      DataCell(
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Container(
            height: 35,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.green.withOpacity(.3),
              //  product.status.name == "active"
              //     ? Colors.green.withOpacity(.3)
              //     : Colors.red.withOpacity(.3),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                "firstAppointments",
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: Colors.green),
              ),
            ),
          ),
        ),
      ),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(vertical: defaultSpace + 6),
          child: Center(
            child: Container(
              height: 25,
              width: 25,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: backgroundColor,
              ),
              child: Icon(
                Icons.more_horiz,
                size: 17,
                color: Colors.black.withOpacity(.5),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

const defaultSpace = 16.0;
const Color menuBarColor = Colors.white;
const Color backgroundColor = Color(0xFFf4f5f7);
const Color primaryColor = Color(0xFF0845ff);
const Color defaultIconColor = Color(0xFF83919a);
const List<Color> productStatusColor = [Color(0xFFcdf5d3), Color(0xFFffd2cc)];
const Color iconBackdropColor = Color(0xFFe5e9ec);

class PaginationWidget extends ConsumerWidget {
  final int totalPages;
  final int currentPage;
  final Function(int) onPageSelected;

  PaginationWidget({
    required this.totalPages,
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<int> visiblePages = _getVisiblePages(currentPage, totalPages);
    return Container(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              print("current PAGE");
              print(currentPage);
              _goToPreviousPage(currentPage);
            },
            icon: Icon(Icons.keyboard_arrow_left),
          ),
          for (int page in visiblePages) ...[
            ProductPageLabel(
              pageNo: page,
              isCurrentPage: page == currentPage,
              onPressed: () {
                onPageSelected(page - 1);
              },
            ),
          ],
          IconButton(
            onPressed: () {
              print("current PAGE");
              print(currentPage);
              _goToNextPage(currentPage, totalPages);
            },
            icon: Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
    );
  }

  List<int> _getVisiblePages(int currentPage, int totalPages) {
    const maxVisiblePages = 5; // You can adjust this number
    final List<int> visiblePages = [];
    print(totalPages.toString() + "totalPages");
    print("currentPage" + currentPage.toString());

    if (totalPages <= maxVisiblePages) {
      visiblePages.addAll(List.generate(totalPages, (index) => index + 1));
    } else {
      final int middlePage = currentPage + 1;
      final int leftBound = middlePage - (maxVisiblePages ~/ 2);
      final int rightBound = middlePage + (maxVisiblePages ~/ 2);

      if (leftBound <= 1) {
        visiblePages
            .addAll(List.generate(maxVisiblePages, (index) => index + 1));
      } else if (rightBound >= totalPages) {
        visiblePages.addAll(List.generate(maxVisiblePages,
            (index) => totalPages - maxVisiblePages + index + 1));
      } else {
        visiblePages.addAll(
            List.generate(maxVisiblePages, (index) => leftBound + index));
      }
    }
    print("visiblePage" + visiblePages.toString());
    return visiblePages;
  }

  void _goToPreviousPage(int currentPage) {
    if (currentPage > 1) {
      onPageSelected(currentPage - 1);
    }
  }

  void _goToNextPage(int currentPage, int totalPages) {
    if (currentPage < totalPages - 1) {
      onPageSelected(currentPage + 1);
    }
  }
}

class ProductPageLabel extends StatelessWidget {
  final dynamic pageNo;
  final bool? isCurrentPage;
  final Function() onPressed;

  const ProductPageLabel(
      {Key? key,
      required this.pageNo,
      this.isCurrentPage,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30,
        height: 25,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isCurrentPage ?? false
                ? AppColors.lightGreen
                : Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Center(
              child: Text(
            "$pageNo",
            style: TextStyle(
                color: isCurrentPage ?? false ? Colors.white : Colors.black87),
          )),
        ),
      ),
    );
  }
}

class ButtonWidgetWithIcon extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? borderColor;
  final Color? labelAndIconColor;
  final double? borderRadius;
  final Function() onTap;

  const ButtonWidgetWithIcon(
      {Key? key,
      required this.label,
      this.icon,
      this.borderColor,
      this.labelAndIconColor,
      this.borderRadius,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
              color: borderColor ?? Colors.grey.withOpacity(.4), width: .7),
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(defaultSpace / 2),
                  child: Text(
                    label,
                    style: TextStyle(
                        color:
                            labelAndIconColor ?? Colors.grey.withOpacity(.7)),
                  )),
              Icon(
                icon,
                color: labelAndIconColor ?? Colors.grey.withOpacity(.8),
                size: 19,
              )
            ],
          ),
        ),
      ),
    );
  }
}
