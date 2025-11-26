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
