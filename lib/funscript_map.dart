import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/model/video_model.dart';
import 'package:syncopathy/model/player_model.dart';
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
    final List<Video> funscriptVideos = [];
    final List<String> funscriptPaths = [];

    for (final video in videos) {
      if (video.funscriptPath.isNotEmpty) {
        funscriptVideos.add(video);
        funscriptPaths.add(video.funscriptPath);
      }
    }

    if (funscriptPaths.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final inputFile = File('${tempDir.path}/funscript_paths.txt');
    final outputFile = File('${tempDir.path}/funscript_embeddings.json');

    await inputFile.writeAsString(funscriptPaths.join('\n'));

    try {
      final result = await Process.run(
        'funscript-embedder',
        ['--input', inputFile.path, '--output', outputFile.path],
      );

      if (result.exitCode != 0) {
        Logger.error(
            'funscript-embedder failed with exit code ${result.exitCode}: ${result.stderr}');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final jsonString = await outputFile.readAsString();
      final Map<String, dynamic> embeddings = json.decode(jsonString);

      final List<Offset> newPoints = [];
      final List<Video> embeddedVideos = [];

      double minX = double.infinity;
      double maxX = double.negativeInfinity;
      double minY = double.infinity;
      double maxY = double.negativeInfinity;

      for (final video in funscriptVideos) {
        final embedding = embeddings[video.funscriptPath];
        if (embedding != null &&
            embedding['x'] != null &&
            embedding['y'] != null) {
          final x = embedding['x'] as double;
          final y = embedding['y'] as double;

          newPoints.add(Offset(x, y));
          embeddedVideos.add(video);

          if (x < minX) minX = x;
          if (x > maxX) maxX = x;
          if (y < minY) minY = y;
          if (y > maxY) maxY = y;
        }
      }

      if (newPoints.isNotEmpty) {
        setState(() {
          _videos = embeddedVideos;
          _points = newPoints
              .map(
                (p) => Offset(
                  (p.dx - minX) / (maxX - minX),
                  (p.dy - minY) / (maxY - minY),
                ),
              )
              .toList();
        });
      }
    } catch (e) {
      Logger.error('Error running funscript-embedder: $e');
    } finally {
      await inputFile.delete();
      await outputFile.delete();
    }

    setState(() {
      _isLoading = false;
    });
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
