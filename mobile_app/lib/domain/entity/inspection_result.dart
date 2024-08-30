import 'package:flutter/material.dart';

import 'inspection_model.dart';

@immutable
class InspectionResult {
  const InspectionResult({
    required this.imageUrl,
    required this.probabilityScore,
    required this.modelUsed,
    required this.evaluationDate,
  });

  final String imageUrl;
  final double probabilityScore;
  final InspectionModel modelUsed;
  final DateTime evaluationDate;

  bool get isDefective => probabilityScore >= 0.5;
}
