import 'package:parseutil/characters/position/position_map.dart';

class Position {

  final PositionMap source;

  final int index;
  final int line;
  final int column;

  Position(this.source, this.index, this.line, this.column);

  Position copy() {
    return Position(source, index, line, column);
  }

  String toString() {
    return '$source:$line:$column';
  }
}