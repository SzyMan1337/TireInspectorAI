import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizationProvider extends ConsumerWidget {
  final Widget child;

  const LocalizationProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = AppLocalizations.of(context);
    if (appLocalizations == null) {
      return child;
    }
    return ProviderScope(
      overrides: [
        localizationProvider.overrideWithValue(appLocalizations),
      ],
      child: child,
    );
  }
}

final localizationProvider = Provider<AppLocalizations>((ref) {
  throw UnimplementedError();
});
