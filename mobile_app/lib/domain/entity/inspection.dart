import 'package:flutter/material.dart';
import 'package:tireinspectorai_app/data/data.dart';

@immutable
class Inspection {
  const Inspection({
    required this.id,
    required this.imageUrl,
    required this.probabilityScore,
    required this.modelUsed,
    required this.addedAt,
    this.additionalNotes,
  });

  final String id;
  final String imageUrl;
  final double probabilityScore;
  final String modelUsed;
  final DateTime addedAt;
  final String? additionalNotes;

  String get image => imageUrl;
  bool get isDefective =>
      probabilityScore >= 0.5;
  String get model => modelUsed;
  DateTime get dateAdded => addedAt;
  String? get notes => additionalNotes;

  InspectionDataModel toDataModel() {
    return InspectionDataModel(
      id: id,
      imageUrl: imageUrl,
      probabilityScore: probabilityScore,
      modelUsed: modelUsed,
      addedAt: addedAt,
      additionalNotes: additionalNotes,
    );
  }

  factory Inspection.fromDataModel(InspectionDataModel dataModel) {
    return Inspection(
      id: dataModel.id,
      imageUrl: dataModel.imageUrl,
      probabilityScore: dataModel.probabilityScore,
      modelUsed: dataModel.modelUsed,
      addedAt: dataModel.addedAt,
      additionalNotes: dataModel.additionalNotes,
    );
  }
}
