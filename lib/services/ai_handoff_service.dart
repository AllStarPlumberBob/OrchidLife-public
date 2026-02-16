import 'dart:io' show Platform;
import 'package:flutter/material.dart';
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
  /// Try to launch a native Android app by package name using MAIN/LAUNCHER.
  /// Returns true if the app was found and launched, false otherwise.
  static Future<bool> _tryLaunchNativeApp(String packageName) async {
    if (!Platform.isAndroid) return false;
    final intent = AndroidIntent(
      action: 'android.intent.action.MAIN',
      category: 'android.intent.category.LAUNCHER',
      package: packageName,
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    final canResolve = await intent.canResolveActivity();
    if (canResolve == true) {
      await intent.launch();
      return true;
    }
    return false;
  }

  /// Open Google Lens for image identification (native app on Android).
  static Future<bool> openGoogleLens(BuildContext context) async {
    if (Platform.isAndroid) {
      // Try Google Lens app directly
      if (await _tryLaunchNativeApp('com.google.ar.lens')) return true;

      // Fallback: Google app's lens deep link
      try {
        const intent = AndroidIntent(
          action: 'android.intent.action.VIEW',
          data: 'google://lens',
          package: 'com.google.android.googlequicksearchbox',
          flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        final canResolve = await intent.canResolveActivity();
        if (canResolve == true) {
          await intent.launch();
          return true;
        }
      } catch (_) {}
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

  /// Open Claude (native Android app, then web fallback).
  static Future<bool> openClaude(BuildContext context) async {
    if (await _tryLaunchNativeApp('com.anthropic.claude')) return true;

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

  /// Open Perplexity (native Android app, then web fallback).
  static Future<bool> openPerplexity(BuildContext context) async {
    if (await _tryLaunchNativeApp('ai.perplexity.app.android')) return true;

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
