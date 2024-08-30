import 'package:json_annotation/json_annotation.dart';

part 'inspection.g.dart';

@JsonSerializable()
class InspectionDataModel {
  const InspectionDataModel({
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

  factory InspectionDataModel.fromJson(Map<String, dynamic> json) =>
      _$InspectionDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$InspectionDataModelToJson(this);

  InspectionDataModel copyWith({
    String? id,
    String? imageUrl,
    double? probabilityScore,
    String? modelUsed,
    DateTime? addedAt,
    String? additionalNotes,
  }) {
    return InspectionDataModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      probabilityScore: probabilityScore ?? this.probabilityScore,
      modelUsed: modelUsed ?? this.modelUsed,
      addedAt: addedAt ?? this.addedAt,
      additionalNotes: additionalNotes ?? this.additionalNotes,
    );
  }
}
