import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

/// Centralized AI handoff methods shared between Tools screen and Add Wizard.
///
/// Each `open*` method returns `true` if the external app/URL was launched
/// successfully, or `false` if all fallbacks failed (also shows an error
/// snackbar via the provided [BuildContext]).
class AIHandoffService {
  static const _shareChannel = MethodChannel('com.orchidlife.orchidlife/share');

  /// Share an image + text directly to a specific Android app via ACTION_SEND.
  /// Returns true if the share intent was launched successfully.
  static Future<bool> _shareImageToPackage({
    required String filePath,
    required String packageName,
    String text = '',
    String mimeType = 'image/*',
  }) async {
    if (!Platform.isAndroid) return false;
    try {
      final result = await _shareChannel.invokeMethod('shareImageToPackage', {
        'filePath': filePath,
        'packageName': packageName,
        'text': text,
        'mimeType': mimeType,
      });
      return result == true;
    } on PlatformException {
      return false;
    }
  }

  /// Launch a specific Android activity by package + class name (explicit intent).
  /// This avoids the "Complete action using" chooser dialog entirely.
  static Future<bool> _launchActivity(String packageName, String activityClass) async {
    if (!Platform.isAndroid) return false;
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.LAUNCHER',
        package: packageName,
        componentName: activityClass,
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
      return true;
    } on PlatformException {
      return false;
    }
  }

  /// Open Google Lens for image identification (native app on Android).
  /// If [imagePath] is provided, shares the image directly to Lens.
  static Future<bool> openGoogleLens(BuildContext context, {String? imagePath}) async {
    if (Platform.isAndroid) {
      // If we have an image, share it directly to Google Lens
      if (imagePath != null) {
        if (await _shareImageToPackage(
          filePath: imagePath,
          packageName: 'com.google.ar.lens',
        )) {
          return true;
        }
        // Fallback: share to Google app (which includes Lens)
        if (await _shareImageToPackage(
          filePath: imagePath,
          packageName: 'com.google.android.googlequicksearchbox',
        )) {
          return true;
        }
      }

      // No image — just launch the app
      if (await _launchActivity(
        'com.google.ar.lens',
        'com.google.vr.apps.ornament.app.lens.LensLauncherActivity',
      )) {
        return true;
      }

      if (await _launchActivity(
        'com.google.android.googlequicksearchbox',
        'com.google.android.apps.lens.MainActivity',
      )) {
        return true;
      }
    }

    // iOS: try Google Lens URL scheme
    if (Platform.isIOS) {
      final schemeUrl = Uri.parse('googlelens://');
      if (await canLaunchUrl(schemeUrl)) {
        await launchUrl(schemeUrl);
        return true;
      }
    }

    // Final fallback: Google Images search
    final url = Uri.parse('https://images.google.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      return true;
    }
    if (context.mounted) {
      _showError(context, 'Could not open Google Lens. Please install the Google app.');
    }
    return false;
  }

  /// Open Claude (native Android app, iOS URL scheme, then web fallback).
  /// If [imagePath] and [prompt] are provided, shares the image + prompt directly.
  static Future<bool> openClaude(BuildContext context, {String? imagePath, String? prompt}) async {
    if (Platform.isAndroid && imagePath != null) {
      if (await _shareImageToPackage(
        filePath: imagePath,
        packageName: 'com.anthropic.claude',
        text: prompt ?? '',
      )) {
        return true;
      }
    }

    // No image — just launch the app
    if (await _launchActivity(
      'com.anthropic.claude',
      'com.anthropic.claude.mainactivity.MainActivity',
    )) {
      return true;
    }

    // iOS: try URL scheme for native app
    if (Platform.isIOS) {
      final schemeUrl = Uri.parse('claude://');
      if (await canLaunchUrl(schemeUrl)) {
        await launchUrl(schemeUrl);
        return true;
      }
    }

    // Fallback to web
    final url = Uri.parse('https://claude.ai');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      return true;
    }
    if (context.mounted) {
      _showError(context, 'Could not open Claude. Please install the app or check your browser.');
    }
    return false;
  }

  /// Open Perplexity (native Android app, iOS URL scheme, then web fallback).
  /// If [imagePath] and [prompt] are provided, shares the image + prompt directly.
  static Future<bool> openPerplexity(BuildContext context, {String? imagePath, String? prompt}) async {
    if (Platform.isAndroid && imagePath != null) {
      if (await _shareImageToPackage(
        filePath: imagePath,
        packageName: 'ai.perplexity.app.android',
        text: prompt ?? '',
      )) {
        return true;
      }
    }

    // No image — just launch the app
    if (await _launchActivity(
      'ai.perplexity.app.android',
      'ai.perplexity.app.android.ui.main.MainActivity',
    )) {
      return true;
    }

    // iOS: try URL scheme for native app
    if (Platform.isIOS) {
      final schemeUrl = Uri.parse('perplexity://');
      if (await canLaunchUrl(schemeUrl)) {
        await launchUrl(schemeUrl);
        return true;
      }
    }

    // Fallback to web
    final url = Uri.parse('https://www.perplexity.ai');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      return true;
    }
    if (context.mounted) {
      _showError(context, 'Could not open Perplexity. Please install the app or check your browser.');
    }
    return false;
  }

  /// Search Google with a text query.
  static Future<void> searchGoogle(String query) async {
    final encoded = Uri.encodeComponent(query);
    final url = Uri.parse('https://www.google.com/search?q=$encoded');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  /// Share a photo with text to any app.
  static Future<void> shareToAny(XFile image, String text) async {
    await Share.shareXFiles([image], text: text);
  }

  /// Show a follow-up snackbar after successfully opening an external service.
  static void showFollowUp(BuildContext context, String service, {String? message}) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Opening $service... Upload your photo and ask your question there.'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show an error snackbar when all launch fallbacks fail.
  static void _showError(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
