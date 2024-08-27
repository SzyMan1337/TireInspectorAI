import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';

class CollectionsContent extends ConsumerWidget {
  const CollectionsContent({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationProvider);

    return Center(
      child: Text('${l10n.recordsTitle} for User: $userId'),
    );
  }
}
