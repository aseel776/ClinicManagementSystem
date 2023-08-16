import 'package:flutter_riverpod/flutter_riverpod.dart';

//controlling pagination
final previousPageFlag = StateProvider<bool>((ref) => false);
final nextPageFlag = StateProvider<bool>((ref) => true);
final currentPageProvider = StateProvider((ref) => 0);
final totalPagesProvider = StateProvider((ref) => 1);