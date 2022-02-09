/// A CharacterSource provides characters
///
/// @author [Nicolas Schmidt &lt;@nsc-de&gt;](https://github.com/nsc-de)
abstract class CharacterSource {

  /// The contents of the [CharacterSource]
  abstract final List<String> all;

  /// The length of the [CharacterSource]
  abstract final int length;

  /// The location the characters are from (e.g. file location)
  abstract final String location;

  /// Get a range of characters from the [CharacterSource] as a [CharArray]
  ///
  /// @param start the start index for the characters
  /// @param end the end index for the characters
  ///
  /// @author [Nicolas Schmidt &lt;@nsc-de&gt;](https://github.com/nsc-de)
  List<String> get(int start, int end);

  /// Create a [CharacterSource] from a source String
  ///
  /// @param contents the contents of the [CharacterSource]
  /// @param source the source of the characters (e.g. file name)
  ///
  /// @author [Nicolas Schmidt &lt;@nsc-de&gt;](https://github.com/nsc-de)
  static CharacterSource from(String contents, String source) {
    return _CharacterSource(contents, source);
  }

}

class _CharacterSource extends CharacterSource {

  final List<String> _all;
  final String _location;

  _CharacterSource(String contents, String source)
      : _all = contents.split(''),
        _location = source;

  @override
  List<String> get all => _all;

  @override
  List<String> get(int start, int end) {
    return _all.sublist(start, end);
  }

  @override
  int get length => _all.length;

  @override
  String get location => _location;

}