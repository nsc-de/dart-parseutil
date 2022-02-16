import 'package:parseutil/characters/position.dart';
import 'package:parseutil/lexer/token/token.dart';

/// A [TokenInputStream] provides the [Token]s for a Parser. It is
/// created by the [io.github.shakelang.shake.lexer.Lexer]
abstract class TokenInputStream<TT extends TokenType, T extends Token<TT>> {

  /// The source (mostly filename) of the [TokenInputStream]
  abstract final String source;

  /// The map for the token-positions
  /// We have this map to resolve the column / line of an index. This is useful for error-generation.
  abstract final PositionMap map;

  /// The position that the TokenInputStream is actually at
  abstract int position;

  /// Checks if the [TokenInputStream] has left a given number of tokens
  ///
  /// @param num the number of tokens to check
  /// @return has the [TokenInputStream] left the given amount of [Token]s?
  bool has(int num);

  /// Checks if the [TokenInputStream] has a token left
  ///
  /// @return has the [TokenInputStream] another [Token] left?
  bool hasNext(){
    return has(1);
  }

  /// Returns the next token of the [TokenInputStream] (and skips)
  ///
  /// @return the next token
  T next() {
    // skip to next token and then return the actual token
    skip();
    return actual;
  }

  /// Returns the type of the next token of the [TokenInputStream] (and skips)
  ///
  /// @return the next token
  TT nextType() {
    // skip to next token and then return the actual token
    skip();
    return actualType;
  }

  /// Returns the next token of the [TokenInputStream]
  ///
  /// @return the next token
  String? nextValue() {
    // skip to next token and then return the actual token
    skip();
    return actualValue;
  }

  /// Skips the next tokens token
  void skip([int amount = 1]);

  /// Returns the actual [Token]
  ///
  /// @return The actual [Token]
  abstract final T actual;

  /// Gives the type of the actual token
  TT get actualType => actual.type;

  /// Gives the start of the actual token
  int get actualStart => actual.start;

  /// Gives the end of the actual token
  int get actualEnd => actual.end;

  /// Gives the value of the actual token
  String? get actualValue => actual.value;

  /// Checks if the actual token without changing the actual token
  bool get actualHasValue => actualValue != null;

  /// Returns the next [Token]
  ///
  /// @return The next [Token]
  T peek([int offset = 1]);

  /// Peek the token type at the given index
  TT peekType([int offset = 1]) {
    return peek(offset).type;
  }

  /// Peek the token start at the given index
  int peekStart([int offset = 1]) {
    return peek(offset).start;
  }

  /// Peek the token end at the given index
  int peekEnd([int offset = 1]) {
  return peek(offset).end;
  }

  /// Peek the token value at the given index
  String? peekValue([int offset = 1]) {
    return peek(offset).value;
  }

  /// Checks if the token at the given offset of the [TokenInputStream] has a value without changing the actual token
  bool peekHasValue([int offset = 1]) {
    return peekValue(offset) != null;
  }
}