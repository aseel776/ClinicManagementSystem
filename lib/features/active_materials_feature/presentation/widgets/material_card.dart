import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/update_material.dart';
import './/core/app_colors.dart';
import '../../data/models/active_material_model.dart';

class MaterialCard extends StatelessWidget {
  final ActiveMaterialModel material;
  final double cardWidth;
  final double cardHeight;

  const MaterialCard({
    Key? key,
    required this.material,
    required this.cardWidth,
    required this.cardHeight
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColors.lightGreen,
            AppColors.lightGreen.withOpacity(.2),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Consumer(
        builder: (context, ref, child) =>
            InkWell(
              onTap: () {
                // ref.read(activeMaterialsProvider.notifier).get();
                showUpdatePopUp(context, material);
                print(material.name);
              },
              child: Container(
                width: cardWidth,
                height: cardHeight,
                alignment: Alignment.center,
                child: Text(
                  material.name!,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 22,
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
