import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/domain/domain.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:tireinspectorai_app/presentation/collection/collection_state.dart';
import 'package:tireinspectorai_app/presentation/inspection/states/inspection_details_state.dart';
import 'package:tireinspectorai_app/presentation/main/states/collections_state.dart';

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

                            return Dismissible(
                              key: ValueKey(inspection.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: theme.colorScheme.error.withOpacity(0.8),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Icon(
                                  Icons.delete,
                                  color: theme.colorScheme.onError,
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        l10n.deleteConfirmationTitle,
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                      content: Text(
                                        l10n.deleteConfirmationMessage,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text(
                                            l10n.cancelButtonLabel,
                                            style: TextStyle(
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: theme
                                                .colorScheme.errorContainer,
                                            foregroundColor: theme
                                                .colorScheme.onErrorContainer,
                                          ),
                                          child: Text(l10n.deleteButtonLabel),
                                        ),
                                      ],
                                      backgroundColor:
                                          theme.colorScheme.surface,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                    );
                                  },
                                );
                              },
                              onDismissed: (direction) {
                                _deleteInspection(context, ref, inspection.id);
                                // Invalidate userCollectionsProvider to reload collections data
                                ref.invalidate(userCollectionsProvider(userId));

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(l10n.inspectionDeletedMessage),
                                  ),
                                );
                              },
                              child: Container(
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
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return const SizedBox(
                                          height: 90.0,
                                          width: 90.0,
                                          child: Center(
                                            child:
                                                CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  title: Text(
                                    Helpers.getModelName(
                                        Helpers.parseInspectionModel(
                                            inspection.modelUsed),
                                        l10n),
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${l10n.probabilityScoreDescription}: ${inspection.probabilityScore.toStringAsFixed(2)}',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                      Text(
                                        DateFormat.yMMMMd()
                                            .format(inspection.dateAdded),
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  trailing: Icon(
                                    inspection.isDefective
                                        ? Icons.error
                                        : Icons.check,
                                    color: inspection.isDefective
                                        ? theme.colorScheme.error
                                        : theme.colorScheme.primary,
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

  void _deleteInspection(
      BuildContext context, WidgetRef ref, String inspectionId) {
    ref.read(deleteInspectionStateProvider(DeleteInspectionData(
      userId: userId,
      collectionId: collectionId,
      inspectionId: inspectionId,
    )));
  }
}
