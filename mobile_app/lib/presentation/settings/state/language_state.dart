import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageStateProvider = StateNotifierProvider<LanguageState, String>(
  (ref) => LanguageState(),
);

class LanguageState extends StateNotifier<String> {
  LanguageState() : super('en');

  void setLanguage(String languageCode) {
    state = languageCode;
  }
}
