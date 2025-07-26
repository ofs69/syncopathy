import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/heatmap.dart';
import 'package:syncopathy/scrolling_graph.dart';
import 'package:syncopathy/video_controls.dart';

class VisualizerPage extends StatefulWidget {
  const VisualizerPage({super.key});

  @override
  State<VisualizerPage> createState() => _VisualizerPageState();
}

class _VisualizerPageState extends State<VisualizerPage> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<SyncopathyModel>();

    return ValueListenableBuilder(
      valueListenable: model.funscript,
      builder: (context, funscript, child) {
        if (funscript == null) {
          return const Center(child: Text('No funscript loaded'));
        }
        return Column(
          children: [
            Expanded(
              flex: 10,
              child: InteractiveScrollingGraph(
                funscript: funscript,
                videoPosition: model.positionNoOffset,
              ),
            ),
            Expanded(flex: 1, child: VideoControls()),
            SizedBox(
              height: 50,
              child: Heatmap(
                funscript: funscript,
                videoPosition: model.positionNoOffset,
                totalDuration: model.duration,
                onClick: (seekTo) =>
                    model.seekTo(seekTo.inMilliseconds / 1000.0),
              ),
            ),
          ],
        );
      },
    );
  }
}
