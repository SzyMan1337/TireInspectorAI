import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/data.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

abstract interface class EditProfileUseCase {
  Future<void> editProfile({
    required String uid,
    required String displayName,
  });
  Future<void> updateProfileImage({
    required String uid,
    required String filePath,
  });
  Stream<double> getUploadProgress({
    required String uid,
    required String filePath,
  });
  Future<void> deleteProfileImage({
    required String uid,
    required String imageUrl,
  });
}

class _EditProfileUseCase implements EditProfileUseCase {
  const _EditProfileUseCase(
    this._userRepository,
    this._storageRepository,
  );

  final UserRepository _userRepository;
  final StorageRepository _storageRepository;

  @override
  Future<void> editProfile({
    required String uid,
    required String displayName,
  }) {
    return _userRepository.editUserProfile(
      uid: uid,
      displayName: displayName,
    );
  }

  @override
  Future<void> updateProfileImage({
    required String uid,
    required String filePath,
  }) async {
    final file = File(filePath);
    final storagePath = Helpers.getStoragePath(uid, file);

    final uploadFuture = _storageRepository.uploadFile(storagePath, file);

    final downloadUrl = await uploadFuture;

    await _userRepository.updateAvatarImage(
      uid: uid,
      photoUrl: downloadUrl, // todo: replace with thumbnail _200x200
    );
  }

  @override
  Stream<double> getUploadProgress({
    required String uid,
    required String filePath,
  }) {
    final file = File(filePath);
    final storagePath = Helpers.getStoragePath(uid, file);
    return _storageRepository.uploadProgress(storagePath);
  }

  @override
  Future<void> deleteProfileImage({
    required String uid,
    required String imageUrl,
  }) async {
    await _storageRepository.deleteByUrl(imageUrl);
    await _userRepository.updateAvatarImage(uid: uid, photoUrl: null);
  }
}

final editProfileUseCaseProvider = Provider<EditProfileUseCase>(
  (ref) => _EditProfileUseCase(
    ref.watch(userRepositoryProvider),
    ref.watch(storageRepositoryProvider),
  ),
);
