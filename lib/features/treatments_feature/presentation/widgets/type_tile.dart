import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/customs.dart';
import './/core/app_colors.dart';
import '../states/control_states.dart';
import '../../data/models/treatment_type_model.dart';

class TypeTile extends ConsumerWidget {
  final double tileHeight;
  final double tileWidth;
  final TreatmentTypeModel type;

  final focusNode = FocusNode();
  late final _controller = TextEditingController(text: type.name);

  TypeTile({
    Key? key,
    required this.tileHeight,
    required this.tileWidth,
    required this.type
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = ValueKey(type.id);
    bool editing = ref.watch(editingType(key));
    return Container(
      height: tileHeight,
      width: tileWidth,
      padding: EdgeInsets.symmetric(horizontal: tileWidth * .01),
      margin: EdgeInsets.symmetric(vertical: tileHeight * .01),
      child: editing
          ? TextFieldTapRegion(
              onTapOutside: (event) {
                ref.read(editingType(key).notifier).state = false;
                _controller.text = type.name!;
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: focusNode,
                      controller: _controller,
                      cursorColor: AppColors.black,
                      cursorHeight: tileHeight * .6,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        color: AppColors.black,
                      ),
                      decoration: InputDecoration(
                        border: typeFieldBorder,
                        focusedBorder: typeFieldBorder,
                        contentPadding: EdgeInsets.only(bottom: - tileHeight * .2),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الحقل مطلوب';
                        } else {
                          return null;
                        }
                      },
                      onFieldSubmitted: (value) {
                        if(value.isEmpty){
                          _controller.text = type.name!;
                        }else{
                          //call edit function
                        }
                        ref.read(editingType(key).notifier).state = false;
                      },
                    ),
                  ),
                  SizedBox(
                    width: tileWidth * .125,
                    height: tileHeight * .9,
                    child: FloatingActionButton(
                      onPressed: () {
                        ref.read(editingType(key).notifier).state = false;
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: Colors.redAccent,
                      elevation: 2,
                      hoverElevation: 0,
                      highlightElevation: 0,
                      splashColor: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.keyboard_arrow_left,
                        color: AppColors.black,
                      ),
                      Text(
                        type.name!,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 20,
                            color: AppColors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: tileWidth * .125,
                  height: tileHeight * .9,
                  child: FloatingActionButton(
                    onPressed: () {
                      focusNode.requestFocus();
                      ref.read(editingType(key).notifier).state = true;
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    hoverElevation: 0,
                    highlightElevation: 0,
                    splashColor: AppColors.lightGreen,
                    child: const Icon(
                      Icons.edit,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
