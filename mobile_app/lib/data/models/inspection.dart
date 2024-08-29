import 'package:json_annotation/json_annotation.dart';

part 'inspection.g.dart';

@JsonSerializable()
class InspectionDataModel {
  const InspectionDataModel({
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

  factory InspectionDataModel.fromJson(Map<String, dynamic> json) =>
      _$InspectionDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$InspectionDataModelToJson(this);
}
