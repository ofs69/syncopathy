import 'package:flutter/material.dart';
import 'package:syncopathy/search_expression_ast.dart';
import 'package:syncopathy/search_expression_parser.dart';

class ExpressionVisualizer extends StatelessWidget {
  final String expression;
  final TextStyle? style;

  const ExpressionVisualizer({
    super.key,
    required this.expression,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final spans = _buildSpans(context);
    return RichText(
      text: TextSpan(
        style: style,
        children: spans,
      ),
    );
  }

  List<TextSpan> _buildSpans(BuildContext context) {
    final rootNode = SearchExpressionParser().parse(expression);
    return _buildSpansFromNode(rootNode, context);
  }

  List<TextSpan> _buildSpansFromNode(
      SearchExpressionNode node, BuildContext context) {
    final theme = Theme.of(context);
    final List<TextSpan> spans = [];

    switch (node) {
      case RootNode(body: final children):
        for (int i = 0; i < children.length; i++) {
          spans.addAll(_buildSpansFromNode(children[i], context));
          if (i < children.length - 1) {
            spans.add(const TextSpan(text: ' '));
          }
        }
        break;
      case AndNode(children: final children):
        for (int i = 0; i < children.length; i++) {
          spans.addAll(_buildSpansFromNode(children[i], context));
          if (i < children.length - 1) {
            spans.add(TextSpan(
                text: ' AND ',
                style: TextStyle(color: theme.colorScheme.primary)));
          }
        }
        break;
      case OrNode(children: final children):
        for (int i = 0; i < children.length; i++) {
          spans.addAll(_buildSpansFromNode(children[i], context));
          if (i < children.length - 1) {
            spans.add(TextSpan(
                text: ' OR ',
                style: TextStyle(color: theme.colorScheme.primary)));
          }
        }
        break;
      case ExcludeNode(child: final child):
        spans.add(TextSpan(
            text: 'NOT ', style: TextStyle(color: theme.colorScheme.error)));
        spans.addAll(_buildSpansFromNode(child, context));
        break;
      case StringNode(value: final value):
        spans.add(TextSpan(text: value));
        break;
      case ParameterNode(name: final name, value: final value):
        spans.add(TextSpan(
            text: '$name:',
            style: TextStyle(color: theme.colorScheme.secondary)));
        spans.add(TextSpan(
            text: value,
            style: TextStyle(color: theme.colorScheme.secondary)));
        break;
      case DateNode(operator: final op, value: final date):
        spans.add(TextSpan(
            text: 'date:${_operatorToString(op)}',
            style: TextStyle(color: theme.colorScheme.secondary)));
        spans.add(TextSpan(
            text: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
            style: TextStyle(color: theme.colorScheme.secondary)));
        break;
      case DurationNode(operator: final op, duration: final duration):
        spans.add(TextSpan(
            text: 'duration:${_operatorToString(op)}',
            style: TextStyle(color: theme.colorScheme.secondary)));
        spans.add(TextSpan(
            text: _formatDuration(duration),
            style: TextStyle(color: theme.colorScheme.secondary)));
        break;
    }

    return spans;
  }

  String _operatorToString(RelationalOperator op) {
    switch (op) {
      case RelationalOperator.greater:
        return '>';
      case RelationalOperator.less:
        return '<';
      case RelationalOperator.equal:
        return '=';
      case RelationalOperator.greaterOrEqual:
        return '>=';
      case RelationalOperator.lessOrEqual:
        return '<=';
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
