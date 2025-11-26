import 'package:flutter/material.dart';
import 'package:syncopathy/pca_calculator.dart';

class PcaProgressDialog extends StatefulWidget {
  final PcaCalculator pcaCalculator;
  final void Function(Map<String, List<double>>) onCalculationComplete;

  const PcaProgressDialog({
    super.key,
    required this.pcaCalculator,
    required this.onCalculationComplete,
  });

  @override
  State<PcaProgressDialog> createState() => _PcaProgressDialogState();
}

class _PcaProgressDialogState extends State<PcaProgressDialog> {
  String _progressMessage = "Initializing PCA calculation...";

  @override
  void initState() {
    super.initState();
    _startPcaCalculation();
  }

  Future<void> _startPcaCalculation() async {
    final pcaScoresByPath =
        await widget.pcaCalculator.performPcaCalculation(onProgress: (message) {
      if (mounted) {
        setState(() {
          _progressMessage = message;
        });
      }
    });

    if (mounted) {
      widget.onCalculationComplete(pcaScoresByPath);
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('PCA Sorting in Progress'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(_progressMessage),
        ],
      ),
    );
  }
}