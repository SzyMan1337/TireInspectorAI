import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

class SaveInspectionData {
  SaveInspectionData({
    required this.userId,
    required this.collectionId,
    required this.inspection,
  });

  final String userId;
  final String collectionId;
  final Inspection inspection;
}

final saveInspectionStateProvider =
    FutureProvider.autoDispose.family<String, SaveInspectionData>(
  (ref, saveData) async {
    final inspectionUseCase = ref.watch(inspectionUseCaseProvider);

    final inspectionId = await inspectionUseCase.addInspection(
      userId: saveData.userId,
      collectionId: saveData.collectionId,
      inspection: saveData.inspection,
    );

    return inspectionId;
  },
);

final uploadProgressProvider =
    StreamProvider.autoDispose.family<double, SaveInspectionData>(
  (ref, saveData) {
    final inspectionUseCase = ref.watch(inspectionUseCaseProvider);
    return inspectionUseCase.getUploadProgress(
      userId: saveData.userId,
      collectionId: saveData.collectionId,
      filePath: saveData.inspection.imageUrl,
    );
  },
);
