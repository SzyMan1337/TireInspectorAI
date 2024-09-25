import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart'; // Import logger
import 'package:tireinspectorai_app/common/utils/logger_provider.dart';
import 'package:tireinspectorai_app/data/interfaces/model_evaluator.dart';
import 'package:tireinspectorai_app/domain/domain.dart';
import 'package:tireinspectorai_app/data/utils/image_processing_helper.dart';

class CloudModelEvaluator implements ModelEvaluator {
  final String functionUrl;
  final Logger logger;

  CloudModelEvaluator(this.logger, {required this.functionUrl});

  @override
  Future<InspectionResult> evaluateTireImage({required String imageUrl}) async {
    try {
      logger.i('Starting cloud model evaluation for image: $imageUrl');

      final List<double> inputData =
          await compute(ImageProcessingHelper.processImage, imageUrl);
      final probabilityScore = await _callCloudModel(inputData);

      logger.i(
          'Cloud model evaluation successful, probability score: $probabilityScore');

      // Return the result wrapped in an InspectionResult object
      return InspectionResult(
        imageUrl: imageUrl,
        probabilityScore: probabilityScore,
        modelUsed: InspectionModel.cloudModel,
        evaluationDate: DateTime.now(),
      );
    } catch (e) {
      logger.e('Error during cloud model evaluation: $e');
      throw Exception('Cloud model evaluation failed');
    }
  }

  Future<double> _callCloudModel(List<double> inputData) async {
    try {
      logger.i(
          'Calling cloud model with input data of length: ${inputData.length}');

      final response = await http.post(
        Uri.parse(functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'inputData': inputData}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        logger.i(
            'Cloud model returned a result successfully: ${result['result']}');
        return (result['result'][0][0] as num).toDouble();
      } else {
        logger
            .w('Failed to get result from cloud model: ${response.statusCode}');
        throw Exception(
            'Cloud model returned an error: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error calling cloud model: $e');
      throw Exception('Cloud model call failed');
    }
  }
}

final cloudModelEvaluatorProvider = Provider<ModelEvaluator>((ref) {
  final logger = ref.read(loggerProvider);
  final String functionUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:8080/predict';
  return CloudModelEvaluator(logger, functionUrl: functionUrl);
});
 