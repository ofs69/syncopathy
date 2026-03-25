import 'package:flutter/material.dart';
import 'package:syncopathy/helper/constants.dart';

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
}
