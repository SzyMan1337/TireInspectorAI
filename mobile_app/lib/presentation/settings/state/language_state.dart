import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final languageStateProvider =
    StateNotifierProvider<LanguageStateNotifier, String>(
  (ref) => LanguageStateNotifier(),
);

class LanguageStateNotifier extends StateNotifier<String> {
  static const String _languageKey = 'app_language';

  LanguageStateNotifier() : super('en') {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString(_languageKey) ?? 'en';
    state = language;
  }

  void setLanguage(String languageCode) async {
    state = languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
}
