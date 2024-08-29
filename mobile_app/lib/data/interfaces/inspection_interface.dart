import 'package:tireinspectorai_app/data/models/inspection.dart';

abstract interface class InspectionRepository {
  Future<void> addInspection(
      String userId, String collectionId, InspectionDataModel inspection);
  Stream<List<InspectionDataModel>> getCollectionInspections(
      String userId, String collectionId);
  Future<void> deleteInspection(
      String userId, String collectionId, String inspectionId);
}
