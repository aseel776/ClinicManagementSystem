import 'package:clinic_management_system/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Pages/medicine_page.dart';
import '../riverpod/medicines/medicines_provider.dart';

class Searchbar extends ConsumerStatefulWidget {
  const Searchbar({super.key});

  @override
  ConsumerState<Searchbar> createState() => _SearchbarState();
}

final SearchBarProvider = StateProvider<int>((ref) => 0);

class _SearchbarState extends ConsumerState<Searchbar>
    with SingleTickerProviderStateMixin {
  AnimationController? _con;
  @override
  void initState() {
    super.initState();
    _con = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 375));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.35,
      alignment: const Alignment(1, -2.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 375),
        height: 42.0,
        width: (ref.watch(SearchBarProvider) == 0)
            ? 48.0
            : MediaQuery.of(context).size.width * 0.35,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: (ref.watch(SearchBarProvider) == 0)
              ? null
              : Border.all(color: AppColors.black.withOpacity(0.3)),
          boxShadow: (ref.watch(SearchBarProvider) == 0)
              ? null
              : const [
                  BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 1.0,
                      blurRadius: 4.0,
                      offset: Offset(7.0, 5.0))
                ],
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 375),
              left: (ref.watch(SearchBarProvider) == 0) ? 20.0 : 43.0,
              top: 13.0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: (ref.watch(SearchBarProvider) == 0) ? 0.0 : 1.0,
                child: SizedBox(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: TextField(
                    textDirection: TextDirection.ltr,
                    cursorRadius: const Radius.circular(10),
                    onChanged: (search) {
                      print("11111111111111111111111");
                      ref
                          .watch(medicinesProvider.notifier)
                          .getSearchMedicines(6, 1, search);
                      ref.watch(currentPageMedicines.notifier).state = 1;
                    },
                    cursorWidth: 2.0,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: "Search",
                        labelStyle: const TextStyle(
                            color: Color(0xff5b5b5b),
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none)),
                  ),
                ),
              ),
            ),
            Container(
                width: 48,
                height: 50,
                decoration: BoxDecoration(
                    color: const Color(0xFFAFC8C6),
                    borderRadius: BorderRadius.circular(14)),
                child: IconButton(
                    onPressed: () {
                      if (ref.watch(SearchBarProvider) == 0) {
                        ref.read(SearchBarProvider.notifier).state = 1;
                        _con!.forward();
                      } else {
                        ref.read(SearchBarProvider.notifier).state = 0;
                        _con!.reverse();
                      }
                    },
                    icon: const Icon(Icons.search)))
          ],
        ),
      ),
    );
  }
}
