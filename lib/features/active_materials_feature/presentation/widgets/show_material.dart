import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './update_material.dart';
import './/core/app_colors.dart';
import '../states/control_states.dart';
import '../states/active_material/active_material_state.dart';
import '../states/active_material/active_material_provider.dart';
import '../states/active_materials/active_materials_provider.dart';

Future<void> showDetailsPopUp(BuildContext context, int id) async {
  double screenWidth = MediaQuery.of(context).size.width;
  double containerWidth = screenWidth * .35;
  double screenHeight = MediaQuery.of(context).size.height;
  double containerHeight = screenHeight * .6;

  await showDialog(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(activeMaterialProvider);
          final isScrollingState = ref.watch(isScrolling);
          final isHoveringState = ref.watch(isHovering);

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                width: containerWidth,
                height: containerHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.lightGreen,
                ),
                padding: EdgeInsets.symmetric(vertical: containerHeight * .05),
                child: Column(
                  children: [
                    SizedBox(
                      height: containerHeight * .1,
                      child: const Text(
                        'تفاصيل',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 22,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: containerHeight * .025),
                    SizedBox(
                      width: containerWidth * .8,
                      height: containerHeight * .75,
                      child: state is LoadedActiveMaterialState
                          ? Column(
                        children: [
                          SizedBox(
                            height: containerHeight * .1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'المادة:',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 18,
                                    color: AppColors.black,
                                  ),
                                ),
                                SizedBox(width: containerWidth * .05),
                                Expanded(
                                  child: Text(
                                    state.material.name!,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 18,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: containerHeight * .1,
                            width: containerWidth * .8,
                            child: const Text(
                              'التعارضات الدوائية:',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 18,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: containerHeight * .4,
                            child: MouseRegion(
                              onEnter: (event) {
                                ref.read(isHovering.notifier).state = true;
                              },
                              onExit: (event) {
                                ref.read(isHovering.notifier).state = false;
                                ref.read(isScrolling.notifier).state = false;
                              },
                              child: Listener(
                                onPointerSignal: (event) {
                                  if (event is PointerScrollEvent) {
                                    ref.read(isScrolling.notifier).state = event.scrollDelta.dy > 0;
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    backgroundBlendMode: BlendMode.lighten  ,
                                    borderRadius: BorderRadius.circular(15),
                                    color: (isScrollingState || isHoveringState)
                                        ? Colors.white70
                                        : Colors.grey[300]!.withOpacity(.6),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: (containerWidth * .8) * .05,
                                    vertical: (containerHeight * .4) * .05
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: ListView.builder(
                                      itemCount: state.material.antiMaterials!.length,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          height: containerHeight * .075,
                                          width: containerWidth * .07,
                                          child: Text(
                                            '- ${state.material.antiMaterials![index].name!}',
                                            style: const TextStyle(
                                              fontFamily: 'Cairo',
                                              color: AppColors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: containerHeight * .05),
                          SizedBox(
                            height: containerHeight * .1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MaterialButton(
                                  minWidth: containerWidth * .25,
                                  height: containerHeight * .1,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onPressed: () async {
                                    await showUpdatePopUp(context, state.material).then((value) async{
                                      if(value){
                                        await ref.read(activeMaterialProvider.notifier).getMaterial(id);
                                      }
                                    });
                                  },
                                  child: const Text(
                                    'تعديل',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 16,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: containerHeight * .1,
                                  width: containerWidth * .1,
                                ),
                                MaterialButton(
                                  minWidth: containerWidth * .25,
                                  height: containerHeight * .1,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    await ref.read(activeMaterialsProvider.notifier).deleteMaterial(state.material.id!);
                                    int page = ref.read(currentPageProvider);
                                    await ref.read(activeMaterialsProvider.notifier).getAllMaterials(page, ref: ref);
                                  },
                                  child: const Text(
                                    'حذف',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 16,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                          : state is LoadingActiveMaterialState
                          ? Container(color: Colors.yellow)
                          : Container(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
