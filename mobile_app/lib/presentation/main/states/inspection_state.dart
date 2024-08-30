import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

final selectedModelProvider = StateProvider<InspectionModel?>((ref) => null);

final uploadedImagePathProvider = StateProvider<String?>((ref) => null);

class RunInspectionData {
  RunInspectionData({
    required this.model,
    required this.imagePath,
  });

  final InspectionModel model;
  final String imagePath;
}

final runInspectionStateProvider =
    FutureProvider.autoDispose.family<void, RunInspectionData>(
  (ref, data) {
    return ref
        .watch(tireHealthEvaluationUseCaseProvider)
        .evaluateTireImage(model: data.model, imagePath: data.imagePath);
  },
);
