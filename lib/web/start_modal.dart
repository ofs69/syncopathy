import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StartupModal extends StatefulWidget {
  const StartupModal({super.key});
  static const int currentModalVersion = 1;

  @override
  State<StartupModal> createState() => _StartupModalState();
}

class _StartupModalState extends State<StartupModal> {
  bool _neverShowAgain = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Welcome!"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              // This line is the magic fix:
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                const TextSpan(
                  text: "This is a client-side browser version of ",
                ),
                TextSpan(
                  text: "syncopathy",
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrl(
                      Uri.parse("https://github.com/ofs69/syncopathy"),
                    ),
                ),
                const TextSpan(text: ".\n"),
                TextSpan(
                  text:
                      "Beware that only chromium browsers have web bluetooth capabilities needed for this app.\n\n",
                ),
                TextSpan(text: "You can check support here "),
                TextSpan(
                  text: "web bluetooth",
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrl(
                      Uri.parse("https://caniuse.com/web-bluetooth"),
                    ),
                ),
                TextSpan(text: ".\n"),
              ],
            ),
          ),
          _buildBulletPoint("Keep the tab always in focus when playing video."),
          _buildBulletPoint(
            "No minimizing or tab switching when playing video.",
          ),
          _buildBulletPoint(
            "You're limited to playing local videos and funscripts.\nScript token playback is not supported.",
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      actions: [
        Row(
          children: [
            // Checkbox and Label
            Checkbox(
              value: _neverShowAgain,
              onChanged: (bool? value) {
                setState(() {
                  _neverShowAgain = value ?? false;
                });
              },
            ),
            const Text("Don't show again", style: TextStyle(fontSize: 14)),

            const Spacer(),
            // Dismiss Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_neverShowAgain);
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
