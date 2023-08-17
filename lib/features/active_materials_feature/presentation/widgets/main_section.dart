import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './insert_material.dart';
import './/core/app_colors.dart';
import './material_card.dart';
import '../states/control_states.dart';
import '../states/active_materials/active_materials_state.dart';
import '../states/active_materials/active_materials_provider.dart';

class ActiveMaterialsMainSection extends ConsumerStatefulWidget {
  final double sectionWidth;

  const ActiveMaterialsMainSection({Key? key, required this.sectionWidth})
      : super(key: key);

  @override
  ConsumerState<ActiveMaterialsMainSection> createState() =>
      _ActiveMaterialsMainSectionState();
}

class _ActiveMaterialsMainSectionState extends ConsumerState<ActiveMaterialsMainSection>{

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        ref.read(currentPageProvider.notifier).state = _pageController.page!.toInt() + 1;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(activeMaterialsProvider.notifier).getAllMaterials(1);
      final state = ref.read(activeMaterialsProvider);
      if(state is LoadedActiveMaterialsState){
        ref.read(totalPagesProvider.notifier).state = state.page.totalPages!;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(activeMaterialsProvider);
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      //row and scaffold to be removed
      body: Row(
        children: [
          //to be removed
          Container(
            width: screenWidth - widget.sectionWidth,
            color: AppColors.black,
          ),
          //return starts here
          Container(
            width: widget.sectionWidth,
            color: AppColors.lightGrey,
            // color: Colors.white,
            padding: EdgeInsets.only(
              left: widget.sectionWidth * .025,
              right: widget.sectionWidth * .025,
              top: screenHeight * .04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: widget.sectionWidth * .4,
                  height: screenHeight * .125,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.sectionWidth * .4 * .05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'المواد الكيميائية',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.black,
                          fontSize: 24,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/materials.jpg',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * .05),
                Row(
                  children: [
                    Container(
                      width: widget.sectionWidth * .6,
                      height: screenHeight * .07,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.sectionWidth * 0.01,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //search icon
                          SizedBox(
                            width: widget.sectionWidth * .02,
                            height: screenHeight * .04,
                            child: Icon(
                              Icons.search,
                              color: AppColors.black.withOpacity(0.5),
                              size: widget.sectionWidth * .018,
                            ),
                          ),
                          SizedBox(width: widget.sectionWidth * .01),
                          //text field
                          Expanded(
                            child: TextField(
                              // controller: _controller.searchController,
                              textAlign: TextAlign.right,
                              cursorColor: AppColors.black,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                color: AppColors.black.withOpacity(.8),
                              ),
                              decoration: InputDecoration(
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none,
                                hintText: 'بحث',
                                hintStyle: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 18,
                                  color: AppColors.black.withOpacity(.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: widget.sectionWidth * .025),
                    MaterialButton(
                      height: screenHeight * .08,
                      minWidth: widget.sectionWidth * .2,
                      color: AppColors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) async{
                          await showInsertPopUp(context).then((newMaterial){
                            if(newMaterial != null){
                              ref.read(activeMaterialsProvider.notifier).createMaterial(newMaterial);
                            }
                          });
                        });
                      },
                      child: const Text(
                        'إضافة مادة كيميائية',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * .025),
                Expanded(
                  child: state is LoadedActiveMaterialsState
                      ? Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemBuilder: (_, __) {
                          return Wrap(
                            runSpacing: screenHeight * .025,
                            spacing: widget.sectionWidth * .01875,
                            children: [
                              ...state.page.materials!.map((m) =>
                                  MaterialCard(
                                    material: m,
                                    cardHeight: screenHeight * .2,
                                    cardWidth: widget.sectionWidth * .175,
                                  )).toList(),
                            ],
                          );
                        },
                      ),
                      Visibility(
                        visible: ref.watch(nextPageFlag),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: widget.sectionWidth * .035,
                            child: FloatingActionButton(
                              backgroundColor: AppColors.black,
                              onPressed: () {
                                WidgetsBinding.instance.addPostFrameCallback((_) async{
                                  await handleNextPage(ref);
                                });
                              },
                              child: const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: ref.watch(previousPageFlag),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: widget.sectionWidth * .035,
                            child: FloatingActionButton(
                              backgroundColor: AppColors.black,
                              onPressed: () {
                                WidgetsBinding.instance.addPostFrameCallback((_) async {
                                  await handlePreviousPage(ref);
                                });
                              },
                              child: const Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      : state is ErrorActiveMaterialsState
                      ? Container(color: Colors.red)
                      : Container(color: Colors.yellow),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  handleNextPage(WidgetRef ref) {
    if (ref.read(currentPageProvider) < ref.read(totalPagesProvider)) {
      int pageBefore = ref.read(currentPageProvider);
      ref.read(activeMaterialsProvider.notifier).getAllMaterials(pageBefore + 1);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      ).whenComplete(() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          int pageAfter = ref.read(currentPageProvider);
          if (pageAfter == ref.read(totalPagesProvider)) {
            ref.read(nextPageFlag.notifier).state = false;
          }
          ref.read(previousPageFlag.notifier).state = true;
        });
      });
    }
  }

  handlePreviousPage(WidgetRef ref) {
    if (ref.read(currentPageProvider) > 1) {
      int pageBefore = ref.read(currentPageProvider);
      ref.read(activeMaterialsProvider.notifier).getAllMaterials(pageBefore - 1);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      ).whenComplete(() async {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          int pageAfter = ref.read(currentPageProvider);
          if (pageAfter == 1) {
            ref.read(previousPageFlag.notifier).state = false;
          }
          ref.read(nextPageFlag.notifier).state = true;
        });
      });
    }
  }
}
