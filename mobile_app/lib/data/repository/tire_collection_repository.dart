import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/data/tire_collection_data_source.dart';
import 'package:tireinspectorai_app/data/interfaces/tire_collection_interface.dart';
import 'package:tireinspectorai_app/data/models/tire_collection.dart';

class _TireCollectionRepository implements TireCollectionRepository {
  const _TireCollectionRepository({
    required this.databaseDataSource,
  });

  final TireCollectionRepository databaseDataSource;

  @override
  Future<void> createCollection(
      String userId, TireCollectionDataModel collection) {
    return databaseDataSource.createCollection(userId, collection);
  }

  @override
  Stream<List<TireCollectionDataModel>> getUserCollections(String userId) {
    return databaseDataSource.getUserCollections(userId);
  }

  @override
  Future<void> deleteCollection(String userId, String collectionId) {
    return databaseDataSource.deleteCollection(userId, collectionId);
  }

  @override
  Future<TireCollectionDataModel> getCollectionById(
      String userId, String collectionId) {
    return databaseDataSource.getCollectionById(userId, collectionId);
  }
}

final tireCollectionRepositoryProvider = Provider<TireCollectionRepository>(
  (ref) => _TireCollectionRepository(
    databaseDataSource: ref.watch(tireCollectionDataSourceProvider),
  ),
);
