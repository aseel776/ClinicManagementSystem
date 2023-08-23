import 'dart:ui';

import 'package:clinic_management_system/features/repository_feature/data/models/book_in.dart';
import 'package:clinic_management_system/features/repository_feature/presentation/riverpod/book_in_provider.dart';
import 'package:clinic_management_system/features/repository_feature/presentation/riverpod/book_in_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/app_colors.dart';
import '../../../medicine/presentation/widgets/primaryText.dart';
import '../../../patients_management/presentation/pages/patients_index.dart';
import '../../../patients_management/presentation/widgets/textField.dart';
import '../../data/models/product.dart';

StateProvider totalPagesBookIns = StateProvider((ref) => 1);
StateProvider currentPageBookIns = StateProvider((ref) => 1);
StateProvider bookInDate = StateProvider<DateTime>((ref) => DateTime(2000));
StateProvider bookInDateString = StateProvider((ref) => "");
StateProvider priceBookIn = StateProvider((ref) => TextEditingController());
StateProvider qunatityBookIn = StateProvider((ref) => TextEditingController());

class ProductBookIn extends ConsumerStatefulWidget {
  Product product;
  ProductBookIn({super.key, required this.product});

  @override
  ConsumerState<ProductBookIn> createState() => _ProductBookInState();
}

const defaultSpace = 16.0;

class _ProductBookInState extends ConsumerState<ProductBookIn> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .watch(bookInsProvider.notifier)
          .getPaginatedBookIns(6, 1, widget.product.id!);
      final state = ref.watch(bookInsProvider.notifier).state;

      if (state is LoadedBookInsState) {
        ref.watch(totalPagesBookIns.notifier).state = state.totalPages;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookInsProvider.notifier).state;
    ref.watch(currentPageBookIns);
    ref.watch(totalPagesBookIns);
    ref.watch(bookInsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0, right: 20),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PrimaryText(
                  text: "قسم الإدخالات",
                  size: 23,
                  fontWeight: FontWeight.bold,
                ),
                PrimaryText(
                  text: " جميع الإدخالات  ل المنتج ${widget.product.name}",
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
                // top: defaultSpace * 2,
                // left: defaultSpace,
                // right: defaultSpace * 2,
                // bottom: defaultSpace * 0,
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
                                createBookInPopup(context, ref);
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
                                      text: "إدخال كمية ",
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
                  DataTable(
                    columnSpacing: MediaQuery.of(context).size.height * 0.23,
                    headingRowColor:
                        MaterialStatePropertyAll(AppColors.lightGreen),

                    columns: _buildProductColumns(),
                    rows: (state is LoadedBookInsState)
                        ? state.bookIns.map((e) => _buildProductRow(e)).toList()
                        : <DataRow>[], // Pass an empty list as List<DataRow>
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.height * 0.65),
          child: Align(
            alignment: Alignment.center,
            child: PaginationWidget(
                totalPages: ref.watch(totalPagesBookIns.notifier).state,
                currentPage: ref.watch(currentPageBookIns.notifier).state,
                onPageSelected: (i) async {
                  await ref.watch(bookInsProvider.notifier).getPaginatedBookIns(
                      6, (i + 1).toDouble(), widget.product.id!);
                  ref.watch(currentPageBookIns.notifier).state = i + 1;
                }),
          ),
        ),
      ],
    );
  }

  List<DataColumn> _buildProductColumns() {
    return [
      const DataColumn(label: PrimaryText(text: 'الرقم')),
      const DataColumn(label: PrimaryText(text: ' اسم المنتج')),
      const DataColumn(label: PrimaryText(text: ' رقم المنتج')),

      const DataColumn(label: PrimaryText(text: ' السعر')),
      const DataColumn(label: PrimaryText(text: ' الكمية')),
      // const DataColumn(label: PrimaryText(text: "تاريخ انتهاء الصلاحية")),
      // const DataColumn(label: PrimaryText(text: ' الكمية كاملة')),
    ];
  }

  DataRow _buildProductRow(BookIn bookIn) {
    print(bookIn.toString());
    return DataRow(cells: [
      DataCell(
        Padding(
          padding: const EdgeInsets.all(0),
          child: Text(
            bookIn.id.toString(),
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
            bookIn.product.name!,
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
            bookIn.product.id.toString(),
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
            bookIn.price.toString(),
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
                bookIn.quantity.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black87.withOpacity(.7)),
              ),
            ],
          ),
        ),
      ),
      // DataCell(
      //   Padding(
      //     padding: const EdgeInsets.all(0.0),
      //     child: Container(
      //       height: 35,
      //       width: 120,
      //       decoration: BoxDecoration(
      //         shape: BoxShape.rectangle,
      //         color: Colors.green.withOpacity(.3),
      //         borderRadius: BorderRadius.circular(50),
      //       ),
      //       child: Center(
      //         child: Text(
      //           "firstAppointments",
      //           style: Theme.of(context).textTheme.bodyText2?.copyWith(
      //               fontWeight: FontWeight.w800,
      //               fontSize: 12,
      //               color: Colors.green),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // DataCell(
      //   Container(
      //     padding: const EdgeInsets.symmetric(vertical: defaultSpace + 6),
      //     child: Center(
      //       child: Container(
      //         height: 25,
      //         width: 25,
      //         decoration: const BoxDecoration(
      //           shape: BoxShape.rectangle,
      //           color: backgroundColor,
      //         ),
      //         child: Icon(
      //           Icons.more_horiz,
      //           size: 17,
      //           color: Colors.black.withOpacity(.5),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    ]);
  }

  Future<dynamic> createBookInPopup(BuildContext context, WidgetRef ref) async {
    // final badHabits = await ref
    //     .watch(badHabitsProvider.notifier)
    //     .getPaginatedBadHabits(10, 1);
    // final state = ref.watch(badHabitsProvider.notifier).state;
    // print(state);

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
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: PrimaryText(
                            text: "إضافة إدخال جديد",
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                                        text: "تاريخ انتهاء الصلاحية",
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
                                          datePick != ref.watch(bookInDate)) {
                                        ref.read(bookInDate.notifier).state =
                                            datePick;

                                        ref
                                                .read(bookInDateString.notifier)
                                                .state =
                                            DateFormat("yyyy-MM-dd").format(ref
                                                .watch(bookInDate.notifier)
                                                .state!);
                                      }
                                    }),
                                const SizedBox(
                                  width: 10,
                                ),
                                ref.watch(bookInDateString) == null
                                    ? const Text("DD/MM/YYYY")
                                    : Text("${ref.watch(bookInDateString)}")
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: textfield("السعر",
                              ref.watch(priceBookIn.notifier).state, "", 1),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: textfield("الكمية",
                              ref.watch(qunatityBookIn.notifier).state, "", 1),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.08,
                          child: ElevatedButton(
                              onPressed: () async {
                                await ref
                                    .watch(bookInsProvider.notifier)
                                    .createBookIn(
                                        ref
                                            .watch(bookInDateString.notifier)
                                            .state,
                                        int.parse(
                                          ref
                                              .watch(priceBookIn.notifier)
                                              .state
                                              .text,
                                        ),
                                        int.parse(
                                          ref
                                              .watch(qunatityBookIn.notifier)
                                              .state
                                              .text,
                                        ),
                                        widget.product.id!)
                                    .then((value) {
                                  ref
                                      .watch(bookInsProvider.notifier)
                                      .getPaginatedBookIns(
                                          6, 1, widget.product.id!);
                                  ref.read(currentPageBookIns.notifier).state =
                                      1;
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
