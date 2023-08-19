import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/app_colors.dart';
import '../widgets/treatment_tile.dart';
import '../widgets/treatment_info.dart';
import '../states/control_states.dart';
import '../states/treatments/treatments_state.dart';
import '../states/treatments/treatments_provider.dart';
import '../../data/models/treatment_model.dart';

class TreatmentsSection extends ConsumerStatefulWidget {
  final double sectionWidth;
  final double sectionHeight;

  const TreatmentsSection(
      {Key? key, required this.sectionWidth, required this.sectionHeight})
      : super(key: key);

  @override
  ConsumerState<TreatmentsSection> createState() => _TreatmentsSectionState();
}

class _TreatmentsSectionState extends ConsumerState<TreatmentsSection> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await ref.read(treatmentsProvider.notifier).getAllTreatments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentsProvider);

    return ValueListenableBuilder<bool>(
      valueListenable: isExpanded,
      builder: (context, isExpandedValue, child) => SizedBox(
        height: widget.sectionHeight,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 750),
                curve: Curves.linear,
                width: widget.sectionWidth,
                height: isExpandedValue ? widget.sectionHeight : widget.sectionHeight * .495,
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
                        'المعالجات',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.black,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        child: state is LoadedTreatmentsState
                          ? buildTreatmentsGridView(state.page.treatments!)
                          : state is LoadedTreatmentsState
                          ? Container(color: Colors.yellow)
                          : Container(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isExpandedValue)
                SizedBox(
                  height: widget.sectionHeight * .505,
                  child: Column(
                    children: [
                      SizedBox(
                        height: widget.sectionHeight * .01,
                      ),
                      TreatmentInfo(
                        containerHeight: widget.sectionHeight * .495,
                        containerWidth: widget.sectionWidth,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  buildTreatmentsGridView(List<TreatmentModel> treatments) {
    int rowsCount = (treatments.length / 2).ceil();
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int r = 0, i = 0;
              r < rowsCount && i < treatments.length;
              r++, i += 2)
            Row(
              children: [
                Expanded(
                  child: TreatmentTile(
                    sectionWidth: widget.sectionWidth,
                    sectionHeight: widget.sectionHeight,
                    treatment: treatments[i],
                    key: ValueKey(treatments[i].id),
                  ),
                ),
                if (i + 1 < treatments.length)
                  Expanded(
                    child: TreatmentTile(
                      sectionWidth: widget.sectionWidth,
                      sectionHeight: widget.sectionHeight,
                      treatment: treatments[i + 1],
                      key: ValueKey(treatments[i + 1].id),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
