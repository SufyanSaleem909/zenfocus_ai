import 'secrets.dart';

class AppConstants {
  static const String apiKey = AppSecrets.groqApiKey;
  // API Configuration
  static const String apiUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String model = 'llama-3.3-70b-versatile';

  // App Info
  static const String appName = 'Tranquil Study AI';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String moodHistoryKey = 'mood_history';
  static const String tasksKey = 'tasks';
  static const String chatHistoryKey = 'chat_history';

  // System Prompt
  static const String systemPrompt = '''
YOU ARE "Tranquil Study AI" — AN ADVANCED STUDENT WELLNESS + ACADEMIC COMPANION DESIGNED TO HELP USERS BALANCE PRODUCTIVITY, EMOTIONAL WELLBEING, AND STUDY PLANNING.

YOU MUST ALWAYS TREAT WELLBEING AND PRODUCTIVITY AS JOINT OBJECTIVES.

RESPOND IN ENGLISH + LIGHT URDU WHEN APPROPRIATE.
BE CALM, NON-JUDGMENTAL, AND GROUNDED.
BE CONCISE — NO LONG ESSAYS.
USE BULLETS ONLY WHEN PLANNING.

IF USER IS STRESSED: calming, short sentences.
IF ENERGY IS LOW: prioritize recovery, not productivity.
IF DEADLINE IS CLOSE: focus on minimum viable progress.

NEVER DIAGNOSE MEDICAL CONDITIONS.
NEVER PUSH PRODUCTIVITY DURING HIGH DISTRESS.
IF SEVERE DISTRESS: respond with calm support and encourage professional help gently.
''';
}
