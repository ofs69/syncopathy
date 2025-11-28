import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/search_expression_ast.dart';
import 'package:syncopathy/search_expression_parser.dart';

void main() {
  group('SearchExpressionParser', () {
    test('should parse an empty query', () {
      var parser = SearchExpressionParser();
      var ast = parser.parse("");
      expect(ast.body.isEmpty, isTrue);
    });

    test('should ignore dangling operators', () {
      var parser = SearchExpressionParser();
      var ast = parser.parse("- |");
      expect(ast.body.isEmpty, isTrue);
    });

    test('should parse a single word', () {
      var parser = SearchExpressionParser();
      var ast = parser.parse("hello");
      expect(ast.body.length, 1);
      expect(ast.body[0], isA<StringNode>());
      expect((ast.body[0] as StringNode).value, "hello");
    });

    test('should parse multiple words as implicit AND', () {
      var parser = SearchExpressionParser();
      var ast = parser.parse("hello world");
      expect(ast.body.length, 1);
      expect(ast.body[0], isA<AndNode>());
      final andNode = ast.body[0] as AndNode;
      expect(andNode.children.length, 2);
      expect(andNode.children[0], isA<StringNode>());
      expect((andNode.children[0] as StringNode).value, "hello");
      expect(andNode.children[1], isA<StringNode>());
      expect((andNode.children[1] as StringNode).value, "world");
    });

    test('should parse excluded words', () {
      var parser = SearchExpressionParser();
      var ast1 = parser.parse("-exclude");
      expect(ast1.body.length, 1);
      expect(ast1.body[0], isA<ExcludeNode>());
      final excludeNode1 = ast1.body[0] as ExcludeNode;
      expect(excludeNode1.child, isA<StringNode>());
      expect((excludeNode1.child as StringNode).value, "exclude");

      var ast2 = parser.parse('-"hello world"');
      expect(ast2.body.length, 1);
      expect(ast2.body[0], isA<ExcludeNode>());
      final excludeNode2 = ast2.body[0] as ExcludeNode;
      expect(excludeNode2.child, isA<StringNode>());
      expect((excludeNode2.child as StringNode).value, "hello world");

      var ast3 = parser.parse('-"hello world" -exclude_this');
      expect(ast3.body.length, 1);
      expect(ast3.body[0], isA<AndNode>());
      final andNode = ast3.body[0] as AndNode;
      expect(andNode.children.length, 2);
      expect(andNode.children[0], isA<ExcludeNode>());
      expect(andNode.children[1], isA<ExcludeNode>());
    });

    test('should parse OR conditions', () {
      var parser = SearchExpressionParser();
      var ast = parser.parse("hello | world");
      expect(ast.body.length, 1);
      expect(ast.body[0], isA<OrNode>());
      final orNode = ast.body[0] as OrNode;
      expect(orNode.children.length, 2);
      expect(orNode.children[0], isA<StringNode>());
      expect((orNode.children[0] as StringNode).value, "hello");
      expect(orNode.children[1], isA<StringNode>());
      expect((orNode.children[1] as StringNode).value, "world");
    });

    test('should handle precedence of AND and OR', () {
      var parser = SearchExpressionParser();
      var ast = parser.parse("a b | c d");
      expect(ast.body.length, 1);
      expect(ast.body[0], isA<OrNode>());
      final orNode = ast.body[0] as OrNode;
      expect(orNode.children.length, 2);

      expect(orNode.children[0], isA<AndNode>());
      final andNode1 = orNode.children[0] as AndNode;
      expect(andNode1.children.length, 2);
      expect((andNode1.children[0] as StringNode).value, 'a');
      expect((andNode1.children[1] as StringNode).value, 'b');

      expect(orNode.children[1], isA<AndNode>());
      final andNode2 = orNode.children[1] as AndNode;
      expect(andNode2.children.length, 2);
      expect((andNode2.children[0] as StringNode).value, 'c');
      expect((andNode2.children[1] as StringNode).value, 'd');
    });

    test('should parse included paths', () {
      var parser = SearchExpressionParser();
      var ast = parser.parse("path:test/path");
      expect(ast.body.length, 1);
      expect(ast.body[0], isA<ParameterNode>());
      final paramNode = ast.body[0] as ParameterNode;
      expect(paramNode.name, 'path');
      expect(paramNode.value, 'test/path');
    });

    test('should parse excluded paths', () {
      var parser = SearchExpressionParser();
      var ast = parser.parse("-path:test/path");
      expect(ast.body.length, 1);
      expect(ast.body[0], isA<ExcludeNode>());
      final excludeNode = ast.body[0] as ExcludeNode;
      expect(excludeNode.child, isA<ParameterNode>());
      final paramNode = excludeNode.child as ParameterNode;
      expect(paramNode.name, 'path');
      expect(paramNode.value, 'test/path');
    });

    test('should parse combination of terms', () {
      var parser = SearchExpressionParser();
      var ast = parser.parse(
        "term1 path:some/path -term2 | -path:another/path term3",
      );

      expect(ast.body.length, 1);
      expect(ast.body[0], isA<OrNode>());
      final orNode = ast.body[0] as OrNode;
      expect(orNode.children.length, 2);

      // first part of OR
      final andNode1 = orNode.children[0] as AndNode;
      expect(andNode1.children.length, 3);
      expect((andNode1.children[0] as StringNode).value, 'term1');
      final paramNode1 = andNode1.children[1] as ParameterNode;
      expect(paramNode1.name, 'path');
      expect(paramNode1.value, 'some/path');
      final excludeNode1 = andNode1.children[2] as ExcludeNode;
      expect((excludeNode1.child as StringNode).value, 'term2');

      // second part of OR
      final andNode2 = orNode.children[1] as AndNode;
      expect(andNode2.children.length, 2);
      final excludeNode2 = andNode2.children[0] as ExcludeNode;
      final paramNode2 = excludeNode2.child as ParameterNode;
      expect(paramNode2.name, 'path');
      expect(paramNode2.value, 'another/path');
      expect((andNode2.children[1] as StringNode).value, 'term3');
    });
  });
}
