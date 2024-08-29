import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/data/inspection_data_source.dart';
import 'package:tireinspectorai_app/data/interfaces/inspection_interface.dart';
import 'package:tireinspectorai_app/data/models/inspection.dart';

class _InspectionRepository implements InspectionRepository {
  const _InspectionRepository({
    required this.databaseDataSource,
  });

  final InspectionRepository databaseDataSource;

  @override
  Future<void> addInspection(
      String userId, String collectionId, InspectionDataModel inspection) {
    return databaseDataSource.addInspection(userId, collectionId, inspection);
  }

  @override
  Stream<List<InspectionDataModel>> getCollectionInspections(
      String userId, String collectionId) {
    return databaseDataSource.getCollectionInspections(userId, collectionId);
  }

  @override
  Future<void> deleteInspection(
      String userId, String collectionId, String inspectionId) {
    return databaseDataSource.deleteInspection(
        userId, collectionId, inspectionId);
  }
}

final inspectionRepositoryProvider = Provider<InspectionRepository>(
  (ref) => _InspectionRepository(
    databaseDataSource: ref.watch(inspectionDataSourceProvider),
  ),
);
