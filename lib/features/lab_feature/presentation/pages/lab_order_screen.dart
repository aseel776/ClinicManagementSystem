import 'dart:ui';

import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/core/pagination_widget.dart';
import 'package:clinic_management_system/core/primaryText.dart';
import 'package:clinic_management_system/features/lab_feature/data/models/lab_model.dart';
import 'package:clinic_management_system/features/lab_feature/data/models/lab_order.dart';
import 'package:clinic_management_system/features/lab_feature/presentation/rievrpod/lab_order_crud_provider.dart';
import 'package:clinic_management_system/features/lab_feature/presentation/rievrpod/lab_order_provider.dart';
import 'package:clinic_management_system/features/lab_feature/presentation/rievrpod/lab_order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/textField.dart';
import '../widgets/lab_order_steps_collapse.dart';
import '../widgets/step_input_fields.dart';

StateProvider totalPagesLabOrders = StateProvider((ref) => 1);
StateProvider currentPageLabOrders = StateProvider((ref) => 1);
StateProvider nameLabOrder = StateProvider((ref) => TextEditingController());
StateProvider priceLabOrder = StateProvider((ref) => TextEditingController());

class LabOrderScreen extends ConsumerStatefulWidget {
  Lab lab;

  LabOrderScreen({super.key, required this.lab});

  @override
  ConsumerState<LabOrderScreen> createState() => _LabOrderScreenState();
}

class _LabOrderScreenState extends ConsumerState<LabOrderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .watch(labOrdersProvider.notifier)
          .getPaginatedLabOrders(widget.lab.id!, 5, 1);
      final state = ref.watch(labOrdersProvider.notifier).state;
      if (state is LoadedLabOrdersState) {
        ref.watch(totalPagesLabOrders.notifier).state = state.totalPages;
      }
    });
  }

  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    ref.watch(currentPageLabOrders);
    ref.watch(totalPagesLabOrders);
    final state = ref.watch(labOrdersProvider);
    ref.watch(labOrdersProvider);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30.0, right: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: "قسم الخدمات",
                      size: 23,
                      fontWeight: FontWeight.bold,
                    ),
                    PrimaryText(
                      text: "التي يقدمها المخبر ${1}",
                      size: 14,
                      fontWeight: FontWeight.w200,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.54,
                  bottom: 3,
                  top: 30),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .07,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      addEditOrderPopup(context, ref, true, null);
                    },
                    child: const PrimaryText(text: " إضافة خدمة")),
              ),
            )
          ],
        ),
        const SizedBox(height: 30),
        Column(
          children: [
            if (state is LoadedLabOrdersState)
              Container(
                clipBehavior: Clip.hardEdge,
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.07),
                decoration: BoxDecoration(
                    // color: Colors.amber,
                    borderRadius: BorderRadius.circular(15)),
                child: ExpansionPanelList(
                  expandedHeaderPadding: const EdgeInsets.all(0),
                  elevation: 2,
                  dividerColor: Colors.white,
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _expandedIndex = isExpanded ? -1 : index;
                    });
                  },
                  children: state.labOrders.asMap().entries.map((entry) {
                    final index = entry.key;
                    final labOrder1 = entry.value;
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(labOrder1.name),
                          subtitle: Text("السعر ${labOrder1.price}"),
                          trailing: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.1),
                            child: TextButton(
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.white)),
                              onPressed: () {
                                ref.watch(nameLabOrder.notifier).state.text =
                                    labOrder1.name;
                                ref.watch(priceLabOrder.notifier).state.text =
                                    labOrder1.price.toString();
                                for (var entry
                                    in labOrder1.steps!.asMap().entries) {
                                  var index = entry.key;
                                  var step = entry.value;

                                  ref.watch(stepControllers).add(
                                      TextEditingController(text: step.name));

                                  ref
                                      .watch(stepControllers.notifier)
                                      .state[index]
                                      .text = step.name;
                                }

                                // ref.watch(stepControllers.notifier).state
                                addEditOrderPopup(
                                    context, ref, false, labOrder1.id);
                              },
                              child: const Icon(
                                Icons.edit,
                                color: AppColors.lightGreen,
                              ),
                            ),
                          ),
                        );
                      },
                      body: Row(
                        children: [
                          Expanded(
                            child: LabOrderStepsPanel(
                              steps:
                                  labOrder1.steps!.map((e) => e.name).toList(),
                            ),
                          ),
                        ],
                      ),
                      isExpanded: _expandedIndex == index,
                    );
                  }).toList(),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.35),
              child: PaginationWidget(
                  totalPages: ref.watch(totalPagesLabOrders.notifier).state,
                  currentPage: ref.watch(currentPageLabOrders.notifier).state,
                  onPageSelected: (i) async {
                    await ref
                        .watch(labOrdersProvider.notifier)
                        .getPaginatedLabOrders(
                            widget.lab.id!, 1, (i + 1).toDouble());
                    ref.watch(currentPageLabOrders.notifier).state = i + 1;
                  }),
            )
            // ... (other states)
          ],
        ),
      ],
    );
  }

  Future<dynamic> addEditOrderPopup(
      BuildContext context, WidgetRef ref, bool addOrEdit, int? orderID) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final _formKey = GlobalKey<FormState>();
    ref.watch(stepControllers);

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
                                  ? "إضافة خدمة جديدة"
                                  : "تعديل خدمة ",
                              size: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: screenWidth * 0.2,
                            child: textfield(
                                "اسم الخدمة",
                                ref.watch(nameLabOrder.notifier).state,
                                "قم بإضافة اسم",
                                1),
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          SizedBox(
                            width: screenWidth * 0.2,
                            child: textfield(
                                "سعر الخدمة",
                                ref.watch(priceLabOrder.notifier).state,
                                "ادخل سعر الخدمة",
                                1),
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          StepInputScreen(),
                          SizedBox(
                            height: screenHeight * 0.1,
                          ),
                          SizedBox(
                            width: screenWidth * 0.08,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (addOrEdit) {
                                      LabOrder labOrder = LabOrder(
                                        labId: widget.lab.id!,
                                        name: ref
                                            .watch(nameLabOrder.notifier)
                                            .state
                                            .text,
                                        price: int.tryParse(ref
                                            .watch(priceLabOrder.notifier)
                                            .state
                                            .text),
                                      );
                                      List<String> steps = ref
                                          .watch(stepControllers.notifier)
                                          .state
                                          .map((e) => e.text)
                                          .toList();
                                      await ref
                                          .watch(labOrderCrudProvider.notifier)
                                          .addLabOrder(labOrder, steps)
                                          .then((value) {
                                        ref
                                            .watch(labOrdersProvider.notifier)
                                            .getPaginatedLabOrders(
                                                widget.lab.id!, 5, 1);
                                        ref
                                            .read(currentPageLabOrders.notifier)
                                            .state = 1;
                                      });
                                      Navigator.of(context).pop();
                                    } else {
                                      LabOrder labOrder = LabOrder(
                                          id: orderID,
                                          labId: widget.lab.id!,
                                          name: ref
                                              .watch(nameLabOrder.notifier)
                                              .state
                                              .text,
                                          price: int.tryParse(ref
                                              .watch(priceLabOrder.notifier)
                                              .state
                                              .text));
                                      List<String> steps = ref
                                          .watch(stepControllers.notifier)
                                          .state
                                          .map((e) => e.text)
                                          .toList();

                                      await ref
                                          .watch(labOrderCrudProvider.notifier)
                                          .editLabOrder(labOrder, steps)
                                          .then((value) {
                                        ref
                                            .watch(labOrdersProvider.notifier)
                                            .getPaginatedLabOrders(
                                                widget.lab.id!, 5, 1);
                                        ref
                                            .read(currentPageLabOrders.notifier)
                                            .state = 1;
                                      });
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
}
