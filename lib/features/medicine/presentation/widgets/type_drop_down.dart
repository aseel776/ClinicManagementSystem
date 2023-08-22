import 'package:clinic_management_system/features/medicine/presentation/widgets/primaryText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider selectedValueProvider = StateProvider((ref) => "");

class TypeDropDown extends ConsumerStatefulWidget {
  String? hintText;
  List<String> items;
  TypeDropDown({super.key, this.hintText, required this.items});

  @override
  _MyDropdownFormFieldState createState() => _MyDropdownFormFieldState();
}

class _MyDropdownFormFieldState extends ConsumerState<TypeDropDown> {
  // String? selectedValue;

  @override
  Widget build(BuildContext context) {
    ref.watch(selectedValueProvider);
    return DropdownButtonFormField<String>(
      // value: ref.watch(selectedValueProvider.notifier).state,
      elevation: 2,
      hint: PrimaryText(
        text: widget.hintText,
        height: 1.5,
      ),
      decoration: InputDecoration(
        // labelText: widget.hintText,
        // icon: Icon(Icons.arrow_drop_down),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onChanged: (value) {
        ref.watch(selectedValueProvider.notifier).state = value;
        // setState(() {
        //   selectedValue = value;
        // });
      },
      items: widget.items.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Row(
            children: [
              // Icon(item['icon']),
              // const SizedBox(width: 10),
              Text(item),
            ],
          ),
        );
      }).toList(),
    );
  }
}
