import 'package:flutter/material.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/helper/extensions.dart';

class SettingsOverlay extends StatelessWidget {
  final Widget child;
  final bool showSettings;
  const SettingsOverlay({
    super.key,
    required this.child,
    required this.showSettings,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: showSettings ? Offset.zero : const Offset(0, -1.2),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ExcludeFocus(
        excluding: !showSettings,
        child: Container(
          padding: EdgeInsets.zero,
          decoration: stdBoxShadow(),
          alignment: Alignment.topCenter,
          // create a soft edge at the bottom
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.transparent],
                stops: [0.98, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: SingleChildScrollView(child: child),
          ),
        ),
      ),
    );
  }

  static Widget settingsCard({
    required double width,
    required String title,
    required List<Widget> children,
    void Function()? onClose,
    String closeTooltip = 'Remove',
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adapt to a narrow viewport: when the parent bounds the width (e.g. a
        // vertical list on a small window) shrink to fit instead of
        // overflowing. In a horizontally-scrolling parent maxWidth is
        // unbounded, so the requested width is used as-is.
        final effectiveWidth =
            constraints.maxWidth.isFinite && constraints.maxWidth < width
            ? constraints.maxWidth
            : width;
        return SizedBox(
          width: effectiveWidth,
          child: Card(
            color: Colors.grey.shade900.withAlphaF(0.6),
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.white.withAlphaF(0.2), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      if (onClose != null)
                        IconButton(
                          onPressed: onClose,
                          tooltip: closeTooltip,
                          icon: const Icon(Icons.delete),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ...children,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
