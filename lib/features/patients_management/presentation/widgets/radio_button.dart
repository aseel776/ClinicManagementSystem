import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/app_colors.dart';

Row addRadioButton(int btnValue, String title, List<String> listValue,
    WidgetRef ref, StateProvider provider) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Radio(
          activeColor: AppColors.lightGreen,
          value: listValue[btnValue],
          groupValue: ref.watch(provider),
          onChanged: (value) {
            print("valueee");
            print(value);
            ref.read(provider.notifier).state = value.toString();
          }),
      Text(title),
    ],
  );
}
