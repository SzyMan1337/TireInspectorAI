import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/data.dart';
import 'package:tireinspectorai_app/domain/entity/inspection.dart';
import 'package:tireinspectorai_app/domain/logics/helpers.dart';

abstract interface class InspectionUseCase {
  Future<String> addInspection({
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

  Future<Inspection> getInspectionById({
    required String userId,
    required String collectionId,
    required String inspectionId,
  });

  Stream<double> getUploadProgress({
    required String userId,
    required String collectionId,
    required String filePath,
  });
}

class _InspectionUseCase implements InspectionUseCase {
  const _InspectionUseCase(
    this._inspectionRepository,
    this._storageRepository,
  );

  final InspectionRepository _inspectionRepository;
  final StorageRepository _storageRepository;

  @override
  Future<String> addInspection({
    required String userId,
    required String collectionId,
    required Inspection inspection,
  }) async {
    final file = File(inspection.imageUrl);
    final storagePath =
        Helpers.getInspectionImagePath(userId, collectionId, file);

    final imageUrl = await _storageRepository.uploadFile(storagePath, file);
    final newInspection = inspection.copyWith(imageUrl: imageUrl);
    final inspectionId = await _inspectionRepository.addInspection(
      userId,
      collectionId,
      newInspection.toDataModel(),
    );

    return inspectionId;
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
  Future<Inspection> getInspectionById({
    required String userId,
    required String collectionId,
    required String inspectionId,
  }) async {
    final dataModel = await _inspectionRepository.getInspectionById(
        userId, collectionId, inspectionId);
    return Inspection.fromDataModel(dataModel);
  }

  @override
  Stream<double> getUploadProgress({
    required String userId,
    required String collectionId,
    required String filePath,
  }) {
    final file = File(filePath);
    final storagePath =
        Helpers.getInspectionImagePath(userId, collectionId, file);
    return _storageRepository.uploadProgress(storagePath);
  }
}

final inspectionUseCaseProvider = Provider<InspectionUseCase>(
  (ref) => _InspectionUseCase(
    ref.watch(inspectionRepositoryProvider),
    ref.watch(storageRepositoryProvider),
  ),
);
