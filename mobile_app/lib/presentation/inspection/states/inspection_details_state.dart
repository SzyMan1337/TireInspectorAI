import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

// Provider to fetch a specific inspection by ID
final inspectionProvider =
    FutureProvider.autoDispose.family<Inspection, InspectionParams>(
  (ref, params) async {
    return ref.watch(inspectionUseCaseProvider).getInspectionById(
          userId: params.userId,
          collectionId: params.collectionId,
          inspectionId: params.inspectionId,
        );
  },
);

class InspectionParams {
  final String userId;
  final String collectionId;
  final String inspectionId;

  InspectionParams({
    required this.userId,
    required this.collectionId,
    required this.inspectionId,
  });
}

class DeleteInspectionData {
  DeleteInspectionData({
    required this.userId,
    required this.collectionId,
    required this.inspectionId,
  });

  final String userId;
  final String collectionId;
  final String inspectionId;
}

final deleteInspectionStateProvider =
    FutureProvider.autoDispose.family<void, DeleteInspectionData>(
  (ref, data) async {
    await ref.watch(inspectionUseCaseProvider).deleteInspection(
          userId: data.userId,
          collectionId: data.collectionId,
          inspectionId: data.inspectionId,
        );
  },
);
