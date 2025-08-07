import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectTabIntent extends Intent {
  const SelectTabIntent(this.index);
  final int index;
}

class SelectTabAction extends Action<SelectTabIntent> {
  SelectTabAction(this.onTabChanged);

  final ValueChanged<int> onTabChanged;

  @override
  void invoke(SelectTabIntent intent) {
    onTabChanged(intent.index);
  }
}

class ShortcutHandler extends StatelessWidget {
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
  Widget build(BuildContext context) {

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(
          LogicalKeyboardKey.controlLeft,
          LogicalKeyboardKey.digit1,
        ): const SelectTabIntent(
          0,
        ),
        LogicalKeySet(
          LogicalKeyboardKey.controlLeft,
          LogicalKeyboardKey.digit2,
        ): const SelectTabIntent(
          1,
        ),
        LogicalKeySet(
          LogicalKeyboardKey.controlLeft,
          LogicalKeyboardKey.digit3,
        ): const SelectTabIntent(
          2,
        ),
        LogicalKeySet(
          LogicalKeyboardKey.controlLeft,
          LogicalKeyboardKey.digit4,
        ): const SelectTabIntent(
          3,
        ),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          SelectTabIntent: SelectTabAction(onTabChanged),
        },
        child: Focus(autofocus: true, child: child),
      ),
    );
  }
}
