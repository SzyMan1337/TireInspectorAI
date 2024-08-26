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
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => _UserRepository(
    databaseDataSource: ref.watch(userDataSourceProvider),
  ),
);
