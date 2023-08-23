import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';

Widget textfield(String hint, TextEditingController controller,
    String validateMessage, int maxLines) {
  return TextFormField(
    validator: (value) {
      if (value == null || value.isEmpty) {
        return validateMessage;
      }
      return null;
    },
    controller: controller,
    // initialValue: (controller != null) ? controller.text : "",
    cursorColor: AppColors.lightGreen,
    /*onChanged: (value) => controller.email = value,*/
    keyboardType: TextInputType.emailAddress,
    maxLines: maxLines,
    
    decoration: InputDecoration(
      fillColor: Colors.transparent,
      filled: true,
      hintText: hint,

      // hintMaxLines: 7,
      // helperMaxLines: 7,
      hintStyle:
          const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 2, color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}
