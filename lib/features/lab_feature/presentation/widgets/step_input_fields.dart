import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/core/primaryText.dart';
import 'package:clinic_management_system/core/textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stepControllers =
    StateProvider.autoDispose<List<TextEditingController>>((ref) => []);

class StepInputScreen extends ConsumerStatefulWidget {
  @override
  _StepInputScreenState createState() => _StepInputScreenState();
}

class _StepInputScreenState extends ConsumerState<StepInputScreen> {
  ScrollController? controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(stepControllers);
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.05,
          width: MediaQuery.of(context).size.width * 0.2,
          child: ListView.builder(
            shrinkWrap: true,
            controller: controller,
            itemCount: ref.watch(stepControllers.notifier).state.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: textfield("الخطوة $index",
                    ref.watch(stepControllers.notifier).state[index], "", 1),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(AppColors.black)),
          onPressed: () {
            setState(() {
              List<TextEditingController> list =
                  ref.watch(stepControllers.notifier).state;
              list.add(TextEditingController());
              ref.watch(stepControllers.notifier).state = list;
            });
          },
          child: const PrimaryText(
            text: "إضافة خطوة",
          ),
        ),
      ],
    );
  }
}
