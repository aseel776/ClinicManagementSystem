import 'package:flutter_riverpod/flutter_riverpod.dart';

//controlling pagination
final currentPageProvider = StateProvider((ref) => 1);
final totalPagesProvider = StateProvider((ref) => 1);
final previousPageFlag = StateProvider<bool>((ref) {
  int page = ref.watch(currentPageProvider);
  return page > 1;
});
final nextPageFlag = StateProvider<bool>((ref) {
  int page = ref.watch(currentPageProvider);
  int totalPages = ref.watch(totalPagesProvider);
  return page < totalPages;
});
//to control antiMaterials box at details pop-up
final isScrolling = StateProvider((ref) => false);
final isHovering = StateProvider((ref) => false);
