import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/interfaces/model_evaluator.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

class LocalModelEvaluator implements ModelEvaluator {
  @override
  Future<InspectionResult> evaluateTireImage({
    required String imageUrl,
  }) async {
    const probabilityScore = 0.3;

    return InspectionResult(
      imageUrl: imageUrl,
      probabilityScore: probabilityScore,
      modelUsed: InspectionModel.localModel,
      evaluationDate: DateTime.now(),
    );
  }
}

final localModelEvaluatorProvider = Provider<ModelEvaluator>(
  (ref) => LocalModelEvaluator(),
);
