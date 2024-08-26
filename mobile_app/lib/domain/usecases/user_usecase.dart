import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/data.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

abstract interface class UserUseCase {
  Future<void> signOut();
  Stream<AppUser> getCurrentUserInfo();
}

class _UserUseCase implements UserUseCase {
  const _UserUseCase(
    this._authRepository,
    this._userRepository,
  );

  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  @override
  Future<void> signOut() {
    return _authRepository.signOut();
  }

  @override
  Stream<AppUser> getCurrentUserInfo() {
    final user = _authRepository.currentUser;
    return _userRepository
        .getExtraUserInfo(
          user.uid,
        )
        .map(
          (userDataModel) => AppUser.fromUserInfoDataModel(userDataModel),
        );
  }
}

// 3- Create a provider
final userUseCaseProvider = Provider<UserUseCase>(
  (ref) => _UserUseCase(
    ref.watch(authRepositoryProvider),
    ref.watch(userRepositoryProvider),
  ),
);
