import 'dart:ui';

import 'package:clinic_management_system/features/lab_feature/presentation/pages/lab_order_screen.dart';
import 'package:clinic_management_system/features/lab_feature/presentation/rievrpod/lab_provider.dart';
import 'package:clinic_management_system/features/lab_feature/presentation/rievrpod/lab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/primaryText.dart';
import '../../../../core/textField.dart';
import '../../../../sidebar/presentation/pages/sidebar.dart';
import '../../../diseases_badHabits/presentation/widgets/delete_snack_bar.dart';
import '../../../repository_feature/presentation/riverpod/products_state.dart';
import '../../data/models/lab_model.dart';
import '../rievrpod/lab_crud_provider.dart';

StateProvider totalPagesLabs = StateProvider((ref) => 1);
StateProvider currentPageLabs = StateProvider((ref) => 1);
StateProvider labsName = StateProvider((ref) => TextEditingController());
StateProvider labsAddress = StateProvider((ref) => TextEditingController());
StateProvider labsEmail = StateProvider((ref) => TextEditingController());
StateProvider labsPhone = StateProvider((ref) => TextEditingController());

class LabsScreen extends ConsumerStatefulWidget {
  const LabsScreen({super.key});

  @override
  ConsumerState<LabsScreen> createState() => _LabsScreenState();
}

class _LabsScreenState extends ConsumerState<LabsScreen> {
  ScrollController? controller;
  PageController? pageController;
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    pageController = PageController(initialPage: 1);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(labsProvider.notifier).getPaginatedLabs(6, 1);
      final state = ref.watch(labsProvider.notifier).state;
      if (state is LoadedLabsState) {
        ref.watch(totalPagesLabs.notifier).state = state.totalPages;
        print("total");
        print(state.totalPages);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(currentPageLabs);
    ref.watch(totalPagesLabs);
    final state = ref.watch(labsProvider);
    ref.watch(labsProvider);
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
                                  text: "قسم المخابر",
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
                Padding(
                  padding:
                      EdgeInsets.only(left: sectionWidth * 0.05, bottom: 3),
                  child: SizedBox(
                    height: sectionHeight * .08,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.black),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          ref.watch(labsName.notifier).state.text = "";
                          ref.watch(labsAddress.notifier).state.text = "";

                          ref.watch(labsPhone.notifier).state.text = "";
                          ref.watch(labsEmail.notifier).state.text = "";

                          add_edit_product_popup(context, ref, true, null);
                        },
                        child: const PrimaryText(text: "إضافة مخبر")),
                  ),
                )
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          child: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: (state is LoadingLabsState)
                      ? LoadingAnimationWidget.inkDrop(
                          color: AppColors.black, size: 25)
                      : (state is ErrorLabsState)
                          ? Center(
                              child: PrimaryText(
                                text: state.message,
                              ),
                            )
                          : (state is LoadedLabsState)
                              ? PageView.builder(
                                  controller: pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      ref.watch(totalPagesLabs.notifier).state,
                                  itemBuilder: (context, pageIndex) {
                                    var products = state.labs;

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

                                        return _renderProducts(productIndex);
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
                          ref.watch(currentPageLabs.notifier).state);
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
                      _goToNextPage(ref.watch(currentPageLabs.notifier).state,
                          ref.watch(totalPagesLabs.notifier).state);
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

  Future<dynamic> add_edit_product_popup(
      BuildContext context, WidgetRef ref, bool addOrEdit, int? id) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final _formKey = GlobalKey<FormState>();

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
                    height: screenHeight * 0.7,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PrimaryText(
                              text: addOrEdit
                                  ? "إضافة منتج جديد "
                                  : "تعديل منتج ",
                              size: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: screenWidth * 0.2,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: textfield(
                                  "اسم المخبر",
                                  ref.watch(labsName.notifier).state,
                                  "قم بإضافة اسم ",
                                  1),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          SizedBox(
                            width: screenWidth * 0.2,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: textfield(
                                  "عنوان المخبر ",
                                  ref.watch(labsAddress.notifier).state,
                                  "ادخل عنوان المخبر",
                                  1),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          SizedBox(
                            width: screenWidth * 0.2,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: textfield(
                                  "رقم المخبر ",
                                  ref.watch(labsPhone.notifier).state,
                                  "ادخل رقم المخبر",
                                  1),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          SizedBox(
                            width: screenWidth * 0.2,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: textfield("ايميل المخبر",
                                  ref.watch(labsEmail.notifier).state, "", 1),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          SizedBox(
                            width: screenWidth * 0.08,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // Validation passed, perform your submit logic here
                                    // ref.watch(labsProvider.notifier);
                                    if (addOrEdit) {
                                      Lab lab = Lab(
                                          name: ref
                                              .watch(labsName.notifier)
                                              .state
                                              .text,
                                          address: ref
                                              .watch(labsAddress.notifier)
                                              .state
                                              .text,
                                          phone: ref
                                              .watch(labsPhone.notifier)
                                              .state
                                              .text,
                                          email: ref
                                              .watch(labsEmail.notifier)
                                              .state
                                              .text);
                                      await ref
                                          .watch(labCrudProvider.notifier)
                                          .addLab(lab)
                                          .then((value) {
                                        ref
                                            .watch(labsProvider.notifier)
                                            .getPaginatedLabs(6, 1);
                                      });
                                      ref
                                          .watch(currentPageLabs.notifier)
                                          .state = 1;

                                      Navigator.pop(context);
                                    } else {
                                      Lab lab = Lab(
                                          id: id,
                                          name: ref
                                              .watch(labsName.notifier)
                                              .state
                                              .text,
                                          address: ref
                                              .watch(labsAddress.notifier)
                                              .state
                                              .text,
                                          phone: ref
                                              .watch(labsPhone.notifier)
                                              .state
                                              .text,
                                          email: ref
                                              .watch(labsEmail.notifier)
                                              .state
                                              .text);
                                      await ref
                                          .watch(labCrudProvider.notifier)
                                          .editLab(lab)
                                          .then((value) {
                                        ref
                                            .watch(labsProvider.notifier)
                                            .getPaginatedLabs(6, 1);
                                      });
                                      ref
                                          .watch(currentPageLabs.notifier)
                                          .state = 1;

                                      Navigator.pop(context);
                                    }
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
      await ref
          .watch(labsProvider.notifier)
          .getPaginatedLabs(6, currentPage - 1);

      ref.watch(currentPageLabs.notifier).state = currentPage - 1;
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

      await ref
          .watch(labsProvider.notifier)
          .getPaginatedLabs(6, currentPage + 1);
      ref.watch(currentPageLabs.notifier).state = currentPage + 1;
    }
  }

  GestureDetector _renderProducts(Lab lab) {
    return GestureDetector(
      onTap: () {
        ref.watch(pageProvider.notifier).state = LabOrderScreen(lab: lab);
      },
      child: Padding(
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
                                  .watch(labCrudProvider.notifier)
                                  .deleteLab(lab)
                                  .then((value) {
                                ref
                                    .watch(labsProvider.notifier)
                                    .getPaginatedLabs(6, 1);
                                ref.watch(currentPageLabs.notifier).state = 1;
                              });
                            }));
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 16,
                          ),
                        )),
                    const SizedBox(
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
                              ref.watch(labsName.notifier).state.text =
                                  lab.name;
                              ref.watch(labsAddress.notifier).state.text =
                                  lab.address;
                              ref.watch(labsPhone.notifier).state.text =
                                  lab.phone;
                              ref.watch(labsEmail.notifier).state.text =
                                  lab.email;

                              add_edit_product_popup(
                                  context, ref, false, lab.id);
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
                    text: lab.name,
                    size: 22,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
