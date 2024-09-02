import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/domain/domain.dart';
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

    final params = CollectionParams(userId: userId, collectionId: collectionId);
    final collectionFuture = ref.watch(collectionProvider(params).future);
    final inspectionsFuture = ref.watch(inspectionsProvider(params).future);

    return FutureBuilder<TireCollection>(
      future: collectionFuture,
      builder: (context, collectionSnapshot) {
        if (collectionSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.loading),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (collectionSnapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.errorTitle),
            ),
            body: Center(
              child: Text('${l10n.errorMessage}: ${collectionSnapshot.error}'),
            ),
          );
        } else if (collectionSnapshot.hasData) {
          final collection = collectionSnapshot.data!;
          return Scaffold(
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
            body: FutureBuilder<List<Inspection>>(
              future: inspectionsFuture,
              builder: (context, inspectionsSnapshot) {
                if (inspectionsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (inspectionsSnapshot.hasError) {
                  return Center(
                    child: Text(
                        '${l10n.errorMessage}: ${inspectionsSnapshot.error}'),
                  );
                } else if (inspectionsSnapshot.hasData) {
                  final inspections = inspectionsSnapshot.data!;
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
                          AppRouter.go(
                            context,
                            RouterNames.inspectionDetailsPage,
                            pathParameters: {
                              'collectionId': collectionId,
                              'inspectionId': inspection.id,
                            },
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: Text(l10n.errorMessage));
                }
              },
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.errorTitle),
            ),
            body: Center(child: Text(l10n.errorMessage)),
          );
        }
      },
    );
  }
}
