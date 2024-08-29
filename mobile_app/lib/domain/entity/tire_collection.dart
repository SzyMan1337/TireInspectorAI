import 'package:flutter/material.dart';
import 'package:tireinspectorai_app/data/data.dart';

@immutable
class TireCollection {
  const TireCollection({
    this.id,
    required this.collectionName,
    required this.createdAt,
    this.inspectionsCount = 0,
  });

  final String? id;
  final String collectionName;
  final DateTime createdAt;
  final int inspectionsCount;

  String get name => collectionName;
  DateTime get creationDate => createdAt;

  TireCollectionDataModel toDataModel() {
    return TireCollectionDataModel(
      id: id ?? '',
      collectionName: collectionName,
      createdAt: createdAt,
    );
  }

  factory TireCollection.fromDataModel(TireCollectionDataModel dataModel) {
    return TireCollection(
      id: dataModel.id,
      collectionName: dataModel.collectionName,
      createdAt: dataModel.createdAt,
      inspectionsCount: dataModel.inspectionsCount,
    );
  }
}
