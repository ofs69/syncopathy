abstract class SearchExpressionNode {
  const SearchExpressionNode();
}

class RootNode extends SearchExpressionNode {
  final List<SearchExpressionNode> body;
  const RootNode(this.body);
}

class AndNode extends SearchExpressionNode {
  final List<SearchExpressionNode> children;

  const AndNode(this.children);
}

class OrNode extends SearchExpressionNode {
  final List<SearchExpressionNode> children;

  const OrNode(this.children);
}

class StringNode extends SearchExpressionNode {
  final String value;

  const StringNode(this.value);
}

class ParameterNode extends SearchExpressionNode {
  final String name;
  final String value;

  const ParameterNode(this.name, this.value);
}

class ExcludeNode extends SearchExpressionNode {
  final SearchExpressionNode child;

  const ExcludeNode(this.child);
}

class DateNode extends SearchExpressionNode {
  final RelationalOperator operator;
  final DateTime value;

  const DateNode(this.operator, this.value);
}

enum RelationalOperator { greater, less, equal, greaterOrEqual, lessOrEqual }

class DurationNode extends SearchExpressionNode {
  final RelationalOperator operator;
  final Duration duration;

  const DurationNode(this.operator, this.duration);
}

class PlayedNode extends SearchExpressionNode {
  final RelationalOperator operator;
  final int playedCount;

  const PlayedNode(this.operator, this.playedCount);
}
