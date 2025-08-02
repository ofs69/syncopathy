import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:syncopathy/logging.dart';

class UpdateChecker {
  static const String _repoOwner = 'ofs69'; // Replace with your GitHub username
  static const String _repoName =
      'syncopathy'; // Replace with your GitHub repository name

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
      final latestVersionAndBuild = latest.split('+');
      final currentVersionAndBuild = current.split('+');

      final latestVersion = latestVersionAndBuild[0];
      final currentVersion = currentVersionAndBuild[0];

      final latestVersionParts = latestVersion
          .split('.')
          .map(int.parse)
          .toList();
      final currentVersionParts = currentVersion
          .split('.')
          .map(int.parse)
          .toList();

      final minLength = latestVersionParts.length < currentVersionParts.length
          ? latestVersionParts.length
          : currentVersionParts.length;

      for (int i = 0; i < minLength; i++) {
        if (latestVersionParts[i] > currentVersionParts[i]) {
          return true;
        }
        if (latestVersionParts[i] < currentVersionParts[i]) {
          return false;
        }
      }

      if (latestVersionParts.length > currentVersionParts.length) {
        return true;
      }
      if (latestVersionParts.length < currentVersionParts.length) {
        return false;
      }

      // Versions are the same, compare build numbers
      if (latestVersionAndBuild.length > 1 &&
          currentVersionAndBuild.length > 1) {
        final latestBuild = int.parse(latestVersionAndBuild[1]);
        final currentBuild = int.parse(currentVersionAndBuild[1]);
        return latestBuild > currentBuild;
      }

      // If latest has build number and current does not, it's newer
      if (latestVersionAndBuild.length > 1 &&
          currentVersionAndBuild.length == 1) {
        return true;
      }

      return false;
    } catch (e) {
      Logger.error('Error parsing version numbers: $e');
      return false; // Assume no new version if parsing fails
    }
  }
}
