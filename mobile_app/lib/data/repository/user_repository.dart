import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/models/userinfo.dart';

import '../data/user_data_source.dart';
import '../interfaces/user_interface.dart';

class _UserRepository implements UserRepository {
  const _UserRepository({
    required this.databaseDataSource,
  });

  final UserRepository databaseDataSource;

  @override
  Stream<UserInfoDataModel> getExtraUserInfo(String uid) {
    return databaseDataSource.getExtraUserInfo(uid);
  }

  @override
  Future<void> createUser(UserInfoDataModel user) {
    return databaseDataSource.createUser(user);
  }

  @override
  Future<void> updateAvatarImage({required String uid, String? photoUrl}) {
    return databaseDataSource.updateAvatarImage(uid: uid, photoUrl: photoUrl);
  }

  @override
  Future<void> editUserProfile({
    required String uid,
    required String displayName,
  }) {
    return databaseDataSource.editUserProfile(
      uid: uid,
      displayName: displayName,
    );
  }

  @override
  Future<bool> userExists(String uid) {
    return databaseDataSource.userExists(uid);
  }
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => _UserRepository(
    databaseDataSource: ref.watch(userDataSourceProvider),
  ),
);
