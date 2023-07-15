import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './tile_size_state.dart';

final tileProvider = StateNotifierProvider.family<TileSizeNotifier,
        TileSizeState, Tuple3<double, double, Key?>>(
    (ref, tuple) => TileSizeNotifier(tuple.value1, tuple.value2));

class TileSizeNotifier extends StateNotifier<TileSizeState> {
  TileSizeNotifier(width, height) : super(TileSizeState(width, height));

  TileSizeState scale(){
    if (state is ScaledTileSizeState){
      return state;
    }
    state = ScaledTileSizeState(state.width, state.height);
    return state;
  }

  TileSizeState unscale(){
    if (state is NormalTileSizeState){
      return state;
    }
    state = NormalTileSizeState(state.width / 1.125, state.height / 1.125);
    return state;
  }
}
