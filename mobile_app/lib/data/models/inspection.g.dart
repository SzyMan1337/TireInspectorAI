// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionDataModel _$InspectionDataModelFromJson(Map<String, dynamic> json) =>
    InspectionDataModel(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      probabilityScore: (json['probabilityScore'] as num).toDouble(),
      modelUsed: json['modelUsed'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
      additionalNotes: json['additionalNotes'] as String?,
    );

Map<String, dynamic> _$InspectionDataModelToJson(
        InspectionDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'probabilityScore': instance.probabilityScore,
      'modelUsed': instance.modelUsed,
      'addedAt': instance.addedAt.toIso8601String(),
      'additionalNotes': instance.additionalNotes,
    };
