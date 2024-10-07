import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/constants/collections.dart';
import 'package:tireinspectorai_app/data/models/tire_collection.dart';
import 'package:tireinspectorai_app/data/models/userinfo.dart';

import '../../exceptions/app_exceptions.dart';
import '../interfaces/user_interface.dart';

class _UserRemoteDataSource implements UserRepository {
  const _UserRemoteDataSource(
    this.databaseDataSource,
  );

  final FirebaseFirestore databaseDataSource;

  @override
  Future<void> createUser(UserInfoDataModel user) async {
    try {
      // Create user in the Firestore
      await databaseDataSource
          .collection(CollectionsName.users.name)
          .doc(user.uid)
          .set(
            user.toJson(),
            SetOptions(merge: true),
          );

      final collectionRef = databaseDataSource
          .collection(CollectionsName.users.name)
          .doc(user.uid)
          .collection(CollectionsName.collections.name)
          .doc();

      // Create a default TireCollectionDataModel with default values
      final defaultCollection = TireCollectionDataModel(
        id: collectionRef.id,
        collectionName: 'MyTires',
        createdAt: DateTime.now(),
      );

      // Save the default collection in the Firestore
      await collectionRef.set(defaultCollection.toJson());
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code, e.message ?? 'An error occurred');
    } catch (e) {
      throw const UnknownException();
    }
  }

  @override
  Stream<UserInfoDataModel?> getExtraUserInfo(String uid) {
    return databaseDataSource
        .collection(CollectionsName.users.name)
        .doc(uid)
        .snapshots()
        .map(
      (event) {
        if (event.exists && event.data() != null) {
          return UserInfoDataModel.fromJson(
            {
              ...event.data()!,
              'uid': event.id,
            },
          );
        } else {
          return null;
        }
      },
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

  @override
  Future<bool> userExists(String uid) async {
    try {
      final doc = await databaseDataSource
          .collection(CollectionsName.users.name)
          .doc(uid)
          .get();
      return doc.exists;
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code, e.message ?? 'An error occurred');
    } catch (e) {
      throw const UnknownException();
    }
  }
}

final userDataSourceProvider = Provider(
  (ref) => _UserRemoteDataSource(FirebaseFirestore.instance),
);
