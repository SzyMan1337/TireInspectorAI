// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tire_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TireCollectionDataModel _$TireCollectionDataModelFromJson(
        Map<String, dynamic> json) =>
    TireCollectionDataModel(
      id: json['id'] as String,
      collectionName: json['collectionName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TireCollectionDataModelToJson(
        TireCollectionDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collectionName': instance.collectionName,
      'createdAt': instance.createdAt.toIso8601String(),
    };
