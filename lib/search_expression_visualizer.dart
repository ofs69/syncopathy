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
    return _buildSpansFromNode(rootNode, context, 0); // 0 for root, ensuring root never gets parentheses
  }

  int _getPrecedence(SearchExpressionNode node) {
    if (node is ExcludeNode) return 3;
    if (node is AndNode) return 2;
    if (node is OrNode) return 1;
    return 4; // Atomic nodes have highest effective precedence
  }

  List<TextSpan> _buildSpansFromNode(
      SearchExpressionNode node, BuildContext context,
      [int parentOperatorPrecedence = 0]) { // 0 for the initial call, meaning no parent operator.
    final theme = Theme.of(context);
    final List<TextSpan> spans = [];
    final int currentOperatorPrecedence = _getPrecedence(node);

    // Parentheses needed if the current node's main operator binds tighter
    // than its parent's operator.
    // Higher number = tighter binding.
    bool needsParentheses = false;

    // Special case: AndNode as a child of OrNode
    if (node is AndNode && parentOperatorPrecedence == 1) { // 1 is OrNode's precedence
        needsParentheses = true;
    }
    // A child of ExcludeNode generally needs parentheses if its precedence is lower than Exclude's,
    // which it is (OR (1) < NOT (3), AND (2) < NOT (3)).
    // However, the "NOT" prefix already provides the grouping for ExcludeNode's direct child.
    // So, we only need parentheses for a child of an ExcludeNode if that child itself would need parentheses
    // relative to its *own* children (e.g., if the child is an OrNode containing an AndNode).
    // The current recursive call for ExcludeNode passes currentOperatorPrecedence (3) as parent,
    // so this is implicitly handled by the previous (AndNode in OrNode) rule.

    if (node is RootNode) { // RootNode itself never gets parentheses
      needsParentheses = false;
    }

    if (needsParentheses) {
      spans.add(const TextSpan(text: '('));
    }

    switch (node) {
      case RootNode(body: final children):
        for (int i = 0; i < children.length; i++) {
          // Children of RootNode should not be influenced by an operator precedence from the RootNode itself.
          spans.addAll(_buildSpansFromNode(children[i], context, 0)); // 0 represents "no operator parent"
          if (i < children.length - 1) {
            spans.add(const TextSpan(text: ' '));
          }
        }
        break;
      case AndNode(children: final children):
        for (int i = 0; i < children.length; i++) {
          spans.addAll(_buildSpansFromNode(children[i], context, currentOperatorPrecedence));
          if (i < children.length - 1) {
            spans.add(TextSpan(
                text: ' AND ',
                style: TextStyle(color: theme.colorScheme.primary)));
          }
        }
        break;
      case OrNode(children: final children):
        for (int i = 0; i < children.length; i++) {
          spans.addAll(_buildSpansFromNode(children[i], context, currentOperatorPrecedence));
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
        // Child of ExcludeNode inherits ExcludeNode's precedence for its own parentheses decision.
        // E.g., -(A | B) -> NOT (A OR B)
        spans.addAll(_buildSpansFromNode(child, context, currentOperatorPrecedence));
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

    if (needsParentheses) {
      spans.add(const TextSpan(text: ')'));
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
