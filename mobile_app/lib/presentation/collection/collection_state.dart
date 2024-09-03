import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

// Provider to fetch a specific collection by ID
final collectionProvider =
    FutureProvider.autoDispose.family<TireCollection, CollectionParams>(
  (ref, params) async {
    return ref.watch(tireCollectionUseCaseProvider).getCollectionById(
        userId: params.userId, collectionId: params.collectionId);
  },
);

// Provider to fetch inspections for a specific collection
final inspectionsProvider =
    StreamProvider.autoDispose.family<List<Inspection>, CollectionParams>(
  (ref, params) {
    return ref.watch(inspectionUseCaseProvider).getCollectionInspections(
        userId: params.userId, collectionId: params.collectionId);
  },
);

class CollectionParams {
  final String userId;
  final String collectionId;

  CollectionParams({
    required this.userId,
    required this.collectionId,
  });
}
