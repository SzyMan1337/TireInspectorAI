import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
    final theme = Theme.of(context);

    final params = CollectionParams(userId: userId, collectionId: collectionId);
    final collectionFuture = ref.watch(collectionProvider(params).future);
    final inspectionsFuture = ref.watch(inspectionsProvider(params).future);

    return FutureBuilder<TireCollection>(
      future: collectionFuture,
      builder: (context, collectionSnapshot) {
        if (collectionSnapshot.connectionState == ConnectionState.waiting) {
          return CommonPageScaffold(
            title: l10n.loading,
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (collectionSnapshot.hasError) {
          return CommonPageScaffold(
            title: l10n.errorTitle,
            child: Center(
              child: Text('${l10n.errorMessage}: ${collectionSnapshot.error}'),
            ),
          );
        } else if (collectionSnapshot.hasData) {
          final collection = collectionSnapshot.data!;
          return CommonPageScaffold(
            withPadding: false,
            title: collection.name,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FutureBuilder<List<Inspection>>(
                    future: inspectionsFuture,
                    builder: (context, inspectionsSnapshot) {
                      if (inspectionsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (inspectionsSnapshot.hasError) {
                        return Center(
                          child: Text(
                            '${l10n.errorMessage}: ${inspectionsSnapshot.error}',
                          ),
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
                            final color = index % 2 == 0
                                ? theme.colorScheme.surfaceContainerLow
                                : theme.colorScheme.surface;

                            return Container(
                              color: color,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(8, 0, 24, 0),
                                leading: Image.network(
                                  inspection.imageUrl,
                                  width: 90.0,
                                  height: 90.0,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  Helpers.getModelName(
                                      Helpers.parseInspectionModel(
                                          inspection.modelUsed),
                                      l10n),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${l10n.probabilityScoreDescription}: ${inspection.probabilityScore.toStringAsFixed(2)}',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Text(
                                      DateFormat.yMMMMd()
                                          .format(inspection.dateAdded),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                trailing: Icon(
                                  inspection.isDefective
                                      ? Icons.error
                                      : Icons.check,
                                  color: inspection.isDefective
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(context).colorScheme.primary,
                                ),
                                onTap: () {
                                  AppRouter.go(
                                    context,
                                    RouterNames.inspectionDetailsPage,
                                    pathParameters: {
                                      'userId': userId,
                                      'collectionId': collectionId,
                                      'inspectionId': inspection.id,
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(child: Text(l10n.errorMessage));
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return CommonPageScaffold(
            title: l10n.errorTitle,
            child: Center(child: Text(l10n.errorMessage)),
          );
        }
      },
    );
  }
}
