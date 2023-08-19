import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/customs.dart';
import './/core/app_colors.dart';
import '../widgets/type_tile.dart';
import '../states/control_states.dart';
import '../states/treatments_types/treatment_types_state.dart';
import '../states/treatments_types/treatment_types_provider.dart';

class TreatmentTypesSection extends ConsumerStatefulWidget {
  final double sectionHeight;
  final double sectionWidth;

  const TreatmentTypesSection(
      {Key? key, required this.sectionHeight, required this.sectionWidth})
      : super(key: key);

  @override
  ConsumerState<TreatmentTypesSection> createState() => _TreatmentTypesSectionState();
}

class _TreatmentTypesSectionState extends ConsumerState<TreatmentTypesSection> {
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await ref.read(treatmentsTypesProvider.notifier).getAllTreatmentsTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentsTypesProvider);
    return Expanded(
      child: Container(
        height: widget.sectionHeight,
        width: widget.sectionWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          // color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: widget.sectionHeight * .025,
              ),
              height: widget.sectionHeight * .1,
              child: const Text(
                'أنواع المعالجات',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.black,
                  fontSize: 24,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: widget.sectionHeight * .75,
                    child: state is LoadedTreatmentTypesState
                    ? SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ...state.types.map((type) {
                            return TypeTile(
                              tileHeight: widget.sectionHeight * .075,
                              tileWidth: widget.sectionWidth * .75,
                              type: type,
                            );
                          }).toList(),
                          createAddingField(),
                        ],
                      ),
                    )
                        : state is LoadingTreatmentTypesState
                    ? Container(color: Colors.yellow)
                        : Container(color: Colors.red),
                  ),
                  MaterialButton(
                    color: AppColors.lightGreen,
                    height: widget.sectionHeight * .085,
                    minWidth: widget.sectionHeight * .2,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(
                        color: AppColors.lightGreen,
                        // color: AppColors.black,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                    splashColor: AppColors.lightBlue,
                    onPressed: () {
                      focusNode.requestFocus();
                      ref.read(addingType.notifier).state = true;
                    },
                    child: const Text(
                      'إضافة نوع',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.black,
                        // color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  createAddingField() {
    final isAdding = ref.watch(addingType);
    double tileHeight = widget.sectionHeight * .075;
    double tileWidth = widget.sectionWidth * .75;
    if (isAdding) {
      return SizedBox(
        height: tileHeight,
        width: tileWidth,
        child: TextFormField(
          focusNode: focusNode,
          cursorColor: AppColors.black,
          cursorHeight: tileHeight * .6,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 18,
            color: AppColors.black,
          ),
          decoration: InputDecoration(
            border: typeFieldBorder,
            focusedBorder: typeFieldBorder,
            contentPadding: EdgeInsets.only(bottom: -tileHeight * .2),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الحقل مطلوب';
            } else {
              return null;
            }
          },
          onFieldSubmitted: (value) async{
            ref.read(addingType.notifier).state = false;
            if (value.isNotEmpty) {
              await ref.read(treatmentsTypesProvider.notifier).createTreatmentType(value);
              ref.read(addingType.notifier).state = false;
            }
          },
          onTapOutside: (event) {
            ref.read(addingType.notifier).state = false;
          },
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
