import 'package:string_scanner/string_scanner.dart';

abstract class Token {
  const Token();

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

class StringToken extends Token {
  final String value;
  const StringToken(this.value);

  @override
  String toString() {
    return 'StringToken("$value")';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StringToken &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

enum OperatorEnum {
  and('&'),
  or('|'),
  exclude('-');

  const OperatorEnum(this.character);
  final String character;
}

class OperatorToken extends Token {
  final OperatorEnum value;
  const OperatorToken(this.value);

  @override
  String toString() {
    return 'OperatorToken(${value.name})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperatorToken &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

enum KeywordEnum {
  path('path'),
  date('date'),
  duration('duration');

  const KeywordEnum(this.label);
  final String label;
}

class KeywordToken extends Token {
  final KeywordEnum value;
  const KeywordToken(this.value);

  @override
  String toString() {
    return 'KeywordToken(${value.name})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeywordToken &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class WhitespaceToken extends Token {
  const WhitespaceToken();

  @override
  String toString() {
    return 'WhitespaceToken';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WhitespaceToken && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0; // Singleton-like, no distinct state
}

class EOFToken extends Token {
  const EOFToken();

  @override
  String toString() {
    return 'EOFToken';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EOFToken && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0; // Singleton-like, no distinct state
}

class SearchExpressionTokenizer {
  List<Token> tokenize(String query) {
    final scanner = StringScanner(query);
    final tokens = <Token>[];

    while (!scanner.isDone) {
      if (scanner.matches(' ')) {
        tokens.add(const WhitespaceToken());
        while (!scanner.isDone && scanner.matches(' ')) {
          scanner.readChar();
        }
      } else if (scanner.scan('&')) {
        tokens.add(const OperatorToken(OperatorEnum.and));
      } else if (scanner.scan('|')) {
        tokens.add(const OperatorToken(OperatorEnum.or));
      } else if (scanner.scan('-')) {
        tokens.add(const OperatorToken(OperatorEnum.exclude));
      } else if (scanner.scan('path:')) {
        tokens.add(const KeywordToken(KeywordEnum.path));
      } else if (scanner.scan('date:')) {
        tokens.add(const KeywordToken(KeywordEnum.date));
      } else if (scanner.scan('duration:')) {
        tokens.add(const KeywordToken(KeywordEnum.duration));
      } else if (scanner.scan('"')) {
        final buffer = StringBuffer();
        while (!scanner.scan('"')) {
          if (scanner.isDone) {
            //TODO: unclosed quote
            break;
          }
          buffer.writeCharCode(scanner.readChar());
        }
        tokens.add(StringToken(buffer.toString()));
      } else if (scanner.scan("'")) {
        final buffer = StringBuffer();
        while (!scanner.scan("'")) {
          if (scanner.isDone) {
            //TODO: unclosed quote
            break;
          }
          buffer.writeCharCode(scanner.readChar());
        }
        tokens.add(StringToken(buffer.toString()));
      } else {
        final buffer = StringBuffer();
        while (!scanner.isDone &&
            !scanner.matches(' ') &&
            !scanner.matches('&') &&
            !scanner.matches('|')) {
          buffer.writeCharCode(scanner.readChar());
        }
        tokens.add(StringToken(buffer.toString()));
      }
    }

    tokens.add(const EOFToken());
    return tokens;
  }
}
