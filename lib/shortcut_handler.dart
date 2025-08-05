import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/player_model.dart';

class ShortcutHandler extends StatefulWidget {
  final Widget child;
  final PageController pageController;
  final ValueChanged<int> onTabChanged;

  const ShortcutHandler({
    super.key,
    required this.child,
    required this.pageController,
    required this.onTabChanged,
  });

  @override
  State<ShortcutHandler> createState() => _ShortcutHandlerState();
}

class _ShortcutHandlerState extends State<ShortcutHandler> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is KeyDownEvent) {
          int? newIndex;
          switch (event.logicalKey) {
            case LogicalKeyboardKey.digit1:
              newIndex = 0;
              break;
            case LogicalKeyboardKey.digit2:
              newIndex = 1;
              break;
            case LogicalKeyboardKey.digit3:
              newIndex = 2;
              break;
            case LogicalKeyboardKey.digit4:
              newIndex = 3;
              break;
            default:
              break;
          }

          if (newIndex != null) {
            widget.onTabChanged(newIndex);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.space) {
            context.read<PlayerModel>().togglePause();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: widget.child,
    );
  }
}
