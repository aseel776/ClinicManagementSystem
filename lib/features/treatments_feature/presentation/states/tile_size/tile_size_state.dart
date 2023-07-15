import 'package:equatable/equatable.dart';

class TileSizeState extends Equatable{
  final double width;
  final double height;

  const TileSizeState(this.width, this.height);

  @override
  List<Object> get props => [width, height];
}

class NormalTileSizeState extends TileSizeState{
  const NormalTileSizeState(width, height): super (width, height);
}

class ScaledTileSizeState extends TileSizeState{
  const ScaledTileSizeState(width, height): super (width * 1.125, height * 1.125);
}