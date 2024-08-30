import 'package:tireinspectorai_app/domain/domain.dart';

abstract class ModelEvaluator {
  Future<InspectionResult> evaluateTireImage({required String imageUrl});
}
