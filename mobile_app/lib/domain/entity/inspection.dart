import 'package:flutter/material.dart';
import 'package:tireinspectorai_app/data/data.dart';

@immutable
class Inspection {
  const Inspection({
    required this.imageUrl,
    required this.isDefective,
    required this.modelUsed,
    required this.addedAt,
    this.additionalNotes,
  });

  final String imageUrl;
  final bool isDefective;
  final String modelUsed;
  final DateTime addedAt;
  final String? additionalNotes;

  String get image => imageUrl;
  bool get defective => isDefective;
  String get model => modelUsed;
  DateTime get dateAdded => addedAt;
  String? get notes => additionalNotes;

  InspectionDataModel toDataModel() {
    return InspectionDataModel(
      imageUrl: imageUrl,
      isDefective: isDefective,
      modelUsed: modelUsed,
      addedAt: addedAt,
      additionalNotes: additionalNotes,
    );
  }

  factory Inspection.fromDataModel(InspectionDataModel dataModel) {
    return Inspection(
      imageUrl: dataModel.imageUrl,
      isDefective: dataModel.isDefective,
      modelUsed: dataModel.modelUsed,
      addedAt: dataModel.addedAt,
      additionalNotes: dataModel.additionalNotes,
    );
  }
}
