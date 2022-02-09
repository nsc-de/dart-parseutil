library parseutils_characters;

final String base16chars = "0123456789abcdef";

bool isHexChar(String c) {
  int code = c.codeUnitAt(0);
  return (code >= 0x30 && code <= 0x39) ||
      (code >= 0x41 && code <= 0x46) ||
      (code >= 0x61 && code <= 0x66);
}

bool isNumericCharacter(String c) {
  int code = c.codeUnitAt(0);
  return code >= 0x30 && code <= 0x39;
}

bool isNumericOrDotCharacter(String c) {
  int code = c.codeUnitAt(0);
  return code >= 0x30 && code <= 0x39 || code == 0x2E;
}

bool isWhitespaceCharacters(String c) {
  return c == "\r" || c == "\t" || c == " ";
}

bool isWhitespaceCharacterNoNewline(String c) {
  return c == "\r" || c == "\t" || c == " " || c == "\n";
}

bool isIdentifierCharacter(String c) {
  int code = c.codeUnitAt(0);
  return (code >= 0x30 && code <= 0x39) ||
      (code >= 0x41 && code <= 0x5A) ||
      (code >= 0x61 && code <= 0x7A) ||
      code == 0x5F;
}

bool isIdentifierStartCharacter(String c) {
  int code = c.codeUnitAt(0);
  return (code >= 0x41 && code <= 0x5A) ||
      (code >= 0x61 && code <= 0x7A) ||
      code == 0x5F;
}

String parseString(String s) {
  StringBuffer sb = StringBuffer();
  int i = 0;
  while (i < s.length) {
    String c = s[i];
    if (c == "\\") {
      i++;
      if (i >= s.length) {
        throw "Invalid escape sequence";
      }
      c = s[i];
      if (c == "n") {
        sb.write("\n");
      } else if (c == "r") {
        sb.write("\r");
      } else if (c == "t") {
        sb.write("\t");
      } else if (c == "b") {
        sb.write("\b");
      } else if (c == "f") {
        sb.write("\f");
      } else if (c == "v") {
        sb.write("\v");
      } else if (c == "0") {
        sb.write("0");
      } else if (c == "\\") {
        sb.write("\\");
      } else if (c == "\"") {
        sb.write("\"");
      } else if (c == "u") {
        i++;
        if (i >= s.length) {
          throw "Invalid escape sequence";
        }
        String hex = s.substring(i, i + 2);
        if (!isHexChar(hex)) {
          throw "Invalid escape sequence";
        }
        int code = int.parse(hex, radix: 16);
        sb.writeCharCode(code);
        i += 2;
      } else {
        throw "Invalid escape sequence";
      }
    } else {
      sb.write(c);
    }
    i++;
  }
  return sb.toString();
}

String escapeString(String s) {
  StringBuffer sb = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    String c = s[i];
    sb.write(escapeCharacter(c));
  }
  return sb.toString();
}

String escapeCharacter(String c) {
  if(c == "\n") {
    return "\\n";
  }
  if(c == "\r") {
    return "\\r";
  }
  if(c == "\t") {
    return "\\t";
  }
  if(c == "\b") {
    return "\\b";
  }
  if(c == "\f") {
    return "\\f";
  }
  if(c == "\v") {
    return "\\v";
  }
  if(c == "\\") {
    return "\\\\";
  }
  if(c == "\"") {
    return "\\\"";
  }
  if(c == "\$") {
    return "\\\$";
  }
  if(c.codeUnitAt(0) <= 0xFF) {
    return "\\u" + toUnicode(c);
  }
  return c;
}

String toUnicode(String c) {
  int code = c.codeUnitAt(0);
  String hex = base16chars[(code >> 12) & 0xF] +
      base16chars[(code >> 8) & 0xF] +
      base16chars[(code >> 4) & 0xF] +
      base16chars[code & 0xF];
  return hex;
}


String getBase16Character(int number) {
  if(number < 0 || number > 15) {
    throw "Invalid base16 number";
  }
  return base16chars[number];
}

String ushortToBase16(int number, int length) {
  StringBuffer sb = StringBuffer();
  for(int i = 0; i < length; i++) {
    sb.write(getBase16Character(number & 0xF));
    number >>= 4;
  }
  return sb.toString().split('').reversed.join();
}