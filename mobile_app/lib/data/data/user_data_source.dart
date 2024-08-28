import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/constants/collections.dart';
import 'package:tireinspectorai_app/data/models/userinfo.dart';

import '../../exceptions/app_exceptions.dart';
import '../interfaces/user_interface.dart';

class _UserRemoteDataSource implements UserRepository {
  const _UserRemoteDataSource(
    this.databaseDataSource,
  );

  final FirebaseFirestore databaseDataSource;

  @override
  Future<void> createUser(UserInfoDataModel user) {
    try {
      return databaseDataSource
          .collection(CollectionsName.users.name)
          .doc(user.uid)
          .set(
            user.toJson(),
            SetOptions(merge: true),
          );
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code, e.message ?? 'An error occurred');
    } catch (e) {
      throw const UnknownException();
    }
  }

  @override
  Stream<UserInfoDataModel> getExtraUserInfo(String uid) {
    return databaseDataSource
        .collection(CollectionsName.users.name)
        .doc(uid)
        .snapshots()
        .map(
          (event) => UserInfoDataModel.fromJson(
            {
              ...event.data()!,
              'uid': event.id,
            },
          ),
        );
  }

  @override
  Future<void> updateAvatarImage({required String uid, String? photoUrl}) {
    return databaseDataSource
        .collection(CollectionsName.users.name)
        .doc(uid)
        .update(
      {
        'photoUrl': photoUrl,
      },
    );
  }

  @override
  Future<void> editUserProfile(
      {required String uid, required String displayName}) {
    return databaseDataSource
        .collection(CollectionsName.users.name)
        .doc(uid)
        .update(
      {
        'displayName': displayName,
      },
    );
  }
}

final userDataSourceProvider = Provider(
  (ref) => _UserRemoteDataSource(FirebaseFirestore.instance),
);
