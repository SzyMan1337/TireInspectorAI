import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/data.dart';
import 'package:tireinspectorai_app/domain/entity/tire_collection.dart';

abstract interface class TireCollectionUseCase {
  Future<void> addTireCollection({
    required String userId,
    required TireCollection collection,
  });

  Stream<List<TireCollection>> getUserTireCollections(String userId);

  Future<void> deleteTireCollection({
    required String userId,
    required String collectionId,
  });

  Future<TireCollection> getCollectionById({
    required String userId,
    required String collectionId,
  });
}

class _TireCollectionUseCase implements TireCollectionUseCase {
  const _TireCollectionUseCase(this._tireCollectionRepository);

  final TireCollectionRepository _tireCollectionRepository;

  @override
  Future<void> addTireCollection({
    required String userId,
    required TireCollection collection,
  }) {
    return _tireCollectionRepository.createCollection(
      userId,
      collection.toDataModel(),
    );
  }

  @override
  Stream<List<TireCollection>> getUserTireCollections(String userId) {
    return _tireCollectionRepository.getUserCollections(userId).map(
          (collectionDataModels) => collectionDataModels
              .map((dataModel) => TireCollection.fromDataModel(dataModel))
              .toList(),
        );
  }

  @override
  Future<void> deleteTireCollection({
    required String userId,
    required String collectionId,
  }) {
    return _tireCollectionRepository.deleteCollection(userId, collectionId);
  }

  @override
  Future<TireCollection> getCollectionById({
    required String userId,
    required String collectionId,
  }) async {
    final dataModel = await _tireCollectionRepository.getCollectionById(
      userId,
      collectionId,
    );

    return TireCollection.fromDataModel(dataModel);
  }
}

final tireCollectionUseCaseProvider = Provider<TireCollectionUseCase>(
  (ref) => _TireCollectionUseCase(
    ref.watch(tireCollectionRepositoryProvider),
  ),
);
