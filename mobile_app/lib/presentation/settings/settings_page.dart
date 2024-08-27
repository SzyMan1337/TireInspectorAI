import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/theme/theme.dart';
import 'package:tireinspectorai_app/common/widgets/page_scaffold.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:tireinspectorai_app/presentation/settings/state/language_state.dart';
import 'package:tireinspectorai_app/presentation/settings/state/notification_preferences_state.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeModeProvider);
    final l10n = ref.watch(localizationProvider);
    final notificationPrefs = ref.watch(notificationPreferencesStateProvider);
    final currentLanguage = ref.watch(languageStateProvider);

    return CommonPageScaffold(
      title: l10n.settingsTitle,
      child: ListView(
        children: [
          // Dark Mode
          ListTile(
            title: Text(l10n.darkModeLabel),
            trailing: Switch(
              value: theme == ThemeMode.dark,
              onChanged: (value) {
                final themeNotifier = ref.read(themeModeProvider.notifier);
                themeNotifier.state = value ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),
          // Notification Preferences
          ListTile(
            title: Text(l10n.notificationPreferencesLabel),
            trailing: Switch(
              value: notificationPrefs.isEnabled,
              onChanged: (value) {
                ref
                    .read(notificationPreferencesStateProvider.notifier)
                    .setNotificationEnabled(value);
              },
            ),
          ),
          // Language Selection
          ListTile(
            title: Text(l10n.languageLabel),
            trailing: DropdownButton<String>(
              value: currentLanguage,
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(l10n.englishLanguage),
                ),
                DropdownMenuItem(
                  value: 'pl',
                  child: Text(l10n.polishLanguage),
                ),
              ],
              onChanged: (String? newLanguage) {
                if (newLanguage != null) {
                  ref
                      .read(languageStateProvider.notifier)
                      .setLanguage(newLanguage);
                  ref.read(localeProvider.notifier).state =
                      Locale(newLanguage); // Update locale
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
