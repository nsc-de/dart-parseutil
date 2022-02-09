import 'package:parseutil/characters/position/position.dart';

import '../character_source.dart';

abstract class PositionMap {
  abstract final CharacterSource source;
  abstract final List<int> lineSeparators;
  abstract final String location;
  Position resolve(int index);
  int getAfterInLine(Position p);
}
class PositionMapImpl implements PositionMap {
  final CharacterSource source;
  final List<int> lineSeparators;
  final String location;
  PositionMapImpl(this.source, this.lineSeparators, this.location);

  @override
  Position resolve(int index) {
    int line = 0;
    int column = 0;
    for(int i = 0; i < lineSeparators.length; i++) {
      if(lineSeparators[i] > index) {
        break;
      }
      line++;
      column = index - lineSeparators[i];
    }
    return Position(this, index, line, column);
  }

  @override
  int getAfterInLine(Position p) {
    int line = p.line;
    int column = p.column;
    if(line - 1 == lineSeparators.length) {
      return source.length - column;
    }
    return lineSeparators[line - 1] - p.index;
  }

}