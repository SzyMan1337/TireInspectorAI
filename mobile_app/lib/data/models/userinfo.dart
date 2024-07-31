import 'package:json_annotation/json_annotation.dart';

part 'userinfo.g.dart';

@JsonSerializable()
class UserInfoDataModel {
  const UserInfoDataModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  final String uid;
  final String? displayName;
  final String email;
  final String? photoUrl;

  factory UserInfoDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoDataModelToJson(this);
}
