import 'character_source.dart';

/// A marker that points to a position in a string.
abstract class PositionMarker {

  /// The index of the position
  abstract final int index;

  /// The column of the position
  abstract final int column;

  /// The line of the position
  abstract final int line;

}

class Position implements PositionMarker {

  final PositionMap source;

  @override
  final int index;

  @override
  final int line;

  @override
  final int column;

  Position(this.source, this.index, this.line, this.column);

  Position copy() {
    return Position(source, index, line, column);
  }

  @override
  String toString() {
    return '$source:$line:$column';
  }
}

abstract class PositionMap {
  abstract final CharacterSource source;
  abstract final List<int> lineSeparators;
  abstract final String location;
  Position resolve(int index);
  int getAfterInLine(Position p);
}

class PositionMapImpl implements PositionMap {

  @override
  final CharacterSource source;

  @override
  final List<int> lineSeparators;

  @override
  get location => source.location;

  PositionMapImpl(this.source, this.lineSeparators);

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

class PositionMaker implements PositionMap, PositionMarker {

  int _index;
  int _line;
  int _column;

  final List<int> _lineSeparators = [];

  @override
  final CharacterSource source;

  PositionMaker(this.source, [this._index = 0, this._line = 1, this._column = 1]);

  @override
  int get column => _column;

  @override
  int get index => _index;

  @override
  int get line => _line;

  @override
  List<int> get lineSeparators => _lineSeparators;

  @override
  String get location => source.location;

  void nextColumn() {
    _index++;
    _column++;
  }

  void nextLine() {
    _lineSeparators.add(++_index);
    _line++;
    _column = 1;
  }

  PositionMap createPositionMap() {
    return PositionMapImpl(source, _lineSeparators);
  }

  Position createPositionAtLocation() {
    return Position(createPositionMap(), _index, _line, _column);
  }

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