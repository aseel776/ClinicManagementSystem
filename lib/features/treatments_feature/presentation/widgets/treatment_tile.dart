import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/app_colors.dart';
import '../states/control_states.dart';
import '../states/tile_size/tile_size_state.dart';
import '../states/treatment/treatment_state.dart';
import '../states/treatment/treatment_provider.dart';
import '../states/tile_size/tile_size_provider.dart';
import '../../data/models/treatment_model.dart';

class TreatmentTile extends ConsumerWidget {
  const TreatmentTile({
    Key? key,
    required this.sectionWidth,
    required this.sectionHeight,
    required this.treatment,
  }) : super(key: key);

  final double sectionWidth;
  final double sectionHeight;
  final TreatmentModel treatment;
  final animationDuration = const Duration(milliseconds: 50);
  final animationCurve = Curves.linear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tuple = Tuple3(sectionWidth * .43, sectionHeight * .1, key);
    TileSizeState tileSizeStatement = ref.watch(tileProvider(tuple));

    return Container(
      width: sectionWidth * .5,
      height: sectionHeight * .15,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: InkWell(
        onTap: () async{
          await ref.read(treatmentProvider.notifier).getTreatment(treatment.id!);
          final tempState = ref.watch(treatmentProvider);
          if(tempState is LoadedTreatmentState){
            if (selectedTreatment == null) {
              selectedTreatment = ValueNotifier(tempState.treatment);
            } else {
              selectedTreatment!.value = tempState.treatment;
            }
            isExpanded.value = false;
          }
        },
        onHover: (value){
          if(value){
            ref.read(tileProvider(tuple).notifier).scale();
          }else{
            ref.read(tileProvider(tuple).notifier).unscale();
          }
        },
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          shadowColor: Colors.grey[100],
          child: Stack(
            children: [
              AnimatedContainer(
                width: tileSizeStatement.width,
                height: tileSizeStatement.height,
                curve: animationCurve,
                duration: animationDuration,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
              ),
              Positioned(
                right: 0,
                child: AnimatedContainer(
                  width: tileSizeStatement.width * .25,
                  height: tileSizeStatement.height,
                  curve: animationCurve,
                  duration: animationDuration,
                  decoration: BoxDecoration(
                    color: treatment.color!,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                child: AnimatedContainer(
                  width: tileSizeStatement.width * .75,
                  height: tileSizeStatement.height,
                  curve: animationCurve,
                  duration: animationDuration,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: sectionWidth * .025),
                  child: Text(
                    treatment.name!,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
