import 'package:tireinspectorai_app/data/models/userinfo.dart';

abstract interface class UserRepository {
  Future<void> createUser(UserInfoDataModel user);
  Stream<UserInfoDataModel> getExtraUserInfo(String uid);
  Future<void> updateAvatarImage({
    required String uid,
    String? photoUrl,
  });
  Future<void> editUserProfile({
    required String uid,
    required String displayName,
  });
}
