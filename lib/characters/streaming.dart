import 'position.dart';
import 'character_source.dart';

/// A [CharacterInputStream] provides the characters for a Lexer
///
/// @author [Nicolas Schmidt &lt;@nsc-de&gt;](https://github.com/nsc-de)
///
/// @see SourceCharacterInputStream
abstract class CharacterInputStream {

  /// Returns the source of the [CharacterInputStream]
  abstract final CharacterSource source;

  /// Returns the chars of the [CharacterInputStream]
  abstract final List<String> content;

  /// Returns the actual position of the [CharacterInputStream]
  abstract final int position;

  /// Returns the actual position-maker of the [CharacterInputStream]
  abstract final PositionMaker positionMaker;

  /// Checks if the [CharacterInputStream] has a next character left
  bool hasNext();

  /// Checks if the [CharacterInputStream] has a given number of characters left
  bool has(int number);

  /// Returns the next character and continues to the next token
  String next();

  /// Skips a given number of characters
  void skip([int number = 0]);

  /// Returns the actual character (the same as returned by [.next] when used before)
  String actual();

  /// Gives back a character of the [CharacterInputStream]
  /// (relative to the actual position)
  String peek([int num = 1]);
}

/// An implementation of [CharacterInputStream] using a [CharacterSource]
class SourceCharacterInputStream implements CharacterInputStream {

  @override
  final CharacterSource source;

  /// The actual position of the [SourceCharacterInputStream]
  @override
  late final PositionMaker positionMaker;

  /// the actual position of the [CharacterInputStream]
  @override
  get position => positionMaker.index;

  /// Returns the chars of the [CharacterInputStream]
  @override
  get content => source.all;

  /// Creates a new [SourceCharacterInputStream]
  SourceCharacterInputStream(this.source) {
    positionMaker = PositionMaker(source);
  }

  /// Checks if the [CharacterInputStream] has a next character left
  @override bool hasNext() {
    return positionMaker.index + 1 < source.length;
  }

  /// Checks if the [CharacterInputStream] has a given number of characters left
  @override
  bool has(int number) {
  if (number < 1) throw "The given number must be 1 or bigger";
  return positionMaker.index + number < source.length;
  }

  /// Returns the next character and continues to the next token
   @override
   String next() {
    skip();
    return actual();
  }

  /// Skips a given number of characters
  @override
  void skip([int number = 1]) {
    for (int i = 0; i < number; i++) {
      if (peek() == '\n') {
        positionMaker.nextLine();
      } else {
        positionMaker.nextColumn();
      }
    }
  }

  /// Returns the actual character (the same as returned by [.next] when used before)
  @override
  String actual() {
    return content[position];
  }

  /// Gives back the next character at the given position without skipping
  @override
  String peek([int num = 1]) {
    if (!has(num)) {
      throw "Not enough characters left";
    }
    // return the content at the required position
    return content[position + num];
  }
}