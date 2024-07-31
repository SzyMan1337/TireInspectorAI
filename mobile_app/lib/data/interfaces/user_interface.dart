import 'package:tireinspectorai_app/data/models/userinfo.dart';

abstract interface class UserRepository {
  Future<void> createUser(UserInfoDataModel user);
}
