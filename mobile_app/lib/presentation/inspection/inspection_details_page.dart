import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';

class InspectionDetailsPage extends ConsumerWidget {
  const InspectionDetailsPage({
    super.key,
    required this.collectionId,
    required this.inspectionId,
  });

  final String collectionId;
  final String inspectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inspectionTitle),
      ),
      body: const Center(
        child: Text('Inspection details will be shown here.'),
      ),
    );
  }
}
