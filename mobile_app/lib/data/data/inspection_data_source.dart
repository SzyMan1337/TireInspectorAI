import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/constants/collections.dart';
import 'package:tireinspectorai_app/data/interfaces/inspection_interface.dart';
import 'package:tireinspectorai_app/data/models/inspection.dart';
import 'package:tireinspectorai_app/exceptions/app_exceptions.dart';

class _InspectionRemoteDataSource implements InspectionRepository {
  const _InspectionRemoteDataSource(this.databaseDataSource);

  final FirebaseFirestore databaseDataSource;

  @override
  Future<void> addInspection(String userId, String collectionId,
      InspectionDataModel inspection) async {
    try {
      final inspectionRef = databaseDataSource
          .collection(CollectionsName.users.name)
          .doc(userId)
          .collection(CollectionsName.collections.name)
          .doc(collectionId)
          .collection(CollectionsName.inspections.name)
          .doc();

      // Set the document ID in the InspectionDataModel
      final inspectionWithId = inspection.copyWith(id: inspectionRef.id);

      await inspectionRef.set(inspectionWithId.toJson());
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code, e.message ?? 'An error occurred');
    } catch (e) {
      throw const UnknownException();
    }
  }

  @override
  Stream<List<InspectionDataModel>> getCollectionInspections(
      String userId, String collectionId) {
    return databaseDataSource
        .collection(CollectionsName.users.name)
        .doc(userId)
        .collection(CollectionsName.collections.name)
        .doc(collectionId)
        .collection(CollectionsName.inspections.name)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = InspectionDataModel.fromJson(doc.data());
              return data.copyWith(id: doc.id);
            }).toList());
  }

  @override
  Future<void> deleteInspection(
      String userId, String collectionId, String inspectionId) {
    return databaseDataSource
        .collection(CollectionsName.users.name)
        .doc(userId)
        .collection(CollectionsName.collections.name)
        .doc(collectionId)
        .collection(CollectionsName.inspections.name)
        .doc(inspectionId)
        .delete();
  }

  @override
  Future<InspectionDataModel> getInspectionById(
      String userId, String collectionId, String inspectionId) async {
    final doc = await databaseDataSource
        .collection(CollectionsName.users.name)
        .doc(userId)
        .collection(CollectionsName.collections.name)
        .doc(collectionId)
        .collection(CollectionsName.inspections.name)
        .doc(inspectionId)
        .get();

    if (doc.exists) {
      final data = InspectionDataModel.fromJson(doc.data()!);
      return data.copyWith(id: doc.id);
    } else {
      throw const InspectionNotFoundException();
    }
  }
}

final inspectionDataSourceProvider = Provider(
  (ref) => _InspectionRemoteDataSource(FirebaseFirestore.instance),
);
