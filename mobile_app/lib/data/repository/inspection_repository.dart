import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/data/inspection_data_source.dart';
import 'package:tireinspectorai_app/data/interfaces/inspection_interface.dart';
import 'package:tireinspectorai_app/data/models/inspection.dart';

class _InspectionRepository implements InspectionRepository {
  const _InspectionRepository({
    required this.dataSource,
  });

  final InspectionRepository dataSource;

  @override
  Future<String> addInspection(
      String userId, String collectionId, InspectionDataModel inspection) {
    return dataSource.addInspection(userId, collectionId, inspection);
  }

  @override
  Stream<List<InspectionDataModel>> getCollectionInspections(
      String userId, String collectionId) {
    return dataSource.getCollectionInspections(userId, collectionId);
  }

  @override
  Future<void> deleteInspection(
      String userId, String collectionId, String inspectionId) {
    return dataSource.deleteInspection(userId, collectionId, inspectionId);
  }

  @override
  Future<InspectionDataModel> getInspectionById(
      String userId, String collectionId, String inspectionId) {
    return dataSource.getInspectionById(userId, collectionId, inspectionId);
  }
}

final inspectionRepositoryProvider = Provider<InspectionRepository>(
  (ref) => _InspectionRepository(
    dataSource: ref.watch(inspectionDataSourceProvider),
  ),
);
