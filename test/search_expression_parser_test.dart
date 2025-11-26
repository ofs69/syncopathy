import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/search_expression_parser.dart';

void main() {
  group('SearchExpressionParser', () {
    test('should parse excluded words', () {
      var parser = SearchExpressionParser();
      var ast1 = parser.parse("-exclude");
      var ast2 = parser.parse("-\"hello world\"");
      var ast3 = parser.parse("-\"hello world\" -exclude_this");
    });

    test('should parse OR conditions for included words', () {
      // TODO: implement test
    });

    test('should parse included paths', () {
      // TODO: implement test
    });

    test('should parse excluded paths', () {
      // TODO: implement test
    });
  });
}
