import 'package:clinic_management_system/core/app_colors.dart';
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
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 400, // Set the specific height you want
            child: ListView.builder(
              shrinkWrap: true,
              controller: controller,
              itemCount: ref.watch(stepControllers.notifier).state.length,
              itemBuilder: (context, index) {
                return textfield("الخطوة ${index}",
                    ref.watch(stepControllers.notifier).state[index], "", 1);
              },
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColors.black)),
            onPressed: () {
              setState(() {
                List<TextEditingController> list =
                    ref.watch(stepControllers.notifier).state;
                list.add(TextEditingController());
                ref.read(stepControllers.notifier).state = list;
              });
            },
            child: Text('Add Step'),
          ),
        ],
      ),
    );
  }
}
