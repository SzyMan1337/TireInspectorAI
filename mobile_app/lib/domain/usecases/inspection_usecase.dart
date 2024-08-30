import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/data.dart';
import 'package:tireinspectorai_app/domain/entity/inspection.dart';

abstract interface class InspectionUseCase {
  Future<void> addInspection({
    required String userId,
    required String collectionId,
    required Inspection inspection,
  });

  Stream<List<Inspection>> getCollectionInspections({
    required String userId,
    required String collectionId,
  });

  Future<void> deleteInspection({
    required String userId,
    required String collectionId,
    required String inspectionId,
  });

  Future<Inspection?> getInspectionById({
    required String userId,
    required String collectionId,
    required String inspectionId,
  });
}

class _InspectionUseCase implements InspectionUseCase {
  const _InspectionUseCase(this._inspectionRepository);

  final InspectionRepository _inspectionRepository;

  @override
  Future<void> addInspection({
    required String userId,
    required String collectionId,
    required Inspection inspection,
  }) {
    return _inspectionRepository.addInspection(
      userId,
      collectionId,
      inspection.toDataModel(),
    );
  }

  @override
  Stream<List<Inspection>> getCollectionInspections({
    required String userId,
    required String collectionId,
  }) {
    return _inspectionRepository
        .getCollectionInspections(userId, collectionId)
        .map(
          (inspectionDataModels) => inspectionDataModels
              .map((dataModel) => Inspection.fromDataModel(dataModel))
              .toList(),
        );
  }

  @override
  Future<void> deleteInspection({
    required String userId,
    required String collectionId,
    required String inspectionId,
  }) {
    return _inspectionRepository.deleteInspection(
        userId, collectionId, inspectionId);
  }

  @override
  Future<Inspection?> getInspectionById({
    required String userId,
    required String collectionId,
    required String inspectionId,
  }) async {
    final dataModel = await _inspectionRepository.getInspectionById(
        userId, collectionId, inspectionId);
    return Inspection.fromDataModel(dataModel);
  }
}

final inspectionUseCaseProvider = Provider<InspectionUseCase>(
  (ref) => _InspectionUseCase(
    ref.watch(inspectionRepositoryProvider),
  ),
);
