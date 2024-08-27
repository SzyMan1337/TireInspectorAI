import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Locale provider to track the current locale
final localeProvider = StateProvider<Locale?>((ref) => null);

// Localization provider to access the AppLocalizations instance
final localizationProvider = Provider<AppLocalizations>((ref) {
  throw UnimplementedError();
});
