import 'dart:ui';

import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/core/primaryText.dart';
import 'package:clinic_management_system/core/textField.dart';

import 'package:clinic_management_system/features/repository_feature/data/models/product.dart';
import 'package:clinic_management_system/features/repository_feature/data/models/stored_product.dart';
import 'package:clinic_management_system/features/repository_feature/presentation/pages/products_book_in.dart';
import 'package:clinic_management_system/features/repository_feature/presentation/pages/products_book_out.dart';
import 'package:clinic_management_system/features/repository_feature/presentation/riverpod/products_crud_provider.dart';
import 'package:clinic_management_system/features/repository_feature/presentation/riverpod/products_provider.dart';
import 'package:clinic_management_system/features/repository_feature/presentation/riverpod/products_state.dart';
import 'package:clinic_management_system/features/sidebar/presentation/pages/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../diseases_badHabits_teeth/presentation/widgets/delete_snack_bar.dart';

StateProvider showAllProducts = StateProvider((ref) => true);
StateProvider showStoredProducts = StateProvider((ref) => false);
StateProvider totalPagesProducts = StateProvider((ref) => 1);
StateProvider currentPageProducts = StateProvider((ref) => 1);
StateProvider productName = StateProvider((ref) => TextEditingController());

class RepositoryScreen extends ConsumerStatefulWidget {
  const RepositoryScreen({super.key});

  @override
  ConsumerState<RepositoryScreen> createState() => _RepositoryScreenState();
}

class _RepositoryScreenState extends ConsumerState<RepositoryScreen> {
  ScrollController? controller;
  PageController? pageController;
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    pageController = PageController(initialPage: 1);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(productsProvider.notifier).getPaginatedProducts(6, 1);
      final state = ref.watch(productsProvider.notifier).state;
      if (state is LoadedProductsState) {
        ref.watch(totalPagesProducts.notifier).state = state.totalPages;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(showAllProducts);
    ref.watch(showStoredProducts);
    ref.watch(totalPagesProducts);
    ref.watch(currentPageProducts);
    ref.watch(productsProvider);
    final state = ref.watch(productsProvider.notifier).state;
    double sectionWidth = MediaQuery.of(context).size.width;
    double sectionHeight = MediaQuery.of(context).size.height;
    return CustomScrollView(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: sectionHeight * 0.2,
          backgroundColor: Colors.transparent,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 0.0, right: 15),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(30),
                            right: Radius.circular(20))),
                    width: sectionWidth * 0.37,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: PrimaryText(
                                  text: "مستودع العيادة",
                                  size: 25,
                                  fontWeight: FontWeight.w800),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 18.0, top: 10),
                              child: Image.asset(
                                "assets/images/repository_icon.png",
                                width: 40,
                                height: 40,
                              ),

                              //  Icon(
                              //   Icons.grid_3x3,
                              //   color: Colors.redAccent,
                              // ),
                            )
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 18.0),
                          child: Text(
                            "-----------------------",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: sectionWidth * 0.1, top: sectionHeight * 0.01),
                  child: SvgPicture.asset(
                    'assets/svgs/repository_section.svg',

                    // color:
                    //     AppColors.lightGreen, // Replace with your desired color
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: sectionHeight * 0.2),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: ref.watch(showAllProducts.notifier).state,
                            onChanged: (value) {
                              // Update the state when checkbox value changes
                              // You can use a state management solution for this
                              // For example: ref.read(yourProvider).updateShowKind1(value);
                            },
                          ),
                          const Text('Show Kind 1 Products'),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: ref.watch(showStoredProducts.notifier).state,
                            onChanged: (value) {
                              // Update the state when checkbox value changes
                              // You can use a state management solution for this
                              // For example: ref.read(yourProvider).updateShowKind2(value);
                            },
                          ),
                          const Text('Show Kind 2 Products'),
                        ],
                      ),
                      Expanded(
                        child: PageView.builder(
                          // Your PageView.builder parameters
                          itemBuilder: (context, pageIndex) {
                            // Filter the list of products based on the checkboxes
                            // List<Product> filteredProducts = [];

                            // if (showKind1Products) {
                            //   // Add Kind 1 products to filteredProducts
                            // }

                            // if (showKind2Products) {
                            //   // Add Kind 2 products to filteredProducts
                            // }

                            // return GridView.builder(
                            //   // Your GridView.builder parameters
                            //   itemCount: filteredProducts.length,
                            //   itemBuilder: (context, index) {
                            //     final product = filteredProducts[index];
                            //     return _renderContent(context, product);
                            //   },
                            // );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
                top: sectionHeight * 0.02, right: sectionWidth * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: sectionHeight * 0.1,
                    width: sectionWidth * 0.19,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    // color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: ref.watch(showAllProducts.notifier).state,
                              onChanged: (value) async {
                                ref.read(showAllProducts.notifier).state =
                                    value;
                                ref.read(showStoredProducts.notifier).state =
                                    !value!;
                                ref.read(currentPageProducts.notifier).state =
                                    1;
                                if (ref.watch(showAllProducts.notifier).state) {
                                  await ref
                                      .watch(productsProvider.notifier)
                                      .getPaginatedProducts(6, 1);
                                }
                                if (ref
                                    .watch(showStoredProducts.notifier)
                                    .state) {
                                  await ref
                                      .watch(productsProvider.notifier)
                                      .getPaginatedStoredProducts(6, 1);
                                }
                                // Update the state when checkbox value changes
                                // You can use a state management solution for this
                                // For example: ref.read(yourProvider).updateShowKind1(value);
                              },
                              activeColor: Colors
                                  .blue, // Change the checkbox color when selected
                              side: const BorderSide(
                                  color: Colors
                                      .blue), // Add a border around the checkbox
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4)), // Apply rounded corners to the checkbox
                            ),
                            const PrimaryText(
                              text: 'إظهار جميع العناصر',
                              size: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value:
                                  ref.watch(showStoredProducts.notifier).state,
                              onChanged: (value) async {
                                ref.read(showStoredProducts.notifier).state =
                                    value;
                                ref.read(showAllProducts.notifier).state =
                                    !value!;
                                ref.read(currentPageProducts.notifier).state =
                                    1;
                                if (ref.watch(showAllProducts.notifier).state) {
                                  await ref
                                      .watch(productsProvider.notifier)
                                      .getPaginatedProducts(6, 1);
                                }
                                if (ref
                                    .watch(showStoredProducts.notifier)
                                    .state) {
                                  await ref
                                      .watch(productsProvider.notifier)
                                      .getPaginatedStoredProducts(6, 1);
                                }
                              },
                              activeColor: Colors
                                  .green, // Change the checkbox color when selected
                              side: const BorderSide(
                                  color: Colors
                                      .green), // Add a border around the checkbox
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4)), // Apply rounded corners to the checkbox
                            ),
                            const PrimaryText(
                              text: 'إظهار جميع العناصر المخزنة',
                              size: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                (ref.watch(showAllProducts.notifier).state)
                    ? Padding(
                        padding: EdgeInsets.only(
                            left: sectionWidth * 0.05, bottom: 3),
                        child: SizedBox(
                          height: sectionHeight * .08,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(AppColors.black),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                ref.watch(productName.notifier).state.text = "";
                                add_edit_product_popup(
                                    context, ref, true, null);
                              },
                              child:
                                  const PrimaryText(text: "إضافة منتج جديد")),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          child: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: (state is LoadingProductsState)
                      ? LoadingAnimationWidget.inkDrop(
                          color: AppColors.black, size: 25)
                      : (state is ErrorProductsState)
                          ? Center(
                              child: PrimaryText(
                                text: state.message,
                              ),
                            )
                          : (state is LoadedProductsState ||
                                  state is LoadedStoredProductsState)
                              ? PageView.builder(
                                  controller: pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: ref
                                      .watch(totalPagesProducts.notifier)
                                      .state,
                                  itemBuilder: (context, pageIndex) {
                                    var products = [];
                                    if (ref
                                        .watch(showAllProducts.notifier)
                                        .state) {
                                      if (state is LoadedProductsState) {
                                        products = state.products;
                                      }
                                    }
                                    if (ref
                                        .watch(showStoredProducts.notifier)
                                        .state) {
                                      if (state is LoadedStoredProductsState) {
                                        products = state.storedProducts;
                                      }
                                    }
                                    if (products.isEmpty) {
                                      return Container();
                                    }
                                    return GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 16 / 9,
                                      ),
                                      itemCount: products.length,
                                      itemBuilder: (context, index) {
                                        final productIndex = products[index];
                                        if (productIndex is Product) {
                                          return _renderProducts(productIndex);
                                        } else if (productIndex
                                            is StoredProduct) {
                                          return _renderStoredProducts(
                                              productIndex);
                                        } else {
                                          return Container();
                                        }
                                      },
                                    );
                                  },
                                )
                              : Container()),
              Align(
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  backgroundColor: AppColors.black,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    onPressed: () {
                      _goToPreviousPage(
                          ref.watch(currentPageProducts.notifier).state);
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  backgroundColor: AppColors.black,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    onPressed: () {
                      _goToNextPage(
                          ref.watch(currentPageProducts.notifier).state,
                          ref.watch(totalPagesProducts.notifier).state);
                    },
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Future<dynamic> add_edit_product_popup(BuildContext context, WidgetRef ref,
      bool addOrEdit, int? productIndex) async {
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
                            text:
                                addOrEdit ? "إضافة منتج جديد " : "تعديل منتج ",
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: screenWidth * 0.2,
                          child: textfield("اسم المنتج",
                              ref.watch(productName.notifier).state, "", 1),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        SizedBox(
                          width: screenWidth * 0.08,
                          child: ElevatedButton(
                              onPressed: () async {
                                // ref.watch(productsProvider.notifier)
                                if (addOrEdit) {
                                  Product product = Product(
                                      name: ref
                                          .watch(productName.notifier)
                                          .state
                                          .text);
                                  await ref
                                      .watch(productsCrudProvider.notifier)
                                      .addNewProduct(product)
                                      .then((value) {
                                    ref
                                        .watch(productsProvider.notifier)
                                        .getPaginatedProducts(6, 1);
                                  });
                                  ref
                                      .watch(currentPageProducts.notifier)
                                      .state = 1;

                                  Navigator.pop(context);
                                } else {
                                  Product product = Product(
                                      id: productIndex,
                                      name: ref
                                          .watch(productName.notifier)
                                          .state
                                          .text);
                                  await ref
                                      .watch(productsCrudProvider.notifier)
                                      .editProduct(product)
                                      .then((value) => ref
                                          .watch(productsProvider.notifier)
                                          .getPaginatedProducts(6, 1));
                                  ref
                                      .watch(currentPageProducts.notifier)
                                      .state = 1;
                                  Navigator.pop(context);
                                }
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
                                text: addOrEdit ? "إضافة" : "تعديل",
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

  _goToPreviousPage(int currentPage) async {
    if (currentPage > 1) {
      await pageController!.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      if (ref.watch(showAllProducts.notifier).state) {
        await ref
            .watch(productsProvider.notifier)
            .getPaginatedProducts(6, currentPage - 1);
      } else if (ref.watch(showStoredProducts.notifier).state) {
        await ref
            .watch(productsProvider.notifier)
            .getPaginatedStoredProducts(6, currentPage - 1);
      }

      ref.watch(currentPageProducts.notifier).state = currentPage - 1;
    }
  }

  _goToNextPage(int currentPage, int totalPages) async {
    print(currentPage);
    print(totalPages);
    if (currentPage < totalPages) {
      await pageController!.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      print("next PAGE");
      if (ref.watch(showAllProducts.notifier).state) {
        await ref
            .watch(productsProvider.notifier)
            .getPaginatedProducts(6, currentPage + 1);
      } else if (ref.watch(showStoredProducts.notifier).state) {
        await ref
            .watch(productsProvider.notifier)
            .getPaginatedStoredProducts(6, currentPage + 1);
      }

      ref.watch(currentPageProducts.notifier).state = currentPage + 1;
    }
  }

  Padding _renderProducts(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: 100,
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              AppColors.lightGreen,
              AppColors.lightGreen.withOpacity(.2),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.black.withOpacity(0.3)),
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(DeleteSnackBar(() async {
                            await ref
                                .watch(productsCrudProvider.notifier)
                                .deleteProduct(product)
                                .then((value) {
                              ref
                                  .watch(productsProvider.notifier)
                                  .getPaginatedProducts(6, 1);
                              ref.watch(currentPageProducts.notifier).state = 1;
                            });
                          }));
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 16,
                        ),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.black.withOpacity(0.3)),
                      child: TextButton(
                          onPressed: () {
                            ref.watch(productName.notifier).state.text =
                                product.name;
                            add_edit_product_popup(
                                context, ref, false, product.id);
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          )))
                ],
              ),
            ),
            Consumer(
              builder: (context, ref, child) => Container(
                alignment: Alignment.center,
                child: PrimaryText(
                  text: product.name,
                  size: 22,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.black.withOpacity(0.8),
                      child: IconButton(
                        onPressed: () {
                          ref.watch(pageProvider.notifier).state =
                              ProductBookIn(product: product);
                        },
                        icon: const Icon(Icons.add),
                        color: Colors.white,
                      )),
                  // Spacer(),/
                  CircleAvatar(
                      backgroundColor: AppColors.black.withOpacity(0.8),
                      child: GestureDetector(
                        onTap: () {
                          ref.watch(pageProvider.notifier).state =
                              ProductsBookOut(product: product);
                        },
                        child: const PrimaryText(
                          text: "-",
                          size: 30,
                          height: 1.4,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _renderStoredProducts(StoredProduct product) {
    print(product.toString());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: 100,
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              AppColors.lightGreen,
              AppColors.lightGreen.withOpacity(.2),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Consumer(
          builder: (context, ref, child) => Container(
            alignment: Alignment.center,
            child: PrimaryText(
              text: product.name,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
