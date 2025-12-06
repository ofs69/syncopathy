import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/search_expression_lexer.dart';

void main() {
  group('SearchExpressionTokenizer', () {
    test('should tokenize a simple string', () {
      final tokenizer = SearchExpressionTokenizer();
      final tokens = tokenizer.tokenize('hello');
      expect(tokens, [
        const StringToken('hello'),
        const EOFToken(),
      ]);
    });

    test('should tokenize operators', () {
      final tokenizer = SearchExpressionTokenizer();
      final tokens = tokenizer.tokenize('&|-');
      expect(tokens, [
        const OperatorToken(OperatorEnum.and),
        const OperatorToken(OperatorEnum.or),
        const OperatorToken(OperatorEnum.exclude),
        const EOFToken(),
      ]);
    });

    test('should tokenize keywords', () {
      final tokenizer = SearchExpressionTokenizer();
      final tokens = tokenizer.tokenize('path:date:duration:');
      expect(tokens, [
        const KeywordToken(KeywordEnum.path),
        const KeywordToken(KeywordEnum.date),
        const KeywordToken(KeywordEnum.duration),
        const EOFToken(),
      ]);
    });

    test('should tokenize quoted strings with double quotes', () {
      final tokenizer = SearchExpressionTokenizer();
      final tokens = tokenizer.tokenize('"hello world"');
      expect(tokens, [
        const StringToken('hello world'),
        const EOFToken(),
      ]);
    });

    test('should tokenize quoted strings with single quotes', () {
      final tokenizer = SearchExpressionTokenizer();
      final tokens = tokenizer.tokenize("'hello world'");
      expect(tokens, [
        const StringToken('hello world'),
        const EOFToken(),
      ]);
    });

    test('should tokenize a mixed expression', () {
      final tokenizer = SearchExpressionTokenizer();
      final tokens = tokenizer.tokenize('path:"some/path" & date:today - "old"');
      expect(tokens, [
        const KeywordToken(KeywordEnum.path),
        const StringToken('some/path'),
        const WhitespaceToken(),
        const OperatorToken(OperatorEnum.and),
        const WhitespaceToken(),
        const KeywordToken(KeywordEnum.date),
        const StringToken('today'),
        const WhitespaceToken(),
        const OperatorToken(OperatorEnum.exclude),
        const WhitespaceToken(),
        const StringToken('old'),
        const EOFToken(),
      ]);
    });

    test('should tokenize with leading/trailing/multiple whitespaces', () {
      final tokenizer = SearchExpressionTokenizer();
      final tokens = tokenizer.tokenize('  foo   bar  ');
      expect(tokens, [
        const WhitespaceToken(),
        const StringToken('foo'),
        const WhitespaceToken(),
        const StringToken('bar'),
        const WhitespaceToken(),
        const EOFToken(),
      ]);
    });

    test('should tokenize an empty query', () {
      final tokenizer = SearchExpressionTokenizer();
      final tokens = tokenizer.tokenize('');
      expect(tokens, [
        const EOFToken(),
      ]);
    });

    test('should tokenize with operators without surrounding spaces', () {
      final tokenizer = SearchExpressionTokenizer();
      final tokens = tokenizer.tokenize('foo&bar|baz-qux');
      expect(tokens, [
        const StringToken('foo'),
        const OperatorToken(OperatorEnum.and),
        const StringToken('bar'),
        const OperatorToken(OperatorEnum.or),
        const StringToken('baz-qux'),
        const EOFToken(),
      ]);
    });
  });
}