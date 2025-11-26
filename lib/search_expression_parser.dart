import 'package:syncopathy/search_expression_ast.dart';
import 'package:syncopathy/search_expression_lexer.dart';

class SearchExpressionParser {
  // TODO
  // Planned search parameters:
  // path:
  // date:
  // duration:

  final SearchExpressionTokenizer _tokenizer = SearchExpressionTokenizer();

  RootNode parse(String query) {
    var tokens = _tokenizer.tokenize(query);
    var expression = _parseBody(tokens);
    return RootNode(expression);
  }

  List<SearchExpressionNode> _parseBody(List<Token> tokens) {
    var body = List<SearchExpressionNode>.empty(growable: true);
    for (var token in tokens) {
      
    }
    return body;
  }
}
