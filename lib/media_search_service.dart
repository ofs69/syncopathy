import 'package:syncopathy/search_expression_parser.dart';
import 'package:syncopathy/search_expression_ast.dart';
import 'package:syncopathy/model/video_model.dart';

class MediaSearchService {
  List<Video> filterVideos(List<Video> videos, String query) {
    if (query.trim().isEmpty) {
      return videos;
    }

    try {
      final parser = SearchExpressionParser();
      final rootNode = parser.parse(query);

      if (rootNode.body.isEmpty) {
        return videos; // No valid expressions found, return all videos
      }

      return videos.where((video) {
        return _evaluateNode(rootNode, video);
      }).toList();
    } catch (e) {
      // Log the error or handle it as appropriate
      // print('Error parsing search query: $e'); // Removed print
      return [];
    }
  }

  bool _evaluateNode(SearchExpressionNode node, Video video) {
    if (node is RootNode) {
      // For a RootNode, all top-level expressions are implicitly ANDed
      return node.body.every((n) => _evaluateNode(n, video));
    } else if (node is AndNode) {
      return node.children.every((n) => _evaluateNode(n, video));
    } else if (node is OrNode) {
      return node.children.any((n) => _evaluateNode(n, video));
    } else if (node is ExcludeNode) {
      return !_evaluateNode(node.child, video);
    } else if (node is StringNode) {
      return _matchesString(node.value, video);
    } else if (node is ParameterNode) {
      return _matchesParameter(node.name, node.value, video);
    } else if (node is DateNode) {
      return _matchesDate(node.operator, node.value, video);
    } else if (node is DurationNode) {
      return _matchesDuration(node.operator, node.duration, video);
    }
    return false; // Should not reach here for valid nodes
  }

  bool _checkMetadataFieldList(List<String>? list, String search) {
    return list?.any((item) => item.toLowerCase().contains(search)) ?? false;
  }

  bool _matchesString(String value, Video video) {
    final lowerCaseValue = value.toLowerCase();
    // Search across title, authors, tags, and performers for a general string
    return video.title.toLowerCase().contains(lowerCaseValue) ||
        (video.funscriptMetadata?.creator?.toLowerCase().contains(lowerCaseValue) ?? false) ||
        _checkMetadataFieldList(video.funscriptMetadata?.tags, lowerCaseValue) ||
        _checkMetadataFieldList(video.funscriptMetadata?.performers, lowerCaseValue);
  }

  bool _matchesParameter(String field, String value, Video video) {
    final lowerCaseValue = value.toLowerCase();

    switch (field.toLowerCase()) {
      case 'path':
        return video.videoPath.toLowerCase().contains(lowerCaseValue) ||
            video.funscriptPath.toLowerCase().contains(lowerCaseValue);
      default:
        return false; // Invalid field name
    }
  }

  bool _matchesDate(RelationalOperator operator, DateTime targetDate, Video video) {
    final videoDate = video.dateFirstFound; // Assuming 'dateFirstFound' is the relevant date field for comparison

    // Extract only the date part for comparison
    final videoDateOnly = DateTime(videoDate.year, videoDate.month, videoDate.day);
    final targetDateOnly = DateTime(targetDate.year, targetDate.month, targetDate.day);

    switch (operator) {
      case RelationalOperator.equal:
        return videoDateOnly.isAtSameMomentAs(targetDateOnly);
      case RelationalOperator.greater:
        return videoDateOnly.isAfter(targetDateOnly);
      case RelationalOperator.less:
        return videoDateOnly.isBefore(targetDateOnly);
      case RelationalOperator.greaterOrEqual:
        return videoDateOnly.isAfter(targetDateOnly) || videoDateOnly.isAtSameMomentAs(targetDateOnly);
      case RelationalOperator.lessOrEqual:
        return videoDateOnly.isBefore(targetDateOnly) || videoDateOnly.isAtSameMomentAs(targetDateOnly);
    }
  }

  bool _matchesDuration(RelationalOperator operator, Duration targetDuration, Video video) {
    final actualVideoDuration = video.duration; // This is a double?
    if (actualVideoDuration == null) {
      return false; // If video has no duration, it can't match any duration criteria
    }

    // Convert targetDuration to seconds (double) for comparison
    final targetDurationInSeconds = targetDuration.inMilliseconds / 1000.0;

    switch (operator) {
      case RelationalOperator.equal:
        return actualVideoDuration == targetDurationInSeconds;
      case RelationalOperator.greater:
        return actualVideoDuration > targetDurationInSeconds;
      case RelationalOperator.less:
        return actualVideoDuration < targetDurationInSeconds;
      case RelationalOperator.greaterOrEqual:
        return actualVideoDuration >= targetDurationInSeconds;
      case RelationalOperator.lessOrEqual:
        return actualVideoDuration <= targetDurationInSeconds;
    }
  }
}