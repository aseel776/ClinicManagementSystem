import 'package:clinic_management_system/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const defaultSpace = 16.0;
const Color menuBarColor = Colors.white;
const Color backgroundColor = Color(0xFFf4f5f7);
const Color primaryColor = Color(0xFF0845ff);
const Color defaultIconColor = Color(0xFF83919a);
const List<Color> productStatusColor = [Color(0xFFcdf5d3), Color(0xFFffd2cc)];
const Color iconBackdropColor = Color(0xFFe5e9ec);

class PaginationWidget extends ConsumerWidget {
  final int totalPages;
  final int currentPage;
  final Function(int) onPageSelected;

  PaginationWidget({
    required this.totalPages,
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<int> visiblePages = _getVisiblePages(currentPage, totalPages);
    return Container(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              print("current PAGE");
              print(currentPage);
              _goToPreviousPage(currentPage);
            },
            icon: Icon(Icons.keyboard_arrow_left),
          ),
          for (int page in visiblePages) ...[
            ProductPageLabel(
              pageNo: page,
              isCurrentPage: page == currentPage,
              onPressed: () {
                onPageSelected(page - 1);
              },
            ),
          ],
          IconButton(
            onPressed: () {
              print("current PAGE");
              print(currentPage);
              _goToNextPage(currentPage, totalPages);
            },
            icon: Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
    );
  }

  List<int> _getVisiblePages(int currentPage, int totalPages) {
    const maxVisiblePages = 5; // You can adjust this number
    final List<int> visiblePages = [];
    print(totalPages.toString() + "totalPages");
    print("currentPage" + currentPage.toString());

    if (totalPages <= maxVisiblePages) {
      visiblePages.addAll(List.generate(totalPages, (index) => index + 1));
    } else {
      final int middlePage = currentPage + 1;
      final int leftBound = middlePage - (maxVisiblePages ~/ 2);
      final int rightBound = middlePage + (maxVisiblePages ~/ 2);

      if (leftBound <= 1) {
        visiblePages
            .addAll(List.generate(maxVisiblePages, (index) => index + 1));
      } else if (rightBound >= totalPages) {
        visiblePages.addAll(List.generate(maxVisiblePages,
                (index) => totalPages - maxVisiblePages + index + 1));
      } else {
        visiblePages.addAll(
            List.generate(maxVisiblePages, (index) => leftBound + index));
      }
    }
    print("visiblePage" + visiblePages.toString());
    return visiblePages;
  }

  void _goToPreviousPage(int currentPage) {
    if (currentPage > 1) {
      onPageSelected(currentPage - 1);
    }
  }

  void _goToNextPage(int currentPage, int totalPages) {
    if (currentPage < totalPages - 1) {
      onPageSelected(currentPage + 1);
    }
  }
}

class ProductPageLabel extends StatelessWidget {
  final dynamic pageNo;
  final bool? isCurrentPage;
  final Function() onPressed;

  const ProductPageLabel({Key? key,
    required this.pageNo,
    this.isCurrentPage,
    required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30,
        height: 25,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isCurrentPage ?? false
                ? AppColors.lightGreen
                : Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Center(
              child: Text(
                "$pageNo",
                style: TextStyle(
                    color: isCurrentPage ?? false ? Colors.white : Colors
                        .black87),
              )),
        ),
      ),
    );
  }
}

class ButtonWidgetWithIcon extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? borderColor;
  final Color? labelAndIconColor;
  final double? borderRadius;
  final Function() onTap;

  const ButtonWidgetWithIcon({Key? key,
    required this.label,
    this.icon,
    this.borderColor,
    this.labelAndIconColor,
    this.borderRadius,
    required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
              color: borderColor ?? Colors.grey.withOpacity(.4), width: .7),
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(defaultSpace / 2),
                  child: Text(
                    label,
                    style: TextStyle(
                        color:
                        labelAndIconColor ?? Colors.grey.withOpacity(.7)),
                  )),
              Icon(
                icon,
                color: labelAndIconColor ?? Colors.grey.withOpacity(.8),
                size: 19,
              )
            ],
          ),
        ),
      ),
    );
  }
}