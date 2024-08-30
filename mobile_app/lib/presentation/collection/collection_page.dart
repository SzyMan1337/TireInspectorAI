import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:tireinspectorai_app/presentation/collection/collection_state.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({
    super.key,
    required this.userId,
    required this.collectionId,
  });

  final String userId;
  final String collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationProvider);

    final collectionAsyncValue = ref.watch(collectionProvider({
      'userId': userId,
      'collectionId': collectionId,
    }));

    final inspectionsAsyncValue = ref.watch(inspectionsProvider({
      'userId': userId,
      'collectionId': collectionId,
    }));

    return collectionAsyncValue.when(
      data: (collection) => Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                collection.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                l10n.creationDateLabel(
                    collection.createdAt.toLocal().toString()),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: inspectionsAsyncValue.when(
            data: (inspections) {
              if (inspections.isEmpty) {
                return Center(
                  child: Text(l10n.noInspectionsAvailable),
                );
              }

              return ListView.builder(
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
                        l10n.inspectionDatePrefix,
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
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text('${l10n.errorMessage}: $error'),
            ),
          ),
        ),
      ),
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text(l10n.loading),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          title: Text(l10n.errorTitle),
        ),
        body: Center(
          child: Text('${l10n.errorMessage}: $error'),
        ),
      ),
    );
  }
}
