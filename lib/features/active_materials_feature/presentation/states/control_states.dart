import 'package:flutter_riverpod/flutter_riverpod.dart';

final previousPageFlag = StateProvider<bool>((ref) => false);
final nextPageFlag = StateProvider<bool>((ref) => true);