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
  // TODO
  // Planned search parameters:
  // date:
  // duration:

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

      final isExcluded = iterator.current is OperatorToken &&
          (iterator.current as OperatorToken).value == OperatorEnum.exclude;
      if (isExcluded) {
        iterator.advance();
      }

      if (iterator.current is StringToken) {
        final value = (iterator.current as StringToken).value;
        iterator.advance(); // consume value
        final node = ParameterNode(keyword.label, value);
        if (isExcluded) {
          return ExcludeNode(node);
        }
        return node;
      } else {
        // keyword not followed by string
        return null;
      }
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
}
