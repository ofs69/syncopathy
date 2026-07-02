import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/notification_feed.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker {
  static const String _repoOwner = 'ofs69'; // Replace with your GitHub username
  static const String _repoName =
      'syncopathy'; // Replace with your GitHub repository name

  static Future<void> openReleasePage() async {
    final url = Uri.parse(
      'https://github.com/$_repoOwner/$_repoName/releases',
    );
    if (!await launchUrl(url)) {
      AlertManager.showError('Could not open releases page.');
    }
  }

  static Future<String?> checkForUpdates() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.github.com/repos/$_repoOwner/$_repoName/releases/latest',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> releaseInfo = json.decode(response.body);
        final String latestVersion = releaseInfo['tag_name'];

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String currentVersion =
            "${packageInfo.version}+${packageInfo.buildNumber}";

        // Remove 'v' prefix if present in the GitHub tag
        final cleanLatestVersion = latestVersion.startsWith('v')
            ? latestVersion.substring(1)
            : latestVersion;

        if (_isNewVersion(cleanLatestVersion, currentVersion)) {
          return latestVersion; // Return the latest version if an update is available
        }
      }
    } catch (e) {
      Logger.error('Error checking for updates: $e');
    }
    return null; // No update available or an error occurred
  }

  static bool _isNewVersion(String latest, String current) {
    try {
      final latestKey = _versionKey(latest);
      final currentKey = _versionKey(current);

      for (var i = 0; i < latestKey.length && i < currentKey.length; i++) {
        if (latestKey[i] != currentKey[i]) return latestKey[i] > currentKey[i];
      }
      // All shared components equal: the one with more components (e.g. an
      // extra build number) is newer.
      return latestKey.length > currentKey.length;
    } catch (e) {
      Logger.error('Error parsing version numbers: $e');
      return false; // Assume no new version if parsing fails
    }
  }

  /// Splits a `major.minor.patch+build` string into its numeric components for
  /// lexicographic comparison (e.g. `1.2.3+45` -> `[1, 2, 3, 45]`).
  static List<int> _versionKey(String version) =>
      version.split(RegExp(r'[.+]')).map(int.parse).toList();
}
