import 'package:flutter/material.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/video_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/tsne.dart';
import 'package:syncopathy/video_thumbnail.dart';

class FunscriptMapPage extends StatefulWidget {
  const FunscriptMapPage({super.key});

  @override
  State<FunscriptMapPage> createState() => _FunscriptMapPageState();
}

class _FunscriptMapPageState extends State<FunscriptMapPage>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = false;
  List<Video> _videos = [];
  List<Offset> _points = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _hoveredIndex;
  static const double _mapMargin = 20.0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _calculateTSNE() async {
    setState(() {
      _isLoading = true;
      _videos = [];
      _points = [];
    });

    final model = context.read<SyncopathyModel>();
    final videos = model.mediaManager.allVideos;
    final List<List<double>> vectors = [];
    final List<Video> funscriptVideos = [];

    for (final video in videos) {
      if (video.funscriptPath.isEmpty) {
        continue;
      }
      Funscript? funscript;
      try {
        funscript = await Funscript.fromFile(video.funscriptPath);
      } catch (e) {
        Logger.error('Error loading funscript for ${video.funscriptPath}: $e');
        continue;
      }
      if (funscript == null || funscript.actions.length < 2) {
        continue;
      }

      funscriptVideos.add(video);

      final speeds = <double>[];
      for (int i = 0; i < funscript.actions.length - 1; i++) {
        final a1 = funscript.actions[i];
        final a2 = funscript.actions[i + 1];
        final timeDiff = a2.at - a1.at;
        if (timeDiff > 0) {
          final posDiff = (a2.pos - a1.pos).abs();
          speeds.add(posDiff / timeDiff);
        }
      }

      final positions = funscript.actions
          .map((a) => a.pos.toDouble() / 100.0)
          .toList();

      if (speeds.isEmpty || positions.isEmpty) {
        continue;
      }

      final speedQuantiles = _calculateQuantiles(speeds, 16);
      final positionQuantiles = _calculateQuantiles(positions, 16);

      final vector = [...speedQuantiles, ...positionQuantiles];
      vectors.add(vector);
    }

    if (vectors.isNotEmpty) {
      final data = vectors;
      final tsne = TSNE(perplexity: 500.0, maxIter: 1000, dimension: 2);
      final tsneResult = tsne.fitTransform(data);
      final matrix = Matrix.fromList(tsneResult);
      final points = matrix.rows.toList();
      final double minX = points
          .map((p) => p[0])
          .reduce((a, b) => a < b ? a : b);
      final double maxX = points
          .map((p) => p[0])
          .reduce((a, b) => a > b ? a : b);
      final double minY = points
          .map((p) => p[1])
          .reduce((a, b) => a < b ? a : b);
      final double maxY = points
          .map((p) => p[1])
          .reduce((a, b) => a > b ? a : b);

      setState(() {
        _videos = funscriptVideos;
        _points = points
            .map(
              (p) => Offset(
                (p[0] - minX) / (maxX - minX),
                (p[1] - minY) / (maxY - minY),
              ),
            )
            .toList();
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  List<double> _calculateQuantiles(List<double> data, int numQuantiles) {
    if (data.isEmpty) {
      return List.filled(numQuantiles, 0.0);
    }
    data.sort();
    final List<double> quantiles = [];
    for (int i = 1; i <= numQuantiles; i++) {
      final double quantileIndex = (data.length - 1) * (i / numQuantiles);
      final int lowerIndex = quantileIndex.floor();
      final int upperIndex = quantileIndex.ceil();
      if (lowerIndex == upperIndex) {
        quantiles.add(data[lowerIndex]);
      } else {
        final double interpolation = quantileIndex - lowerIndex;
        quantiles.add(
          data[lowerIndex] * (1.0 - interpolation) +
              data[upperIndex] * interpolation,
        );
      }
    }
    return quantiles;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: _isLoading
            ? const Text('Generating Map...')
            : TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _calculateTSNE,
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _points.isEmpty
            ? const Text('Press the refresh button to generate the map.')
            : LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final availableHeight = constraints.maxHeight;
                  return MouseRegion(
                    onHover: (event) {
                      final RenderBox box =
                          context.findRenderObject() as RenderBox;
                      final Offset localPosition = box.globalToLocal(
                        event.position,
                      );
                      int? newHoveredIndex;
                      double minDistance = double.infinity;

                      for (int i = 0; i < _points.length; i++) {
                        final double effectiveWidth =
                            availableWidth - 2 * _mapMargin;
                        final double effectiveHeight =
                            availableHeight - 2 * _mapMargin;
                        final point = Offset(
                          _points[i].dx * effectiveWidth + _mapMargin,
                          _points[i].dy * effectiveHeight + _mapMargin,
                        );
                        final distance = (point - localPosition).distance;
                        if (distance < 10 && distance < minDistance) {
                          minDistance = distance;
                          newHoveredIndex = i;
                        }
                      }

                      if (newHoveredIndex != _hoveredIndex) {
                        setState(() {
                          _hoveredIndex = newHoveredIndex;
                        });
                      }
                    },
                    onExit: (event) {
                      if (_hoveredIndex != null) {
                        setState(() {
                          _hoveredIndex = null;
                        });
                      }
                    },
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTapUp: (details) {
                            final Offset localPosition = details.localPosition;
                            int? clickedIndex;
                            double minDistance = double.infinity;

                            final double availableWidth = constraints.maxWidth;
                            final double availableHeight =
                                constraints.maxHeight;
                            final double effectiveWidth =
                                availableWidth - 2 * _mapMargin;
                            final double effectiveHeight =
                                availableHeight - 2 * _mapMargin;

                            for (int i = 0; i < _points.length; i++) {
                              final point = Offset(
                                _points[i].dx * effectiveWidth + _mapMargin,
                                _points[i].dy * effectiveHeight + _mapMargin,
                              );
                              final distance = (point - localPosition).distance;
                              if (distance < 10 && distance < minDistance) {
                                minDistance = distance;
                                clickedIndex = i;
                              }
                            }

                            if (clickedIndex != null) {
                              final video = _videos[clickedIndex];
                              context.read<PlayerModel>().openVideoAndScript(
                                video,
                                false,
                              );
                            }
                          },
                          child: CustomPaint(
                            painter: ScatterPainter(
                              points: _points,
                              videos: _videos,
                              searchQuery: _searchQuery,
                              hoveredIndex: _hoveredIndex,
                              margin: _mapMargin,
                            ),
                            size: Size.infinite,
                          ),
                        ),
                        if (_hoveredIndex != null)
                          Positioned(
                            left:
                                _points[_hoveredIndex!].dx *
                                    (availableWidth - 2 * _mapMargin) +
                                _mapMargin +
                                10,
                            top:
                                _points[_hoveredIndex!].dy *
                                    (availableHeight - 2 * _mapMargin) +
                                _mapMargin +
                                10,
                            child: IgnorePointer(
                              child: Card(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 160,
                                      height: 90,
                                      child: VideoThumbnail(
                                        video: _videos[_hoveredIndex!],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _videos[_hoveredIndex!].title,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Text(
                                        'Avg Speed: ${_videos[_hoveredIndex!].averageSpeed.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Text(
                                        'Avg Min Pos: ${_videos[_hoveredIndex!].averageMin.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Text(
                                        'Avg Max Pos: ${_videos[_hoveredIndex!].averageMax.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 4.0,
                                      ),
                                      child: Text(
                                        'Duration: ${_videos[_hoveredIndex!].duration?.toStringAsFixed(2) ?? 'N/A'}s',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class ScatterPainter extends CustomPainter {
  final List<Offset> points;
  final List<Video> videos;
  final String searchQuery;
  final int? hoveredIndex;
  final double margin;

  ScatterPainter({
    required this.points,
    required this.videos,
    required this.searchQuery,
    required this.hoveredIndex,
    this.margin = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final video = videos[i];

      final paint = Paint();

      bool isHighlighted =
          searchQuery.isNotEmpty &&
          video.title.toLowerCase().contains(searchQuery.toLowerCase());
      bool isHovered = i == hoveredIndex;

      if (isHovered) {
        paint.color = Colors.green;
      } else if (isHighlighted) {
        paint.color = Colors.red;
      } else {
        paint.color = Colors.blue;
      }

      final double effectiveWidth = size.width - 2 * margin;
      final double effectiveHeight = size.height - 2 * margin;
      final double x = point.dx * effectiveWidth + margin;
      final double y = point.dy * effectiveHeight + margin;
      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ScatterPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.videos != videos ||
        oldDelegate.searchQuery != searchQuery ||
        oldDelegate.hoveredIndex != hoveredIndex;
  }
}
