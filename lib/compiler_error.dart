import 'package:ansicolor/ansicolor.dart';

import 'characters/position.dart';

/// A [CompilerError] is an error thrown by a Compiler. It has functionality for
/// marking source code locations
class CompilerError implements Error {

  /// The [message] of the error
  final String message;

  /// The name of the [CompilerError]
  final String exceptionName;

  /// The details of the [CompilerError]
  final String details;

  /// The start position of the [CompilerError]
  final Position start;

  /// The end position of the [CompilerError]
  final Position end;

  /// The marker of the Error
  final ErrorMarker marker;

  /// The cause of the [CompilerError]
  final Error? cause;

  @override
  late final StackTrace stackTrace;


  /// Constructor for [CompilerError]
  ///
  /// @param message the message of the exception _(Value for [CompilerError.message])_
  /// @param marker the marker of the exception _(Value for [CompilerError.marker])_
  /// @param exceptionName the name of the exception _(Value for [CompilerError.exceptionName])_
  /// @param details the details of the exception _(Value for [CompilerError.details])_
  /// @param start the start position of the exception _(Value for [CompilerError.start])_
  /// @param end the end position of the exception _(Value for [CompilerError.end])_
  /// @param cause the cause for the exception
  CompilerError (
    this.message,
    this.marker,
    this.exceptionName,
    this.details,
    this.start,
    this.end,
    [this.cause]
  ) : super() {
    stackTrace = StackTrace.current;
  }


  /// Constructor for [CompilerError]
  ///
  /// @param message the message of the exception _(Value for [CompilerError.message])_
  /// @param marker the marker of the exception _(Value for [CompilerError.marker])_
  /// @param exceptionName the name of the exception _(Value for [CompilerError.exceptionName])_
  /// @param details the details of the exception _(Value for [CompilerError.details])_
  /// @param map the position map to resolve start and end _(Value for [CompilerError.start])_
  /// @param start the start position of the exception _(Value for [CompilerError.start])_
  /// @param end the end position of the exception _(Value for [CompilerError.end])_
  /// @param cause the cause for the exception
  CompilerError.fromInts (
    String message,
    ErrorMarker marker,
    String exceptionName,
    String details,
    PositionMap map,
    int start,
    int end,
    [Error? cause]
  ) : this(
    message,
    marker,
    exceptionName,
    details,
    map.resolve(start),
    map.resolve(end),
    cause
  );


  /// Constructor for [CompilerError]
  ///
  /// @param message the message of the exception _(Value for [CompilerError.message])_
  /// @param exceptionName the name of the exception _(Value for [CompilerError.exceptionName])_
  /// @param details the details of the exception _(Value for [CompilerError.details])_
  /// @param start the start position of the exception _(Value for [CompilerError.start])_
  /// @param end the end position of the exception _(Value for [CompilerError.end])_
  /// @param cause the cause for the exception
  CompilerError.simple(
    String message,
    String exceptionName,
    String details,
    Position start,
    Position end,
    [Error? cause]
  ) : this(message, ErrorMarker.createPositionMarker(start, end), exceptionName, details, start, end, cause);


  /// Constructor for [CompilerError]
  ///
  /// @param message the message of the exception _(Value for [CompilerError.message])_
  /// @param exceptionName the name of the exception _(Value for [CompilerError.exceptionName])_
  /// @param details the details of the exception _(Value for [CompilerError.details])_
  /// @param map the position map to resolve start and end _(Value for [CompilerError.start])_
  /// @param start the start position of the exception _(Value for [CompilerError.start])_
  /// @param end the end position of the exception _(Value for [CompilerError.end])_
  /// @param cause the cause for the exception
  CompilerError.fromSimpleInt(
    String message,
    String exceptionName,
    String details,
    PositionMap map,
    int start,
    int end,
    [Error? cause]
  ) : this.simple(
    message,
    exceptionName,
    details,
    map.resolve(start),
    map.resolve(end),
    cause
  );

  /// Stringify the [CompilerError]
  @override
  String toString() {
    return message;
  }

  void printStackTrace() {
    print(this);
    print(stackTrace);
    if(cause != null) {
      print("Caused by: ");
      if(cause is CompilerError) {
        (cause as CompilerError).printStackTrace();
      } else {
        print(cause);
        print(cause!.stackTrace);
      }
    }
  }
}


/// A marker for the position of the [CompilerError]
class ErrorMarker {

  /// The source of the [ErrorMarker]
  final String source;

  /// The colored preview of the [ErrorMarker]
  final String colorPreview;

  /// The preview of the [ErrorMarker]
  final String preview;

  /// The marker of the [ErrorMarker]
  final String marker;

  ErrorMarker(this.source, this.colorPreview, this.preview, this.marker);

  /// Generate the [ErrorMarker] as a string
  String generateMarker() {
    return "at $source\n$preview\n$marker";
  }

  /// Generate the [ErrorMarker] as a string including console colors
  String generateColoredMarker() {
    return "at $source\n$colorPreview\n$marker";
  }

  /// Stringify the [CompilerError] (just the same as [ErrorMarker.generateMarker]
  String toString() {
    return generateMarker();
  }

  /// The maxLength for generated [ErrorMarker]s
  static final int maxLength = 60;

  /// Creates a [ErrorMarker]
  static ErrorMarker createPositionMarker(

    Position pos1,
    Position pos2,
    [int? maxLength]

  ) {
    maxLength ??= ErrorMarker.maxLength;
    final red = AnsiPen()..red(bg: true);

    try {

      // Check requirements
      if (pos1.source != pos2.source) throw "The two have to be located in the same source";
      if (pos1.line != pos2.line) throw "The two positions that should be marked have to be in the same line";
      if (pos1.column > pos2.column) throw "Position 1 must be before Position 2";


      // Line start (linenumber + 2 spaces)
      final String lineStr = pos1.line.toString() + "  ";

      // Length of the highlighted section
      final int highlighted = pos2.column - pos1.column + 1;

      // The maximum amount of characters that will be shown around the highlighted section
      final int maxAround = maxLength - highlighted - lineStr.length;
      final int before = ((maxAround / 2) + (maxAround % 2)) as int;
      final int after = (maxAround / 2) as int;


      // The available tokens before the highlighted section
      final int before2 = pos1.column - 1;

      // The available tokens after the highlighted section
      final int after2 = pos2.source.getAfterInLine(pos2);

      // Take the smallest value and use it
      int realBefore = smallest([before, before2]);
      int realAfter = smallest([after, after2 + 1]);

      // Get the differences (to display if there are tokens that can't be displayed)
      int beforeDif = before2 - realBefore;
      int afterDif = after2 - realAfter;

      // Resolve numbers if there is a non-displayed part
      if (beforeDif > 0) {
        final int baseLen = beforeDif.toString().length;
        var len = baseLen + 4;
        realBefore -= len.toString().length != baseLen ? ++len : len;
        beforeDif += len;
      }
      if (afterDif > 0) {
        final int baseLen = afterDif.toString().length;
        int len = baseLen + 4;
        realAfter -= len.toString().length != baseLen ? ++len : len;
        afterDif += len;
      }

      // The start of the line
      final String start = (lineStr
      + (beforeDif > 0 ? "+$beforeDif..." : "")
      + pos1.source.source.get(pos1.index - realBefore, pos1.index)
              .join("")
              .replaceAll("\t", " "));

      // The end of the line
      final String end = (pos1.source.source.get(pos2.index + 1, pos2.index + realAfter)
          .join("")
          .replaceAll("\t", " ")
          .replaceAll("\n", " ")
        + (afterDif > 0 ? "...+$afterDif" : ""));

      // Generate end-string
      return ErrorMarker(
        "${pos1.source.location}:${pos1.line}:${pos1.column}",
        start + red(pos1.source.source.get(pos1.index, pos2.index + 1).join("")) + end,
        start + pos1.source.source.get(pos1.index, pos2.index + 1).join("") + end,
        (' ' * start.length) + ('^' * highlighted)
      );
    } catch (e) {
      print("Error while creating position marker:");
      print(e);
      return ErrorMarker(
        "${pos1.source.location}:${pos1.line}:${pos1.column}",
        red("Error while creating position marker: $e"),
        "Error while creating position marker: $e",
        ""
      );
  }
  }
}

int smallest(List<int> arr) {
  int smallest = arr[0];
  for (int i = 1; i < arr.length; i++) {
    if (arr[i] < smallest) smallest = arr[i];
  }
  return smallest;
}