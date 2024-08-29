// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionDataModel _$InspectionDataModelFromJson(Map<String, dynamic> json) =>
    InspectionDataModel(
      imageUrl: json['imageUrl'] as String,
      isDefective: json['isDefective'] as bool,
      modelUsed: json['modelUsed'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
      additionalNotes: json['additionalNotes'] as String?,
    );

Map<String, dynamic> _$InspectionDataModelToJson(
        InspectionDataModel instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'isDefective': instance.isDefective,
      'modelUsed': instance.modelUsed,
      'addedAt': instance.addedAt.toIso8601String(),
      'additionalNotes': instance.additionalNotes,
    };
