import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/app_colors.dart';
import '../states/problems/problems_provider.dart';
import '../../data/models/problem_model.dart';

class ProblemTile extends StatelessWidget {
  final double tileWidth;
  final double tileHeight;
  final ProblemModel problem;
  const ProblemTile({
    Key? key,
    required this.tileWidth,
    required this.tileHeight,
    required this.problem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            AppColors.lightGreen,
            AppColors.lightGreen.withOpacity(.5),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )
      ),
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            height: tileHeight,
            width: tileWidth,
            padding: EdgeInsets.only(
              right: tileWidth * .1,
              top: tileHeight * .1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  problem.name!,
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      color: AppColors.black
                  ),
                ),
                SizedBox(height: tileHeight * .01),
                Row(
                  children: [
                    SizedBox(width: tileWidth * .025),
                    const Icon(
                      Icons.chevron_right,
                    ),
                    Text(
                      'النوع: ${problem.type!.name}',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: tileWidth * .025,
            bottom: tileHeight * .05,
            child: IconButton(
              onPressed: () async {
                print('edit');
                // await showUpdateDialog();
              },
              icon: const Icon(
                Icons.edit,
              ),
            ),
          ),
          Positioned(
            left: tileWidth * .025,
            bottom: tileHeight * .05,
            child: Consumer(
              builder: (context, ref, child) =>
                  IconButton(
                    onPressed: () async {
                      await ref.read(problemsProvider.notifier).deleteProblemType(problem.id!);
                    },
                    icon: const Icon(
                      Icons.delete,
                    ),
                  ),
            )
          ),
        ],
      ),
    );
  }
}
