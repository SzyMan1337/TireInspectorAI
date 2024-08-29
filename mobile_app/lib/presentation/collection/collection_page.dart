import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/domain/domain.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:tireinspectorai_app/common/common.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({
    super.key,
    required this.collectionId,
  });

  final String collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationProvider);

    // Mock collection data
    final collection = TireCollection(
      id: collectionId,
      collectionName: "Sample Collection",
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );

    // Mock inspections data
    final inspections = [
      Inspection(
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/9/9b/Tire_tread.jpg",
        isDefective: false,
        modelUsed: "localModel",
        addedAt: DateTime.now().subtract(const Duration(days: 1)),
        additionalNotes: "No issues found",
      ),
      Inspection(
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/9/9b/Tire_tread.jpg",
        isDefective: true,
        modelUsed: "cloudModel",
        addedAt: DateTime.now().subtract(const Duration(days: 2)),
        additionalNotes: "Detected a small crack",
      ),
    ];

    return CommonPageScaffold(
      title: l10n.collectionPageTitle,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              collection.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            Text(
              l10n.creationDateLabel(collection.createdAt.toLocal().toString()),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 16.0),
            if (inspections.isEmpty)
              Center(
                child: Text(l10n.noInspectionsAvailable),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: inspections.length,
                  itemBuilder: (context, index) {
                    final inspection = inspections[index];
                    return ListTile(
                      leading: Image.network(
                        inspection.imageUrl,
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        l10n.inspectionTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        l10n.inspectionDateLabel(
                          l10n.inspectionDateLabel,
                          inspection.addedAt.toLocal().toString(),
                        ),
                      ),
                      trailing: Icon(
                        inspection.isDefective ? Icons.error : Icons.check,
                        color: inspection.isDefective
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary,
                      ),
                      onTap: () {
                        // TODO: Implement navigation to inspection details page
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
