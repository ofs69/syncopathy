abstract class Token {
  const Token();
}

class StringToken extends Token {
  final String value;
  const StringToken(this.value);
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
}

class WhitespaceToken extends Token {
  const WhitespaceToken();
}

class EOFToken extends Token {
  const EOFToken();
}

class SearchExpressionTokenizer {
  final StringBuffer _tmpBuffer = StringBuffer();

  List<Token> tokenize(String query) {
    var tokens = List<Token>.empty(growable: true);
    RuneIterator runeIterator = query.runes.iterator;
    _tmpBuffer.clear();

    while (runeIterator.moveNext()) {
      var currentCharacter = runeIterator.currentAsString;
    }

    return tokens;
  }
}
