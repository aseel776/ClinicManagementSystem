import 'package:flutter/material.dart';

class TextFieldAddMedicine {
  static Widget textfield(
      {String? hint,
      TextEditingController? controller,
      String? initialvalue,
      int? maxLines,
      bool? boarder = true}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        initialValue: initialvalue,
        controller: controller,
        // textDirection: TextDirection.rtl,
        /*onChanged: (value) => controller.email = value,*/
        cursorColor: Colors.black45,
        cursorWidth: 1,
        maxLines: maxLines,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          // label: Text("test"),
          fillColor: Colors.transparent,
          filled: true,
          hintText: hint,

          hintStyle: const TextStyle(color: Colors.black54, fontSize: 13),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                width: 1,
                color: boarder! ? Colors.black45 : Colors.transparent),
            // borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black45),
            // borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
