import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

// Provider to fetch user collections
final userCollectionsProvider =
    StreamProvider.autoDispose.family<List<TireCollection>, String>(
  (ref, userId) {
    return ref
        .watch(tireCollectionUseCaseProvider)
        .getUserTireCollections(userId);
  },
);

// Data structure for adding a new collection
class AddCollectionData {
  AddCollectionData({
    required this.userId,
    required this.collectionName,
  });

  final String userId;
  final String collectionName;
}

// Provider to handle adding a new collection
final addCollectionStateProvider =
    FutureProvider.autoDispose.family<void, AddCollectionData>(
  (ref, data) async {
    final collection = TireCollection(
      id: null,
      collectionName: data.collectionName,
      createdAt: DateTime.now(),
    );
    await ref.watch(tireCollectionUseCaseProvider).addTireCollection(
          userId: data.userId,
          collection: collection,
        );
  },
);

// Provider to handle deleting a collection
class DeleteCollectionData {
  DeleteCollectionData({
    required this.userId,
    required this.collectionId,
  });

  final String userId;
  final String collectionId;
}

final deleteCollectionStateProvider =
    FutureProvider.autoDispose.family<void, DeleteCollectionData>(
  (ref, data) async {
    await ref.watch(tireCollectionUseCaseProvider).deleteTireCollection(
          userId: data.userId,
          collectionId: data.collectionId,
        );
  },
);

class UserStatistics {
  final int inspectedTires;
  final int validTires;
  final int defectiveTires;

  UserStatistics({
    required this.inspectedTires,
    required this.validTires,
    required this.defectiveTires,
  });
}

final userStatisticsProvider = FutureProvider.family<UserStatistics, String>(
  (ref, userId) async {
    return ref.read(userStatisticsUseCaseProvider).fetchUserStatistics(userId);
  },
);
