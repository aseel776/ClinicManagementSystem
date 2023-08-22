import 'dart:ui';

import 'package:clinic_management_system/features/patients_management/presentation/widgets/textField.dart';
import 'package:clinic_management_system/features/repository_feature/data/models/book_out.dart';
import 'package:clinic_management_system/features/repository_feature/presentation/riverpod/book_out_provider.dart';
import 'package:clinic_management_system/features/repository_feature/presentation/riverpod/book_out_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/app_colors.dart';
import '../../../medicine/presentation/widgets/primaryText.dart';
import '../../../patients_management/presentation/pages/patients_index.dart';
import '../../data/models/product.dart';
import '../../data/models/select_stored_product.dart';

StateProvider totalPagesStoredProduct = StateProvider((ref) => 1);
StateProvider currentPageStoredProduct = StateProvider((ref) => 1);
StateProvider selectedRows = StateProvider<List<int>>((ref) => []);
StateProvider quantityController =
    StateProvider((ref) => TextEditingController());

class ProductsBookOut extends ConsumerStatefulWidget {
  Product product;
  ProductsBookOut({super.key, required this.product});

  @override
  ConsumerState<ProductsBookOut> createState() => _ProductsBookOutState();
}

const defaultSpace = 16.0;

class _ProductsBookOutState extends ConsumerState<ProductsBookOut> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .watch(bookoutProvider.notifier)
          .getStoredProduct(6, 1, widget.product.id!);
      final state = ref.watch(bookoutProvider.notifier).state;
      if (state is LoadedSelectStoredProductState) {
        print("successsss");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookoutProvider.notifier).state;
    ref.watch(currentPageStoredProduct);
    ref.watch(totalPagesStoredProduct);
    ref.watch(bookoutProvider);
    ref.watch(selectedRows);
    List<int> list = ref.watch(selectedRows.notifier).state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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
                  text: "قسم المنتجات المتوفرة",
                  size: 23,
                  fontWeight: FontWeight.bold,
                ),
                PrimaryText(
                  text: " المتوفر في المستودع  ل المنتج ${widget.product.name}",
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
              top: defaultSpace * 1,
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
                        const SizedBox(
                          width: defaultSpace / 2,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (ref
                                        .watch(selectedRows.notifier)
                                        .state
                                        .length ==
                                    0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "يجب عليك تحديد عناصر أولا")));
                                } else {
                                  createBookOut(context, ref);
                                }
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
                                      text: "إخراج كمية  ",
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
                    columnSpacing: 70,

                    columns: _buildProductColumns(),
                    rows: (state is LoadedSelectStoredProductState)
                        ? state.storedProducts
                            .map(
                                (e) => _buildProductRow(e, list.contains(e.id)))
                            .toList()
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
                totalPages: ref.watch(totalPagesStoredProduct.notifier).state,
                currentPage: ref.watch(currentPageStoredProduct.notifier).state,
                onPageSelected: (i) async {
                  await ref.watch(bookoutProvider.notifier).getStoredProduct(
                      6, (i + 1).toDouble(), widget.product.id!);
                  ref.watch(currentPagePatientsTable.notifier).state = i + 1;
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
      const DataColumn(label: PrimaryText(text: ' السعر')),
      const DataColumn(label: PrimaryText(text: ' الكمية')),
      const DataColumn(label: PrimaryText(text: "تاريخ انتهاء الصلاحية")),
      const DataColumn(label: PrimaryText(text: ' الكمية كاملة')),
      // const DataColumn(label: PrimaryText(text: ' العمليات')),
    ];
  }

  DataRow _buildProductRow(SelectStoredProduct storedProducts, bool selected) {
    List<int> list = ref.watch(selectedRows.notifier).state;
    ref.watch(selectedRows);
    print(storedProducts.toString());
    return DataRow(
        selected: list.contains(storedProducts.id),
        onSelectChanged: (i) {
          setState(() {
            if (i!) {
              List<int> list = ref.watch(selectedRows.notifier).state;

              list.add(storedProducts.id);
              print(list);
              ref.read(selectedRows.notifier).state = list;
            } else {
              List<int> list = ref.watch(selectedRows.notifier).state;
              list.remove(storedProducts.id);
              ref.read(selectedRows.notifier).state = list;
            }
          });
          print(i);
        },
        cells: [
          DataCell(
            Padding(
              padding: const EdgeInsets.all(0),
              child: Text(
                storedProducts.id.toString(),
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
                storedProducts.product.name!,
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
                storedProducts.price.toString(),
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
                    storedProducts.quantity.toString(),
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
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    storedProducts.expirationDate.toString(),
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    storedProducts.totalQuantity.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(color: Colors.black87.withOpacity(.7)),
                  ),
                ],
              ),
            ),
          ),
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

  Future<dynamic> createBookOut(
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
                    height: screenHeight * 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PrimaryText(
                            text: "إخراج كمية",
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: screenWidth * 0.2,
                          child: textfield(
                              "الكمية المطلوبة",
                              ref.watch(quantityController.notifier).state,
                              "",
                              1),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        SizedBox(
                          width: screenWidth * 0.08,
                          child: ElevatedButton(
                              onPressed: () async {
                                ref
                                    .watch(bookoutProvider.notifier)
                                    .createBookOut(
                                        widget.product.id!,
                                        int.parse(
                                          ref
                                              .watch(
                                                  quantityController.notifier)
                                              .state
                                              .text,
                                        ),
                                        ref.watch(selectedRows.notifier).state)
                                    .then((value) {
                                  ref
                                      .watch(bookoutProvider.notifier)
                                      .getStoredProduct(
                                          6, 1, widget.product.id!);
                                  ref
                                      .read(currentPageStoredProduct.notifier)
                                      .state = 1;
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
                              child: PrimaryText(
                                text: "إخراج",
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
