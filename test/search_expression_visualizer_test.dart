import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/search_expression_visualizer.dart';
import 'package:syncopathy/search_expression_ast.dart'; // Import if needed for direct AST comparison, though TextSpan will be easier

void main() {
  group('ExpressionVisualizer', () {
    testWidgets('should correctly visualize precedence: test | -test2 test3', (WidgetTester tester) async {
      final theme = ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: Colors.green,
          error: Colors.red,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: ExpressionVisualizer(expression: 'test | -test2 test3'),
          ),
        ),
      );

      // Find the RichText widget
      final richTextFinder = find.byType(RichText);
      expect(richTextFinder, findsOneWidget);

      final RichText richText = tester.widget(richTextFinder);
      final TextSpan textSpan = richText.text as TextSpan;

      // This is where we will assert the structure and content of the TextSpan
      // Based on: "test OR (NOT test2 AND test3)"
      //
      // Expected structure (simplified):
      // TextSpan (root)
      //   - TextSpan(text: 'test')
      //   - TextSpan(text: ' OR ', style: primary)
      //   - TextSpan(text: '(')
      //   - TextSpan(text: 'NOT ', style: error)
      //   - TextSpan(text: 'test2')
      //   - TextSpan(text: ' AND ', style: primary)
      //   - TextSpan(text: 'test3')
      //   - TextSpan(text: ')')

      expect(textSpan.children, isA<List<InlineSpan>>());
      final children = textSpan.children!;

      expect(children.length, 8); // test, ' OR ', '(', 'NOT ', test2, ' AND ', test3, ')'

      // 'test'
      expect((children[0] as TextSpan).text, 'test');

      // ' OR '
      expect((children[1] as TextSpan).text, ' OR ');
      expect((children[1] as TextSpan).style?.color, theme.colorScheme.primary);

      // '('
      expect((children[2] as TextSpan).text, '(');

      // 'NOT '
      expect((children[3] as TextSpan).text, 'NOT ');
      expect((children[3] as TextSpan).style?.color, theme.colorScheme.error);

      // 'test2'
      expect((children[4] as TextSpan).text, 'test2');

      // ' AND '
      expect((children[5] as TextSpan).text, ' AND ');
      expect((children[5] as TextSpan).style?.color, theme.colorScheme.primary);

      // 'test3'
      expect((children[6] as TextSpan).text, 'test3');

      // ')'
      expect((children[7] as TextSpan).text, ')');
    });
  });
}
