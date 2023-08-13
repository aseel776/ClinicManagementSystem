import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/app_colors.dart';
import './material_card.dart';
import '../dummy_data.dart';
import '../states/control_states.dart';

class ActiveMaterialsMainSection extends StatelessWidget {
  final double sectionWidth;

  ActiveMaterialsMainSection({Key? key, required this.sectionWidth})
      : super(key: key);

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      //row and scaffold to be removed
      body: Row(
        children: [
          //to be removed
          Container(
            width: screenWidth - sectionWidth,
            color: AppColors.black,
          ),
          //return starts here
          Container(
            width: sectionWidth,
            color: AppColors.lightGrey,
            // color: Colors.white,
            padding: EdgeInsets.only(
              left: sectionWidth * .025,
              right: sectionWidth * .025,
              top: screenHeight * .04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: sectionWidth * .4,
                  height: screenHeight * .125,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: sectionWidth * .4 * .05),
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
                      width: sectionWidth * .6,
                      height: screenHeight * .07,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: sectionWidth * 0.01,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //search icon
                          SizedBox(
                            width: sectionWidth * .02,
                            height: screenHeight * .04,
                            child: Icon(
                              Icons.search,
                              color: AppColors.black.withOpacity(0.5),
                              size: sectionWidth * .018,
                            ),
                          ),
                          SizedBox(width: sectionWidth * .01),
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
                    SizedBox(width: sectionWidth * .025),
                    MaterialButton(
                      height: screenHeight * .08,
                      minWidth: sectionWidth * .2,
                      color: AppColors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {},
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
                  child: Consumer(
                    builder: (context, ref, child) {
                      bool previousPageExists = ref.watch(previousPageFlag);
                      bool nextPageExists = ref.watch(nextPageFlag);
                      return Stack(
                        children: [
                          PageView(
                            controller: _pageController,
                            children: [
                              Wrap(
                                runSpacing: screenHeight * .025,
                                spacing: sectionWidth * .01875,
                                children: [
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                ],
                              ),
                              Wrap(
                                runSpacing: screenHeight * .025,
                                spacing: sectionWidth * .01875,
                                children: [
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                ],
                              ),
                              Wrap(
                                runSpacing: screenHeight * .025,
                                spacing: sectionWidth * .01875,
                                children: [
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                  MaterialCard(
                                    material: materials[1],
                                    cardHeight: screenHeight * .2,
                                    cardWidth: sectionWidth * .175,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (nextPageExists)
                            FutureBuilder(
                              future: Future.delayed(
                                const Duration(milliseconds: 10),
                              ).then((value) => true),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const SizedBox();
                                }
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    width: sectionWidth * .035,
                                    child: FloatingActionButton(
                                      backgroundColor: AppColors.black,
                                      onPressed: () {
                                        handleNextPage(ref);
                                      },
                                      child: const Icon(
                                        Icons.chevron_right,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          if (previousPageExists)
                            FutureBuilder(
                              future: Future.delayed(
                                const Duration(milliseconds: 10),
                              ).then((value) => true),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const SizedBox();
                                }
                                return Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: sectionWidth * .035,
                                    child: FloatingActionButton(
                                      backgroundColor: AppColors.black,
                                      onPressed: () {
                                        handlePreviousPage(ref);
                                      },
                                      child: const Icon(
                                        Icons.chevron_left,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  handleNextPage(WidgetRef ref) {
    print('next');
    if (_pageController.page! < 2) {
      print('current: ${_pageController.page}');
      _pageController
          .nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      )
          .whenComplete(() {
        if (_pageController.page == 2) {
          ref.read(nextPageFlag.notifier).state = false;
        }
        print('new: ${_pageController.page}');
        ref.read(previousPageFlag.notifier).state = true;
      });
    }
  }

  handlePreviousPage(WidgetRef ref) {
    print('previous');
    if (_pageController.page! > 0) {
      print('current: ${_pageController.page}');
      _pageController
          .previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      )
          .whenComplete(() {
        if (_pageController.page == 0) {
          ref.read(previousPageFlag.notifier).state = false;
        }
        print('new: ${_pageController.page}');
        ref.read(nextPageFlag.notifier).state = true;
      });
    }
  }
}
