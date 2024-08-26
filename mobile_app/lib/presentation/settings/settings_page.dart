import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/theme/theme.dart';
import 'package:tireinspectorai_app/common/widgets/page_scaffold.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeModeProvider);
    final l10n = ref.watch(localizationProvider);

    return CommonPageScaffold(
      title: l10n.settingsTitle,
      child: ListView(
        children: [
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
        ],
      ),
    );
  }
}
