import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/app_colors.dart';
import '../states/problems/problems_provider.dart';

class ProblemsSection extends ConsumerStatefulWidget {
  final double sectionWidth;
  final double sectionHeight;
  const ProblemsSection({
    Key? key,
    required this.sectionWidth,
    required this.sectionHeight
  }) : super(key: key);

  @override
  ConsumerState<ProblemsSection> createState() => _ProblemsSectionState();
}

class _ProblemsSectionState extends ConsumerState<ProblemsSection> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await ref.read(problemsProvider.notifier).getAllProblems();
    });
  }

  @override
  Widget build(BuildContext context) {

    // final state = ref.watch(problemsProvider);

    return Container(
      width: widget.sectionWidth,
      height: widget.sectionHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: widget.sectionWidth * .05,
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
              'المشاكل',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.black,
                fontSize: 22,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(

            ),
          ),
        ],
      )
    );
  }
}
