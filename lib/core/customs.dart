import 'app_colors.dart';
import 'package:flutter/material.dart';

const typeFieldBorder = UnderlineInputBorder(
  borderSide: BorderSide(
    color: AppColors.black,
  ),
);

//////////////////////////////////////////////////

decorateUpsertField({required double width, required double height, String? label}) {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: height * .025, horizontal: width * .025),
    border: upsertFieldBorder,
    focusedBorder: upsertFieldFocusBorder,
    errorBorder: upsertFieldErrorBorder,
    focusedErrorBorder: upsertFieldErrorBorder,
    enabledBorder: upsertFieldEnabledBorder,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    label: Text(
      label ?? '',
      style: const TextStyle(
        fontFamily: 'Cairo',
        color: AppColors.black,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    ),
    errorStyle: TextStyle(
      fontFamily: 'Cairo',
      color: Colors.red[600]!,
      fontSize: 14,
    ),
  );
}

final upsertFieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(20),
  borderSide: const BorderSide(
    color: AppColors.black,
  ),
);

final upsertFieldFocusBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(20),
  borderSide: BorderSide(
    color: Colors.black.withOpacity(.6),
  ),
);

final upsertFieldErrorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(20),
  borderSide: BorderSide(
    color: Colors.red[600]!,
  ),
);

final upsertFieldEnabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(20),
  borderSide: const BorderSide(color: Colors.black38),
);

//////////////////////////////////////////////////

decorateInsertMaterialField({required double horizontalPadding, required double verticalPadding}) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    focusColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(
      vertical: verticalPadding,
      horizontal: horizontalPadding,
    ),
    border: insertMaterialBorder,
    focusedBorder: insertMaterialBorder,
    errorBorder: insertMaterialBorder,
    focusedErrorBorder: insertMaterialBorder,
    enabledBorder: insertMaterialBorder,
    errorStyle: TextStyle(
      fontFamily: 'Cairo',
      color: Colors.red[600]!,
      fontSize: 14,
    ),
  );
}

final insertMaterialBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: const BorderSide(
    color: Colors.white70,
  ),
);
