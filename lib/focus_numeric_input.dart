import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusNumericInput extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double? min;
  final double? max;
  final String? label;

  const FocusNumericInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.min,
    this.max,
    this.label,
  });

  @override
  State<FocusNumericInput> createState() => _FocusNumericInputState();
}

class _FocusNumericInputState extends State<FocusNumericInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.round().toString());
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FocusNumericInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value.round().toString();
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      var text = _controller.text;
      if (text.isEmpty) {
        text = '0';
      }
      var parsedValue = double.tryParse(text);
      if (parsedValue != null) {
        if (widget.min != null) {
          parsedValue = parsedValue.clamp(widget.min!, widget.max!);
        }
        widget.onChanged(parsedValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}
