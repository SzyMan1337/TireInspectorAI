import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:tireinspectorai_app/presentation/settings/state/language_state.dart';
import 'package:tireinspectorai_app/presentation/settings/state/notification_preferences_state.dart';
import 'package:tireinspectorai_app/presentation/settings/state/theme_mode_state.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late ThemeMode _tempThemeMode;
  late bool _tempNotificationEnabled;
  late String _tempLanguage;

  @override
  void initState() {
    super.initState();
    // Initialize temporary state with current settings
    _tempThemeMode = ref.read(themeModeProvider);
    _tempNotificationEnabled =
        ref.read(notificationPreferencesStateProvider).isEnabled;
    _tempLanguage = ref.read(languageStateProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(localizationProvider);

    return CommonPageScaffold(
      title: l10n.settingsTitle,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                GapWidgets.h24,
                // Dark Mode
                ListTile(
                  title: Text(l10n.darkModeLabel),
                  trailing: Switch(
                    value: _tempThemeMode == ThemeMode.dark,
                    onChanged: (value) {
                      setState(() {
                        _tempThemeMode =
                            value ? ThemeMode.dark : ThemeMode.light;
                      });
                    },
                  ),
                ),
                // Notification Preferences
                ListTile(
                  title: Text(l10n.notificationPreferencesLabel),
                  trailing: Switch(
                    value: _tempNotificationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _tempNotificationEnabled = value;
                      });
                    },
                  ),
                ),
                // Language Selection
                ListTile(
                  title: Text(l10n.languageLabel),
                  trailing: DropdownButton<String>(
                    value: _tempLanguage,
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
                        setState(() {
                          _tempLanguage = newLanguage;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          // Save Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: HighlightButton(
              text: l10n.saveButtonLabel,
              onPressed: () {
                ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(_tempThemeMode);
                ref
                    .read(notificationPreferencesStateProvider.notifier)
                    .setNotificationEnabled(_tempNotificationEnabled);
                ref
                    .read(languageStateProvider.notifier)
                    .setLanguage(_tempLanguage);
                ref.read(localeProvider.notifier).state = Locale(_tempLanguage);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.settingsSavedMessage)),
                );
              },
            ),
          ),
          GapWidgets.h24,
        ],
      ),
    );
  }
}
