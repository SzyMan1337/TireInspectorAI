import 'package:flutter/material.dart';
import 'package:tireinspectorai_app/data/data.dart';

@immutable
class AppUser extends UserInfoDataModel {
  const AppUser({
    required super.uid,
    required super.email,
    super.displayName,
    super.photoUrl,
  });

  String get id => uid;
  String get avatar => photoUrl ?? 'https://via.placeholder.com/150';

  toUserInfoDataModel() {
    return UserInfoDataModel(
      photoUrl: photoUrl,
      displayName: displayName,
      uid: uid,
      email: email,
    );
  }

  factory AppUser.fromUserInfoDataModel(UserInfoDataModel userInfo) {
    return AppUser(
      uid: userInfo.uid,
      email: userInfo.email,
      displayName: userInfo.displayName,
      photoUrl: userInfo.photoUrl,
    );
  }

  factory AppUser.fromCurrentUserDataModel(CurrentUserDataModel userInfo) {
    return AppUser(
      uid: userInfo.uid,
      email: userInfo.email!,
      displayName: userInfo.displayName,
    );
  }
}
