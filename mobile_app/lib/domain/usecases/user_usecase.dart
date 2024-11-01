import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/data.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

abstract interface class UserUseCase {
  Future<void> signOut();
  Stream<AppUser?> getCurrentUserInfo();
  Future<void> deleteAccount(String uid);
}

class _UserUseCase implements UserUseCase {
  const _UserUseCase(
    this._authRepository,
    this._userRepository,
    this._storageRepository,
  );

  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;

  @override
  Future<void> signOut() {
    return _authRepository.signOut();
  }

  @override
  Stream<AppUser?> getCurrentUserInfo() {
    final user = _authRepository.currentUser;

    return _userRepository.getExtraUserInfo(user.uid).map((userDataModel) {
      if (userDataModel == null) {
        return null;
      } else {
        return AppUser.fromUserInfoDataModel(userDataModel);
      }
    }).handleError((error) {
      throw Exception('Error fetching AppUser: $error');
    });
  }

  @override
  Future<void> deleteAccount(String uid) async {
    try {
      final imagePaths = await _storageRepository.getUserImagePaths(uid);
      for (final imagePath in imagePaths) {
        await _storageRepository.deleteFile(imagePath);
      }

      await _userRepository.deleteUserData(uid);
      await _authRepository.deleteAccount();
    } catch (error) {
      throw Exception('Error deleting account: $error');
    }
  }
}

final userUseCaseProvider = Provider<UserUseCase>(
  (ref) => _UserUseCase(
    ref.watch(authRepositoryProvider),
    ref.watch(userRepositoryProvider),
    ref.watch(storageRepositoryProvider),
  ),
);
