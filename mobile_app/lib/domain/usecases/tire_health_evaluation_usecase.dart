import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/data.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

abstract interface class TireHealthEvaluationUseCase {
  /// Evaluates the tire image using the specified model.
  ///
  /// [imagePath]: Path to the tire image to be evaluated.
  /// [model]: The inspection model to use for evaluation (local or cloud).
  Future<InspectionResult> evaluateTireImage({
    required String imagePath,
    required InspectionModel model,
  });
}

class _TireHealthEvaluationUseCase implements TireHealthEvaluationUseCase {
  const _TireHealthEvaluationUseCase(
    this._localModelEvaluator,
    this._cloudModelEvaluator,
  );

  final ModelEvaluator _localModelEvaluator;
  final ModelEvaluator _cloudModelEvaluator;

  @override
  Future<InspectionResult> evaluateTireImage({
    required String imagePath,
    required InspectionModel model,
  }) {
    switch (model) {
      case InspectionModel.localModel:
        return _localModelEvaluator.evaluateTireImage(imageUrl: imagePath);
      case InspectionModel.cloudModel:
        return _cloudModelEvaluator.evaluateTireImage(imageUrl: imagePath);
      default:
        throw UnsupportedError('Unknown model: $model');
    }
  }
}

final tireHealthEvaluationUseCaseProvider =
    Provider<TireHealthEvaluationUseCase>(
  (ref) => _TireHealthEvaluationUseCase(
    ref.watch(localModelEvaluatorProvider),
    ref.watch(cloudModelEvaluatorProvider),
  ),
);
