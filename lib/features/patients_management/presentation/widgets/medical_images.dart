import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/patient_profile.dart';

class MedicalImagesScreen extends ConsumerStatefulWidget {
  PageController pageController;
  MedicalImagesScreen({super.key, required this.pageController});

  @override
  ConsumerState<MedicalImagesScreen> createState() =>
      _MedicalImagesScreenState();
}

class _MedicalImagesScreenState extends ConsumerState<MedicalImagesScreen> {
  // late PageController pagecontroller;
  var currentPage = "صور شعاعية";
  List navBarItems = [
    "صور شعاعية",
    "صور شمسية",
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sectionWidth = MediaQuery.of(context).size.width;
    final sectionHeight = MediaQuery.of(context).size.height;

    return Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height * 0.52,
        width: MediaQuery.of(context).size.width,
        child:
            pageView(ref.watch(currentPageViewProvider.notifier).state, ref));
  }

  Widget pageView(int currentPage, WidgetRef ref) {
    switch (currentPage) {
      case 0:
        {
          return PageView.custom(
            scrollDirection: Axis.horizontal,
            controller: widget.pageController,
            childrenDelegate: SliverChildBuilderDelegate(
              ((context, index) {
                return Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, top: 15, right: 10),
                    child: Container(
                      color: Colors.green,
                      child: Text("sh3a3ehhh"),
                    ));
              }),
              childCount: 1,
            ),
          );
        }
      case 1:
        {
          return PageView.custom(
            scrollDirection: Axis.horizontal,
            controller: widget.pageController,
            childrenDelegate: SliverChildBuilderDelegate(
              ((context, index) {
                return Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, top: 15, right: 10),
                    child: Container(
                      color: Colors.red,
                      child: Text("shamsieeeh"),
                    ));
              }),
              childCount: 1,
            ),
          );
        }
      default:
        {
          return Container();
        }
    }
  }
}

class CustomNavigationButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool selected;
  final double screenHeight;
  final double screenWidth;

  CustomNavigationButton({
    required this.text,
    required this.onTap,
    required this.selected,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: Colors.black45,
        ),
        height: screenHeight * 0.065,
        width: screenWidth * 0.18,
        child: Center(
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                  ),
                ),
              ),
              if (text == "accepted request") SizedBox(width: 5),
              if (selected)
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.check,
                    color: Colors.white54,
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
