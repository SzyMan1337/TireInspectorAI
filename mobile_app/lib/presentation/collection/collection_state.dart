import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

// Provider to fetch a specific collection by ID
final collectionProvider =
    FutureProvider.autoDispose.family<TireCollection, Map<String, String>>(
  (ref, params) async {
    final userId = params['userId']!;
    final collectionId = params['collectionId']!;
    return ref
        .watch(tireCollectionUseCaseProvider)
        .getCollectionById(userId: userId, collectionId: collectionId);
  },
);

// Provider to fetch inspections for a specific collection
final inspectionsProvider =
    StreamProvider.autoDispose.family<List<Inspection>, Map<String, String>>(
  (ref, params) {
    final userId = params['userId']!;
    final collectionId = params['collectionId']!;
    return ref
        .watch(inspectionUseCaseProvider)
        .getCollectionInspections(userId: userId, collectionId: collectionId);
  },
);
