import 'package:flutter/material.dart';

import 'package:syncopathy/logging.dart';
import 'package:syncopathy/update_checker.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateCheckerWidget extends StatefulWidget {
  const UpdateCheckerWidget({super.key});

  @override
  State<UpdateCheckerWidget> createState() => _UpdateCheckerWidgetState();
}

class _UpdateCheckerWidgetState extends State<UpdateCheckerWidget> {
  String? _latestVersion;
  bool _isCheckingForUpdates = false;
  bool _isUpToDate = false;

  Future<void> _checkForUpdates() async {
    setState(() {
      _isCheckingForUpdates = true;
      _isUpToDate = false;
    });
    final version = await UpdateChecker.checkForUpdates();
    if (mounted) {
      setState(() {
        _latestVersion = version;
        _isCheckingForUpdates = false;
        if (version == null) {
          _isUpToDate = true;
        }
      });
      if (version != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('New version $version available!')),
        );
      } else {
        // Optionally, show a temporary green checkmark or a subtle animation
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isUpToDate = false;
            });
          }
        });
      }
    }
  }

  Future<void> _openReleasePage() async {
    final url = Uri.parse('https://github.com/ofs69/syncopathy/releases');
    if (!await launchUrl(url)) {
      Logger.error('Could not launch $url');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the release page.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (_isCheckingForUpdates)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            ),
          )
        else if (_isUpToDate)
          const Tooltip(
            message: 'You are on the latest version!',
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.check_circle, color: Colors.green),
            ),
          )
        else if (_latestVersion != null)
          Tooltip(
            message: 'New version available: $_latestVersion',
            child: IconButton(
              icon: const Icon(Icons.update, color: Colors.amber),
              onPressed: _openReleasePage,
            ),
          )
        else
          IconButton(
            icon: const Icon(Icons.update_sharp),
            onPressed: _checkForUpdates,
            tooltip: 'Check for Updates',
          ),
      ],
    );
  }
}
