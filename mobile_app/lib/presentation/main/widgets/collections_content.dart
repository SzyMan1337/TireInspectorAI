import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:tireinspectorai_app/presentation/main/widgets/collection_tile.dart';
import 'package:tireinspectorai_app/presentation/main/states/collections_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CollectionsContent extends ConsumerWidget {
  const CollectionsContent({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationProvider);
    final collectionsAsyncValue = ref.watch(userCollectionsProvider(userId));

    return Scaffold(
      body: Stack(
        children: [
          collectionsAsyncValue.when(
            data: (collections) {
              if (collections.isEmpty) {
                return Center(
                  child: Text(l10n.noCollectionsAvailable),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 1,
                  ),
                  itemCount: collections.length,
                  itemBuilder: (context, index) {
                    final collection = collections[index];
                    return CollectionTile(
                      id: collection.id!,
                      userId: userId,
                      name: collection.name,
                      count: collection.inspectionsCount,
                      onDelete: () => _confirmDeleteCollection(
                          context, ref, collection.id!, l10n),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) =>
                Center(child: Text('${l10n.errorMessage}: $error')),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: FloatingActionButton(
                onPressed: () async {
                  final collectionName =
                      await _showAddCollectionDialog(context, l10n);

                  if (collectionName != null && collectionName.isNotEmpty) {
                    ref.read(addCollectionStateProvider(AddCollectionData(
                      userId: userId,
                      collectionName: collectionName,
                    )));
                  }
                },
                shape: const CircleBorder(),
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showAddCollectionDialog(
      BuildContext context, AppLocalizations l10n) async {
    final TextEditingController controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.addCollectionTitle),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: l10n.addCollectionHint,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(l10n.cancelButtonLabel),
            ),
            ElevatedButton(
              onPressed: () {
                final collectionName = controller.text.trim();
                Navigator.of(context).pop(collectionName);
              },
              child: Text(l10n.addButtonLabel),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteCollection(
    BuildContext context,
    WidgetRef ref,
    String collectionId,
    AppLocalizations l10n,
  ) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            l10n.deleteCollectionTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          content: Text(
            l10n.deleteCollectionConfirmation,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                l10n.cancelButtonLabel,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
              ),
              child: Text(l10n.deleteButtonLabel),
            ),
          ],
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        );
      },
    );

    if (shouldDelete == true) {
      ref.read(deleteCollectionStateProvider(DeleteCollectionData(
        userId: userId,
        collectionId: collectionId,
      )));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.collectionDeletedSuccessfully)),
        );
      }
    }
  }
}
