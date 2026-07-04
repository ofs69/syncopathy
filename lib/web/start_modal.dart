import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StartupModal extends StatefulWidget {
  const StartupModal({super.key});
  static const int currentModalVersion = 1;

  @override
  State<StartupModal> createState() => _StartupModalState();
}

class _StartupModalState extends State<StartupModal> with SignalsMixin {
  late final Signal<bool> _neverShowAgain = createSignal(false);

  // Created once and disposed in dispose() — building them inline in build()
  // leaks a recognizer on every rebuild.
  late final TapGestureRecognizer _repoTap = TapGestureRecognizer()
    ..onTap = () => _launch("https://github.com/ofs69/syncopathy");
  late final TapGestureRecognizer _bluetoothTap = TapGestureRecognizer()
    ..onTap = () => _launch("https://caniuse.com/web-bluetooth");

  @override
  void dispose() {
    _repoTap.dispose();
    _bluetoothTap.dispose();
    super.dispose();
  }

  Future<void> _launch(String url) async {
    try {
      final ok = await launchUrl(Uri.parse(url));
      if (!ok && mounted) _showLaunchError(url);
    } catch (_) {
      if (mounted) _showLaunchError(url);
    }
  }

  void _showLaunchError(String url) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Couldn't open $url")));
  }

  TextStyle get _linkStyle => TextStyle(
    color: Theme.of(context).colorScheme.primary,
    decoration: TextDecoration.underline,
  );

  @override
  Widget build(BuildContext context) {
    final neverShowAgain = _neverShowAgain.watch(context);

    return AlertDialog(
      title: const Text("Welcome!"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(
                    text: "This is a client-side browser version of ",
                  ),
                  TextSpan(
                    text: "syncopathy",
                    style: _linkStyle,
                    recognizer: _repoTap,
                  ),
                  const TextSpan(text: ".\n"),
                  TextSpan(
                    text:
                        "Beware that only chromium browsers have web bluetooth capabilities needed for this app.\n\n",
                  ),
                  TextSpan(text: "You can check support here "),
                  TextSpan(
                    text: "web bluetooth",
                    style: _linkStyle,
                    recognizer: _bluetoothTap,
                  ),
                  TextSpan(text: ".\n"),
                ],
              ),
            ),
            _buildBulletPoint(
              "Keep the tab always in focus when playing video.",
            ),
            _buildBulletPoint(
              "No minimizing or tab switching when playing video.",
            ),
            _buildBulletPoint(
              "You're limited to playing local videos and funscripts.\nScript token playback is not supported.",
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      actions: [
        Row(
          children: [
            // Checkbox and label — the whole thing toggles, not just the box.
            InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => _neverShowAgain.value = !neverShowAgain,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: neverShowAgain,
                    onChanged: (bool? value) {
                      _neverShowAgain.value = value ?? false;
                    },
                  ),
                  const Text(
                    "Don't show again",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),

            const Spacer(),
            // Dismiss Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(neverShowAgain);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            " • ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
