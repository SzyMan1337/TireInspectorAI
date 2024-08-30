import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/interfaces/model_evaluator.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

class CloudModelEvaluator implements ModelEvaluator {
  @override
  Future<InspectionResult> evaluateTireImage({required String imageUrl}) async {
    const probabilityScore = 0.7;

    return InspectionResult(
      imageUrl: imageUrl,
      probabilityScore: probabilityScore,
      modelUsed: InspectionModel.cloudModel,
      evaluationDate: DateTime.now(),
    );
  }
}

final cloudModelEvaluatorProvider = Provider<ModelEvaluator>(
  (ref) => CloudModelEvaluator(),
);
