import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/customs.dart';
import './/core/app_colors.dart';
import './type_tile.dart';
import '../states/control_states.dart';
import '../states/types/problem_type_state.dart';
import '../states/types/problem_type_provider.dart';

class ProblemTypesSection extends ConsumerStatefulWidget {
  final double sectionHeight;
  final double sectionWidth;

  const ProblemTypesSection(
      {Key? key, required this.sectionHeight, required this.sectionWidth})
      : super(key: key);

  @override
  ConsumerState<ProblemTypesSection> createState() => _ProblemTypesSectionState();
}

class _ProblemTypesSectionState extends ConsumerState<ProblemTypesSection> {
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await ref.read(problemTypesProvider.notifier).getAllTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final typesState = ref.watch(problemTypesProvider);
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
              height: widget.sectionHeight * .125,
              child: const Text(
                'أنواع المشاكل',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.black,
                  fontSize: 22,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: widget.sectionHeight * .75,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if(typesState is LoadedProblemTypesState)
                          ...typesState.types.map((type) =>
                              ProblemTypeTile(
                                tileHeight: widget.sectionHeight * .1,
                                tileWidth: widget.sectionWidth * .9,
                                type: type,
                              ),
                          ).toList(),
                          createAddingField(),
                        ],
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: AppColors.lightGreen,
                    // color: AppColors.black,
                    height: widget.sectionHeight * .085,
                    minWidth: widget.sectionWidth * .4,
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
                      ref.read(addingProblemType.notifier).state = true;
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
                  SizedBox(height: widget.sectionHeight * .025)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  createAddingField() {
    double tileHeight = widget.sectionHeight * .075;
    double tileWidth = widget.sectionWidth * .75;
    final isAdding = ref.watch(addingProblemType);
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
            ref.read(addingProblemType.notifier).state = false;
            if (value.isNotEmpty) {
              await ref.read(problemTypesProvider.notifier).createProblemType(value);
              await ref.read(problemTypesProvider.notifier).getAllTypes();
            }
          },
          onTapOutside: (event) {
            ref.read(addingProblemType.notifier).state = false;
          },
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
