import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/constants/collections.dart';
import 'package:tireinspectorai_app/data/interfaces/tire_collection_interface.dart';
import 'package:tireinspectorai_app/data/models/tire_collection.dart';
import 'package:tireinspectorai_app/exceptions/app_exceptions.dart';

class _TireCollectionRemoteDataSource implements TireCollectionRepository {
  const _TireCollectionRemoteDataSource(this.databaseDataSource);

  final FirebaseFirestore databaseDataSource;

  @override
  Future<void> createCollection(
      String userId, TireCollectionDataModel collection) async {
    try {
      final collectionRef = databaseDataSource
          .collection(CollectionsName.users.name)
          .doc(userId)
          .collection(CollectionsName.collections.name)
          .doc();

      await collectionRef.set(collection.toJson());
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code, e.message ?? 'An error occurred');
    } catch (e) {
      throw const UnknownException();
    }
  }

  @override
  Stream<List<TireCollectionDataModel>> getUserCollections(String userId) {
    return databaseDataSource
        .collection(CollectionsName.users.name)
        .doc(userId)
        .collection(CollectionsName.collections.name)
        .snapshots()
        .asyncMap((snapshot) async {
      List<TireCollectionDataModel> collections = [];
      for (var doc in snapshot.docs) {
        final data = TireCollectionDataModel.fromJson(doc.data());

        final inspectionsSnapshot = await doc.reference
            .collection(CollectionsName.inspections.name)
            .get();
        final inspectionsCount = inspectionsSnapshot.size;

        collections.add(TireCollectionDataModel(
          id: doc.id,
          collectionName: data.collectionName,
          createdAt: data.createdAt,
          inspectionsCount: inspectionsCount,
        ));
      }
      return collections;
    });
  }

  @override
  Future<void> deleteCollection(String userId, String collectionId) {
    return databaseDataSource
        .collection(CollectionsName.users.name)
        .doc(userId)
        .collection(CollectionsName.collections.name)
        .doc(collectionId)
        .delete();
  }
}

final tireCollectionDataSourceProvider = Provider(
  (ref) => _TireCollectionRemoteDataSource(FirebaseFirestore.instance),
);
