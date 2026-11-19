import 'dart:async';

import 'package:flutter/widgets.dart';

/// Matches a contained video texture to the physical pixels it can occupy.
class ViewportVideoTexture extends StatefulWidget {
  const ViewportVideoTexture({
    super.key,
    required this.source,
    required this.resize,
    required this.child,
  });

  final Size? source;
  final void Function(int width, int height) resize;
  final Widget child;

  @override
  State<ViewportVideoTexture> createState() => _ViewportVideoTextureState();
}

class _ViewportVideoTextureState extends State<ViewportVideoTexture> {
  (int, int)? _target;
  Timer? _timer;

  void _request((int, int)? target) {
    if (_target == target) return;
    _target = target;
    _timer?.cancel();
    if (target == null) return;
    // A window drag emits many intermediate sizes. Keep showing the existing
    // texture until the layout settles before reallocating GPU surfaces.
    _timer = Timer(const Duration(milliseconds: 100), () {
      widget.resize(target.$1, target.$2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final active = ModalRoute.isCurrentOf(context) ?? true;
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final source = widget.source;
        final bounds = constraints.biggest * pixelRatio;
        if (active &&
            source != null &&
            !source.isEmpty &&
            bounds.isFinite &&
            !bounds.isEmpty) {
          final size = applyBoxFit(
            BoxFit.scaleDown,
            source,
            bounds,
          ).destination;
          _request((size.width.ceil(), size.height.ceil()));
        } else {
          // Fullscreen shares the controller with the route underneath it.
          // Reapply this viewport when it becomes current again.
          _request(null);
        }
        return widget.child;
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
