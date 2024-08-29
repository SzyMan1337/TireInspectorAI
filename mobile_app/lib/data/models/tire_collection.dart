import 'package:json_annotation/json_annotation.dart';

part 'tire_collection.g.dart';

@JsonSerializable()
class TireCollectionDataModel {
  const TireCollectionDataModel({
    required this.id,
    required this.collectionName,
    required this.createdAt,
    this.inspectionsCount =
        0,
  });

  final String id;
  final String collectionName;
  final DateTime createdAt;

  @JsonKey(
      includeFromJson: false,
      includeToJson: false)
  final int inspectionsCount;

  factory TireCollectionDataModel.fromJson(Map<String, dynamic> json) =>
      _$TireCollectionDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$TireCollectionDataModelToJson(this);
}
