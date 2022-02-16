import 'package:parseutil/characters/position.dart';
import 'package:parseutil/lexer/token/token.dart';

/// A [TokenInputStream] provides the [Token]s for a Parser. It is
/// created by a lexer
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

/// A [TokenBasedTokenInputStream] provides the [Token]s for a Parser. It is
/// created by a lexer
class TokenBasedTokenInputStream<TT extends TokenType, T extends Token<TT>> extends TokenInputStream<TT, T> {

  /// The tokenTypes that are contained in the [TokenBasedTokenInputStream]
  final List<T> tokens;

  /// Map to resolve the column / line of an index.
  /// This is useful for error-generation.
  final PositionMap map;

  TokenBasedTokenInputStream(this.tokens, this.map);

  get source => map.source.location;

  /// Get a specific token from the [DataBasedTokenInputStream]
  ///
  /// @param position the position to get
  /// @return the token at the given position
  T get(int position) {
    return tokens[position];
  }

  /// Get the type of specific token from the [DataBasedTokenInputStream] by its position
  ///
  /// @param position the position to get
  /// @return the token at the given position
  TT getType(int position) {
    return get(position).type;
  }

  /// Get the start of specific token from the [DataBasedTokenInputStream] by its position
  ///
  /// @param position the position to get
  /// @return the token at the given position
  int getStart(int position) {
    return get(position).start;
  }

  /// Get the end of specific token from the [DataBasedTokenInputStream] by it's position
  ///
  /// @param position the position to get
  /// @return the token at the given position
  int getEnd(int position) {
    return get(position).end;
  }

  /// Get the value of specific token from the [DataBasedTokenInputStream] by it's position
  ///
  /// @param position the position to get
  /// @return the token at the given position
  String? getValue(int position) {
    return get(position).value;
  }

  /// Check if specific token from the [DataBasedTokenInputStream] has a value (by it's position)
  ///
  /// @param position the position to get
  /// @return the token at the given position
  bool getHasValue(int position) {
    return getValue(position) != null;
  }

  @override
  int position = -1;

  @override
  bool has(int num) {
    return position + num < tokens.length;
  }

  @override
  T next() {
    if(!hasNext()) "Not enough tokens left";
    return tokens[++position];
  }

  @override
  void skip([int amount = 1]) {
    if(!has(amount)) throw "Not enough tokens left";
    position += amount;
  }

  @override
  bool hasNext() {
    return has(1);
  }

  @override
  T peek([int offset = 1]) {
    if(!has(offset)) throw "Not enough tokens left";
    return tokens[position + offset];
  }

  @override
  get actual => tokens[position];

  void reset() {
    position = -1;
  }

  @override
  String toString() {
    return "TokenBasedTokenInputStream(source='$source', tokens=$tokens, position=$position)";
  }

}