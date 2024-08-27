import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/presentation/main/widgets/collection_tile.dart';

class CollectionsContent extends ConsumerWidget {
  const CollectionsContent({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // TODO Example collections data
    final collections = [
      {'name': 'Collection 1', 'count': 10},
      {'name': 'Collection 2', 'count': 5},
      {'name': 'Collection 3', 'count': 15},
    ];

    return Scaffold(
      body: Stack(
        children: [
          Padding(
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
                  name: collection['name'] as String,
                  count: collection['count'] as int,
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: FloatingActionButton(
                onPressed: () {
                  // TODO: Implement the action to add a new collection
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
}
