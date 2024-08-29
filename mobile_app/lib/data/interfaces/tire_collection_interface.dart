import 'package:tireinspectorai_app/data/models/tire_collection.dart';

abstract interface class TireCollectionRepository {
  Future<void> createCollection(String userId, TireCollectionDataModel collection);
  Stream<List<TireCollectionDataModel>> getUserCollections(String userId);
  Future<void> deleteCollection(String userId, String collectionId);
}
