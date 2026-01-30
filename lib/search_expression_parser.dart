import 'package:path/path.dart';
import 'package:syncopathy/search_expression_ast.dart';
import 'package:syncopathy/search_expression_lexer.dart';

class TokenIterator {
  final List<Token> _tokens;
  int _currentIndex = 0;

  TokenIterator(List<Token> tokens)
    : _tokens = tokens.where((t) => t is! WhitespaceToken).toList();

  Token get current => _tokens[_currentIndex];
  bool get isDone => current is EOFToken;

  void advance() {
    if (!isDone) {
      _currentIndex++;
    }
  }
}

class SearchExpressionParser {
  final SearchExpressionTokenizer _tokenizer = SearchExpressionTokenizer();

  RootNode parse(String query) {
    var tokens = _tokenizer.tokenize(query);
    var iterator = TokenIterator(tokens);
    final expression = _parseOrExpression(iterator);
    return RootNode(expression != null ? [expression] : []);
  }

  SearchExpressionNode? _parseOrExpression(TokenIterator iterator) {
    final expressions = <SearchExpressionNode>[];

    while (!iterator.isDone) {
      var expression = _parseAndExpression(iterator);
      if (expression != null) {
        expressions.add(expression);
      }

      if (iterator.isDone) break;

      if (iterator.current is OperatorToken &&
          (iterator.current as OperatorToken).value == OperatorEnum.or) {
        iterator.advance(); // consume |
      } else {
        // This means we have an implicit AND here, but our grammar says | is top level.
        // So we are done with the OR expression.
        break;
      }
    }

    if (expressions.isEmpty) return null;
    if (expressions.length == 1) return expressions.first;
    return OrNode(expressions);
  }

  SearchExpressionNode? _parseAndExpression(TokenIterator iterator) {
    final terms = <SearchExpressionNode>[];
    while (!iterator.isDone &&
        !(iterator.current is OperatorToken &&
            (iterator.current as OperatorToken).value == OperatorEnum.or)) {
      final term = _parseTerm(iterator);
      if (term != null) {
        terms.add(term);
      }
    }

    if (terms.isEmpty) {
      return null;
    }
    if (terms.length == 1) {
      return terms.first;
    }
    return AndNode(terms);
  }

  SearchExpressionNode? _parseTerm(TokenIterator iterator) {
    if (iterator.isDone) return null;

    if (iterator.current is OperatorToken &&
        (iterator.current as OperatorToken).value == OperatorEnum.exclude) {
      iterator.advance(); // consume '-'
      // No naked exclude
      if (iterator.isDone || iterator.current is OperatorToken) {
        return null;
      }
      final child = _parseTerm(iterator);
      return child != null ? ExcludeNode(child) : null;
    }

    if (iterator.current is KeywordToken) {
      final keyword = (iterator.current as KeywordToken).value;
      iterator.advance(); // consume keyword

      final isExcluded =
          iterator.current is OperatorToken &&
          (iterator.current as OperatorToken).value == OperatorEnum.exclude;
      if (isExcluded) {
        iterator.advance();
      }

      SearchExpressionNode? node;
      if (keyword == KeywordEnum.date) {
        node = _parseDate(iterator);
      } else if (keyword == KeywordEnum.duration) {
        node = _parseDuration(iterator);
      } else if (keyword == KeywordEnum.played) {
        node = _parsePlayedCount(iterator);
      } else if (iterator.current is StringToken) {
        final value = (iterator.current as StringToken).value;
        iterator.advance(); // consume value
        node = ParameterNode(keyword.label, value);
      } else {
        // keyword not followed by string
        return null;
      }

      if (node == null) return null;

      if (isExcluded) {
        return ExcludeNode(node);
      }
      return node;
    }

    if (iterator.current is StringToken) {
      final value = (iterator.current as StringToken).value;
      iterator.advance();
      return StringNode(value);
    }

    // unexpected token, advance to avoid infinite loop
    iterator.advance();
    return null;
  }

  DateNode? _parseDate(TokenIterator iterator) {
    if (iterator.current is! StringToken) return null;

    final value = (iterator.current as StringToken).value;
    iterator.advance();

    final operator = _parseRelationalOperator(value);
    final dateValue = value.substring(
      operator == RelationalOperator.equal
          ? 0
          : (operator == RelationalOperator.greaterOrEqual ||
                operator == RelationalOperator.lessOrEqual)
          ? 2
          : 1,
    );

    final parts = dateValue.split('-');
    if (parts.length != 3) return null;

    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);

    if (year == null || month == null || day == null) return null;
    if (month < 1 || month > 12) return null;
    if (day < 1 || day > 31) return null;

    try {
      return DateNode(operator, DateTime(year, month, day));
    } catch (e) {
      return null;
    }
  }

  DurationNode? _parseDuration(TokenIterator iterator) {
    if (iterator.current is! StringToken) return null;

    final value = (iterator.current as StringToken).value;
    iterator.advance();

    final operator = _parseRelationalOperator(value);
    final duration = _parseDurationValue(value);

    if (duration == null) return null;

    return DurationNode(operator, duration);
  }

  PlayedNode? _parsePlayedCount(TokenIterator iterator) {
    if (iterator.current is! StringToken) return null;

    final value = (iterator.current as StringToken).value;
    iterator.advance();

    final operator = _parseRelationalOperator(value);
    final valueInt = _parseIntegerValue(value);

    if (valueInt == null) return null;

    return PlayedNode(operator, valueInt);
  }

  int? _parseIntegerValue(String value) {
    value = value.replaceAll(">", "");
    value = value.replaceAll("<", "");
    value = value.replaceAll("=", "");
    return int.tryParse(value);
  }

  RelationalOperator _parseRelationalOperator(String value) {
    if (value.startsWith('>=')) {
      return RelationalOperator.greaterOrEqual;
    } else if (value.startsWith('<=')) {
      return RelationalOperator.lessOrEqual;
    } else if (value.startsWith('>')) {
      return RelationalOperator.greater;
    } else if (value.startsWith('<')) {
      return RelationalOperator.less;
    } else {
      return RelationalOperator.equal;
    }
  }

  Duration? _parseDurationValue(String value) {
    final re = RegExp(r'(\d+)([smh])');
    final match = re.firstMatch(value);
    if (match == null) return null;

    final num = int.parse(match.group(1)!);
    final unit = match.group(2)!;

    switch (unit) {
      case 's':
        return Duration(seconds: num);
      case 'm':
        return Duration(minutes: num);
      case 'h':
        return Duration(hours: num);
      default:
        return null;
    }
  }
}
