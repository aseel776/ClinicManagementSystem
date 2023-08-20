import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editingProblemType = StateProvider.family<bool, Key?>((ref, key) => false);
final addingProblemType = StateProvider((ref) => false);