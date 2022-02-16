abstract class TokenType {

  abstract final bool hasValue;
  abstract final String name;
  int length(String value);

}

class Token<TokenType> {

  final TokenType type;
  final String? value;
  final int start;
  final int end;


  Token(this.type, this.value, this.start, this.end);

  @override
  String toString() {
    return start == end ?
      (value != null ?
        "Token{type=$type, value=$value, position=$start}" :
        "Token{type=$type, position=$start}"
      ) : value != null ?
      "Token{type=$type, value=$value, start=$start, end=$end}" :
      "Token{type=$type, position=$start, end=$end}";
  }

  @override
  bool equals(dynamic other) {
    if (this == other) return true;
    if(other is TokenType) return other == type;
    if (other == null || other !is Token) return false;
    return type == other.type && value == other.value;
  }

  @override
  int get hashCode => Object.hashAll([type, value, start, end]);

}