import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

/// Extracted AI handoff methods shared between Tools screen and Add Wizard.
class AIHandoffService {
  /// Open Google Lens for image identification
  static Future<void> openGoogleLens(BuildContext context) async {
    final url = Uri.parse('https://lens.google.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  /// Open ChatGPT
  static Future<void> openChatGPT(BuildContext context) async {
    final url = Uri.parse('https://chat.openai.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  /// Open Google Gemini
  static Future<void> openGemini(BuildContext context) async {
    final url = Uri.parse('https://gemini.google.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  /// Open Claude
  static Future<void> openClaude(BuildContext context) async {
    final url = Uri.parse('https://claude.ai');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  /// Search Google with a text query
  static Future<void> searchGoogle(String query) async {
    final encoded = Uri.encodeComponent(query);
    final url = Uri.parse('https://www.google.com/search?q=$encoded');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  /// Launch voice assistant / web search
  static Future<void> launchVoiceAssistant(String query) async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.intent.action.WEB_SEARCH',
        arguments: {'query': query},
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      try {
        await intent.launch();
        return;
      } catch (_) {
        // Fall through to Google
      }
    }
    await searchGoogle(query);
  }

  /// Share a photo with text to any app
  static Future<void> shareToAny(XFile image, String text) async {
    await Share.shareXFiles([image], text: text);
  }

  /// Show a follow-up snackbar after opening an external service
  static void showFollowUp(BuildContext context, String service, {String? message}) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Opening $service... Upload your photo and ask your question there.'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
