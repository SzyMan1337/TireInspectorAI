import 'dart:io';

import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tireinspectorai_app/data/interfaces/model_evaluator.dart';
import 'package:tireinspectorai_app/data/utils/image_processing_helper.dart';
import 'package:tireinspectorai_app/domain/domain.dart';
import 'package:tireinspectorai_app/common/utils/model_service.dart';

class LocalModelEvaluator implements ModelEvaluator {
  final ModelService modelService;
  Interpreter? _interpreter;

  LocalModelEvaluator(this.modelService);

  Future<void> _initializeInterpreter() async {
    if (_interpreter == null) {
      FirebaseCustomModel model = await modelService.getModel();
      final modelPath = model.file.path;
      _interpreter = Interpreter.fromFile(File(modelPath));
      _interpreter!.allocateTensors();
    }
  }

  @override
  Future<InspectionResult> evaluateTireImage({
    required String imageUrl,
  }) async {
    try {
      await _initializeInterpreter();

      // Use compute to process the image off the main thread using ImageProcessingHelper
      final input = await compute(ImageProcessingHelper.processImage, imageUrl);
      var outputDetails = _interpreter!.getOutputTensor(0);

      var reshapedInput = List<List<List<List<double>>>>.generate(
          1,
          (_) => List<List<List<double>>>.generate(
              224,
              (i) => List<List<double>>.generate(
                  224,
                  (j) => List<double>.generate(
                      3, (k) => input[i * 224 * 3 + j * 3 + k]))));

      final output =
          List.filled(outputDetails.shape.reduce((a, b) => a * b), 0.0)
              .reshape(outputDetails.shape);

      // Run inference
      _interpreter!.run(reshapedInput, output);
      final probabilityScore = output[0][0] as double;

      return InspectionResult(
        imageUrl: imageUrl,
        probabilityScore: probabilityScore,
        modelUsed: InspectionModel.localModel,
        evaluationDate: DateTime.now(),
      );
    } catch (e) {
      // Handle any errors during inference or processing
      rethrow;
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}

final localModelEvaluatorProvider = Provider<ModelEvaluator>(
  (ref) {
    final modelService = ref.read(modelServiceProvider);
    return LocalModelEvaluator(modelService);
  },
);
